{
   "draft" : false,
   "date" : "2015-06-09T12:59:02",
   "description" : "The ubiquitous test runner is a powerful tool for your arsenal",
   "slug" : "177/2015/6/9/Get-to-grips-with-Prove--Perl-s-test-workhorse",
   "tags" : [
      "perl-6",
      "test",
      "prove",
      "cheet_sheet",
      "test-anything-protocol"
   ],
   "categories" : "testing",
   "title" : "Get to grips with Prove, Perl's test workhorse",
   "image" : null,
   "authors" : [
      "david-farrell"
   ]
}


Prove is a test running tool that ships with Perl. It has a ton of options, which can make it confusing for a beginner to use. If you have never used prove, or are not confident using it, do not despair! This article will get you up to speed with prove and it's most common options.

### Basics

If you have Perl installed, you should already have Prove installed as well. To demo the features of Prove, I'm going to clone the Mojolicious repo using Git. I like demoing Prove with Mojolicious as it has a large test suite. At the command line:

```perl
$ git clone https://github.com/kraih/mojo
$ cd mojo
```

So I've cloned the Mojolicious repo and changed into the project directory. Now I'm ready to run some tests with Prove!

```perl
$ prove -l t/mojo/asset.t
```

I executed Prove using the `prove` command. I included the `-l` option so that Prove would load the Mojolicious code beneath the `lib` directory. If I didn't do this, Perl would not find the Mojolicious code referenced in `t/mojo/asset.t` and raise an error, or perhaps worse, it might run the tests against an older version of Mojolicious I already had installed on my system.

Sometimes the code to include is not directly in the `lib` directory. For these cases Prove has the `-I` option for "include":

```perl
prove -I/path/to/lib /path/to/test_file
```

Prove can run a single test file, or if given a directory containing multiple test files, with will execute them all:

```perl
$ prove -l t/mojo
```

This runs all the test files in `t/mojo` directory.

### Recursively execute test files with "r"

The Mojolicious project has test files in several different directories beneath the `t` directory. It would be tiresome to locate all of these directory paths and give them to Prove. Instead, Prove provides the `-r` option to recursively search for test files.

```perl
$ prove -lr
```

This option executed every test file under the `t` directory, about 10,000 tests across 85 different files. Pretty convenient huh? Note that I didn't provide the `t` directory as an argument, because Prove searches the `t` directory by default. Now that's convenience!

### Run tests in parallel using "j"

The ability to run lots of test files is useful, but it can take a long time to run all of the tests. On my machine, executing the Mojolicious test suite takes 32 seconds. To speed things up, Prove can run test files in parallel, to share the work across multiple processes. To do this I just add the `-j` option plus the number of processes I want to use. I have a quad core machine, so I'm going to use 4 different processes:

```perl
$ prove -lr -j 4
```

This time, prove executed all the tests in 12 seconds. That's a 266% speed-up, not bad!

### Get more detail with "v" for verbose

To minimize line noise, by default Prove provides summary-level statistics and low-level detail for test failures. Sometimes it's useful to see the output for each test. I can see this detail by adding the `-v` option for "verbose":

```perl
$ prove -lrv
```

### Running Perl 6 tests

Prove can run tests for other languages, as long as the tests follow the Test Anything Protocol. Perl 6 unit tests follow TAP, so we can use Prove to run Perl 6 tests too! I can demo this on my Perl 6 module, [URI::Encode](https://github.com/dnmfarrell/URI-Encode). To follow along, just clone the repo with Git:

```perl
$ git clone https://github.com/dnmfarrell/URI-Encode
$ cd URI-Encode
```

To run non Perl tests with Prove, we need to pass the `--exec` option, with a program name. That tells Prove which program to execute the tests with. Like this:

```perl
$ prove --exec perl6
```

Note that I didn't have to pass the filepath of which tests to run. It's just lucky that by convention Perl6 modules have their tests in the `t` directory, usually with a `.t` extension. For other languages, you'll need to specify the test filepath:

```perl
$ prove --exec some_program /path/to/testfile
```

### Documentation

You can get a summary of the options Prove accepts by using the `-h` option for help:

```perl
$ prove -h
```

For more detailed documentation, use `perldoc`:

```perl
$ perldoc prove
```

Perldoc is another useful Perl tool, if you'd like to know more about it, have a look at our introductory [article](http://perltricks.com/article/155/2015/2/26/Hello-perldoc--productivity-booster). Prove also has a man page entry (if you're on Unix/BSD based systems).

### Prove Cheat sheet

    prove [options] [filepath]

    Options
    -------
    l       Include the "lib" dir
    I       Include a dir: -I/path/to/lib
    r       Recursively search and run test files
    j       Parallel, specify # procs: -j 4
    v       Verbose test output
    h       Help, summary of options
    exec    Exec tests in another program: --exec perl6

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
