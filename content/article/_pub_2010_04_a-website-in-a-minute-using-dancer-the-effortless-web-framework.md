{
   "title" : "A Website in a Minute Using Dancer, the Effortless Web Framework",
   "categories" : "web",
   "thumbnail" : null,
   "description" : "While Perl has a few heavy hitters in the web framework world (Catalyst, Jifty, CGI::App), sometimes they can seem like overkill. When writing a light web service or a high-end but not-as-complex website, you might want something smaller and simpler....",
   "authors" : [
      "perldotcom"
   ],
   "image" : null,
   "draft" : null,
   "tags" : [
      "cpan",
      "dancer",
      "perl",
      "perl-5",
      "perl-programming",
      "web-development"
   ],
   "date" : "2010-04-06T06:00:01-08:00",
   "slug" : "/pub/2010/04/a-website-in-a-minute-using-dancer-the-effortless-web-framework"
}





While Perl has a few heavy hitters in the web framework world
([Catalyst](http://search.cpan.org/perldoc?Catalyst),
[Jifty](http://search.cpan.org/perldoc?Jifty),
[CGI::App](http://search.cpan.org/perldoc?CGI%3A%3AApplication)),
sometimes they can seem like overkill. When writing a light web service
or a high-end but not-as-complex website, you might want something
smaller and simpler. This is where [Dancer](http://www.perldancer.org/)
comes in.

[Dancer](http://search.cpan.org/perldoc?Dancer) is a web framework whose
purpose is to let you get a website up and running within a minute, if
not sooner. It started as a port of Ruby's
[Sinatra](http://www.sinatrarb.com/) but has since took its own path.

Dancer supports
[Plack](http://plackperl.org/)/[PSGI](http://plackperl.org/) from an
early version and has a built-in scaffolding script to help you get up
and running within seconds. It creates deployment scripts for you,
includes a guide for deployment situations to help you configure your
webserver (whether [Perlbal](http://www.danga.com/perlbal),
[Apache](http://httpd.apache.org/), [Lighttpd](http://www.lighttpd.net/)
or anything else you might care to use) and has a default clean design
to help you prototype your website faster.

**Dancing**
-----------

The best way to learn, understand, and fall in love with Dancer is to
get on the dance floor:

        $ cpan Dancer # or cpanp, or cpanm
        $ dancer -a MyApp
        + ./MyApp
        + MyApp/views
        + MyApp/views/index.tt
        + MyApp/views/layouts
        + MyApp/views/layouts/main.tt
        + MyApp/environments
        + MyApp/environments/development.yml
        + MyApp/environments/production.yml
        + MyApp/config.yml
        + MyApp/app.psgi
        + MyApp/MyApp.pm
        + MyApp/MyApp.pl
        + MyApp/public
        + MyApp/public/css
        + MyApp/public/css/style.css
        + MyApp/public/css/error.css
        + MyApp/public/images
        + MyApp/public/404.html
        + MyApp/public/dispatch.fcgi
        + MyApp/public/dispatch.cgi
        + MyApp/public/500.html

The `dancer` application creates a *views* folder, which contains layout
and templates. It contains sane defaults you can use to start. It also
creates a *config.yaml* file and an *environments* folder for
environment-specific configurations. *MyApp.pm* and *MyApp.pl* are the
main application files. *MyApp.pl* includes a built-in webserver for the
development (or even deployment!) of your application. The *public*
folder contains default CSS and images.

This directory tree includes a few other interesting files; these are
dispatchers for various backends. The PSGI dispatcher is *app.psgi*. The
CGI and FCGI dispatchers are *public/dispatch.cgi* and
*public/dispatch.fcgi*, respectively.

Look in *MyApp/MyApp.pm*. Dancing really is this simple!

        package MyApp;
        use Dancer;

        get '/' => sub {
            template 'index';
        };

        true;

What does this all mean?

**Routes**
----------

Dancer uses the notion of *routes* to specify the paths your users might
take in your website. All you need in order to write a Dancer
application is to define routes. Routes are not only simple, but concise
and versatile. They support variables (named matching, wildcard
matching), regular expressions and even conditional matching.

Here are a few examples:

        get '/' => sub {
            return 'hello world!';
        };

This route defines the root path of the application. If someone reaches
<http://example.com/>, it will match this route.

The word `get` signifies the HTTP method (GET) for which the path
exists. If you use a web form, you need a route for a POST method:

        post '/user/add/' => sub {
            # create a user using the data from the form
        };

There are a few more methods (**del** for *DELETE*, **put** for *PUT*).
You can also use `any` to provide a single route for all HTTP methods or
for several specific methods:

        any ['get', 'post'] => sub {
            # both post and get will reach here!
        };

Variables are clean and simple:

        get '/user/view/:username/' => sub {
            my $username = params->{username};
            template 'users' => { username => $username };
        };

This route matches <http://example.com/user/view/variable/>, while
*variable* can be of any type.

Of course, you can write a more complex wildcard matching:

        get '/download/*.*' => sub {
            # we extract the wild card matching using splat
            my ( $file, $ext ) = splat;
        };

If you feel rambunctious, you can define a regular expression:

        get r( '/hello/([\w]+)' ) => sub {
            my ($name) = splat;
        };

Note that in these examples, the `splat` keyword returns the values that
the wildcards (the `*` used in routes) or regular expressions (declared
with `r()`) match. As a convenience, note also that you do *not* have to
escape the forward slash regex delimiters used in `r()`; Dancer escapes
them for you.

**Multiple Routes**
-------------------

When writing many routes, you might find it easier to separate them to
different files according to their prefixes. Dancer provides `prefix`
and `load` to help you with that.

        # in main Dancer application:
        load 'UserRoutes.pm';

        # in UserRoutes.pm:
        use Dancer ':syntax'; # importing just the syntax to create routes
        prefix '/user';

        get '/view/'   => sub { ... };
        get '/edit/'   => sub { ... };
        get '/delete/' => sub { ... };

These will match <http://example.com/user/view/>,
<http://example.com/user/edit/> and <http://example.com/user/delete/>,
respectively.

**Built for scalability**
-------------------------

Dancer has a built-in route caching mechanism, making sure that even
when you have a lot of routes, it will be able to serve them at almost
the same speed as though you had only a few routes. This means that even
if you have 600 routes, you do not have to worry about your application
being slow!

**Variables**
-------------

Dancer supports internal variables. Declare them with `var`, and you can
later fetch them inside your routes:

        var waiter => 'sawyer';

        get '/welcome/' => sub {
            my $name = vars->{waiter};
            return "Hi, I'm $name and I'll be your waiter this evening.";
        };

**Filters**
-----------

Sometimes you want to be able to specify code to run before any route.
[KiokuDB](http://search.cpan.org/perldoc?KiokuDB), for example, requires
you to make a scope whenever you want to work with the database. This is
easy to automate with the `before` filter:

        before sub {
            var scope => $dir->new_scope;
        };

Another common technique is to verify a session:

        before sub {
            if ( !session('user') && request->path_info !~ m{^/login} ) {
                # Pass the original path requested along to the handler:
                var requested_path => request->path_info;
                request->path_info('/login');
            }
        };

**Templates**
-------------

Dancer will return to the user agent whatever you return from a route,
just like PSGI does. "Hello, world!" in Dancer is:

        get '/' => sub { 'Hello, world!' };

Plain text isn't always what you want, so Dancer has powerful support
for templates. There are various template engines available
([Template::Toolkit](http://search.cpan.org/perldoc?Template),
[Template::Tiny](http://search.cpan.org/perldoc?Template%3A%3ATiny),
[Tenjin](http://search.cpan.org/perldoc?Tenjin),
[Text::Haml](http://search.cpan.org/perldoc?Text%3A%3AHaml), and
[Mason](http://search.cpan.org/perldoc?Mason), to name a few). Dancer
also provides a default simple template engine called
[Dancer::Template::Simple](http://search.cpan.org/perldoc?Dancer%3A%3ATemplate%3A%3ASimple).
This gives you a simple self-contained template engine at no additional
cost!

The `template` keyword allows you to specify which template to process
and which variables to pass to the template:

        get '/user/view/:name' => sub {
            my $name = params->{name};

            # Dancer adds .tt automatically, but this is configurable
            template 'show_user' => {
                name => $name,
                user => get_user($name),
            };
        };

Dancer automatically supplies you an encompassing layout for your
templates, much like
[Template](http://search.cpan.org/perldoc?Template%3A%3AToolkit)'s
`WRAPPER` option. This built-in template means you can use the layout
with other template engines, such as
[Template::Tiny](http://search.cpan.org/perldoc?Template%3A%3ATiny).

Dancer accomplishes this by rendering two templates: the one you
provided and a (configurable) layout template. The layout template gets
the output of rendering your template as a `content` variable, then
embeds that content in the general page layout.

The default templates that come with Dancer demonstrate this point very
well. Here's *main.tt*, the default layout:

        <html><head><!-- some default css --></head>
        <body>
        <% content %>
        </body>
        </html>

**Serializers make RESTing easier**
-----------------------------------

Serializers are a new feature in Dancer (available since version 1.170).
They allow automatic serialization for your output in various forms
([Data::Dumper](http://search.cpan.org/perldoc?Data%3A%3ADumper),
[YAML](http://search.cpan.org/perldoc?YAML), or
[JSON](http://search.cpan.org/perldoc?JSON)) to shorten the amount of
code you have to write in your application.

When programming a RESTful service, the JSON serializer cuts down much
of your code by automatically serializing your output. This makes your
server-side AJAX code much more efficient and less boilerplate code for
you to write.

**File uploads are fun**
------------------------

File uploads exist since version 1.170. Within a route, write:

        # several files
        my @files = request->upload();

        # single file
        my $file  = request->upload();

        # then you can do several things with that file
        $file->copy_to('/my/upload/folder');
        my $fh       = $file->file_handle;
        my $content  = $file->content;
        my $filename = $file->filename;

**Easy configuration**
----------------------

You can configure everything (logging, session handling, template
layout, file locations) in Dancer using the main configuration file
(*appdir/config.yml*). There are configuration files for your specific
environment (*production* and *development*) and you can provide
environment-specific configurations in the corresponding file
(*appdir/environments/development.yml*, for example).

**Summary**
-----------

While Dancer is still evolving, it is already a production-ready
simple-yet-powerful web framework lets you get from zero to web in
record time. Put on your dancing shoes, define your steps, and bust a
move!

Dancer is available on the CPAN
([Dancer](http://search.cpan.org/perldoc?Dancer)), and [Dancer
development takes place on Github](http://github.com/sukria/Dancer).


