{
   "slug" : "/pub/2002/08/27/filtering.html",
   "description" : " There are many ways to filter your e-mail with Perl. Two of the more popular and interesting ways are to use PerlMx or Mail::Audit. I took a long look at both, and this is what I thought of them....",
   "draft" : null,
   "authors" : [
      "michael-stevens"
   ],
   "date" : "2002-08-27T00:00:00-08:00",
   "image" : null,
   "title" : "Mail Filtering",
   "categories" : "email",
   "thumbnail" : "/images/_pub_2002_08_27_filtering/111-mail_filtering.gif",
   "tags" : [
      "mail-filtering",
      "mail-and-usenet-news"
   ]
}



There are many ways to filter your e-mail with Perl. Two of the more popular and interesting ways are to use `PerlMx` or `Mail::Audit`. I took a long look at both, and this is what I thought of them.

### <span id="perlmx">`PerlMx`</span>

`PerlMx` is a server product from ActiveState that uses the milter support in recent versions of sendmail to hook in at almost every stage of the mail-handling process.

`PerlMx` comes with its own copy of Perl, and all the supporting modules it needs - it can't run from a normal Perl, as it needs Perl to be built with various options such as ithreads support and multiplicity. This means you need to install any modules you want to use with `PerlMx` twice if you already have them installed somewhere else on your system.

`PerlMx` provides a persistent daemon that processes e-mail for an entire mail-server - it avoids the overhead of starting a Perl process to handle each e-mail by running forever, and by using threads to ensure it can service more than one e-mail at a time.

`PerlMx` ships with two main filters - the Spam and Virus filters. The Virus filtering looks interesting, but ultimately I don't receive that many viruses in e-mail, so I was unable to test it beyond establishing that it didn't mangle my e-mail.

The Spam filtering in PerlMX is much more interesting - it seems to be based on [Mail::SpamAssassin](http://www.spamassassin.org/), a popular spam filtering module often used with Mail::Audit, procmail, or other ways of processing e-mail.

In two weeks of testing with `PerlMx`, using it to process a copy of all my personal e-mail, I found a lot useful functionality, and a few minor problems.

The first hassles were setup - I don't normally use sendmail, but `PerlMx` requires it for the milter API, so I installed sendmail, set it up, and hooked it into `PerlMx`.

Once you have sendmail setup, and built with milter support (as the default build from Debian Linux I used was), it's easy to add a connection to `PerlMx` with one line in your sendmail.mc file:

    INPUT_MAIL_FILTER(`C<PerlMx>', `S=inet:3366@localhost, F=T, 
         T=S:3m;R:3m;E:8m'')

`PerlMx` essentially works out of the box - it asks a number of simple questions when you install and set it up, and assuming you get these right, no further configuration will be required.

The `INPUT_MAIL_FILTER` line also sets several key options, including the timeouts for communication between sendmail and `PerlMx` - I had to raise these significantly to deal with a problem I found where `PerlMx` was taking too much time to process spam (it appear to be doing DNS lookups), sendmail was timing out the connection to `PerlMx`, and refusing to accept mail.

In `PerlMx` 2.1, it even ships with its own sendmail install, pre-configured for use with `PerlMx`, but you can choose to ignore this and use an existing system sendmail.

Once you've done this, suddenly all the mail that goes through your mail-server is spam filtered, and virus checked. Mail that looks likely to be spam, or that contains a virus is stopped and held in a quarantine queue, the rest are sent to the user, possibly with a spam header added to indicate a score representing how likely to be spam they are. The quarantine queue is a systemwide collection of messages which, for one reason or another, weren't appropriate to deliver to the user - this will be normally as they are either suspected to contain viruses or spam.

If the filters supplied with `PerlMx` aren't to your tastes, then it comes supplied with an extension API, and extensive documentation and samples to allow you to write your own.

While testing `PerlMx`, I never managed to bounce or accidentally lose my e-mail - I made many configuration errors, which meant mail wasn't processed and a lot of stuff was somewhat over-enthusiastically marked as spam when it was actually valid. But as far as I can tell, nothing bounced or disappeared into the system - this is pretty impressive, as when configuring most new bits of e-mail I usually manage to delete everything I send to it in the first few attempts, or, worse, make myself look stupid by sending errors back to random people unfortunate enough to be on the same mailing list as me.

### <span id="mail::audit">`Mail::Audit`</span>

`Mail::Audit` is very different from `PerlMx`. For starters, once you've installed it, by default it doesn't do anything. `Mail::Audit` is just a Perl module - it's a powerful tool for implementing mail filters, but mostly you have to write them yourself. `PerlMx` ships with spam filtering and virus checking configured by default, `Mail::Audit` provides duplicate killing, a mailing list processing module (based on Mail::ListDetector), and a few simple spam filtering options based on Realtime Blackhole Lists or Vipul's Razor.

`Mail::Audit` is not designed to be used with an entire mail-server in the same way as `PerlMx`. Instead, it allows you to easily write little e-mail filter programs that can be triggered from the *.forward* file of a particular user. `Mail::Audit` can be easily configured and used on a per-user basis, whereas `PerlMx` takes over an entire mail-server and is an all-or-nothing choice.

The default `Mail::Audit` configuration starts one Perl process for each mail handled - normally this won't be a problem, but if you're processing large volumes of mail, or have a system which is already at or near capacity, it may be enough to tip the balance and cause performance problems (Translation: Long ago I installed `Mail::Audit` on an old, spare machine I was using as a mail-server, received 200 e-mails in less than a minute, and spent quite a while waiting for the system to stop gazing at its navel and start responding to the outside world again). If your mail comes to you via POP3, or can be made to do so (possibly by installing a POP3 daemon if you do not have one already), then a simple script supplied with `Mail::Audit` called *popread* provides a base you can use to feed articles from a POP3 server into `Mail::Audit` in a single Perl process, improving performance. I didn't do this myself, as I wanted to use what appeared to be the 'recommended' approach to `Mail::Audit` setup - the one that is, if not actively promoted in the documentation, most strongly suggested by it, of running a `Mail::Audit` script from a user's .forward file.

A popular `Mail::Audit` addition is SpamAssassin (the same codebase as `PerlMx`'s mail processing is loosely based on) - this comes as a `Mail::Audit` plugin, among other forms.

`Mail::Audit` makes it easy to write mail filters that work on a per-user basis, whereas `PerlMx` by default applies to all mail processed on a given mailserver.

If you wanted to install `Mail::Audit` systemwide, then many mail-servers (such as exim) provide a way to configure a custom local delivery agent on flexible criteria. For example, [this article](http://bogmog.sourceforge.net/document_show.php3?doc_id=28) provides some documentation on how to do this with exim.

### <span id="testing... 1... 2... 3...">Testing ... 1 ... 2 ... 3 ...</span>

I decided to do an extended comparison of both `PerlMx` and `Mail::Audit`. As one of the most common applications of mail filtering tools is for spam filtering, I set up recent versions of both the tools on my personal e-mail, by various nefarious means, ran them for a week, and compared the results on two main criteria:

-   False positives (legitimate email recognized as spam)
-   False negatives (spam not recognized as spam)

`Mail::Audit` doesn't come with much spam filtering technology by default, so I decided to add SpamAssassin (http://www.spamassassin.org/) to the testing, as it can be used as a `Mail::Audit` extension.

I used procmail to copy all my incoming e-mail to two pop3 mailboxes setup for the purposes of testing - one would contain mail to be processed by `Mail::Audit`, the other mail to be processed by `PerlMx`'s spam filtering. fetchmail was used to pull the mail down into the domain of `Mail::Audit` and `PerlMx`.

Once I had `Mail::Audit` and SpamAssassin setup, I started feeding mail into the test box with fetchmail, and was reminded that as the `Mail::Audit` approach of setting up a perl program to run from a .forward file has ... unpleasant effects if you receive more than a few e-mails in quick succession. As my test mail-server collapsed under the load, I checked the `PerlMx` machine, started at roughly the same time, and found that while it was working through the e-mail more slowly, it hadn't put any serious load on the machine.

Due to a `PerlMx` configuration error on my part, of the first 171 messages processed, 10 were quarantined as spam AND delivered to the inbox of my test user. `PerlMx` runs by default in 'training mode' when processing spam - in this mode, mail is spamchecked as normal, but even if it is found to be spam and quarantined, it is also delivered to the user.

I decided to keep track of any mail lost or mislaid during initial setup problems, so I could see what problems could arise from the tools being misconfigured. An important aspect of any software is not only how it behaves when configured right, but how much it punishes you when you get the configuration wrong.

Waking up the next morning, I found I'd bounced several hundred e-mails back to the account from which I was forwarding all the test e-mails, someone of which appeared to have gone back and forth, or found their way into the `PerlMx` test mailbox. Most of the problems appeared to be internal errors from within SpamAssassin. My mail-server still hadn't recovered.

I later found this was because of an compatibility issue with SpamAssassin / `Mail::Audit`, and there was a recommended fix in the SpamAssassin FAQ involving the *nomime* option to `Mail::Audit` (but not, sadly, in the documentation for the Mail::SpamAssassin module itself).

The SpamAssassin / `Mail::Audit` script I ended up using in the end was:

      #!/usr/local/bin/perl -w

      use strict;
      use C<Mail::Audit>;
      use Mail::SpamAssassin;

      # create C<Mail::Audit> object, log to /tmp, disable mime processing
      # for SpamAssassin compatibility, and store mail in ~/emergency_mbox
      # if processing fails
      my $mail = C<Mail::Audit>->new(emergency=>"~/emergency_mbox",
                                  log => '/tmp/audit.log',
                                  loglevel => 4, nomime => 1);

      my $spamtest = Mail::SpamAssassin->new;
      
      # check mail with SpamAssassin
      my $status = $spamtest->check($mail);
      
      # if it was spam, rewrite to indicate what the problem was, and 
      # store in the file ass-spam in our home directory
      if ($status->is_spam) {
              $status->rewrite_mail;
              $mail->accept("/home/spam1/ass-spam");
      # if if wasn't spam, accept it as normal mail
      } else {
              $mail->accept;
      }
      
      exit 0;

After clearing down all my mail, and losing two days of testing, I started again. It was only the nature of the testing setup that meant the bounce mail went to me and not the original sender. So, at 23:25 on Tuesday, I had another go. This time I knew enough to limit SpamAssassin to receiving messages in batches of five (using fetchmail) - something I could do in testing, but wouldn't be an easy option in most production setups. This meant my test machine could just about cope with delivering mail using SpamAssassin.

At 10 p.m. Sunday, I declared the testing closed, and examined the accuracy or otherwise of each system.

During the testing between Aug. 6 and 11, `Mail::Audit` marked 16 pieces of e-mail as spam. Seven of these e-mails proved to be false positives - mail that I had actually solicited and would have liked to have received. Six spam emails were accepted into my Inbox. There were 874 e-mails received in all. `Mail::Audit` appeared to receive 15 pieces of spam mail in total.

`PerlMx` marked 14 e-mails as spam. Two of these e-mails proved to be false positives - mail that was not spam. Impressively, it received 886 e-mails in the same period that `Mail::Audit` received 874 e-mails. I was unable to work out the exact cause of this, although the power-cut in the middle of the testing period will always be a major suspect. Eleven spam messages were incorrectly allowws through into my Inbox. `PerlMx` appeared to receive 23 pieces of spam mail in total.

The sample was small, as all I had was my own personal e-mail to work with, and I get what I'm told is surprisingly little spam, but it shows that `Mail::Audit` / SpamAssassin seems to decide more mail is spam than `PerlMx` does, but is also wrong more of the time. `PerlMx` marked slightly less e-mail as spam, and let more spam through, but when it did claim e-mail was spam it was right more of the time.

These tests would benefit significantly from being re-run during a long period of time on a larger mail-server, but I had neither the time nor the mail-server available.

Both tools can be extensively configured in terms of what is considered spam, and are likely to need regular updating to ensure they keep up to date with new tricks of the spammers. Here I only considered the behavior with the default configuration of the latest release at the time I ran my tests.

### <span id="feature comparison">Feature Comparison</span>

To help you choose, I've summarized the basic characteristics of both systems below. Some of the points are quite subjective and are more my impressions of the tools rather than hard facts - these are marked separately.

|                                                           |                                                                                                          |                                                                         |
|-----------------------------------------------------------|----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|
|                                                           | PerlMX                                                                                                   | Mail::Audit                                                             |
| Scalable                                                  | Yes - persistent server                                                                                  | Maybe - depends on config - obvious default configurations scale poorly |
| Ships with wide range of existing filtering functionality | Yes                                                                                                      | Limited range, more available from third-parties                        |
| Target use                                                | System-wide mail filtering for mailservers                                                               | Per-use mail filtering as a replacement for programs like procmail      |
| Extensible?                                               | Yes                                                                                                      | Yes                                                                     |
| Licensing                                                 | Commercial                                                                                               | Open-source                                                             |
| Mail Server Compatibility                                 | Sendmail                                                                                                 | Almost any mail server                                                  |
| Spam filtering                                            | Yes                                                                                                      | Third-party extension                                                   |
| Virus filtering                                           | Yes                                                                                                      | No                                                                      |
| Easy to setup                                             | Yes                                                                                                      | Not so easy, requires custom code                                       |
| Efficient and Scalable                                    | Very scalable - easily separated from the mailserver, and no noticable performance impact during testing | Performance problems during testing in default configuration            |

### <span id="conclusions">Conclusions</span>

During testing, `PerlMx` was significantly more reliable, both in terms of the amount of mail bounced due to configuration problems (none), and in terms of the load put in the mailserver (minimal) than `Mail::Audit`. Although `Mail::Audit` appears able to be setup for good performance, the obvious suggested configuration showed extremely poor scalability during testing. Also, as `Mail::Audit` requires writing some filtering code, bugs, mostly in this code, resulted in nontrivial quantities of mail being bounced during testing due to code/configuration errors, a problem that simply didn't occur with `PerlMx`'s more pre-supplied, configuration file based system.

Both `PerlMx` and `Mail::Audit` provide good mail filtering solutions using Perl, but are targeted at entirely different markets. `PerlMx` is a systemwide solution providing drop-in functionality on mailservers, with Perl extensibility as well, whereas `Mail::Audit` is a more low-level tool, mostly focused on use by individuals, designed to let users build their own mail processing tools more easily.
