{
   "authors" : [
      "david-farrell"
   ],
   "date" : "2014-05-09T03:14:01",
   "categories" : "data",
   "description" : "So simple a llama could do it",
   "image" : "/images/87/ECE462D6-FF2E-11E3-A828-5C05A68B9E16.jpeg",
   "tags" : [
      "cpan",
      "xml",
      "data",
      "parse",
      "old_site"
   ],
   "title" : "Parsing data couldn't be easier with XML::Dataset",
   "slug" : "87/2014/5/9/Parsing-data-couldn-t-be-easier-with-XML--Dataset",
   "draft" : false
}


*It's hard to believe that when it comes to XML parsing CPAN hasn't already got you covered, but [XML::Dataset](https://metacpan.org/pod/XML::Dataset) is a new module that fills a useful void. XML::Dataset let's you declare a plaintext data collection schema, and then goes and extracts the data for you, super fast. Read on to see how it works.*

### Requirements

The CPAN Testers results [show](http://matrix.cpantesters.org/?dist=XML-Dataset+0.006) that XML::Dataset v0.06 will run on any platform with Perl (down to 5.8.9). To install the module with CPAN, open up the terminal and type:

``` prettyprint
$ cpan XML::Dataset
```

### Your data, extracted

To use XML::Dataset you'll need some stringified XML source data and a data profile. A profile is just a plaintext schema which specifies the data you'd like to extract. Let's look at an example:

``` prettyprint
use strict;
use warnings;
use XML::Dataset;
use Data::Printer;

my $sample_data = q(<?xml version="1.0"?>
<colleagues>
    <colleague>
        <title>The Boss</title>
        <phone>+1 202-663-9108</phone>
    </colleague>
    <colleague>
        <title>Admin Assistant</title>
        <phone>+1 347-999-5454</phone>
        <email>inbox@the_company.com</email>
    </colleague>
    <colleague>
        <title>Minion</title>
        <phone>+1 792-123-4109</phone>
    </colleague>
</colleagues>);

my $sample_data_profile
    = q(colleagues
            colleague
                title   = dataset:colleagues
                email   = dataset:colleagues
                phone   = dataset:colleagues);

p parse_using_profile($sample_data, $sample_data_profile);
```

The code above declares a simple XML dataset ($sample\_data) and a data profile to extract the required data ($sample\_data\_profile). XML::Dataset requires every indented newline in the data profile to map to another nested level of the data set. Once we reach the data attributes we want to extract, we simply assign a dataset to them (dataset:colleagues).

XML::Dataset exports the "parse\_using\_profile" function which extracts the data using our data profile and returns a Perl data structure. We use [Data::Printer](https://metacpan.org/pod/Data::Printer) to print out the results. Running this code we get this output:

``` prettyprint
\ {
    colleagues   [
        [0] {
            phone   "+1 202-663-9108",
            title   "The Boss"
        },
        [1] {
            email   "inbox@the_company.com",
            phone   "+1 347-999-5454",
            title   "Admin Assistant"
        },
        [2] {
            phone   "+1 792-123-4109",
            title   "Minion"
        },
    ]
}
```

Note that XML::Dataset had no problem extracting the one email address that was present in the data, even though the other colleagues did not have that attribute. What if we wanted to collect emails and phone numbers, but in separate datasets? All we need to do is update $sample\_data\_profile with two datasets:

``` prettyprint
my $sample_data_profile
    = q(colleagues
            colleague
                title   = dataset:emails dataset:phones
                email   = dataset:emails
                phone   = dataset:phones);
```

Re-running the code, XML::Dataset now produces two datasets for us:

``` prettyprint
\ {
    emails   [
        [0] {
            title   "The Boss"
        },
        [1] {
            email   "inbox@the_company.com",
            title   "Admin Assistant"
        },
        [2] {
            title   "Minion"
        }
    ],
    phones   [
        [0] {
            phone   "+1 202-663-9108",
            title   "The Boss"
        },
        [1] {
            phone   "+1 347-999-5454",
            title   "Admin Assistant"
        },
        [2] {
            phone   "+1 792-123-4109",
            title   "Minion"
        }
    ]
}
```

### A real example

Let's write a program to parse a a more realistic data set. Many websites provide a sitemap that lists all of the content on the website, and when it was last updated. This information is used by search engines to optimize their crawling routines. The sitemap has a defined xml format, so it's a cinch to parse it with XML::Dataset:

``` prettyprint
use strict;
use warnings;
use XML::Dataset;
use Data::Printer;
use HTTP::Tiny;

my $url = 'http://perltricks.com/sitemap.xml';

my $sitemap_data 
    = HTTP::Tiny->new->get($url)->{content};

my $sitemap_data_profile
    = q(urlset
            url
                loc     = dataset:sitemap_locations_modified
                lastmod = dataset:sitemap_locations_modified);

p parse_using_profile($sitemap_data, $sitemap_data_profile);
```

The code above downloads the PerlTricks.com sitemap using [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny) and extracts every URL and last modified timestamp from the sitemap. Running the code, we get this output:

``` prettyprint
\ {
    sitemap_locations_modified   [
        [0]  {
            lastmod   "2014-05-09",
            loc       "http://perltricks.com/"
        },
        [1]  {
            lastmod   "2013-03-24",
            loc       "http://perltricks.com/article/1/2013/3/24/3-quick-ways-to-find-out-the-version-number-of-an-installed-Perl-module-from-the-terminal"
        },
        [2]  {
            lastmod   "2013-03-27",
            loc       "http://perltricks.com/article/3/2013/3/27/How-to-cleanly-uninstall-a-Perl-module"
        },
        ...
    ]
}
```

No problem! We could re-use that same program to download and parse any sitemap on the Internet.

### Conclusion

XML::Dataset is fantastic for extracting fixed data schemas from XML. The plaintext data profiles are so easy to use, a non-programmer could write them. XML::Dataset is also fast: under the hood it uses XML::LibXML (and a few optimizations) and could be adapted for well-formatted HTML. It has great [documentation](https://metacpan.org/pod/XML::Dataset) and offers some advanced features like partial dataset parse dispatching. Module author James Spurin deserves credit for producing a quality module and a welcome addition to CPAN's XML namespace.

*Do you have a much-loved CPAN module that you'd like us to cover? Drop us an [email](mailto:perltricks.com@gmail.com)*

*Cover image [©](https://creativecommons.org/licenses/by/2.0/) [Duncun Hull](https://www.flickr.com/photos/dullhunk/3948166814/in/photolist-71TorC-5RcLVC-5RcLk1-5R8vpe-5RcMC9-5R8w7D-5R8v7e-5RcM9Q-5RcLeL-5R8upk-5RcMso-5RcL7J-72QCEU-7KoKym-72QCsE-6FtTJ-6m6pyB-5AJCpY-6FvjN-6FuLy-6FtQL-6Fv4J-5BHeXd-6FuUe-6FtXH-6Fu9t-6FuAs-5AJCs3-5AJCsd-5AJCro-tS2dS-6kzkkD-6kDvjQ-6kDAtY-6kDvzS-6kD45L-6kzqYM-6kDvsE-6kDuys-6kDvcE-6m6prT-6kDupU-6kDuWw-6kDv6j-6kzkd2-6kDALo-5AJCsA-CJhVy-5AJCrN-5MzAkw)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
