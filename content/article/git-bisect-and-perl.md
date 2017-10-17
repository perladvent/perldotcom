
  {
    "title"  : "Git bisect and Perl",
    "authors": ["david-farrell"],
    "date"   : "2017-08-08T20:27:16",
    "tags"   : ["git", "bisect"],
    "draft"  : false,
    "image"  : "/images/displaying-the-git-branch-in-the-terminal-prompt-with-perl/Git-Logo-1788C.png",
    "description" : "Bisecting Perl commits doesn't always work by itself",
    "categories": "development"
  }

At [work](https://ziprecruiter.com) we have many developers committing code to a large Git repo, and a huge test suite which runs to check the software builds and operates correctly. Inevitably, developers push commits which break a test or two, and in particularly hectic moments, it can be difficult to figure out "who broke the build".

Enter Git's bisect [command](https://git-scm.com/docs/git-bisect). I feed it the SHA of the earliest bad commit I know of (or "HEAD") and the SHA of the last working commit:

    $ git bisect start HEAD b507d1a
    Bisecting: 41 revisions left to test after this (roughly 5 steps)

Then I set it running, using the failing test script:

    $ git bisect run t/foo.t

Git will checkout a commit between `HEAD` to `b507d1a` and run `t/foo.t` to determine if it is good or not. It will then select a subset of those commits, checkout one of them and run the test again. Git will keep going, subdividing commits into groups and testing them, until it's found the earliest commit which the test fails on. It's kind of fun:

<img src="https://media.giphy.com/media/WjAkrAvSA0XV6/giphy.gif" class="center" alt="HUD targeting fighter jet"/>

Eventually it will output:

    6717e8dd92ccc6b8f1a058799e895a716bbbb3fd is the first bad commit
    commit 6717e8dd92ccc6b8f1a058799e895a716bbbb3fd
    Author: Spider <spider@example.com>
    Date:   Mon Jul 24 10:56:41 2017 -0700

        Add some feature

And I know who to contact about the broken build, so I can exit the bisect process:

    $ git bisect reset

### Bisect and exit values

Bisect run treats certain exit values specially: 125 means the code cannot be tested, and 128 or higher will abort the bisect process. If Perl throws an exception it exits with 255 (instead of 0 for a pass and 1 for a test fail), aborting the bisect altogether:

    bisect run failed:
    exit code 141 from 't/foo.t' is < 0 or >= 128

To fix this, wrap the call to `t/foo.t` in a shell script which caps the return value of the test script at 127:

``` prettyprint
#!/bin/sh
$*
rv=$?
if [ $rv -gt 127 ]; then
  exit 127
else
  exit $rv
fi
```

The variable `$*` is a string of the commands passed to the shell script, so it literally executes whatever arguments are passed to it. Just like in Perl, `$?` is the exit value of the last run command, which here I assign to `rv`. Then the script exits either with 127 or the value of `rv`. I save the script as `cap-exit-value`, and use it like this:

    $ git bisect start HEAD b507d1a
    Bisecting: 41 revisions left to test after this (roughly 5 steps)
    $ git bisect run ./cap-exit-value t/foo.t

Now when Git is bisecting, if the test fails or Perl throws an exception, it will be treated as a failure and bisect can continue.

Hat tip to my colleague Frew, who first explained this issue and solution to me. If you like articles like these, you might enjoy his [blog](https://blog.afoolishmanifesto.com/).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
