{
   "image" : null,
   "slug" : "155/2015/2/26/Hello-perldoc--productivity-booster",
   "description" : "Get to know perldoc to find Perl answers faster",
   "categories" : "apps",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "cpan",
      "documentation",
      "pod",
      "terminal",
      "command_line",
      "perldoc",
      "productivity"
   ],
   "title" : "Hello perldoc, productivity booster",
   "date" : "2015-02-26T13:42:57",
   "draft" : false
}


Imagine this scenario: you're using the DateTime module but you can't remember the exact name of a function it provides. What do you do? You could open your browser, go to [MetaCPAN](https://metacpan.org/), search for DateTime and look up the answer in the module's documentation. A faster way would be to switch to the command line, and type `perldoc DateTime` to display the module's documentation right there in the terminal.

`perldoc` is a command line program for reading Perl documentation. It comes with Perl, so if you've got Perl installed, perldoc should be available too. Using perldoc is easy: as you've already seen, to view the documentation of a module you've installed, at the command line type:

```perl
$ perldoc Module::Name
```

perldoc will search for the module and if it finds it, display the module's documentation (written in Pod). Using perldoc you can learn more about any aspect of Perl almost instantly. Want to know more about Pod? Try `perldoc pod`.

### Dial -f for functions

Perl has a huge number of built-in functions, about 224 depending on the Perl version. Who can remember exactly how they all work? I know I can't. To lookup a Perl function, use perldoc with the `-f` switch. For instance to look up the documentation on the `rindex` function:

```perl
$ perldoc -f rindex
```

Which will display:

    rindex STR,SUBSTR,POSITION
    rindex STR,SUBSTR
          Works just like index() except that it returns the position of the
          last occurrence of SUBSTR in STR. If POSITION is specified,
          returns the last occurrence beginning at or before that position.

Aha! This is all well and good, but what do you do if you can't remember the function name? Well you could use [B::Keywords]({{<mcpan "B::Keywords" >}}), but another way would be to check out `perlfunc` the Perl documentation on built-in functions. To read it, with perldoc just type:

```perl
$ perldoc perlfunc
```

### Predefined Variables

As with functions, Perl has a large number of predefined variables that do everything from storing the program name to tracking the state of the regex engine. They're really useful, but often have obscure names like `$^O` (the OS name). So if you find yourself needing to check whether you're looking at a list separator (`$"`) or an output separator (`$/`), just use perldoc with the `-v` switch:

```perl
$ perldoc -v $/
```

Because some predefined variables have weird names, you may need to quote them on the command line for perldoc to work:

```perl
$ perldoc -v '$"'
```

The predefined variables documentation is known as `perlvar`. It's well worth a read through at least once (`perldoc perlvar`).

### Searching the documentation

Perl has a lot of great documentation, but it can be hard to remember the names of all of the entries. If you ever want to browse the table of contents, use `perl`:

```perl
$ perldoc perl
```

Many people recommend perltoc for this, but for finding relevant entries, I think the perl entry is easier to browse than perltoc.

Perl also has an extensive FAQ, (another entry that's worth a read through). It has loads of answers to common queries. As usual you can read it with `perldoc faq`, but you can also search it using the `-q` switch. Want to know if there are any good IDEs for Perl? (a common newbie question):

```perl
$ perl -q ide
```

    Is there an IDE or Windows Perl Editor?
     Perl programs are just plain text, so any editor will do.

     If you're on Unix, you already have an IDE--Unix itself. The Unix
     philosophy is the philosophy of several small tools that each do one thing
     and do it well. It's like a carpenter's toolbox.

     If you want an IDE, check the following (in alphabetical order, not order
     of preference):

     Eclipse
         

         The Eclipse Perl Integration Project integrates Perl editing/debugging
         with Eclipse.

     Komodo
         

         ActiveState's cross-platform (as of October 2004, that's Windows,
         Linux, and Solaris), multi-language IDE has Perl support, including a
         regular expression debugger and remote debugging.
    ...

### Finding module install locations

perldoc isn't just about documentation. If you need to find out where a module is installed, using the `-l` switch, perldoc will return the filepath of the module:

```perl
$ perldoc -l Test::More
```

If you get the path, you can open it in an editor directly:

```perl
$ vi $(perldoc -l Test::More)
```

One trick here: some modules don't have any POD in them, for those modules, use `-lm` to still return the path.

### Read module source code in perldoc

Finally, perldoc can also display module source code. Just use the `-m` switch:

```perl
$ perldoc -m Test::More
```

### Wrap up

This article has covered the most common features, but perldoc has a bunch of other capabilities that you can read about at the command line with `man perldoc`. The Perl documentation is also [online](http://perldoc.perl.org/).

Keep in mind that as you get more proficient with perldoc, you'll need the online resources less and less. Get in the habit of switching to the command line, looking up something in perldoc and flipping right back to programming - it's a productivity win.

### perldoc cheatsheet

    perldoc [option]

    Module Options                               
    --------------                               
             Module documentation     
    -l       Module filepath          
    -lm      Module filepath (alt.)   
    -m       Module source


    Search Options
    --------------
    -f     Get a built-in function definition
    -v     Get a variable definition
    -q      Search the faq for a keyword


    Commonly Used Entries
    ---------------------
    perl         Language overview, list of all other entries
    perltoc      Table of contents
    perlfunc     Built-in functions documentation
    perlvar      Predefined variables documentation
    perlref      References documentation
    perlre       Regex documentation
    faq          The Perl FAQ

    Help
    ----
    man perldoc     List of all perldoc options

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
