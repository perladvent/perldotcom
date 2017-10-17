{
   "title" : "HTML pro-parsing tips",
   "slug" : "101/2014/7/10/HTML-pro-parsing-tips",
   "tags" : [
      "html",
      "xml",
      "parse",
      "web",
      "libxml2",
      "scrape",
      "xml_libxml",
      "old_site"
   ],
   "image" : null,
   "date" : "2014-07-10T12:33:45",
   "categories" : "data",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "description" : "A few tips for parsing HTML with XML::LibXML"
}


*Perl has some fantastic modules for parsing HTML and one of the best is XML::LibXML. It's an interface to the libxml2 C library; super fast but also super-picky. I've often found XML::LibXML croaking on relatively simple - but incorrectly formed HTML. If you find this, do not give up! This article shares 3 simple techniques for overcoming malformed HTML when parsing with XML::LibXML.*

### Tip 1: turn on recovery mode

If XML::LibXML is croaking on a later part of the HTML, try turning on recovery mode, which will return all of the correctly parsed HTML up until XML::LibXML encountered the error.

``` prettyprint
use XML::LibXML;

my $xml = XML::LibXML->new( recover => 1 );
my $dom = $xml->load_html( string => $html );
```

With recovery mode set to 1, the parser will still warn about parsing errors. To suppress the warnings, set recover to 2.

### Tip 2: sanitize the input first with HTML::Scrubber

Sometimes recovery mode alone is not enough - XML::LibXML will croak at the first whiff of HTML if there are two doctype declarations for example. In these situations, consider sanitizing the HTML with [HTML::Scrubber](https://metacpan.org/pod/HTML::Scrubber).

HTML::Scrubber provides both whitelist and blacklist functions to include or exclude HTML tags and attributes. It's a powerful combination which allows you to create a custom filter to scrub the HTML that you want to parse.

By default HTML::Scrubber removes all tags, but in the case of a duplicate doctype declaration, you just need that one tag removed. Let's remove all div tags too for good measure:

``` prettyprint
use HTML::Scrubber;

my $scrubber = HTML::Scrubber->new( deny => [ 'doctype', 'div' ],
                                    allow=> '*' );
my $scrubbed_html = $scrubber->scrub($html);
my $dom = XML::LibXML->load_html( string => $scrubbed_html );
```

The "deny" rule sets the scrubber blacklist (what to exclude) and the "allow" rule specifies the whitelist (what to include). Here we passed an asterisk ("\*") to allow, which means allow everything, but because we're denying div and doctype tags, they'll be removed.

### Tip 3: extract a subset of data with a regex capture

If the subset HTML you want to parse has a unique identifier (such as an id attribute), consider using a regex capture to extract it from the HTML document. You can then scrub or immediately parse this subset with XML::LibXML.

For example recently I had to extract an HTML table from a badly-formed web page. Fortunately the table had an id attribute, which made extracting it with a regex a piece-of-cake:

``` prettyprint
if ( $html =~ /(<table id="t2">.*?<\/table>)/s ) {
    my $dom = XML::LibXML->load_html( string => $1 );
    ...
}
```

Note the use of the "s" modifier in the regex to match multiline. Many HTML pages contain newlines and you don't want your match fail because of that.

### Conclusion

Hopefully these tips will make parsing HTML with XML::LibXML easier. My GitHub account has a web scraper [script](https://gist.github.com/sillymoose/998b9199007589199dce#file-get_swift_code-pl-L42) that uses some of these tips. If you're looking for an entirely different approach to parsing HTML, check out [XML::Rabbit](https://metacpan.org/pod/XML::Rabbit) and [HTML::TreeBuilder](https://metacpan.org/pod/HTML::TreeBuilder).

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F101%2F2014%2F7%2F10%2FHTML-pro-parsing-tips&text=HTML+pro-parsing+tips&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F101%2F2014%2F7%2F10%2FHTML-pro-parsing-tips&via=perltricks) about it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
