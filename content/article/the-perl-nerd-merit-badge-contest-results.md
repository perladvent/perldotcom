{
   "draft" : false,
   "tags" : [],
   "thumbnail" : "/images/73/thumb_EC75761E-FF2E-11E3-BD48-5C05A68B9E16.png",
   "title" : "The Perl Nerd Merit Badge Contest results",
   "description" : "Three winners, three awesome Perl tricks. Read on to find out more...",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "73/2014/2/28/The-Perl-Nerd-Merit-Badge-Contest-results",
   "image" : "/images/73/EC75761E-FF2E-11E3-BD48-5C05A68B9E16.png",
   "categories" : "community",
   "date" : "2014-02-28T13:57:22"
}


*Four weeks ago we [announced](http://perltricks.com/article/64/2014/1/29/Announcing-the-Perl-Nerd-Merit-Badge-contest)the Perl Nerd Merit Badge Contest, inviting readers to send us their favourite Perl code tricks large and small. After much deliberation, the winners have been chosen. Read on to find out about our winning entries ...*

### Memoizing callers - Paul Boyd

Paul submitted a solution for [memoizing](http://en.wikipedia.org/wiki/Memoization) calling subroutines using Perl's [caller]({{</* perlfunc "caller" */>}}) function. Paul's demo script is below. The "aggressively\_memoize" subroutine will memoize the results of the calling function so that when it is called repeatedly with the same arguments, the memoizer returns the stored result rather than re-calculating it. Cool huh?

To see this in action, just copy and save the script below as "memoizer.pl". Open up the terminal and type:

```perl
$ chmod 755 memoizer.pl
$ ./memoizer.pl
```

Or if you're on Windows, in cmd.exe or PowerShell:

```perl
>perl memoizer.pl
```

```perl
#!/bin/env perl

use strict;
use warnings;
use v5.12;

sub aggressively_memoize {
    my $caller_num = shift // 1;

    my $caller = (caller($caller_num))[3];
    return unless $caller;

    my ($package, $sub_name) = $caller =~ /(.*)::(.*?)$/;
    return if $sub_name eq '__ANON__';

    my $orig = $package->can($sub_name);
    my %cache;

    my $new_sub = sub {
        aggressively_memoize(2);

        my $key = join("\0", @_);

        # FIXME: Should check wantarray, this doesn't work in list context.
        unless (exists $cache{$key}) {
            $cache{$key} = $orig->(@_);
        }
        # Uncomment this if you wonder whether or not the cache is getting hit:
        #else {
        #    warn 'hit';
        #}

        return $cache{$key};
    };
    {
        no strict 'refs';
        no warnings 'redefine';
        *{$caller} = $new_sub;
    }
    return;
}

sub add {
    # Comment this out to see the performance difference
    aggressively_memoize();

    my $result = 0;
    $result += $_ for @_;
    return $result;
}

sub fib {
    my $n = shift;
    return 0 if $n <= 0;
    return 1 if $n == 1;
    return fib(add($n, -1)) + fib(add($n, -2));
}

say fib(40);
```

### An END block in a looping one liner - Josh Goldberg

Josh submitted a looping Perl one liner with a twist - once it has finished looping, the one liner executes a final block of code using Perl's [END]({{< perldoc "perlmod" "BEGIN,-UNITCHECK,-CHECK,-INIT-and-END" >}}) block. For example this can be used to process a web server log, and then summarize the log statistics:

```perl
$ cat /var/log/httpd/access_log |perl -lne '/20\d\d:\d\d:\d\d/;$counts{$&}++;$t++}END { for (sort keys %counts) { print "$_: $counts{$_} (".sprintf("%.02f",$counts{$_}/$t*100)."%)" }'
```

Running the above code on an Apache or Nginx access log gives these results:

```perl
2013:08:27: 1 (3.85%)
2013:08:28: 4 (15.38%)
2013:08:29: 1 (3.85%)
2013:08:40: 1 (3.85%)
2013:08:45: 1 (3.85%)
2013:08:54: 1 (3.85%)
2013:08:56: 2 (7.69%)
2013:09:02: 9 (34.62%)
2013:09:08: 1 (3.85%)
2013:09:18: 1 (3.85%)
2013:09:31: 2 (7.69%)
2013:15:50: 1 (3.85%)
2013:15:53: 1 (3.85%)
```

### A multicore Mojolicous web app - Justin Hawkins and Mario Roy

Yes you read that right - Justin and Mario's submission was a parallel processing [Mojolicious]({{<mcpan "Mojolicious" >}}) web app. The proof-of-concept app calculates the MD5 hash of all files in a directory. It combines Mojolicious's non-blocking web loop with Mario's MCE module (a PerlTricks favourite) to distribute the processing across all available cores on the host machine.

To try out the app, you'll need to install the [Mojolicious::Lite]({{<mcpan "Mojolicious::Lite" >}}) module, which you can get from CPAN. Just open a terminal and enter:

```perl
$ cpan Mojolicious::Lite
```

Get the [application code](https://gist.github.com/tardisx/9088819) and save it as "mce\_mojolicious.pl". At the terminal type:

```perl
$ chmod 755 mce_mojolicious.pl
$ ./mce_mojolicious.pl daemon
```

Or if you're on Windows, in cmd.exe or PowerShell type:

```perl
>perl mce_mojolicious.pl daemon
```

The app will start and point your browser at http://localhost:3000 to see the app in action!

### Conclusion

Thank you very much to everyone who entered the contest and congratulations to our winners. An exclusive Perl Nerd Merit Badge is on its way to them. Thanks also to brian d foy, for running the crowdtilt campaign, and making all of this possible.

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F73%2F2014%2F2%2F28%2FThe-Perl-Nerd-Merit-Badge-Contest-results&text=The+Perl+Nerd+Merit+Badge+Contest+results&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F73%2F2014%2F2%2F28%2FThe-Perl-Nerd-Merit-Badge-Contest-results&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
