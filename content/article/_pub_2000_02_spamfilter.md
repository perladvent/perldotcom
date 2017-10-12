{
   "image" : null,
   "description" : "My Life with Spam -> or How I Caught the Spam and What I Did With It When I Caught it -> I wrote Part 1 of this series back in October 1999 for the LinuxPlanet web site, but the...",
   "authors" : [
      "mark-jason-dominus"
   ],
   "draft" : null,
   "thumbnail" : null,
   "title" : "My Life With Spam",
   "tags" : [
      "spam"
   ],
   "date" : "2000-02-09T00:00:00-08:00",
   "slug" : "/pub/2000/02/spamfilter",
   "categories" : "Email"
}





or\

I wrote Part 1 of this series back in October 1999 for the LinuxPlanet
web site, but the editors decided not to publish the rest of the series.
Since then, many people have asked for the continuation. This article is
Part 2.

Part 1 of the series discussed my early experiences with the spam
problem, first on Usenet and then in my e-mail box. I talked about how
to set up a mail filter program and how to have it parse incoming
messages. I discussed splitting up the header into logical lines and why
this is necessary. For the details and the Perl code, you can read [the
original article](http://www.plover.com/~mjd/perl/lp/Spam.html).

I also talked about my filtering philosophy, which is to blacklist the
domains that send me a lot of spam, and reject mail from those domains.

[Domain Pattern Matching]{#Domain_Pattern_Matching}
===================================================

One way to handle domains might have been to take the `To:` address in
the message and strip off the host name. However, this is impossible
because a host name *is* a domain. `perl.com` is both a host name and a
domain; `www.perl.com` is both a host name and a domain, and so is
`chocolaty-goodness.www.perl.com`. In practice, though, it's easy to use
a simple heuristic:

1.  Split the host name into components.
2.  If the last component is `com`, `edu`, `gov`, `net`, or `org`, then
    the domain name is the last two components.
3.  Otherwise, the domain name is the last three components

The theory is that if the final component is not a generic top-level
domain like `com`, it is probably a two-letter country code. Most
countries imitate the generic space at the second level of their domain.
For example, the United Kingdom has `ac.uk`, `co.uk`, and `org.uk`
corresponding to `edu`, `com`, and `org`, so when I get mail from
`someone@thelonious.new.ox.ac.uk`, I want to recognize the domain as
`ox.ac.uk` (Oxford University), not `ac.uk`.

Of course, this is a heuristic, which is a fancy way of saying that it
doesn't work. Many top-level domains aren't divided up at the third
level the way I assumed. For example, the `to` domain has no
organization at all, the same as the `com` domain. If I get mail from
`hot.spama.to`, my program will blacklist that domain only, not
realizing that it's part of the larger `spama.to` domain owned by the
same people. So far, however, this has never come up.

And I didn't include `mil` in my list of exceptions. However, I've never
gotten spam from a `mil`.

Eventually the domain registration folks will introduce a batch of new
generic top-level domains, such as `.firm` and `.web`. But they've been
getting ready for it since 1996; they're still working up to it; and I
might grow old and die waiting for it to happen. (See
<http://www.gtld-mou.org/> for more information.)

For all its problems, this method has worked just fine for a long time
because hardly any of the problems ever actually come up. There's a
moral here: The world is full of terrifically over-engineered software.
Sometimes you can waste a lot of time trying to find the perfect
solution to a problem that only needs to be partially solved. Or as my
friends at MIT used to say, \`\`Good enough for government work!''

Here's the code for extracting the domain:

     1    my ($user, $site) = $s =~ /(.*)@(.*)/;
     2    next unless $site;
     3    my @components =  split(/\./, $site);
     4    my $n_comp = ($components[-1] =~ /^edu|com|net|org|gov$/) ? 2 : 3;
     5    my $domain = lc(join '.', @components[-$n_comp .. -1]);
     6    $domain =~ s/^\.//;  # Remove leading . if there is one.

The sender's address is in `$s`. I extract the site name from the
address with a simple pattern match, which is also a wonderful example
of the "good enough" principle. Messages appear in the
`comp.lang.perl.misc` newsgroup every week asking for a pattern that
matches an e-mail address. The senders get a lot of very long
complicated answers, or are told that it can't be done. And yet there it
is. Sure, it doesn't work. Of course, if you get mail addressed to
\`\`@''@plover.com, it's going to barf. Of course, if you get
source-routed mail with an address like
<@send.here.first:joe@send.here.afterwards,> it isn't going to work.

But guess what? Those things never happen. A production mail server has
to deal with these sorts of fussy details, but if my program fails to
reject some message as spam because it made an overly simple assumption
about the format of the mail addresses, there's no harm done.

On line 2, we skip immediately to the next address if there's no site
name, since it now appears that this wasn't an address at all. Line 3
breaks the site name up into components; `thelonious.new.ox.ac.uk` is
broken into `thelonious`, `new`, `ox`, `ac`, and `uk`.

Line 4 is the nasty heuristic: It peeks at the last component, in this
case `uk`, and if it's one of the magic five (`edu`, `com`, `net`,
`org`, or `gov`), it sets `$n_comp` to 2; otherwise to 3. `$n_comp` is
going to be the number of components that are part of the domain, so the
domain of `saul.cis.upenn.edu` is `upenn.edu`, and the domain of
`thelonious.new.ox.ac.uk` is `ox.ac.uk`.

To get the last component, we subscript the component array
`@components` with `-1`. `-1` as an array subscript means to get the
last element of the array. Similarly, -2 means to get the next-to-last
element. In this case, the last component is `uk`, which doesn't match
the pattern, so `$n_comp` is 3.

On line 5, `-$n_comp .. -1` is really `-3 .. -1`, which is the list
`-3, -2, -1`. We use a Perl feature called a "list slice" to extract
just the elements -3, -2, and -1 from the `@components` array. The
syntax

            @components[(some list)]

invokes this feature. The list is taken to be a list of subscripts, and
the elements of `@components` with those subscripts are extracted, in
order. This is why you can write

            ($year, $month, $day) = (localtime)[5,4,3];

to extract the year, month, and day from `localtime`, in that
order--it's almost the same feature. Here we're extracting elements -3
(the third-to-last), -2 (the second-to-last), and -1 (the last) and
joining them together again. If `$n_comp` had been 2, we would have
gotten elements -2 and -1 only.

Finally, line 6 takes care of a common case in which the heuristic
doesn't work. If we get mail from `alcatel.at`, and try to select the
last three components, we'll get one undefined component--because there
were really only two there--and the result of the join will be
`.alcatel.at`, with a bogus null component on the front. Line 6 looks to
see if there's an extra period on the front of the domain, and if so, it
chops it off.

------------------------------------------------------------------------

[Now That You Have it, What Do You Do With it?]{#Now_That_You_Have_it_What_Do_Yo}
=================================================================================

I've extracted the domain name. The obvious thing to do is to have a big
hash with every bad domain in it, and to look this domain up in the hash
to see if it's there. Looking things up in a hash is very fast.

However, that's not what I decided to do. Instead, I have a huge file
with a *regex* in it for every bad domain, and I take the domain in
question and match it against all the patterns in the file. That's a lot
slower. A *lot* slower. Instead of looking up the domain
instantaneously, it takes 0.24 seconds to match the patterns.

Some people might see that and complain that it was taking a thousand
times as long as it should. And maybe that's true. But the patterns are
more flexible, and what's a quarter of a second more or less? The mail
filter handled 2,211 messages in the month of January. At 0.24 seconds
each, the pattern matching is costing me less than 9 minutes per month.

So much for the downside. What's the upside? I get to use patterns.
That's a big upside.

I have a pattern in my pattern file that rejects any mail from anyone
who claims that their domain is all digits, such as 12345.com. That
would have been impossible with a hash. I have a pattern that rejects
mail from anyone with "casino" in their domain. That took care of spam
from Planetrockcasino.com and Romancasino.com before I had ever heard of
those places. Remember that I only do the pattern matching on the
domain, so if someone sent me mail from `casino.ox.ac.uk`, it would get
through.

The regexes actually do have a potential problem: The patterns are in
the file, one pattern per line. Suppose I'm adding patterns to the file
and I leave a blank line by mistake. Then some mail arrives. The filter
extracts the domain name of the sender and starts working through the
pattern file. 0.24 seconds later, it gets to the blank line.

What happens when you match a string against the empty pattern? It
matches, that's what. Every string matches the empty pattern. Since the
patterns are assumed to describe mail that I *don't* want to receive,
the letter is rejected. So is the next letter. So is every letter.
Whoops.

It's tempting to say that I should just check for blank patterns and
skip them if they're there, but that won't protect me against a line
that has only a period and nothing else--that will also match any
string.

Instead, here's what I've done:

            $MATCHLESS = "qjdhqhd1!&@^#^*&!@#";

            if ($MATCHLESS =~ /$badsite_pat/i) {
              &defer("The bad site pattern matched `$MATCHLESS', 
                      so I assume it would match anything.  Deferring...\n");
            }

Since the patterns are designed to identify bad domain names, none of
them should match `qjdhqhd1!&@^#^*&!@#`. If a pattern *does* match that
string, it probably also matches a whole lot of other stuff that it
shouldn't. In that case, the program assumes that the pattern file is
corrupt, and defers the delivery. This means that it tells `qmail` that
it isn't prepared to deliver the mail at the present time, and that
`qmail` should try again later on. `qmail` will keep trying until it
gets through or until five days have elapsed, at which point it gives up
and bounces the message back to the sender. Chances are that I'll notice
that I'm not getting any mail sometime before five days have elapsed,
look in the filter log file, and fix the pattern file. As `qmail`
retries delivery, the deferred messages will eventually arrive.

Deferring a message is easy when your mailer is `qmail`. Here's the
`defer` subroutine in its entirety:

            sub defer {
              my $msg = shift;
              carp $msg;
              exit 111;
            }

When `qmail` sees the 111 exit status from the filter program, it
interprets it as a request to defer delivery. (Similarly, 100 tells
`qmail` that there was a permanent failure and it should bounce the
message back to the sender immediately. The normal status of 0 means
that delivery was successful.)

I would still be in trouble if I installed `com` as a pattern in the
pattern file, because it matches more domains than it should, but the
`MATCHLESS` test doesn't catch it. But unlike the blank line problem,
it's never come up, so I've decided to deal with it when it arises.

------------------------------------------------------------------------

['Received:' Lines]{#C_Received_Lines}
======================================

In addition to filtering the `From:`, `Reply-To:`, and envelope sender
addresses, I also look through the list of forwarding hosts for bad
domains. The `From:` and `Reply-To:` headers are easy to forge: The
sender can put whatever they want in those fields and spammers usually
do. But the `Received:` fields are a little different. When computer A
sends a message to computer B, the *receiving* computer B adds a
`Received:` header to the message, recording who it is, when it received
the message, and from whom. If the message travels through several
computers, there will be several received lines, with the earliest one
at the bottom of the header and the later ones added above it. Here's a
typical set of `Received:` lines:

    1   Received: (qmail 7131 invoked by uid 119); 22 Feb 1999 22:01:59 -0000

    2   Received: (qmail 7124 invoked by uid 119); 22 Feb 1999 22:01:58 -0000

    3   Received: (qmail 7119 invoked from network); 22 Feb 1999 22:01:53 -0000

    4   Received: from renoir.op.net (root@209.152.193.4)

    5   by plover.com with SMTP; 22 Feb 1999 22:01:53 -0000

    6   Received: from pisarro.op.net (root@pisarro.op.net [209.152.193.22]) 
        by renoir.op.net (o1/$Revision:1.18 $) with ESMTP id RAA24909 
        for <mjd@mail.op.net>; Mon, 22 Feb 1999 17:01:48 -0500 (EST)

    7   Received: from linc.cis.upenn.edu (LINC.CIS.UPENN.EDU [158.130.12.3])
        by pisarro.op.net 
       (o2/$Revision: 1.1 $) with ESMTP id RAA12310 for 
       <mjd@op.net>; Mon, 22 Feb 1999 17:01:45 -0500(EST)

    8   Received: from saul.cis.upenn.edu (SAUL.CIS.UPENN.EDU [158.130.12.4])

    9   by linc.cis.upenn.edu (8.8.5/8.8.5) with ESMTP id QAA15020

    10  for <mjd@op.net>; Mon, 22 Feb 1999 16:56:20 -0500 (EST)

    11  Received: from mail.cucs.org (root@cucs-a252.cucs.org [207.25.43.252])

    12  by saul.cis.upenn.edu (8.8.5/8.8.5) with ESMTP id QAA09203
    13  for <mjd@saul.cis.upenn.edu>; Mon, 22 Feb 1999 16:56:19 -0500 (EST)

    14  Received: from localhost.cucs.org ([192.168.1.223])

    15  by mail.cucs.org (8.8.5/8.8.5) with SMTP id QAA06332

    16  for <mjd@saul.cis.upenn.edu>; Mon, 22 Feb 1999 16:54:11 -0500

This is from a message that someone sent to `mjd@saul.cis.upenn.edu`, an
old address of mine. Apparently the sender's mail client, in
`localhost.cucs.org`, initially passed the message to the organization's
mail server, `mail.cucs.org`. The mail server then added the lines 14-16
to the message header.

The mail server then delivered the message to `saul.cis.upenn.edu` over
the Internet. `saul` added lines 11-13. Notice that the time on line 13
is 128 seconds after the time on line 13. This might mean that the
message sat on `mail.cucs.org` for 128 seconds before it was delivered
to `saul`, or it might mean that the two computers' clocks are not
properly synchronized.

When the mail arrived on `saul`, the mailer there discovered that I have
a `.forward` file there directing delivery to `mjd@op.net`. `saul`
needed to forward the message to `mjd@op.net`. However, most machines in
the University of Pennsylvania CIS department do not deliver Internet
mail themselves. Instead, they forward all mail to a departmental mail
hub, `linc`, which takes care of delivering all the mail outside the
organization. Lines 8-10 were added by `linc` when the mail was
delivered to it by `saul`.

`linc` looked up `op.net` in the domain name service and discovered that
the machine `pisarro.op.net` was receiving mail for the `op.net` domain.
Line 7 was added by `pisarro` when it received the mail from `linc`.

I don't know why `pisarro` then delivered the message to `renoir`, but
we know that it did, because line 6 says so.

`qmail` on `plover.com` added lines 4-5 when the mail was delivered from
`renoir`. Then the final three lines, 1-3, were added by `qmail` for
various local deliveries to `mjd`, then `mjd-filter` (which runs my spam
filter), and finally, `mjd-filter-deliver`, which is the address that
actually leads to my mailbox.

What can we learn from all this? The `Received:` lines have a record of
every computer that the message passed through on its way to being
delivered. And unlike the `From:` and `Reply-To:` lines, it really does
record where the message has been.

Suppose the original sender, at `localhost.cucs.org` had wanted to
disguise the message's origin. Let's call him Bob. Bob cannot prevent
`cucs.org` from being mentioned in the message header. Why? Because
there it is in line 11. Line 11 was put there by `saul.cis.upenn.edu`,
not by Bob, who has no control over computers in the `upenn.edu` domain.

Bob can try to confuse the issue by *adding* spurious `Received:` lines,
but he can't prevent the other computers from adding the correct ones.

Now, when spammers send spam, they often forge the `From:` and the
`Reply-To:` lines so that people don't know who they are and can't come
and kill them. But they can't forge the `Received:` lines because it's
another computer that puts those in. So when we're searching for domains
to check against the list of bad domain patterns, we should look through
the `Received:` lines too.

The difficulty with that is that there's no standard for what a
`Received:` line should look like or what should be in it, and every
different mailer does its own thing. You can see this in the example
above. We need a way to go over the `Received:` lines and look for
things that might be domains. This is just the sort of thing that Perl
regexes were designed for.

`   1  sub forwarders { 2    return @forwarders if @forwarders; 3    4     @forwarders =  5  grep { /[A-Za-z]/ } ($H{'Received'} =~ m/(?:[\w-]+\.)+[\w-]+/g); 6  7   @forwarders = grep      { !/(\bplover\.com|\bcis\.upenn\.edu|\bpobox\.com|\bop\.net)$/i }     @forwarders; 8  9   foreach $r (@forwarders) { 10    $r{lc $r} = 1; 11     } 12  13   @forwarders = keys %r; 14  15   return @forwarders; 16     }`

The message header has already been parsed and placed into the `%H`
hash. `$H{Received}` contains the concatenation of all the `Received`
lines in the whole message. The purpose of the `forwarders()` function
is to examine `$H{Received}`, extract all the domain names it can find,
and place them in the array `@forwarders`.

Lines 4-5 are the heart of this process. Let's look a little more
closely.

            $H{'Received'} =~ m/(?:[\w-]+\.)+[\w-]+/g

This does a pattern match in the `Received:` lines. `[\w-]` looks for a
single letter, digit, underscore, or hyphen, while `[\w-]+` looks for a
sequence of such characters, such as `saul` or `apple-gunkies`. This is
a domain component. `[\w-]+\.` looks for a domain component followed by
a period, like `saul.` or `apple-gunkies.`.

Ignore the `?:` for the time being. Without it, the pattern is
`([\w-]+\.)+[\w-]+`, which means a domain component followed by a
period, then another domain component followed by another period, and so
on, and ending with a domain component and no period. So this is a
pattern that will match something that looks like a domain.

The `/g` modifier on the match instructs Perl to find *all* matching
substrings and to return a list of them. Perl will look through the
`Received:` headers, pulling out all the things that look like domains,
making them into a list, and returning the list of domains.

Another example of this feature:

    $s = "Timmy is 7 years old and he lives at 350 Beacon St. 
    Boston, MA 02134" @numbers = ($s =~ m/\d+/g);

Now `@numbers` contains (7, 350, 02134).

I still haven't explained that `?:`. I have to confess to a lie. Perl
only returns the list of matching substrings if the pattern contains no
parentheses. If the pattern contains parentheses, the parentheses cause
part of the string to be captured into the special `$1` variable, and
the match returns a list of the `$1`s instead of a list of the entire
matching substrings. If I'd done

    "saul.cis.upenn.edu plover.com" =~ m/([\w-]+\.)+[\w-]+/g

instead, I would have gotten the list
`("saul.cis.upenn.",    "plover.")`, which are the `$1`'s, because the
`com` parts match the final `[\w-]+`, which is not in parentheses. The
`?:` in the real pattern is nothing more than a switch to tell Perl not
to use `$1`; . Since `$1` isn't being used, we get the default behavior,
and the match returns a list of everything that matched.

     
      4   @forwarders = 
      5   grep { /[A-Za-z]/ } ($H{'Received'} =~ m/(?:[\w-]+\.)+[\w-]+/g);

The pattern match generates a list of things that might be domains. The
list initially looks like:

      renoir.op.net 209.152.193.4
      plover.com
      pisarro.op.net pisarro.op.net 209.152.193.22 renoir.op.net 1.18 mail.op.net
      linc.cis.upenn.edu LINC.CIS.UPENN.EDU 158.130.12.3 pisarro.op.net 1.1 op.net
      saul.cis.upenn.edu SAUL.CIS.UPENN.EDU 158.130.12.4
      linc.cis.upenn.edu 8.8.5 8.8.5
      op.net
      mail.cucs.org cucs-a252.cucs.org 207.25.43.252
      saul.cis.upenn.edu 8.8.5 8.8.5
      saul.cis.upenn.edu
      localhost.cucs.org 192.168.1.223
      mail.cucs.org 8.8.5 8.8.5
      saul.cis.upenn.edu

As you can see, it contains a lot of junk. Most notably, it contains
several occurrences of `8.8.5`, because the `upenn.edu` mailer was
Sendmail version 8.8.5. There are also some IP addresses that we won't
be able to filter, and some other things that look like version numbers.
The `grep` filters this list of items and passes through only those that
contain at least one letter, discarding the entirely numeric ones.

`@forwarders` is now

           
      renoir.op.net
      plover.com
      pisarro.op.net pisarro.op.net renoir.op.net mail.op.net
      linc.cis.upenn.edu LINC.CIS.UPENN.EDU pisarro.op.net op.net
      saul.cis.upenn.edu SAUL.CIS.UPENN.EDU
      linc.cis.upenn.edu
      op.net
      mail.cucs.org cucs-a252.cucs.org
      saul.cis.upenn.edu
      saul.cis.upenn.edu
      localhost.cucs.org
      mail.cucs.org
      saul.cis.upenn.edu

The rest of the function is just a little bit of cleanup. Line 7
discards several domain names that aren't worth looking at because they
appear so often:

``

    7  @forwarders = grep { !/(\bplover\.com|\bcis\.upenn\.edu|\bpobox\.com|\bop\.net)$/i }
       @forwarders;

Plover.com is my domain, and it's going to appear in all my mail, so
there's no point in checking it. I worked at the University of
Pennsylvania for four and a half years, and I get a lot of mail
forwarded from there, so there's no point in checking `cis.upenn.edu`
domains either. Similarly, I subscribe to the Pobox.com lifetime e-mail
forwarding service, and I get a lot of mail forwarded through there.
`op.net` is my ISP domain name, which handles mail for me when Plover is
down. Line 7 discards all these domains from the `@forwarders` list,
leaving only the following:

     
           mail.cucs.org cucs-a252.cucs.org
           localhost.cucs.org
           mail.cucs.org

Lines 9-13 now discard duplicate items, using a common Perl idiom:

      
     9     foreach $r (@forwarders) {
     10       $r{lc $r} = 1;
     11     }
     12
     13     @forwarders = keys %r;

We use the remaining items as keys in a hash. Since a hash can't have
the same key twice, the duplicate `mail.cucs.org` has no effect on the
hash, which ends up with the keys, `mail.cucs.org`, `cucs-a252.cucs.org`
and `localhost.cucs.org`. The values associated with these keys are each
"1," which doesn't matter. When we ask Perl for a list of keys on line
13, we get each key exactly once.

Finally, line 15 returns the list of forwarders to whomever needed it.

There's one little thing I didn't discuss:

      2       return @forwarders if @forwarders;

The first thing the function does is check to see if it's already
processed the `Received:` lines and the computer `@forwarders`. If so,
it returns the list without computing it over again. That way I can just
call `forwarders()` anywhere in my program that I need a list of
forwarders, without worrying that I might be doing the same work more
than once; the `forwarders()` function guarantees to return immediately
after the first time I call it.

------------------------------------------------------------------------

[More to Come]{#More_to_Come}
=============================

Because of the long delay, I'll repeat the quiz from the first article:
What's wrong with this header line?

    Received: from login_2961.sayme2.net (mail.sayme2.net[103.12.210.92])
    by sayme2.net (8.8.5/8.7.3) with SMTP id XAA02040
    for creditc@aoI.net;  Thu, 28 August 1997 15:51:23 -0700 (EDT)

The story's not over. In the next article, I'll talk about some other
rules I used to filter the spam; one of them would have thrown out
messages when it saw a line like the one above. Another one throws out
mail when there's no `To:` line in the message--a likely sign of bulk
mail.

I'll also tell a cautionary tale of how I might have lost a lot of money
because my system worked too well, and how I found out that sometimes,
you *want* to get unsolicited bulk mail.


