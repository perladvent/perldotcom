{
   "thumbnail" : "/images/_pub_2003_05_29_treasures/111-treasures.gif",
   "description" : " The Perl Core comes with a lot of little modules to help you get thejob done. Many of these modules are not well-known. Even some of the well-known modules have some nice features that are often overlooked. In this...",
   "image" : null,
   "authors" : [
      "casey-west"
   ],
   "tags" : [],
   "categories" : "Perl Internals",
   "slug" : "/pub/2003/05/29/treasures.html",
   "date" : "2003-05-29T00:00:00-08:00",
   "title" : "Hidden Treasures of the Perl Core",
   "draft" : null
}





The Perl Core comes with a lot of little modules to help you get thejob
done. Many of these modules are not well-known. Even some of the
well-known modules have some nice features that are often overlooked. In
this article, we'll dive into many of these hidden treasures of the Perl
Core.

### [`blib`]{#blib}

This module allows you to use `MakeMaker`s to-be-installed version of a
package. Most of the distributions on the CPAN conform to `MakeMaker`s
building techniques. If you are writing a Perl module that has a build
system, then there would be a good chance `MakeMaker` is involved.
Testing on the command line is common; I know I find myself doing it
often. This is one of the places that `blib` comes in handy. When
running my test suite (you all have test suites, right?) on the command
line, I'm able to execute individual tests easily.

      perl -Mblib t/deepmagic.t

If you are building someone elses module and find yourself debugging a
testing failure, then `blib` could be used the same way.

### [`diagnostics`]{#diagnostics}

*PC Load Letter, what the frell does that mean?!* -- Micheal Bolton

When pushed hard enough, the Perl interpreter can spew out hundreds of
error messages. Some of them can be quite cryptic. Running the following
code snippet under the `warnings` pragma yields the warning
*Unterminated &lt;&gt; operator at program.perl line 11*.

      $i <<< $j;

Thankfully, `diagnostics` is an easy way to get a better explanation
from Perl. Since we're all running our important programs under the
`strict` and `warnings` pragmas, it's easy to add `diagnostics` to the
mix.

      use strict;
      use warnings;
      use diagnostics;

The previous code snippet now yields the following warning:

      Unterminated <> operator at -e line 1 (#1)
        (F) The lexer saw a left-angle bracket in a place where it was expecting
        a term, so it's looking for the corresponding right-angle bracket, and
        not finding it.  Chances are you left some needed parentheses out
        earlier in the line, and you really meant a "less than".

      Uncaught exception from user code:
            Unterminated <> operator at program.perl line 11.

Use of the `diagnostics` pragma should be kept to development only
(where it's truly useful).

### [`Benchmark`]{#benchmark}

It can be difficult to benchmark code. When trying to optimise a program
or routine, you want to try several approaches and see which comes out
faster. That's what the `Benchmark` module is for. This way, you don't
have to calculate start and stop times yourself, and in general you can
do high-level profiling quickly. Here is an example that tries to
determine which is faster, literal hash slices or retrieving hash values
one at a time.

      use Benchmark;

      sub literal_slice {
        my %family = (
          Daughter => 'Evilina',
          Father => 'Casey',
          Mother => 'Chastity',
        );
        my ($mom, $dad) = @family{qw[Mother Father]};
      }

      sub one_at_a_time {
        my %family = (
          Daughter => 'Evelina',
          Father => 'Casey',
          Mother => 'Chastity',
        );
        my $mom = $family{Mother};
        my $dad = $family{Father};
      }

      timethese(
        5_000_000 => {
          slice       => \&literal_slice,
          one_at_time => \&one_at_a_time,
        },
      );

On the hardware I have at work, a dual G4 PowerMac, the answer seems
obvious. Being cute and clever doesn't hurt us too badly. Here is the
output.

      Benchmark: timing 5000000 iterations of one_at_time, slice...
      one_at_time: 53 wallclock secs (53.63 usr +  0.00 sys = 53.63 CPU) 
             @ 93231.40/s (n=5000000)
            slice: 56 wallclock secs (56.72 usr +  0.00 sys = 56.72 CPU) 
             @ 88152.33/s (n=5000000)

### [`CGI::Pretty`]{#cgi::pretty}

Many of you know you can use Perl to write your HTML, in fact, this
trick is often used in CGI programs. If you have used the `CGI` module
to create HTML, then it would be obvious that the output is not intended
for humans to parse. The \`\`browser only'' nature of the output makes
debugging nearly impossible.

      use CGI qw[:standard];

      print header,
        start_html( 'HTML from Perl' ),
        h2('Writiing HTML using Perl' ),
        hr,
        p( 'Writing HTML with Perl is simple with the CGI module.' ),
        end_html;

The previous program produces the following incomprehensible output.

      Content-Type: text/html; charset=ISO-8859-1
      
      <?xml version="1.0" encoding="iso-8859-1"?>
      <!DOCTYPE html
              PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
               "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">;
      <html xmlns="http://www.w3.org/1999/xhtml"; lang="en-US">
      <head><title>HTML from Perl</title></head><body><h2>Writing 
      HTML using Perl</h2><hr /><p>Writing HTML with Perl is simple with the 
      CGI module.</p></body></html>

By changing the first line to `use CGI::Pretty qw[:standard];`, our
output is now manageable.

      Content-Type: text/html; charset=ISO-8859-1
      
      <?xml version="1.0" encoding="iso-8859-1"?>
      <!DOCTYPE html
              PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
               "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">;
      <html xmlns="http://www.w3.org/1999/xhtml"; lang="en-US">
      <head><title>HTML from Perl</title>
      </head><body>
      <h2>
              Writing HTML using Perl
      </h2>
      <hr><p>
              Writing HTML with Perl is simple with the CGI module.
      </p>
      </body></html>

While not as attractive as I'd like, there are lots of customizations to
be made, all outlined in the `CGI::Pretty` documentation.

### [`Class::ISA`]{#class::isa}

The world of class inheritance is a complex and twisting maze. This
module provides some functions to help us navigate the maze. The most
common need is for the function `super_path()`. When dealing with
complex OO hierarchies, `super_path()` can help us know which classes
we're inheriting from (it isn't always obvious), and find method
declarations.

I have a little project that requires `Class::DBI`, so I ran
`super_path()` on one of the classes to determine how Perl would search
the inheritance tree for a method.

      perl -MJobSearch -MClass::ISA -le'print for 
          Class::ISA::super_path( "JobSearch::Job" )'

The following list of classes is in the order Perl would search to find
a method.

      JobSearch::Object
      Class::DBI::mysql
      Class::DBI
      Class::DBI::__::Base
      Class::Data::Inheritable
      Class::Accessor
      Ima::DBI
      Class::WhiteHole
      DBI
      Exporter
      DynaLoader

Now if I have a question about a method implementation, or where methods
are coming from, I have a nice list to look through. `Class::ISA`
intentionally leaves out the current class (in this case
`JobSearch::Job`), and `UNIVERSAL`.

Here is a little trick that allows me to find out which classes *may*
implement the `mk_accessors` method.

      perl -MJobSearch -MClass::ISA -le \
        'for (Class::ISA::super_path( "JobSearch::Job" )) { 
            print if $_->can("mk_accessors") }'

Because of inheritance, all of the classes listed can invoke
`mk_accessors`, but not all of them actually define `mk_accessors`. It
still manages to narrow the list.

`Class::ISA` was introduced to the Perl Core in release **5.8.0**. If
you're using an older Perl, you can download it from the CPAN.

### [`Cwd`]{#cwd}

This module makes it simple to find the current working directory. There
is no need to go to the shell, as so many of us do. Instead, use `Cwd`.

      use Cwd;
      my $path = cwd;

### [`Env`]{#env}

Perl provides access to environment variables via the global `%ENV`
hash. For many applications, this is fine. Other times it can get in the
way. Enter the `Env` module. By default, this module will create global
scalars for all the variables in your environment.

      use Env;
      print "$USER uses $SHELL";

Some variables are of better use as a list. You can alter the behavior
of `Env` by specifying an import list.

      use Env qw[@PATH $USER];
      print "$USER's  path is @PATH";

Yet another module to save time and energy when writing programs.

### [`File::Path`]{#file::path}

This module has a useful function called `mkpath`. With `mkpath` you can
create more than one level of directory at a time. In some cases, this
could reduce a recursive function or a loop construct to a simple
function call.

      use File::Path;
      mkpath "/usr/local/apache/htdocs/articles/2003";

Since `mkpath` will create any directory it needs to in order to finally
create the `2003` directory, a tremendous amount of code is no longer
needed.

### [`File::Spec::Functions`]{#file::spec::functions}

This module implements a sane and useful interface over the `File::Spec`
module. `File::Spec` must be used by calling class methods, while
`File::Spec::Functions` turns those methods into functions. There are
many functions that are all useful (and fully documented in
`File::Spec::Unix`). Here are a few examples.

      use File::Spec::Functions qw[splitpath canonpath splitdir abs2rel];

      # split a path into logical pieces
      my ($volume, $dir_path, $file) = splitpath( $path );
      
      # clean up directory path
      $dir_path = canonpath $dir_path;

      # split the directories into a list
      my @dirs = splitdir $dir_path;

      # turn the full path into a relative path
      my $rel_path = abs2rel $path;

As you can see, there are plenty of ways to save yourself coding time by
using `File::Spec::Functions`. Don't forget, these functions are
portable because they use different symantecs behind the senses for the
operating system Perl is running on.

### [`File::Temp`]{#file::temp}

If you need a temporary file, then use `File::Temp`. This module will
find a temporary directory that is suitable for the operating system
Perl is running on and open a temporary file in that location. This is
yet another example of the Perl Core saving you time.

      use File::Temp;
      my $fh = tempfile;
      
      print $fh "temp data";

This will open a temporary file for you and return the filehandle for
you to write to. When your program exits, the temporary file will be
deleted.

### [`FindBin`]{#findbin}

`FindBin` has a small but useful purpose: to find the original directory
of the Perl script being run. When a program is invoked, it can be hard
to determine this directory. If a program is calling `chdir`, then it
can be even more difficult. `FindBin` makes it easy.

      use FindBin;
      my $program_dir = $FindBin::Bin;

### [`Shell`]{#shell}

`Shell` takes the ugliness of dealing with the command line and wraps it
up in pretty functions. The effect here is prettier programs. Here is a
simple demonstration.

      use Shell qw[ls du];
      use File::Spec::Functions qw[rel2abs];

      chomp( my @files = ls );
      foreach ( @files ) {
            print du "-sk", rel2abs $_;
      }

### [`Time::localtime`]{#time::localtime}

This module allows `localtime` to return an object. The object gives you
by-name access to the individual elements returned by `localtime` in
list context. This doesn't save us much coding time, but is can save us
a trip to the documentation.

      use Time::localtime;
      my $time = localtime;
      print $time->year += 1900;

There is a similar module called `Time::gmtime`, which provides the same
functionality for the `gmtime` function.

### [`UNIVERSAL`]{#universal}

The `UNIVERSAL` module is handy. Two of its most common functions, `isa`
and `can` are almost always used in OO programming as methods. `isa` is
used to determine what class an object belongs to, and `can` will tell
us whether an object supports a method. This is useful for testing. For
example.

      use Time::localtime;
      my $time = localtime;

      if ( $time->isa( 'Time::localtime' ) ) {
        print "We have a Time::localtime object";
      }
      
      if ( $time->can( "year" ) ) {
        print "We can get the year from our object";
      }

Another less-known function in `UNIVERSAL` is `VERSION`. I often need to
know the version of an installed module and I find myself writing a
one-liner like:

      perl -MTest::More -le'print $Test::More::VERSION'

That's just not as pretty as this.

      perl -MTest::More -le'print Test::More->VERSION'

### [Conclusion]{#conclusion}

The Perl Core has many hidden wonders, and I've just laid out a few
here. Trolling the Core for interesting functions and modules has saved
me a lot of work over the years. If you would like to look further, then
browse the `perlmodlib` manpage for a list of the core modules. Whether
your interest is CGI, I18N, Locale, or Math, you can find something
there that saves a few hours of work.


