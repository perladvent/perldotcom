{
   "categories" : "data",
   "date" : "2015-10-06T13:18:48",
   "image" : "/images/197/B45BD4D2-6C2C-11E5-BA94-117C46321329.png",
   "slug" : "197/2015/10/6/Display-real-time-data-with-Curses",
   "description" : "How to create terminal interfaces",
   "authors" : [
      "brian-d-foy"
   ],
   "title" : "Display real-time data with Curses",
   "thumbnail" : "/images/197/thumb_B45BD4D2-6C2C-11E5-BA94-117C46321329.png",
   "tags" : [
      "terminal",
      "du",
      "filesystem"
   ],
   "draft" : false
}


Sometimes a terminal interface is the easiest way to get an answer, and when it is, I like to use Curses to make the experience pleasant. In this article, I'll rewrite a Curses program I've written many times, mostly because I forget where I had put it the last time I created it (and this time I found that I'd posted it to [Perlmonks](http://www.perlmonks.org/index.pl/jacques?node_id=388218)).

Every time I reinvent it I write it a little differently than I did before, and now I want to update it for Perl's new features, mainly its [subroutine signatures](http://www.effectiveperlprogramming.com/2015/04/use-v5-20-subroutine-signatures/).

One day I had a small task to prune a directory tree and I wanted to look at the largest files in it. I knew about `du` and that it could show me a list of files and their sizes:

```perl
$ du -a
16  ./apache2/extra
16  ./apache2/original/extra
32  ./apache2/original
0   ./apache2/other
16  ./apache2/users
192 ./apache2
0   ./asl
104 ./certificates
...
12904
```

The problem is the command's depth-first traversal. I could play various tricks to sort the output once I had it, but for a large directory I want to see the results as they come in. Perl, being the Unix glue language (Swiss Army Chainsaw, etc.), is perfect for this. I can read the real-time output of `du` and display it how I like.

The first part is easy. I can open a pipe to the external command (see my earlier article [Stupid open tricks](http://perltricks.com/article/182/2015/7/15/Stupid-open---tricks)). This time, I use the three-argument pipe-open instead of the two-argument form I'd used earlier.

```perl
open my $pipe, '-|', 'du -a';
```

After that, I need to display the data. My concept is that the on-screen list will update with the largest files so far. I take each line of output, split it into its size and filename, and add them to the list. I've created a class to handle that, including the parts that decide which files are large enough to display:

```perl
my $files = Local::files->new;

while( <$pipe> ) {
  chomp;
  my( $size, $file ) = split /\s+/, $_, 2;
  next if -d $file;
  next if $file eq ".";
  $files->add( $size, "$file" );
}
```

The next part I update for Perl 5.12's [package NAME BLOCK](http://www.effectiveperlprogramming.com/2013/08/declare-packages-outside-of-their-block/) syntax that allows me to declare the `package` outside of its block:

```perl
package Local::files {
  ...
}
```

The rest is list manipulation and Curses stuff. I won't go through the list code. Basically, if the next item is greater than the size of the last element in the list, the new, larger element replaces the existing one. After that, I resort the list.

The setup for Curses is easy. It knows the screen size already:

```perl
sub init ($self) {
  initscr;
  curs_set(0); # hide cursor
  $win = Curses->new;

  for( my $i = MAX; $i >= 0; $i-- ) {
    $self->size_at( $i, undef );
    $self->name_at( $i, '' );
  }
}
```

I need to remember to undo all the magic that Curses does by calling `endwin` at the end, so I put the `DESTROY` right after the part I go through the initial setup:

```perl
sub DESTROY { endwin; }
```

Once I have the sorted list, I have to draw it to the screen. This involves two things. I need to erase what's already there so a shorter filename doesn't leave parts of a longer filename it might replace. The `addstr` puts text on the screen (the top-left corner being (1,1)). None of the new text shows up until I call `refresh`:

```perl
sub draw ($self) {
  for( my $i = 0; $i < MAX; $i++ ) {
    next if $self->size_at( $i ) == 0 or $self->name_at( $i ) eq '';
    $win->addstr( $i,  1, " " x $Curses::COLS );
    $win->addstr( $i,  1, sprintf( "%8d", $self->[$i][SIZE] || '' )  );
    $win->addstr( $i, 10, $self->name_at( $i ) );
    $win->refresh;
  }
}
```

Now I have a little script that makes some fancy output to the screen as I sort the list of largest files in real time. Here's a run against my [MiniCPAN]({{<mcpan "CPAN::Mini" >}}) directory:

The way I've written it, I have to run it from the directory I want to check. I can avoid all sorts of nonsense with taint-checking and weird directory names that way. You could easily make it work otherwise. You could even adapt this program to list something else. The list management stuff is already there and it doesn't really care about the particular problem. The full code is on [GitHub as briandfoy/du-curses](https://github.com/briandfoy/du-curses/blob/master/curses.pl).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
