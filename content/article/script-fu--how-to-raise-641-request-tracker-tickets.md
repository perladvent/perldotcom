{
   "draft" : false,
   "image" : null,
   "slug" : "174/2015/5/12/Script-fu--how-to-raise-641-request-tracker-tickets",
   "title" : "Script-fu: how to raise 641 request tracker tickets",
   "date" : "2015-05-12T12:54:26",
   "description" : "NYC Perl hackathon fun",
   "categories" : "community",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "rakudo",
      "perl_6",
      "nyc",
      "hackathon",
      "rt"
   ]
}


I spent most of the NYC Perl Hackathon (thanks Bloomberg!) hacking on Perl 6 stuff. Led by Will "Coke" Coleda, one of the tasks for the group was to find skip/todo directives that were missing Request Tracker (RT) ticket numbers in the Perl 6 test suite.

A typical skip/todo directive looks like this:

```perl
#?rakudo todo "doesn't work yet due to copying of arrays"
```

This tells Rakudo to skip the following block of tests. For each skip/todo directive, a new RT ticket had to be raised and the ticket number added to the skip directive line in the test file, like this:

```perl
#?rakudo todo "doesn't work yet due to copying of arrays RT #99999"
```

This makes it easier for the Rakudo team to identify the remaining bugs or missing features in Rakudo.

I cloned the Perl 6 test suite, roast and after working through the workflow for reporting a single ticket, I wondered how many other skip/todo directives were missing RT tickets. To find out, I used a little `grep` magic:

```perl
$ grep -rlP '#?rakudo.+?(?:skip|todo)(?:(?!RT).{2})+$' ./ | wc -l
```

This tells grep to recursively search for files in the current directory, and for each file, print the filename if the Perl-style regex matches the text in the file. The regex matches Rakudo skip/todo directives that didn't already have an RT reference. The output of grep is then passed to `wc` in order to count the number of files. Turns out there were 236 files affected, and this method didn't even count the number of occurrences *within* a file. Even if it took 5 minutes per file to raise the ticket on RT, update the file, commit the change and issue a pull request, that's still 20 hours of work. It gets more complicated when you have to apportion that work between several people. At this point my spidey sense was tingling ... can you say "automation"?

### Using a machine to raise RT tickets "like a machine"

I wrote a quick script to find all the skip/todo directives again, only this time I would capture the filename, line number and description:

```perl
use strict;
use warnings;

scan_directory('.');

sub scan_directory
{
  my ($dir) = @_;

  opendir(my $dh, "$dir") or die $!;

  while (readdir $dh)
  {
    my $newpath = "$dir/$_";

    next if $newpath !~ qr/^\.\/S/ || -l $newpath;

    if (-d $newpath && $newpath !~ /\.$/)
    {
      scan_directory($newpath);
    }
    elsif (-f $newpath)
    {
      open my $file, '<', $newpath or die "failed to open $newpath $!\n";
      my $line_num = 1;·
      while (<$file>)
      {
        chomp;
        if (/^#\?rakudo.+?(?:skip|todo)((?:(?!RT).)+)$/)
        {
          my $subject = sprintf "Roast rakudo skip/todo test:%s line:%s reason:%s",
            $newpath, $line_num, $1;

         $subject =~ s/"//g;

          my $response = `rt create -t ticket set subject="$subject" queue=perl6 priority=0`;
          if ($response =~ /([0-9]+)/)
          {
            printf "%s RT#:%s\n", $subject, $1;
          }
          else
          {
            die "Failed to capture ticket # for $subject response: $response";
          }
        }
        $line_num++;
      }
      close $file;
    }
  }
}
```

The script is fairly simple: it's a recursive directory scanner that scans files for Rakudo skip/todo blocks. The script uses the following line of code with backticks to execute the `rt` command line program, raise a ticket in the Perl 6 queue and captures the response:

```perl
my $response = `rt create -t ticket set subject="$subject" queue=perl6 priority=0`;
```

The script then extracts the RT ticket number from the `$response`, and prints out a line containing the filename, line number, description and the RT ticket number. I saved this output in a separate file

.

### A quick note on configuring RT CLI

Configuring and using the RT command line client is simple, but finding out how to do it can be a hard - most of the sources I looked at were out of date, and the [RT CPAN namespace](https://metacpan.org/search?q=RT&size=20) has so many burned-out carcasses that Mad Max would be comfortable there. To use the command line client, first install RT::Client::CLI:

```perl
$ cpan RT::Client::CLI
```

Then login to the RT Perl [website](http://rt.perl.org/) and go to user [preferences](https://rt.perl.org/User/Prefs.html) and set a CLI password. Finally, create the file `.rtrc` in your home directory. This file should contain:

    server https://rt.perl.org/
    user rt_username
    passwd rt_cli_password

Replace `rt_username` with whatever name shows as the top of the RT screen under "logged in as". For me it's my email address. Also replace `rt_cli_password` with the CLI password you just set. Alternatively instead of a config file, you can use the following environment variables: RTSERVER, RTUSER and RTPASSWD.

That's it, RT is now configured! Try out some [commands](http://requesttracker.wikia.com/wiki/CLI). [Chapter 4](https://www.safaribooksonline.com/library/view/rt-essentials/0596006683/ch04.html) from the RT Essentials book was also useful.

### Updating roast

Now that I had the RT ticket numbers I needed to go back and add them to the skip/todo directives in the unit test files in roast. I scripted that too:

```perl
use strict;
use warnings;

open my $tickets, '<', './tickets';

while (my $line = <$tickets>)
{
  chomp $line;
  if (my ($filename, $line_num, $reason, $ticket_num) = $line =~ /:(.+?) .+?:(.+?) .+?:(.+?) .+?:(.+?)$/)
  {
    open my $file, '<', $filename or die "failed to open $filename $!\n";
    my $counter = 1;
    my @lines;
    while (my $line = <$file>)
    {
      if ($counter == $line_num)
      {
        chomp $line;
        $line =~ s/('|")\s*$/ RT #$ticket_num$1\n/;
      }
      push @lines, $line;
      $counter++;
    }
    close $file;

    open my $output_file, '>', $filename or die "failed to open $filename $!\n";
    for (@lines)
    {
      print $output_file $_;
    }
    close $output_file;
  }
  else
  {
    die "failed to match $line!\n";
  }
}
```

This took a couple of attempts to get right. At first I thought I would try using `open` with an awesome read/write filehandle using `+<` but that turned out to be more trouble than it was worth. The other challenge was inserting the RT ticket number within the quoted string on the line, rather than outside of it. So this:

```perl
#?rakudo todo "doesn't work yet due to copying of arrays"
```

Would become this:

```perl
#?rakudo todo "doesn't work yet due to copying of arrays RT #124652"
```

The challenge here is that different descriptions use different delimiters to capture the description, either single or double quotes. In the script, this line handles that problem:

```perl
$line =~ s/('|")\s*$/ RT #$ticket_num$1\n/;
```

It's a substitution regex that captures the last quoting delimiter on the line, and replaces that with the RT ticket number plus the captured delimiter (`$1`). It worked!

### Wrap up

In the end I raised 641 tickets across 236 test files in roast, for about 2 hours of work. And most of that was spent trying to configure the RT command line client. One thing to keep in mind with raising hundreds of tickets is email notification. Luckily for me Robert Spier intercepted the mailsend (thanks Robert!), but it would be great if there was a way to avoid creating hundreds of notifications when raising tickets. If there's a way, I'd love to know how.

Thanks to Will "Coke" Coleda, Tobias Leich (FROGGS) and Christian Bartolomäus (usev6) for reviewing the pull request and doing the work of merging it. If you're interested in supporting Perl 6, the Rakudo team have a [page](http://rakudo.org/how-to-help/) explaining way to contribute. I'd also recommend looking at the Perl 6 community [page](http://perl6.org/community/).

If you're based in New York or in the North-East of America, I'll be at the [Miniconf](http://mini-conf.com) hackathon on June 6th, leading a team to convert Perl 5 modules to Perl 6. Hope to see everyone there!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
