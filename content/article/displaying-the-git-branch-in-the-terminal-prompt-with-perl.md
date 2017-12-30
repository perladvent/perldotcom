{
   "authors" : [
      "david-farrell"
   ],
   "description" : "Where am I again? No more typing \"git branch\"",
   "image" : "/images/displaying-the-git-branch-in-the-terminal-prompt-with-perl/Git-Logo-1788C.png",
   "categories" : "development",
   "date" : "2016-05-13T07:57:42",
   "draft" : false,
   "tags" : [
      "git",
      "branch",
      "terminal",
      "perl",
      "prompt",
      "bash",
      "sed"
   ],
   "title" : "Displaying the Git branch in the terminal prompt with and without Perl",
   "thumbnail" : "/images/displaying-the-git-branch-in-the-terminal-prompt-with-perl/thumb_Git-Logo-1788C.png"
}

One way to evolve as a programmer is to pay attention to things you do repeatedly, and replace that action with an efficient alternative. It took me a shamefully long time to realize I was typing `git branch` many times a day to check which branch I was committing code to. A more efficient way is to display the current branch name in the terminal prompt. Ideally I'd like to see something like this:

    ~/some/path [master]

### The branch command

With Git version control, code changes are committed to branches. The active branch is the context for work. For example I might be working on a new feature, so I create a new branch called "new-feature-x" and start writing code. Any changes I make to the code whilst in this branch, do not affect the master branch of code. This makes knowing the active branch really important - I don't want to commit code to the wrong branch.

The `branch` command displays a list of all local branches and places an asterisk next to the active one. So in my fictional example, it might look like this:

    $ git branch
      master
    * new-feature-x

Git prepends an asterisk to highlight the active branch name. Sometimes I use this to remind myself which branches are available locally, but most of the time I'm checking it to see which branch I'm currently working on. The Git [branch documentation](https://git-scm.com/docs/git-branch) has more information on the ins and outs of `branch`.

### Parsing git branch with Perl

This is the one liner I want to use:

    $ git branch 2> /dev/null | perl -ne 'print " [$_]" if s/^\*\s+// && chomp'

It runs `git branch` redirecting error messages to the netherworld. That means if the current working directory is not a git repository, the ensuing error message will be ignored. We pipe the list of git branches to Perl, which uses the `-n` option to loop through each line of input, running the quoted code.

The code operates on the default variable `$_` which is the line of output from `git branch` being looped over. The active branch name always begins with an asterisk, So `s/^\*\s+//` tries to substitute the leading asterisk and whitespace from the branch name. Substitute returns the number of characters it replaced, so for all lines except the active branch, that will be zero and evaluate to false. If it's true, the code then chomps the trailing newline character from the branch name and prints it.

I can add this as a function to my `.bashrc` file:

```perl
function current_git_branch {
  git branch 2> /dev/null | perl -ne 'print " [$_]" if s/^\*\s+// && chomp'
}
PS1="\w\$(current_git_branch) "
```

The `PS1` variable defines the terminal prompt content and style. Here I've defined it as follows: `\w` is the current working directory path, e.g. `~/Projects/work/` or whatever. This is followed by the call to `current_git_branch`. Once those edits are saved in my `.bashrc`, I need to save the file and reload it:

    $ . ~/.bashrc

Now my terminal prompt looks like this:

    ~/Projects/work [new-feature-x]

And if I checkout a different branch it will change:

    ~/Projects/work [new-feature-x] git checkout master
    ~/Projects/work [master]

### Some other ways

One easy alternative would be to use Perl 6:

    $ git branch 2> /dev/null | perl6 -ne 'print " [$_]" if s/^\*\s+// && .chomp'

The code is almost the same as before, only `chomp` has been changed to a method call. A regex capture could be used instead too:

    $ git branch 2> /dev/null | perl -ne 'print " [$1]" if /^\*\s+(\S+)/'

I've also seen [examples](https://askubuntu.com/questions/730754/how-do-i-show-the-git-branch-with-colours-in-bash-prompt) using `sed` to parse the output instead of Perl.

### Bash only

Perhaps a more efficient approach is to have Git emit only the active branch name, and then we don't need another program to parse the output at all, we can just use bash. Credit goes to [Randal Schwartz](http://randalschwartz.com) for showing me this:

    $ git rev-parse --abbrev-ref HEAD
    new-feature-x

This emits the active branch only. So now the code in my `.bashrc` becomes:

```perl
function current_git_branch {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null);
  if [[ -n $branch ]];then
    echo " [$branch]";
  fi
}
PS1="\w\$(current_git_branch) "
```

This code assigns the output of the git command to the variable `branch`. It then echoes the branch name as long as it's not a zero length string (which happens when the current working directory is not a git repository). But wait a second, what happened to that newline at the end of the branch name? Bash has some interesting behavior with nested `echo` commands. Check this out:

    $ echo -n $(echo -e "\n\n\n\n")

If you run that command at the terminal you should get no output, even though it includes 4 newline characters, plus another newline appended by the `echo` subcommand. The outer `echo` ignores all newlines returned by the subcommand, and the `-n` option suppresses its own newline append (thanks to Ben Grimm for the explanation).

I'm going with the bash variant, but whichever method you use, displaying the branch name in the terminal is a nice time saver.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
