{
   "image" : "/images/143/BD58A4DE-973E-11E4-8923-CF4520B41B38.png",
   "categories" : "data",
   "draft" : false,
   "slug" : "143/2015/1/8/Extracting-from-HTML-with-Mojo--DOM",
   "thumbnail" : "/images/143/thumb_BD58A4DE-973E-11E4-8923-CF4520B41B38.png",
   "description" : "No HTML or regexes necessary",
   "authors" : [
      "brian-d-foy"
   ],
   "tags" : [
      "html",
      "mojolicious",
      "parse",
      "dom"
   ],
   "title" : "Extracting from HTML with Mojo::DOM",
   "date" : "2015-01-08T14:01:42"
}


Everyone wants to parse HTML, and many people reach for a regular expression to do that. Although you can [use a regex to parse HTML](http://stackoverflow.com/a/4234491/2766176), it's not as fun as my latest favorite way: [Mojo::DOM](http://www.metacpan.org/module/Mojo::DOM) with CSS3 selectors. I find this much easier than trying to remember XPATH and I get to play with Mojo.

The DOM is the ["Document Object Model"](http://www.w3.org/DOM/). Something behind the scenes parses and organizes the information and allows me to query it with questions such as "find all the `a` tags inside a `div` tag", or "find all the tags of a particular class". I don't manipulate the text myself.

If I'm using [Mojo::UserAgent](http://mojolicio.us/perldoc/Mojo/UserAgent), I can get a DOM object from the response object from an HTTP request:

```perl
use Mojo::UserAgent;
my $ua = Mojo::UserAgent->new;

my $dom = $ua->get( 'https://metacpan.org/author/BDFOY' )
    ->res
    ->dom;
```

The Mojo method-chaining style with one method per line shows its strengths as I get into more complicated tasks later.

I don't *have* to make a request to get a DOM object. I'm often presented with HTML files to parse with no server to give them to me. Depending on the tractability of the task, I might hand edit it to remove the parts I don't want to think about then use a regex to handle the rest. That way, I don't have to do a lot of work to save state and know where I am in the document. With a DOM, that's not a problem.

In the first example, I fetched `https://metacpan.org/author/BDFOY'`, my author page at [CPAN Search](https://metacpan.org/). I'll start with that HTML, assuming I already have it in a string.

```perl
use Mojo::DOM;

my $string = ...;

my $dom = Mojo::DOM->new( $string );

my $module_list = $dom
    ->find('a')
    ->join("\n");

print $module_list;
```

Once I have the `$dom` object, I can use `find` to select elements. I give `find` a [CSS3 selector](http://mojolicio.us/perldoc/Mojo/DOM/CSS#SELECTORS), in this case just `a` to find all the anchor links. `find` returns a [Mojo::Collection](="http://mojolicio.us/perldoc/Mojo/Collection") object, a fancy way to store a list and do things do it. The Mojolicious style makes heavy use of method chaining so it needs a way to call methods on the result. In this example, I merely `join` the elements with a newline. These are the results:

```perl
<a href="/"><img alt="CPAN" src="http://st.pimg.net/tucs/img/cpan_banner.png"></a>
<a href="/">Home</a>
<a href="/author/">Authors</a>
<a href="/recent">Recent</a>
<a href="http://log.perl.org/cpansearch/">News</a>
<a href="/mirror">Mirrors</a>
<a href="/faq.html">FAQ</a>
<a href="/feedback">Feedback</a>
<a href="Acme-BDFOY-0.01/">Acme-BDFOY-0.01</a>
<a href="/CPAN/authors/id/B/BD/BDFOY/Acme-BDFOY-0.01.tar.gz">Download</a>
<a href="/src/BDFOY/Acme-BDFOY-0.01/">Browse</a>
```

That's a good start, but I extracted all of the links. I want to limit it to the links to my distributions. Looking at the HTML, I see that the link I want is in the first `td` tag in a `tr`:

```perl
<tr class=s>
    <td><a href="Data-Constraint-1.17/">Data-Constraint-1.17</a></td>
    <td>prototypical value checking</td>
    <td><small>[<a href="/CPAN/authors/id/B/BD/BDFOY/Data-Constraint-1.17.tar.gz">Download</a>] [<a
      href="/src/BDFOY/Data-Constraint-1.17/">Browse</a>]</small></td>
    <td nowrap>26 Aug 2014</td>
   </tr>
```

I change my selector to look for the first anchor in the first table cell in a table row:

```perl
my $module_list = $dom
    ->find('tr td:first-child a:first-child')
    ->join("\n");
```

Now I have a list of the links I want, but with the anchor HTML and text:

```perl
<a href="Acme-BDFOY-0.01/">Acme-BDFOY-0.01</a>
<a href="Apache-Htaccess-1.4/">Apache-Htaccess-1.4</a>
<a href="Apache-iTunes-0.11/">Apache-iTunes-0.11</a>
<a href="App-Module-Lister-0.15/">App-Module-Lister-0.15</a>
<a href="App-PPI-Dumper-1.02/">App-PPI-Dumper-1.02</a>
```

I still have a bit of work to do. I want to extract the value of the `href` attribute. I can do that with the `map` method from [Mojo::Collection](http://mojolicio.us/perldoc/Mojo/Collection):

```perl
my $module_list = $dom
    ->find('tr td:first-child a:first-child')
    ->map( attr => 'href' )
    ->join("\n");
```

Each element in the collection is actually a [Mojo::DOM](http://mojolicio.us/perldoc/Mojo/DOM) object. The first argument to `map` is the method to call on each element and the remaining arguments pass through to that method. In this case, I'm calling `attr('href')` on each object. Now I mostly have the values I want:

```perl
Acme-BDFOY-0.01/
Apache-Htaccess-1.4/
Apache-iTunes-0.11/
App-Module-Lister-0.15/
App-PPI-Dumper-1.02/
```

I don't want that trailing slash. I can use another `map`, but with an anonymous subroutine. The result of the subroutine replaces the element in the collection. I use the [`/r` of the substitution operator to return the modified string](http://www.effectiveperlprogramming.com/2010/09/use-the-r-substitution-flag-to-work-on-a-copy/) instead of the number of substitutions (best Perl enhancement ever):

```perl
use v5.14;

my $module_list = $dom
    ->find('tr td:first-child a:first-child')
    ->map( attr => 'href' )
    ->map( sub { s|/\z||r } )
    ->join("\n");
```

Now I have my list of distributions:

```perl
Acme-BDFOY-0.01
Apache-Htaccess-1.4
Apache-iTunes-0.11
App-Module-Lister-0.15
App-PPI-Dumper-1.02
```

That's still as one string since I ended the method chain with `join("\n")`. To get a list, I use `each` to get the list, which I join myself later:

```perl
my @module_list = $dom
    ->find('tr td:first-child a:first-child')
    ->map( attr => 'href' )
    ->map( sub { s|/\z||r } )
    ->each;

print join "\n", @module_list;
```

I can get even fancier. Instead of the distribution name with the version, I can break it up with [CPAN::DistnameInfo](http://www.metacpan.org/module/CPAN::DistnameInfo). I'll turn every found link into a tuple of name and version. Since that module wants to deal with a distribution filename, I tack on *.tar.gz* to make it work out:

```perl
use Data::Printer;
use CPAN::DistnameInfo;

my $dom = Mojo::DOM->new( $string );

my @module_list = $dom
    ->find('tr td:first-child a:first-child')
    ->map( attr => 'href' )
    ->map( sub { s|/\z||r } )
    ->map( sub {
        my $d = CPAN::DistnameInfo->new( "$_.tar.gz" );
        [ map { $d->$_() } qw(dist version) ];
         } )
    ->each;

p @module_list;
```

The `each` extracts each element from the collection and returns it. I use [Data::Printer](https://metacpan.org/pod/Data::Printer) to display the array:

```perl
[
    [0]   [
        [0] "Acme-BDFOY",
        [1] 0.01
    ],
    [1]   [
        [0] "Apache-Htaccess",
        [1] 1.4
    ],
    [2]   [
        [0] "Apache-iTunes",
        [1] 0.11
    ],
    [3]   [
        [0] "App-Module-Lister",
        [1] 0.15
    ],
```

If I want only the distributions that are development versions, I can use [Mojo::Collection](http://mojolicio.us/perldoc/Mojo/Collection)'s `grep`:

```perl
my @module_list = $dom
    ->find('tr td:first-child a:first-child')
    ->map( attr => 'href' )
    ->map( sub { s|/\z||r } )
    ->map( sub {
        my $d = CPAN::DistnameInfo->new( "$_.tar.gz" );
        [ map { $d->$_() } qw(dist version) ];
         } )
    ->grep( sub { $_->[-1] =~ /_/ } )
    ->each;
```

The `grep` selects each element of the collection for which the subroutine returns a true value:

```perl
[
    [0]  [
        [0] "Brick",
        [1] "0.227_01"
    ],
    [1]  [
        [0] "Distribution-Guess-BuildSystem",
        [1] "0.12_02"
    ],
    [2]  [
        [0] "File-Fingerprint",
        [1] "0.10_02"
    ],
    [3]  [
        [0] "Geo-GeoNames",
        [1] "1.01_01"
    ],
```

That's the process. No HTML shows up in my code. The rest is figuring out how to select the particular element that I want.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
