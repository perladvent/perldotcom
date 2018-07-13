
  {
    "title"  : "Mock APIs for free using JSON Schemas",
    "authors": ["david-farrell"],
    "date"   : "2017-09-20T06:57:21",
    "tags"   : ["json-schema", "swagger", "openapi", "mock"],
    "draft"  : false,
    "image"  : "",
    "description" : "Starring JSON::Schema::ToJSON",
    "categories": "data"
  }

[JSON::Schema::ToJSON]({{<mcpan "JSON::Schema::ToJSON" >}}) is a module which takes a [JSON schema](http://json-schema.org/), and generates a data structure compliant with the schema. Here's a quick script to generate a data structure based on a schema:

```perl
#!/usr/bin/perl
# gen-json - create json from a schema filepath
use Data::Dumper;
use JSON::Schema::ToJSON;

my $generator = JSON::Schema::ToJSON->new();
my $schema    = do { local($/);<> }; # slurp the filepath in @ARGV
my $data      = $generator->json_schema_to_json(schema_str => $schema);

print Dumper($data);
```

To run it, I need to pass the filepath to a JSON schema, in this case `user.json` describes a web app user:

    $ ./gen-json user.json
    $VAR1 = {
          'email_address' => 'HfeiJzddxVTg@AspFqfgUKivV.com',
          'birthdate' => '2014-01-14T00:59:43.000Z',
          'active' => bless( do{\(my $o = 0)}, 'JSON::PP::Boolean' ),
          'cell_phone_number' => '043 185 8956',
          'roles' => [
                       'manager',
                       'trainer',
                       'admin'
                     ],
          'display_name' => 'Pswgfkjzdc',
          'password' => 'QI0RQDR9A7W2EtuNHaQKvBFQp67oO0Ld',
          'login' => '7oRSCeREi9sWm',
          'full_name' => 'Oiqmqdr Frfxrzkzfjn',
        };

The script creates a new `JSON::Schema::ToJSON` object called `$generator`, slurps the JSON schema into `$schema`, and generates the data structure assigning it to `$data`. Then `$data` is pretty-printed to STDOUT via `Data::Dumper`. Notice how the data printed to the terminal is compliant but *not* realistic.

### Mocking APIs

It's popular to describe API endpoints with JSON schemas for [Swagger](https://swagger.io/). Swagger will generate documentation using the schemas, and even provides a request/response testing tool. We can make the JSON schemas even more useful by using them to mock API endpoints. Imagine you've defined an API but haven't built it yet: you can create the API endpoint and return data mocked with `JSON::Schema::ToJSON` so that frontend development can begin without waiting for the backend to be ready.

Let's say we've got the following Swagger doc (a JSON schema) which defines a single API route `/user`:

```
{
  "swagger": "2.0",
  "schemes": [
    "https"
  ],
  "produces": [
    "application/json"
  ],
  "paths": {
    "/user": {
      "get": {
        "summary": "returns a user for a given id",
        "parameters": [
          {
            "name": "id",
            "in": "path",
            "type": "string"
          }
        ],
        "responses": {
          "200": {
            "description": "Objects matching the search term",
            "schema": {
              "type": "object",
              "properties": {
                "login": {
                  "type": "string",
                  "pattern": "[0-9A-Za-z]{5,32}"
                },
                "full_name": {
                  "type": "string",
                  "pattern": "[A-Z][a-z]{3,10} [A-Z][a-z]{3,20}"
                },
                "display_name": {
                  "type": "string",
                  "pattern": "[A-Z][a-z]{3,10}"
                },
                "birthdate": {
                  "type": "string",
                  "format": "date-time"
                },
                "email_address": {
                  "type": "string",
                  "format": "email"
                },
                "cell_phone_number": {
                  "type": "string",
                  "pattern": "\\d{3} \\d{3} \\d{4}"
                },
                "password": {
                  "type": "string",
                  "pattern": "[0-9A-Za-z]{8,32}"
                },
                "roles": {
                  "type": "array",
                  "minItems": 1,
                  "maxItems": 4,
                  "uniqueItems": true,
                  "items": {
                    "type": "string",
                    "enum": [ "admin", "manager", "trainer", "member" ]
                  }
                },
                "active": {
                  "type": "boolean"
                }
              }
            }
          }
        }
      }
    }
  }
}

```

Here's a [Mojolicious::Lite app](http://mojolicious.org/perldoc/Mojolicious/Lite) to serve the mocked route:

```perl
use Mojolicious::Lite;
use JSON::XS 'decode_json';
use JSON::Schema::ToJSON;

my $generator  = JSON::Schema::ToJSON->new();
my $json       = do { open my $fh, '<', 'swaggerdoc.json'; local($/);<$fh> };
my $swaggerdoc = decode_json($json);

get '/user' => sub {
  my $self = shift;
  my $route_def = $swaggerdoc->{paths}{'/user'}{get}{responses}{200}{schema};
  my $response = $generator->json_schema_to_json(schema => $route_def);
  $self->render(json => $response);
};

app->start;
```

This app slurps and decodes the swagger doc on startup, saving the result to `$swaggerdoc` and declares a `/user` route which extracts the API definition from the `$swaggerdoc`, and uses `JSON::Schema::ToJSON` to generate a response, and renders it. Let's test the app:

```
$ hypnotoad user-app.pl
[Wed Sep 20 14:19:49 2017] [info] Listening at "http://*:8080"
Server available at http://127.0.0.1:8080

$ curl localhost:8080/user
{"active":false,"birthdate":"2009-08-30T17:47:32.000Z","cell_phone_number":"254 403 0133","display_name":"Nyzhoyp","email_address":"gEyRQXRPrlzL@CvuRitFtArXv.com","full_name":"Wmpgrd Bnaazxguekqtuezlu","login":"oAxgIvYQfbRmWHq4WifclhQxAI","password":"99wciSr8V","roles":["member","trainer","manager"]}

$ hypnotoad -s user-app.pl
Stopping Hypnotoad server 2177 gracefully.
```

First I launch the app into the background with `hypnotoad`. Next I use `curl` to test the endpoint, and it correctly returns the user JSON. Finally I stop the app via `hypnotoad` again. Looking good!

### Limitations

I've run into a couple of limitations when using `JSON::Schema::ToJSON`. One I already mentioned: it generates compliant but not realistic data. This can cause an issue if you have interdependencies in your object properties, like `first_name` should be a substring of `full_name`. Or when generating dates, sometimes a random datetime is not precise enough: for realistic dates of birth you might want someone born between 10 and 80 years ago. This issue can be mitigated somewhat by clever use of regex definitions in the JSON schema, or by using the `example_key` feature of `JSON::Schema::ToJSON`.

Another issue is caused by limitations in JSON schema itself: you might not be able to generate the data in the format your API returns, for example there is no date [format](http://json-schema.org/latest/json-schema-validation.html#rfc.section.8.3), only datetimes.

But these are minor limitations, and I remain convinced that [JSON::Schema::ToJSON]({{<mcpan "JSON::Schema::ToJSON" >}}) is great way to augment the value of JSON schemas, by rapidly generating test data and/or mocking APIs.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
