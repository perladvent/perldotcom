{
   "thumbnail" : "/images/_pub_2005_12_08_test_files/111-file_test.gif",
   "description" : " For the last several years, there has been more and more emphasis on automated testing. No self-respecting CPAN author can post a distribution without tests. Yet some things are hard to test. This article explains how writing Test::Files gave...",
   "title" : "Testing Files and Test Modules",
   "slug" : "/pub/2005/12/08/test_files.html",
   "authors" : [
      "phil-crow"
   ],
   "date" : "2005-12-08T00:00:00-08:00",
   "image" : null,
   "categories" : "data",
   "tags" : [
      "file-testing",
      "perl-test-modules",
      "perl-testing",
      "test-builder",
      "test-builder-tester",
      "test-files"
   ],
   "draft" : null
}





For the last several years, there has been more and more emphasis on
automated testing. No self-respecting CPAN author can post a
distribution without tests. Yet some things are hard to test. This
article explains how writing `Test::Files` gave me a useful tool for
validating one module's output and taught me a few things about the
current state of Perl testing.

### Introduction

My boss put me to work writing a moderately large suite in Perl. Among
many other things, it needed to perform check out and commit operations
on CVS repositories. In a quest to build quality tests for that module,
I wrote [`Test::Files`](http://search.cpan.org/perldoc/Test::Files),
which is now on CPAN. This article explains how to use that module and,
perhaps more importantly, how it tests itself.

### Using `Test::Files`

To use `Test::Files`, first use
[`Test::More`](http://search.cpan.org/perldoc/Test::More) and tell it
how many tests you want to run.

    use strict;
    use warnings;
    use Test::More tests => 5;
    use Test::Files;

After you use the module, there are four things it can help you do:

-   Compare one file to a string or to another file.
-   Make sure that directories have the files you expect them to have.
-   Compare all the files in one directory to all the files in another
    directory.
-   Exclude some things from consideration.

### Single Files

In the simplest case, you have written a file. Now it is time to
validate it. That could look like this:

    file_ok($file_name, "This is the\ntext\n",
        "file one contents");

The `file_ok` function takes two (or optionally, and preferably, three)
arguments. The first is the name of the file you want to validate. The
second is a text string containing the text that should be in the file.
The third is the name of the test. In the rush of writing, I'm likely to
fail to mention the test names at some point, so let me say up front
that all of the tests shown here take a name argument. Including a name
makes finding the test easier.

If the file agrees with the string, the test passes with only an OK
message. Otherwise, the test will fail and diagnostic messages will show
where the two differed. The diagnostic output is really the reason to
use `Test::Files`.

Some, including myself, prefer to check one file against another. I put
one version in the distribution. The other one, my tests write. To
compare two files, use:

    compare_ok($file1, $file2, $name);

As with `file_ok`, if the files are the same, `Test::Files` only reports
an OK message. Failure shows where the files differ.

### Directory Structures

Sometimes, you need to validate that certain files are present in a
directory. Other times, you need to make that check exclusive so that
only known files are present. Finally, you might want to know that not
only is the directory structure is the same, but that the files contain
the same data.

To look for some files in a directory by name, write:

    dir_contains_ok($dir, [qw(list files here)], $name);

This will succeed, even if the directory has some other files you
weren't looking for.

To ensure that your list is exclusive, add only to the function name:

    dir_only_contains_ok($dir, [qw(list all files here)], $name);

Both of these report a list of absent files if they fail due to them.
The exclusive form also reports a list of unexpected files, if it sees
any.

### Directory Contents

If knowing that certain file names are present is not enough, use the
`compare_dirs_ok` function to check the contents of all files in one
directory against files in another directory. A typical module might
build one directory during `make test`, with the other built ahead of
time and shipped with the distribution.

    compare_dirs_ok($test_built, $shipped, $name);

This will generate a separate diagnostic `diff` output for each pair of
files that differs, in addition to listing files that are missing from
either distribution. (If you need to know which files are missing from
the built directory, either reverse the order of the directories or use
`dir_only_contains_ok` in addition to `compare_dirs_ok`. This is a bug
and might eventually be fixed.) Even though this could yield many
diagnostic reports, all of those separate failures only count as one
failed test.

There are many times when testing *all* files in the directories is just
wrong. In these cases, it is best to use
[`File::Find`](http://search.cpan.org/perldoc/File::Find) or an
equivalent, putting an exclusion criterion at the top of your wanted
function and a call to `compare_ok` at the bottom. This probably
requires you to use `no_plan` with `Test::More`:

    use Test::More qw(no_plan);

`Test::More` wants to know the exact number of tests you are about to
run. If you tell it the wrong number, the test harness will think
something is wrong with your test script, causing it to report failures.
To avoid this confusion, use `no_plan`--but keep in mind that plans are
there for a reason. If your test dies, the plan lets the harness know
how many tests it missed. If you have `no_plan`, the harness doesn't
always have enough information to keep score. Thus, you should put such
tests in separate scripts, so that the harness can count your other
tests properly.

### Filtering

While the above list of functions seemed sufficient during planning,
reality set in as soon as I tried it out on my CVS module. I wanted to
compare two CVS repositories: one ready for shipment with the
distribution, the other built during testing. As soon as I tried the
test it failed, not because the operative parts of the module were not
working, but because the CVS timestamps differed between the two
versions.

To deal with cosmetic differences that should not count as failures, I
added two functions to the above list: one for single files and the
other for directories. These new functions accept a code reference that
receives each line prior to comparison. It performs any needed
alterations, and then returns a line suitable for comparison. My example
function below redacts the offending timestamps. With the filtered
versions in place, the tests pass and fail when they should.

My final tests for the CVS repository directories look like this:

    compare_dirs_filter_ok(
        't/cvsroot/CVSROOT',
        't/sampleroot/CVSROOT',
        \&chop_dates,
        "make repo"
    );

The code reference argument comes between the directory names and the
test name. The `chop_dates` function is not particularly complex. It
removes two kinds of dates favored by CVS, as shown in its comments.

    sub chop_dates {
        my $line =  shift;

        #  2003.10.15.13.45.57 (year month day hour minute sec)
        $line    =~ s/\d{4}(.\d\d){5}//;

        #  Thu Oct 16 18:00:28 2003
        $line    =~ s/\w{3} \w{3} \d\d? \d\d:\d\d:\d\d \d{4}//;

        return $line;
    }

This shows the general behavior of filters. They receive a line of input
which they must not directly change. Instead, they must return a new,
corrected line.

In addition to `compare_dirs_filter_ok` for whole directory structures,
there is also `compare_filter_ok`, which works similarly for single file
comparisons. (There is no `file_filter_ok`, but maybe there should be.)

### Testing a Test Module

The most interesting part of writing `Test::Files` was learning how to
test it. Thanks to Schwern, I learned about
[`Test::Builder::Tester`](http://search.cpan.org/perldoc/Test::Builder::Tester),
which eases the problems inherent in testing a Perl test module.

The difficulty with testing Perl tests has to do with how they normally
run. The venerable test harness scheme expects test scripts to produce
pass and fail data on standard out and diagnostic help on standard
error. This is a great design. The simplicity is exactly what you would
expect from a Unix-inspired tool. Yet, it poses a problem for testing
test modules.

When eventual users use the test module, their harness expects it to
write quite specific things to standard out and standard error. Among
the things that must go to standard out are a sequence of lines such as
`ok 1`. When you write a test of the test module, its harness also
expects to see this sort of data on standard out and standard error.
Having two different sources of `ok 1` is highly confusing, not least to
the harness, which chokes on such duplications.

Test module writers need a scheme to trap the output from the module
being tested, check it for correct content, and report that result onto
the actual standard channels for the harness to see. This is tricky,
requiring care in diversion of file handles at the right moments without
the knowledge of the module whose output is diverted. Doing this by hand
is inelegant and prone to error. Further, multiple test scripts might
have to recreate home-rolled solutions (introducing the oldest of known
coding sins: duplication of code). Finally, the diagnostic output, in
the event of failure, from homemade diverters is unlikely to be helpful
when tests of the test module fail.

*Enter `Test::Builder::Tester`.*

To help us test testers, Mark Fowler collected some code from Schwern,
and used it to make `Test::Builder::Tester`. With it, tests of test
modules are relatively painless and their failure diagnostics are highly
informative. Here are two examples from the `Test::Files` test suite.
The first shows a file comparison that should pass:

    test_out("ok 1 - passing file");
    compare_ok("t/ok_pass.dat", "t/ok_pass.same.dat",
        "passing file");
    test_test("passing file");

This test should work, generating `ok 1 - passing file` on standard
output. To tell `Test::Builder::Tester` what the standard output should
be, I called `test_out`. After the test, I called `test_test` with only
the name of my test. (To avoid confusion, I made the test names the
same.)

Between the call to `test_out` and the one to `test_test`,
`Test::Builder::Tester` diverted the regular output channels so the
harness won't see them.

The second example shows a failed test and how to check both standard
out and standard error. The later contains the diagnostic data the
module should generate.

    test_out("not ok 1 - failing file");
    $line = line_num(+9);
    test_diag("    Failed test (t/03compare_ok.t at line $line)",
    '+---+--------------------+-------------------+',
    '|   |Got                 |Expected           |',
    '| Ln|                    |                   |',
    '+---+--------------------+-------------------+',
    '|  1|This file           |This file          |',
    '*  2|is for 03ok_pass.t  |is for many tests  *',
    '+---+--------------------+-------------------+'  );
    compare_ok("t/ok_pass.dat", "t/ok_pass.diff.dat",
        "failing file");
    test_test("failing file");

Two new functions appear here. First, `line_num` returns the current
line number plus or minus an offset. Because failing tests report the
line number of the failure, checking standard error for an exact match
requires matching that number. Yet, no one wants his tests to break
because he inserted a new line at the top of the script. With
`line_num`, you can obtain the line number of the test relative to where
you are. Here, there are nine lines between the call to `line_num` and
the actual test.

The other new function is `test_diag`. It allows you to check the
standard error output, where diagnostic messages appear. The easiest way
to use it is to provide each line of output as a separate parameter.

### Summary

Now you know how to use `Test::Files` and how to test modules that
implement tests. There is one final way I use `Test::Files`. I use it
outside of module testing any time I want to know how the contents of
text files in two directory hierarchies compare. With this, I can
quickly locate differences in archives, for example, enabling me to
debug builders of those archives. In one example, I used it compare more
than 400 text files in two WebSphere .ear archives. My program had only
about 30 operative lines (there were also comments and blank lines) and
performed the comparison in under five seconds. This is testament to the
leverage of Perl and CPAN.

(Since doing that comparison, I have moved to a new company. In the
process I exchanged WebSphere for `mod_perl` and am generally happier
with the latter.)


