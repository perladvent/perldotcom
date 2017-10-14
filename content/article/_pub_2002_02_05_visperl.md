{
   "draft" : null,
   "tags" : [
      "microsoft-visual-perl-studio"
   ],
   "categories" : "development",
   "image" : null,
   "date" : "2002-02-06T00:00:00-08:00",
   "authors" : [
      "eric-promislow"
   ],
   "title" : "Visual Perl",
   "slug" : "/pub/2002/02/05/visperl.html",
   "description" : " Jumbo shrimp, military intelligence - Visual Perl? ActiveState built its reputation by bringing Perl to the Windows platform, thereby extending the reach of Perl and the size and nature of the Perl community. However, regardless of the Windows port,...",
   "thumbnail" : "/images/_pub_2002_02_05_visperl/111-visual_perl.gif"
}





Jumbo shrimp, military intelligence - Visual Perl? ActiveState built its
reputation by bringing Perl to the Windows platform, thereby extending
the reach of Perl and the size and nature of the Perl community.
However, regardless of the Windows port, many Perl programmers don't
hesitate to voice their preference for text-based editors (like vi and
emacs) over Windows-based integrated development environments (IDEs).
Some Perl gurus find text-based editors the most efficient way to code.
But for programmers who are new to Perl, and programmers who primarily
work in graphical environments such as Windows, the intuitive, visual
nature of IDEs help them to learn languages and produce code more
quickly.

ActiveState's combined expertise in Perl and the Windows platform, and
our stated goal of bringing open-source programming languages to a wider
developer audience, has led to our interest in developing IDEs. We have
three particular goals:

1.  to create an intuitive editing environment
2.  to deliver much of the functionality that powerful text-based
    editors offer, but without the initial learning curve
3.  to add language-specific features, such as real-time syntax
    checking, debugging, colorizing and online help

Therefore, in addition to developing our own
[Komodo](http://www.ActiveState.com/Products/Komodo) IDE, ActiveState
has participated in Microsoft's Visual Studio Integration Program (VSIP)
and developed three plug-ins ([Visual
Perl](http://www.ActiveState.com/Products/Visual_Perl), [Visual
Python](http://www.ActiveState.com/Products/Visual_Python) and [Visual
XSLT](http://www.ActiveState.com/Products/Visual_XSLT)) for Microsoft's
[Visual Studio .NET](http://msdn.microsoft.com/vstudio).

Integrating Perl support into Visual Studio .NET required extending
Visual Studio to provide Perl-specific functionality. For example,
Visual Perl includes module-based code completion, pop-up hints for Perl
keywords and module functions, a context-sensitive Perl language
reference and emacs-like auto-indenting, brace matching, and block
selection. Additionally, Visual Perl makes use of standard Visual Studio
.NET functionality through the graphical debugger, the class view (for
browsing functions), sophisticated project management, etc.

### Visual Perl and .NET

In a separate initiative, ActiveState has developed
[PerlNET](http://www.activestate.com/Products/Perl_Dev_Kit/), a tool for
building .NET-compliant components with Perl. PerlNET is part of
ActiveState's Perl Dev Kit 4.0, and Visual Perl integrates with the Perl
Dev Kit, allowing developers to create .NET-compliant components (and
also Windows applications, services and controls) from within Visual
Studio .NET.

PerlNET and Visual Perl make it easier to build multi-language
applications. Previously, the easiest way to build Windows applications
quickly was with Visual Basic. However, Visual Basic has drawbacks with
regards to the the speed at which the applications run. Also, VB is not
the most commodious language for developers accustomed to modern
constructs such as associative arrays, dynamic functions, closures,
run-time eval and regular expression matching with full backtracking.

Microsoft has addressed this by creating a modernized ".NET" version of
Visual Basic, and with the creation of C\#, which provides a
near-functional equivalent to Visual Basic .NET (some would say
"superior, but functionally close"). Additionally, any language that can
target the .NET runtime engine can be used to build components, and
multilanguage interoperability is transparent. In a nutshell, you can
use a high-level language to script the UI, write back-end components in
Perl, and tie the two together almost effortlessly. All you have to do
is:

-   tell Visual Perl that a particular Perl project should be converted
    to a .NET DLL, and add the interface definition for the component in
    one or more "=for interface" POD comments
-   assign the code in the Perl-sourced DLL a namespace
-   point the client application to the Perl-sourced DLL, and use that
    namespace

### Visual Perl and .NET: Making it Happen

As an example, the process of building a .NET-compliant application goes
something like this:

1.  Quickly build a front-end in C\# or Visual Basic .NET using Win
    Forms to populate a form with UI widgets. Double-click on the
    widgets to script common events ("...\_Click" for buttons,
    "...\_TextChanged" for changing text fields).
2.  When it's time to add more processing to the back end, add a Perl
    project to the current Visual Studio .NET solution, and treat it
    like a Perl package. Define the constructor, add methods and fields
    to the interface definition block, and then define the new methods
    and fields.
3.  Like other Perl component builders, you should test and debug your
    Perl code before converting it into a DLL. The simplest way is to
    put a


            unless (caller) { ... }

    block at the end of your module, before the final "1;", and drive
    your package from that.

4.  Configure the Perl project as the "startup" project, then run the
    Perl component straight through, outside Visual Perl's debugger.
    (You can run programs in a DOS command shell, or in the "Run Window"
    within Visual Studio .NET. Both support standard IO, including
    stdin.)
5.  Change the project type from "Standard" to "Managed DLL," change the
    "startup" project to the C\# project, then build and run.

### Getting the Job Done with Visual Perl

.NET aside, we worked hard to make Visual Perl an attractive alternative
to emacs, vim and other editors favored by Perl programmers. Visual
Studio .NET provides an editing environment familiar to developers who
have always worked in Windows. But many Perl programmers cut their hash
variables on emacs and vi, and are wary of giving up the powerful
functionality of those editors.

However, implementing "vi" and "emacs" keystroke bindings wasn't the way
to go. "Ctrl-X" has a long-established meaning in the GUI world, and we
weren't about to let developers accidentally delete a chunk of selected
text when they meant to start a multi-keystroke command.

So, while we couldn't preserve the keystrokes, we could go some way
toward preserving the functionality. Visual Perl features:

-   configurable auto-indenting that provides the ability to set the
    level of indent, specify whether to insert spaces or tabs, and
    whether to auto-indent based on nesting constructs
-   auto-indenting based on the Camel book style, so it's sensitive to
    the location of enclosing braces and parentheses
-   the ability to show matching bracketing characters
-   keyboard shortcuts for moving to matching brackets, or selecting a
    block within the matching brackets
-   keyboard shortcuts for commenting and un-commenting blocks of
    selected text
-   the ability to collapse and expand blocks of code with a single
    mouse click
-   incremental searching, both forward and backward (although we hope
    to extend this functionality with incremental regular expression
    searches)

Visual Perl's colorizer is aware of some of Perl's more arcane
constructs, including here-documents (stacked or plain), regex
substitutions with different delimiters on the pattern and replacement,
and ?-delimited regular expressions. And Visual Studio .NET's Options
dialog lets you assign whatever color combination you want to each
style.

Other features include the class browser, which is used to quickly
navigate to the functions in the files loaded in a project. Integrated
context-sensitive help provides quick information on Perl keywords. You
can right click on a "use" or "require" statement, and view help for the
imported module within the Visual Studio .NET environment. The debugger
supports debugging of remote Perl programs, not just the program loaded
in the IDE.

Visual Perl uses the Visual Studio .NET code completion framework to
help walk the user through "::"-separated names when importing modules.
It recognizes when an instance of a package is bound to a variable, and
presents available methods when "-&gt;" is typed after the variable.
Visual Perl isn't doing anything fancy here; it's simply assuming that
good developers try to maintain a many-to-one relationship between their
variable names and the types the variables are labels for. So when
Visual Perl sees that a variable called "\$ua" is an instance of
LWP::UserAgent, it assumes that other instances of that variable are as
well. This definitely isn't thorough, and assumes that a value keeps its
name on both sides of a function call, but it works the way that many
people work.

### Visual Perl and Web Services

Visual Perl's code completion is also available for Web services. Once a
Web service has been associated with a variable, a list of available
methods in the Web service, and their call signatures, will pop up when
you type "-&gt;".

ActiveState has participated in the development of a
scripting-language-agnostic framework for consuming Web services, called
the Simple Web Services API. It works with Python and PHP, as well as
Perl. Among other things, it allows you to bind to and call methods on a
Web service with a minimal amount of code. For Perl, this line suffices
to bind a variable to a Web service:\
\
`$var = WebService::ServiceProxy->new (wsdl string)`\
\
Calling methods off the service is as simple as invoking an object
method:\
\
`$var->method(args...)`\

Once a variable has been bound to a Web service, typing the '-&gt;' will
drop a list of methods the Web service exports, and typing the '(' after
the method name will raise a call tip that walks through the arguments.

This is similar to SOAP::Lite, but has the advantage of working in
several languages, as well as handling features such as overloaded
methods, and supporting method names that contain Unicode characters
that can't be used in Perl identifiers.

### Conclusion

ActiveState's work with Visual Studio .NET and the .NET Framework
furthers our commitment to expanding the use of Perl. Visual Perl
expands the language set available to developers using Microsoft's
ubiquitous Visual Studio IDE, and PerlNET extends Perl by providing
compliancy with the .NET Framework.


