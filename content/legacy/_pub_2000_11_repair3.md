{
   "tags" : ["style-guides"],
   "thumbnail" : null,
   "categories" : "development",
   "title" : "Program Repair Shop and Red Flags",
   "image" : null,
   "date" : "2000-11-14T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "mark-jason-dominus"
   ],
   "slug" : "/pub/2000/11/repair3.html",
   "description" : " What's wrong with this picture? The Interface The Code open_info_file start_info_file start_next_part read_next_node Looking for the menu Putting It All Together Red Flags Don't Repeat Code eof() return 0 and return undef Brief Confession What's wrong with this picture?..."
}



<span id="__index__"></span>
[What's wrong with this picture?](#what's%20wrong%20with%20this%20picture)
[The Interface](#the%20interface)
[The Code](#the%20code)
-   [`open_info_file`](#open_info_file)
-   [`start_info_file`](#start_info_file)
-   [`start_next_part`](#start_next_part)
-   [`read_next_node`](#read_next_node)
-   [Looking for the menu](#looking%20for%20the%20menu)

[Putting It All Together](#putting%20it%20all%20together)
[Red Flags](#red%20flags)
-   [Don't Repeat Code](#don't%20repeat%20code)
-   [`eof()`](#eof())
-   [`return 0` and `return undef`](#return%200%20and%20return%20undef)

[Brief Confession](#brief%20confession)

------------------------------------------------------------------------

### <span id="what's wrong with this picture">What's wrong with this picture?</span>

Once again I'm going to have a look at a program written by a Perl beginner and see what I can do to improve it.

This month's program comes from a very old Usenet post. It was posted seven years ago - on Nov. 12, 1993, to be exact - on the `comp.lang.perl` newsgroup. (At that time `comp.lang.perl.misc` had not yet been created.)

The program is a library of code for reading GNU \`\`info'' files. Info files are a form of structured documentation used by the GNU project. If you use the emacs editor, you can browse info files by using the `C-h i` command, for example. An info file is made up of many *nodes*, each containing information about a certain topic. The nodes are arranged in a tree structure. Each node has a header with some meta-information; one item recorded in the header of each node is the name of that node's parent in the documentation tree. Most nodes also have a menu of their child nodes. Each node also has pointers to the following and preceding nodes so that you can read through all the nodes in order.

------------------------------------------------------------------------

### <span id="the interface">The Interface</span>

The code we'll see has functions for opening info files and for reading in nodes and parsing the information in their headers and menus. But before I start discussing the code, I'll show the documentation. Here it is, copied directly from that 7-year-old Usenet posting, typos and all:

        To use the functions:  Call



                &open_info_file(INFO_FILENAME);


        to open the filehandle `INFO' to the named info file.
        Then call


                &get_next_node;


        repeatedly to read the next node in the info file; variables
                $info_file
                $info_node
                $info_prev
                $info_next
                $info_up


        are set if the corresponding fields appear in the node's
        header, and if the node has a menu, it is loaded into
        %info_menu.  When `get_next-node' returns false, you have
        reached end-of-file or there has been an error.

Right away, we can see a major problem. The code is supposed to be a library of utility functions. But the only communication between the library and the main program is through a series of global variables with names like `$info_up`. This, of course, is terrible style. The functions cannot be used in any program that happens to have a variable named `$info_up`, and if you do use it in such a program, you can introduce bizarre, hard-to-find bugs that result from the way the library smashes whatever value that variable had before. The library might even interfere with itself! If you had something like this:

            &get_next_node;
            foo();
            print $info_node;

then you might not get the results you expect. If `foo()` happens to *also* call `get_next_node`, it will discard the value of `$info_node` that the main code was planning to print.

These are the types of problems that functions and local variables were intended to solve. In this case, it's easy to solve the problems: Just have `get_next_node` return a list of the node information, instead of setting a bunch of hardwired global variables. If the caller of the function wants to set the variables itself, it is still free to do that:

            %next_node = &get_next_node;
            ($info_file, $info_node, $info_prev, $info_next, $info_up)
                = @next_node{qw(File Node Prev Next Up)};
            %info_menu = %{$next_node{Menu}}

Or not:

            my (%node) = &get_next_node;
            my ($next) = $node{Next};

If for some reason the caller of `get_next_node` *likes* the global variables, they can still have the original interface:

            sub get_next_node_orig {
              my %next_node = &get_next_node;
              ($info_file, $info_node, $info_prev, $info_next, $info_up)
                  = @next_node{qw(File Node Prev Next Up)};
              %info_menu = %{$next_node{Menu}}
            }

This shows that no functionality has been lost; it is just as powerful to return a list of values as it is to set the global variables directly.

------------------------------------------------------------------------

### <span id="the code">The Code</span>

Now we'll see the code itself. [The entire program is available here](/media/_pub_2000_11_repair3/info.pl). We will be looking at one part at a time.

#### <span id="open_info_file">`open_info_file`</span>

The first function that the user calls is the `open_info_file` function:

        83  sub open_info_file {
        84      ($info_filename) = @_;
        85      (open(INFO, "$info_filename")) 
              || die "Couldn't open $info_filename: $!";
        86      return &start_info_file;
        87  }

Before I discuss the design problems here, there's a minor syntactic issue: The quotation marks around `"$info_filename"` are useless. Perl uses the `"..."` notation to say \`\`Construct a string.'' But `$info_filename` is *already* a string, so making it into a string is at best a waste of time. Moreover, the extra quotation marks can sometimes cause subtle bugs. Consider this innocuous-looking code:

            my ($x) = @_;
            do_something("$x");

If `$x` was a string, this still works. But if `$x` was a *reference*, it probably fails. Why? Because `"$x"` constructs a string that looks like a reference but isn't, and if `do_something` is expecting a reference, it will be disappointed. Such errors can be hard to debug, because the string that `do_something` gets looks like a reference when you print it out. The `use strict 'refs'` pragma was designed to catch exactly this error. With `use strict 'refs'` in scope, `do_something` will probably raise an error like

        Can't use string ("SCALAR(0x8149bbc)") as an ARRAY ref...

Without `use strict 'refs'`, you get a subtle and silent bug.

But back to the code. `open_info_file` calls `die` if it can't open the specified file for any reason. It would probably be more convenient and consistent to have it simply return a failure code in this case; this is what it does if the `open` succeeds, but then `start_next_part` fails. It's usually easier for the calling code to deal with a simple error return than with an exception, all the more so in 1993, when Perl didn't have exception handling. I would rewrite the function like this:

            sub open_info_file {
                ($info_filename) = @_;
                open(INFO, $info_filename) || return;
                return start_info_file();
            }

I also got rid of some superfluous parentheses and changed the 1993 `&function` syntax to a more modern `function()` syntax. It's tempting to try to make `$info_filename` into a private variable, but it turns out that other functions need to see it later, so the best we can do is make it a file-scoped lexical, private to the library, but shared among all the functions in the library.

Finally, a design issue: The filehandle name `INFO` is hard-wired into the function. Since filehandle names are global variables, this is best avoided for the same reason that we wanted to get rid of the `$info_node` variable earlier: If some other part of the program happens to have a filehandle named `INFO`, it's going to be very surprised to find it suddenly attached to a new file.

There are a number of ways to solve this. The best one available in Perl 4 is to have the caller pass in the filehandle it wants to use, as an argument to `open_info_file`. Then the call is effectively using the filehandle as an object. In this case, however, this doesn't work as well as we'd like, because, as we'll see later, the library needs to be able to associate the name of the file with the filehandle. In the original library, this was easy, because the filename was always stored in the global variable `$info_filename` and the filehandle was always `INFO`. The downside of this simple solution is the library couldn't have two info files open at once. There are solutions to this in Perl 4, but they're only of interest to Perl 4 programmers, so I won't go into detail.

The solution in Perl 5 is to use an *object* to represent an open info file. Whenever the caller wants to operate on the file, it passes the object into the library as an argument. The object can carry around the open filehandle and the filename. Since the data inside the object is private, it doesn't interfere with any other data in the program. The caller can have several files open at once, and distinguish between them because each file is represented by its own object.

To make this library into an object-oriented class only requires a few small changes. We add

            package Info_File;

at the top, and rewrite `open_info_file` like this:

        sub open_info_file {
            my ($class, $info_filename) = @_;
            my $fh = new FileHandle;        
            open($fh, $info_filename) || return;
            my $object = { FH => $fh, NAME => $info_filename };
            bless $object => $class;
            return unless $object->start_info_file;            
            return $object;
        }

We now invoke the function like this:

         $object = Info_File->new('camel.info');

The `new FileHandle` line constructs a fresh new filehandle. The next line opens the filehandle, as usual. The line

         my $object = { FH => $fh, NAME => $info_filename };

constructs the object, which is simply a hash. The object contains all the information that the library will need to use in order to deal with the info file - in this case, the open filehandle and the original filename. The `bless` function converts the hash into a full-fledged object of the `Info_File` class. Finally, the

            $object->start_info_file;

invokes the `start_info_file` function with `$object` as its argument, just like calling `start_info_file($object)`. The special \`\`arrow'' syntax for objects is enabled by the `bless` on the previous line. This notation indicates a *method call* on the object; `start_info_file` is the *method*. A method is just an ordinary subroutine. A method call on an object is like any other subroutine call, except that the object itself is passed as an argument to the subroutine.

That was a lot of space to spend on one three-line function, but many of the same issues are going to pop up over and over, and it's good to see them in a simple context.

### <span id="start_info_file">`start_info_file`</span>


        47  # Discard commentary before first node of info file
        48  sub start_info_file {
        49      $_ = <INFO> until (/^\037/ || eof(INFO));
        50      return &start_next_part if (eof(INFO)) ;
        51      return 1;
        52  }

An info file typically has a preamble before the first node, usually containing a copyright notice and a license. When the user opens an info file, the library needs to skip this preamble to get to the nodes, which are the parts of interest. That is what `start_info_file` does. The preamble is separated from the first node by a line that begins with the obscure `\037` character, which is control-underscore. The function will read through the file line by line, looking for the first line that begins with the obscure character. If it finds such a line, it immediately returns success. Otherwise, it moves on to the next \`\`part,'' which I'll explain later.

As I explained in earlier articles, a \`\`red flag'' is an immediate warning sign that you have done something wrong. Use of the `eof()` function is one of the clearest and brightest red flags in Perl. It is almost always a mistake to use `eof()`.

The problem with `eof()` is that it tries to see into the future, whether the *next* read from the filehandle will return an end-of-file condition. It's impossible to actually see the future, so what it really does is try to read some data. If there isn't any, it reports that the next read will also report end-of-file. If not, it has to put back the data that it just read. This can cause weird problems, because `eof()` is reading extra data that you might not have meant to read.

`eof()` is one of those functions like `goto` that looks useful at first, but then it turns out that there is almost always a better way to accomplish the same thing. In this case, the code is more straightforward and idiomatic like this:

        sub start_info_file {
            while (<INFO>) {
              return 1  if /^\037/;
            }
            &start_next_part;
        }

Perl will automatically exit the `while` loop when it reaches the end of the file, and in that case we can unconditionally call `start_next_part`. Inside the loop, we examine the current line to see whether it is the separator, and return success if it is. The assignment to `$_` and the check for end-of-file are now all implicit.

In the object-oriented style, `start_info_file` expects to get an object, originally constructed by `open_info_file`, as its argument. This object will contain the filehandle that the function will read from in place of `INFO`. The rewriting into OO style is straightforward:

        sub start_info_file {
            my ($object) = @_;
            my $fh = $object->{FH};
            while (<$fh>) {
              return 1 if /^\037/;
            }
            $object->start_next_part;
        }

Here we extract the filehandle from the object by asking for `$object->{$fh}`, and then use the filehandle `$fh` in place of `INFO`. The call to `start_next_part` changes into a method call on the object, which means that the object is implicitly passed to the `start_next_part` function so that `start_next_part` *also* has access to the object, including the filehandle buried inside it.

### <span id="start_next_part">`start_next_part`</span>

I promised to explain what `start_next_part` does, and now we're there. An info file is not a single file; it might be split into several separate files, each containing some of the nodes. If the main info file is named `camel.info`, there might be additional nodes in the files `camel.info-1`, `camel.info-2` and so on. This means that when we get to the end of an info file we are not finished; we have to check to see whether it continues in a different file. `start_next_part` does this.

        54  # Look for next part of multi-part info file.  Return 0
        55  # (normal failure) if it isn't there---that just means
        56  # we ran out of parts.  die on some other kind of failure.
        57  sub start_next_part {
        58      local($path, $basename, $ext);
        59      if ($info_filename =~ /\//) {
        60          ($path, $basename) 
                = ( $info_filename =~ /^(.*)\/(.*)$/ );
        61      } else {
        62          $basename = $info_filename;
        63          $path = "";
        64      }
        65      if ($basename =~ /-\d*$/) {
        66          ($basename, $ext) 
                = ($basename =~ /^([^-]*)-(\d*)$/);
        67      } else {
        68          $ext = 0;
        69      }
        70      $ext++;
        71      $info_filename = "$path/$basename-$ext";
        72      close(INFO);
        73      if (! (open(INFO, "$info_filename")) ) {
        74          if ($! eq "No such file or directory") {
        75              return 0;
        76          } else {
        77              die "Couldn't open $info_filename: $!";
        78          }
        79      }
        80      return &start_info_file;
        81  }

The main point of this code is to take a filename like `/usr/info/camel.info-3` and change it into `/usr/info/camel.info-4`. It has to handle a special case: `/usr/info/camel.info` must become `/usr/info/camel.info-1`. After computing the new filename, it tries to open the next part of the info file. If successful, it calls `start_info_file` to skip the preamble in the new part.

The first thing to notice here is that the function is performing more work than it needs to. It carefully separates the filename into a directory name and a base name, typically `/usr/info` and `camel.info-3`. But this step is unnecessary, so let's eliminate it.

        sub start_next_part {
            local($name, $ext);
            if ($info_filename =~ /-\d*$/) {
                ($name, $ext) 
                    = ($info_filename =~ /^([^-]*)-(\d*)$/);
            } else {
                $ext = 0;
            }
            $ext++;
            $info_filename = "$name-$ext";
            # ... no more changes ...
        }

This immediately reduces the size of the function by 25 percent. Now we notice that the two pattern matches that remain are almost the same. This is the red flag of all red flags: Any time a program does something twice, look to see whether you can get away with doing it only once. Sometimes you can't. This time, we can:

        sub start_next_part {
            local($name, $ext);
            if ($info_filename =~ /^([^-]*)-(\d*)$/) {
                ($name, $ext) = ($1, $2);
            } else {
                $name = $info_filename; $ext = 0;
            }
            $ext++;
            $info_filename = "$name-$ext";
            # ... no more changes ...
        }

This is somewhat simpler, and it paves the way for a big improvement: The `$name` variable is superfluous, because its only purpose is to hold an intermediate result. The real variable of interest is `$info_filename`. `$name` is what I call a *synthetic variable*: It's an artifact of the way we solve the problem, and is inessential to the problem itself. In this case, it's easy to eliminate:

        sub start_next_part {
            if ($info_filename =~ /^([^-]*)-(\d*)$/) {
                $info_filename = $1 . '-' . ($2 + 1);
            } else {
                $info_filename .= '-1';
            }
            # ... no more changes ...
        }

If the pattern matches, then `$1` contains the base name, typically `/usr/info/camel.info`, and `$2` contains the numeric suffix, typically `3`. There is no need to copy these into named variables before using them; we can construct the new filename, `/usr/info/camel.info-4` directly from `$1` and `$2`. If the pattern doesn't match, we construct the new file name by appending `-1` to the old file name; this turns `/usr/info/camel.info` into `/usr/info/camel.info-1`.

That takes care of the top half of the function; now let's look at the bottom half:

        sub start_next_part {
            if ($info_filename =~ /^([^-]*)-(\d*)$/) {
                $info_filename = $1 . '-' . ($2 + 1);
            } else {
                $info_filename .= '-1';
            }
            close(INFO);
            if (! (open(INFO, "$info_filename")) ) {
                if ($! eq "No such file or directory") {
                    return 0;
                } else {
                    die "Couldn't open $info_filename: $!";
                }
            }
            return &start_info_file;
        }

The `close(INFO)` is unnecessary, because the `open` on the following line will perform an implicit close. If the file can't be opened the function looks to find out why. If the reason is that the next part doesn't exist, then we're really at the end, and it quietly returns failure, but if there was some other sort of error, it aborts. In keeping with our change to `open_info_file`, we will eliminate the `die` and let the caller die itself, if that is desirable:

        sub start_next_part {
            if ($info_filename =~ /^([^-]*)-(\d*)$/) {
                $info_filename = $1 . '-' . ($2 + 1);
            } else {
                $info_filename .= '-1';
            }
            return unless open(INFO, $info_filename);
            return &start_info_file;
        }

I made a few other minor changes here: Superfluous quotation marks around `$info_filename` are gone, and `if !` has turned into `unless`. Also, I replaced `return 0` with `return`. `return 0` and `return undef` are red flags: They are attempts to make a function that returns a false value. But if the function is invoked in a list context, return values of `0` and `undef` are interpreted as true, not false, because they are one-element lists, and the only false lists are empty ones:

        sub false {
          return 0;
        }

        @a = false();
        if (@a) {          
          print "ooops!\n";
        }

The correct way for a function to return a boolean false value in Perl is almost always a simple `return` as we have here. In scalar context, this returns an undefined value; in list context, it returns an empty list.

The function has gone from 20 lines to 7. Refitting it for object-oriented style does not make it much bigger:

        sub start_next_part {
            my ($object) = @_;
            my $info_filename = $object->{NAME};
            if ($info_filename =~ /^([^-]*)-(\d*)$/) {
                $info_filename = $1 . '-' . ($2 + 1);
            } else {
                $info_filename .= '-1';
            }
            my $fh = $object->{FH};
            return unless open($fh, $info_filename);
            $object->{NAME} = $info_filename;         # ***
            return $object->start_info_file;
        }

Here we extract the info file's filename from the object using `$object->{NAME}`, which we originally set up back in `open_info_file`. We also extract the filehandle from the object using `$object->{FH}` as we did in `start_info_file`. If we successfully open the new file, we store the changed filename back into the object, for next time; this occurs on the line marked `***`.

### <span id="read_next_node">`read_next_node`</span>

Finally, we get to the heart of the library. `read_next_node` actually reads a nodeful of information and returns it to the caller. (The first thing to notice is that the documentation calls this function `get_next_node`, which is wrong. But that's an easy fix.)

As far as this function is concerned, the node has three parts. The first line is the header of the node, which contains the name of the node; pointers to the previous and next nodes; and other metainformation. Then there's a long stretch of text, which is the documentation that the node was intended to contain. Somewhere near the bottom of the text is a menu of pointers to other nodes. `read_next_node` is interested in the header line and the menu. It has three sections: One section to handle the header line, one section to skip the following text until it sees the menu and one section to parse the menu. We'll deal with these one at a time.

         1  # Read next node into global variables.  Assumes that file 
         2  # pointer is positioned at the header line that starts a 
         3  # node.  Leaves file pointer positioned at header line of 
         4  # next node. Programmer: note that nodes are separated by 
         5  # a "\n\037\n" sequence.  Reutrn true on 
          success, false on failure
         6  sub read_next_node {
         7      undef %info_menu;
         8      $_ = <INFO>;                # Header line
         9      if (eof(INFO)) {
        10          return &start_next_part && &read_next_node;
        11      }
        12  
        13      ($info_file) = /File:\s*([^,]*)/;
        14      ($info_node) = /Node:\s*([^,]*)/;
        15      ($info_prev) = /Prev:\s*([^,]*)/;
        16      ($info_next) = /Next:\s*([^,]*)/;
        17      ($info_up)   = /Up:\s*([^,]*)/;

Not much needs to change here. The `undef %info_menu` was an appropriate initialization when `%info_menu` was a global variable, but our function isn't going to use global variables; it's going to return the menu information as part of its return list, so we replace this line with `my %info_menu`. The `eof()` test is a red flag again; it's probably more straightforward to simply check whether `$_` is defined. If it's undefined, then the function has reached the end of the file, and needs to try to open the next part. If that succeeds, then it calls itself recursively to read the first node from the new part. The `&&` used here to sequence those two operations is concise, if a little peculiar. Unfortunately, it won't work any more now that `read_next_node` returns a list of data, because `&&` always evaluates its arguments in scalar context. This section of the code needs to change to:

            $_ = <INFO>;                # Header line
            if (! defined $_) {
                return unless  &start_next_part;      
                return &read_next_node;
            }

The recursive call might be considered a little strange, because it's essentially performing a `goto` back up to the top of the function, and some people might express that with a simple `while` loop. But it's not really obvious that that would be clearer, so I decided to leave the recursive call in.

The subsequent lines extract parts of the header into the global variables `$info_file`, `$info_node` and so on. Since we need to make these items into a data structure to be returned from the function, rather than a set of global variables, it's natural to try this:

            ($header{File}) = /File:\s*([^,]*)/;
            ($header{Node}) = /Node:\s*([^,]*)/;
            ($header{Prev}) = /Prev:\s*([^,]*)/;
            ($header{Next}) = /Next:\s*([^,]*)/;
            ($header{Up})   =   /Up:\s*([^,]*)/;

This works, but as I mentioned before, repeated code is the biggest red flag of all. The similarity of these five lines suggests that we should try a loop instead:
            for my $label (qw(File Node Prev Next Up)) {
              ($header{$label}) = /$label:\s*([^,]*)/;
            }

Here five lines have become two. The downside, however, is that Perl has to recompile the pattern five times for each node, because the value of `$label` keeps changing. There are three things we can do to deal with this. We can ignore it, we can apply the `qr//` operator to precompile the patterns, or we can try to make the five variable patterns into a single constant pattern. My vote here, as for most questions of micro-optimization, is to ignore it unless it proves to be a real problem. The `qr//` solution will be an adequate fallback in that case.

I did also consider combining them into one pattern, but that turns into a disaster:

        ($file, $node, $prev, $next, $up) = 
          /File:\s*([^,]*),\s*Node:\s*([^,]*),\s*
           Next:\s*([^,]*),\s*Prev:\s*([^,]*),\s*
           Up:\s*([^,]*)/x;

Actually, it's worse than that, because some of the five items might be missing from the header line, so we must make each part optional:

        ($file, $node, $prev, $next, $up) = 
          /(?:File:\s*([^,]*),)?\s*(?:Node:\s*([^,]*),)?\s*
           (?:Next:\s*([^,]*),)?\s*(?:Prev:\s*([^,]*),)?\s*
           (?:Up:\s*([^,]*))?/x;

Actually, it's even worse, because the original author was programming in Perl 4 and didn't have `(?:...)` or `/x`. So that tactic really didn't work out.

This brings up an important point that I don't always emphasize as much as I should: It's not always obvious what tactics are best until you have tried them. When I write these articles, I make false starts. I rewrite the code one way, and discover that there are unexpected problems and the gains aren't as big as I thought they were. Then, I try another way and see if it looks better. Sometimes it turns out I was wrong, and the original code wins, as it did in this case.

When you're writing your own code, it won't always be clear how best to proceed. Try it both ways and see which looks better, then throw away the one you don't like as much.

In this article, I had originally planned to rework the library into something that would still have functioned under Perl 4. I wrote a lot of text explaining how to do this. But it turned out that the only good solution was objects, so I did it over, and that's what you see.

The moral: Never be afraid to do it over.

### <span id="looking for the menu">Looking for the menu</span>

OK, end of digression. The function has processed the header line; now it needs to skip the intervening text until it finds the menu part of the node:

        19      $_ = <INFO> until /^(\* Menu:|\037)/ || eof(INFO);
        20      if (eof(INFO)) {
        21          return &start_next_part;
        22      } elsif (/^\037/) { 
        23          return 1; # end of node, so return success.
        24      }

The menu follows a line labeled `* Menu:`. If the function sees the end of the node or the end of the file before it sees `* Menu`, then the node has no menu. There's a bug here: The function should return immediately at the end of the node, regardless of whether it is also the end of the file. As originally written, it calls `start_next_part` at the end of the file, which might fail (if the current node was the last one) and reports the failure back to the caller when it should have reported success. Fixing the bug and eliminating `eof()` yields this:

        $_ = <INFO> until !defined($_) || /^(\* Menu:|\037)/;
        return @header if !defined($_) || /^\037/;

The repeated tests bothered me there, but the best alternative formulation I could come up with was:

        while (<INFO>) {
          last if /^\* Menu:/;
          return %header if /^\037/;
        }
        return %header unless defined $_;

I asked around, and Simon Cozens suggested

        do { 
          $_ = <INFO>; 
          return %header if /^\037/ || ! defined $_ 
        } until /^\* Menu:/ ;

I think I like this best, because it makes the `/^\* Menu:/` into the main termination condition, which is as it should be. On the other hand, `do...until` is unusual, and you don't get the implicit read into `$_`. But four versions of the same code is plenty, so let's move on.

Finally our function is ready to read the menu. A typical menu looks like this:

            * Menu:

            * Numerical types::
            * Exactness::
            * Implementation restrictions::
            * Syntax of numerical constants::
            * Numerical operations::
            * Numerical input and output::

Each item has a title (which is displayed to the user) and a node name (which is the node that the user visits next if they select that menu item). If the title and node name are different, the menu item looks like this:

            * The title:       The node name.

If they're the same (as is often the case) the menu item ends in `::` as in the examples above. The menu-reading code has to handle both cases:

        27      local($key, $ref);
        28      while (<INFO>) {    
        29          return 1 if /^\037/;    # end of node, success.
        30          next unless /^\* \S/;   # skip non-menu-items
        31          if (/^\* ([^:]*)::/) {  # menu item ends with ::
        32              $key = $ref = $1;
        33          } elsif (/^\* ([^:]*):\s*([^.]*)[.]/) {
        34              ($key, $ref) = ($1, $2);
        35          } else {
        36              print STDERR "Couldn't parse menu item\n\t$_";
        37              next;
        38          }
        39          $info_menu{$key} = $ref;
        40      }

I think this code is lovely. I would do only two things differently. First, I would change the error message to include the filename and line number of the malformed menu entry. Perl's built-in `$.` variable makes this easy, and the current behavior makes it too difficult for the programmer to locate the source of the problem. And second, instead of `return`ing directly out of the loop, I would use `last`, because the return value `(%header, Menu => \%menu)` is rather complicated and the code below the loop will have to return the same thing anyway.

In the original prgram, that `return` line calls `start_info_file` again if the function reads to the end of the current part while still reading the menu. This isn't correct; it should simply return success and let the next call to `read_next_node` worry about opening the new part.

The rewritten version of `read_next_node` looks like this:

        sub read_next_node {
            $_ = <INFO>;                # Header line
            if (! defined $_) {
                return unless  &start_next_part;      
                return &read_next_node;
            }

            my (%header, %menu);
            for my $label (qw(File Node Prev Next Up)) {
              ($header{$label}) = /$label:\s*([^,]*)/;
            }

            do { 
              $_ = <INFO>; 
              return %header if /^\037/ || ! defined $_ 
            } until /^\* Menu:/ ;



            while (<INFO>) {    
                my ($key, $ref);
                last if /^\037/;        # end of node
                next unless /^\* \S/;   # skip non-menu-items
                if (/^\* ([^:]*)::/) {  # menu item ends with ::
                    $key = $ref = $1;
                } elsif (/^\* ([^:]*):\s*([^.]*)[.]/) {
                    ($key, $ref) = ($1, $2);
                } else {
                    warn "Couldn't parse menu item at line $. 
                          of file $info_file_name";
                    next;
                }
                $menu{$key} = $ref;
            }

            return (%header, Menu => \%menu);
        }

The code didn't get shorter this time, but that's because it was pretty good to begin with. After making a few straightforward changes to convert it to object-oriented style, we get:

        sub read_next_node {
            my ($object) = @_;
            my ($fh) = $object->{FH};
            local $_ = <$fh>;           # Header line
            if (! defined $_) {
                return unless  $object->start_next_part;      
                return $object->read_next_node;
            }

            my (%header, %menu);
            for my $label (qw(File Node Prev Next Up)) {
              ($header{$label}) = /$label:\s*([^,]*)/;
            }

            do { 
              $_ = <$fh>; 
              return %header if /^\037/ || ! defined $_ 
            } until /^\* Menu:/ ;

            while (<$fh>) {    
                my ($key, $ref);
                last if /^\037/;        # end of node
                next unless /^\* \S/;   # skip non-menu-items
                if (/^\* ([^:]*)::/) {  # menu item ends with ::
                    $key = $ref = $1;
                } elsif (/^\* ([^:]*):\s*([^.]*)[.]/) {
                    ($key, $ref) = ($1, $2);
                } else {
                    warn "Couldn't parse menu item at line $. 
                          of file $object->{NAME}";
                    next;
                }
                $menu{$key} = $ref;
            }

            return (%header, Menu => \%menu);
        }

[The entire object-oriented module is available here](/media/_pub_2000_11_repair3/Info_File.pm).

A simple example program that demonstrates the use of the library:

        use Info_File;
        my $file = shift;
        my $info = Info_File->open_info_file($file)
          or die "Couldn't open $file: $!; aborting";
        while (my %node = $info->read_next_node) {
          print $node{Node},"\n";  # print the node name
        }

------------------------------------------------------------------------

### <span id="putting it all together">Putting It All Together</span>

This time the code hasn't gotten any smaller; it's the same size as it was before. Some parts got smaller, but there was some overhead associated with the conversion to object-oriented style that made the code bigger again.

But the OO style got us several big wins. The interface got better; the library no longer communicates through global variables and no longer smashes `INFO`. It also gained the capability to process two or more info files simultaneously, or the same info file more than once, which is essential if it's to be useful in any large project. Flexibility has increased also: It would require only a few extra lines to provide the ability to search for any node or to seek back to a node by name.

------------------------------------------------------------------------

### <span id="red flags">Red Flags</span>

A summary of the red flags we saw this time:

The Cardinal Rule of Computer Programming is that if you wrote the same code twice, you probably did something wrong. At the very least, you may be setting yourself up for a maintenance problem later on when someone changes the code in one place and not in another.

Programming languages are chock-full of features designed to prevent code duplication from the very lowest levels (features such as `$a[3] += $b` instead of `$a[3] = $a[3] + $b` to the very highest (features such as DLLs and pipes.) In between these levels are essential features such as subroutines and modules.

Each time you see you have written the same code more than once, give serious thought to how you might eliminate all but one instance.

#### <span id="eof()">`eof()`</span>

The Perl `eof()` function is almost always a bad choice. It's typically overused by beginners and by people who have been programming in Pascal for too long.

Perl returns an unambiguous end-of-file condition by yielding an undefined value. Perl's I/O operators are designed to make it convenient to check for this. The `while(<FH>)` construction even does so automatically. Explicit checking of `eof()` is almost never required or desirable.

#### <span id="return 0 and return undef">`return 0` and `return undef`</span>

This is often an attempt to return a value that will be perceived by the caller as a Boolean false. But in list context, it will test as true, not false. Unless the function *always* returns a single scalar, even in list context, it is usually a better choice to use plain `return;` to yield a false value.

Some programmers write `wantarray() ? () : undef`, which does the same thing but is more verbose and confusing.

------------------------------------------------------------------------

### <span id="brief confession">Brief Confession</span>

The program discussed in this article was indeed written by a Perl beginner. I wrote it in 1993 when I had only been programming in Perl for a few months. I must have been pleased with it, because it was the first Perl program that I posted in a public forum.
