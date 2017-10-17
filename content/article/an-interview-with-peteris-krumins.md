{
   "slug" : "54/2013/12/18/An-interview-with-Peteris-Krumins",
   "authors" : [
      "david-farrell"
   ],
   "title" : "An interview with Peteris Krumins",
   "categories" : "community",
   "tags" : [
      "powershell",
      "bash",
      "interview",
      "one_liner",
      "old_site"
   ],
   "draft" : false,
   "image" : "/images/54/EBF9E79C-FF2E-11E3-A3E3-5C05A68B9E16.jpeg",
   "date" : "2013-12-18T03:47:38",
   "description" : "We talk about his favourite Perl one liners, publishing books and Perl on Windows!"
}


*Peteris Krumins is a Perl author, start-up founder and all-around hacker. He also runs the popular blog CatOnMat.*

**You're a really busy guy; running catonmat, Browserling and publishing books. What's your secret?**
 I just work like crazy. It's pretty much all I do! I'm a list person; one of my recent posts on catonmat was about how I work: I use Google Calendar to track the most important tasks; interviews, payments, important events, that kind of thing. Then I also use to-do lists, actually several to-do lists for each one of my projects - [Browserling](http://www.browserling.com), [Testling](%0Ahttp://www.testling.com), books, blog posts, a reading list, stuff like that. [Here is an example](http://www.catonmat.net/images/codeproject-interview/todo-list.jpg).

**We're talking because you're famous for writing one liners in Perl. How did you get into that?**
 So there was this guy, Eric Pement and he collected hundreds of Awk one liners in this file "[awk1line.txt](http://www.pement.org/awk/awk1line.txt)" and he published it on UseNet, like 10 years ago. So I found his file and it was really interesting. I went through all of his one liners and learned Awk. Then I found that he had done the same thing for Sed ([sed1line.txt](http://www.pement.org/sed/sed1line.txt)) and I went through that and learned Sed. So that inspired me to create my own file for Perl, [perl1line.txt](http://www.catonmat.net/download/perl1line.txt) and it started from there.

**I read that that your post "Perl One Liners Explained" has something like 500,000 hits?**
 It's an article series made out of eight separate posts. It's actually more like 800,000 now for all posts combined.

**Wow! Was that an outlier for you, did it make you think there was a lot of interest in this topic?**
 Well I had already written perl1line.txt by then. I wrote eight blog posts following the structure used by Eric Pement in his files; for example he had a section called "How to do line spacing in Awk", so I wrote one post called "How to do line spacing with Perl one liners" and so on.

**Your Perl One Liners book was originally self-published, then picked up by No Starch Press. How did that happen?**
 It was amazing. I just got an email from Bill, who runs No Starch Press and he asked me if I wanted to turn my self-published book into a real book. And I said "yeah!" and we got it published. Here's the result - [Perl One Liners book](http://nostarch.com/perloneliners).

**The new No Starch Press version has 30+ more pages of content, did No Starch help you with that?**
 Yes, we took the original text and improved it mainly by adding more examples. We added examples for most of the one liners. And we also added a section about running Perl on Windows.

**I wanted to ask you about that. That seemed like a topic that hasn't been well-covered elsewhere?**
 It was really hard to write. I had to test all of the one liners on PowerShell and the command line (cmd.exe) to make sure they worked, find all of the workarounds, handle special symbols, it was very challenging.

**Was that a section that No Starch Press encouraged?**
 Not really. I run Windows as well, it's my primary workstation although I do have a bunch of Linux servers which I ssh into. Sometimes I need to run Perl one liners on Windows, so I thought a lot of my readers would be interested in how to run the one liners on Windows as well. We spent about a month on that section, it delayed the book for about a month and a half, because of it. It was very challenging and hard to write but it should help a lot of Windows users as it's probably the best guide to running Perl from the command line on Windows.

> I thought a lot of my readers would be interested in how to run the one liners on Windows

**Would you still use Unix tools over PowerShell on a Windows?**
 Well, I run Windows XP and don't have PowerShell. I use Cygwin, but sometimes when I don't want to use that, I just run bash.exe from [win-bash](http://win-bash.sourceforge.net/). My setup is that I have Linux server mounted through Samba as a virtual drive. So if I have to do serious editing, I throw the file onto the shared drive and shh into my Linux server, so I don't need to use the Linux tools on Windows that much.

**Your book is full of interesting command line shortcuts and hidden features. Do you have a favourite one liner or code trick in Perl?**
 I love one liners that are like puzzles - you can't understand them just by looking at them. You have to tinker around and try them out to see what it does. For example a regular expression like: "/[ -~]/" is fun, which matches every printable ASCII character from space to tilde.

Another one liner which I like because it has no code in it is: "perl -00pe0", for paragraph slurping.

**So how did you find out about that? I don't think it's even documented in perlrun.**
 I don't know how I came up with this one. I remember something about being on the \#perl freenode IRC channel. When I was writing the book I was often on there asking people for advice. Maybe someone told me about it or I found it myself, but it's fun.

**You've also written about Sed and Awk. If you know Perl one liners, do you need to learn Sed or Awk as well?**
 No, you don't. But sometimes when you write a Perl one liner the equivalent one liner in Awk / Sed would be shorter. For example to reference the fifth word on a line in Awk it's "$5" but in Perl it's "$F[4]", besides you'd have to turn on autosplitting and use a bunch of other command line arguments.

**What text editor / IDE do you use to code in Perl?**
 I use Vim. I have a bunch of customizations and shortcuts that I use. I have an article series on my site called "[Vim plugins you should know about](http://www.catonmat.net/series/vim-plugins-you-should-know-about)" that covers this. One of my favourite plugins is "[surround.vim](http://www.catonmat.net/blog/vim-plugins-surround-vim/)" - if you have a single-quoted string and want to change them to double-quotes, you type: cs'" and it will change them. You can change parentheses and many other things that surround something. Another plugin I like is "[matchit.vim](http://www.catonmat.net/blog/vim-plugins-matchit-vim/)", which extends the shift + F5 (%) parenthesis matching in Vim to match HTML tags and if/then/else statements and other constructs. Some of my other favorites are "[snipmate.vim](http://www.catonmat.net/blog/vim-plugins-snipmate-vim/%0A)" for code snippets, "[ragtag.vim](http://www.catonmat.net/blog/vim-plugins-ragtag-allml-vim/)" for working with HTML tags and "[nerd\_tree.vim](http://www.catonmat.net/blog/vim-plugins-nerdtree-vim/)" for browsing files in vim.

**What about color schemes, do you have a favourite?**
 I don't really care about color schemes - Vim does color the code but I don't change it. I also don't care about programming fonts. The font just have to be constant width and that's it.

**You've also written about EMACS before. Why do you stick with Vim over other tools?**
 I was working at this company once and I thought that from day one I would use EMACS (as a way of learning it) and see how it goes. After a few weeks I went back to Vim. I had to learn so many new key combinations it was hurting my productivity.

When I'm programming in C and C++, I use Visual Studio. The best thing about using Visual Studio is if I forget a command or method, I can quickly look it up using IntelliSense.

**Apart from one liners, do you develop Perl applications or modules?**
 Perl is my preferred programming language for writing quick tools, for example: uploading / downloading videos from YouTube, or parsing HTML pages. I'm incredibly fast at that and there are so many modules that can help - I wouldn't be able to be that productive in other languages.

**Have you used any Perl code analysis tools like Perl::Critic ?**
 I have used [Perl::Critic](https://metacpan.org/pod/Perl::Critic) but I don't like it when someone criticizes my code! (even if it's from Damian Conway's Perl best practices book!) I just write sane code and apply most of the best practices. Other people usually don't have problems with my code.

> I have used Perl::Critic but I don't like it when someone criticizes my code

**You're a real polyglot as apart from Perl, your Github page hosts projects in C++, JavaScript, Python, OCaml, PHP! Are there any features of those languages would you like to see in Perl?**
 It's hard to take a feature from another language and put it into Perl as it's already very expressive and supports many different programming paradigms. I often get asked this, but I don't have a good answer! I'm very productive with Perl as it is, whereas I could definitely name features of Perl that I would like to see in other languages.

**What about Perl versions, do you keep up to date?**
 Yeah, right now I'm using Perl 5.18 and that's all thanks to [Perlbrew](http://perlbrew.pl/). I remember a few years ago before I knew about Perlbrew it was huge pain to have several different Perl versions and I always had the system Perl and maybe one local version of Perl. Managing packages was a pain, too. Once I found out about Perlbrew, I installed every version of Perl, going back to 5.6. One cool feature is "perlbrew exec" which I used to test my one liners against every version of Perl to see which ones work and don't.

> I'm using Perl 5.18 and that's all thanks to Perlbrew.

**What are your favourite Perl modules and tools?**
 I really like [Try::Tiny](https://metacpan.org/pod/Try::Tiny) for better exception handling, [File::Slurp](https://metacpan.org/pod/File::Slurp) for quickly working with files, [WWW::Mechanize](https://metacpan.org/pod/WWW::Mechanize) and [](https://metacpan.org/pod/HTML::TreeBuilder)HTML::TreeBuilder for scraping the web.

Talking about tools I also like [rxrx](https://metacpan.org/pod/Regexp::Debugger) by Damian Conway ([here's a demo at YAPC](http://www.youtube.com/watch?v=zcSFIUiMgAs)). It's this interactive regexp debugger. Another tool that I use is [ack](http://beyondgrep.com/) that's a better version of grep!

**And one last final question - what is it that you're doing in your profile picture? Making a cigarette?**
 Haha, no! I'm actually holding a piece of scotch tape. I was making a raft that day from empty bottles so I was taping them together. It turned out to be a really good raft and it worked. [Here's a photo.](%0Ahttp://www.flickr.com/photos/pkrumins/11391256906/)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
