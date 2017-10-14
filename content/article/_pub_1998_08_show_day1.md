{
   "title" : "Day 1 Highlights: Lincoln's Cool Tricks and Regexp",
   "slug" : "/pub/1998/08/show/day1.html",
   "date" : "1998-08-18T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "brent-michalski"
   ],
   "image" : null,
   "tags" : [],
   "categories" : "community",
   "description" : null,
   "thumbnail" : null
}



### Monday's Highlights

\

The first day of The Perl Conference is behind us and the knowledge
sharing is in high gear.

Today I attended two excellent tutorials. The first was called *Cool
Tricks with Perl and Apache* by Lincoln Stein and the second was
*Understanding Perl Regular Expressions* by Jeffrey Friedl.

#### Cool Tricks with Perl and Apache

*Cool Tricks with Perl and Apache* was the ideal seminar for anyone
running a web server. Yes, the seminar was geared toward the
[Apache](http://www.apache.org) web server but the concepts and most of
the code that Lincoln provided is useful for any webmaster/developer.

Lincoln talked extensively about how to manage and process log files.
This may seem like a trivial task on the surface, but managing an
ever-growing file is not as easy as working with just any file. Lincoln
provided useful tips and code to help.

My favorite example that Lincoln talked about was how to set up an
Apache web server to log to a mySQL database instead of the standard
text files. By doing this, you are able to perform ad-hoc queries on the
data on anything we choose. Since the log files are in a SQL database,
to get at the data you simply use SQL to select and manipulate the data
that you are looking for.

A very humorous moment, although unintended, according to Lincoln,
occurred when he was talking about using Perl to monitor a remote
server. The script he was demonstrating connected to a site and used the
LWP libraries *head* command. The site Lincoln referred to was the White
House. Since the latest White House scandal is still on everyone's mind,
this struck the crowd as very funny and several other funny comments
followed (none of which I wish to discuss here). *See the kind of fun
you miss if you don't come to the conference?*

#### Understanding Regular Expressions

The *Understanding Perl Regular Expressions* was an excellent seminar by
Jeffrey Friedl. Jeffrey did a wonderful job of explaining some of the
details of how Perl handles regular expressions.

Trying to explain regular expressions in a three-hour seminar is no easy
task. Heck, trying to explain regular expressions in a fifty-hour
seminar would be hard!

Having been out of Jeffrey's seminar for several hours now, still my
head is spinning. If you think you have regular expressions under
control, and can write them with your hands tied behind your back...
think again! Jeffery show several examples of simple regular expressions
that looked harmful enough, but didn't work anything like you would
expect!

One quick example: If you pass the string **ab ab ab ab** into this
regular expression: `/a*((ab)*|b*)/` what would you expect it to match?
Well, the `b*` will **never ever** be evaluated because the asterisks
inside the parenthesis make it *always* match. Also, since the **a**
matches and then we hit an asterisk, this regular expression really only
matches the **a** and then exits! Remember, the asterisk means *match
zero or more times.*

Jeffrey had many more examples that looked innocent enough, but were
basically regular expression death-traps. The examples provided in the
seminar are too detailed to explain here, but if/when I get the links to
the seminar notes, I will post the URL where you can find them.

#### Suds

After today's conference, it was *buy-Randal-beer night.* How do these
guys get such great nights named after them? Anyway, several of us had
an enjoyable evening at the Tied House Brewery and Cafe talking about
Perl and visiting with Randal. *When is buy-Brent-beer night?* ;-)

Tuesday promises to be an exciting day also. I will be at the *Advanved
Perl Fundamentals* seminar by Randal Schwartz. It is an all-day seminar
that promises to be an awesome learning experience! I will let you know
about it tomorrow.

It is not too late to get here and get a lot out of the conference!
Larry Wall gives his "State of the Onion" address Wednesday morning.
