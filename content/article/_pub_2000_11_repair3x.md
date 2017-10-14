{
   "draft" : null,
   "title" : "Red Flags Return",
   "slug" : "/pub/2000/11/repair3x.html",
   "date" : "2000-11-28T00:00:00-08:00",
   "tags" : [],
   "categories" : "development",
   "authors" : [
      "mark-jason-dominus"
   ],
   "image" : null,
   "description" : "What's Wrong With This Picture? -> Astute readers had a number of comments about last week's Program Repair Shop and Red Flags article. Control Flow Puzzle In the article, I had a section of code that looked like this: $_...",
   "thumbnail" : null
}





Astute readers had a number of comments about last week's [Program
Repair Shop and Red Flags](/media/_pub_2000_11_repair3x/repair3.html)
article.

### [Control Flow Puzzle]{#control flow puzzle}

In the article, I had a section of code that looked like this:

           $_ = <INFO> until !defined($_) || /^(\* Menu:|\037)/;
           return @header if !defined($_) || /^\037/;

I disliked the structure and especially the repeated tests. I played
with it, changing it to

+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| •[Control Flow Puzzle](#control%20flow%20puzzle)\                     |
| •[Pattern Matching](#pattern%20matching)\                             |
| •[Synthetic Variables](#synthetic%20variables)\                       |
| •[Send More Code](#send%20more%20code)\                               |
+-----------------------------------------------------------------------+

            while (<INFO>) {
              last if /^\* Menu:/;
              return @header if /^\037/;
            }
            return @header unless defined $_;

and then used Simon Cozens' suggestion of

            do { 
              $_ = <INFO>; 
              return @header if /^\037/ || ! defined $_ 
            } until /^\* Menu:/ ;

This still bothered me, because `do...until` is unusual. But I was out
of time, so that's what I used.

Readers came up with two interesting alternatives. Jeff Pinyan
suggested:

            while (<INFO>) {
              last if /^\* Menu:/;
              return %header if /^\037/ or eof(INFO);
            }

This is perfectly straightforward, and the only reason I didn't think of
it was because of my prejudice against `eof()`. In the article, I
recommended avoiding `eof()`, and that's a good rule of thumb. But in
this case, I think it was probably the wrong way to go.

After I saw Jeff's solution, I thought more about `eof()` and tried to
remember what its real problems are. The conclusion I came to is that
the big problem with `eof()` occurs when you use it on a filehandle that
is involved in an interactive dialogue, such as a terminal.

Consider code like this:

            my ($name, $fav_color);
            print "Enter your name: ";
            chomp($name = <STDIN>);
            unless (eof(STDIN)) {
              print "Enter your favorite color: ";
              chomp($fav_color = <STDIN>);
            }

This seems straightforward, but it doesn't work. (Try it!) After user
enters their name, we ask for `eof()`. This tries to read another
character from `STDIN`, which means that the program is waiting for user
input *before* printing the second prompt! The program hangs forever at
the `eof` test, and the only way it can continue is if the user
clairvoyantly guesses that they are supposed to enter their favorite
color. If they do that, then the program will print the prompt and
immediately continue. Not very useful behavior! And under some
circumstances, this can cause deadlock.

However, in the example program I was discussing, no deadlock is
possible because the information flows in only one direction - from a
file into the program. So the use of `eof()` would have been safe.

Ilya Zakharevich suggested a solution that I like even better:

          while (<INFO>) {
              return do_menu() if /^\* Menu:/;
              last if /^\037/;
          }
          return %header;

Here, instead of requiring the loop to fall through to process the menu,
we simply put the menu-processing code into a subroutine and process it
inside the loop.

Ilya also pointed out that the order of the tests in the original code
is backward:

        return @header if /^\037/ || ! defined $_

It should have looked like this:

        return @header if ! defined $_  || /^\037/;

Otherwise, we're trying to do a pattern-match operation on a possibly
undefined value.

Ilya also suggested another alternative:

        READ_A_LINE: {
          return %header if not defined ($_ = <INFO>) or /^\037/;
          redo READ_A_LINE unless /^\* Menu:/;
        }

Randal Schwartz suggested something similar. This points out a possible
rule of thumb: When Perl's control-flow constructions don't seem to be
what you want, try decorating a bare block.

### [Oops!]{#oops!}

I said:

> now invoke the function like this:
>
>         $object = Info_File->new('camel.info');

Unfortunately, the function in question was named `open_info_file`, not
`new`. The call should have been

        $object = Info_File->open_info_file('camel.info');

I got the call right in my test program (of *course* I had a test
program!) but then mixed up the name when I wrote the article. Thanks to
Adam Turoff for spotting this.

### [Pattern Matching]{#pattern matching}

In the article, I replaced this:

        ($info_file) = /File:\s*([^,]*)/;
            ($info_node) = /Node:\s*([^,]*)/;
            ($info_prev) = /Prev:\s*([^,]*)/;
            ($info_next) = /Next:\s*([^,]*)/;
            ($info_up)   = /Up:\s*([^,]*)/;

With this:

        for my $label (qw(File Node Prev Next Up)) {
              ($header{$label}) = /$label:\s*([^,]*)/;
            }

Then I complained that Perl must recompile the regex each time through
the loop, five times per node. Ilya pointed out the obvious solution:

         $header{$1} = $2 
             while /(File|Node|Prev|Next|Up):\s*([^,]*)/g;

I wish I had thought of this, because you can produce it almost
mechanically. In fact, I think my original code betrays a red flag
itself. Whenever you have something like this:

        for $item (LIST) {
              something involving m/$item/;
            }

this is a red flag, and you should consider trying to replace it with
this:

        my $pat = join '|', LIST;
            Something involving m/$pat/o;

As a simple example, consider this common construction:

        @states = ('Alabama', 'Alaska', ..., 
                   'West Virginia', 'Wyoming');
            $matched = 0;
            for $state (@states) {
              if ($input =~ /$state/) { 
                $matched = 1; last;
              }
            }

It's more efficient to use this instead:

        my $pat = join '|', @states;
            $matched = ($input =~ /$pat/o);

Applying this same transformation to the code in my original program
yields Ilya's suggestion.

### [Synthetic Variables]{#synthetic variables}

My code looked like this:

        while (<INFO>) {
              return 1 if /^\037/;    # end of node, success.
              next unless /^\* \S/;   # skip non-menu-items
              if (/^\* ([^:]*)::/) {  # menu item ends with ::
                  $key = $ref = $1;
              } elsif (/^\* ([^:]*):\s*([^.]*)[.]/) {
                  ($key, $ref) = ($1, $2);
              } else {
                  print STDERR "Couldn't parse menu item\n\t$_";
                  next;
              }
              $info_menu{$key} = $ref;
            }

Ilya pointed out that in this code, `$key` and `$ref` may be synthetic
variables. A synthetic variable isn't intrinsic to the problem you're
trying to solve; rather, they're an artifact of the way the problem is
expressed in a programming language. I think `$key` and `$ref` are at
least somewhat natural, because the problem statement *does* include
menu items with names that refer to nodes, and `$key` is the name of a
menu item and `$ref` is the node it refers to. But some people might
prefer Ilya's version:

           while (<INFO>) {
               return 1 if /^\037/;        # end of node, success.
               next unless s/^\* (?=\S)//; # skip non-menu-items
               $info_menu{$1} = $1, next if /^([^:]*)::/; 
               $info_menu{$1} = $2, next if /^([^:]*):\s*(.*?)\./;
               print STDERR "Couldn't parse menu item\n\t* $_";
           }

Whatever else you say about it, this reduces the code from eleven lines
to six, which is good.

### [Old News]{#old news}

Finally, a belated correction. In the *second* [Repair Shop and Red
Flags Article](/media/_pub_2000_11_repair3x/commify.html) way back in
June, I got the notion that you shouldn't use string operations on
numbers. While I still think this is good advice, I then tried to apply
it outside of the domain in which it made sense.

I was trying to transform a number like 12345678 into an array like
`('12', ',', '345', ',', '678')`. After discussing several strategies,
all of which worked, I ended with the following nonworking code:

        sub convert {
              my ($number) = shift;
              my @result;
              while ($number) {
                push @result, ($number % 1000) , ',';
                $number = int($number/1000);
              }
              pop @result;      # Remove trailing comma
              return reverse @result;
            }

If you ask this subroutine to convert the number 1009, you get
`('1', ',', '9')`, which is wrong; it should have been
`(1, ',', '009')`. Many people wrote to point this out; I think Mark
Lybrand was the first. Oops! Of course, you can fix this with `sprintf`,
but really the solutions I showed earlier in the article are better.

The problem here is that I became too excited about my new idea. I still
think it's usually a red flag to treat a number like a string. But
there's an exception: When you are formatting a number for output, you
*have* to treat it like a string, because output is always a string. I
think Charles Knell hit the nail on the head here:

> By inserting commas into the returned value, you ultimately treat the
> number as a string. Why not just give in and admit you're working with
> a string.

Thanks, Charles.

People also complained that the subroutine returns a rather peculiar
list instead of a single scalar, but that was the original author's
decision and I didn't want to tamper with it without being sure why he
had done it that way. People also took advantage of the opportunity to
send in every bizarre, convoluted way they would think of to accomplish
the same thing (or even a similar thing), often saying something like
this:

> You are doing way too much work! Why don't you simply use this, like
> everyone else does?
>
>         sub commify {
>               $_ = shift . '*';
>               "nosehair" while s/(.{1,3})\*/*,$1/;
>               substr($_,2);
>             }

I think this just shows that all code is really simple if you already
happen to understand it.

### [Send More Code]{#send more code}

Finally, thanks to everyone who wrote in, especially the people I didn't
mention. These articles have been quite popular, and I'd like to
continue them. But that can't happen unless I have code to discuss. So
if you'd like to see another \`\`Red Flags'' article, please consider
sending me a 20- to 50-line section of your own code. If you do, I won't
publish the article without showing it to you beforehand.


