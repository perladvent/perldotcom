  {
    "title"       : "Porting a Dancer plugin to Dancer2",
    "authors"     : ["christopher-white"],
    "date"        : "2020-01-10T13:37:00",
    "tags"        : ["dancer","dancer2","perl","perl-5","perl-programming","web-development","porting","plugin"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "How I ported a plugin without having to know it all first",
    "categories"  : "development"
  }

In my [Dancer2]({{< mcpan "Dancer2" >}}) web application, I want to know which requests come from smartphones.  There’s a plugin for that — but only in the older [Dancer (v1)]({{< mcpan "Dancer" >}}) framework.  I’m no expert, but even I was easily able to port the Dancer plugin, [Dancer::Plugin::MobileDevice]({{< mcpan "Dancer::Plugin::MobileDevice" >}}), to Dancer2!  In this article, we’ll explore Dancer2 and the way it handles plugins.  We’ll get our hands dirty working with the framework, and examine the main changes I made to port the plugin from Dancer to Dancer2.  By the end of this article, you’ll be ready to rock _and_ you’ll have a handy reference to use when porting plugins yourself.

The Dancer2 web framework
-------------------------

Dancer2 applications run on a Web server and process requests from a browser.  The application’s Perl code uses keywords in Dancer2’s domain-specific language (DSL) to access information about a request.

Try it out: Install [Task::Dancer2]({{< mcpan "Task::Dancer2" >}}).  Then, save this as `app.psgi`:


```perl
use Dancer2;
get '/' => sub {
    return 'Hello, ' . (query_parameters->{name} || 'world') . '!';
};
to_app;
```

and run `plackup`.

Enter the URL `http://localhost:5000` in a browser and you will see “Hello, world!”, or visit `http://localhost:5000/?name=genius` to see “Hello, genius!”.  The “genius” comes from `query_parameters`, a DSL keyword that returns the values after the `?` in the URL.  You can use those values when building a response to a request.

Dancer and Dancer2 plugins
--------------------------

Dancer and Dancer2 plugins define new DSL keywords for the plugin’s users.  They also install “hooks,” subroutines that run while Dancer processes a request.  The hooks collect information for the DSL keywords to access.

For example, a hook in Dancer::Plugin::MobileDevice detects whether a request is coming from a mobile device.  The plugin defines the `is_mobile_device` DSL keyword so your code can react appropriately. To port the plugin, I changed code for the keyword, the hooks, and the test suite.

Porting keywords
----------------

Dancer plugins use the Dancer DSL and a [plugin-specific DSL]({{< mcpan "Dancer::Plugin" >}}) to define DSL keywords. In Dancer (v1), the `is_mobile_device` keyword is created with the `register` plugin-DSL function (code examples simplified to focus on the porting):

```perl
register 'is_mobile_device' => sub {
    return request->user_agent =~ /$regex/ || 0;
};
register_plugin;
```

Dancer2 plugins are [Moo]({{< mcpan "Moo" >}}) objects, and new DSL keywords are member functions on those objects.  Therefore, I changed `is_mobile_device()` to a member function:

```perl
sub is_mobile_device {
    my $self = shift;       # get the plugin’s object instance
    return ($self->dsl->request->user_agent =~ /$regex/) || 0 ;
}
plugin_keywords qw(is_mobile_device);   # replaces register_plugin()
```

In the body of the function, the Dancer plugin directly accessed the DSL keyword `request`.  The Dancer2 plugin instead accesses the request via `$self->dsl->request`.

Porting hooks
-------------

Dancer plugins add hooks using the DSL `hook` keyword.  For example, this `before_template` hook makes `is_mobile_device` available in templates:

```perl
hook before_template => sub {
    my $tokens = shift;
    $tokens->{'is_mobile_device'} = is_mobile_device();
};
```

Dancer2 handles hooks very differently.  The plugin’s Moo constructor, `BUILD`, is called when a plugin instance is created.  In `BUILD`, the plugin registers the hook.  I added `BUILD` and called
`$self->dsl->hook` to add the hook:

```perl
sub BUILD {
    my $self = shift;
    $self->dsl->hook( before_template_render => sub {
        my $tokens = shift;
        $tokens->{is_mobile_device} = $plugin->is_mobile_device;
    });
}
```

If your hook functions are too long to move into `BUILD`, you can leave them where they are and say `$self->dsl->hook( hook_name => \&sub_name );`.

Porting the tests
-----------------

Dancer::Plugin::MobileDevice has a full test suite.  These tests are extremely useful to developers, as they allow you to to see if a Dancer2 port behaves the same as the Dancer original. That said, you have to port the tests themselves before you can use them to test your ported plugin! We’ll look at the Dancer way, then I’ll show you the Dancer2 changes.

The Dancer tests define a simple Web application using the plugin.  They exercise that application using helpers in [Dancer::Test]({{< mcpan "Dancer::Test" >}}).  For example (simplified from `t/01-is-mobile-device.t`):

```perl
{   # The simple application
    use Dancer;
    use Dancer::Plugin::MobileDevice;
    get '/' => sub { return is_mobile_device; };
}

use Dancer::Test;

$ENV{HTTP_USER_AGENT} = 'iPhone';
my $response = dancer_response GET => '/';  # dancer_response() is from Dancer::Test
is( $response->{content}, 1 );
```

Dancer2, on the other hand, uses the [Plack]({{< mcpan "Plack" >}}) ecosystem for testing instead of its own helpers.  To work in that ecosystem, I changed the
above test as described in the
[Dancer2 manual’s “testing” section]({{< mcpan "Dancer2::Manual#TESTING" >}}):

```perl
use Plack::Test;                        # Additional testing modules
use HTTP::Request::Common;
{
    package TestApp;     # Still a simple application, but now with a name
    use Dancer2;
    use Dancer2::Plugin::MobileDevice;

    get '/' => sub { return is_mobile_device; };
}

my $dut = Plack::Test->create(TestApp->to_app);     # a fake Web server
my $response = $dut->request(GET '/', 'User-Agent' => 'iPhone');
is( $response->content, 1 );
```

Dancer2 tests use more boilerplate than Dancer tests, but Dancer2 tests are more modular and flexible than Dancer tests.  With Plack, you don’t have to use the global state (`%ENV`) any more, and you can test more than one application or use case per `.t` file.  Seeing the tests pass is good indication that your porting job is done.

Conclusion
----------

I am a newbie at Dancer2, and have never used Dancer.  But I was able to port Dancer::Plugin::MobileDevice to Dancer2 in less than a day — including time to read the documentation and figure out how!  When you need a Dancer function in Dancer2, grab the quick reference below and you’ll be off and running!

Acknowledgements
----------------

My thanks to Kelly Deltoro-White for her insights, and to the authors of Dancer::Plugin::MobileDevice and Dancer2 for a strong foundation to build on.

More information on Dancer2 plugins
-----------------------------------

- “[The new Dancer2 plugin system](http://advent.perldancer.org/2016/22)” by Sawyer X, for an overview
- [Dancer2::Plugin]({{< mcpan "Dancer2::Plugin" >}}), for details

Quick reference: porting plugins from Dancer to Dancer2
-------------------------------------------------------

**Port keywords:**

- Make keywords freestanding `sub`s, not arguments of `register`
- Access data through `$self` rather than DSL keywords
- Change `register_plugin` to `plugin_keywords`

**Port hooks:**

- Add a `BUILD` function
- Move the hook functions into `BUILD`, or refer to them from `BUILD`
- Wrap each hook function in a `$self->dsl->hook` call

**Port tests:**

- Import[Plack::Test]({{< mcpan "Plack::Test" >}}}) and
  [HTTP::Request::Common]({{< mcpan "HTTP::Request::Common" >}})
  instead of Dancer::Test
- Give the application under test a `package` statement
- Create a Plack::Test instance representing the application
- Create requests using HTTP::Request::Common methods
- Change `$response->{content}` to `$response->content`
