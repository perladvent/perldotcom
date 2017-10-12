{
   "title" : "Mail Filtering with Mail::Audit",
   "tags" : [
      "e-mail",
      "filter",
      "procmail",
      "rule",
      "spam"
   ],
   "slug" : "/pub/2001/07/17/mailfiltering",
   "date" : "2001-07-17T00:00:00-08:00",
   "categories" : "Security",
   "draft" : null,
   "thumbnail" : "/images/_pub_2001_07_17_mailfiltering/111-mailaudit.jpg",
   "image" : null,
   "description" : " Let's face it. procmail is horrid. But for most of us, it's the only sensible way to handle mail filtering. I used to tolerate procmail, with its grotesque syntax and its less-than-helpful error messages, because it was the only...",
   "authors" : [
      "simon-cozens"
   ]
}





Let's face it. *procmail* is horrid. But for most of us, it's the only
sensible way to handle mail filtering. I used to tolerate *procmail*,
with its grotesque syntax and its less-than-helpful error messages,
because it was the only way I knew to separate out my mail. One day,
however, I decided that I'd been told "delivery failed, couldn't get
lock" or similar garbage for the very last time, and decided to sit down
and write a *procmail* replacement.

That's when it dawned on me that what I really disliked about *procmail*
was the recipe format. I didn't want to handle my mail with a collection
of colons, zeroes, and single-letter commands that made `sendmail.cf`
look like a Shakespearean sonnet; I wanted to program my mail routing in
a nice, high-level language. Something like Perl, for instance.

The result is the astonishingly simple Mail::Audit module. In this
article, we'll examine what we can do with Mail::Audit and how we can
use it to create mail filters. We'll also look at the News::Gateway
module for turning mailing lists into newsgroups and back again.

### What Is It?

Mail::Audit itself isn't a mail filter - it's a toolkit that makes it
very easy for you to build mail filters. You write a program that
describes what should happen to your mail, and this replaces your
*procmail* command in your `.forward` or `.qmail` file.

Mail::Audit provides the functionality for extracting mail headers,
bouncing, accepting, rejecting, forwarding, and filtering incoming mail.

### A Very Simple Mail Filter

Here's the simplest filter program we can make with Mail::Audit.

        use Mail::Audit;
        my $incoming = Mail::Audit->new;
        $incoming->reject;

If you save this as `~/bin/chuckmail`, then you can put the following in
a `.forward` file:

        |~/bin/chuckmail

or in a `.qmail` file:

        preline ~/bin/chuckmail

Every mail message you receive will now pass through this program. The
mail comes into the program via standard input, and the `new()` method
takes it from there and turns it into a Mail::Audit object:

        my $incoming = Mail::Audit->new;

Next, we bounce it as undeliverable:

        $incoming->reject;

We could even get fancy, and supply a reason with the bounce:

    $incoming->reject(<<EOF);
        The local user was silly enough to leave chuckmail as his
        mail filter.  Too bad you can't mail him to let him know.
    EOF

This reason will be relayed back to the sender as part of the bounce
message.

### Separating Mail Into Folders

The one thing most people use *procmail* for is to separate mail out
into several mail folders. Here's an example of how we'd do this:

        use Mail::Audit;
        my $item = Mail::Audit->new;

        if ($item->from =~ /perl5-porters/) {
            $item->accept("/home/simon/mail/p5p")
        }

        $item->accept;

Now any mail with `perl5-porters` in the `From:` line will be added to
the file `mail/p5p` under my home directory. Any other mail will be
accepted into my inbox as normal.

Two things to note here:

-   Once the mail has been filed to `mail/p5p` via `accept()`, it leaves
    the program. Game over, end of story. The same goes for the other
    methods such as `reject()`, `pipe()`, and `bounce()`.
-   The last line in the program should probably be an `accept()` call;
    mail that reaches the end of the program without being deposited in
    a mailbox or rejected will be silently ignored. (This may change to
    an implicit `accept()` in a later version, to be more
    *procmail*-like.)

If you've got a few mailing lists or people you want to filter, you
could do this:

      use Mail::Audit;
      my $item    = Mail::Audit->new;
      my $maildir = "/home/simon/mail/";

      my %lists = (
          perl5-porters    => "p5p",
          helixcode        => "gnome",
          uclinux          => "uclinux",
          'infobot\.org'   => "infobot",
          '@dion\.ne\.jp'  => "yamachan"
      );

      for my $pattern (keys %lists) {
          $item->accept($maildir.$lists{$pattern})
              if $item->from =~ /$pattern/ 
                 or $item->to =~ /$pattern/;
      }

      $item->accept;

This time, we perform a regular expression match to see if either the
`From:` line or the `To:` line match any of the patterns in our hash
keys, and if they do, direct the mail to the corresponding folder. Since
we're using ordinary Perl regular expressions, we can do this sort of
thing:

      '\bxxx.*\.com$'  => "spam"

(And you'd be surprised at quite how much junk mail that one traps.)

Here's another simple but remarkably effective spamtrap recipe:

      $item->accept("questionable")
          if $item->from !~ /simon/i and $item->cc !~ /simon/i;

We check the `From:` and `CC:` headers for my name, and if it's not in
either - the mail probably isn't to me. This one only makes sense after
we've filtered out mailing list messages, which could validly be sent
from a subscriber to a generic list address.

### Mail and News

I much prefer reading mailing lists as newsgroups; while a good mail
client like *mutt* can display mail as threaded discussions, I
personally prefer navigating in a newsreader. So, how do we gate mailing
lists to newsgroups and back? Russ Allbery's News::Gateway module helps
do just that - it provides a program called *listgate* which takes an
incoming mailing list message, reformats it as a valid news article, and
then posts it to the news server. We can plug this into our mail filter
quite easily; assuming we've got the group `lists.p5p` set up on the
local news server and we've configured listgate appropriately, we can
just say:

      $item->pipe("listgate p5p") if $item->from =~ /perl5-porters/;

Again, if we've got multiple groups, we can use a hash to correlate
patterns to groups as we did with mailing lists above.

So much for getting incoming mail to news - what about getting posted
articles back into the mailing list? The key to this is in the newsgroup
moderation system - when you post to a moderated newsgroup, the article
is mailed to a moderator for approval. If we set the moderator of
`lists.p5p` to the list address, we can get our outgoing posts sent to
the list. In `/usr/news/etc/moderators`, you'd say

        lists.p5p:  perl5-porters@perl.org

Very easy. The only problem is that it doesn't work. Mail messages and
news articles have a slightly different format, and some mailing list
managers will reject mail messages that look like news articles. So we
need to send our message through a clean-up phase first. Instead of
sending it to `perl5-porters@perl.org`, we'll instead send it to
`news-outgoing@localhost`:

        lists.*:    news-outgoing@localhost

Mail arriving at that account needs to go through another Perl program
to clean up and dispatch the outgoing article, and that looks like this:

        #!/usr/bin/perl
        use News::Gateway;
        my $gw=News::Gateway->new(0);
        $gw->modules( 'newstomail', 'headers');
        $gw->config_line("newstomail /home/simon/bin/news2mail.h");
        $gw->config_line("header newsgroups drop");
        $gw->config_line("header organisation drop");
        $gw->config_line("header nntp-posting-host drop");
        $gw->read(*STDIN) or die $!;
        $gw->apply();
        $gw->mail();

This reads an article from standard input, drops the `Newsgroups`,
`Organisation`, and `NNTP-Posting-Host` headers, reformats it as a mail
message using the configuration file `/home/simon/bin/news2mail.h` to
find the address, and then sends it. That config file is just a list of
newsgroups and the addresses they belong to:

        lists.p5p perl5-porters@perl.org
        lists.tlug tlug@tlug.gr.jp
        lists.advocacy advocacy@perl.org
        lists.linux-kernel linux-kernel@vger.rutgers.edu
        lists.perl-friends perl-friends@perlsupport.com

So here's the recipe for filtering news to mail and back again:

• Incoming messages

> will be trapped by a rule in your mail filter, and be piped to
> `listgate` via a line like
>
>         $item->pipe("listgate p5p")
>             if $item->from =~ /perl5-porters/;
>
> `listgate` will then post them to your news server, to the group
> `lists.p5p`.

• Outgoing articles

> will be sent to the moderator address, `news-outgoing@localhost` for
> cleanup. The cleanup program will drop unnecessary headers, reformat
> as a mail message, and then look at the configuration file to
> determine where to send them on. They'll be sent to the mailing list,
> and sometime later will be returned to you by mail, to appear in the
> newsgroup as above.

### A Complete Filter

Here, to show off exactly what I do with Mail::Audit, is a suitably
anonymized and annotated version of the filter I currently use to
process my incoming mail.

        #!/usr/bin/perl
        use Mail::Audit;
        $folder = "/home/simon/mail/";

Anything that actually reaches me is going to be logged so that I can
`tail -f` a summary of incoming mail to one of my terminals.

        open (LOG, ">/home/simon/.audit_log");

Read in the new mail message, and extract the important headers from it:

        my $item = Mail::Audit->new;
        my $from = $item->from();
        study $from;
        my $to = $item->to();
        my $cc = $item->cc();
        my $subject = $item->subject();
        chomp($from, $to, $subject);

If I'm likely to be at the office, I appreciate a copy of all mail I
receive, in case there's something I need to deal with immediately. So I
need *time-controlled* filtering. Try doing this with *procmail*:

        my ($hour, $wday) = (localtime)[2,6];
        if ($wday !=0 and $wday !=6         # Not Saturday/Sunday
            and $hour > 9 and $hour < 18) { # Between 9am and 6pm
            print LOG "$subject: $from: Bouncing to work\n";
            $item->resend('simon@theoffice.com');
            # resend is the only action
            # which doesn't end the program.
        }

One of my users didn't have their own email address for a while, so they
had their friends send mail to me instead. Now they have their own
address, so the mail is bounced across to them:

        $item->bounce('ei@somewhere.com') if $subject =~ /^For Ei:/;

I maintain two FAQs: the perl5-porters FAQ and the Tokyo high speed
connectivity FAQ. The mail comes to different email addresses, but it
all ends up at my box. They need to go in separate folders.

        $item->accept("$folder/p5p-faq")   if $to=~ /p5p-faq/;
        $item->accept("$folder/tokyo-faq") if $to=~ /faq/;

I get some mail in Greek which needs to be processed with `metamail` to
sort out the character sets. The pipe method squirts the mail to a
separate program:

        $item->pipe("metamail -B -x > $folder/greek")
                    if $from =~/hri\.org$/;

Some people I definitely want to hear from, so they get accepted at this
stage to save time:

        for (qw(goodguy dormouse locust)) {
            if ($from =~ /$_/) {
                print LOG "$from:$subject:Exception, 
                    accepting into inbox\n";
                $item->accept;
            }
        }

Some people I very definitely do not want to hear from:

        for (qw(badguy nasty enemy)) {
            if ($from =~ /$_/) {
                print LOG "$from:$subject:Dumped\n";
                $item->reject("Go away! Stop emailing me!");
            }
        }

Some people or mailing lists I currently just don't have time for, so
they get silently ignored:

        for (qw(freshmeat.net microsoft news\@myhost cron)) {
            if ($from =~ /$_/) {
                print LOG "$from:$subject:Ignored\n";
                $item->ignore;
            }
        }

Some mailing lists I want to stay as lists:

        my %lists = (
            "pound.perl.org"  => "purl",
            "helixcode"       => "gnome",
            "uclinux"         => "uclinux",
            "infobot"         => "infobot",
            "european-"       => "yapc",
            "tpm\@otherside"  => "tpm",
            "hellenic"        => "greeknews",
        );
        for my $what (keys %lists) {
            next unless $from =~ /$what/i or 
                $to =~ /$what/i or $cc =~/$what/i;
            my $where = $lists{$what};
            print LOG "$from:$subject:List, 
                accepting to folder $where\n";
            $item->accept($folder.$where);
        }

And some I want to pipe to `listgate` as newsgroups:

        my %gated = (
            "tlug"    => "tlug",
            "advocacy"    => "advocacy",
            "security-sig"    => "security",
            "iss.net" => "security",
            "securityfocus"   => "security",
            "perl5-porters"   => "p5p",
            "linux-kernel"    => "linux-kernel",
            "perlsupport" => "perl-friends",
        );

        for my $what (keys %gated) {
            next unless $from =~ /$what/i or 
                $to =~ /$what/i or $cc =~/$what/i;
            my $where=$gated{$what};
            print LOG "$from:$subject:Gated to lists.$where\n";
            $item->pipe("/usr/local/bin/listgate $where");
        }

Some spammers just don't give up, so we actually reject their messages.
We do this based on subject, which is a bit risky but seems to work:

        for ("Invest", "nude asian"))  {
            $item->reject("No! Go away!")
                    if $subject=~/\b$_\b/;
        }

Before we let the article in to the inbox, there's a long list of
patterns at the end of the program which match known spam senders. We
check the incoming mail against this list, and save it for analysis and
reporting:

        while (<DATA>) {
            chomp;
            next unless $from =~ /$_/i or $to =~ /$_/i;
            print LOG "$from:$subject:Spam?\n";
            $item->accept($folder."spam");
        }

Now our final check for mail which doesn't appear to be for us:

        if ($item->from !~ /simon/i and $item->cc !~ /simon/i) {
            print LOG "$from:$subject:Badly addressed mail\n";
            $item->accept("questionable")
        }

Finally, we let the mail in:

        print LOG "INCOMING MAIL:$from:$subject:
                Accepting to inbox\n";
        $item->accept();

### Caveats

I'm perfectly happy to trust Mail::Audit with all my incoming email. For
a while it was running alongside *procmail*, but now it rules the roost.
However, there are some things which you do need to take care about if
you want to run it yourself.

Mail::Audit has been tested on `qmail` and `postfix` - it should work
fine on other MTAs (Message Transfer Agents), so long as they believe
that `exit 100`; means reject. If they don't, you can override the
`reject` method like this:

        $item = Mail::Audit->new(
                reject => sub { exit 67; }
        );

It also assumes that the default mailbox is `/var/spool/mail/name` where
`name` is user ID of the current user. If this isn't the case, (I
believe `mh` doesn't work like this) say `accept("Mailbox")` or override
`accept` with a subroutine of your own.

Finally, Mail::Audit isn't sophisticated. It's little other than a
wrapper around Mail::Internet. While it's probably perfectly fine for
most filters you want to write, don't expect it to do everything for
you.

### Conclusion

Mail::Audit and News::Gateway are both available from CPAN; together
they allow you to very easily construct mail filters and newsgroup
gateways in Perl. It's a great way to filter your mail with Perl, and an
excellent replacement for moldy old *procmail*.

*Copyright The Perl Journal. Reprinted with permission from CPM Media
LLC. All rights reserved.*


