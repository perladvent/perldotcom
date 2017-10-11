{
   "authors" : [
      "philipp-janert"
   ],
   "image" : null,
   "title" : "Advanced HTML::Template: Widgets",
   "description" : " My previous article, looked at extending HTML::Template through custom tags and filters. This article looks at ways to manage large, more complex pages, by bundling HTML::Template into something like GUI \"widgets\" (or \"controls\"). Imagine you have a basic page...",
   "categories" : "Web",
   "thumbnail" : "/images/_pub_2007_02_02_htmltemplate-widgets/111-HTML_Frag.gif",
   "date" : "2007-02-01T00:00:00-08:00",
   "tags" : [
      "html-templating",
      "html-template",
      "perl-templating",
      "web-templates",
      "widgets"
   ],
   "slug" : "/pub/2007/02/02/htmltemplate-widgets",
   "draft" : null
}





My previous article, looked at [extending `HTML::Template` through
custom tags and filters](/pub/a/2006/11/30/html-template-filters.html).
This article looks at ways to manage large, more complex pages, by
bundling
[`HTML::Template`](http://search.cpan.org/perldoc?HTML::Template) into
something like GUI "widgets" (or "controls").

Imagine you have a basic page layout following the standard setup, with
a header, a lefthand navbar, and the main body in the bottom right. The
header and navbar are the same for all pages of the site, but of course
the main body differs from page to page:

Header
Navbar
Body

Naturally, you don't want to repeat the information for the header and
the navbar explicitly on each page. Furthermore, if the HTML for the
navbar changes, you don't want to have to modify each and every page.
The `<TMPL_INCLUDE>` tag can help in this situation.

Create separate files for header and navbar, then include them in the
template for each page (by convention, I use the filename extension
*.tpf* for page *f*ragments, to distinguish them from full-page
templates: *.tpl*):

    <html>
      <head></head>
      <body>
        <table>
        <tr colspan="2">
          <td><TMPL_INCLUDE NAME=header.tpf></td>
        </tr>
        <tr>
          <td><TMPL_INCLUDE NAME=navbar.tpf></td>
          <td> 
            <!-- Body goes here! -->
            ...
          </td>
        </tr>
        </table>
      </body>
    </html>

Now `HTML::Template` will include the page fragments for the header and
navbar in the page when it evaluates the template. Changes to either of
the fragments will affect the entire site immediately.

(For simplicity of presentation, I am going to use the old familiar
`<table>` method to fix the layout--this article is about
`HTML::Template`, not CSS positioning!)

Note that both the header and the navbar may include other
`HTML::Template` tags, such as `<TMPL_VAR>` or `<TMPL_LOOP>`: file
fragment inclusion occurs *before* tag substitution. If you need dynamic
content in either header or navbar, all you need to do is set the value
of the corresponding parameter using the `param()` function before
evaluating the template.

### Better Encapsulation through Widgets

If there are only a few dynamic parameters in header and navbar, you can
simply assign values to them together with the parameters required by
the main body of the page. However, if the header and navbar themselves
become sufficiently complicated, you probably don't want to repeat their
parameter-setting logic with the actual Perl code managing the main
business logic for each page of our site. Instead, you can control them
through an API.

To establish a Perl API for a page fragment, hide the entire template
handling, including parameter setting and template substitution, in a
subroutine. The subroutine takes several parameters and returns a string
containing the fully expanded HTML code corresponding to the page
fragment. You can then include this string in the current page through a
simple `<TMPL_VAR>` tag.

As an example, consider a navbar that contains the username of the
currently logged-in user.

Here is the page-fragment template for the navbar:

    Current User: <TMPL_VAR NAME=login>
    <br />
    <ul>
      <li><a href="page1.html">Page 1</a>
      <li><a href="page2.html">Page 2</a>
      <li><a href="page3.html">Page 3</a>
    </ul>

For this example, the corresponding subroutine is very simple. It's easy
to imagine a situation where the navbar requires some complex logic that
you are glad to hide behind a function call--for instance, when the
selection of links depends on the permissions (found through a DB call)
of the logged-in user.

Demonstrating the principle is straightforward; find the template
fragment, set the required parameter, and render the template:

    sub navbar { 
      my ( $login ) = shift;

      my $tpl = HTML::Template->new( filename => 'navbar.tpf' );
      $tpl->param( login => $login );
      return $tpl->output();
    }

The master-page template then includes the navbar string using a
`<TMPL_VAR>` tag. (Note the header inclusion through a `<TMPL_INCLUDE>`
tag.)

    <html>
      <head></head>
      <body>
        <table>
        <tr colspan="2">
          <td><TMPL_INCLUDE NAME=header.tpf></td>
        </tr>
        <tr>
          <td><TMPL_VAR NAME=navbar></td>
          <td> 
            <!-- Body goes here! -->
            ...
          </td>
        </tr>
        </table>
      </body>
    </html>

This approach provides pretty good encapsulation: the code calling the
`navbar()` routine does not need to know anything about its
implementation--in fact, the subroutine can be in a separate module
entirely. It is not far-fetched to imagine a shared module for all
reusable page fragments used on the site.

### Building Pages Inside Out

This development model still uses a separate, top-level template file
for each page. All shared parts of the page are then included in this
master template.

The widget approach can go a step further to do away entirely with the
notion of having a separate master template for each page, by turning
even the *main body* of the page into a widget or a collection of
widgets. At this point, there may be only a single top-level template:

    <html>
      <head></head>
      <body>
        <table>
        <tr colspan="2">
          <td><TMPL_INCLUDE NAME=header.tpf></td>
        </tr>
        <tr>
          <td><TMPL_VAR NAME=navbar></td>
          <td><TMPL_VAR NAME=mainbody></td>
        </tr>
        </table>
      </body>
    </html>

A central Perl "controller" component dispatches page requests to the
appropriate main-body widget (assuming you specify destination pages
through a request parameter called `action`):

    use CGI;
    use HTML::Template;

    my $q = CGI->new;
    my $action = $q->param( 'action' );

    # Dispatch to the desired main function
    my $body_string = '';
    if(    $action eq 'act1' ) { $body_string = act1( $q ); }
    elsif( $action eq 'act2' ) { $body_string = act2( $q ); }
    elsif( $action eq 'act3' ) { $body_string = act3( $q ); }

    # Pull the current user from the query object and pass to the navbar
    my $navbar_string = navbar( $q->param( 'login' ) );

    # Set the rendered navbar and mainbody in the master template
    my $tpl = HTML::Template->new( filename => 'tmpl3.tpl' );
    $tpl->param( mainbody => $body_string );
    $tpl->param( navbar   => $navbar_string );

    print $q->header(), $tpl->output;

    sub navbar { ... }

    sub act1{ ... }
    sub act2{ ... }
    sub act3{ ... }

### A Drop-down Widget

At this point, you may ask why you still need a template for the page
fragment at all. Well, you don't--unless you find it convenient, of
course.

There are two reasons to use a template: as a more suitable method of
generating HTML than having to program a whole bunch of `print`
statements, and to ensure separation of presentation from behavior. By
encapsulating the nitty-gritty of HTML generation behind an API, you
achieve the latter. How you go about the former depends entirely on the
context. If you need to generate a lot of straight up HTML, with lots of
`<table>`, `<img>`, and `<form>` tags, a template fragment makes perfect
sense. But if it is actually easier to program the `print` statements
yourself, there is nothing wrong with that--by encapsulating the HTML
generation in a subroutine, you still achieve separation of presentation
and main control flow and business logic.

As a classic example for something that is hard to express as a
template, consider a drop-down menu with a default that has to be set
programmatically. Attempting to do this using a template leads to a mess
of template loops and conditionals. However, doing it in a widget
subroutine is clean and easy, in particular if you use the appropriate
functions from the standard `CGI` module:

    sub color_select {
      my ( $default_color ) = @_;

      my @colors = qw( red green blue yellow cyan magenta );

      return popup_menu( 'color_select', \@colors, $default_color );
    }

Include the string returned by this subroutine in a page template using
`<TMPL_VAR>` tags as discussed previously.

### Conclusion

This concludes a brief overview of some useful techniques for using
`HTML::Template` that go beyond straight up variable replacement. I hope
you enjoyed the trip.

There remains the question of when all of this is useful and suitable.
To me, the beauty of `HTML::Template` is its utter simplicity. There
isn't much in the way of creature comforts or "framework" features (such
as forms processing or automated request dispatch). On the other hand,
there is virtually *no* overhead: it's possible to understand the basic
ideas of `HTML::Template` in five minutes or fewer, and it's easy to add
to any simple CGI script. You don't need to design the project around
the framework (as is often the case with more powerful but inevitably
more complex toolsets). In fact, `HTML::Template` is so trivial to use
that I use it in any CGI script that produces more than, say, 10 to 15
lines of HTML output. It's just convenient.

Filters and "widgets" as described in this series are easy ways to add
some convenience features that are missing from `HTML::Template`. By
bundling some repetitive code segments into a custom tag or a widget,
you can keep both the code and template cleaner and simpler while at the
same time continuing to enjoy the low overhead of `HTML::Template`.

However, there is only so much lipstick you can put on a pig. When you
find ourselves building extensive libraries of custom tags or specific
widgets, maybe you want to look more deeply into one of the existing
frameworks for Perl web development, such as [the Template
Toolkit](http://search.cpan.org/perldoc?Perl::Mason%3C/a%3E%3Ccode%3EPerl::Mason%3C/code%3E%20or%3Ca%20href=).

Of course, as long as you are happy with `HTML::Template` and it works
for you, there is no reason to change. It works for me--and very well
indeed.

<div style="border: 1px solid #777777; width: 95%; 
background-color:#f0f0f0; padding:8px; margin:5px 5px;">

#### Sidebar: Three Hidden Gems

`HTML::Template` has several useful and often overlooked minor features
and options, (despite being clearly documented in POD). I want to point
out three of the ones that are most commonly useful--all of which, by
default, are (unfortunately, I think) turned *off*.

##### Permit Unused Parameters

    my $tpl = HTML::Template->new( filename => '...', die_on_bad_params => 0 );

HTML::Template will die when it encounters an unused parameter in the
template. In other words, if you set a parameter with `$tpl->param()`,
but there is no corresponding `<TMPL_VAR>` in the template, template
processing will fail by default. Setting the option `die_on_bad_params`
to `0` disables this behavior.

##### Make Global Variables Visible In Loops

    my $tpl = HTML::Template->new( filename => '...', global_vars => 1 );

By default, template loops open up a new scope, which makes all template
parameters from outside the loop invisible within the loop. In
particular, code like this will (by default) not work as expected:

    Verbosity level: <TMPL_VAR NAME=isVerbose>
    <ul>
    <TMPL_LOOP NAME=rows>
      <li><TMPL_VAR NAME=rowitem>
        <TMPL_IF NAME=isVerbose>
          ... <!-- print additional, 'verbose' info -->
        </TMPL_IF>
    </TMPL_LOOP>
    </ul>

The `verbose` parameter, defined *outside* the loop scope will by
default *not* be visible within the loop. Change this by setting the
option `global_vars` to `1`.

##### Special Loop Variables

    my $tpl = HTML::Template->new( filename => '...', loop_context_vars => 1 );

Finally, enable a very useful little feature by setting
`loop_context_vars` to `1`. This defines several Boolean variables
within each loop; they take on the appropriate value for each row:

-   `__first__`
-   `__inner__`
-   `__last__`
-   `__odd__`
-   `__even__`

There is also an integer variable `__counter__`, which is incremented
for each row. Note that `__counter__` starts at `1`, in contrast to Perl
arrays!

These variables are extremely useful in a variety of ways. For example,
they make it easy to give every other row in a table a different
background color to improve legibility. Together with filters (as
described in my previous article), this allows for rather elegant
template code:

    <html>
    <head>
      <style type="text/css">
        .odd  { background-color: yellow }
        .even { background-color: cyan }
      </style>
    </head>

    <body>
      <table>
      <TMPL_LOOP NAME=rows>
        <CSTM_ROW EVEN=even ODD=odd>
          <td> <TMPL_VAR NAME=__counter__> Cell contents... </td>
        </tr>
      </TMPL_LOOP>
      </table>
    </body>
    </html>

The appropriate filter for the new custom tag is:

    sub cstmrow_filter {
      my $text_ref = shift;
      $$text_ref =~ s/<CSTM_ROW\s+EVEN=(.+)\s+ODD=(.*)\s*>
                     /<TMPL_IF NAME=__odd__>
                        <tr class="$1">
                      <TMPL_ELSE>
                        <tr class="$2">
                      <\/TMPL_IF>
                     /gx;
    }

Note that, as implemented, the `EVEN` attribute must precede the `ODD`
attribute in the `<CSTM_ROW>` tag.

</div>


