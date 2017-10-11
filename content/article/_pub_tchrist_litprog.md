{
   "draft" : null,
   "tags" : [],
   "date" : "2000-03-20T00:00:00-08:00",
   "slug" : "/pub/tchrist/litprog",
   "title" : "POD is not Literate Programming",
   "description" : null,
   "thumbnail" : null,
   "categories" : "development",
   "authors" : [
      "mark-jason-dominus"
   ],
   "image" : null
}



  ----------------------------------------------------------------------------
  Table of Contents

  â¢[POD is Not Literate Programming](#POD_is_Not_Literate_Programming)\
  â¢[What is Literate Programming?](#What_is_Literate_Programming_)\
  â¢[How Literate Programming Systems Work](#How_Literate_Programming_Works)\
  Â Â Â â¢[`tangle`](#C_tangle_)\
  Â Â Â â¢[`weave`](#C_weave_)\
  â¢[Summary](#Summary)\
  ----------------------------------------------------------------------------

I frequently come across assertions that POD, Perl's documentation
system, is an example of \`Literate Programming'. For example, FOLDOC,
the Free On-Line Dictionary of Computing, says [\`\`Perl's literate
programming system is called
pod.''](http://burks.bton.ac.uk/burks/foldoc/35/63.htm) The manual for
Ian Clatworthy's Simple Document Format (SDF) package says [\`\`Like
SDF, POD supports literate
programming.''](http://www.mincom.com/mtr/sdf/paper/sdfintro.html#POD)
But POD is *not* literate programming.

Why is this important? POD is a really good idea. But literate
programming is an even better idea. Perl has a long history of borrowing
good ideas from elsewhere. If we go around thinking that POD is literate
programming when it isn't, that'll lead us to disregard literate
programming when we hear about it. \`\`Oh, I already know what that
is,'' we'll say. But we *don't* know what it is, and since it's such an
excellent idea, it would be a shame if we missed out on it just because
we thought we already knew what it was.

[What is Literate Programming?]{#What_is_Literate_Programming_}
===============================================================

Literate programming was invented around 1983 by the very famous Donald
Knuth, author of the TeX typesetting system and the multi-volume series
*The Art of Computer Programming*. It is based on two important ideas.

The first idea is that good program documentation shouldn't be squeezed
into little \`comments'. It should be structured more like a technical
article for a journal, and it should have all the support that a journal
article usually gets, including good typesetting. The programmer should
have the opportunity to annotate each section of the code with as much
explanation as is necessary and appropriate.

So far this sounds just like POD. Where POD comes up short is in the
other important idea.

Knuth's other idea was that the best order to explain the parts of the
program in a journal article is not going to be the same as the order
that the computer needs to see the code. When you write a computer
program, you have to present the code to the computer in a certain
order, or else it doesn't work. This order might not be a good order for
explaining the way the program works.

For example, you might have

            unless (open(F, "< $file")) {
               # 55 lines of error handling here ...        
            }

            $line = <F>;

When you're explaining the program to someone else, you want to talk
about opening the file and reading a line. You don't want to have to
interrupt yourself with a huge digression about the error handling just
because the computer language you're using requires that you put the
error handling in between the open and the read; you'd might prefer to
talk about the main logic first, and return to discuss the
error-handling part much later.

For the same reason, having the error handling code in the middle there
is no just an impediment to you when you try to explain the code, it's
also an impediment to another programmer trying to understand the code.
One frequent criticism of C is that it's too hard to follow the flow of
logic because it is visually dominated by block after block of error
handling code.

It's sometimes possible to work around this kind of problem by using
subroutines or exceptions or some other kind of non-local control flow,
but Knuth's idea goes right to the heart of the problem. When you
program in a literate programming system, you get to write the code in
any order you want to. The literate programming system comes with a
utility program, usually called `tangle`, which permutes the code into
the right order so that you can compile or execute it.

Perl doesn't have anything like `tangle`. You can write comments and
typeset them with your favorite typesetting system, but you still have
to explain the code in an order that makes sense for the perl
interpreter, and not for the person who's trying to understand it.

[How Literate Programming Systems Work]{#How_Literate_Programming_Works}
========================================================================

The world's full of examples of literate programming in action; see the
links at the end of this article. Here's a super-simple incomplete
example, to give you the idea.

This is a fragment of a typical file written in the literate programming
style. You should focus on the main idea, rather than on the details of
syntax, because this example was written for a notional literate
programming system that doesn't actually exist.

            # much code omitted....
            =head1 Open the file
            
            First we will need to open the file.  Blah blah blah.  In a
            real example, this might be much more complicated and might
            require an extended explanation such as a description of the
            algorithm or pictures of the data structures.

            =cut

            unless (open FH, $file) {
              <<handle the errors>>
            }

            =head1 Handle the errors
            
            If `normal' errors occur, we will just ask the user for a new
            filename.  `Normal' errors are if the file doesn't exist
            (perhaps the user mispelled the name) or if the user lacks
            permission to read it.  In case of some other error, such as
            `disk is on fire', the program will abort immediately.

            =cut

            if (   $! =~ /no such file/i
                || $! =~ /permission denied/i) {
              warn "Could not open file `$file': $!.\n";
              <<get new filename and start over>>
            }

            =head1 Process input

            Notice how we don't need to deal with ``get new filename and
            start over'' until we feel like it.  We have postponed that
            section for later.

            =cut

            # and so on...

The file is divided up into sections. Each section has some
documentation, a title, and some code. The code might be incomplete; if
it contains `<<title>>` then that means the code from another section
should be inserted at that point.

A literate programming system comes with two important programs. One,
typically called `tangle`, discards the documentation sections and
rearranges the code into the right order. The output of tangling the
example above would look something like this:

            # Open the file
            unless (open FH, $file) {
              # handle the errors
            if (   $! =~ /no such file/i
                || $! =~ /permission denied/i) {
              warn "Could not open file `$file': $!.\n";
               #Get new filename and start over
               print "Enter new filename: ";
               #[Etc.]
            }

This actually runs. The code from \`Handle the errors' was inserted into
the appropriate place in \`Open the file', and the code from \`Get new
filename and start over' (which I didn't show before) was inserted into
the appropriate place in \`Handle the errors'. This code is ugly, but no
uglier than the output of the C preprocessor, or a C compiler. Just
consider the output of `tangle` to be object code: You can run it, but
you don't want to look at it.

[`weave`]{#C_weave_}
--------------------

The other important program that comes with a literate programming
system is typically called `weave`. It formats and typesets the
documentation and the code, generates an appropriate index and table of
contents, and so on. The result of running `weave` on our example above
might look something like this:

+-----------------------------------------------------------------------+
| #### [Open the file]{#open_the_file}                                  |
|                                                                       |
| First we will need to open the file. Blah blah blah. In a real        |
| example, this might be much more complicated and might require an     |
| extended explanation such as a description of the algorithm or        |
| pictures of the data structures.                                      |
|                                                                       |
|     unless (open FH, $file) {                                         |
|       handle the errors                                               |
|     }                                                                 |
|                                                                       |
| #### [Handle the errors]{#handle_the_errors}                          |
|                                                                       |
| If \`normal' errors occur, we will just ask the user for a new        |
| filename. \`Normal' errors are if the file doesn't exist (perhaps the |
| user mispelled the name) or if the user lacks permission to read it.  |
| In case of some other error, such as \`disk is on fire', the program  |
| will abort immediately.                                               |
|                                                                       |
|     warn "Could not open file `$file': $!.\n";                        |
|     if (   $! =~ /no such file/i                                      |
|         || $! =~ /permission denied/i) {                              |
|       get new filename and start over                                 |
|     } else {                                                          |
|       exit 1;                                                         |
|     }                                                                 |
|                                                                       |
| #### [Process input]{#process_input}                                  |
|                                                                       |
| Notice how we don't need to deal with \`\`get new filename and start  |
| over'' until we feel like it. We have postponed that section for      |
| later.                                                                |
|                                                                       |
|     # Much omitted...                                                 |
|                                                                       |
| ### [Index]{##INDEX}                                                  |
|                                                                       |
| -   [Get new filename and start                                       |
|     over](#get_new_filename_and_start_over)                           |
| -   [Handle the errors](#handle_the_errors)                           |
| -   [Open the file](#open_the_file)                                   |
| -   [Process input](#process_input)                                   |
+-----------------------------------------------------------------------+

[Summary]{#Summary}
===================

Literate programming systems have the following properties:

1.  Code and extended, detailed comments are intermingled.

2.  The code sections can be written in whatever order is best for
    people to understand, and are re-ordered automatically when the
    computer needs to run the program.

3.  The program and its documentation can be handsomely typeset into a
    single article that explains the program and how it works. Indices
    and cross-references are generated automatically.

POD only does task 1, but the other tasks are much more important.

Literate programming is an intersting idea, and worth looking into, but
if we think that we already know all about it, we won't bother. Let's
bother. For an introduction, [see Knuth's original
paper](http://www.literateprogramming.com/knuthweb.pdf) which has a
short but complete example. For a slightly longer example, [here's a
library I wrote in literate
style](http://www.plover.com/~mjd/23tree.tgz) that manages 2-3 trees in
C.

Andrew Johnson's new book [*Elements of Programming with
Perl*](http://www.manning.com/Johnson/) uses literate programming
techniques extensively, and shows the source code for a literate
programming system written in Perl.

Finally, [the Literate Programming web
site](http://www.literateprogramming.com/) has links to many other
resources, including literate programming environments that you can try
out yourself.
