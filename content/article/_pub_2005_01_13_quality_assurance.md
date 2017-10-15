{
   "date" : "2005-01-13T00:00:00-08:00",
   "categories" : "debugging",
   "image" : null,
   "title" : "An Introduction to Quality Assurance",
   "tags" : [
      "automated-testing",
      "perl-qa",
      "perl-testing",
      "quality-assurance",
      "software-quality",
      "test-plans",
      "test-specifications"
   ],
   "thumbnail" : "/images/_pub_2005_01_13_quality_assurance/111-sure_quality.gif",
   "description" : " On Being Wrong When I decided to study computer science, I installed Linux on my computer and bought a copy of \"The C Programming Language\" by Kernighan and Ritchie. I have been trying to solve software problems ever since....",
   "slug" : "/pub/2005/01/13/quality_assurance.html",
   "draft" : null,
   "authors" : [
      "tom-mctighe"
   ]
}



### On Being Wrong

When I decided to study computer science, I installed Linux on my computer and bought a copy of "The C Programming Language" by Kernighan and Ritchie. I have been trying to solve software problems ever since. After much heartache, I decided that if I was to continue programming I would have to come to terms with being wrong, because I quickly discovered that being wrong is a big part of the development cycle: you code, compile, view the errors, and then code some more. I found it helpful to actually say "I am wrong" when the compiler complained, to remind myself where the fault lay. It made finding problems a lot easier when I accepted responsibility for the errors.

### Enjoy the Ride

To deal with the frustration of constantly being wrong, I began to view programming more as a game that I enjoyed than as an epic battle, and I started looking at things from the compiler's perspective. This view has improved my overall approach to software immensely. I was also fortunate to discover *[Perl Debugged](http://www.perldebugged.com/)* by Peter Scott and Ed Wright. The authors provide a wealth of information about debugging and testing Perl scripts, but they also emphasize that the right mental attitude is often the key to a programmer's success. Basically, they say that you should enjoy what you do.

Bugs come in many flavors, from syntax errors to errors of logic. Perl's interpreter will catch most typos, especially if you `use warnings`, but some can be tricky--and errors of logic are often even harder to tease out.

Here is a common syntax error:

    if ($two_plus_two = 5) {
       print "two plus two is five"; 
    } else {
       # I never seem to get here...
    }

Here is common logical error:

1.  I know of software companies that let their customers find their bugs for them.
2.  These companies are worth millions of dollars.
3.  If I let my customers find my bugs for me, I will be worth millions of dollars.

This particular error can lead to embarrassing code such as the following:

    sub handle_error() {

    print <<END;

       Dear Friend,
          We realize this may be a difficult time 
          for you, but there has been an SQL error. 
          Please email us for further assistance, 
          or try entering your obituary again. 
          Thank you. 

    END
    }

Now, anyone who wants to sleep easy at night will want to avoid shameful code like this, because slowly but surely, users are becoming less tolerant of buggy code. If you haven't done so already, you will want to read through Michael G. Schwern's [Test::Tutorial](http://search.cpan.org/perldoc?Test::Tutorial) and get started. Test-based development, combined with quality assurance, can enable a company to offer its customers a rare and valuable commodity: reliable software. In the future, the world of software may very well be divided between the companies that incorporate testing into their development cycle and those that used to be in business.

### Parts of a Test

When the compiler stops complaining, many developers are happy to declare victory and move on to the next project, but for the tester (often just the developer with his hat on backwards), things are just becoming interesting. Testers begin by breaking the program into sections, as Lydia Ash does in *[The Web Testing Companion](http://www.wiley.com/WileyCDA/WileyTitle/productCd-0471430218.html)*. She notes the following five basic software functions:

1.  Accepting input
2.  Giving output
3.  Saving data
4.  Manipulating data
5.  Removing data

To begin testing, start at the top of the list and work down, one section at a time. At this point in the process, you really understand why everyone always tells you to write modular code. It is much easier to work through the list if you've broken your program into the functions `get_input()`, `display_members()`, `add_member()`, `update_info()`, and `delete_member()`.

### Where to Look

When asked where to look for bugs, software testers sometimes speak of the "joints" between program components, "equivalence classes," and "edge values." These are the primary points of weakness in an application.

An example of a joint is the place where your software interacts with a third-party module. It's important to make sure that all of the components send and receive what you think they should.

An equivalence class is a class of data that follows the same data path through the program. Consider a program that divides the number 50 by whatever number the user enters and either returns a positive integer or tells them why the answer is not a positive integer. You might have the following classes: negative numbers; the number zero; the numbers 1, 2, 5, 10, 25, and 50; numbers greater than 50; and non-numbers. Consider the following incomplete but well-intentioned code:

    sub factor_of_50 {
        my $divisor = shift;
        my $result  = 50 / $divisor;

        return $result if $result == int( $result );
        return "$divisor is negative" if $result < 0;
        return "$result is not an integer";
    }

In this case, good tests should start with -1, 0, 1, 49, and 51, the edge values for this program, to test the different paths through the code. Edge values define the limits of the program, values near and past the stated minimum and maximum that the program should handle. In the example above, you'd also want to enter a string of letters and punctuation to see how the program handles it. Then, compare the test results to the program's specification, which tells you which inputs should work and what outputs the users should see.

### Specifications

Any non-trivial program needs to have a specified list of what it should do. This list of requirements lays a foundation on which to build the software and against which testers can test. There must be a specification of quality from the beginning, or else there is no way to tell if the program has passed or failed a given test. Functional specifications tell you about the program's logic, while non-functional specifications include things like the speed of the application, usability issues for a user interface, and security.

### Writing Tests

Once you have a specification, you can make a test inventory--a list of all the tests you need to write in order to prove that the software meets the specifications. Of course, you need to eliminate all the bugs that crash the program and as many more as you can find, but when do you say enough is enough?

In *[Software Testing Fundamentals](http://he-cda.wiley.com/WileyCDA/HigherEdTitle/productCd-047143020X,courseCd-CX4700.html)*, Marnie Hutcheson describes her Most Important Tests method. This process tries to determine which tests will be most valuable to run. Essentially, it is a way to present management with the opportunity to weigh the tradeoffs between further testing and pushing the product to market sooner.

### Reporting

Reporting is, of course, crucial to testing. You test, trying to get the software to fail, so that you can report the bugs you find back to the development team, so they can fix things before the software's release. A clear, informative bug report is the only one worth writing. Here is a template for a web application's bug report from *The Web Testing Companion*.

SERVER CONFIG
Operating System: &lt;Operating system and hardware, if applicable.&gt;
Software Build: &lt;Build-number of your software.&gt;
Topology: &lt;If you have multiple topologies where you test your server in-house.&gt;

CLIENT
OS: &lt;Operating system, service packs, and other dependent DLL versions, if applicable&gt;
Browser: &lt;Browser and version&gt;

DESCRIPTION
&lt;Brief description of the problem&gt;

Repro (short for reproduction)

1.  &lt;Very descriptive steps showing how to recreate the problem&gt;
2.   
3.   

Result:
&lt;Description of exactly what happens after the last repro step&gt;

Expected Results:
&lt;Description of what should have happened after the last repro step&gt;

Notes:
&lt;Add any information about when this was last verified or what this might be related to here&gt;

### Final Thoughts

When all the tests have finshed, the tester turns the repro reports in to the development team and starts looking forward to the next project. If there are any bugs found, the developer is back to square one: debugging. The process has come full circle. Hopefully, after a few more iterations, everyone can go out and have a paintball war.

Software development and software testing require two different mindsets. Sometimes it is hard for one person to switch back and forth between them, but testing is essential to the success of any non-trivial software project in the same way that editing is essential for any non-trivial writing project. Without it, progress is ponderous, at best.

In conclusion, I'd like to list the nine debugging rules from David J. Agans' excellent book, *[Debugging](http://www.debuggingrules.com/Debugging_CH1.PDF)*. His book clarifies these essential debugging concepts and is mandatory reading for anyone who fixes things:

1.  Understand the system
2.  Make it fail
3.  Quit thinking and look
4.  Divide and conquer
5.  Change one thing at a time
6.  Keep an audit trail
7.  Check the plug
8.  Get a fresh view
9.  If you didn't fix it, it isn't fixed

### Bibliography

Agans, David J. *Debugging*, American Management Association, 2002

Ash, Lydia. *The Web Testing Companion*, Wiley, 2003

Hutcheson, Marnie L. *Software Testing Fundamentals*, Wiley, 2003

Scott, Peter J.; Wright, Ed. *Perl Debugged*, Addison-Wesley Pub Co, 2001
