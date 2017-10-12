{
   "draft" : null,
   "thumbnail" : "/images/_pub_2005_07_07_navwidgets/111-menus.gif",
   "authors" : [
      "shlomi-fish"
   ],
   "description" : " Navigation menus are a group of links given at one side of the page that allows users to navigate to different places of a website. Navigation menus allow site visitors to explore other pages of the site and to...",
   "image" : null,
   "date" : "2005-07-07T00:00:00-08:00",
   "slug" : "/pub/2005/07/07/navwidgets",
   "categories" : "Web",
   "tags" : [
      "html-design",
      "html-menus",
      "html-navigation",
      "html-widgets-navmenu",
      "perl-html-modules"
   ],
   "title" : "Building Navigation Menus"
}





\
Navigation menus are a group of links given at one side of the page that
allows users to navigate to different places of a website. Navigation
menus allow site visitors to explore other pages of the site and to find
what they want more easily. For example, [Paul Graham's home
page](http://www.paulgraham.com/) contains a simple navigation menu made
out of images. It doesn't change as the site visitor move to different
pages of the site. The [KDE desktop environment](http://www.kde.org/)
home page contains a more sophisticated menu. Click on [the link to the
screenshots](http://www.kde.org/screenshots/) to see a submenu for links
to screenshots from multiple versions of KDE. Other menu items have
similar expansions.

### Common Patterns in Navigation Menus and Site Flow

There are several patterns in maintaining navigation menus and general
site flow.

#### A Tree of Items

Usually, the items in the navigation menus are a tree structure (as is
the case for the KDE site) or a flat list. Sometimes, branches of the
tree can *expand* or collapse depending on the current page. This
prevents having to display the entire tree at once.

#### Next/Previous/Up Links to Traverse a Site

Many sites provide links to traverse the pages of the site in order: a
*Next* link to go to the next page, a *Previous* link to go to the
previous page, an *Up* link to go to the section containing the current
page, a *Contents* link to go to the main page, and so on.

HTML can represent these links by using `<head>` tag and
`<link rel="next" href="" />`. directives. Mozilla, Firefox, and Opera
all support these tags. They can be also visible in the HTML as normal
links, as is the case with [GNU
Documentation](http://www.gnu.org/software/make/manual/html_node/make_toc.html).

#### Site Maps and Breadcrumb Trails

Other navigation aids provided by sites include a *site map* (like [the
one on Eric S. Raymond's home
page](http://www.catb.org/~esr/sitemap.html)) and a *breadcrumb trail*.
A breadcrumb trail is a path of the components of the navigation menu
that leads to the current page. The [documentation for
Module::Build::Cookbook](http://search.cpan.org/dist/Module-Build/lib/Module/Build/Cookbook.pm)
on [search.cpan.org](http://search.cpan.org/) provides an example ("Ken
Williams &gt; Module-Build &gt; Module::Build::Cookbook," in this case).

#### Hidden Pages and Skipped Pages

Hidden pages are part of the site flow (the next/previous scheme) but
don't appear in the navigation menu. Skipped pages are the opposite:
they appear in the navigation menu, but are not part of the site flow.

### Introducing HTML::Widgets::NavMenu

How do you create menus?
[HTML::Widgets::NavMenu](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/)
is a [CPAN](http://www.cpan.org/) module for maintaining navigation
menus and site flow in general. It supports all of the above-mentioned
patterns and some others, has a comprehensive test suite, and is under
active maintenance. I have successfully used this module to maintain the
site flow logic for such sites as [my personal home
page](http://www.shlomifish.org/) and [the Perl Beginners'
Site](http://perl-begin.berlios.de/). Other people use it for their own
sites.

This makes it easy to generate and maintain such navigation menus in
Perl. It is generic enough so that it can generate static HTML or
dynamic HTML on the fly for use within server-side scripts (CGI,
*mod\_perl*, etc.).

To install it, use a CPAN front end by issuing a command such as
`perl -MCPANPLUS -e "install HTML::Widgets::NavMenu"` or
`perl -MCPAN -e "install HTML::Widgets::NavMenu"`.

### A Simple Example

Here's a simple example: a navigation tree that contains a home page and
two other pages.

You can see [the complete code for this
example](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/simple/H-W-NM-simple.pl):

    #!/usr/bin/perl

    use strict;
    use warnings;

    use HTML::Widgets::NavMenu;
    use File::Path;

This is the standard way to begin a Perl script. It imports the module
and the `File::Path` module, both of which it uses later.

    my $css_style = <<"EOF";
    a:hover { background-color : palegreen; }
    .body {
    .
    .
    .
    EOF

This code defines a CSS stylesheet to make things nicer visually.

    my $nav_menu_tree =
    {
        'host'  => "default",
        'text'  => "Top 1",
        'title' => "T1 Title",
        'subs'  =>
        [
            {
                'text' => "Home",
                'url'  => "",
            },
            {
                'text'  => "About Me",
                'title' => "About Myself",
                'url'   => "me/",
            },
            {
                'text'  => "Links",
                'title' => "Hyperlinks to other Pages",
                'url'   => "links/",
            },
        ],
    };

Now this is important. This is the tree that describes the navigation
menu. It is a standard nested Perl 5 data structure, with well-specified
keys. These keys are:

-   `host`: A specification of the host on which the sub-tree starting
    from that node resides. HTML::Widgets::NavMenu menus can span
    several hosts on several domains. In this case, the menu uses just
    one host, so `default` here is fine.
-   `text`: What to place inside of the `<a>...</a>` tag (or
    alternatively, the `<b>` tag, if it's the current page).
-   `title`: Text to place as a `title` attribute to a hyperlink
    (usually displayed as a tooltip). It can display more detailed
    information, helping to keep the link text itself short.
-   `url`: The path within the host where this item resides. Note that
    all URLs are relative to the top of the host, not the URL of their
    supernode. If the supernode has a path of *software/* and you wish
    the subnode to have a path of *software/gimp/*, specify
    `url => 'software/gimp/'`.
-   `subs`: An array reference that contains the node's sub-items.
    Normally, this will render them in a submenu.

One final note: HTML::Widgets::NavMenu does not render the top item. The
rendering starts from its sub-items.

    my %hosts =
    (
        'hosts' =>
        {
            'default' =>
            {
                'base_url' => ("http://web-cpan.berlios.de/modules/" .
                    "HTML-Widgets-NavMenu/article/examples/simple/dest/"),
            },
        },
    );

This is the hosts map, which holds the hosts for the site. Here there is
only one host, called `default`.

    my @pages =
    (
        {
            'path'    => "",
            'title'   => "John Doe's Homepage",
            'content' => <<'EOF',
    <p>
    Hi! This is the homepage of John Doe. I hope you enjoy your stay here.
    </p>
    EOF
        },
        .
        .
        .
    );

The purpose of this array is to enumerate the pages, giving each one the
`<title>` tag, the `<h1>` title, and the content that it contains. It's
not part of HTML::Widgets::NavMenu, but rather something that this
script uses to render meaningful pages.

    foreach my $page (@pages)
    {
        my $path     = $page->{'path'};
        my $title    = $page->{'title'};
        my $content  = $page->{'content'};
        my $nav_menu =

            HTML::Widgets::NavMenu->new(
                path_info     => "/$path",
                current_host  => "default",
                hosts         => \%hosts,
                tree_contents => $nav_menu_tree,
            );

        my $nav_menu_results = $nav_menu->render();
        my $nav_menu_text    = join("\n", @{$nav_menu_results->{'html'}});
        
        my $file_path = $path;
        if (($file_path =~ m{/$}) || ($file_path eq ""))
        {
            $file_path .= "index.html";
        }
        my $full_path = "dest/$file_path";
        $full_path =~ m{^(.*)/[^/]+$};

        # mkpath() throws an exception if it isn't successful, which will cause
        # this program to terminate.  This is what we want.
        mkpath($1, 0, 0755);
        open my $out, ">", $full_path or
            die "Could not open \"$full_path\" for writing: $!\n";
        
        print {$out} <<"EOF";
    <?xml version="1.0" encoding="iso-8859-1"?>
    <!DOCTYPE html
         PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
         "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
    <html>
    <head>
    <title>$title</title>
    <style type="text/css">
    $css_style
    </style>
    </head>
    <body>
    <div class="navbar">
    $nav_menu_text
    </div>
    <div class="body">
    <h1>$title</h1>
    $content
    </div>
    </body>
    </html>
    EOF

        close($out);
    }

This loop iterates over all the pages and renders each one in turn. If
the directory up to the file does not exist, the program creates it by
using the `mkpath()` function. The most important lines are:

        my $nav_menu =
            HTML::Widgets::NavMenu->new(
                path_info     => "/$path",
                current_host  => "default",
                hosts         => \%hosts,
                tree_contents => $nav_menu_tree,
            );

        my $nav_menu_results = $nav_menu->render();
        my $nav_menu_text    = join("\n", @{$nav_menu_results->{'html'}});

This code initializes a new navigation menu, giving it four named
parameters. `path_info` is the path within the host. Note that, as
opposed to the paths in the navigation menu, it starts with a slash.
This is to allow some CGI-related redirections. `current_host` is the
current host (again, it's `default`). Finally, `hosts` and
`tree_contents` point to hosts and the tree of contents, respectively.

The object `render()` method returns the results in a hash reference,
with the navigation menu results as an array of tags pointed by the
`html` key. The code finally `join`s and returns them.

The program produces [this
result](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/simple/dest/),
with three entries, placed in a `<ul>`. When a user visits a page, the
corresponding menu entry displays in bold and has its link removed.

### A More Complex Example

Now consider [a more complex
example](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/complex/H-W-NM-complex.pl).
This time, the tree is considerably larger and contains nested items.
There are now `subs` of other pages.

The [final
site](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/complex/dest/)
has a menu. When accessing a page (for example, [the "About Myself"
page](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/complex/dest/me/))
its expands so visitors can see its sub-items.

### Adding More Navigation Aids

The next step is to add a breadcrumb trail, navigation links, and a site
map to the site. You can inspect [the new
code](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/with-embellishments/H-W-NM-embellish.pl)
to see if you understand it and [view the final
site](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/with-embellishments/dest/).

The breadcrumb trail appears right at the top of the site. Below it is a
toolbar with navigation links like "next," "previous," and "up."
Finally, there's [a site
map](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/with-embellishments/dest/site-map/).
Here are the salient points of the [code's
modifications](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/complex-2-embellish-delta.diff "the difference from the previous version in patch format"):

1.  The code loads the [Template
    Toolkit](http://www.template-toolkit.org/) to render the page, then
    fills in the variables of the template to define the template itself
    and to process it into the output file.
2.  The CSS stylesheet has several new styles, to make the modified page
    look nicer.
3.  A template portion to transform a breadcrumb-trail object as
    returned by HTML::Widgets::NavMenu into HTML. It should be easy to
    understand.
4.  The bottom of the navigation menu tree now has an entry with a link
    to the site map page.
5.  The site map is now part of the `@pages` array. It initializes an
    `HTML::Widgets::NavMenu` with the appropriate URL, and then uses its
    `gen_site_map()` function.
6.  There is new code used to generate the navigation links. These links
    are a hash reference with the keys being the relevance of the link
    and the value being an object supplying information about the link
    (such as `direct_url()` or `title()`). There are two loops that
    renders each link into both the HTML `<head>` tag `<link>` elements,
    or the toolbar to present on the page.
7.  The text of the breadcrumb trail is a `join` of their HTML
    representations.
8.  The generated HTML template includes the new page elements.

### Fine-Grained Site Flow

The [final
example](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/fine-grained-site-flow/H-W-NM-fine-grained-site-flow.pl)
modifies the site to have a more sophisticated site flow. [Looking at
the
changes](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/embellish-2-fine-grained-delta.diff)
shows several more additions. Their implications are:

1.  Both English resumés have a `'skip' => 1,` pair. This caused these
    pages to [appear in the navigation
    menu](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/fine-grained-site-flow/dest/me/resumes/),
    but not to be part of the traversal flow. Clicking "next" at that
    page will skip them both. Pressing "prev" at [the page that follows
    them](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/fine-grained-site-flow/dest/humour/)
    leads to the page that precedes them.
2.  The Humour section has its `'show_always'` attribute set, causing it
    to expand on all pages of the site.
3.  `'expand'` is a regular expression for the Software section. As a
    result, accessing [a page not specified in the navigation
    menu](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/fine-grained-site-flow/dest/perl/japhs/)
    but that matches that regular expression causes the Software section
    to expand there.
4.  [The software tools
    page](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/fine-grained-site-flow/dest/software-tools)
    entry has the attribute `'hide' => 1`. This removes it from the
    navigation menu but allows it to appear in the site flow. Clicking
    on "next" on [the preceding
    page](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/fine-grained-site-flow/dest/open-source/bits.html)
    will reach it.

### A CGI Script

Until now, the examples have demonstrated generating a set of static
HTML pages. The code can also run dynamically on a server. One approach
is to use the ubiquitous [CGI.pm](http://search.cpan.org/dist/CGI.pm/),
which comes bundled with Perl.

Converting to [the CGI
script](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/cgi-script/H-W-NM-serve.pl.html)
required [few
changes](http://web-cpan.berlios.de/modules/HTML-Widgets-NavMenu/article/examples/fine-grained-2-cgi.diff.html).
Inside of the page loop, the code checks if the page matches the CGI
path info (the path appended after the CGI script name). If so, the code
calls the `render_page()` function.

`render_page()` is similar to the rest of the loop except that it prints
the output to `STDOUT` *after* the CGI header. Finally, after the loop
ends, the code checks that it has found a page. If not, it displays an
error page.

Note that the way this script looks for a suitable page is suboptimal. A
better-engineered script might keep the page paths in a persistent hash
or other data structure from which to look up the path info.

### Conclusion

This article demonstrated how to use HTML::Widgets::NavMenu to maintain
navigation menus and organize site flow. Reading its documentation may
reveal other useful features. Now you no longer have an excuse for
lacking the niceties demonstrated here on your site. Happy hacking!

### Acknowledgments

Thanks to Diego Iastrubni, Aankehn, and chromatic (my editor) for giving
some useful commentary on early drafts of this document.


