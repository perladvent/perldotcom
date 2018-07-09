{
   "thumbnail" : "/images/_pub_2006_06_01_fear-api/111-FEAR-less.gif",
   "tags" : [
      "domain-specific-languages",
      "dsl",
      "fear",
      "fear-api",
      "web-robots",
      "web-scraping",
      "web-spiders"
   ],
   "date" : "2006-06-01T00:00:00-08:00",
   "image" : null,
   "title" : "FEAR-less Site Scraping",
   "categories" : "web",
   "slug" : "/pub/2006/06/01/fear-api.html",
   "description" : " Imagine that you have an assignment that you need to fetch all of the web pages of a given website, scrape data from them, and transfer the data to another place, such as a database or plain files. This...",
   "draft" : null,
   "authors" : [
      "yung-chung-lin"
   ]
}



Imagine that you have an assignment that you need to fetch all of the web pages of a given website, scrape data from them, and transfer the data to another place, such as a database or plain files. This is a common scenario for data scraping tasks, and CPAN has plenty of modules for this job.

While I was developing site-scraping scripts, retrieving data from some sites of the same type, I realized that I had repeated many identical or very similar code structures, such as:

      fetch_the_homepage();

      while(there_are_some_more_unfetched_links){
         foreach $link (@{links_in_the_current_page}){
             follow_link()          if $link =~ /NEXT_PAGE_OR_SOMETHING/;
             extract_product_spec() if $link =~ /PRODUCT_SPEC_PAGE/;
         }
      }

### The Usual Tools

At the very beginning, I created scripts using `LWP::Simple`, `LWP::UserAgent`, and vanilla regular expressions to extract links and produce details. As the number of scripts grew, I needed more powerful resources, so I started to use `WWW::Mechanize` for web page fetching and `Regexp::Bind`, `Template::Extract`, `HTML::LinkExtractor`, `Regexp::Common`, etc. for data scraping. However, then I still found many redundancies.

A scraping script first needs to use essential modules for the site scraping task. Second, it may need to instantiate objects. Third, site scraping involves many interactions among different modules, mostly by passing data between them. After you fetch a page, you may need to pass the page to `HTML::LinkExtractor` to extract links, to `Template::Extract` to get detailed information, or save it to a file. You may then store extracted data in a relational database. Considering these properties, creating a site scraping script is very time-consuming, and sometimes it makes a lot of duplication.

Thus, I tried to fuse some modules together, hoping to save some of my keystrokes and simplify the coding process.

### An Example using `WWW::Mechanize` and `Template::Extract`

Here's a typical site scraping script structure:

         use YAML;
         use Data::Dumper;
         use WWW::Mechanize;
         use Template::Extract;

         my $mech = WWW::Mechanize->new();
         $mech->get( "http://metacpan.org" );

         my $ext = Template::Extract->new;

         my @result = $ext->extract($template, $mech->content);
         print Dumper \@result;

         my @link;
         foreach ($mech->links){
             if( $_->[0] =~ /foo/ ) {
                $mech->get($_->[0]);
             }
             elsif( $_->[0] =~ /bar/ ) {
                push @link;
             }
             else {
                sub { 'do something here' }->($_->[0]);
             }
         }
         print $mech->content;
         print Dumper \@link;
         foreach (@result){
            print YAML::Dump $_;
         }

This program does several things:

-   Fetch CPAN's homepage.
-   Extract data with a template.
-   Process links using a control structure.
-   Print fetched content to `STDOUT`.
-   Dump links in the page.
-   Use YAML to print extract results.

If you need to create just one or two temporary scripts, it is acceptable to use copy and paste to generate scripts. Things will become messy if the job is to create a hundred scripts and you still use copy and paste.

### What Do I Need?

There are some techniques to gather identical code blocks and put them into some place and create scripts by loading different components for different purposes. Instead, I worked on the interface. I wished to simplify the problem through language. I re-examined the routine and the code structure to identified distinct features in every site scraping script:

-   Manually load lots of modules.
-   Create a WWW agent.
-   Create an extractor object.
-   Process links using a control structure.
-   Perform extraction.
-   Process extracted results.

I searched CPAN for something related to my ideas. I found plenty of modules for site scraping and data extraction, but no module that could meet my needs.

Then I created `FEAR::API`.

### Use FEAR::API

`FEAR::API`'s documentation says:

> `FEAR::API` is a tool that helps reduce your time creating site scraping scripts and helps you do it in an much more elegant way. `FEAR::API` combines many strong and powerful features from various CPAN modules, such as `LWP::UserAgent`, `WWW::Mechanize`, `Template::Extract`, `Encode`, `HTML::Parser`, etc., and digests them into a deeper Zen.

It might be best to introduce `FEAR::API` by rewriting the previous example:

       1    use FEAR::API -base;
       2    url("metacpan.org");
       3    fetch >> [
       4      qr(foo) => _feedback,
       5      qr(bar) => \my @link,
       6      qr()    => sub { 'do something here' }
       7    ];
       8    fetch while has_more_links;
       9    extmethod('Template::Extract');
      10    extract($template);
      11    print Dumper extresult;
      12    print document->as_string;
      13    print Dumper \@link;
      14    invoke_handler('YAML');

Line 1 loads `FEAR::API`. The `-base` argument means the package is a subclass of `FEAR::API`. The module automatically instantiates `$_` as a `FEAR::API` object.

Line 2 specifies the URL. The code will later fetch this URL by calling `fetch()`, but you can use `fetch( $the_url )`, too.

Line 3 fetches the home page of *some.site.com*. `>>` is an overloaded operator for dispatching links. The following array reference contains pairs of (`regular expression => action`). An action can be a code ref, an array ref, or a `_feedback` or `_self` constant.

`FEAR::API` maintains a queue of links. Using `_feedback` or `_self` means that `FEAR::API` should put the link in a queue for fetching later if the link matches a certain regular expression.

Line 8 calls `has_more_links`, so `FEAR::API` checks if the internal link queue has, well, more links. The program will continue fetching if there are queued links.

Line 9 specifies the extraction method. The default method is `Template::Extract`.

Line 10 extracts data according to `$template`.

Line 11 dumps the extracted results to `STDOUT`. `FEAR::API` even exports `Dumper()` for you. For [YAML](https://metacpan.org/pod/YAML) fans, there is also `Dump()`.

Line 12 accesses the fetched content through the object returned from `document`. You need to invoke `as_string()` to stringify the data. By the way, each fetched document is converted to UTF-8 automatically for you. It is very useful while processing multilingual texts.

Line 14 invokes the result handler to do data processing. The argument can be a subref, a module's name, `YAML`, or `Data::Dumper`.

### Comparison

I hope that now you can see what `FEAR::API` has improved, at least in code size. `FEAR::API` encapsulates many modules, and you don't need to worry about messing around with them on your own. All you need to do is tell `FEAR::API` to fetch a page, to do extraction, and how you want to deal with links contained in the page and the extracted results from the page. You don't need to initialize a WWW agent, convert the encoding of a fetched page, create an extractor object on your own, pass content to the extractor, write control structures for link processing, or anything else. Everything happens inside of `FEAR::API` or via this simple syntax.

At first sight, perhaps you don't even realize that the example script uses OO. If you don't like things to happen so automatically, you may choose to drop the `-base` option. Then you have to create FEAR::API objects manually using `fear()`:

       use FEAR::API;
       my $f = fear();

One of the goals of `FEAR::API` is to weed out redundancies and minimize code size. It is very cumbersome to use syntax such as `$_->blah_blah('blah')` throughout a scraping script, given mass script creation requirements. I decided to remove `$_->`, while it still uses OO.

### More Features

`FEAR::API` incorporates many features from successful modules, and you can use `FEAR::API` as an alternative.

If you use `LWP::Simple`:

       use LWP::Simple;
       get("http://metacpan.org");
       getprint("http://metacpan.org");
       getstore("http://metacpan.org", 'cpan.html');

With `FEAR::API`:

       use FEAR::API;
       get("http://metacpan.org");
       getprint("http://metacpan.org");
       getstore("http://metacpan.org", 'cpan.html');

If you are familiar with `curl`, you may use:

       $ curl  http://site.{one,two,three}.com
       # and
       $ curl ftp://ftp.numericals.com/file[1-100].txt

In `FEAR::API`, use `Template-Toolkit`:

       url("[% FOREACH number = ['one','two','three'] %]
            http://site.[% number %].com
            [% END %]");
       fetch while has_more_links;

       # and

       url("[% FOREACH number = [1..100] %]
            ftp://ftp.numericals.com/file[% number %].txt
            [% END %]");
       fetch while has_more_links;

`FEAR::API` also supports `WWW::Mechanize` methods. Use `submit_form()`, `links()`, and `follow_links()` in `FEAR::API` like those in `WWW::Mechanize`.

Submitting a query is easy:

       fetch("http://metacpan.org");
       submit_form(
                   form_name => 'f',
                   fields => {
                        query => 'perl'
                   });
       template($template); # specify template
       extract;

Dumping links is also easy:

       print Dumper fetch("http://metacpan.org/")->links;

So is following links:

       fetch("http://metacpan.org/")->follow_link(n => 3);

#### Cleaning Up Content

You may use `HTML::Strip` or basic regular expressions to strip HTML code in fetched content or in extracted results, but `FEAR::API` provides two simple methods: `preproc()` and `postproc()`. (There are also aliases: `doc_filter()` and `result_filter()`.)

You may process documents now with code resembling:

       use LWP::Simple;
       use HTML::Strip;

       my $content = get("http://metacpan.org");
       my $hs = HTML::Strip->new();
       print $hs->parse( $content );

Things are easier in `FEAR::API`:

       fetch("metacpan.org");
       preproc(use => 'html_to_null');
       print document->as_string;

If you don't use `FEAR::API` for postprocessing, your code might be:

       use Data::Dumper;
       use LWP::Simple;
       use Template::Extract;
       my $extor = Template::Extract->new;
       my $content = get("http://metacpan.org");
       my $result = $extor->extract($template, $content);
       foreach my $r (@$result){
          foreach (values %$r){
            s/(?:<[^>]*>)+/ /g;
          }
       }
       print Dumper $result;

`FEAR::API` is simpler:

       fetch("metacpan.org");
       extract($template);
       postproc('s/(?:<[^>]*>)+/ /g;');
       print extresult;

You can apply `preproc()` and `postproc()` on data multiple times until you find satisfactory results.

#### More Overloaded Operators.

The previous examples have used the `dispatch_links` operator (`>>`). There are more overloaded operators that you can use to reduce your code size further.

       print document->as_string;

is equivalent to:

       print $$_;

       print Dumper extresult;

is equivalent to:

       print Dumper \@$_;

       url("metacpan.org")->();

is equivalent to:

       url("metacpan.org");
       fetch;

       my $cont = fetch("metacpan.org")->document->as_string;

is equivalent to:

       fetch("metacpan.org") > $cont;

       push my @cont, fetch("metacpan.org")->document->as_string;

is equivalent to:

       fetch("metacpan.org") > \my @cont;

#### Filtering Syntax

`FEAR::API` creates something like shell piping. You can continually pass data through a series of filters to get what you need.

       url("metacpan.org")->()
         | _preproc(use => 'html_to_null')
         | _template($template)
         | _postproc('tr/a-z/A-Z/')
         | _foreach_result({ print Dumper $_ });

This is equivalent to:

       url("metacpan.org")->();
       preproc(use => 'html_to_null');
       template($template);
       extract;
       postproc('tr/a-z/A-Z');
       foreach (@{extresult()}){
         print Dumper $_;
       }

### A Full Example

Finally, here is an example that submits a query to CPAN, extracts records of results, and then puts the extracted data into a `SQLite` database.

First, create the database schema:

       % cat > schema.sql

       CREATE TABLE cpan (
          module      varchar(64),
          dist        varchar(64),
          link        varchar(256),
          description varchar(128),
          date        varchar(32),
          author      varchar(64),
          url         varchar(256),
          primary key (module)
       );

Then create the database:

       % sqlite3 cpan.db < schema.sql

Now create a class that maps to the database:

       % mkdir lib
       % mkdir lib/CPAN
       % cat > lib/CPAN/DBI.pm
       package CPAN::DBI;
       use base 'Class::DBI::SQLite';
       __PACKAGE__->set_db('Main', 'dbi:SQLite:dbname=cpan.db', '', '');
       __PACKAGE__->set_up_table('cpan');
       1;

The next part is the CPAN scraper:

      % cat > cpan-scraper.pl
       use lib 'lib';
       use FEAR::API -base;
       use CPAN::DBI;

       url("http://metacpan.org/")->();
       submit_form(form_name => 'f',
                   fields => {
                      query => 'perl',
                      mode => 'module',
                   });

       preproc('s/\A.+<!--results-->(.+)<!--end results-->.+\Z/$1/s');

       template('<!--item-->
      <p><a href="[% link %]"><b>[% module %]</b></a>
    <br /><small>[% description %]</small>
    <br /><small>   <a href="[% ... %]">[% dist %]</a> -
       <span class=date>[% date %]</span> -
       <a href="/~[% ... %]">[% author %]</a>
    </small>
    <!--end item-->');

       extract;

       invoke_handler(sub {
        print "-- Inserting $_->{module}\n";
        CPAN::DBI->find_or_create($_);
       });

Run it, and then check the database:

       % sqlite3 cpan.db
       sqlite> .mode csv
       sqlite> select module, dist, author from cpan;

If everything goes well, your results will resemble:

       "Perl","PerlInterp-0.03","Ben Morrow"
       "Perl::AfterFork","Perl-AfterFork-0.01","Torsten F&#246;rtsch"
       "Perl::AtEndOfScope","Perl-AtEndOfScope-0.01","Torsten F&#246;rtsch"
       "Perl::BestPractice","Perl-BestPractice-0.01","Adam Kennedy"
       "Perl::Compare","Perl-Compare-0.10","Adam Kennedy"
       "Perl::Critic","Perl-Critic-0.14","Jeffrey Ryan Thalhammer"
       "Perl::Editor","Perl-Editor-0.02","Adam Kennedy"
       "Perl::Metrics","Perl-Metrics-0.05","Adam Kennedy"
       "Perl::MinimumVersion","Perl-MinimumVersion-0.11","Adam Kennedy"
       "Perl::SAX","Perl-SAX-0.06","Adam Kennedy"

Isn't that easy?

### Conclusion

`FEAR::API` is an innovation for site scraping. It combines strong features and powerful methods from various modules, and it also employs operator overloading to build something a domain-specific language without forbidding the use of Perl's full power. `FEAR::API` is very suitable for the fast creation of scraping scripts. A central dogma of `FEAR::API` is "Code the least and perform the most."

However, `FEAR::API` still needs lots of improvement. Currently, it does not handle errors very well, lacks automatic template generation, performs no logging, and has no direct connection to a database mapper such as `DBIx::Class` or `Class::DBI`. Even the documentation needs work.

Patches or suggestions are welcome!
