
  {
    "title"       : "Inspecting Catalyst",
    "authors"     : ["david-farrell"],
    "date"        : "2019-11-11T10:34:07",
    "tags"        : ["catalyst", "metacpan"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "What routes does your Catalyst app respond to?",
    "categories"  : "web"
  }

One of the convenient things about [Catalyst]({{< mcpan "Catalyst" >}}) is it lets you register controller methods as actions, so you don't need a separate routing table of URIs to controller methods. A consequence of this though, is that when the web app gets large enough it can be tricky to keep track of all the different paths the app is responding to.

Catalyst's [chained dispatch]({{< mcpan "Catalyst::DispatchType::Chained" >}}) promotes code reuse, but exacerbates the issue by obfuscating route matching. Catalyst also permits declaring controller methods which match an unlimited number of paths after a prefix; another recipe for unpredictablity.

Take a look at the MetaCPAN [source code](https://github.com/metacpan/metacpan-web). Can you tell all of the routes it responds to?

As far as I know, the only way is to launch the app in debug mode and Catalyst will print a list of all the controller actions and their URIs. I suppose you could try parsing that output, but that feels like a hack. If we're programming a web app, surely we should be able to programmatically retrieve all the routes *we've* created, without having to launch the app.


Catalyst::Plugin::ActionPaths
-----------------------------
With that straw man sufficiently propped up, allow me to introduce [Catalyst::Plugin::ActionPaths]({{< mcpan "Catalyst::Plugin::ActionPaths" >}}). I wrote it a while ago to implement some [axiomatic]({{< relref "save-time-with-compile-tests.md" >}}) tests at work which checked for misconfigured Catalyst routes.

The plugin adds the `get_action_paths` method to the Catalyst context object. The method returns an arrayref of the application's [Catalyst::Action]({{< mcpan "Catalyst::Action" >}}) objects. The way Catalyst's routing works is it loops through every action object until it finds one that matches the request, or returns in failure.

To use the ActionPaths plugin on the MetaCPAN app I forked and cloned the [repo](https://github.com/dnmfarrell/metacpan-web/commit/08d9a4929887c6bfb39271378415f6190a1a010a), and added the ActionPaths plugin to the application [class](https://github.com/dnmfarrell/metacpan-web/commit/08d9a4929887c6bfb39271378415f6190a1a010a).

After installing [Carton]({{< mcpan "Carton" >}}) from the root project directory I ran:

```bash
$ carton install
```

Which installed of the applications dependencies into the `./local` directory. This is a nice way to avoid clobbering your system or user-installed modules with the application's dependencies.

I also had to install the libxml2-dev and node-less Ubuntu packages to provide all of the app's dependencies.

Finally I wrote this [script](https://github.com/dnmfarrell/metacpan-web/commit/d17066f41945692a960ba80ed1865f22286efb78):

```perl
#!/usr/bin/env perl
use v5.16;
use Cwd;
use File::Basename;
use File::Spec;

my $root_dir;
BEGIN {
  my $bin_dir = File::Basename::dirname(__FILE__);
  $root_dir = Cwd::abs_path(File::Spec->catdir($bin_dir, File::Spec->updir));
}
use lib "$root_dir/local/lib/perl5"; # carton installed deps
use lib "$root_dir/lib";             # root application dir
use Catalyst::Test 'MetaCPAN::Web';

my($res, $c) = ctx_request('/');

for (@{$c->get_action_paths}) {
  say join "\t", $_->{class}, $_->{name}, $_->{path};
}
```

It begins by figuring out the root application directory, and adding the paths to the local Carton-installed and the MetaCPAN project modules (it uses [lib]({{< mcpan "lib" >}}) to catch architecture specific nested paths).

It uses [Catalyst::Test]({{< mcpan "Catalyst::Test" >}}) to load the MetaCPAN::Web application. Catalyst::Test exports the `ctx_request` method, which returns the Catalyst context object `$c`. From there I can call `get_action_paths` and print out all the routes served by MetaCPAN.

```bash
$ bin/dump-catalyst-paths
MetaCPAN::Web::Controller::Root   index           /
MetaCPAN::Web::Controller::Root   default         /...
MetaCPAN::Web::Controller::About  about           /about/
MetaCPAN::Web::Controller::About  contact         /about/contact/
MetaCPAN::Web::Controller::About  contributors    /about/contributors/
MetaCPAN::Web::Controller::About  development     /about/development/
MetaCPAN::Web::Controller::About  faq             /about/faq/
MetaCPAN::Web::Controller::About  meta_hack       /about/meta_hack/
MetaCPAN::Web::Controller::About  metadata        /about/metadata/
MetaCPAN::Web::Controller::About  missing_modules /about/missing_modules/
MetaCPAN::Web::Controller::About  resources       /about/resources/
MetaCPAN::Web::Controller::About  sponsors        /about/sponsors/
MetaCPAN::Web::Controller::About  stats           /about/stats/
MetaCPAN::Web::Controller::Author index           /author/*
# output truncated
```

An asterisk in the path is a placeholder. An ellipses means the path accepts unlimited(!) placeholders.

In this case I'm just printing the controller methods and URIs they match, but you could implement all kinds of checks on the Catalyst::Action objects to detect violations of agreed upon development best practices.


A better way
------------
The solution above works, but it feels a bit gross. I've added a plugin to the Catalyst app which the app doesn't actually use. The script fakes a request to the app *just* to get `$c`. I'm using a test module but running no tests. Surely there is a better way.

Typically, Catalyst applications call the `setup` method in the application module (for MetaCPAN that's [MetaCPAN::Web](https://github.com/dnmfarrell/metacpan-web/blob/7866904ca299701bfa850c10a9e0456f73109bc4/lib/MetaCPAN/Web.pm)). The `setup` method bootstraps the web application, doing things like configuring directories, initializing the logger, loading plugins and building the request dispatcher. These are stored in the application package which is a singleton.

`Catalyst::Plugin::ActionPaths::get_action_paths` uses the Catalyst context to get the dispatcher object, which is all it needs to extract the paths from the Catalyst app. So instead of using `request_ctx` to get the context to get the dispatcher, I can just stand up the application myself and pluck the dispatcher out of the application package:

```perl
require MetaCPAN::Web; # calls setup()
my $dispatcher = MetaCPAN::Web->dispatcher;
```

Now if I re-write the `get_action_paths` method to just use the dispatcher object directly, I can extract all the paths from the app without using `request_ctx`:

```perl
my $actions = get_action_paths($dispatcher);
for (@{$actions}) {
  say join "\t", $_->{class}, $_->{name}, $_->{path};
}
```

This works. Of course if I can dynamically load the MetaCPAN app and extract its routes, then I can do that for any Catalyst app. That's what [dump-catalyst-paths](https://gist.github.com/dnmfarrell/cad2c6f6395850cb1ceca48b3ba05b7c) does. To dump a Catalyst app's routes just provide the package name and any additional paths to include:

```bash
$ ./dump-catalyst-routes MetaCPAN::Web lib local/lib/perl5
```

Postscript
----------
We're just a couple of months past the 10th anniversary of the publication of [Catalyst: The Definitive Guide](https://www.apress.com/gp/book/9781430223658). Two of our core applications at work are Catalyst apps. As one of Perl's premier MVC apps, it's remarkable how resilient it's been. That's a testament to the implementation (which got a lot of things right) and more recently the work done by its maintainer [John Napiorkowski](https://metacpan.org/author/JJNAPIORK). Thanks John!

If you're considering web application programming with Perl, the [Dancer2]({{< mcpan "Dancer2" >}}), [Mojolicious]({{< mcpan "Mojolicious" >}}) and [Kelp]({{< mcpan "Kelp" >}}) frameworks are modern alternatives to Catalyst.
