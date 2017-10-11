{
   "draft" : null,
   "slug" : "/pub/2003/09/17/perlcookbook",
   "tags" : [
      "extracting-table-data",
      "making-simple-changes-to-elements-or-text",
      "nathan-torkington",
      "perl",
      "perl-cookbook",
      "templating-with-html-mason",
      "tom-christiansen"
   ],
   "date" : "2003-09-17T00:00:00-08:00",
   "description" : " Editor's note: In this third and final batch of recipes excerpted from Perl Cookbook, you'll find solutions and code examples for extracting HTML table data, templating with HTML::Mason, and making simple changes to elements or text. Sample Recipe: Extracting...",
   "categories" : "development",
   "thumbnail" : null,
   "title" : "Cooking with Perl, Part 3",
   "image" : null,
   "authors" : [
      "perldotcom"
   ]
}





*Editor's note: In this third and final batch of recipes excerpted from
[Perl
Cookbook](http://www.oreilly.com/catalog/perlckbk2/index.html?CMP=IL7015),
you'll find solutions and code examples for extracting HTML table data,
templating with HTML::Mason, and making simple changes to elements or
text.*

### Sample Recipe: Extracting Table Data

#### Problem

You have data in an HTML table, and you would like to turn that into a
Perl data structure. For example, you want to monitor changes to an
author's CPAN module list.

#### Solution

Use the HTML::TableContentParser module from CPAN:

    use HTML::TableContentParser;
    Â 
    $tcp = HTML::TableContentParser->new;
    $tables = $tcp->parse($HTML);
    Â 
    foreach $table (@$tables) {
      @headers = map { $_->{data} } @{ $table->{headers} };
      # attributes of table tag available as keys in hash
      $table_width = $table->{width};
    Â 
      foreach $row (@{ $tables->{rows} }) {
        # attributes of tr tag available as keys in hash
        foreach $col (@{ $row->{cols} }) {
          # attributes of td tag available as keys in hash
          $data = $col->{data};
        }
      }
    }

#### Discussion

The HTML::TableContentParser module converts all tables in the HTML
document into a Perl data structure. As with HTML tables, there are
three layers of nesting in the data structure: the table, the row, and
the data in that row.

Each table, row, and data tag is represented as a hash reference. The
hash keys correspond to attributes of the tag that defined that table,
row, or cell. In addition, the value for a special key gives the
contents of the table, row, or cell. In a table, the value for the
`rows` key is a reference to an array of rows. In a row, the `cols` key
points to an array of cells. In a cell, the `data` key holds the HTML
contents of the data tag.

For example, take the following table:

    <table width="100%" bgcolor="#ffffff">
      <tr>
        <td>Larry &amp; Gloria</td>
        <td>Mountain View</td>
        <td>California</td>
      </tr>
      <tr>
        <td><b>Tom</b></td>
        <td>Boulder</td>
        <td>Colorado</td>
      </tr>
      <tr>
        <td>Nathan &amp; Jenine</td>
        <td>Fort Collins</td>
        <td>Colorado</td>
      </tr>
    </table>

The `parse` method returns this data structure:

    [
      {
        'width' => '100%',
        'bgcolor' => '#ffffff',
        'rows' => [
                   {
                    'cells' => [
                                { 'data' => 'Larry &amp; Gloria' },
                                { 'data' => 'Mountain View' },
                                { 'data' => 'California' },
                               ],
                    'data' => "\n      "
                   },
                   {
                    'cells' => [
                                { 'data' => '<b>Tom</b>' },
                                { 'data' => 'Boulder' },
                                { 'data' => 'Colorado' },
                               ],
                    'data' => "\n      "
                   },
                   {
                    'cells' => [
                                { 'data' => 'Nathan &amp; Jenine' },
                                { 'data' => 'Fort Collins' },
                                { 'data' => 'Colorado' },
                               ],
                    'data' => "\n      "
                   }
                  ]
      }
    ]

The data tags still contain tags and entities. If you don't want the
tags and entities, remove them by hand using techniques from "Extracting
or Removing HTML Tags."

+-----------------------------------------------------------------------+
| <div class="secondary">                                               |
|                                                                       |
| #### Previous Articles in this Series                                 |
|                                                                       |
| â¢ [Cooking with Perl](/pub/a/2003/08/21/perlcookbook.html)\           |
| â¢ [Cooking with Perl, Part 2](/pub/a/2003/09/03/perlcookbook.html)    |
|                                                                       |
| </div>                                                                |
+-----------------------------------------------------------------------+

[Example
20-11](http://admin.oreillynet.com/catalog/perlckbk2/excerpts/ch20.html#77026)
fetches a particular CPAN author's page and displays in plain text the
modules they own. You could use this as part of a system that notifies
you when your favorite CPAN authors do something new.

**Example 20-11:** **Dump modules for a particular CPAN author**

      #!/usr/bin/perl -w
      # dump-cpan-modules-for-author - display modules a CPAN author owns
      use LWP::Simple;
      use URI;
      use HTML::TableContentParser;
      use HTML::Entities;
      use strict;
      our $URL = shift || 'http://search.cpan.org/author/TOMC/';
      my $tables = get_tables($URL);
      my $modules = $tables->[4];    # 5th table holds module data
      foreach my $r (@{ $modules->{rows} }) {
        my ($module_name, $module_link, $status, $description) = 
            parse_module_row($r, $URL);
        print "$module_name <$module_link>\n\t$status\n\t$description\n\n";
      } 
      sub get_tables {
        my $URL = shift;
        my $page = get($URL);
        my $tcp = new HTML::TableContentParser;
        return $tcp->parse($page);
      }
      sub parse_module_row {
        my ($row, $URL) = @_;
        my ($module_html, $module_link, $module_name, $status, $description);
        # extract cells
        $module_html = $row->{cells}[0]{data};  # link and name in HTML
        $status      = $row->{cells}[1]{data};  # status string and link
        $description = $row->{cells}[2]{data};  # description only
        $status =~ s{<.*?>}{  }g; # naive link removal, works on this simple HTML
        # separate module link and name from html
        ($module_link, $module_name) = $module_html =~ m{href="(.*?)".*?>(.*)<}i;
        $module_link = URI->new_abs($module_link, $URL); # resolve relative links
        # clean up entities and tags
        decode_entities($module_name);
        decode_entities($description);
        return ($module_name, $module_link, $status, $description);
      }

#### See Also

The documentation for the CPAN module HTML::TableContentParser;
<http://search.cpan.org/>

### Sample Recipe: Templating with HTML::Mason

### Problem

You want to separate presentation (HTML formatting) from logic (Perl
code) in your program. Your web site has a lot of components with only
slight variations between them. You'd like to abstract out common
elements and build your pages from templates without having a lot of "if
I'm in this page, then print this; else if I'm in some other page . . .
" conditional statements in a single master template.

#### Solution

Use HTML::Mason components and inheritance.

#### Discussion

HTML::Mason (also simply called Mason) offers the power of Perl in
templates. The basic unit of a web site built with Mason is the
component--a file that produces output. The file can be HTML, Perl, or a
mixture of both. Components can take arguments and execute arbitrary
Perl code. Mason has many features, documented at <http://masonhq.com/>
and in Embedding Perl in HTML with Mason by Dave Rolsky and Ken Williams
(O'Reilly; online at <http://masonbook.com/>).

Mason works equally well with CGI, mod\_perl, and non-web programs. For
the purposes of this recipe, however, we look at how to use it with
mod\_perl. The rest of this recipe contains a few demonstrations to give
you a feel for what you can do with Mason and how your site will be
constructed. There are more tricks, traps, and techniques for everything
we discuss, though, so be sure to visit the web site and read the book
for the full story.

##### Configuration

Install the HTML-Mason distribution from CPAN and add the following to
your *httpd.conf*:

    PerlModule HTML::Mason::ApacheHandler
    <Location /mason>
      SetHandler perl-script
      PerlHandler HTML::Mason::ApacheHandler
      DefaultType text/html
    </Location>

This tells mod\_perl that every URL that starts with `/mason` is handled
by Mason. So if you request `/mason/hello.html`, the file
*mason/hello.html* in your document directory will be compiled and
executed as a Mason component. The DefaultType directive lets you omit
the *.html* from component names.

Next create a directory for Mason to cache the compiled components in.
Mason does this to speed up execution.

    cd $SERVER_ROOT
    mkdir mason

Then make a *mason* directory for components to live in:

    cd $DOCUMENT_ROOT
    mkdir mason

Now you're ready for "Hello, World". Put this in *mason/hello*:

    Hello, <% ("World", "Puny Human")[rand 2] %>

Restart Apache and load up the *mason/hello* page. If you reload it, you
should see "Hello, World" and "Hello, Puny Human" randomly. If not, look
at the Mason FAQ (<http://www.masonhq.com/docs/faq/>), which answers
most commonly encountered problems.

##### Basic Mason syntax

There are four types of new markup in Mason components: substitutions,
Perl code, component calls, and block tags. You saw a substitution in
the "Hello World" example: `<% ...  %>` evaluates the contents as Perl
code and inserts the result into the surrounding text.

Perl code is marked with a `%` at the start of the line:

    % $now = localtime;   # embedded Perl
    This page was generated on <% $now %>.

Because substitutions can be almost any Perl code you like, this could
have been written more simply as:

    This page was generated on <% scalar localtime %>.

If either of these variations were saved in *footer.mas*, you could
include it simply by saying:

    <& footer.mas &>

This is an example of a component call--Mason runs the component and
inserts its result into the document that made the call.

Block tags define different regions of your component.
`<%perl> ... </%perl>` identifies Perl code. While `%` at the start of a
line indicates that just that line is Perl code, you can have any number
of lines in a `<%perl>` block.

A `<%init> ... </%init>` block is like an INIT block in Perl. The code
in the block is executed before the main body of code. It lets you store
definitions, initialization, database connections, etc. at the bottom of
your component, where they're out of the way of the main logic.

The `<%args> ... </%args>` block lets you define arguments to your
component, optionally with default values. For example, here's
*greet.mas*:

    <%args>
       $name => "Larry"
       $town => "Mountain View"
    </%args>
    Hello, <% $name %>.  How's life in <% $town %>?

Calling it with:

    <& greet.mas &>

emits:

    Hello, Larry.  How's life in Mountain View?

You can provide options on the component call:

    <& greet.mas, name => "Nat", town => "Fort Collins" &>

That emits:

    Hello, Nat.  How's life in Fort Collins?

Because there are default values, you can supply only some of the
arguments:

    <& greet.mas, name => "Bob" &>

That emits:

    Hello, Bob.  How's life in Mountain View?

Arguments are also how Mason components access form parameters. Take
this form:

    <form action="compliment">
      How old are you?  <input type="text" name="age"> <br />
      <input type="submit">
    </form>

Here's a *compliment* component that could take that parameter:

    <%args>
      $age
    </%args>
    Hi.  Are you really <% $age %>?  You don't look it!

##### Objects

All Mason components have access to a `$m` variable, which contains an
HTML::Mason::Request object. Methods on this object give access to Mason
features. For example, you can redirect with:

    $m->redirect($URL);

The `$r` variable is the mod\_perl request object, so you have access to
the information and functions of Apache from your Mason handlers. For
example, you can discover the client's IP address with:

    $ip = $r->connection->remote_ip;

##### Autohandlers

When a page is requested through Mason, Mason can do more than simply
execute the code in that page. Mason inspects each directory between the
component root and the requested page, looking for components called
*autohandler*. This forms a *wrapping chain*, with the top-level
autohandler at the start of the chain and the requested page at the end.
Mason then executes the code at the start of the chain. Each autohandler
can say "insert the output of the next component in the chain here."

Imagine a newspaper site. Some parts don't change, regardless of which
article you're looking at: the banner at the top, the random selection
of ads, the list of sections down the lefthand side. However, the actual
article text varies from article to article. Implement this in Mason
with a directory structure like this:

    /sports
    /sports/autohandler
    /sports/story1
    /sports/story2
    /sports/story3

The individual story files contain only the text of each story. The
autohandler builds the page (the banner, the ads, the navigation bar),
and when it wants to insert the content of the story, it says:

    % $m->call_next;

This tells Mason to call the next component in the chain (the story) and
insert its output here.

The technique of having a chain of components is called *inheritance*,
and autohandlers aren't the only way to do it. In a component, you can
designate a parent with:

    <%flags>
      inherit = 'parent.mas'
    </%flags>

This lets you have different types of content in the one directory, and
each contained component gets to identify its surrounding page (its
parent).

##### Dhandlers

Sometimes it's nice to provide the illusion of a directory full of
pages, when in reality they are all dynamically generated. For example,
stories kept in a database could be accessed through URLs like:

    /sports/1
    /sports/2
    /sports/3

The Mason way to dynamically generate the pages at these URLs is with a
component called *dhandler* in the *sports* directory. The *dhandler*
component accesses the name of the missing page (*123* in this case) by
calling:

    $m->dhandler_arg

You could then use this to retrieve the story from the database and
insert it into a page template.

#### See Also

Recipe 15.11 in mod\_perl Developer's Cookbook; Embedding Perl in HTML
with Mason; <http://www.masonhq.com/> and <http://www.masonbook.com/>

### Sample Recipe: Making Simple Changes to Elements or Text

### Problem

You want to filter some XML. For example, you want to make substitutions
in the body of a document, or add a price to every book described in an
XML document, or you want to change `<book  id="1">` to
`<book>  <id>1</id>`.

#### Solution

Use the XML::SAX::Machines module from CPAN:

    #!/usr/bin/perl -w
    Â 
    use MySAXFilter1;
    use MySAXFilter2;
    use XML::SAX::ParserFactory;
    use XML::SAX::Machines qw(Pipeline);
    Â 
    my $machine = Pipeline(MySAXFilter1 => MySAXFilter2); # or more
    $machine->parse_uri($FILENAME);

Write a handler, inheriting from XML::SAX::Base as in "Parsing XML into
SAX Events," then whenever you need a SAX event, call the appropriate
handler in your superclass. For example:

    $self->SUPER::start_element($tag_struct);

#### Discussion

A SAX filter accepts SAX events and triggers new ones. The
XML::SAX::Base module detects whether your handler object is called as a
filter. If so, the XML::SAX::Base methods pass the SAX events onto the
next filter in the chain. If your handler object is not called as a
filter, then the XML::SAX::Base methods consume events but do not emit
them. This makes it almost as simple to write events as it is to consume
them.

The XML::SAX::Machines module chains the filters for you. Import its
`Pipeline` function, then say:

    my $machine = Pipeline(Filter1 => Filter2 => Filter3 => Filter4);
    $machine->parse_uri($FILENAME);

SAX events triggered by parsing the XML file go to Filter1, which sends
possibly different events to Filter2, which in turn sends events to
Filter3, and so on to Filter4. The last filter should print or otherwise
do something with the incoming SAX events. If you pass a reference to a
typeglob, XML::SAX::Machines writes the XML to the filehandle in that
typeglob.

[Example
22-5](http://admin.oreillynet.com/catalog/perlckbk2/excerpts/ch22.html#45625)
shows a filter that turns the `id` attribute in `book` elements from the
XML document in Example 22-1 into a new `id` element. For example,
`<book id="1">` becomes `<book><id>1</id>`.

**[Example 22-5:]{#45625}** **filters-rewriteids**

    package RewriteIDs;
    # RewriteIDs.pm -- turns "id" attributes into elements
    Â 
    use base qw(XML::SAX::Base);
    Â 
    my $ID_ATTRIB = "{  }id";   # the attribute hash entry we're interested in
    Â 
    sub start_element {
        my ($self, $data) = @_;
    Â 
        if ($data->{Name} eq 'book') {
            my $id = $data->{Attributes}{$ID_ATTRIB}{Value};
            delete $data->{Attributes}{$ID_ATTRIB};
            $self->SUPER::start_element($data);
    Â 
            # make new element parameter data structure for the <id> tag
            my $id_node = {  };
            %$id_node = %$self;
            $id_node->{Name} = 'id';     # more complex if namespaces involved
            $id_node->{Attributes} = {  };
    Â 
            # build the <id>$id</id>
            $self->SUPER::start_element($id_node);
            $self->SUPER::characters({ Data => $id });
            $self->SUPER::end_element($id_node);
        } else {
            $self->SUPER::start_element($data);
        }
    }
    Â 
    1;

[Example
22-6](http://admin.oreillynet.com/catalog/perlckbk2/excerpts/ch22.html#15387)
is the stub that uses XML::SAX::Machines to create the pipeline for
processing *books.xml* and print the altered XML.

**[Example 22-6:]{#15387}** **filters-rewriteprog**

    #!/usr/bin/perl -w
    # rewrite-ids -- call RewriteIDs SAX filter to turn id attrs into elements
    Â 
    use RewriteIDs;
    use XML::SAX::Machines qw(:all);
    Â 
    my $machine = Pipeline(RewriteIDs => *STDOUT);
    $machine->parse_uri("books.xml");

The output of [Example
22-6](http://admin.oreillynet.com/catalog/perlckbk2/excerpts/ch22.html#15387)
is as follows (truncated for brevity):

    <book><id>1</id>
        <title>Programming Perl</title>
     ...
    <book><id>2</id>
        <title>Perl &amp; LWP</title>
     ...

To save the XML to the file *new-books.xml*, use the XML::SAX::Writer
module:

    #!/usr/bin/perl -w
    Â 
    use RewriteIDs;
    use XML::SAX::Machines qw(:all);
    use XML::SAX::Writer;
    Â 
    my $writer = XML::SAX::Writer->new(Output => "new-books.xml");
    my $machine = Pipeline(RewriteIDs => $writer);
    $machine->parse_uri("books.xml");

You can also pass a scalar reference as the `Output` parameter to have
the XML appended to the scalar; as an array reference to have the XML
appended to the array, one array element per SAX event; or as a
filehandle to have the XML printed to that filehandle.

#### See Also

The documentation for the modules XML::SAX::Machines and
XML::SAX::Writer


