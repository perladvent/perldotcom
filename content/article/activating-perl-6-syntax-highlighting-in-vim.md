{
   "description" : "Four tricks to get the highlighting you want",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-09-22T22:16:48",
   "draft" : false,
   "image" : "/images/194/C75D3D7C-6197-11E5-993C-AA2FD27BB60F.png",
   "categories" : "tooling",
   "slug" : "194/2015/9/22/Activating-Perl-6-syntax-highlighting-in-Vim",
   "title" : "Activating Perl 6 syntax highlighting in Vim",
   "tags" : [
      "config",
      "perl-6",
      "productivity",
      "vim",
      "vimscript",
      "old_site"
   ]
}


Modern versions of the Vim text editor ship with Perl 6 syntax highlighting, but automatically activating it is tricky because Perl 6 files can have ambiguous file extensions. It can get tiresome to correct the file type every time you open a Perl 6 file, so I'm going to show you a few tricks that I use to make Vim detect Perl 6 files automatically.

### Showing and setting the filetype in Vim

First of all I want to make sure that syntax highlighting is turned on by default, so I add this option to my `.vimrc`:

    syntax on

To edit your `.vimrc` just start Vim and enter this command `:e $MYVIMRC`. Save your changes with `:w`, and then reload your `.vimrc` with `:so %`.

Now that I have syntax highlighting turned on, I need to know how set Vim's file type to Perl 6 when I'm working with Perl 6 files. I can see the current file type by typing this command `:set filetype?`. To set the file type to Perl 6, I use this command `:set filetype=perl6`. The `filetype` keyword can be shortened to `ft`. In which case the last command becomes `:set ft=perl6`.

### Detecting Perl 6 files

Now the challenge becomes correctly detecting when I'm working with Perl 6 files in Vim. Perl 6 scripts shouldn't be a problem: Vim (not Vi) automatically parses the [shebang](https://en.wikipedia.org/wiki/Shebang_line) line to determine the file type. However this fails when the script has an extension like `.pl`.

#### Use the .pm6 file extension

Vim will automatically use Perl 6 syntax highlighting if the file extension is `.pm6`. So when working with Perl 6 module files, it's better to use this extension. This doesn't help when I'm working on other people's Perl 6 projects however. It also doesn't help for test files, which do not have an equivalent Perl 6 file extension (`.t6` test files are ignored when installing Perl 6 modules).

#### Use a modeline

A modeline is a line of code in the text of the file which Vim reads and executes. So to activate Perl 6 syntax highlighting I just need to add this modeline to every Perl 6 file I work with:

``` prettyprint
# vim: filetype=perl6
```

Take a look at the [source code](https://github.com/Mouq/json5/blob/master/lib/JSON5/Tiny.pm6#L54) of JSON5::Tiny for a real-World example. To Perl 6 this code looks just like an ordinary comment, but Vim will use it to turn on Perl 6 syntax highlighting. The modeline can appear anywhere in the code, but it's better to place it at the start or end of the file.

Older versions of Vim (pre 7.3) and when Vim is run under root privileges, disable modelines as a security risk. Don't run Vim as root! But if you have an older Vim, you can turn on modelines with `:set modeline`. As with `filetype`, modeline can be abbreviated to `ml`, so `set ml` works too. To activate modelines automatically, add this line to your `.vimrc`:

    set ml

The downside of using modelines? First there is aforementioned security risk for older Vims. Also it feels impure to add editor directives to the code I'm working with, as not everyone uses Vim. These seem like minor issues though.

#### Use a local vimrc

Often different Open Source projects will have different coding conventions that I need to follow, so it can be helpful to use a local vimrc file to store these project-specific settings. This works for syntax highlighting too. In order to use local vimrc files, I add the following code to my `.vimrc`:

    if filereadable(".vimrc.local")
      so .vimrc.local
    endif

This will check the current working directory for `.vimrc.local` file, and automatically execute it if it finds it. **Warning** this is a security risk - Vim will execute ANY instruction in a local vimrc, so I am very careful when working with projects that are not my own. Next I create a `.vimrc.local` file in the root project directory and add this auto command to it:

    au Bufnewfile,bufRead *.pm,*.t,*.pl set filetype=perl6

Now when I open or create any file with a Perl extension, Vim will set the syntax highlighting to Perl 6. I like this technique because it's not intrusive: it doesn't require any changes to the Perl 6 files themselves, so it works well on shared projects (I never check-in my local vimrc to the Git repo).

#### Use code detection

I can also have Vim try to detect Perl 6 code automatically. Two directives which would indicate we're working with Perl 6 instead of Perl 5 code: the shebang line and the `use v6;` directive. To check for these, I'll add a function to my .vimrc:

    function! LooksLikePerl6 ()
      if getline(1) =~# '^#!.*/bin/.*perl6'
        set filetype=perl6
      else
        for i in [1,2,3,4,5]
          if getline(i) == 'use v6;'
            set filetype=perl6
            break
          endif
        endfor
      endif
    endfunction

    au bufRead *.pm,*.t,*.pl call LooksLikePerl6()

This function uses `getline()` to check the first line of the file to see if it looks like a Perl 6 shebang. This should work well for `.pl` scripts, but Perl 6 module files will not have a shebang, so the next part of the script checks the first 5 lines of the file for the `use v6;` directive. The last line of code is an auto command which will call the function anytime we open file with a Perl file extension.

The main drawback of this technique is that not all Perl 6 code uses the `use v6;` directive, and so when working with module files, the code detection can fail. However the code detection could be improved to use more rules for detecting Perl 6 code such as class declarations. The [vim-perl](https://github.com/vim-perl/vim-perl) plugin has more sophisticated Perl 6 code detection [rules](https://github.com/vim-perl/vim-perl/blob/master/ftdetect/perl11.vim).

### Complete .vimrc

This `.vimrc` contains all the code shown above:

    syntax on

    "Recognize modeline # vim: filetype=perl6
    set ml

    "check for a local vimrc
    if filereadable(".vimrc.local")
      so .vimrc.local
    endif

    "check for Perl 6 code
    function! LooksLikePerl6 ()
      if getline(1) =~# '^#!.*/bin/.*perl6'
        set filetype=perl6
      else
        for i in [1,2,3,4,5]
          if getline(i) == 'use v6;'
            set filetype=perl6
            break
          endif
        endfor
      endif
    endfunction

    au bufRead *.pm,*.t,*.pl call LooksLikePerl6()

### Conclusion

So that's it, four useful-but-imperfect techniques for detecting file types in Vim. I tend to use a combination of all four. This would be a nice problem not to have. I'd like the Perl 6 community to agree and encourage unambiguous file extensions like `.pm6`, `.t6` and `.pl6`. Larry Wall called this "free advertising". It's also a simple way to make Perl 6 programmers more productive. Not every text editor is as customizable as Vim.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
