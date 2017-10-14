{
   "thumbnail" : "/images/_pub_2006_10_19_cgi_application/111-cgiapps.gif",
   "description" : " This article provides an update on the popular and mature CGI::Application framework for web applications. It assumes a basic understanding of the system, so reviewing the previous Perl.com article about CGI::Application may be helpful background reading. CGI::Application and Catalyst...",
   "tags" : [
      "cgi-application",
      "perl-frameworks",
      "perl-web-applications",
      "web-development"
   ],
   "categories" : "web",
   "authors" : [
      "mark-stosberg"
   ],
   "image" : null,
   "draft" : null,
   "title" : "Rapid Website Development with CGI::Application",
   "date" : "2006-10-19T00:00:00-08:00",
   "slug" : "/pub/2006/10/19/cgi_application.html"
}





This article provides an update on the popular and mature
[CGI::Application](http://www.cgi-app.org/) framework for web
applications. It assumes a basic understanding of the system, so
reviewing the [previous Perl.com article about
CGI::Application](/pub/a/2001/06/05/cgi.html) may be helpful background
reading.

### CGI::Application and Catalyst Compared

You may recall the [Perl.com article on another MVC web framework,
Catalyst](/pub/a/2005/06/02/catalyst.html). First, I want to clear up
possible confusion by explaining how the CGI::Application and Catalyst
relate.

With the many [plugins available for
CGI::Application](http://www.cgi-app.org/?Plugins) and Catalyst, both
[frameworks offer many of the same
features](http://cgiapp.erlbaum.net/cgi-bin/cgi-app/index.cgi?CatalystCompared).

Both provide convenient methods to access many of the same underlying
modules including
[Data::FormValidator](http://www.summersault.com/community/weblog/2005/10/25/validating-web-forms-with-perl.html),
[HTML::FillInForm](http://search.cpan.org/perldoc?HTML::FillInForm) and
templating systems such as [Template
Toolkit](http://www.template-toolkit.org/) and
[HTML::Template](http://html-template.sourceforge.net/).

Both frameworks work in CGI and mod\_perl environments, although
CGI::Application loads faster in CGI. Each one provides unique features
to help with development and debugging. Catalyst includes a built-in web
server for easy offline testing and development. CGI::Application
provides a [persistent development pop-up
window](http://search.cpan.org/perldoc?CGI::Application::Plugin::DevPopup)
that provides convenient reports on HTML validation, application
performance, and more.

While CGI::Application and Catalyst share many of the same strengths,
they also face the same challenge of attracting users and developers.

As the expectations for web site features and quality increase, the
toolkit that a web developer depends on must increase and expand as
well. The more plugins that are compatible with our framework, the
easier our job is. We each have a selfish incentive to attract others to
use the same framework. Users become contributors, and contributors
write plugins to make our lives easier.

CGI::Application and Catalyst already share users and developers of many
of the Perl modules they depend on. With PHP and Ruby on Rails both on
the rise as web development solutions, those who prefer Perl have an
incentive to promote the best the language has to offer.

### What A Difference Half A Decade Makes

CGI::Application development took off around the 4.0 release for two
reasons. To start with, it formalized a plugin system, which led to the
release of some initial plugins. Next, the 4.0 release added a callback
system, allowing the plugin authors to automatically add actions that
take place at particular points in the request cycle.

For example, the AutoRunmode plugin registers itself at the "prerun"
phase, allowing it to adjust which run mode is selected. Another plugin
might register to add a cleanup action in the "teardown" phase.

The combined result was a boom in plugin development. While the core of
CGI::Application has remained small and stable, there are over three
dozen plugins now on the CPAN.

Here's a tour of some of the enhancements that have come about as a
result of the new plugin and callback system.

### Simplified Runmode Syntax

The built-in way to register a run mode typically involves calling
`run_modes()` within `setup()`:

    sub setup {
       my $self = shift;
       $self->run_modes([qw/
            my_run_mode
       /]);
    }

    # later...
    sub my_run_mode {
     ...
    }

With the [AutoRunmode
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::AutoRunmode),
it's now very easy to declare that a method is a "run mode" handling a
CGI request rather than an internal function. The syntax is simply:

        sub my_run_mode : Runmode {
            my $self = shift;
            # ...    
        }

You can still use `setup()`, but it's no longer necessary.

### New Dispatcher Provides Clean URLS

A large project built with CGI::Application typically has many small
"instance scripts" that drive modules full of run modes. All of these
instance scripts look basically the same:

    use Project::Widget::View;
    my $app = Project::Widget::View->new();
    $app->run();

A corresponding URL might look like:

    /cgi-bin/project/widget/view.cgi?widget_id=23

[CGI::Application::Dispatch
2.0](http://search.cpan.org/~wonko/CGI-Application-Dispatch/lib/CGI/Application/Dispatch.pm)
allows you to replace all of these instance scripts with a single
dispatch script to produce much cleaner URLs. Such a dispatch script
might look like:

    #!/usr/bin/perl
    use CGI::Application::Dispatch;
    CGI::Application::Dispatch->dispatch(
            prefix              => '',
            table               => [
                ':app/:rm/:id'  => {},
            ],

    );

Now add a dash of mod\_rewrite magic provided in the documentation, and
the URL will transform from:

    /cgi-bin/project/widget/view.cgi/detailed_view?widget_id=23

to:

    /widget/detailed_view/23

Clean and simple.

The `widget_id` is easily accessible from within the run mode:

    my $widget_id = $self->param('id');

The dispatcher takes care of that detail for you, saving some manual
munging of `PATH_INFO`.

### First-Class Templating Support

While CGI::Application integrates by default with
[HTML::Template](http://html-template.sourceforge.net/), it seems an
equal number of the users prefer the [Template
Toolkit](http://www.template-toolkit.org/) templating system. Both camps
now have access to several new templating-related features.

#### Default template names

To keep the code cleaner and consistent, it's now possible to generate
template names automatically. Typically, you want to load one template
to correspond with each run mode. Simply loading a template might look
like:

        sub my_run_mode: Runmode {
            my $self = shift;

            # XXX The old way, with redundant file name 
            # my $t = $self->load_tmpl('my_run_mode.html');

            # Look Ma! No explicit file name needed!
            my $t = $self->load_tmpl;
            return $t->output;
        }

#### Easy access to the application object from the template

The [TT
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::TT)
introduced easy access to the CGI::Application object from the template,
allowing easy constructions by using the `c` parameter to access the
application object.

    Hello [% c.session.param('username') || 'Anonymous User' %]
    <a href="[% c.query.self_url %]">Reload this page</a>

Authors of open source web applications will surely appreciate the
[AnyTemplate
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::AnyTemplate),
which allows you to use a single templating syntax in your code, and
lets users choose the templating system that best integrates with their
existing project. There was no ready-made way to do this in the past.

Conveniently, HTML::Template and TT users can use a familiar syntax to
drive AnyTemplate.

TT style:

    $self->template->process('file_name', \%params);

HTML::Template style:

    # Yes, it really can be identical to the standard load_tmpl() syntax!
    my $template = $self->load_tmpl('file_name');
    $template->param('foo' => 'bar');
    $template->output;

A great example of this template abstraction is
[CGI::Application::Search](http://search.cpan.org/perldoc?CGI::Application::Search),
a reusable application that integrates with the
[Swish-E](http://swish-e.org.) search engine. Whether you prefer
HTML::Template or Template Toolkit, it's easy to add this as a search
solution for a larger project--even if the rest of your website does not
use CGI::Application.

CGI::Application also offers improved support for other output formats.
The [Stream
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::Stream)
makes it a snap to stream a document to the user, such as a PDF or Excel
file that is built on the fly. This saves the busy work of remembering
the related details for unbuffered output, `binmode`, file chunking, and
MIME types. That now takes basically one line of syntax:

    $self->stream_file( $file );

The [XSV
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::Output::XSV)
simplifies building CSV files. This tedium is now a single function call
for simple cases:

      return $self->xsv_report_web({
        fields     => \@headers,
        # Get values from the database
        values     => $sth->fetchall_arrayref( {} );
        csv_opts   => { sep_char => "\t" },
        filename   => 'members.csv',
      });

### Lazier Than Ever

One frequent feature you'll find in CGI::Application plugins is lazy
loading. This means that loading and configuring the plugin often has
little resource penalty. Take the [DBH
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::DBH).
It's convenient to configure the database handle once for a whole
website project and then use the handle whenever you want.

Before this plugin arrived, it would be tempting to stuff the database
handle into the `param` method to achieve a similar effect:

    sub cgiapp_init {
        my $self = shift;

        my $dbh = DBI->connect($data_source, $username, $auth, \%attr);

        # save for later!
        $self->param('dbh',$dbh);
    }

That works OK, but it misses a valuable feature: lazy loading.

Lazy loading creates the database connection only if any code needs to
use it. This avoids needlessly creating a database connection for
scripts that don't need it, while still being very convenient. Here's an
example:

    # define the database connection parameters once in a super class, for a whole
    # suite of child applications:

    sub cgiapp_init  {
       my $self = shift;

       # use the same args as DBI->connect(); 
       $self->dbh_config($data_source, $username, $auth, \%attr);

    }

Then, whenever you need a database handle:

    sub my_run_mode : Runmode {
        my $self = shift;
        my $result = $self->dbh->selectrow("...");
        # ...
    }

Easy. `dbh_config()` will get called on every request, but it simply
stores the configuration details. The database handle gets created only
during calls to the `dbh()` method.

Another notable lazy-loading plugin is the [Session
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::Session),
which provides easy access to a CGI::Session object. It further takes
advantage of the CGI::Application framework by automatically setting the
session cookie for you, so you don't have to deal with cookies unless
you want to.

### Ready for High-Performance Environments

I mostly use CGI::Application with plain CGI, because it performs well
enough and works well in a shared hosting environment since no resources
persist between requests.

However, [CGI::Application is ready for high-performance
applications](http://cgiapp.erlbaum.net/cgi-bin/cgi-app/index.cgi?SitePerformance).

Often, code written for CGI::Application will run without changes under
mod\_perl's `Apache::Registry` mode, as
[1-800-Save-A-Pet.com](http://www.1-800-save-a-pet.com/) does.

To squeeze a little more juice out of mod\_perl, there is an [Apache
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::Apache),
which uses `Apache::Request` instead of `CGI.pm`.

A current popular alternative for increasing performance is
[FastCGI](http://www.fastcgi.com/). Use
[CGI::Application::FastCGI](http://search.cpan.org/perldoc?CGI::Application::FastCGI),
and add, usually, just one line of code to make your application work in
this environment.

### Easy Form Handling

A lot of tedium can be involved in processing web forms. The first
plugin,
[ValidateRM](http://search.cpan.org/perldoc?CGI::Application::Plugin::ValidateRM),
helped with that.

    my $results =  $self->check_rm('display_form', '_form_profile' ) 
       || return $self->dfv_error_page;

This simple syntax calls a
[Data::FormValidator](http://search.cpan.org/perldoc?Data::FormValidator)
profile into action. If validation fails, the page with the original
form is redisplayed with the previous values intact, and error messages
appear next to each field that is missing or invalid.

Fans of Data::FormValidator will appreciate an upcoming related module
from the CGI::Application community:
[JavaScript::DataFormValidator](http://search.cpan.org/perldoc?JavaScript::DataFormValidator).

This module makes it easy to use the same Perl data structure to add an
additional level of validation in JavaScript. I expect Catalyst and
CGI::App users alike will be putting this to use.

Finally, there's a new plugin to simplify filling in a web form from a
database record. This is the [FillInForm
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::FillInForm).
The syntax is simple:

       # fill in the HTML form from the query object
        $self->fill_form($html);

In part, this plugin solves [bug \#13913 in
HTML::FillInForm](http://rt.cpan.org/Public/Bug/Display.html?id=13913),
which means the interface detects what kind of input you are giving it,
rather than requiring you to explicitly declare that you have `hashref`
or `scalarref` and so forth. As you can see from the example, if you are
using the query object as input, you don't need to pass it in at all.

### DevPopUp: A Unique Developer Tool

CGI::Application offers a unique developer tool in the form of the
[DevPopUp
plugin](http://search.cpan.org/perldoc?CGI::Application::Plugin::DevPopup).
You can [see DevPopUp in action](http://oss.rhesa.com/scripts/dp.cgi) on
Rhesa's demo site. (Make sure your pop-up blocker doesn't trap it!).

The tool creates a persistent pop-up window that gives you feedback
about each run mode as soon as it completes. *"What were the HTTP
Headers? How long did it take? Was the resulting HTML valid?"*

The real kicker is that DevPopUp is itself pluggable, allowing other
developers to add their own reports. I look forward to Sam Tregar
releasing his [graphical DBI profiling
tool](http://use.perl.org/~samtregar/journal/25051), which would make a
nice addition here.

### Easier Error Messages with DebugScreen

CGI::Application users in Japan recently brought us the
[DebugScreen](http://search.cpan.org/perldoc?CGI::Application::Plugin::DebugScreen)
plugin. This is a welcome change from referencing the web server log to
find the most recent line that needs debugging.

### Hello, Web 2.0: AJAX Integration

In another story of cross-pollination with Catalyst, CGI::Application
integrates easily with the JavaScript
[Prototype](http://prototype.conio.net/) library. Prototype provides
easy access to plenty of interesting AJAX effects, such as
auto-completing based on a lookup to the server. This uses a thin
plugin-wrapping
[HTML::Prototype](http://search.cpan.org/perldoc?HTML::Prototype), which
was written with Catalyst in mind.

### CGI::Application and Catalyst

The appearance of Catalyst has been a great benefit to the
CGI::Application community. Both projects support the use and
development of focused, reusable components. When a new patch arrives
for a module both projects use, both projects benefit. As the maintainer
of Data::FormValidator, I'm well aware that the two camps are
collaborating through this project.

Catalyst releases its code under a license that allows CGI::Application
to reuse and integrate their work (and vice-versa). Often a plugin
written for Catalyst takes only a little effort to port to work with
CGI::Application. For example, Catalyst recently added
[PAR](http://par.perl.org/) support, which allows the distribution and
execution of a complex web application as a single binary. This helps a
Perl project with complex module dependencies compete with the
installation ease of typical PHP software.

This will be a great reference as CGI::Application users evaluate
[options for easier web application
deployment](http://www.perlmonks.org/?node_id=519032).

Finally, Catalyst demonstrates an alternate approach as a web framework.
This helps the CGI::Application community better evaluate their own
options.

### Conclusion

CGI::Application has always been about providing a clean structure for
web applications. With the advent of myriad plugins, it is also about
simplifying access to the many great tools that Perl offers web
developers through the CPAN. With more plugins being developed on a
regular basis, the life of the web developer is getting easier by the
day.


