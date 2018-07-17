{
   "description" : "An easy trick that saves you time",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "133/2014/11/10/Boost-your-Perl-productivity-with-auto-compile-checking",
   "image" : "/images/133/8CD1623C-68E1-11E4-99FF-327195E830D2.jpeg",
   "categories" : "testing",
   "date" : "2014-11-10T14:01:51",
   "draft" : false,
   "tags" : [
      "perl",
      "compile",
      "check",
      "vim",
      "sublime_text",
      "text_editor",
      "watch",
      "syntastic"
   ],
   "title" : "Boost your Perl productivity with auto-compile checking",
   "thumbnail" : "/images/133/thumb_8CD1623C-68E1-11E4-99FF-327195E830D2.jpeg"
}


The Perl command line option `-c` causes Perl to check the syntax of the program, but not execute it (apart from code in BEGIN, CHECK and UNITCHECK blocks - watch out for those). For example:

```perl
$ perl -c lib/Devel/DidYouMean.pm
lib/Devel/DidYouMean.pm syntax OK
```

This is useful but it's kind of clunky to type it every time you want to check the syntax of a program or file.

### Continuous syntax checking

One of my favourite [features]({{<mcpan "Catalyst::Manual::Tutorial::02_CatalystBasics#The-Simplest-Way" >}}) when developing Catalyst web apps is using the test server to automatically check the syntax of the web app as I develop it. This saves me time as I know immediately if the web app compiles or not and don't waste time opening up a browser only to get an error. if you're working on a Unix-based operating system you can achieve a similar effect for any Perl program (not just web apps). The `watch` program can automatically run the check command. Just start a new terminal, and enter:

```perl
$ watch 'perl -c lib/Devel/DidYouMean.pm'
```

Giving this output:

```perl
Every 2s perl -c lib/Devel/DidYouMean.pm           Sat Nov  8 2014

lib/Devel/DidYouMean.pm syntax OK
```

In this case I'm watching the file `lib/Devel/DidYouMean.pm` but you can provide any path to a Perl file that you want to check for syntax errors. By default `watch` will run the command every 2 seconds. So if I save a bad update to the file, the watching terminal window will show the error:

```perl
Every 2.0s: perl -c lib/Devel/DidYouMean.pm           Sat Nov  8 2014

syntax error at lib/Devel/DidYouMean.pm line 122, near "} keys"

lib/Devel/DidYouMean.pm had compilation errors.
```

This enables me to catch the error before running the program, saving time.

### Checking syntax in a text-editor

Using `watch` is useful, but I find it can be annoying to have to check a separate terminal window to know if my program compiles or not. Another way to do this is to run the command from within your text-editor. I'll show how you how to do this in vim, but it should be possible to do this in any text-editor that has save events which you can hook in to (e.g. examples for [Sublime Text](http://www.klaascuvelier.be/2013/06/sublime-command-on-save/) and [Emacs](http://flycheck.readthedocs.org/en/latest/)).

Add the following line to your .vimrc file:

```perl
autocmd BufWritePost *.pm,*.t,*.pl echom system("perl -Ilib -c " . '"' . expand("%:p"). '"' )
```

What this command does is every time a file ending in .pm, .t, or.pl is saved, vim will run the check syntax command on the file, echoing the results to the current window. Reload your .vimrc with this vim command: `:so $MYVIMRC`.

Now you don't have to bother setting up a separate terminal window and watching the file; vim will notify you immediately if any Perl file is saved with compilation errors. Much more convenient!

### Alternative Methods in Vim

Several readers got in touch to recommend the Syntastic [plugin](https://github.com/scrooloose/syntastic) for Vim ([manual](https://github.com/scrooloose/syntastic)). One nice thing about Syntastic is you can chain compile checks: first run `perl -c`, if it passes, then run [Perl::Critic]({{<mcpan "Perl::Critic" >}}) and so on. Syntastic also integrates syntax checkers for many other languages, so if Vim is your editor of choice, you might want to check it out.

A simpler alternative to Syntastic is to use Vim's built-in compiler support. With a Perl file in the current buffer, type:

```perl
:compiler perl
:make
:cope
```

This will run Perl's syntax checks checks on the current buffer. Vim reads the output into an error list, which the `:cope` command displays. You can jump to the line referenced by a specific error by pressing the enter key ([manual](http://vimdoc.sourceforge.net/htmldoc/quickfix.html#quickfix-window)).

**Updates:** *BEGIN, CHECK, UNITCHECK blocks caution added. Emacs link and addition Vim methods added. 2014-11-10*

*Vim autocmd example updated to handle filepaths containing spaces. Thanks to Henry An for the suggestion. 2015-01-22*

*Cover image [©](https://creativecommons.org/licenses/by/4.0/) [Alan Kotok](https://www.flickr.com/photos/runneralan/10092757714/in/photolist--88qSeT-88u7R1-dqTSLE-atoyrp-bD3QaN-93yNyq-8QYfKX-diG9h4-bD3NV9-88u847-gnS2f3-55QWyu-dqTHcF-9AJTkV-88qSdr-7h39AP-7nPgCT-88qSfv-5MyRfE-bRXxYv-bD3PXU-88u7pC-imjBX2-8xz38b-32eo27-a8YVvZ-8WJgFA-93ySDG-57KLMs-oYUnQ1-88qRL4-fturhH-88qRMx-cUx3nS-4GMFL2-88qSrv-5RhqjZ-ftuqAr-ehAoHf-ftJLsq-88u7fU-5R22Pk-5CNDM-bv2wve-9vnwcd-6dyA62-ejP2nf-329MpH-88u7ds) image has been digitally altered*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
