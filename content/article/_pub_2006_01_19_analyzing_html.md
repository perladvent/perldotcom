{
   "image" : null,
   "authors" : [
      "kendrew-lau"
   ],
   "categories" : "Web",
   "tags" : [
      "html-assignments-perl-html",
      "parsing-html",
      "perl-assignments",
      "perl-parsing"
   ],
   "date" : "2006-01-19T00:00:00-08:00",
   "slug" : "/pub/2006/01/19/analyzing_html.html",
   "title" : "Analyzing HTML with Perl",
   "draft" : null,
   "thumbnail" : "/images/_pub_2006_01_19_analyzing_html/111-analyzing_html.gif",
   "description" : " Routine work is all around us every day, no matter if you like it or not. For a teacher on computing subjects, grading assignments can be such work. Certain computing assignments aim at practicing operating skills rather than creativity,..."
}





Routine work is all around us every day, no matter if you like it or
not. For a teacher on computing subjects, grading assignments can be
such work. Certain computing assignments aim at practicing operating
skills rather than creativity, especially in elementary courses. Grading
this kind of assignment is time-consuming and repetitive, if not
tedious.

In a business information system course that I taught, one lesson was
about writing web pages. As the course was the first computing subject
for the students, we used [Nvu](http://www.nvu.com/), a WYSIWYG web page
editor, rather than coding the HTML. One class assignment required
writing three or more inter-linked web pages containing a list of HTML
elements.

Write three or more web pages having the following:

-   Italicized text (2 points)
-   Bolded text (2 points)
-   Three different colors of text (5 points)
-   Three different sizes of text (5 points)
-   Linked graphics with border (5 points)
-   Linked graphics without border (5 points)
-   Non-linked graphics with border (3 points)
-   Non-linked graphics without border (2 points)
-   Three external links (5 points)
-   One horizontal line--not full width of page (5 points)
-   Three internal links to other pages (10 points)
-   Two tables (10 points)
-   One bulleted list (5 points)
-   One numerical list (5 points)
-   Non-default text color (5 points)
-   Non-default link color (2 points)
-   Non-default active link color (2 points)
-   Non-default visited link color (2 points)
-   Non-default background color (5 points)
-   A background image (5 points)
-   Pleasant appearance in the pages (10 points)

Beginning to grade the students' work, I found it monotonous and
error-prone. Because the HTML elements could be in any of the pages, I
had to jump to every page and count the HTML elements in question. I
also needed to do it for each element in the requirement. While some
occurrences were easy to spot in the rendered pages in a browser, others
required close examination of the HTML code. For example, a student
wrote a horizontal line (`<hr>` element) extending 98 percent of the
width of the window, which was difficult to differentiate visually from
a full-width horizontal line. Some other students just liked to use
black and dark gray as two different colors in different parts of the
pages. In addition to locating the elements, awarding and totaling marks
were also error-prone.

I felt a little regret on the flexibility in the requirement. If I had
fixed the file names of the pages and assigned the HTML elements to
individual pages, grading could have been easier. Rather than continuing
the work with regret, I wrote a Perl program to grade the assignments.
The program essentially parses the web pages, awards marks according to
the requirements, writes basic comments, and calculates the total score.

### Processing HTML with Perl

Perl's regular expressions have excellent text processing capability and
there are handy modules for parsing web pages. The module
[`HTML::TreeBuilder`](http://search.cpan.org/perldoc?HTML::TreeBuilder)
provides a HTML parser that builds a tree structure of the elements in a
web page. It is easy to create a tree and build its content from a HTML
file:

    $tree = HTML::TreeBuilder->new;
    $tree->parse_file($file_name);

Nodes in the tree are
[`HTML::Element`](http://search.cpan.org/perldoc?HTML::Element) objects.
There are plenty of methods with which to access and manipulate elements
in the tree. When you finish using the tree, destroy it and free the
memory it occupied:

    $tree->delete;

The module `HTML::Element` represents HTML elements in tree structures
created by `HTML::TreeBuilder`. It has a huge number of methods for
accessing and manipulating the element and searching for descendants
down the tree or ancestors up the tree. The method `find()` retrieves
all descending elements with one or more specified tag names. For
example:

    @elements = $element->find('a', 'img');

stores all `<a>` and `<img>` elements at or under `$element` to the
array `@elements`. The method `look_down()` is a more powerful version
of `find()`. It selects descending elements by three kinds of criteria:
exactly specifying an attribute's value or a tag name, matching an
attribute's value or tag name by a regular expression, and applying a
subroutine that returns true on examining desired elements. Here are
some examples:

    @anchors = $element->look_down('_tag' => 'a');

retrieves all `<a>` elements at or under `$element` and stores them to
the array `@anchors`.

    @colors = $element->look_down('style' => qr/color/);

selects all elements at or under `$element` having a `style` attribute
value that contains `color`.

    @largeimages = $element->look_down(
        sub {
             $_[0]->tag() eq 'img'          and
            ($_[0]->attr('width') > 100 or
             $_[0]->attr('height')  > 100)
        }
    );

locates at or under `$element` all images (`<img>` elements) with widths
or heights larger than 100 pixels. Note that this code will produce a
warning message on encountering an `<img>` element that has no `width`
or `height` attribute.

You can also mix the three kinds of criteria into one invocation of
`look_down`. The last example could also be:

    @largeimages = $element->look_down(
        '_tag'   => 'img',
        'width'  => qr//,
        'height' => qr//,
        sub { $_[0]->attr('width')  > 100 or
              $_[0]->attr('height') > 100 }
    );

This code also caters for any missing `width` or `height` attribute in
an `<img>` element. The parameters `'width' => qr//` and
`'height' => qr//` guarantee selection of only those `<img>` elements
that have both `width` or `height` attributes. The code block checks
these for the attribute values, when invoked.

The method `look_up()` looks for ancestors from an element by the same
kinds of criteria of `look_down()`.

### Processing Multiple Files

These methods provide great HTML parsing capability to grade the web
page assignments. The grading program first builds the tree structures
from the HTML files and stores them in an array `@trees`:

    my @trees;
    foreach (@files) {
        print "  building tree for $_ ...\n" if $options{v};
        my $tree = HTML::TreeBuilder->new;
        $tree->parse_file($_);
        push( @trees, $tree );
    }

The subroutine `doitem()` iterates through the array of trees, applying
a pass-in code block to look for particular HTML elements in each tree
and accumulating the results of calling the code block. To provide
detailed information and facilitate debugging during development, it
calls the convenience subroutine `printd()` to display the HTML elements
found with their corresponding file name when the verbose command line
switch (`-v`) is set. Essentially, the code invokes this subroutine once
for each kind of element in the requirement.

    sub doitem {
        my $func = shift;
        my $num  = 0;
        foreach my $i ( 0 .. $#files ) {
            my @elements = $func->( $files[$i], $trees[$i] );
            printd $files[$i], @elements;
            $num += @elements;
        }
        return $num;
    }

The code block passed into `doitem` is a subroutine that takes two
parameters of a file name and its corresponding HTML tree and returns an
array of selected elements in the tree. The following code block
retrieves all HTML elements in italic, including the `<i>` elements (for
example, `<i>text</i>`) and elements with a `font-style` of `italic`
(for example, `<span STYLE="font-style: italic">text</span>`).

    $n = doitem sub {
        my ( $file, $tree ) = @_;
        return ( $tree->find("i"),
            $tree->look_down( "style" => qr/font-style *: *italic/ ) );
        };

    marking "Italicized text (2 points): "
      . ( ( $n > 0 ) ? "good. 2" : "no italic text. 0"
    );

Two points are available for any italic text in the pages. The `marking`
subroutine records grading in a string. At the end of the program,
examining the string helps to calculate the total points.

Other requirements are marked in the same manner, though some selection
code is more involved. A regular expression helps to select elements
with non-default colors.

    my $pattern = qr/(^|[^-])color *: *rgb\( *[0-9]*, *[0-9]*, *[0-9]*\)/;
    return $tree->look_down(
        "style" => $pattern,
        sub { $_[0]->as_trimmed_text ne "" }
    );

Nvu applies colors to text by the `color` style in the form of
`rgb(R,G,B)` (for example,
`<span STYLE="color: rgb(0, 0, 255);">text</span>`). The above code is
slightly stricter than the italic code, as it also requires an element
to contain some text. The method `as_trimmed_text()` of `HTML::Element`
returns the textual content of an element with any leading and trailing
spaces removed.

Nested invocations of `look_down()` locate linked graphics with a
border. This selects any link (an `<a>` element) that encloses an image
(an `<img>` element) that has a border.

    return $tree->look_down(
        "_tag" => "a",
        sub {
           $_[0]->look_down( "_tag" => "img", sub { hasBorder( $_[0] ) } );
        }
    );

Finding non-linked graphics is more interesting, as it involves both the
methods `look_down()` and `look_up()`. It should only find images
(`<img>` elements) that do not have a parent link (a `<a>` element) up
the tree.

    return $tree->look_down(
        "_tag" => "img",
        sub { !$_[0]->look_up( "_tag" => "a" ) and hasBorder( $_[0] ); }
    );

Checking valid internal links requires passing `look_down()` a code
block that excludes common external links by checking the `href` value
against protocol names, and verifies the existence of the file linked in
the web page.

    use File::Basename;
    $n = doitem sub {
        my ( $file, $tree ) = @_;
        return $tree->look_down(
            "_tag" => "a",
            "href" => qr//,
            sub {
                !( $_[0]->attr("href") =~ /^ *(http:|https:|ftp:|mailto:)/)
                and -e dirname($file) . "/" . decodeURL( $_[0]->attr("href") );
            }
        );
    };

Nvu changes a page's text color by specifying the color components in
the style of the `body` tag, like
`<body style="color: rgb(0, 0, 255);">`. A regular expression matches
the style pattern and retrieves the three color components. Any non-zero
color component denotes a non-default text color in a page.

    my $pattern = qr/(?:^|[^-])color *: *rgb\(( *[0-9]*),( *[0-9]*),( *[0-9]*)\)/;
    return $tree->look_down(
        "_tag"  => "body",
        "style" => qr//,
        sub {
            $_[0]->attr("style") =~ $pattern and
            ( $1 != 0 or $2 != 0 or $3 != 0 );
        }
    );

With proper use of the methods `look_down()`, `look_up()`, and
`as_trimmed_text()`, the code can locate and mark the existence of
various required elements and any broken elements (images, internal
links, or background images).

### Finishing Up

The final requirement of the assignment is a pleasant look of the
rendered pages. Unfortunately, `HTML::TreeBuilder` and its related
modules do not analyze and quantify the visual appearance of a web page.
Neither does any module that I know. OK, I would award marks for the
appearance myself but still want Perl to help in the process--the
program sets the default score and comment, and allows overriding them
in flexible way. By using alternative regular expressions, I can accept
the default, override the score only, or override both the score and
comment.

    my $input = "";
    do {
        print "$str1 [$str2]: ";
        $input = <STDIN>;
        $input =~ s/(^\s+|\s+$)//g;
    } until ( $input =~ /(.*\.\s+\d+$|^\s*$|^\d+$)/ );

    $input = $str2 if $input eq "";
    if ( $input =~ /^\d+$/ ) {
        $n = $input;
        if ( $n == 10 ) {
            $input = "good looking, nice content. $n";
        }
        else {
            ( $input = $str2 ) =~ s/(\.\s*)\d+\s*$/$1$n/;
        }
    }
    marking "$str1 $input";

Finally, the code examines the marking text string containing comments
and scores for each requirement to calculate the total score of the
assignment. Each line in that string is in a fixed format (for example,
`"Italicized text (2 points): good. 0"`). Again, regular expressions
retrieve and accumulate the maximum and awarded points.

    my ( $total, $score ) = ( 0, 0 );
    while ( $marktext =~ /.*?\((\d+)\s+points\).*?\.\s+(\d+)/g )
    {
        $total += $1;
        $score += $2;
    }
    marking "Total ($total points): $score";

Depending on the command-line switches, the program may start a browser
to show the first page so that I can look at the pages' appearance. It
can also optionally write the grading comments and score to a text file
which can be feedback for the student.

I can simply run the program in the directory containing the HTML files,
or specify the set of HTML files in the command-line arguments. In the
best case, I just let it grade the requirements and press `Enter` to
accept the default marking for the appearance, and then jot down the
total score and email the grading text file to the student.

### Conclusion

I did not evaluate the time saved by the program against its developing
effort. Anyway, the program makes the grading process more accurate and
less prone to error, and it is more fun to spend time writing a Perl
program and getting familiar with useful modules.

In fact, there are many other modules that could have been used in the
program to provide even more automation. Had I read Wasserman's article
"[Automating Windows Applications with
Win32::OLE](/pub/a/2005/04/21/win32ole.html)," the program would record
the final score to an Excel file automatically. In addition, networking
modules such as
[`Mail::Internet`](http://search.cpan.org/perldoc?Mail::Internet),
[`Mail::Mailer`](http://search.cpan.org/perldoc?Mail::Mailer), and
[`Mail::Folder`](http://search.cpan.org/perldoc?Mail::Folder) could
retrieve the assignment files from emails and send the feedback files to
the students directly from the program.


