{
   "authors" : [
      "neil-gunton"
   ],
   "title" : "Creating Modular Web Pages With EmbPerl",
   "slug" : "/pub/2001/03/embperl.html",
   "description" : " Table of Contents Getting Started Hello World Web Site Global Variables Modular Files Modular File Inheritance Subroutines in EmbperlObject Conclusions This tutorial is intended as a complement to the Embperl documentation, not a replacement. We assume a basic familiarity...",
   "thumbnail" : null,
   "draft" : null,
   "image" : null,
   "categories" : "web",
   "tags" : [
      "embperl",
      "epl",
      "html"
   ],
   "date" : "2001-03-13T00:00:00-08:00"
}





\

+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| •[Getting Started](#getting%20started)\                               |
| \                                                                     |
| •[Hello World](#Hello%20World)\                                       |
| \                                                                     |
| •[Web Site Global Variables](#websiteglobal%20variables)\             |
| \                                                                     |
| •[Modular Files](#modular%20files)\                                   |
| \                                                                     |
| •[Modular File Inheritance](#modular%20file%20inheritance)\           |
| \                                                                     |
| •[Subroutines in EmbperlObject](#subroutines%20in%20embperlobject)\   |
| \                                                                     |
| •[Conclusions](#conclusions)\                                         |
+-----------------------------------------------------------------------+

This tutorial is intended as a complement to the Embperl documentation,
not a replacement. We assume a basic familiarity with Apache, mod\_perl
and Perl, and the Embperl documentation. No prior experience with
EmbperlObject is assumed. The real purpose is to give a clearer idea of
how EmbperlObject can help you build large Web sites. We give example
code that can serve as a starting template and hints about the best
practices that have come out of real experience using the toolkit. As
always, there is more than one way to do it!

Since EmbperlObject is an evolving tool, it is likely that these design
patterns will evolve over time, and it is recommended that the reader
check back on the Embperl Web site for new versions.

### [Motivation: Constructing Modular Web Sites]{#motivation: constructing modular websites}

Embperl is a tool that allows you to embed Perl code in your HTML
documents. As such, it could handle just about everything you need to do
with your Web site. So what is the point of EmbperlObject? What does it
give us that we don't already get with basic Embperl?

As often seems to be the case with Perl, the answer has to do with
laziness. We would all like the task of building Web sites to be as
simple as possible. Anyone who has had to build a non-trivial site using
pure HTML will have quickly experienced the irritation of having to
copy-and-paste common code between documents - stuff like navigation
bars and table formats. We have probably all wished for an \`\`include''
HTML tag. EmbperlObject goes a long way toward solving this problem,
without requiring the developer to resort to a lot of customized Perl
code.

In a nutshell, EmbperlObject extends Embperl by enabling the
construction of Web sites in a modular, or object-oriented, fashion. I
am using the term \`\`object-oriented'' (OO) loosely here in the context
of inheritance and overloading, but you don't really need to know
anything about the OO paradigm to benefit from EmbperlObject. As you
will see from this short tutorial, it is possible to benefit from using
EmbperlObject with even a minimal knowledge of Perl. With just a little
instruction, in fact, pure HTML coders can use it to improve their Web
site architecture. Having said that, however, EmbperlObject also
provides for more advanced OO functionality, as we'll see later.

### [Getting Started]{#getting started}

We'll assume that you've successfully installed the latest Apache,
mod\_perl and Embperl on your system. That should all be relatively
painless - problems normally occur when mixing older versions of one
tool with later versions of another. If you can, try to download the
latest versions of everything.

Having done all that, you might want to get going with configuring a Web
site. The first thing you need to do is set up the Apache config file,
usually called *httpd.conf*.

### [Configuring *httpd.conf*]{#configuring httpd.conf}

The following is an example configuration for a single virtual host to
use EmbperlObject. There are, as usual, different ways to do this; but
if you are starting from scratch, then it may be useful as a template.
It works with the later versions of Apache (1.3.6 and up). Obviously,
substitute your own IP address and domain name.

            NameVirtualHost 10.1.1.3:80
            
            <VirtualHost 10.1.1.3:80>
                    ServerName www.mydomain.com
                    ServerAdmin webmaster@mydomain.com
                    DocumentRoot /www/mydomain/com/htdocs
                    DirectoryIndex index.html
                    ErrorLog /www/mydomain/com/logs/error_log
                    TransferLog /www/mydomain/com/logs/access_log
                    PerlSetEnv EMBPERL_ESCMODE 0
                    PerlSetEnv EMBPERL_OPTIONS 16
                    PerlSetEnv EMBPERL_MAILHOST mail.mydomain.com
                    PerlSetEnv EMBPERL_OBJECT_BASE base.epl
                    PerlSetEnv EMBPERL_OBJECT_FALLBACK notfound.html
                    PerlSetEnv EMBPERL_DEBUG 0
            </VirtualHost>
            
            # Set EmbPerl handler for main directory
            <Directory "/www/mydomain/com/htdocs/">
                    <FilesMatch ".*\.html$">
                            SetHandler  perl-script
                            PerlHandler HTML::EmbperlObject
                            Options     ExecCGI
                    </FilesMatch>
                    <FilesMatch ".*\.epl$">
                            Order allow,deny
                            Deny From all
                    </FilesMatch>
            </Directory>

Note that you could change the .html file extension in the FilesMatch
directive; this is a personal preference issue. Personally, I use .html
for the main document files because I can edit files using my favorite
editor (emacs) and it will automatically load html mode. Plus, this may
be a minor thing - but using .html rather than a special extension such
as .epl adds a small amount of security to your site since it provides
no clue that the Web site is using Embperl. If you're careful about the
handling of error messages, then there never will be any indication of
this. These days, the less the script kiddies can deduce about you, the
better ...

Also, note that we have added a second FilesMatch directive, which
denies direct access to files with .epl extensions (again, you could
change this extension to another if you like, for example, .obj). This
can be helpful for cases where you have Embperl files that contain
fragments of code or HTML; you want those files to be in the Apache
document tree, but you don't want people to be able to request them
directly - these files should only included directly into other
documents from within Embperl, using Execute(). This is really a
security issue. In the following examples, we name files that are not
intended to be requested directly with the .epl extension. Files that
are intended to be directly requested are named with the standard .html
extension. This can also be helpful when scanning a directory to see
which are the main document files and which are the modules. Finally,
note that using the Apache FilesMatch directive to restrict access does
not prevent us from accessing these files (via Execute) in Embperl.

So how does all this translate into a real Web site? Let's look at the
classic example, Hello World.

### [Hello World]{#hello world}

The file specified by the EMBPERL\_OBJECT\_BASE apache directive
(usually called *base.epl*) is the lynchpin of how EmbperlObject
operates. Whenever a request comes for any page on this Web site, Emperl
will look for *base.epl* - first in the same directory as the request,
and if it's not found there, then working up the directory tree to the
root directory of the Web site. For example, if a request comes for
http://www.yoursite.com/foo/bar/file.html, then Embperl first looks for
*/foo/bar/base.epl*. If it doesn't find *base.epl* there, then it looks
in */foo/base.epl*. If there's still no luck, then it finally looks in
*/base.epl*. (These paths are all relative to the document root for the
Web site). What is the point of all this?

In a nutshell, *base.epl* is a template for giving a common
look-and-feel to your Web pages. This file is what is used to build the
response to any request, regardless of the actual filename that was
requested. So even if *file.html* was requested, *base.epl* is what is
actually executed. *base.epl* is a normal file containing valid HTML
mixed with Perl code, but with a few small differences. Here's a simple
'Hello World' example of this approach:

*/base.epl*

            <HTML>
            <HEAD>
                    <TITLE>Some title</TITLE>
            </HEAD>
            <BODY>
            Joe's Website
            <P>
            [- Execute ('*') -]
            </BODY>
            </HTML>

*/hello.html*

            Hello world!

Now, if the file http://www.yoursite.com/hello.html is requested, then
*base.epl* is what will get executed initially. So where does the file
*hello.html* come into the picture? Well, the key is the '\*' parameter
in the call to Execute(). '\*' is a special filename, only used in
*base.epl*. It means, literally, \`\`the filename that was actually
requested.''

What you will see if you try this example is something like this:

            Joe's Website

            Hello world!

As you can see here, the text \`\`Joe's Web Site'' is from *base.epl*
and the \`\`Hello world!'' is from *hello.html*.

This architecture also means that only *base.epl* has to have the
boilerplate code that each HTML file normally needs to contain - namely
the &lt;HTML&gt; &lt;BODY&gt;, &lt;/HTML&gt; and so on. Since the '\*'
file is simply inserted into the code, all it needs to contain is the
actual content that is specific to that file. Nothing else is necessary,
because *base.epl* has all the standard HTML trappings. Of course,
you'll probably have more interesting content, but you get the point.

### [Web Site Global Variables]{#websiteglobal variables}

Let's look at a more interesting example. When you create Perl variables
in Embperl usually their scope is the current file; so they are
effectively \`\`local'' to that file. When you split your Web site into
modules, however, it quickly becomes apparent that it is useful to have
variables that are global to the Web site, i.e., shared between multiple
files.

To achieve this, EmbperlObject has a special object that is
automatically passed to each page as it is executed. This object is
usually referred to as the \`\`Request'' object, because we get one of
these objects created for each document request that the Web server
receives. This object is passed in on the stack, so you can retrieve it
using the Perl \`\`shift'' statement. This object is also automatically
destroyed after the request, so the Request object cannot be used to
store data between requests. The idea is that you can store variables
that are local to the current request, and shared between all documents
on the current Web site; plus, as we'll see later, we can also use it to
call object methods. For example, let's say you set up some variables in
*base.epl*, and then use them in *file.html*:

*/base.epl*

            <HTML>
            <HEAD>
                    <TITLE>Some title</TITLE>
            </HEAD>
            [- 
                    $req = shift;
                    $req->{webmaster} = 'John Smith'
            -]
            <BODY>
            [- Execute ('*') -]
            </BODY>
            </HTML>

*/file.html*

            [- $req = shift -]
            Please send all suggestions to [+ $req->{webmaster} +].

You can see that EmbperlObject is allowing us to set up global variables
in one place and share them throughout the Web site. If you place
*base.epl* in the root document directory, you can have any number of
other files in this and subdirectories, and they will all get these
variables whenever they are executed. No matter which file is requested,
*/base.epl* is executed first and then the requested file.

You don't even need to include the requested '\*' file, but typically
you will have to - it would be a bit odd to ignore the requested file!

### [Modular Files]{#modular files}

The previous example is nice; it demonstrates the basic ability to have
Web site-wide variables set up in *base.epl* and then automatically have
them shared by all other files. Leading on from this, we probably want
to split up our files, for both maintainability and readability. For
example, a non-trivial Web site will probably define some Web site-wide
constants, perhaps some global variables, and maybe also have some kind
of initialization code that has to be executed for each page (e.g.
setting up a database connection). We could put all of this in
*base.epl*, but this file would quickly begin to look messy. It would be
nice to split this stuff out into other files. For example:

*/base.epl*

            <HTML>
            [- Execute ('constants.epl')-]
            [- Execute ('init.epl')-]
            <HEAD>
                    <TITLE>Some title</TITLE>
            </HEAD>
            <BODY>
            [- Execute ('*') -]
            </BODY>
            [- Execute ('cleanup.epl') -]
            </HTML>

*/constants.epl*

            [-
                    $req = shift;
                    $req->{bgcolor} = "white";
                    $req->{webmaster} = "John Smith";
                    $req->{website_database} = "mydatabase";
            -]

*/init.epl*

            [-
                    $req = shift;
                    # Set up database connection
                    use DBI;
                    use CGI qw(:standard);
                    $dsn = "DBI:mysql:$req->{website_database}";
                    $req->{dbh} = DBI->connect ($dsn);
            -]

*/cleanup.epl*

            [-
                    $req = shift;
                    # Close down database connection
                    $req->{dbh}->disconnect();
            -]

You can see how this would be useful, since each page on your site now
has a database connection available in \$req-&gt;{dbh}. Also notice that
we have a *cleanup.epl* file that is always executed at the end - this
is useful for cleaning up, shutting down connections and so on.

### [Modular File Inheritance]{#modular file inheritance}

To recap, we have seen how we can break our site into modules that are
common across multiple files, because they are automatically included by
*base.epl*. Inheritance is a way in which we can make our Web sites more
modular.

Although the concept of inheritance is one that stems from the
object-oriented paradigm, you really don't need to be an OO guru to
understand it. We will demonstrate the concept through a simple example.

Say you wanted different parts of your Web site to have different
&lt;TITLE&gt; tags. You could set the title in each page manually, but
if you had a number of different pages in each section, then this would
quickly get tiresome. We could split off the &lt;HEAD&gt; section into
its own file, just like *constants.epl* and *init.epl*, right? But so
far, it looks like we are stuck with a single *head.epl* file for the
entire Web site, which doesn't really help much.

The answer lies in subdirectories. This is the key to unlocking
inheritance and one of the most powerful features of EmbperlObject. You
may use subdirectories currently in your Web site design, maybe for
purposes of organization and maintenance. But here, subdirectories
actually enable you to override files from upper directories. This is
best demonstrated by example (simplified to make this specific point
clearer - assume *constants.epl*, *init.epl* and *cleanup.epl* are the
same as in the previous example):

*/base.epl*

            <HTML>
            [- Execute ('constants.epl')-]
            [- Execute ('init.epl')-]
            <HEAD>
            [- Execute ('head.epl')-]
            </HEAD>
            <BODY>
            [- Execute ('*') -]
            </BODY>
            [- Execute ('cleanup.epl') -]
            </HTML>

*/head.epl*

            <TITLE>Joe's Website</TITLE>

*/contact/head.epl*

            <TITLE>Contacting Joe</TITLE>

Assume that we have an *index.html* file in each directory that does
something useful. The main thing to focus on is *head.epl*. You can see
that we have one instance of this file in the root directory, and one in
a subdirectory, namely */contact/head.epl*. Here's the neat part: When a
page is requested from your Web site, EmbperlObject will search
automatically for *base.epl* first in the same directory as the
requested page. If it doesn't find it there, then it tracks back up the
directory tree until it finds the file. But then, when executing
*base.epl*, any files that are Executed (such as *head.epl*) are first
looked for in the **original directory** of the requested file. Again,
if the file is not found there, then EmbperlObject tracks back up the
directory tree.

So what does this mean? Well, if we have a subdirectory, then we can see
whether we want just the usual *index.html* file and nothing else. In
that case, all the files included by *base.epl* will be found in the
root document directory. But if we redefine *head.epl*, then
EmbperlObject will pick up that version of the file whenever we are in
the /contact/ subdirectory.

That is inheritance in action. In a nutshell, subdirectories inherit
files such as *head.epl*, *constants.epl* and so on from \`\`parent''
directories. But if we want, we can redefine any of these files in our
subdirectories, thus specializing that functionality for that part of
our Web site. If we had 20 .html files in /contact/, then loading any of
them would automatically get */contact/head.epl*.

This is all very cool, but there is one more wrinkle. Let's say we want
to redefine *init.epl*, because there is some initialization that is
specific to the /contact/ subdirectory. That's fine since we can create
*/contact/init.epl* and that file would be loaded instead of */init.epl*
whenever a file is requested from the /contact/ subdir. But this also
means that the initialization code that is in */init.epl* would never
get executed, right? That's bad, because the base version of the file
does a lot of useful set up. The answer is simple: For cases such as
this, we need to make sure to call the parent version of the file at the
start. For example:

*/contact/init.epl*

            [- Execute ('../init.epl') -]

            [-
                    # Do some setup specific to this subdirectory
            -]

You can see that the first thing we do here is Execute the parent
version of the file (i.e., the one in the immediate parent directory).
Thus we can ensure the integrity of the basic initialization that each
page should receive.

EmbperlObject is smart about this process. For example, we have a
situation where we have several levels of subdirectory; then, say we
only redefine *init.epl* in one of the deeper levels, say
*/sub/sub/sub/init.epl*. Now, if this file tries to Execute
*../init.epl*, there may not be any such file in the immediate parent
directory - so EmbperlObject automatically tracks back up the
directories until it finds the base version, */init.epl*. So, for any
subdirectory level in your Web site, you only have to redefine those
files that are specific to this particular area. This results in a much
cleaner Web site.

You can break up your files into whatever level of granularity you want,
depending on your needs. For instance, instead of just *head.epl* you
might break it down into *title.epl*, *metatags.epl* and so on. It's up
to you. The more you split it up, the more you can specialize in each of
the subdirectories. There is a balance, however, because splitting
things up too much results in an overly fragmented site that can be
harder to maintain. Moderation is the key - only split out files if they
contain a substantial chunk of code, or if you know that you need to
redefine them in subdirectories, generally speaking.

### [Subroutines in EmbperlObject]{#subroutines in embperlobject}

There are two types of inheritance in EmbperlObject. The first is the
one that we described in the previous section, i.e., inheritance of
modular files via the directory hierarchy. The other type, which is
closely related, is the inheritance of subroutines (both pure Perl and
Embperl). In this context, subroutines are really object methods, as
we'll see below. As you are probably already aware, there are two types
of subroutines in Embperl, for example:

            [!
                    sub perl_sub
                    {
                            # Some perl code
                    }
            !]
            
            [$ sub embperl_sub $]
                    Some HTML
            [$ endsub $]

In EmbperlObject, subroutines become object methods; the difference is
that you always call an object method through an object reference. For
example, instead of a straight subroutine call like this:

            foo();

We have instead a call through some object:

            $obj->foo();

EmbperlObject allows you to inherit object methods in much the same way
as files. Because of the way that Perl implements objects and methods,
there is just a little extra consideration needed. (Note: This is not
really a good place to introduce Perl's object functionality. If you're
not comfortable with inheritance, @ISA and object methods, then I
suggest you take a look at the book \`\`Programming Perl'' (O'Reilly) or
\`\`Object Oriented Perl'' by Damien Conway (Manning).)

A simple use of methods can be demonstrated using the following example:

*/base.epl*

            [! sub title {'Joe's Website'} !]
            [- $req = shift -]
            <HTML>
            <HEAD>
            <TITLE>[+ $req->title() +]</TITLE>
            </HEAD>
            </HTML>

*/contact/index.html*

            [! sub title {'Contacting Joe'} !]
            [- $req = shift -]
            <HTML>
                    A contact form goes here
            </HTML>

This is an alternative way of implementing the previous \`\`contact''
example, which still uses inheritance - but instead of placing the
&lt;TITLE&gt; tag in a separate file (*head.epl*), we use a method
(title()). You can see that we define this method in */base.epl*, so any
page that is requested from the root directory will get the title
\`\`Joe's Web Site.'' This is a good default title. Then, in
*/foo/index.html* we redefine the `title()` method to return
\`\`Contacting Joe.'' Inheritance ensures that when the call to
`title()` occurs in */base.epl*, the correct version of the method will
be executed. Since */foo/index.html* has its own version of that method,
it will automatically be called instead of the base version. This allows
each file to potentially redefine methods that were defined in
*/base.epl*, and it works well. But, as your Web sites get bigger, you
will probably want to split off some routines into their own files.

EmbperlObject also allows us to create special files that contain only
inheritable object methods. EmbperlObject can set up @ISA for us, so
that the Perl object methods will work as expected. To do this, we need
to access our methods through a specially created object rather than
directly through the Request object (usually called \$r or \$req). This
is best illustrated by the following example, which demonstrates the
code that needs to be added to *base.epl* and shows how we implement
inheritance via a subdirectory. Once again, assume that missing files
such as *constants.epl* are the same as the previous example (Note that
the 'object' parameter to Execute only works in 1.3.1 and above).

*/base.epl*

            <HTML>
            [- $subs = Execute ({object => 'subs.epl'}); -]
            [- Execute ('constants.epl') -]
            [- Execute ('init.epl') -]
            <HEAD>
            [- Execute ('head.epl') -]
            </HEAD>
            <BODY>
            [- Execute ('*', $subs) -]
            </BODY>
            [- Execute ('cleanup.epl') -]
            </HTML>

*/subs.epl*

            [!
                    sub hello
                    {
                            my ($self, $name) = @_;
                            print OUT "Hello, $name";
                    }
            !]

*/insult/index.html*

            [-
                    $subs = $param[0];
                    $subs->hello ("Joe");
            -]

*/insult/subs.epl*

            [! Execute ({isa => '../subs.epl'}) !]

            [!
                    sub hello
                    {
                            my ($self, $name) = @_;
                            $self->SUPER::hello ($name);
                            print OUT ", you schmuck";
                    }
            !]

If we requested the file */insult/index.html*, then we would see
something like:

            Hello, Joe, you schmuck

So what is happening? First, note that we create a \$subs object in
*base.epl*, using a special call to Execute(). We then pass this object
to files that will need it, via an `Execute()` parameter. This can be
seen with the '\*' file.

Next, we have two versions of *subs.epl*. The first, */subs.epl*, is
pretty straightforward. All we need to do is remember that all of these
subroutines are now object methods, and so take the extra parameter
(\$self). The basic `hello()` method simply says Hello to the name of
the person passed in.

Then we have a subdirectory, called /insult/. Here we have another
instance of *subs.epl*, and we redefine hello(). We call the parent
version of the function, and then add the insult (\`\`you schmuck'').
You don't have to call the parent version of methods you define, of
course, but it's a useful demonstration of the possibilities.

The file */insult/subs.epl* has to have a call to `Execute()` that sets
up @ISA. This is the first line. You might ask why EmbperlObject doesn't
do this automatically; it is mainly for reasons of efficiency. Not every
file is going to contain methods that need to inherit from the parent
file, and so simply requiring this one line seemed to be a good
compromise. It also allows for more flexibility, as you can include
other arbitrary files into the @ISA tree if you want.

### [Conclusions]{#conclusions}

So there you have it: an introduction to the use of EmbperlObject for
constructing large, modular Web sites. You will probably use it to
enable such things as Web site-wide navigation bars, table layouts and
whatever else needs to be modularized.

This document is just an introduction, to give a broad flavor of the
tool. You should refer to the actual documentation for details.

EmbperlObject will inevitably evolve as developers discover what is
useful and what isn't. We will try to keep this document up-to-date with
these changes, but make sure to check the Embperl Web site regularly for
the latest changes.


