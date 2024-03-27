{
    "title"       : "Hotel hotspot hijinks",
    "authors"     : ["paul-cochrane"],
    "date"        : "2024-03-26T18:00:00",
    "tags"        : [],
    "draft"       : false,
    "image"       : "/images/hotel-hotspot-hijinks/hotel-hotspot-stock-login-page.png",
    "thumbnail"   : "/images/hotel-hotspot-hijinks/hotel-hotspot-stock-login-page.png",
    "description" : "Automating a hotel captive portal",
    "categories"  : "networking"
}

Ever been staying at a hotel and gotten annoyed that you always have to open
a browser to log in for wireless access?  Yup, me too.  A recent instance
was particularly frustrating and I had to pull out my favourite [Swiss Army
chainsaw](https://www.perl.com/pub/2000/10/begperl1.html/) in order to make
my life a bit easier.

## The situation

So, the background story is that I was staying at a hotel in the mountains
for a few days.  As is the fortunate case these days[^the-good-old-days],
the hotel had wireless access.  The weird part, though, was that each room
had a separate username and password.  "Fair enough", I thought and promptly
opened my laptop and then Firefox to enter my login data to get the
dearly-awaited connectivity.  Using Firefox (or any other browser for that
matter) was necessary because the login page was accessed via a [captive
portal](https://en.wikipedia.org/wiki/Captive_portal).  That's the thing you
get directed through when you see a login banner like this pop up in your
browser:

![Firefox captive portal login banner](/images/hotel-hotspot-hijinks/firefox-captive-portal-login-banner.png)

[^the-good-old-days]: Remember when finding a hotel with *any* wireless connectivity was a total mission?  Sort of like the days when finding a power outlet at an airport to charge a laptop was really difficult and one ended up sitting on the floor next to a utility room where the cleaning staff would normally plug in a vacuum cleaner.  Ah, those were the days &#x1f609;.  Put another way: humanity has come a looong way.

That's fine, I thought, and went merrily on with my day.

## The problem

The problem started the following day.  After getting up and waking up my
laptop, I wasn't able to read my email[^mutt-for-email], or read chat on
[irc](https://libera.chat/)[^irssi-for-irc], see my messages via
[Signal](https://signal.org/), or use the internet at
all[^live-on-the-terminal].

Also, `ping` greeted me with `Destination Net Prohibited`:

```
$ ping www.heise.de
PING www.heise.de (193.99.144.85) 56(84) bytes of data.
From logout.hotspot.lan (192.168.168.1) icmp_seq=1 Destination Net Prohibited
From logout.hotspot.lan (192.168.168.1) icmp_seq=2 Destination Net Prohibited
From logout.hotspot.lan (192.168.168.1) icmp_seq=3 Destination Net Prohibited
^C
--- www.heise.de ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2002ms
```

Obviously, I wasn't online.

[^mutt-for-email]: I use [mutt](http://www.mutt.org/); it's fast and one only needs to use text for email.  Right?  Right?

[^irssi-for-irc]: I also use [irssi](https://irssi.org/) for IRC.  Look, I've been around a while, ok?

[^live-on-the-terminal]: I'm one of those geeks who live on the terminal, hence I tend to use a lot of terminal-based tools to get things done.

That's when I noticed the Firefox captive portal login banner (see image
above) again.  Oh, I have to log in again, that's weird.  Upon clicking on
the "Open Network Login Page" button, I was logged in automatically.  No
need to enter the login details again.  That's also weird, I thought,
because if the login is automatic, why do I have to visit the login page
again at all?

I put my laptop to sleep to go for a walk around the village, get some
groceries, and enjoy the mountain air[^mountain-air].  Upon my return, I had
to log in *again* to get wireless access.  I was slowly starting to get a
[bit miffed](https://davywavy.livejournal.com/212580.html).  My guess is
that the MAC address from the relevant end-user device is removed from the
access list fairly quickly, perhaps on the order of an hour or
two[^mac-address-release], and thus network connectivity is cut rather
promptly.

[^mountain-air]: I don't mean this ironically: because of the forests and the distance away from any kind of metropolis, the air is much fresher.  Ever notice that the air in European cities is just awful?

[^mac-address-release]: Later, I'd tried putting my computer to sleep and then waking it up a few minutes later.  The connection was still alive, so my best guess is that the timeout to keep connections alive and keep a MAC address registered is on the order of hours, but not more than two or three hours, because even such short periods of inactivity required login again.  A later test showed that the timeout was after one hour.

One issue that made my situation even worse is that I often have *several*
browser windows open at the same time; usually because I have several trains
of thought on the go at once and each window contains information relevant
to each train of thought.  The thing is, only *one* of the browser windows
actually shows the (automatically appearing) captive portal login banner.
Finding the window with the banner was rather time consuming.

Ok, this was starting to get silly and a bit annoying.  Time to automate the
annoyance away.  [`WWW::Mechanize`](https://metacpan.org/pod/WWW::Mechanize)
to the rescue!

<figure>
<img src="/images/hotel-hotspot-hijinks/www-mechanize-as-superhero.png"
     alt="WWW::Mechanize as a comic book super hero; generated by DALL-E">
<figcaption style="text-align:center">
<code>WWW::Mechanize</code> as a comic book super hero; generated by DALL-E.
</figcaption>
</figure>

## The solution

Why choose `WWW::Mechanize`?  Well, I've got experience with it (I used to
use a similar process to automatically log in to the [ICE
train](https://en.wikipedia.org/wiki/Intercity_Express) in Germany when I
used to commute to work before [the
pandemic](https://en.wikipedia.org/wiki/COVID-19_pandemic)), I know I can
use it to [submit data into simple HTML
forms](https://metacpan.org/pod/WWW::Mechanize#$mech-%3Esubmit_form(-...-)),
and [Perl](https://www.perl.org/) is my go-to language for this kind of
automation.

So, how to get started with automating the login process?  The simple
solution: quit Firefox so that all browser windows are closed, put the
computer to sleep and then go for a walk for a couple of hours.

Upon my return, I just needed to use a combination of `perl -de0` to start a
[REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)-like
environment to play around in and `perldoc` to read the [extensive
`WWW::Mechanize` documentation](https://metacpan.org/pod/WWW::Mechanize).

The first attempt at trying to trigger a connection to the captive portal
didn't go well:

```
└> perl -de0

Loading DB routines from perl5db.pl version 1.55
Editor support available.

Enter h or 'h h' for help, or 'man perldebug' for more help.

main::(-e:1):   0
  DB<1> use WWW::Mechanize;

  DB<2> $mech = WWW::Mechanize->new;

  DB<3> $mech->get('https://google.com');

Error GETing https://google.com: Can't connect to google.com:443 (SSL
connect attempt failed) at (eval
22)[/home/cochrane/perl5/perlbrew/perls/perl-5.30.1/lib/5.30.1/perl5db.pl:738]
line 2.
```

Ok, so we need to use HTTP and avoid HTTPS.  Good to know.

Just using HTTP worked much better:

```
  DB<4> x $mech->get('http://google.com')
0  HTTP::Response=HASH(0x55a95f5048c0)
<snip>
lots of details; you really don't want to see this
</snip>
```

That's what we like to see!  We're at least getting stuff back now.  Having
a look at the page's title, we get:

```
  DB<5> x $mech->title();
0  'myadvise hotspot > login'
```

Yup, that's a login page.  Dumping the page's content with

```
  DB<5> x $mech->content();
<snip>
lots of HTML content
</snip>
```

we get to see what we've got to play with.  The main things to note about
the content (which I'm not showing because it's too much detail and I want
to protect the innocent) are:

  - we have a form called `login`

```html
<form name="login" action="http://login.hotspot.lan/login" method="post">
```

  - we have a username field with the name `username`

```html
<input style="width: 80px" name="username" type="text" value=""/>
```

  - and we have a password field with the name `password`

```html
<input style="width: 80px" name="password" type="password"/>
```

This gives us enough information to be able to submit the form using the
relevant login data.

Aside: interestingly enough, the fields are in English even though the site
is a German one.  I guess standardising the fields on English can be useful
when programming.

To submit the form, we use `WWW::Mechanize`'s
[`submit_form()`](https://metacpan.org/pod/WWW::Mechanize#$mech-%3Esubmit_form(-...-))
method (the call to which I've formatted nicely here to make things easier
to read):

```perl
$mech->submit_form(
    form_name => 'login',
    fields => {
        username => 'username-for-room',
        password => 'password-for-room',
    }
);
```

We can check if the form submission was successful by asking the
[`HTTP::Response`](https://metacpan.org/pod/HTTP::Response) if things went
well:

```
  DB<7> x $mech->res->is_success;
0  1
```

Looking good so far.  Let's see if `ping` works as expected

```
$ ping www.heise.de
PING www.heise.de (193.99.144.85) 56(84) bytes of data.
64 bytes from www.heise.de (193.99.144.85): icmp_seq=1 ttl=247 time=20.6 ms
64 bytes from www.heise.de (193.99.144.85): icmp_seq=2 ttl=247 time=13.9 ms
^C
--- www.heise.de ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 13.941/17.281/20.621/3.340 ms
```

Yes!  In other words: we're in!  [That was
easy](https://www.youtube.com/watch?v=kCE0v-SK5_c). &#x263A;

Putting everything together (and cleaning up the code a bit), I ended up
with this:

```perl
use strict;
use warnings;

use WWW::Mechanize;

my $mech = WWW::Mechanize->new;
$mech->get('http://google.com');

# check that we have the login page and not Google or something else
# i.e. we're not logged in
if ($mech->title() =~ 'login') {
    $mech->submit_form(
        form_name => 'login',
        fields => {
            username => '<username-for-room>',
            password => '<password-for-room>'
        }
    );
    if ($mech->res->is_success) {
        print "Login successful\n";
    }
    else {
        print "Login failed\n";
    }
}
else {
    print "Already logged in\n";
}
```

Now I can just run the script every time I wake my laptop back up and I'm
back online.  Yay!

From a security perspective it's a bit weird that the username and password
are obviously tied to the room number.  In other words, I could probably
use the neighbouring room's account just as easily (I guess: I couldn't
be bothered checking in the end).

## The conclusion

Well, this script certainly saved me some time and hassle when waking up my
laptop from the suspend state.  Also, it was fun working out what pieces of
the puzzle were necessary in order to build a solution.  Perl saves the
day[^perl-saves-the-day] again!

[^perl-saves-the-day]: Well, it saved the week really.

Originally posted on [https://peateasea.de](https://peateasea.de/hotel-hotspot-hijinks/).
