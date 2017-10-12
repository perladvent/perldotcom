{
   "slug" : "/pub/2000/12/begperl5",
   "date" : "2000-12-18T00:00:00-08:00",
   "categories" : "development",
   "title" : "Beginners Intro to Perl - Part 5",
   "tags" : [
      "object-oriented-programming",
      "oop"
   ],
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "doug-sheppard"
   ],
   "image" : null,
   "description" : "Objects and Modules -> Editor's note: this venerable series is undergoing updates. You might be interested in the newer versions, available at: A Beginner's Introduction to Perl 5.10 A Beginner's Introduction to Files and Strings with Perl 5.10 A Beginner's..."
}





*Editor's note: this venerable series is undergoing updates. You might
be interested in the newer versions, available at:*

-   [A Beginner's Introduction to Perl
    5.10](/pub/a/2008/04/23/a-beginners-introduction-to-perl-510.html)
-   [A Beginner's Introduction to Files and Strings with Perl
    5.10](/pub/a/2008/05/07/beginners-introduction-to-perl-510-part-2.html)
-   [A Beginner's Introduction to Regular Expressions with Perl
    5.10](http://news.oreilly.com/2008/06/a-beginners-introduction-to-pe.html)
-   [A Beginner's Introduction to Perl Web
    Programming](http://broadcast.oreilly.com/2008/09/a-beginners-introduction-to-pe.html)

+-----------------------------------------------------------------------+
| **Beginners Intro to Perl**                                           |
+-----------------------------------------------------------------------+
| •**[Part 1 of this                                                    |
| series](/media/_pub_2000_12_begperl5/begperl1.html)**\                |
| •**[Part 2 of this                                                    |
| series](/media/_pub_2000_12_begperl5/begperl2.html)**\                |
| •**[Part 3 of this                                                    |
| series](/media/_pub_2000_12_begperl5/begperl3.html)**\                |
| •**[Part 4 of this                                                    |
| series](/media/_pub_2000_12_begperl5/begperl4.html)**\                |
| •**[Part 6 of this series](/pub/a/2001/01/begperl6.html)**\           |
| \                                                                     |
| •[What Is an Object?](#what%20is%20an%20object)\                      |
| •[Our Goal](#our%20goal)\                                             |
| •[Starting Off](#starting%20off)\                                     |
| •[What Does Our Object Do?](#what%20does%20our%20object%20do)\        |
| •[Our Goal, Part 2](#our%20goal,%20part%202)\                         |
| •[Encapsulation](#encapsulation)\                                     |
| •[Play Around!](#play%20around!)\                                     |
+-----------------------------------------------------------------------+

So far, we've mostly stuck to writing everything for our programs
ourselves. One of the big advantages of Perl is that you don't need to
do this. More than 1,000 people worldwide have contributed more than
5,000 utility packages, or *modules*, for common tasks.

In this installment, we'll learn how modules work by building one, and
along the way we'll learn a bit about *object-oriented programming* in
Perl.

### [What Is an Object?]{#what is an object}

Think back to the first article in this series, when we discussed the
two basic data types in Perl, strings and numbers. There's a third basic
data type: the *object*.

Objects are a convenient way of packaging information with the things
you actually *do* with that information. The information an object
contains is called its *properties*, and the things you can do with that
information are called *methods*.

For example, you might have an `AddressEntry` object for an address book
program - this object would contain *properties* that store a person's
name, mailing address, phone number and e-mail address; and *methods*
that print a nicely formatted mailing label or allow you to change the
person's phone number.

During the course of this article, we'll build a small, but useful,
class: a container for configuration file information.

### [Our Goal]{#our goal}

So far, we've put the code for setting various options in our programs
directly in the program's source code. This isn't a good approach. You
may want to install a program and allow multiple users to run it, each
with their own preferences, or you may want to store common sets of
options for later. What you need is a configuration file to store these
options.

We'll use a simple plain-text format, where name and value pairs are
grouped in sections, and sections are indicated by a header name in
brackets. When we want to refer to the value of a specific key in our
configuration file, we call the key `section.name`. For instance, the
value of *author.firstname* in this simple file is \`\`Doug:''

       [author]
       firstname=Doug
       lastname=Sheppard

       [site]
       name=Perl.com
       url=http://www.perl.com/

(If you used Windows in the ancient days when versions had numbers, not
years, you'll recognize this as being similar to the format of INI
files.)

Now that we know the real-world purpose of our module, we need to think
about what *properties* and *methods* it will have: What do
`TutorialConfig` objects store, and what can we do with them?

The first part is simple: We want the object's properties to be the
values in our configuration file.

The second part is a little more complex. Let's start by doing the two
things we *need* to do: read a configuration file, and get a value from
it. We'll call these two methods `read` and `get`. Finally, we'll add
another method that will allow us to set or change a value from within
our program, which we'll call `set`. These three methods will cover
nearly everything we want to do.

### [Starting Off]{#starting off}

We'll use the name `TutorialConfig` for our configuration file class.
(Class names are normally named in this InterCapitalized style.) Since
Perl looks for a module by its filename, this means we'll call our
module file `TutorialConfig.pm`.

Put the following into a file called `TutorialConfig.pm`:

        package TutorialConfig;

        warn "TutorialConfig is successfully loaded!\n";
        1;

(I'll be sprinkling debugging statements throughout the code. You can
take them out in practice. The `warn` keyword is useful for warnings -
things that you want to bring to the user's attention without ending the
program the way `die` would.)

The `package` keyword tells Perl the name of the class you're defining.
This is generally the same as the module name. (It doesn't *have* to be,
but it's a good idea!) The `1;` will return a true value to Perl, which
indicates that the module was loaded successfully.

You now have a simple module called `TutorialConfig`, which you can use
in your code with the `use` keyword. Put the following into a very
simple, one-line program:

        use TutorialConfig;

When we run this program, we see the following:

        TutorialConfig is successfully loaded!

### [What Does Our Object Do?]{#what does our object do}

Before we can create an object, we need to know *how* to create it. That
means we must write a method called `new` that will set up an object and
return it to us. This is also where you put any special initialization
code that you might need to run for each object when it is created.

The `new` method for our `TutorialConfig` class looks like this, and
goes into `TutorialConfig.pm` right after the package declaration:

        sub new {
            my ($class_name) = @_;

            my ($self) = {};
            warn "We just created our new variable...\n ";

            bless ($self, $class_name);
            warn "and now it's a $class_name object!\n";

            $self->{'_created'} = 1;
            return $self;
        }

(Again, you won't need those `warn` statements in actual practice.)

Let's break this down line by line.

First, notice that we define methods by using `sub`. (All methods are
really just a special sort of sub.) When we call `new`, we pass it one
parameter: the *type* of object we want to create. We store this in a
private variable called `$class_name`. (You can also pass extra
parameters to `new` if you want. Some modules use this for special
initialization routines.)

Next, we tell Perl that `$self` is a hash. The syntax `my ($self) = {};`
is a special idiom that's used mostly in Perl object programming, and
we'll see how it works in some of our methods. (The technical term is
that `$self` is an *anonymous hash*, if you want to read more about it
elsewhere.)

Third, we use the `bless` function. You give this function two
parameters: a variable that you want to make into an object, and the
type of object you want it to be. This is the line that makes the magic
happen!

Fourth, we'll set a *property* called \`\`\_created''. This property
isn't really that useful, but it does show the syntax for accessing the
contents of an object: *\$object\_name-&gt;{property\_name}*.

Finally, now that we've made `$self` into a new `TutorialConfig` object,
we `return` it.

Our program to create a `TutorialConfig` object looks like this:

        use TutorialConfig;
        $tut = new TutorialConfig;

(You don't need to use parentheses here, unless your object's `new`
method takes any extra parameters. But if you feel more comfortable
writing `$tut = new TutorialConfig();`, it'll work just as well.)

When you run this code, you'll see:

        TutorialConfig is successfully loaded!
        We just created the variable ...
        and now it's a TutorialConfig object!

Now that we have a class and we can create objects with it, let's make
our class *do* something!

### [Our Goal, Part 2]{#our goal, part 2}

Look at our goals again. We need to write three methods for our
`TutorialConfig` module: `read`, `get` and `set`.

The first method, `read`, obviously requires that we tell it what file
we want to read. Notice that when we write the source code for this
method, we must give it *two* parameters. The first parameter is the
object we're using, and the second is the filename we want to use. We'll
use `return` to indicate whether the file was successfully read.

       sub read {
          my ($self, $file) = @_;
          my ($line, $section);

          open (CONFIGFILE, $file) or return 0;

          # We'll set a special property 
          # that tells what filename we just read.
          $self->{'_filename'} = $file;



          while ($line = <CONFIGFILE>) {

             # Are we entering a new section?
             if ($line =~ /^\[(.*)\]/) {
                $section = $1;
             } elsif ($line =~ /^([^=]+)=(.*)/) {
                my ($config_name, $config_val) = ($1, $2);
                if ($section) {
                   $self->{"$section.$config_name"} = $config_val;
                } else {
                   $self->{$config_name} = $config_val;
                }
             }
          }

          close CONFIGFILE;
          return 1;
       }

Now that we've read a configuration file, we need to look at the values
we just read. We'll call this method `get`, and it doesn't have to be
complex:


        sub get {
            my ($self, $key) = @_;

            return $self->{$key};
        }

These two methods are really all we need to begin experimenting with our
`TutorialConfig` object. Take the module and sample configuration file
from above (or [download the configuration file
here](/media/_pub_2000_12_begperl5/tutc.txt) and [the module
here](/media/_pub_2000_12_begperl5/TutorialConfig.pm)), put it in a file
called `tutc.txt`, and then run [this simple
program](/media/_pub_2000_12_begperl5/sample.pl):


        use TutorialConfig;

        $tut = new TutorialConfig;
        $tut->read('tutc.txt') or die "Couldn't read config file: $!";

        print "The author's first name is ", 
                 $tut->get('author.firstname'), 
                 ".\n";

(Notice the syntax for calling an object's methods:
`$object->method(parameters)`.)

When you run this program, you'll see something like this:

        TutorialConfig has been successfully loaded!
        We just created the variable... 
        and now it's a TutorialConfig object!
        The author's first name is Doug.

We now have an object that will read configuration files and show us
values inside those files. This is good enough, but we've decided to
make it better by writing a `set` method that allows us to add or change
configuration values from within our program:

        sub set {
            my ($self, $key, $value) = @_;

            $self->{$key} = $value;
        }

Now let's test it out:

        use TutorialConfig;
        $tut = new TutorialConfig;

        $tut->read('tutc.txt') or die "Can't read config file: $!";
        $tut->set('author.country', 'Canada');

        print $tut->get('author.firstname'), " lives in ",
              $tut->get('author.country'), ".\n";

These three methods (`read`, `get` and `set`) are everything we'll need
for our `TutorialConfig.pm` module. More complex modules might have
dozens of methods!

### [Encapsulation]{#encapsulation}

You may be wondering why we have `get` and `set` methods at all. Why are
we using `$tut->set('author.country', 'Canada')` when we could use
`$tut->{'author.country'} = 'Canada'` instead? There are two reasons to
use methods instead of playing directly with an object's properties.

First, you can generally trust that a module won't change its methods,
no matter how much their implementation changes. Someday, we might want
to switch from using text files to hold configuration information to
using a database like MySQL or Postgres. Our new `TutorialConfig.pm`
module might have `new`, `read`, `get` and `set` methods that look like
this:

          sub new {
              my ($class) = @_;
              my ($self) = {};
              bless $self, $class;
              return $self;
          }

          sub read {
              my ($self, $file) = @_;
              my ($db) = database_connect($file);
              if ($db) {
                  $self->{_db} = $db;
                  return $db;
              }
              return 0;
          }

          sub get {
              my ($self, $key) = @_;
              my ($db) = $self->{_db};

              my ($value) = database_lookup($db, $key);
              return $value;
          }

          sub set {
              my ($self, $key, $value) = @_;
              my ($db) = $self->{_db};

              my ($status) = database_set($db, $key, $value);
              return $status;
          }

(Our module would define the `database_connect`, `database_lookup` and
`database_set` routines elsewhere.)

Even though the entire module's source code has changed, all of our
methods still have the same names and syntax. Code that uses these
methods will continue working just fine, but code that directly
manipulates properties will break!

For instance, let's say you have some code that contains this line to
set a configuration value:

         $tut->{'author.country'} = 'Canada';

This works fine with the original `TutorialConfig.pm` module, because
when you call `$tut->get('author.country')`, it looks in the object's
properties and returns \`\`Canada'' just like you expected. So far, so
good. However, when you upgrade to the new version that uses databases,
the code will no longer return the correct result. Instead of `get()`
looking in the object's properties, it'll go to the database, which
won't contain the correct value for \`\`author.country''! If you'd used
`$tut->set('author.country', 'Canada')` all along, things would work
fine.

As a module author, writing methods will let you make changes (bug
fixes, enhancements, or even complete rewrites) without requiring your
module's users to rewrite any of their code.

Second, using methods lets you avoid impossible values. You might have
an object that takes a person's age as a property. A person's age must
be a positive number (you can't be -2 years old!), so the `age()` method
for this object will reject negative numbers. If you bypass the method
and directly manipulate `$obj->{'age'}`, you may cause problems
elsewhere in the code (a routine to calculate the person's birth year,
for example, might fail or produce an odd result).

As a module author, you can use methods to help programmers who use your
module write better software. You can write a good error-checking
routine once, and it will be used many times.

(Some languages, by the way, *enforce* encapsulation, by giving you the
ability to make certain properties private. Perl doesn't do this. In
Perl, encapsulation isn't the law, it's just a very good idea.)

### [Play Around!]{#play around!}

1\. Our `TutorialConfig.pm` module could use a method that will write a
new configuration file to any filename you desire. Write your own
`write()` method (use `keys %$self` to get the keys of the object's
properties). Be sure to use `or` to warn if the file couldn't be opened!

2\. Write a `BankAccount.pm` module. Your `BankAccount` object should
have `deposit`, `withdraw`, and `balance` methods. Make the `withdraw`
method fail if you try to withdraw more money than you have, or deposit
or withdraw a negative amount of money.

3\. `CGI.pm` also lets you use objects if you want. (Each object
represents a single CGI query.) The method names are the same as the CGI
functions we used in the last article:

        use CGI;
        $cgi = new CGI;

        print $cgi->header(), $cgi->start_html();
        print "The 'name' parameter is ", $cgi->param('name'), ".\n";
        print $cgi->end_html();

Try rewriting one of your CGI programs to use `CGI` objects instead of
the CGI functions.

4\. A big advantage of using CGI objects is that you can store and
retrieve queries on disk. Take a look in the `CGI.pm` documentation to
learn how to use the `save()` method to store queries, and how to pass a
filehandle to `new` to read them from disk. Try writing a CGI program
that saves recently used queries for easy retrieval.

------------------------------------------------------------------------

-   [Complete `TutorialConfig.pm`
    module](/media/_pub_2000_12_begperl5/TutorialConfig.pm)
-   [Demo program](/media/_pub_2000_12_begperl5/sample.pl)
-   [Sample configuration file](/media/_pub_2000_12_begperl5/tutc.txt)


