{
   "description" : "PPI::Prettify makes pretty-printing Perl code as HTML easy",
   "draft" : false,
   "categories" : "web",
   "authors" : [
      "david-farrell"
   ],
   "title" : "Display beautiful Perl code in HTML without JavaScript",
   "image" : null,
   "date" : "2014-01-13T01:34:32",
   "tags" : [
      "module",
      "syntax",
      "html",
      "javascript",
      "old_site"
   ],
   "slug" : "60/2014/1/13/Display-beautiful-Perl-code-in-HTML-without-JavaScript"
}


*Would you like to display beautiful syntax-highlighted Perl code on the web without using JavaScript? Maybe you'd like to use an existing [CSS markup theme](http://google-code-prettify.googlecode.com/svn/trunk/styles/index.html) without having to write in-line CSS in your Perl code? If yes, take a look at [PPI::Prettify](https://metacpan.org/pod/PPI::Prettify).*

### Background

The [prettify.js](https://code.google.com/p/google-code-prettify/) library does a wonderful job of robustly syntax coloring a large number of different languages for displaying code on the web. It's used on blogs.perl.org; we use it on PerlTricks.com. But because Perl is an ambiguous language, prettify.js often doesn't tokenize all of the code correctly. What's worse is if a user has JavaScript disabled, the code will not be highlighted at all. That's why I wrote [PPI::Prettify](https://metacpan.org/pod/PPI::Prettify). It runs in the backend using PPI::Document so it's faster more accurate than prettify.js, but outputs the same HTML codes as prettify.js does, enabling you to re-use any of the existing CSS themes available ([here](http://google-code-prettify.googlecode.com/svn/trunk/styles/index.html), [here](%0Ahttp://jmblog.github.io/color-themes-for-google-code-prettify/) and [here](%0Ahttp://stanleyhlng.com/prettify-js/#theme-bootstrap-light) for example).

### Requirements

You'll need PPI::Prettify and can install it via CPAN at the terminal:

``` prettyprint
$ cpan PPI::Prettify
```

In terms of OS compatibility, PPI::Prettify is pure-Perl so you should be able to run it on any platform that has Perl installed.

### Tokenizing inline Perl code

PPI::Prettify exports a prettify() method that takes a string of Perl code, and returns it tokenized with \<span\> tags. To be safe, PPI::Prettify employs HTML encoding on all token content. Let's whip up a quick script to demo prettify():

``` prettyprint
use warnings;
use strict;
use PPI::Prettify;

read(main::DATA, my $code, 500);

print prettify({ code => $code });

__DATA__
# a simple OO class

package Shape;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color  => $args->{color} || 'black',
        length => $args->{length} || 1,
        width  => $args->{width} || 1,
    };
    return bless $self, $class;
}

sub get_area {
    my $self = shift;
    return $self->{length} * $self->{width};
}

sub get_color {
    my $self = shift;
    return $self->{color};
}

sub set_color {
    my ($self, $color) = @_;
    $self->{color} = $color;
}

1;
```

The script uses the [\_\_DATA\_\_](http://perltricks.com/article/24/2013/5/11/Perl-tokens-you-should-know) token to create a filehandle to some inline Perl code (The code is a simple OO example taken from our article [Old School Object Oriented Perl](http://perltricks.com/article/25/2013/5/20/Old-School-Object-Oriented-Perl)). The read function slurps the filehandle contents into $code. We then use the prettify() function to tokenize and markup the Perl code.

Running that script returns the Perl code surrounded by \<span\> tags. This is a summary of the markup produced by prettify():

``` prettyprint
<pre class="prettyprint"><span class="com"># a simple OO class
</span><span class="pln">
</span><span class="kwd">package</span><span class="pln"> </span><span class="atn">Shape</span><span class="pln">;</span>
...
</pre>
```

The example below shows how the markup looks in HTML (using the [desert](http://code.google.com/p/google-code-prettify/source/browse/trunk/styles/desert.css?r=198) CSS theme).

``` prettyprint
# a simple OO class

package Shape;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color  => $args->{color} || 'black',
        length => $args->{length} || 1,
        width  => $args->{width} || 1,
    };
    return bless $self, $class;
}

sub get_area {
    my $self = shift;
    return $self->{length} * $self->{width};
}

sub get_color {
    my $self = shift;
    return $self->{color};
}

sub set_color {
    my ($self, $color) = @_;
    $self->{color} = $color;
}

1;
```

Two things to note here: disabling JavaScript will have no effect on the syntax highlighting above, as it's generated in backend using PPI::Prettify. Second, the code displays multiline comments correctly, (everything after [\_\_DATA\_\_](http://perltricks.com/article/24/2013/5/11/Perl-tokens-you-should-know)) unlike prettify.js.

### Tokenizing Perl code stored in a file

It's easy to prettify existing Perl code from a file. You can do this in one line of Perl at the terminal:

``` prettyprint
$ perl -MPPI::Prettify -MFile::Slurp -e '$code=read_file("output");print prettify({code=>$code})'
```

### Advanced feature 1: debug mode

The prettify() method also takes an optional debug parameter:

``` prettyprint
my $html = prettify({ code => $code, debug => 1 });
```

Debug mode will provide the same output, however every tag will be given a "title" attribute with the original PPI::Token class as the value. This can help you to understand how the original PPI::Token class maps to the markup by hovering the cursor over the text. The code from earlier has been printed with debug mode turned on. Try hovering!

``` prettyprint
# a simple OO class

package Shape;

sub new {
    my ($class, $args) = @_;
    my $self = {
        color  => $args->{color} || 'black',
        length => $args->{length} || 1,
        width  => $args->{width} || 1,
    };
    return bless $self, $class;
}

sub get_area {
    my $self = shift;
    return $self->{length} * $self->{width};
}

sub get_color {
    my $self = shift;
    return $self->{color};
}

sub set_color {
    my ($self, $color) = @_;
    $self->{color} = $color;
}

1;
```

### Advanced feature 2: override the mapping

You may want to change how certain tokens of Perl code are marked up. PPI::Prettify exports the mapping in a hashref, called $MARKUP\_RULES. Every PPI::Token class is a key, with the value being the CSS class name that prettify.js uses (and the prettify CSS themes expect). For example PPI::Token::Comment is mapped to "com":

``` prettyprint
'PPI::Token::Comment' => 'com'
```

Combined with debug mode, it should be straightforward to change the mapping of a particular PPI::Token class to the prettify class you require.

### Alternatives

Consider using Adam Kennedy's [PPI::HTML](https://metacpan.org/pod/PPI::HTML) if you are happy writing inline-CSS in your Perl code, or need more detailed markup than the 10 or so classes provided by PPI::Prettify. It's a more mature module and can do line numbering too.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
