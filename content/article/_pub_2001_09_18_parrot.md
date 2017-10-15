{
   "date" : "2001-09-18T00:00:00-08:00",
   "image" : null,
   "thumbnail" : "/images/_pub_2001_09_18_parrot/111-parrot.jpg",
   "authors" : [
      "simon-cozens"
   ],
   "title" : "Parrot : Some Assembly Required",
   "categories" : "perl-6",
   "slug" : "/pub/2001/09/18/parrot.html",
   "tags" : [
      "parrot-perl-6-assembler-virtual-machine"
   ],
   "draft" : null,
   "description" : " Last week, the first public version of Parrot was released. This week, we're going to take a close look at what Parrot is, how you can get hold of it and play with it, and what we intend for..."
}



Last week, the first public version of Parrot was released. This week, we're going to take a close look at what Parrot is, how you can get hold of it and play with it, and what we intend for Parrot in the future.

What Is Parrot?
---------------

First, though, what is Parrot, and why are we making such a fuss about it? Well, if you haven't been living in a box for the past year, you'll know that the Perl community has embarked on the design and implementation of a new version of Perl, both the language and the interpreter.

Parrot is strongly related to Perl 6, but it is not Perl 6. To find out what it actually is, we need to know a little about how Perl works. When you feed your program into `perl`, it is first compiled into an internal representation, or bytecode; then this bytecode is fed to almost separate subsystem inside `perl` to be interpreted. So there are two distinct phases of `perl`'s operation: compilation to bytecode, and interpretation of bytecode. This is not unique to Perl; other languages following this design include Python, Ruby, Tcl and, believe it or not, even Java.

In previous versions of Perl, this arrangement has been pretty *ad hoc*: There hasn't been any overarching design to the interpreter or the compiler, and the interpreter has ended up being pretty reliant on certain features of the compiler. Nevertheless, the interpreter (some languages call it a Virtual Machine) can be thought of as a software CPU - the compiler produces "machine code" instructions for the virtual machine, which it then executes, much like a C compiler produces machine code to be run on a real CPU.

Perl 6 plans to separate the design of the compiler and the interpreter. This is why we've come up with a subproject, which we've called Parrot that has a certain, limited amount of independence from Perl 6. Parrot is destined to be the Perl 6 Virtual Machine, the software CPU on which we will run Perl 6 bytecode. We're working on Parrot before we work on the Perl 6 compiler because it's much easier to write a compiler once you have a target to compile to!

The name "Parrot" was chosen after this year's [April Fool's Joke,](/media/_pub_2001_09_18_parrot/parrot.htm) which had Perl and Python collaborating on the next version of their interpreters. This is meant to reflect the idea that we'd eventually like other languages to use Parrot as their VM; in a sense, we'd like Parrot to become a "common language runtime" for dynamic languages.

### Where We're At

After the release last Monday, we've seen a huge amount of activity on the development list, with more than 100 CVS commits in the past week. However, it should be stressed we're still in the early stages of development.

But don't let that put you off! Parrot is still very much usable; we've already seen one mini-language emerge that compiles down to Parrot bytecode (more on that later) and Leon Brocard has been working on automatically converting Java bytecode to Parrot.

At the moment, it's possible to write simple programs in Parrot assembly language, use an assembler to convert them to machine code and then execute them on a test interpreter. We have support for a wide variety of ordinary and transcendental mathematical operations, some rudimentary string support and some conditional operators.

### How to Get It

So let's get ourselves a copy of Parrot, so that we can start investigating how to program in the Parrot assembler.

We could get the [initial release](http://www.cpan.org/src/parrot-0.0.1.tar.gz) from CPAN, but an awful lot has changed since then. To really keep up to date with Parrot, we should get our copy from the [CVS repository](http://cvs.perl.org). Here's how we do that:

    % cvs -d :pserver:anonymous@cvs.perl.org:/home/perlcvs login
    (Logging in to anonymous@cvs.perl.org)
    CVS password: [ and here we just press return ]
    % cvs -d :pserver:anonymous@cvs.perl.org:/home/perlcvs co parrot
    cvs server: Updating parrot
    U parrot/.cvsignore
    U parrot/Config_pm.in
    ....
        

For those of you who can't use CVS, there are CVS snapshots built every six hours that you can find [here](http://cvs.perl.org/snapshots/parrot).

Now we have downloaded Parrot, we need to build it; so:

    % cd parrot
    % perl Configure.pl
    Parrot Configure
    Copyright (C) 2001 Yet Another Society

    Since you're running this script, you obviously have
    Perl 5 -- I'll be pulling some defaults from its configuration.
    ...
        

You'll then be asked a series of questions about your local configuration; you can almost always hit return for each one. Finally, you'll be told to type `make test_prog`; with any luck, Parrot will successfully build the test interpreter. (If it doesn't, the address to complain to is at the end of the article ...)
### The Test Suite

Now we should run some tests; so type `make test` and you should see a readout like the following:

    perl t/harness
    t/op/basic.....ok, 1/2 skipped:  label constants unimplemented in
    assembler
    t/op/string....ok, 1/4 skipped:  I'm unable to write it!
    All tests successful, 2 subtests skipped.
    Files=2, Tests=6,  2 wallclock secs ( 1.19 cusr +  0.22 csys =  1.41 CPU)
        

(Of course, by the time you read this, there could be more tests, and some of those which skipped might not skip - but none of them should fail!)

Parrot Concepts
---------------

Before we dive into programming Parrot assembly, let's take a brief look at some of the concepts involved.

### Types

The Parrot CPU has four basic data types:

`IV`  
An integer type; guaranteed to be wide enough to hold a pointer.

`NV`  
An architecture-independent floating-point type.

`STRING`  
An abstracted, encoding-independent string type.

`PMC`  
A scalar.

The first three types are pretty much self-explanatory; the final type, Parrot Magic Cookies, are slightly more difficult to understand. But that's OK, because they're not actually implemented yet! We'll talk more about PMCs at the end of the article.

### Registers

The current Perl 5 virtual machine is a stack machine - it communicates values between operations by keeping them on a stack. Operations load values onto the stack, do whatever they need to do and put the result back onto the stack. This is easy to work with, but it's slow: To add two numbers together, you need to perform three stack pushes and two stack pops. Worse, the stack has to grow at runtime, and that means allocating memory just when you don't want to be allocating it.

So Parrot's going to break with the established tradition for virtual machines, and use a register architecture, more akin to the architecture of a real hardware CPU. This has another advantage: We can use all the existing literature on how to write compilers and optimizers for register-based CPUs for our software CPU!

Parrot has specialist registers for each type: 32 IV registers, 32 NV registers, 32 string registers and 32 PMC registers. In Parrot assembler, these are named `I1`...`I32`, `N1`...`N32`, `S1`...`S32`, `P1`...`P32`.

Now let's look at some assembler. We can set these registers with the `set` operator:

        set I1, 10
        set N1, 3.1415
        set S1, "Hello, Parrot"
        

All Parrot ops have the same format: the name of the operator, the destination register and then the operands.

### Operations

There are a variety of operations you can perform: the file `docs/parrot_assembler.pod` documents them, along with a little more about the assembler syntax. For instance, we can print out the contents of a register or a constant:

        print "The contents of register I1 is: "
        print I1
        print "\n"
        

Or we can perform mathematical functions on registers:

        add I1, I1, I2  # Add the contents of I2 to the contents of I1
        mul I3, I2, I4  # Multiply I2 by I4 and store in I3
        inc I1          # Increment I1 by one
        dec N3, 1.5     # Decrement N3 by 1.5
        

We can even perform some simple string manipulation:

        set S1, "fish"
        set S2, "bone"
        concat S1, S2       # S1 is now "fishbone"
        set S3, "w"
        substr S4, S1, 1, 7
        concat S3, S4       # S3 is now "wishbone"
        length I1, S3       # I1 is now 8
        

### Branches

Code gets a little boring without flow control; for starters, Parrot knows about branching and labels. The `branch` op is equivalent to Perl's `goto`:

     
             branch TERRY
    JOHN:    print "fjords\n"
             branch END
    MICHAEL: print " pining"
             branch GRAHAM
    TERRY:   print "It's"
             branch MICHAEL
    GRAHAM:  print " for the "
             branch JOHN
    END:     end
        

It can also perform simple tests to see whether a register contains a true value:

             set I1, 12
             set I2, 5
             mod I3, I2, I2
             if I3, REMAIND, DIVISOR
    REMAIND: print "5 divides 12 with remainder "
             print I3
             branch DONE
    DIVISOR: print "5 is an integer divisor of 12"
    DONE:    print "\n"
             end
        

Here's what that would look like in Perl, for comparison:

        $i1 = 12;
        $i2 = 5;
        $i3 = $i1 % $i2;
        if ($i3) {
          print "5 divides 12 with remainder ";
          print $i3;
        } else {
          print "5 is an integer divisor of 12";
        }
        print "\n";
        exit;
        

And speaking of comparison, we have the full range of numeric comparators: `eq`, `ne`, `lt`, `gt`, `le` and `ge`. Note that you can't use these operators on arguments of disparate types; you may even need to add the suffix `_i` or `_n` to the op to tell it what type of argument you are using - although the assembler ought to divine this for you, by the time you read this.

Some Parrot Programs
--------------------

Now let's look at a few simple Parrot programs to give you a feel for the language.

### Displaying the Time

This little program displays the Unix epoch time every second: (or so)

            set I3, 3000000
    REDO:   time I1
            print I1
            print "\n"
            set I2 0
    SPIN:   inc I2
            le I2, I3, SPIN, REDO

First, we set integer register 3 to contain 3 million - that's a completely arbitrary number, due to the fact that Parrot averages a massive 6 million ops per second on my machine. Then the program consists of two loops. The outer loop stores the current Unix time in integer register 1, prints it out, prints a new line and resets register 2 to zero. The inner loop increments register 2 until it reaches the 3 million we stored in register 3. When it is no longer less than (or equal to) 3 million, we go back to the `REDO` of the outer loop. In essence, we're just spinning around a busy loop to waste some time. This is only because Parrot doesn't currently have a "sleep" op; we'll see how to implement one later.

How do we run this? First, we need to assemble this into Parrot bytecode, with the `assemble.pl` provided. So, copy the assembler to a file `showtime.pasm`, and inside your Parrot directory, run:

          perl assemble.pl showtime.pasm > showtime.pbc
        

(`.pbc` is the file extension for Parrot bytecode.)

### Finding a Fibonacci number

The Fibonnaci series is defined like this: take two numbers, 1 and 1. Then repeatedly add together the last two numbers in the series to make the next one: 1, 1, 2, 3, 5, 8, 13, and so on. The Fibonacci number `fib(n)` is the n'th number in the series. Here's a simple Parrot assembler program that finds the first 20 Fibonacci numbers:

    # Some simple code to print some Fibonacci numbers
    # Leon Brocard <acme@astray.com>

            print   "The first 20 fibonacci numbers are:\n"
            set     I1, 0
            set     I2, 20
            set     I3, 1
            set     I4, 1
    REDO:   eq      I1, I2, DONE, NEXT
    NEXT:   set     I5, I4
            add     I4, I3, I4
            set     I3, I5
            print   I3
            print   "\n"
            inc     I1
            branch  REDO
    DONE:   end

This is the equivalent code in Perl:

            print "The first 20 fibonacci numbers are:\n";
            my $i = 0;
            my $target = 20;
            my $a = 1;
            my $b = 1;
            until ($i == $target) {
               my $num = $b;
               $b += $a;
               $a = $num;
               print $a,"\n";
               $i++;
            }
        

(As a fine point of interest, one of the shortest and certainly the most beautiful ways of printing out a Fibonacci series in Perl is `perl -le '$b=1; print $a+=$b while print $b+=$a'`.)

### Jako

So much for programming in assembler; let's move on and look at a medium-level language - Jako. Jako was written by Gregor Purdy who obviously got sick (as a parrot) of programming in assembler. Jako looks a little bit like C and a little bit like Perl, and it can do anything you can do in Parrot assembler, but a little tidier. Let's try that Fibonacci program again:

            print("The first 20 fibonacci numbers are:\n");
            var int i = 0;
            var int target = 20;
            var int a = 1;
            var int b = 1;
            var int num;
            while (i != target) {
               num = b;
               b += a;
               a = num;
               print("$a\n");
               i++;
            }

Notice how similar this is to the Perl version? I stripped away the `$` sigils, replaced the Perlish `until` with a more common `while`, replaced `my` with `var int` and I was nearly done.

The Jako compiler, `jakoc`, ships with Parrot in the `little_languages` subdirectory:

     % perl little_languages/jakoc fib.jako > fib.pasm
     % perl assemble.pl fib.pasm > fib.pbc
     % ./test_prog fib.pbc
    The first 20 fibonacci numbers are:
    1
    2
    3
    ...

Where Next?
-----------

Parrot is obviously developing very rapidly, and we still have a long way to go before we are ready for a compiler to this platform. This section is for those who are interested in helping us take Parrot further.

### Adding Operations

The first thing we need is a lot more operations; but this needs to be carefully thought out, and all new proposals for operations should be checked by Dan Sugalski, the Parrot designer.

That said, adding operations to Parrot is actually simple. Let's add the `sleep` operator we were complaining about earlier.

To add an operator to the Parrot core, we need to edit two files: `opcode_table`, which contains the description of operations and their arguments, and `basic_opcodes.ops`, which contains the C implementation for our opcodes.

Although we've been able to say `print "String"` and `print I3` to print a register, Parrots ops are **not** polymorphic - this is some trickery carried out by the assembler. Those two operations would be implemented by two different ops, `print_sc` to print a string constant, and `print_i` to print an integer register. So we'll add two ops `sleep_i` to sleep for the number of seconds determined by the contents of an integer register, and `sleep_ic`, to sleep for a constant number of seconds. Each op has one argument. At the top of `opcode_table` there is a list of argument types:

    # Revised arg types:
    #      i       Integer constant
    #      I       Integer register
    #      n       Numeric constant
    #      N       Numeric register
    #      s       String constant?
    #      S       String register
    #      D       Destination

So `sleep_ic` has 1 argument, `i`, and `sleep_i` has 1 argument, `I`. Let's add these into `opcode_table` in the "Miscellaneous and debugging ops" category:

     # Miscellaneous and debugging ops
     
     time_i              1                   I
     print_i             1                   I
     print_ic            1                   i
     time_n              1                   N
     print_n             1                   N
     print_nc            1                   n
    +sleep_i             1                   I
    +sleep_ic            1                   i
        

And now we need to implement them by adding to `basic_opcodes.ops`. The format of this file is a little funny; it's C, which is preprocessed by a Perl program. The C functions should be declared `AUTO_OP`, which means that the preprocessor will automatically work out the return address of the next op in the bytecode stream. (branch operators need special treatment, and as such are `MANUAL_OP`s) Parameters are denoted by `P1`, `P2` and so on - they aren't actual parameters to the C function, but are pulled out of the bytecode stream. Finally, we can access register `n` by saying `INT_REG(n)`, `NUM_REG(n)` and so on.

So let's do the constant sleep op first. We want to take the first parameter, `P1`, and pass it to sleep:

    AUTO_OP sleep_ic {
         sleep(P1);
    }

That was easy. The second op is only slightly more complex. We have to use `INT_REG` to retrieve the contents of the register:

    AUTO_OP sleep_i {
         sleep(INT_REG(P1));
    }

All that's missing is a test suite (see `t/op/basic.t` for an example) and some documentation (we need to add entries to `docs/parrot_assembly.pod`) and we've added our instructions to the Parrot CPU. The assembler will automatically determine whether we're sleeping for a constant time or a variable time, and will dispatch the right op when we just say `sleep`. Now we can rewrite the `showtime` code a little more neatly - or rather, **you** can, as a nice little exercise!

### Vtable Datatypes

The next major thing that Parrot needs to implement is PMCs; these are almost like Perl 5's SVs, only more so. A PMC is an object of some type, which can be instructed to perform various operations. So when we say

          inc P1
        

to increment the value in PMC register 1, the `increment` method is called on the PMC - and it's up to the PMC how it handles that method.

PMCs are how we plan to make Parrot language-independent - a Perl PMC would have different behavior from a Python PMC or a Tcl PMC. The individual methods are function pointers held in a structure called a **vtable**, and each PMC has a pointer to the vtable which implements the methods of its "class." Hence a Perl interpreter would link in a library full of Perl-like classes and its PMCs would have Perl-like behavior.

We've already designed the vtables and the structure of PMCs, but sitting down and implementing them is one of the priorities for Parrot development that will make it truly useful.

### More Todos

There are a huge number of things we want to do with Parrot: We need, for instance, to create some I/O operators to make programs actually interesting; we want to create a range of string functions to deal with various encodings and convert between them; we want more documentation; we really, really need more tests; we want to check Parrot's portability to various platforms; and finally, there are more ops that we need to implement.

### Getting Involved

We have a good number of people working on Parrot, but we could always use a few more. To help out, you'll need a subscription to the [perl6-internals](mailto:perl6-internals-subscribe@perl.org) mailing list, where all the development takes place; you should keep up to date with the CVS version of Parrot - if you want to be alerted to CVS commits, you can subscribe to the [cvs-parrot](mailto:cvs-parrot-subscribe@perl.org) mailing list. CVS commit access is given to those who taken responsibility for a particular area of Parrot, or who often commit high-quality patches.

A useful Web page is [cvs.perl.org](http://cvs.perl.org/), which reminds you how to use CVS and allows you to browse the CVS repository; the [code](http://dev.perl.org/perl6/code) page is a summary of this information and other resources about Parrot.

So don't delay - pick up a Parrot today!
