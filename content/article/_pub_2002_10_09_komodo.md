{
   "description" : "Every time I get a new copy of ActiveState's Komodo IDE, I do a review that invariably ends &quot;this would be the perfect IDE for me if I were the sort of person who used IDEs&quot;. And every time I...",
   "thumbnail" : null,
   "date" : "2002-10-09T00:00:00-08:00",
   "slug" : "/pub/2002/10/09/komodo.html",
   "title" : "A Review of Komodo",
   "draft" : null,
   "image" : null,
   "authors" : [
      "simon-cozens"
   ],
   "categories" : "Tooling",
   "tags" : [
      "komodo-ide"
   ]
}





Every time I get a new copy of
[ActiveState](http://www.activestate.com/)'s [Komodo
IDE](http://www.activestate.com/Products/Komodo/), I do a review that
invariably ends "this would be the perfect IDE for me if I were the sort
of person who used IDEs". And every time I get the next release, I get
closer to being persuaded I should be using IDEs. With Komodo 2.0,
ActiveState is getting very, very close to persuading me - but it's not
there yet. Let's see what it got right and got wrong this time.

From a Perl point of view, the syntax highlighting and background syntax
checking has been greatly improved. Now, every time someone claims to do
decent Perl syntax highlighting, there'll be at least one annoying
pedant who crawls out of the woodwork with some pathological case and
the oft-quoted "only perl can parse Perl!". Well, so what? For something
that's impossible, Komodo does a surprisingly fine job. Combining the
background syntax checking with `use strict` catches a reassuring amount
of coding errors almost instantly.

My old favourite, Rx, is still there, and is still a great way to
visualize what's going on in complicated regular expressions. One
problem I found was that the Rx window changed size awkwardly while
stepping through the regex match - but maybe this is a good time to
mention that I'm working from a beta version of Komodo 2.0, and many of
my gripes may be fixed by the time 2.0 is released for real.

There are a bunch of little things too that one should come to expect
from this caliber of IDE. Integration with CVS was touted as being a
feature, but I couldn't find any mention of it, although the FTP "remote
editing" feature works well; combined with the CGI features of Komodo,
this could be a fantastic workstation for the Windows user deploying CGI
files on a remote server.

The Web services integration is a nice touch, especially with its
automated installer, but it would benefit from some kind of progress
indicator. Integration with the ASPN Cookbooks is a nice idea, but I
don't know how much use it would see in day-to-day coding. The "external
debugger" feature sounds interesting, but I couldn't find any
documentation on it.

If I had to point to something that really impressed me about Komodo
2.0, then it would be the toolbox; this is actually something that I've
been looking for in my own development environment and could be the one
feature that persuades me to use Komodo. The toolbox is, simply put,
somewhere to collect stuff that might be useful during your development.
That's to say, snippets of code that you can drop into place, commands
that you can execute, URLs to start a browser at, and so on. For
example, you can highlight a function in Perl, and have a button in the
toolbox run `perldoc -f` on it. You can drag a piece of boilerplate code
directly into your file. It's just a nice, fast way of working, making
the repeated things easy - precisely what a GUI should be doing. This is
combined with a macro recording facility to make it easy for you to
create your own toolbox items.

It's worth remembering that Komodo is not just about Perl. Komodo's XML
mode is absolutely wonderful; it offers per-tag folding, tag completion
on insertion, and XSLT debugging. Since I write all of my books in XML
these days, I'm seriously considering using Komodo instead of jEdit and
even emacs's psgml mode for my writing work; the only slight snag is
that Komodo's tag insertion works by divining the acceptable XML tags
from the structure of the documentation, instead of loading a DTD if one
is explicitly supplied. However, perhaps this is unfair - Komodo doesn't
claim to be an XML editor, just an XSLT editor, and the fact that it
makes quite a good XML editor is a surprising bonus.

So why won't I switch to using Komodo? Two reasons: First, it's not out
on my favorite OS, Apple's OS X - although I'm told that a port is in
progress. Unfortunately, when that happens, Komodo will be competing
with Apple's own Project Builder.

Second, speed. If I'm going to be giving up vi and emacs, then I'm going
to want something that can keep up with them in terms of speed and
keyboard response times. Komodo, even running a fairly beefy box, was
slowing down my coding. No amount of cool syntax highlighting is worth
that.

As with the last time I reviewed Komodo, I'd heartily recommend it for
those who enjoy programming with IDEs, but reluctantly say that it's not
for me. But it's very, very close.


