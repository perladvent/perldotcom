{
   "categories" : "development",
   "thumbnail" : "/images/_pub_2006_01_26_more_advanced_perl/111-advanced.gif",
   "description" : " Around Easter last year, I finished writing the second edition of Advanced Perl Programming, a task that had been four years in the making. The aim of this new edition was to reflect the way that Perl programming had...",
   "title" : "More Advancements in Perl Programming",
   "image" : null,
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "slug" : "/pub/2006/01/26/more_advanced_perl",
   "tags" : [
      "advanced-perl",
      "html-parsing",
      "natural-language-processing",
      "nlp",
      "oo-perl",
      "perl-accessors",
      "perl-events",
      "perl-modules",
      "perl-nci",
      "perl-nlp",
      "perl-parsing",
      "perl-shared-libraries",
      "perl-testing",
      "perl-xs",
      "poe"
   ],
   "date" : "2006-01-26T00:00:00-08:00"
}





Around Easter last year, I finished writing the second edition of
[Advanced Perl Programming](http://www.oreilly.com/catalog/advperl2/), a
task that had been four years in the making. The aim of this new edition
was to reflect the way that Perl programming had changed since the first
edition. Much of what Sriram wrote in the original edition was still
true, but to be honest, not too much of it was useful anymore--the Perl
world has changed dramatically since the original publication.

The first edition was very much about how to do things yourself; it
operated at a very low level by current Perl standards. With the
explosion of CPAN modules in the interim, "advanced Perl programming"
now consists of plugging all of the existing components together in the
right order, rather than necessarily writing the components from
scratch. So the nature of the book had to change a lot.

However, CPAN is still expanding, and the Perl world continues to
change; *Advanced Perl Programming* can never be a finished book, but
only a snapshot in time. On top of all that, I've been learning more,
too, and discovering more tricks to get work done smarter and faster.
Even during the writing of the book, some of the best practices changed
and new modules were developed.

The book is still, I believe, an excellent resource for learning how to
master Perl programming, but here, if you like, I want to add to that
resource. I'll try to say something about the developments that have
happened in each chapter of the book.

### Advanced Perl

I'm actually very happy with this chapter. The only thing I left out of
the first chapter which may have been useful there is a section on
`tie`; but this is covered strongly in *Programming Perl* anyway.

On the other hand, although it's not particularly advanced, one of the
things I wish I'd written about in the book was best practices for
creating object-oriented modules. My fellow O'Reilly author Damian
Conway has already written two books about these topics, so, again, I
didn't get too stressed out about having to leave those sections out.
That said, the two modules I would recommend for building OO classes
don't appear to get a mention in *Perl Best Practices*.

First, we all know it's a brilliant idea to create accessors for our
data members in a class; however, it's also a pain in the neck to create
them yourself. There seem to be hundreds of CPAN modules that automate
the process for you, but the easiest is the
[`Class::Accessor`](http://search.cpan.org/perldoc?Class::Accessor)
module. With this module, you declare which accessors you want, and it
will automatically create them. As a useful bonus, it creates a default
`new()` method for you if you don't want to write one of those, either.

Instead of:

    package MyClass;

    sub new { bless { %{@_} }, shift; }

    sub name {
        my $self = shift;
        if (@_) { $self->{name} = shift; }
        $self->{name}
    }

    sub address {
        my $self = shift;
        if (@_) { $self->{address} = shift; }
        $self->{address}
    }

you can now say:

    package MyClass;
    use base qw(Class::Accessor);

    MyClass->mk_accessors(qw( name address ));

`Class::Accessor` also contains methods for making read-only accessors
and for creating separate read and write accessors, and everything is
nicely overrideable. Additionally, there are subclasses that extend
`Class::Accessor` in various ways:
[`Class::Accessor::Fast`](http://search.cpan.org/perldoc?Class::Accessor::Fast)
trades off a bit of the extensibility for an extra speed boost,
[`Class::Accessor::Chained`](http://search.cpan.org/perldoc?Class::Accessor::Chained)
returns the object when called with parameters, and
[`Class::Accessor::Assert`](http://search.cpan.org/perldoc?Class::Accessor::Assert)
does rudimentary type checking on the parameter values. There are many,
many modules on the CPAN that do this sort of thing, but this one is, in
my opinion, the most flexible and simple.

Speaking of flexibility, one way to encourage flexibility in your
modules and applications is to make them pluggable--that is, to allow
other pieces of code to respond to actions that you define.
[`Module::Pluggable`](http://search.cpan.org/perldoc?Module::Pluggable)
is a simple but powerful little module that searches for installed
modules in a given namespace. Here's an example of its use in
[`Email::FolderType`](http://search.cpan.org/perldoc?Email::FolderType):

    use Module::Pluggable 
        search_path => "Email::FolderType", 
        require     => 1, 
        sub_name    => 'matchers';

This looks for all modules underneath the `Email::FolderType::`
namespace, `require`s them, and assembles a list of their classes into
the `matchers` method. The module later determines the type of an email
folder by passing it to each of the recognizers and seeing which of them
handles it, with the moral equivalent of:

    sub folder_type {
        my ($self, $folder) = @_;
        for my $class ($self->matchers) {
            return $class if $class->match($folder);
        }
    }

This means you don't need to know, when you're writing the code, what
folder types you support; you can start off with no recognizers and add
them later. If a new type of email folder comes along, the user can
install a third-party module from CPAN that deals with it, and
`Email::FolderType` requires no additional coding to add support for it.

### Parsing

Perhaps the biggest change of heart I had between writing a chapter and
its publication was in the parsing chapter. That chapter had very little
about parsing HTML, and what it did have was not very friendly. Since
then, Gisle Aas and Sean Burke's
[`HTML::TreeBuilder`](http://search.cpan.org/perldoc?HTML::TreeBuilder)
and the corresponding
[`XML::TreeBuilder`](http://search.cpan.org/perldoc?XML::TreeBuilder)
have established themselves as much simpler and more flexible ways to
navigate HTML and XML documents.

The basic concept in `HTML::TreeBuilder` is the HTML element,
represented as an object of the `HTML::Element` class:

    $a = HTML::Element->new('a', href => 'http://www.perl.com/');
    $html = $a->as_HTML;

This creates a new element that is an anchor tag, with an `href`
attribute. The HTML equivalent in `$html` would be
`<a href="http://www.perl.com"/>`.

Now you can add some content to that tag:

    $a->push_content("The Perl Homepage");

This time, the object represents
`<a href="http://www.perl.com"> The Perl Homepage </a>`.

You can ask this element for its tag, its attributes, its content, and
so on:

    $tag = $a->tag;
    $link = $a->attr("href");
    @content = $a->content_list; # More HTML::Element nodes

Of course, when you are parsing HTML, you won't be creating those
elements manually. Instead, you'll be navigating a tree of them, built
out of your HTML document. The top-level module `HTML::TreeBuilder` does
this for you:

    use HTML::TreeBuilder;
    my $tree = HTML::TreeBuilder->new();
    $tree->parse_file("index.html");

Now `$tree` is a `HTML::Element` object representing the `<html>` tag
and all its contents. You can extract all of the links with the
`extract_links()` method:

    for (@{ $tree->extract_links() || [] }) {
         my($link, $element, $attr, $tag) = @$_;
         print "Found link to $link in $tag\n";
    }

Although the real workhorse of this module is the `look_down()` method,
which helps you pull elements out of the tree by their tags or
attributes. For instance, in a search engine indexer, indexing HTML
files, I have the following code:

    for my $tag ($tree->look_down("_tag","meta")) {
        next unless $tag->attr("name");
        $hash{$tag->attr("name")} .= $tag->attr("content"). " ";
    }

    $hash{title} .= $_->as_text." " for $tree->look_down("_tag","title");

This finds all `<meta>` tags and puts their attributes as name-value
pairs in a hash; then it puts all the text inside of `<title>` tags
together into another hash element. Similarly, you can look for tags by
attribute value, spit out sub-trees as HTML or as text, and much more,
besides. For reaching into HTML text and pulling out just the bits you
need, I haven't found anything better.

On the XML side of things,
[`XML::Twig`](http://search.cpan.org/perldoc?XML::Twig) has emerged as
the usual "middle layer," when
[`XML::Simple`](http://search.cpan.org/perldoc?XML::Simple) is too
simple and [`XML::Parser`](http://search.cpan.org/perldoc?XML::Parser)
is, well, too much like hard work.

### Templating

There's not much to say about templating, although in retrospect, I
would have spent more of the paper expended on
[`HTML::Mason`](http://search.cpan.org/perldoc?HTML::Mason) talking
about the [Template Toolkit](http://www.template-toolkit.org/) instead.
Not that there's anything wrong with `HTML::Mason`, but the world seems
to be moving away from templates that include code in a specific
language (say, Perl's) towards separate templating little languages,
like [TAL](http://search.cpan.org/perldoc?Template::TAL) and Template
Toolkit.

The only thing to report is that Template Toolkit finally received a bit
of attention from its maintainer a couple of months ago, but the
long-awaited Template Toolkit 3 is looking as far away as, well, Perl 6.

### Natural Language Processing

Who would have thought that the big news of 2005 would be that Yahoo is
relevant again? Not only are they coming up with interesting new search
technologies such as Y!Q, but they're releasing a lot of the guts behind
what they're doing as public APIs. One of those that is particularly
relevant for NLP is the [Term Extraction web
service](http://developer.yahoo.net/search/content/V1/termExtraction.html).

This takes a chunk of text and pulls out the distinctive terms and
phrases. Think of this as a step beyond something like
[`Lingua::EN::Keywords`](http://search.cpan.org/perldoc?Lingua::EN::Keywords),
with the firepower of Yahoo behind it. To access the API, simply send a
HTTP `POST` request to a given URL:

    use LWP::UserAgent;
    use XML::Twig;
    my $uri  = "http://api.search.yahoo.com/ContentAnalysisService/V1/termExtraction";
    my $ua   = LWP::UserAgent->new();
    my $resp = $ua->post($uri, {
        appid   => "PerlYahooExtractor",
        context => <<EOF
    Two Scottish towns have seen the highest increase in house prices in the
    UK this year, according to new figures. 
    Alexandria in West Dunbartonshire and Coatbridge in North Lanarkshire
    both saw an average 35% rise in 2005. 
    EOF
    });
    if ($resp->is_success) { 
        my $xmlt = XML::Twig->new( index => [ "Result" ]);
        $xmlt->parse($resp->content);
        for my $result (@{ $xmlt->index("Result") || []}) {
            print $result->text;
        }
    }

This produces:

    north lanarkshire
    scottish towns
    west dunbartonshire
    house prices
    coatbridge
    dunbartonshire
    alexandria

Once I had informed the London Perl Mongers of this amazing discovery,
Simon Wistow immediately bundled it up into a Perl module called
[`Lingua::EN::Keywords::Yahoo`](http://search.cpan.org/perldoc?Lingua::EN::Keywords::Yahoo),
coming soon to a CPAN mirror near you.

### Unicode

The best news about Unicode over the last year is that you should not
have noticed any major changes. By now, the core Unicode support in Perl
just works, and most of the CPAN modules that deal with external data
have been updated to work with Unicode.

If you don't see or hear anything about Unicode, that's a good thing: it
means it's all working properly.

### POE

The chapter on POE was a great introduction to how POE works and some of
the things that you can do with it, but it focused on using POE for
networking applications and for daemons. This is only half the story.
Recently a lot of interest has centered on using POE for graphical and
command-line applications: Randal Schwartz takes over from the RSS
aggregator at the end of the chapter by integrating it with a graphical
interface in "[Graphical interaction with POE and
Tk](http://www.stonehenge.com/merlyn/PerlJournal/col11.html)." Here, I
want to consider command-line applications.

The [`Term::Visual`](http://search.cpan.org/perldoc?Term::Visual) module
is a POE component for creating applications with a split-screen
interface; at the bottom of the interface, you type your input, and the
output appears above a status line. The module handles all of the
history, status bar updates, and everything else for you. Here's an
application that uses
[`Chatbot::Eliza`](http://search.cpan.org/perldoc?Chatbot::Eliza) to
provide therapeutic session with everyone's favorite digital
psychiatrist.

First, set up the chatbot and create a new `Term::Visual` object:

    #!/usr/bin/perl -w
    use POE;
    use POSIX qw(strftime);
    use Term::Visual;
    use Chatbot::Eliza;
    my $eliza = Chatbot::Eliza->new();
    my $vt    = Term::Visual->new( Alias => "interface" );

Now create the window, which will have space on its status bar for a
clock:

    my $window_id = $vt->create_window(
       Status => { 0 => { format => "[%8.8s]", fields => ["time"] } },
       Title => "Eliza" 
    );

You also need a
[`POE::Session`](http://search.cpan.org/perldoc?POE::Session), which
will do all the work. It will have three states; the first is the
`_start` state, to tell `Term::Visual` what to do with any input it gets
from the keyboard and to update the clock:

    POE::Session->create
    (inline_states =>
      { _start          => sub {
            $_[KERNEL]->post( interface => send_me_input => "got_term_input" );
            $_[KERNEL]->yield( "update_time" );
        },

Updating the clock is simply a matter of setting the `time` field
declared earlier to the current time, and scheduling another update at
the top of the next minute:

        update_time     => sub {
            $vt->set_status_field( $window_id,
                                   time => strftime("%I:%M %p", localtime) );
            $_[KERNEL]->alarm( update_time => int(time() / 60) * 60 + 60 );
        },

Finally, you need to handle the input from the user. Do that in a
separate subroutine to make things a big clearer:

        got_term_input  => \&handle_term_input,
      }
    );

    $poe_kernel->run();

When `Term::Visual` gets a line of text from the user, it passes it to
the state declared in the `_start` state. The code takes that text,
prints it to the terminal as an echo, and then passes it through Eliza:

    sub handle_term_input {
      my ($heap, $input) = @_[HEAP, ARG0];
      if ($input =~ m{^/quit}i) {
        $vt->delete_window($window_id); 
        exit;
      }

      $vt->print($window_id, "> $input");
      $vt->print($window_id, $eliza->transform($input));
    }

In just a few lines of code you have a familiar interface, similar to
many IRC or MUD clients, with POE hiding all of the event handling away.

### Testing

*Advanced Perl Programming* showed how to write tests so that we all can
be more sure that our code is doing what it should. How do you know your
tests are doing enough? Enter Paul Johnson's
[`Devel::Cover`](http://search.cpan.org/perldoc?Devel::Cover)!

`Devel::Cover` makes a record of each time a Perl operation or statement
is executed, and then compares this against the statements in your code.
So when you're running your tests, you can see which of the code paths
in your module get exercised and which don't; if you have big branches
of code that never get tested, maybe you should write more tests for
them!

To use it on an uninstalled module:

    $ cover -delete
    $ HARNESS_PERL_SWITCHES=-MDevel::Cover make test
    $ cover

This will give you a textual summary of code coverage;
`cover -report html` produces a colorized, navigable hypertext summary,
useful for showing to bosses.

This ensures that your code works--or at least, that it does what your
tests specify. The next step is to ensure that your code is actually of
relatively decent quality. Because "quality" is a subjective metric when
it comes to the art of programming, Perl folk have introduced the
objective of "Kwalitee" instead, which may or may not have any bearing
on quality.

All modules on CPAN have their Kwalitee measured as part of the
[CPANTS](http://cpants.dev.zsi.at/) (CPAN Testing Service) website. One
way to test for and increase your Kwalitee is to use the
[`Module::Build::Kwalitee`](http://search.cpan.org/perldoc?Module::Build::Kwalitee)
module; this copies some boilerplate tests into your distribution that
ensure that you have adequate and syntactically correct documentation,
that you `use strict` and `warnings`, and so on.

All of this ought to go a fair way to improving the Kwalitee of your
code, if not its actual quality!

### Inline

One of the things that has come over into Perl 5 from Perl 6 development
is the concept of the Native Call Interface (NCI). This hasn't fully
been developed yet, but chromatic (yes, the editor of this very site)
has been working on it.

The idea is that, instead of having something like Inline or XS that
creates a "buffer" between Perl and C libraries, you just call those
libraries directly. At the moment, you need to compile any XS module
against the library you're using. This is particularly awkward for folk
on cut-down operating systems that do not ship a compiler, such as Palm
OS or Windows.

The strength of NCI is that it doesn't require a compiler; instead, it
uses the operating system's normal means of making calls into libraries.
(Hence "Native Call.") It uses Perl's `DynaLoader` to find libraries,
load them, and then find the address of symbols inside of the library.
Then it calls a generic "thunk" function to turn the symbol's address
into a call. For instance:

    my $lib = P5NCI::Library->new( library => 'nci_test', package => 'NCI' );
    $lib->install_function( 'double_int', 'ii' );

    my $two = NCI::double_int( 1 );

These lines find the `nci_test` shared library and get ready to put its
functions into the `NCI` namespace. It then installs the function
`double_int`, which is of signature `int double_int(int)` (hence `ii`).
Once this is done, you can call the function from Perl. It's not much
trickier than Inline, but without the intermediate step of compilation.

NCI isn't quite there yet, and it only supports very simple function
signatures. However, because of its portability, it's definitely the one
to watch for Perl-C interfaces in the future.

### Everything Else

The last chapter is "Fun with Perl." Now, much has happened in the world
of Perl fun, but much has happened all over Perl. There were many other
things I wanted to write about, as well: CPAN best practices for
date/time handling and email handling, Perl 6 and Pugs, the very latest
web application frameworks such as Catalyst and Jifty, and so on. But
all these would fill another book--and if I ever finished that, it too
would require an update like this one. So I hope this is enough for you
to be getting on with!


