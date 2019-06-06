
  {
    "title"       : "How do I Open This?",
    "authors"     : ["olaf-alders"],
    "date"        : "2019-06-03T18:26:42",
    "tags"        : ["vim", "emacs","pico","nano","git","github"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Find and open files with ease",
    "categories"  : "development"
  }

# How do I Open This?

When I'm working on code, I have to open a lot of files.  I work primarily at the command line, inside a `vim` editor.  On any given day I may need to translate some or all of the following into file paths that `vim` can understand:

* Stack traces
* Perl module names
* Perl module names suffixed with subroutine names
* `git-grep` results
* GitHub URLs

Figuring this stuff out isn't generally that hard, but it can make your day just a little longer than it needs to be, so I wrote [ot]({{< mcpan "ot" >}}): a command line utility provided by [Open::This]({{< mcpan "Open::This" >}}).

I'll be using `vim` in examples, but `ot` also supports `nvim`, `emacs`,`nano` and `pico`, defaulting to whatever you have set in `$ENV{EDITOR}`.

Following Along
---------------

I'll be working out of a repository at [https://github.com/oalders/git-helpers](https://github.com/oalders/git-helpers).  If you'd like to follow along:

```bash
$ git clone https://github.com/oalders/git-helpers.git
$ cd git-helpers
```

Using a Perl Module Name
------------------------

We're now in the root of the **git-helpers** `Git` repository.  Let's say we want to open the `Git::Helpers` module.  Translating a Perl module name into a file path isn't all that hard.  Given something like `Git::Helpers`, I know that I'm likely (but not always) looking for a file called `Git/Helpers.pm`.  This could be in `lib`, `t/lib` or some custom directory.  If I know exactly where to find this file, I can invoke `vim` directly: `vim lib/Git/Helpers.pm`.

```bash
$ vim lib/Git/Helpers.pm
```

This works because, by default, `ot` will search your `lib` and `t/lib` directories for local files. You can override this via the `$ENV{OPEN_THIS_LIBS}` variable. It accepts a comma-separated list of libs.

```bash
ot Git::Helpers
```

This works because, by default, ot will search your lib and t/lib directories for local files. You can override this via the `$ENV{OPEN_THIS_LIBS}` variable. It accepts a comma-separated list of libs.

If the file can't be found in one of the standard lib locations, ot will try to find an installed file on the system.  So, if we're not in the root of the git-helpers repository, but we've previously installed Git::Helpers from CPAN

```bash
$ ot Git::Helpers
```

Might open open the following file: `~/.plenv/versions/5.26.1/lib/perl5/site_perl/5.26.1/Git/Helpers.pm`.

Opening a Perl Module at a Subroutine Declaration
-------------------------------------------------

Let's take this a step further.  What if we want to open a file for a module but we also want to go straight to the correct subroutine declaration?  Something like `Git::Helpers::is_inside_work_tree()`.  We could probably craft a fancy one-liner to do this, but today we are lazy.

```bash
$ ot "Git::Helpers::is_inside_work_tree()"
```

That's it.  This will Do The Right Thing.  (Note that in this case we had to quote the args to `ot`.  Your shell will likely require this as well.)

We can do exactly the same thing for an installed module.  Try this command:

```bash
$ ot "Test::More::subtest()"
```

In my case it opens `/.plenv/versions/5.26.1/lib/perl5/site_perl/5.26.1/Test/More.pm` at line 807, which is `sub subtest {`.

Opening a File Using a Line Number
----------------------------------

#### Stack Traces
I see a lot of stack traces on any given day.  A relevant chunk of a stack trace might look like: `Died at lib/Git/Helpers.pm line 50.`

Doing this by hand I might copy the file path and enter the following at the command line:

```bash
$ vim lib/Git/Helpers.pm
```

If I'm feeling fancy, I might translate the line number into something that `vim` understands:

```bash
$ vim +50 lib/Git/Helpers.pm
```

Or, I can just copy the file location and line number and feed it to `ot`:

```bash
$ ot lib/Git/Helpers.pm line 50
```

This will do the right thing and open `lib/Git/Helpers.pm` in `vim` at line 50.

#### git-grep

The results of some searches, like `git grep`, can contain line numbers as well as file names.  To configure this behaviour in git use the following command:

```bash
$ git config --global grep.lineNumber true
```

If you don't want to configure this directly in git you can also search via `git grep --line-number foo`.

Now that we've got line numbers in our `git grep` output, we can use its output to give hints to `ot`:

```bash
$ git grep 'sub _build_latest_release' .
lib/Git/Helpers/CPAN.pm:70:sub _build_latest_release {
```

Having run the above search, we can copy paste the results to `ot`:

```bash
$ ot lib/Git/Helpers/CPAN.pm:70
```

This will now open `lib/Git/Helpers/CPAN.pm` at line 70.

Opening a File at an Arbitrary Line and Column
----------------------------------------------

As we saw above, `ot` can open files at the correct line number.  Let's get even lazier and have `ot` open our files at the correct line **and** column.

If you use  the `--vimgrep` option with `ripgrep` then you will see column numbers as well as line numbers with your search results.  For example:

```bash
$ rg --vimgrep '_build_latest_release' .
./lib/Git/Helpers/CPAN.pm:20:17:    builder => '_build_latest_release',
./lib/Git/Helpers/CPAN.pm:70:5:sub _build_latest_release {
```

To open `lib/Git/Helpers/CPAN.pm` at line 20 and column 17, simply copy/paste the `rg` output and pass it to `ot`:

```bash
$ ot ./lib/Git/Helpers/CPAN.pm:20:17
```

Opening Github Links Locally
----------------------------

Passing a full GitHub URL [https://github.com/oalders/git-helpers/blob/master/lib/Git/Helpers.pm#L50](https://github.com/oalders/git-helpers/blob/master/lib/Git/Helpers.pm#L50), to `ot` will allow you to open the file locally, if it can be found in your relative file path.

```bash
$ ot https://github.com/oalders/git-helpers/blob/master/lib/Git/Helpers.pm#L50
```

opens `lib/Git/Helpers.pm` at line 50.

Passing a truncated URL path is also valid, if the path parts exist locally:

```bash
$ ot lib/Git/Helpers.pm#L50
```

Opening a Locally Checked Out File at GitHub
--------------------------------------------

The `-b` flag will allow you to open your local files on GitHub.

Any of the following commands can launch a browser with a GitHub URL (hopefully) containing the file you want:

```bash
$ ot -b Git::Helpers
$ ot -b "Git::Helpers::is_inside_work_tree()"
$ ot -b Git::Helpers:75
$ ot -b Git::Helpers line 75
```

For example, from the top level of the git-helpers repository:

```bash
$ ot -b Git::Helpers:75
```
opens [https://github.com/oalders/git-helpers/blob/master/lib/Git/Helpers.pm#L75](https://github.com/oalders/git-helpers/blob/master/lib/Git/Helpers.pm#L75).


Opening a File in Your `$ENV{PATH}`
-----------------------------------

`ot` can also be used as a shortcut to inspect files which can be found inside your `$ENV{PATH}`.

For example:

```bash
$ ot perldoc
```

opens `~/.plenv/versions/5.26.1/bin/perldoc` on my machine.  You can think of this as shorthand for:

```bash
$ which perldoc | xargs -o vim
```

Contributing
------------

If you'd like to add support for more editors or other formats of data, please [get in touch with me](https://github.com/oalders/open-this/issues) and we'll see what we can do.

See Also
--------

For other solutions to the problem of finding and opening files, I highly recommend [fzf](https://github.com/junegunn/fzf) and [fpp](https://github.com/facebook/PathPicker).
