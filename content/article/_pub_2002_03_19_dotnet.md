{
   "title" : "A Perl Hacker's Foray into .NET",
   "tags" : [
      "net-clr-c"
   ],
   "categories" : "Windows",
   "slug" : "/pub/2002/03/19/dotnet",
   "date" : "2002-03-19T00:00:00-08:00",
   "image" : null,
   "description" : " No, I haven't sold out; I haven't gone over to the dark side; I haven't been bought. I'm one of the last people to be using closed-source software by choice. But one of the traits of any self-respecting hacker...",
   "authors" : [
      "simon-cozens"
   ],
   "thumbnail" : "/images/_pub_2002_03_19_dotnet/111-perl_dotnet.gif",
   "draft" : null
}





No, I haven't sold out; I haven't gone over to the dark side; I haven't
been bought. I'm one of the last people to be using closed-source
software by choice. But one of the traits of any self-respecting hacker
is curiosity, and so when he hears about some cool new technology, he's
almost obliged to check it out and see whether there's anything he can
learn from it. So this particular Perl hacker took a look at Microsoft's
.NET Framework, and, well, Mikey, I think he likes it.

### What Is .NET?

When something's as incredibly hyped as Microsoft's .NET project, it's
hard to convince people that there's a real working technology
underneath it. Unfortunately, Microsoft doesn't do itself any favors by
slapping the .NET moniker on anything they can. So let's clarify what
we're talking about.

.NET is applied to anything with the broad notion of "Web services" --
from the Passport and Hailstorm automated privacy-deprivation services
and the Web-service-enabled versions of operating systems and
application products to the C\# language and the Common Language
Runtime. But there is an underlying theme and it goes like this: The
.NET **Framework** is an environment based on the Common Language
Runtime and (to some extent) the C\# language, for creating portable Web
services.

So for our exploration, the components of the .NET Framework that we
care about are the Common Language Runtime and the C\# language. And to
nail it down beyond any doubt, these are things that you can download
and use today. They're real, they exist and they work.

### The .NET CLR

Let's begin with the CLR. The CLR is, in essence, a virtual machine for
C\# much like the Java VM, but which is specifically designed to allow a
wide variety of languages other than C\# to run on it. Does this ring
any bells with Perl programmers? Yes, it's not entirely dissimilar to
the idea of the Parrot VM, the host VM for Perl 6 but designed to run
other languages as well.

But that's more or less where the similarity ends. For starters, while
Parrot is chiefly intended to be ran as an interpreted VM but has a
"bolted-on" JIT, CLR is expected to be JITted from the get-go. Microsoft
seems to want to avoid the accusations of slowness leveled at Java by
effectively requiring JIT compilation.

Another "surface" distinction between Parrot and CLR is that the
languages supported by the CLR are primarily statically typed languages
such as C\#, J\#, (a variant of Java) and Visual Basic .NET. The
languages Parrot aims to support are primarily dynamically typed,
allowing run-time compilation, symbolic variable access, (try doing
`${"Package::$var"}` in C\#...) closures, and other relatively wacky
operations.

To address these sorts of features, the [Project
7](http://research.microsoft.com/project7.net/project_7.htm) research
project was set up to provide .NET ports for a variety of "academic"
languages. Unfortunately, it transpires that this has highlighted some
limitations of the CLR, and so almost all of the implementations have
had to modify their target languages slightly or drop difficult
features. For instance, the work on
[Mercury](http://www.cs.mu.oz.au/research/mercury/) turned up some
deficiencies in CLR's Common Type System that would also affect a Perl
implementation. We'll discuss these deficiencies later when we examine
how Perl and the .NET Framework can interact.

But on the other hand, let's not let this detract from what the CLR is
good at - it can run a variety of different languages relatively
efficiently, and it can share data between languages. Let's now take a
look at C\#, the native language of the CLR, and then see how we can run
.NET executables on our favourite free operating systems.

### C\#

C\# is Microsoft's new language for the .NET Framework. It shares some
features with Java, and in fact looks extremely like Java at first
glance. Here's a piece of C\# code:

    using System;

    class App {
       public static void Main(string[] args) {
          Console.WriteLine("Hello World");
          foreach (String s in args) {
             Console.WriteLine("Command-line argument: " + s);
          }
       }
    }

Naturally, the Java-like features are quite obvious to anyone who's seen
much Java - everything's in a class, and there's an explicitly defined
`Main` function. But what's this - a Perl-like `foreach` loop. And that
`using` declaration seems strangely familiar.

Now, don't get me wrong. I'm not trying to claim that C\# is some
bastard offspring of Perl and Java, or even that C\# really has that
much in common with Perl; it doesn't. But it is a well-designed language
that does have a bunch of "programmer-friendly" language features that
traditionally made "scripting" languages like Perl or Python faster for
rapid code prototyping.

Here's some more code, which forms part of a game-of-life benchmarking
tool we used to benchmark the CLR against Parrot.

        static String generate(String input) {
            int cell, neighbours;
            int len = input.Length;
            String output = "";
            cell = 0; 
            do {
                neighbours = 0;
                foreach (int offset in new Int32[] {-16, -15, -14, -1, 1, 14, 15, 16}) {
                    int pos = (offset + len + cell) % len;
                    if (input.Substring(pos, 1) == "*")
                        neighbours++; 
                }
                if (input.Substring(cell, 1) == "*") {
                    output += (neighbours < 2 || neighbours > 3) ? " " : "*";
                } else {
                    output += (neighbours == 3) ? "*" : " ";
                } 
            } while (++cell < len); 
            return output;
        }

This runs one generation of the [game of
life](http://www.math.com/students/wonders/life/life.html), taking an
input playing field and building an output string. What's remarkable
about this is that I wrote it after a day of looking at C\# code, with
no prior exposure to Java. C\# is certainly easy to pick up.

What can Perl learn from C\#? That's an interesting question, especially
as the Perl 6 design project is ongoing. Let's have a a quick look at
some of the innovations in C\# and how we might apply them to Perl.

#### Strong Names

We'll start with an easy one, since Larry has already said that
something like this will already be in Perl 6: To avoid versioning
clashes and interface incompatibilities, .NET has the concept of "strong
names." Assemblies -- the C\# equivalent of Java's `jar` files -- have
metadata containing their name, version number, md5sum and cryptographic
signature, meaning you can be sure you're always going to get the
definitions and behavior you'd expect from any third-party code you run.
More generally, assemblies support arbitrary metadata that you can use
to annotate their contents.

This approach to versioning and metadata in Perl 6 was highlighted in
Larry's [State of the Onion](/pub/a/2001/07/25/onion.html) talk this
year, and is also the solution used by JavaScript 2.0, as described by
Waldemar Horwat at his [LL1
presentation](/pub/a/2001/11/21/lightweight.html), so it seems to be the
way the language world is going.

#### Properties

C\# supports properties, which are class fields with explicit get/set
methods. This is slightly akin to Perl's tying, but much, much slicker.
Here's an example:

        private int MyInt;
        public int SomeInt {
            get {
                Console.WriteLine("I was got.\n");
                return MyInt;
            }
            set {
                Console.WriteLine("I was set.\n");
                MyInt = value;
            }
        }

Whenever we access `SomeInt`, the `get` accessor is executed, and
returns the value of the underlying `MyInt` variable; when we write to
it, the corresponding `set` accessor is called. Here's one suggested way
we could do something similar in Perl 6:

          my $myint;
          our $SomeInt :get(sub{ print "I was got!\n"; $myint })
                       :set(sub{ print "I was set!\n"; $myint = $^a });
        

C\# actually takes this idea slightly further, providing "indexers",
which are essentially tied arrays:

        private String realString;
        public String substrString[int idx] {
            get {
                return realString.Substring(idx, 1);
            }
            set {
                realString = realString(0, idx) + value + realString(idx+1);
            }
        }

        substrString[12] = "*"; // substr($string, 12, 1) = "*";

#### Object-Value Duality

Within the CLR type system, (CTS) there are two distinct types (as it
were) of types: reference types and value types. Value types are the
simple, honest-to-God values: integers, floating point numbers, strings,
and so on. Reference types, on the other hand, are objects, references,
pointers and the like.

Now for the twist: Each value type has an associated reference type, and
you can convert values between them. So, if you've got an
`int counter;`, then you can "box" it as an object like so:
`Object CounterObj = counter`. More specifically, `int` corresponds to
`Int32`. This gives us the flexibility of objects when we need to, for
instance, call methods on them, but the speed of fixed values when we're
doing tight loops on the stack.

While Perl is and needs to remain an essentially untyped language,
optional explicit typing definitions combined with object-value duality
could massively up Perl's flexibility as well as bringing some potential
optimizations.

#### Chaining Delegates

Here's an extremely rare thing - a non-obvious use of operator
overloading that actually makes some sense. In event-driven programming,
you'll often want to assign callbacks to happen on a given event. Here's
how C\# does it: (The following code adapted from [Events in
C\#](http://www.csharphelp.com/archives/archive253.html) by Sanju)

    delegate void ButtonEventHandler(object source, int clickCount);

    class Button {
        public event ButtonEventHandler ButtonClick;

        public void clicked(int count) { // Fire the handler
            if (ButtonClick != null) ButtonClick (this,count);
        }
    }

    public class Dialog {
        public Dialog() {
            Button b = new Button();

            b.ButtonClick += new ButtonEventHandler(onButtonAction);
            b.clicked(1);
        }
    }

    public void onButtonAction(object source,int clickCount) {
        //Define the actions to be performed on button-click here.
    }

Can you see what's going on? The "delegate" type `ButtonEventHandler` is
a function signature that we can use to handle button click events. Our
`Button` class has one of these handlers, `ButtonClick`, which is
defined as an `event`. In the `Dialog` class, we instatiate a new
delegate, using the `onButtonAction` function to fulfill the role of a
`ButtonEventHandler`.

But notice how we assign it to the `Button`'s `ButtonClick` field - we
use addition. We can add more handlers in the same way:

        b.ButtonClick += new ButtonEventHandler(myButtonHandler);
        b.ButtonClick += new ButtonEventHandler(otherButtonHandler);
        

And now when the button's `clicked` method fires off the delegates, all
three of these functions will be called in turn. We might decide that we
need to get rid of one of them:

        b.ButtonClick -= new ButtonEventHandler(myButtonHandler);
        

After that, only the two functions `onButtonAction` and
`otherButtonHandler` are active. Chaining delegates like this is
something I haven't seen in any other language, and makes sense for
event-based programming; it's something it might be good for Perl 6 to
support.

### Mono and Rotor - Running .NET

OK, enough talk about C\#. Let's go run some.

Of course, the easiest way to do this at present is to do your
development on a Windows box. Just grab a copy of the [.NET Framework
SDK](http://msdn.microsoft.com/downloads/default.asp?url=/downloads/sample.asp?url=/msdn-files/027/000/976/msdncompositedoc.xml),
(only 137M!) install it, and you have a C\# compiler at your disposal
which can produce .NET executables running on the Microsoft CLR. This is
how I do my C\# experimentation - I have a copy of Windows running on a
virtual machine, sharing a filesystem with my OS X laptop. I do my
editing in my favourite Unix editor, then pop over to the Windows
session to run the `CSC` compiler.

I know that for some of us, however, that's not a great solution.
Thankfully, the creative monkeys at [Ximian](http://www.ximian.com) have
been feverishly working on bringing us an open-sourced .NET Framework
implementation. The [Mono](http://www.go-mono.com) project comprises of
an implementation of the Common Language Runtime plus a C\# compiler and
other goodies; a very easy way to get started with .NET is to pick up a
release of Mono, and compile and install it.

After the usual `./configure;make;make install`, you have three new
commands at your disposal: `mcs` is the Mono C\# compiler; `mint` is the
CLR Interpreter; and `mono` is its JITted cousin.

And yes, Veronica, you can run .NET `EXE` files on Linux. Let's take the
first C\# example from the top of this article, and run it:

     % mcs -o hello.exe hello.cs
     % mono hello.exe A Test Program
    Hello World
    Command-line argument: A
    Command-line argument: Test
    Command-line argument: Program
    RESULT: 0

And just to show you we're not messing you around:

     % file hello.exe
    hello.exe: MS Windows PE 32-bit Intel 80386 console executable

Mono isn't a particularly quick runtime, nor is it particularly
complete, but it has a large number of hackers improving its base
classes every day. It runs a large percentage of the .NET executables I
throw at it, and the `mcs` compiler can now compile itself, so you can
do all your development using open source tools.

Another option, once it appears, is Microsoft's
[Rotor](http://www.oreillynet.com/pub/a/dotnet/2002/03/04/rotor.html)
project, a shared source CLR and compiler suite. Rotor aims to be the
ECMA standard implementation of the .NET Framework; Microsoft has
submitted the Framework for standardization, but in typical style, its
own implementations add extra functionality not part of the standard.
Oh, and in case the words "shared source" haven't jumped out at you yet,
do not even *consider* looking at Rotor if you may work on Mono at some
point. However, for the casual user, its comprehensive implementation
means it will be a better short-term choice for .NET experimentation -
again, once it's released.

### CLR Architecture

Before we finish considering how Perl and the .NET Framework relate to
each other, let's take a more in-depth look at the internals of the
Common Language Runtime compared to our own Parrot.

First, the CLR is a stack-based virtual machine, as opposed to Parrot's
register approach. I don't know why this approach was taken, other than,
I imagine, "because everyone else does it." CLR runs a bytecode
language, which Microsoft calls MS-IL when it is talking about their
implementation of CLR, and what it calls CIL (Common Intermediate
Language) to ECMA. It's object-oriented assembler, a true horror to
behold, but it works. Here's a fragment of the IL for our Hello example:

        .method public static 
               default void Main(string[] args)  cil managed 
        {
            // Method begins at RVA 0x2090
            .entrypoint
            // Code size 78 (0x4e)
            .maxstack 9
            .locals (
                    string  V_0,
                    string[]        V_1,
                    int32   V_2)
            IL_0000: ldstr "Hello World"
            IL_0005: call void System.Console::WriteLine(string)
            IL_000a: ldarg.s 0
         ...

In order to optimize CLR for JITting, it imposes a number of
restrictions on the IL. For instance, the stack may only be used to
store parameters and return values from operations and calls; you can't
access arbitrary points in the stack; more significantly, the types of
values on the stack have to be statically determinable and invariant.
That's to say, at a given call in the code, you know for sure what types
of things are on the stack at the time.

The types themselves are part of the Common Type System, something every
language compiling to .NET has to conform to. As we have mentioned, CTS
types are either value types or reference types. There's a smaller
subset of CTS called the Common Language Specification, CLS. Languages
**must** implement CLS types, and may implement their own types as part
of the CTS. The CLS ought to be used in all "outward-facing" APIs where
two different languages might meet; the idea being the data passed
between two languages is guaranteed to have a known meaning and
semantics. However, this API restriction is not enforced by the VM.

Types which can appear on the stack are restricted again; you're allowed
int32, int64, int, float, a reference, a "managed" pointer or an
unmanaged pointer. "Management" is determined by where the pointer comes
from (trusted code is managed) and influences what it's allowed to see
and how it gets GCed. Local arguments may live somewhere other than on
the main stack - this is implementation-defined - in which case they
have access to a richer set of types; but since you have a reference to
an object, you should be OK.

Other value types include structures and enumerations. Since value types
are passed around on the stack, you can't really have big structures,
since you'd be passing loads of data. There's also the typed reference,
which is a reference plus something storing what sort of reference it
is. Reference types are kept in the heap, managed by garbage collection,
and are referenced on the stack. This is not unlike what Parrot does
with PMC and non-PMC registers.

Like Java, the CLR has a reasonably small number of operations. You can
load/store constants, local variables, arguments, fields and array
elements; you can create and dereference pointers; you can do
arithmetic; you can do conversion, casting and truncating; there are
branch ops (including a built-in lookup-table switch op) and method call
ops; there's a special tail-recursion method-call op; you can throw and
handle exceptions; you can box and unbox, converting value types to
reference types and vice verca; you can create an array and find its
length; you can handle typed references. And that's essentially it.
Anything else is outside the realm of the CLR, and has to be implemented
with external methods.

An excellent paper comparing the CLR and the JVM has been produced by
the team working on Component Pascal; they've ported CP to both virtual
machines, and so are very well-placed to run a comparison. See the [GPCP
project
page](http://www2.fit.qut.edu.au/CompSci/PLAS//ComponentPascal/).

### Perl and .NET

How can we connect Perl and .NET? Well, let's look at the pieces of work
that have already been done in this area. ActiveState have been leading
research, with their experimental [Perl for .NET
Research](http://www.activestate.com/Initiatives/NET/Research.html) and
[PerlNET](http://www.activestate.com/PerlNET/) projects.

Perl for .NET Research was a brave idea; Jan Dubois essentially wrote a
Perl interpreter in C\#, and used the standard Perl compilation
technique of combining an embedded interpreter with a serialized
representation of the Perl program. The resulting compiler is a C\#
analog of the `B::CC` module, and then runs the `CSC` compiler to
compile the C\# representation of the Perl program, linking in the Perl
interpreter, into an executable. To be honest, I couldn't get Perl for
.NET Research to produce executables, but I could study it enough to see
what it was doing.

PerlNET, now included with AS's Perl Dev Kit, takes a rather different
approach. This time the Perl interpreter sits "outside" the .NET
Framework, communicating with it through DLLs. This allows for .NET
Framework code to call into Perl, and also for Perl to make calls into
the .NET Framework library. For instance, one may write:

        use namespace "System";
        Console->WriteLine("Hello World!");

to call the `System.Console.WriteLine` method in the .NET Framework
runtime library.

However, neither of these initiatives compile Perl to MS-IL in the usual
sense of the word. This is surprising, since it would be an interesting
test of the flexibility of the Common Type System.

This is one of the possible avenues I'd like to see explored in terms of
bringing .NET and Perl closer together. Other possibilities include
crossover between CLR and Parrot - I'd love to see .NET executables run
on top of Parrot and Parrot bytecode files convertable to .NET; I'd like
to see a Perl 6 interpreter emit MS-IL; I'd like to see Perl programs
sharing data and objects with other languages on top of some virtual
machine.

Like it or not, there's a good chance that the .NET Framework is going
to be a big part of the technological scene in the future. I hope after
this brief introduction, you're a little more prepared for it when it
happens, and we have some direction as to how Perl fits into it.

------------------------------------------------------------------------

For more on .NET, check O'Reilly Network's [.NET
DevCenter](http://oreillynet.com/dotnet).


