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


Everyone wants to parse HTML, and many people reach for a regular expression to do that. Although you can [use a regex to parse HTML](http://stackoverflow.com/a/4234491/2766176), it's not as fun as my latest favorite way: [Mojo::DOM]({{<mcpan "Mojo::DOM" >}}) with CSS3 selectors. I find this much easier than trying to remember XPATH and I get to play with Mojo.

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

In the first example, I fetched `http://search.cpan.org/~bdfoy/'`, my author page at [CPAN Search](http://search.cpan.org/). I'll start with that HTML, assuming I already have it in a string.

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
<a data-target=".slidepanel" data-toggle="slidepanel" href="#">
<i class="fa fa-bars icon-slidepanel"></i></a>
<a href="/"><img alt="MetaCPAN icon" src="/static/icons/metacpan-icon.png">Home</a>
<a href="https://grep.metacpan.org"><i class="fa fa-search"></i>grep::cpan</a>
<a href="/recent"><i class="fa fa-history"></i>Recent</a>
<a href="/about"><i class="fa fa-info"></i>About</a>
<a href="/about/faq"><i class="fa fa-question"></i>FAQ</a>
...
```

That's a good start, but I extracted all of the links. I want to limit it to the links to my distributions. Looking at the HTML, I see that there is a table with id `author_releases`:

```perl
    <table  id="author_releases"
  data-default-sort="1,0"
  class="table table-condensed table-striped table-releases tablesorter">
    <thead>
    <tr>
      <th class="river-gauge"><span class="sr-only">River gauge</span></th>
      <th class="name pull-left-phone">Release</th>
      <th class="hidden-phone invisible no-sort"></th>
      <th class="date">Uploaded</th>
    </tr>
  </thead>
  <tbody>
```

I change my selector to look for the first anchor in the first table cell in a table row:

```perl
my $module_list = $dom
    ->find('table#author_releases tr td.name a.ellipsis')
    ->join("\n");

print $module_list;
```

Now I have a list of the links I want, but with the anchor HTML and text:

```perl
<a class="ellipsis" href="/release/App-Module-Lister" title="BDFOY/App-Module-Lister-0.153">App-Module-Lister-0.153</a>
<a class="ellipsis" href="/release/App-PPI-Dumper" title="BDFOY/App-PPI-Dumper-1.021">App-PPI-Dumper-1.021</a>
<a class="ellipsis" href="/release/App-scriptdist" title="BDFOY/App-scriptdist-0.242">App-scriptdist-0.242</a>
<a class="ellipsis" href="/release/App-unichar" title="BDFOY/App-unichar-0.012">App-unichar-0.012</a>
<a class="ellipsis" href="/release/App-url" title="BDFOY/App-url-1.004">App-url-1.004</a>
<a class="ellipsis" href="/release/Brick" title="BDFOY/Brick-0.228">Brick-0.228</a>
<a class="ellipsis" href="/release/Bundle-BDFOY" title="BDFOY/Bundle-BDFOY-20190721">Bundle-BDFOY-20190721</a>
```

I still have a bit of work to do. I want to extract the value of the `href` attribute. I can do that with the `map` method from [Mojo::Collection](http://mojolicio.us/perldoc/Mojo/Collection):

```perl
my $module_list = $dom
    ->find('table#author_releases tr td.name a.ellipsis')
    ->map( 'text' )
    ->join("\n");

print $module_list;
```

Each element in the collection is actually a [Mojo::DOM](http://mojolicio.us/perldoc/Mojo/DOM) object. The first argument to `map` is the method to call on each element and the remaining arguments pass through to that method. In this case, I'm calling `text` on each node to get the string between the opening and closing `A` tags. Now I have my list of distributions:

```perl
App-Module-Lister-0.153
App-PPI-Dumper-1.021
App-scriptdist-0.242
App-unichar-0.012
App-url-1.004
Brick-0.228
Bundle-BDFOY-20190721
Business-ISBN-3.005
Business-ISBN-Data-20191107
...
```

That's still as one string since I ended the method chain with `join("\n")`. To get a list, I use `each` to get the list, which I join myself later:

```perl
my @module_list = $dom
    ->find('table#author_releases tr td.name a.ellipsis')
    ->map( 'text' )
    ->each;

print join "\n", @module_list;
```

I could have also used `to_array` to get an array reference instead.

Instead of the distribution name with the version, I can break it up with [CPAN::DistnameInfo]({{<mcpan "CPAN::DistnameInfo" >}}). I'll turn every found link into a tuple of name and version. Since that module wants to deal with a distribution filename, I tack on *.tar.gz* to make it work out:

```perl
use CPAN::DistnameInfo;
use Mojo::Util qw(dumper);

my $dom = Mojo::DOM->new( $string );

my @module_list = $dom
    ->find('table#author_releases tr td.name a.ellipsis')
    ->map( 'text' )
    ->map( sub {
        my $d = CPAN::DistnameInfo->new( "$_.tar.gz" );
        [ map { $d->$_() } qw(dist version) ];
         } )
    ->each;

say dumper( \@module_list );
```

The `each` extracts each element from the collection and returns it. I use [Data::Printer]({{<mcpan "Data::Printer" >}}) to display the array:

```perl
[
  [
    "App-Module-Lister",
    "0.153"
  ],
  [
    "App-PPI-Dumper",
    "1.021"
  ],
  [
    "App-scriptdist",
    "0.242"
  ],
  [
    "App-unichar",
    "0.012"
  ],
  ...
]
```

If I want only the distributions that are beta versions (or whatever you want to call pre-1.0 releases), I can use [Mojo::Collection](http://mojolicio.us/perldoc/Mojo/Collection)'s `grep`:

```perl
my @module_list = $dom
    ->find('table#author_releases tr td.name a.ellipsis')
    ->map( 'text' )
    ->map( sub {
        my $d = CPAN::DistnameInfo->new( "$_.tar.gz" );
        [ map { $d->$_() } qw(dist version) ];
         } )
    ->grep( sub { $_->[-1] < 1 } )
    ->each;
```

The `grep` filters the collection for which the subroutine returns a true value:

```perl
[
[
  [
    "App-Module-Lister",
    "0.153"
  ],
  [
    "App-scriptdist",
    "0.242"
  ],
  [
    "App-unichar",
    "0.012"
  ],
  [
    "Brick",
    "0.228"
  ],
...
]
```

That's the process. No HTML shows up in my code. The rest is figuring out how to select the particular element that I want. If you are interesting in more [Mojo::Collection](http://mojolicio.us/perldoc/Mojo/Collection) examples, you can check out [Mojo Web Clients](https://leanpub.com/mojo_web_clients).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com). In it's original form, it worked with *search.cpan.org*, which had a different table and HTML. It was updated to work with MetaCPAN. See the [entire history of the article](https://github.com/tpf/perldotcom/blob/master/content/article/extracting-from-html-with-mojo--dom.md)*
