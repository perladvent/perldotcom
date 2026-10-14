+++
title = "Pass filenames to Perl child processes as arguments"
date = 2026-10-14T10:30:00
description = "Keep spaces and shell punctuation inside the filename, then check the child process result."
authors = ["keith-staggers"]
categories = "development"
tags = ["system", "command-line", "testing"]
draft = true
image = ""
thumbnail = ""
canonicalUrl = ""
+++

A recording called `night mix.wav` should reach the next program as one filename. A small Perl wrapper can turn it into two arguments before the audio tool even opens a file.

The mistake is easy to miss when the first test file is called `demo.wav`. Give the same wrapper a name with a space and the useful question changes: what did the child process actually receive?

Make the arguments visible
--------------------------

Save this as `show-args.pl`. It uses [JSON::PP](https://metacpan.org/pod/JSON::PP) to print an unambiguous representation of the arguments. It does not open, rename or process any recording.

```perl
use v5.12;
use warnings;
use JSON::PP qw(encode_json);

print encode_json(\@ARGV), "\n";
```

Now save this deliberately fragile wrapper as `split-name.pl`:

```perl
use v5.12;
use warnings;

my $name = 'night mix.wav';
system "$^X show-args.pl $name";
```

From the directory containing both files, run `perl split-name.pl`. On the macOS test host, the output is:

```text
["night","mix.wav"]
```

The filename was one Perl string, but that did not preserve the argument boundary. The wrapper assembled a command string and asked Perl to interpret it as a command.

With a single scalar argument, [system](https://perldoc.perl.org/functions/system) examines the command for shell metacharacters. It passes such commands to a shell; otherwise, it splits the command into words itself. A filename containing shell punctuation can therefore do more than split in an inconvenient place. Adding quotation marks around the filename inside that string creates another quoting problem rather than removing the parser.

Supply the boundary directly
----------------------------

Replace the last line with:

```perl
system { $^X } $^X, 'show-args.pl', $name;
```

The result becomes:

```text
["night mix.wav"]
```

The braces identify the executable. The list supplies its arguments separately. [$^X](https://perldoc.perl.org/variables/%24%5EX) is Perl's name for its current executable. On the test host it is `/usr/bin/perl`; it is not guaranteed to be an absolute path on every platform. A production wrapper should select a known, trusted executable.

This explicit `system PROGRAM LIST` form also matters for portability: Perl's documentation says ordinary list-form `system` can fall back to a shell on Windows if the initial spawn fails. This tutorial's executable checks ran on macOS, not Windows.

Try a name such as `mix;preview.wav`, `take $demo.wav` or `singer's take.wav`. For this argument-printing helper, each stays one argument with its punctuation intact. Those names need not exist on disk. The experiment checks how text travels to a process, not whether an audio application supports the filename.

Check the result, too
---------------------

Reaching the right program with the right arguments does not establish that its work succeeded. Here is a complete wrapper, `literal-name.pl`, that accepts one or more names and checks the child status:

```perl
use v5.12;
use warnings;

die "Usage: perl literal-name.pl NAME [NAME ...]\n"
    unless @ARGV;

my $status = system { $^X } $^X, 'show-args.pl', @ARGV;

if ($status == -1) {
    die "Could not start or wait for the child: $!\n";
}
elsif ($status & 127) {
    die sprintf "Child terminated with signal %d\n", $status & 127;
}
elsif ($status >> 8) {
    die sprintf "Child exited with status %d\n", $status >> 8;
}
```

Run it from the same directory as the helper:

```text
perl literal-name.pl 'night mix.wav' 'mix;preview.wav'
["night mix.wav","mix;preview.wav"]
```

The single quotes here belong to the calling shell. They preserve the two names when starting the wrapper. Inside Perl, the separate list values preserve them when starting the helper. Fixing the second boundary cannot recover a name already split at the first.

The status is a wait status, not just an exit code. Check `-1` before extracting a signal or shifting for the exit value. This wrapper reports failure by dying; it does not preserve the child's exact exit code for its own caller. `system` also waits rather than capturing the child's output, which is why the JSON appears in the terminal.

Keep the next parser in view
---------------------------

Avoiding shell interpretation does not disable the child's own option parser. A real converter might treat `-preview.wav` as an option. Consult that program's interface: use its documented end-of-options marker, often `--`, or an appropriate explicit path. Do not assume every program accepts the same convention.

Keep the executable and any mode flags under the wrapper's control, then pass filenames as individual values. An argument list preserves boundaries; it does not make an arbitrary command safe or validate what a chosen tool will do.

Before replacing the helper with a converter, test a short name, a spaced name, punctuation and a name beginning with a hyphen. Inspect both the received arguments and a deliberate child failure. The useful test recording is not always the one that sounds different. Sometimes it is the one named `night mix.wav`.
