{
   "date" : "2004-12-22T00:00:00-08:00",
   "tags" : [
      "apache-modules",
      "mod-parrot",
      "mod-perl",
      "parrot",
      "perl-6"
   ],
   "image" : null,
   "categories" : "Perl-6",
   "draft" : null,
   "thumbnail" : "/images/_pub_2004_12_22_mod_parrot/111-mod_parrot.gif",
   "description" : " It's been almost nine years since the first release of mod_perl, and it remains a very powerful tool for writing web applications and extending the capabilities of the Apache web server. However, lurking around the corner is Perl 6,...",
   "slug" : "/pub/2004/12/22/mod_parrot.html",
   "title" : "Introducing mod_parrot",
   "authors" : [
      "jeff-horwitz"
   ]
}





It's been almost nine years since the first release of
[mod\_perl](http://perl.apache.org/), and it remains a very powerful
tool for writing web applications and extending the capabilities of the
Apache web server. However, lurking around the corner is Perl 6, which
gives us not only a new version of Perl to embed in Apache but an
entirely new runtime engine called [Parrot](http://www.parrotcode.org/).
If there is ever going to be a Perl 6 version of mod\_perl, Apache must
first be able to run Parrot bytecode. This article introduces
[mod\_parrot](http://www.smashing.org/mod_parrot), an Apache module that
allows the execution of Parrot bytecode from within the web server. Like
mod\_perl, it also gives your code direct access to the Apache API so
you can write your own handlers.

### What is Parrot?

Parrot is a virtual machine (VM) optimized for dynamic languages like
Perl, Python, PHP, and Ruby. Source code written in each of these
languages eventually compiles down to bytecode (after some
optimizations), which subsequently runs in a virtual machine. Currently,
each language runs bytecode with its own VM, but one of Parrot's goals
is to provide a single common VM for all dynamic languages. This makes
implementing a new language much easier because there's no need to worry
about writing a new VM, and this also makes it possible for code in one
language to call code or access data structures from another language.

Parrot code comes in three distinct flavors:

-   Bytecode: This is the file format natively interpreted by Parrot.
-   PASM: Parrot assembler (PASM) is the low-level language that
    compiles down to bytecode. It has very simple operations to perform
    functions such as setting registers, adding numbers, and printing
    strings. PASM is very straightforward, but it operates at such a low
    level that it can be quite cumbersome.
-   PIR: Parrot Intermediate Representation (PIR) solves many of the
    problems encountered when programming in PASM. It provides more
    user-friendly and compiler-friendly constructs and optimizations and
    feels more like a traditional high-level programming language.
    Parrot eventually breaks down PIR into PASM before compiling to
    bytecode (you can even include PASM blocks in PIR). All of the
    examples in this article use PIR.

For more information on Parrot, including PASM and PIR syntax, visit the
[Parrot website](http://www.parrotcode.org). It will provide a good
background for understanding the code in this article.

### Why mod\_parrot?

Before discussing the details, you should know a little about
mod\_parrot's history. Ask Björn Hansen and Robert Spier originally
wrote mod\_parrot in 2002, later turning it over to Kevin Falcone. This
version of mod\_parrot targeted Apache 1.3 and had very limited
functionality due to Parrot's immaturity at the time. In August 2004,
with Parrot and its API much more mature, people suggested that the
development on mod\_parrot continue. This is where I picked up the
project. However, instead of picking up where Ask, Robert, and Kevin
left off, I started from scratch, coding for Apache 2 and focusing on
access to the Apache API.

The new mod\_parrot project has three primary goals:

-   Provide access to the Apache API through Parrot objects
-   Provide a common Apache layer for Parrot-based languages
-   Support for new languages should require little or no C coding

Let's discuss each of these in more detail.

#### Provide Access to the Apache API Through Parrot

Much of mod\_perl's power comes from direct access to the Apache API.
Rather than restrict your code to content generation, mod\_perl provides
hooks for things such as authentication handlers and output filters and
gives you access to Apache's internal structures, all in Perl. Once you
have this functionality, it is easy to implement other useful features
including script caching and persistent database connections.

mod\_parrot shares this approach, providing access to the Apache API
from Parrot. It does this using Parrot objects, mimicking mod\_perl's
use of `$r`. There will eventually be hooks for all phases of the Apache
lifecycle, though the current version supports only content handlers and
authentication handlers.

#### Provide a Common Apache Layer for Parrot-based Languages

There are several different languages that can run inside Apache today.
The major players here are mod\_perl and PHP, but Python, Ruby, and even
LISP have modules embedding them into Apache. Each of these
implementations comes with its own Apache module, which makes sense for
languages with different runtime engines. This is where Parrot changes
the landscape dramatically-all languages targeted to the Parrot VM now
have a *common* runtime engine, so they need only one Apache module:
mod\_parrot.

#### Support for New Languages Should Require Little or No C Coding

mod\_parrot will provide all of the infrastructure for accessing the
Apache API. The actual Apache module will already be written. Hooks for
calling Parrot code for each stage of the Apache lifecycle will exist.
Parrot objects will provide access to the Apache API. With all of this
already done, and assuming our language compiles down to Parrot
bytecode, we should be able to write the "glue" between Apache and our
language in the language itself. mod\_perl could be written in Perl;
mod\_python could be written in Python, and so on. Very little C code,
if any, would be necessary. Each language community could maintain its
own language-specific code while sharing the mod\_parrot module.

### Architecture

mod\_parrot is written for Apache 2, with no plans to back-port it to
Apache 1.3. The reason behind this decision is to code for the future,
not the past or present; after all, Perl 6 is still a few years down the
road. It's also much easier to write a module for Apache 2 than it is
for 1.3! In addition to the Apache 2 decision, there are several other
interesting aspects of the mod\_parrot architecture.

#### NCI

The most significant design decision is the use of NCI (native call
interface) to access the Apache API. mod\_perl accesses most of the
Apache API functions through individual XS wrappers (basically a bunch
of C macros), themselves compiled into mod\_perl itself or its
supporting modules. This is a tried and true method, used for many Perl
modules as well. Now, Parrot gives us NCI, which eliminates the need for
these wrappers, letting you call arbitrary C functions without having to
write any C code. Here's an example of a Parrot program that calls the C
function `getpid()`, which returns the current process ID:

    .sub _main
        # load libc.so, where getpid() is defined, and assign it to $P0
        $P0 = loadlib '/lib/libc.so.6'

        # find the function in the library and assign it to $P1
        # 'iv' means that getpid() returns an integer and takes no arguments
        $P1 = dlfunc $P0, 'getpid', 'iv'

        # call getpid() and place result in $I0
        $I0 = $P1( )

        # print the PID
        print $I0
        print "\n"
    .end

That's it--there is no C code to write, no recompilation, and no
relinking. However, the Apache API functions do not come from a loadable
shared library; they're in the Apache executable, `httpd`. Fortunately,
NCI can run C functions contained in the running process image, solving
that problem. For more information on NCI, see the [Parrot NCI
Documentation](http://www.parrotcode.org/docs/pdd/pdd16_native_call.html).

#### The Apache::RequestRec Object

All access to the Apache API goes through Parrot objects. Because
mod\_parrot borrows heavily from mod\_perl, it made sense to base the
primary object class in mod\_parrot on Apache's `request_rec` structure.
Just as in mod\_perl, the class is `Apache::RequestRec`. This name is
subject to change, however, as Parrot's namespace nomenclature becomes
clearer.

Every method is written in Parrot, with NCI calls to their corresponding
Apache API functions. For example, here is the Parrot method for the
`ap_rputs` function (`$r->puts` in mod\_perl):

    .sub puts method, prototyped
        .param string data
        .local pmc r
        .local pmc ap_rputs
        .local int offset

        classoffset offset, self, 'Apache::RequestRec'
        getattribute r, self, offset

        # find NCI object for ap_rputs
        find_global ap_rputs, 'Apache::NCI', 'ap_rputs'

        # use NCI to call out to Apache's ap_rputs
        ap_rputs( data, r )
    .end

Currently, `Apache::RequestRec` is the only class implemented in
mod\_parrot. Other classes to support the API will eventually appear,
including classes to support Apache's `conn_rec` and `server_rec`
structures.

### Installing mod\_parrot

You can download mod\_parrot from the [mod\_parrot home
page](http://www.smashing.org/mod_parrot). Additionally, you'll need the
following prerequisites (as of version 0.1):

-   Parrot 0.1.1 (Poicephalus)
-   Apache 2.0.50 or later
-   Perl 5.6.0 or later (for configuration only)
-   Apache::Test 1.13 or later (for the test suite)

Once you have all the prerequisite software, run the `Configure.pl`
script. The arguments to this script will most certainly change in
future releases, but for now, there are only two arguments:

-   `--parrot-build-dir=path-to-parrot-source`, the path to the
    top-level Parrot directory
-   `--apxs=path-to-apxs`, the path to Apache's `apxs` script, usually
    found in the *bin* directory under the Apache installation directory

<!-- -->

    $ perl Configure.pl --parrot-build-dir=../parrot \
      --apxs=/usr/local/apache2/bin/apxs

    Generating Makefile...done.
    Creating testing infrastructure...done.

    Type 'make' to build mod_parrot.

When configuration completes, type `make` to build mod\_parrot, then
`make test` to run the tests. To install, become root and type
`make install`. This will install the mod\_parrot module into your
Apache installation and activate the module in `httpd.conf`.

### Writing a mod\_parrot Handler

While there are currently no languages targeted to Parrot that have the
object support to use mod\_parrot (though Parakeet in the Parrot source
looks promising), we can still write Apache handlers. In what language?
In Parrot, of course! Well, actually, PIR. Here's a simple content
handler that displays "Hello World," or if you pass it an query string
in the URL, "Hello *name*," where *name* is the string you pass.

    # this namespace is used to identify the handler
    .namespace [ 'HelloWorld' ]

    # the actual handler
    .sub _handler
        # our Apache::RequestRec object
        .local pmc r

        # this will contain Apache constants
        .local pmc ap_constants

        # instantiate the Apache::RequestRec object
        find_type $I0, 'Apache::RequestRec'
        r = new $I0

        # who should we say hello to?
        $S0 = r.'args'( )
        $I0 = length $S0
        if $I0 > 0 goto say_hello
        $S0 = 'world'

    say_hello:
        # call the puts method to send some output
        $S1 = 'Hello ' . $S0
        r.'puts'( $S1 )

        # tell Apache that we're finished with this phase
        find_global ap_constants, 'Apache::Constants', 'ap_constants'
        $I0 = ap_constants['OK']
        .pcc_begin_return
            .return $I0
        .pcc_end_return
    .end

If you are at all familiar with mod\_perl or the Apache API, this should
look familiar to you, even if you don't know any Parrot. Let's go
through the code to see how it works. Because this is not an article
about Parrot itself, I'll glaze over the syntax and concentrate on what
the code actually does.

The first line of code in the handler declares the namespace in which
this handler exists. In this case, it is `HelloWorld`. This is important
because namespaces differentiate one handler from another in
`httpd.conf`.

Next comes the actual handler subroutine, which should always be named
`_handler`. The first thing the subroutine does is to declare some
locally scoped "variables." These are actually registers in Parrot, but
PIR can abstract them with named variables as it were a higher level
language. And `ap_constants`, a hash that will give access to Apache
constants including `OK` and `DECLINED`, come next. Both are PMCs, or
*Parrot Magic Cookie*, a special data type that implements the more
complex data types of higher-level languages such as Perl or Python.

The code now checks for a query string using the `args` method of the
`Apache::RequestRec` object and, if one exists, assigns it to the
temporary string register `$S0`. If there is no query string, `$S0` will
contain `world`. Next, the code creates the output string, instantiates
the `Apache::RequestRec` object, and calls the `puts` method to output
"Hello World" or "Hello *name*". By default, the content type is
`text/html`, so there's no need to set it here.

This is the end of the handler, so it's time to tell Apache that we're
done and that it no longer needs to handle this phase of the request.
This requires returning the Apache constant `OK` from the `ap_constants`
hash in the `Apache::Constants` namespace.

To compile the handler into Parrot bytecode, save it in a file with a
*.imc* extension (IMC is short for Intermediate Compiler). Then, compile
it into Parrot bytecode (PBC) as follows (this step will be automatic in
a future release):

    $ parrot -o HelloWorld.pbc HelloWorld.imc

### Configuring Apache to Use A Handler

Writing the handler was the hard part. Configuring Apache to use it is
easy. The first thing to do is to initialize mod\_parrot and load some
bytecode libraries:

    # mod_parrot initialization
    ParrotInit /path/to/lib/ModParrot/init.pbc
    ParrotLoad /path/to/lib/Apache/RequestRec.pbc
    ParrotLoad /path/to/lib/Apache/Constants.pbc

    # our handler
    ParrotLoad /path/to/HelloWorld.pbc

`ParrotInit` tells mod\_parrot where to find its initialization
bytecode. A future release will probably handle this automatically, but
for now explicitly set the path in `httpd.conf`. `ParrotLoad` tells
mod\_parrot to load a bytecode file. In this case, it loads the code
that implements the `Apache::RequestRec` object and the constants hash,
as well as the bytecode for the new handler.

Next, Apache needs a location for the handler to, well, handle. How
about the location `/hello`:

    <Location /hello>
        SetHandler parrot-code
        ParrotHandler HelloWorld
    </Location>

First, this sets the Apache handler for the location to `parrot-code`.
This is the official name of the mod\_parrot handler. Then it sets the
actual Parrot handler, which, as discussed in the previous section, is
the namespace of the handler subroutine, `HelloWorld`. That's it. Save
the configuration, restart Apache, point your browser to
`http://yourserver/hello` (replacing `yourserver` with the name of your
server), and you should see the "Hello World" message. Add a query
string to see the output change: `http://yourserver/hello?Joe` should
produce "Hello Joe."

### Writing an Authentication Handler

Apache handlers do more than just generate content, of course, and this
applies to mod\_parrot as well. Here's an example of using an
authentication handler to protect a private directory. It will use the
HTTP basic authentication scheme, but instead of using a standard
password file, it will accept any username as long as the password is
"squawk." Here's the handler PIR code:

    # this namespace is used to identify the handler
    .namespace [ 'TestAuthHandler']

    # the actual handler
    .sub _handler
        # our Apache::RequestRec object
        .local pmc r
        .local string pw
        .local int status

        # this will contain Apache constants
        .local pmc ap_constants
        find_global ap_constants, 'Apache::Constants', 'ap_constants'

        # instantiate the Apache::RequestRec object
        find_type $I0, 'Apache::RequestRec'
        r = new $I0

        # check the password, ignoring the username
        (status, pw) = r.'get_basic_auth_pw'( )
        if pw != 'squawk' goto auth_failure
        $I0 = ap_constants['OK']
        goto auth_return_status

    # authentication failed
    auth_failure:
        $I0 = ap_constants['HTTP_UNAUTHORIZED']
        goto auth_return_status

    # return our status code
    auth_return_status:
        .pcc_begin_return
            .return $I0
        .pcc_end_return
    .end

Here is the corresponding configuration in `httpd.conf`. Instead of
using `SetHandler` and `ParrotHandler` here, set `ParrotAuthenHandler`
to the namespace of the authentication handler:

    <Directory /usr/local/apache/htdocs/private>
        ParrotAuthenHandler TestAuthHandler
        AuthType Basic
        AuthName Private
        Require valid-user
    </Directory>

### Remembering Why We're Here

Note the low-level nature of the two handlers. There are no else
clauses; goto statements appear throughout the subroutine; and return
values must be assigned to registers before being used in another
operation. You can plainly see that this is only one step above writing
assembly here, but remember that you won't have to worry about writing
code at this level--you'll write in a high-level language such as Perl
6, and it will eventually compile down to Parrot assembler. Looking
forward, the corresponding Perl 6 code for the `HelloWorld` handler
might look a lot like this (as with all things Perl 6, this is subject
to change):

    use Apache::Constants ':common';
    use Apache::RequestRec;

    sub handler(Apache::RequestRec $r)
    {
        my ($status, $pw) = $r.get_basic_auth_pw();
        return ($pw eq 'squawk') ? OK : HTTP_UNAUTHORIZED;
    }

### Future Directions

mod\_parrot is still in its infancy. It's quite functional, but there is
still a lot of work to do before it can power any serious applications.
At this point in development, the primary goal is to finish hooking into
all phases of the Apache request lifecycle, including support for the
relevant Apache API functions. Windows support will also become a
priority as mod\_parrot becomes more functional.

You may also wonder about CGI scripts. As of this writing, there is no
support for running CGI scripts in mod\_parrot. mod\_perl has
`Apache::Registry` to help CGI scripts run in a persistent environment,
and mod\_parrot will need a similar infrastructure.

However, the real fun will begin when we have a high level language that
we can use to write handlers. If the timelines work out as I hope they
will, mod\_parrot will be fully functional before the formal release of
Perl 6 or any other mainstream Parrot-based language. Because the
Apache/Parrot layer will have already been written, this will save quite
a bit of development time for mod\_perl, PHP, and other similar
projects.

If you'd like to read more about mod\_parrot, or would like to help with
the project, visit the [mod\_parrot home
page](http://www.smashing.org/mod_parrot).


