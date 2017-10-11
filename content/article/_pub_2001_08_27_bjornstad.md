{
   "slug" : "/pub/2001/08/27/bjornstad",
   "tags" : [
      "disabled-accessibility-tk-bjornstad"
   ],
   "date" : "2001-08-27T00:00:00-08:00",
   "draft" : null,
   "image" : null,
   "authors" : [
      "dan-brian"
   ],
   "description" : "As part of Mark-Jason Dominus's Lightning Talks at the 2001 O'Reilly Open Source Convention, Jon Bjornstad gave a talk about a Perl/Tk program he wrote to help a mute quadriplegic friend, Sue Simpson, speak and better use her computer. Jon's...",
   "thumbnail" : "/images/_pub_2001_08_27_bjornstad/111-perldisabled.jpg",
   "categories" : "Community",
   "title" : "Perl Helps The Disabled"
}





As part of Mark-Jason Dominus's Lightning Talks at the 2001 O'Reilly
Open Source Convention, Jon Bjornstad gave a talk about a Perl/Tk
program he wrote to help a mute quadriplegic friend, Sue Simpson, speak
and better use her computer. Jon's talk received a grand reception, not
only for his clever use of Perl, but for a remarkably unselfish
application of his skills.

### Q: Who are you, and what do you do?

A: I'm a Perl programmer, currently employed by a company called Sesame
Technology, a small consulting firm in Scotts Valley near Santa Cruz.
I'm 51 years old, so I've been around. My first language was Fortran IV.
I've programmed in C on UNIX, done lots of FoxPro for UNIX, various
database applications, as well as several large Perl apps.

### Q: What got you into Perl?

A: About five years ago, a community project I was involved with wanted
to create a Web store. The product I found to do the job was written in
Perl, so I decided I had better learn the language. I went out and
bought "Learning Perl," which was the first edition at that time. It was
right up my alley. I absorbed that book in two days, and knew that was
clearly where I wanted to be. It just made a lot of sense, and was a
very easy transition. I haven't written a C program since!

  -------------------------------------------------------------------------------------
  ![Sue at home](/images/_pub_2001_08_27_bjornstad/sue.jpg){width="203" height="198"}
  -------------------------------------------------------------------------------------

### Q: Your lightning talk was about a program you wrote for a friend. Tell us about that friend.

A: I met Sue in 1986 through a request on a mailing list. The sender was
seeking help to install some software for a woman described as a mute
quadriplegic, paralyzed from the neck down. The request piqued my
interest, and has led to a long-standing friendship. For years I helped
with configuring and programming a device called the Express 3, a
rectangular array of LEDs that she could point to with a light pen
attached to her glasses. That system is now obsolete, and newer devices
are beyond the funding of her family at present, and the variety of
other choices available really didn't match her needs.

### Q: Tell us about the program you wrote for her.

  ----------------------------------------------------------------------------------------------------------------------
  ![Screenshot of Word Prediction Software](/images/_pub_2001_08_27_bjornstad/300-words.gif){width="300" height="223"}
  [**Word Prediction Software in action**]{.secondary}
  Â 
  ![Screenshot of Keyboard Software](/images/_pub_2001_08_27_bjornstad/300-key.gif){width="300" height="223"}
  [**The Keyboard Interface**]{.secondary}
  ----------------------------------------------------------------------------------------------------------------------

A: There are commercial programs that allow the user to point to letters
on an on-screen keyboard, spell out phrases and so on. At first, for
fun, I started writing a program with Perl/Tk for Sue that performed
some of the same functions. Over time, the program has evolved to be
more of a total environment rather than just a keyboard and mouse.

The base functionality includes an on-screen keyboard that lets her
choose letters, words and phrases by pointing to them. By using word
prediction, I have the words and phrases she has previously used
displayed in a list form as she types, so that she can select a word
without typing it in completely. She can both type in prefixes and then
select from a list of matching words, or use abbreviations that get
expanded to the word.

Since she cannot click a mouse button, it was important that the
selection of letters and words not require any clicking. I implemented
this with a timer that triggers the button or word when the pointer
pauses over that element.

I added a text-to-speech synthesizer from Microsoft that is freely
downloadable and works well with Perl. From the Gutenberg project we
downloaded some public-domain, full textbooks and created a reader
interface with which she can select chapters and sections. She can
bookmark locations and return to them later.

Sue also wanted to be able to view photos, so I added a photo album. She
can put photos of her family and friends, and browse them at her
leisure. I also allowed her to redirect the text input to a file (like
\`\`tee'' on Unix). She can even customize all the display colors.

### Q: What was the most difficult part of the program?

  ---------------------------------------------------------------------------------------------------------
  ![Screenshot of Dictionary](/images/_pub_2001_08_27_bjornstad/300-define.gif){width="300" height="223"}
  [**Looking up a word using the Dictionary**]{.secondary}
  Â 
  ![Screenshot of the Reader](/images/_pub_2001_08_27_bjornstad/300-alice.gif){width="300"}
  [**The Reader Display**]{.secondary}
  ---------------------------------------------------------------------------------------------------------

A: I included a dictionary that is referenced with the texts she reads.
She can pause over any word in the text and have that word looked up in
the dictionary, giving quick access to the definition. The tricky part
was allowing the selection to happen by hovering over the word, and
determining what that word is in the text. Nancy Walsh probably didn't
know people would actually use these types of details from her book,
"Learning Perl/Tk." I did! Tk is a wonderful thing.

### Q: How long did the base functionality take you?

A: About a week. The dictionary itself took about another week. I had to
massage the dictionary into DBM files to allow for quicker access, and
the hover selection I described took some time. And then there were the
usual endless fiddlings and polishings that took months!

### Q: Why did you choose Perl for the program?

A: That was a natural choice. I know Perl best, and Perl's strengths
were a perfect fit: extensive text processing, quick creation of
interfaces with Tk and so on. The short time it took to create the
program is evidence that my decision was a good one.

There's another project under way I have noticed, called the Hawking
Communicator. They are creating a program for Stephen Hawking that
includes some similar functionality. Of course, they are assuming that a
user has the ability to right- or left-click. Apparently Stephen Hawking
only has the ability to click - he can only move two fingers with
control. He cannot control the mouse in two dimensions as Sue can. He
uses a technique called ["switch
scanning"](http://callcentre.education.ed.ac.uk/sat_interactive/home.htm).

There are lots of other programs similar to mine. None of them are
perfect for everyone so there is still room for fun projects like the
one that I started.

### Q: Are you still adding features to the program?

A: It's an ongoing project. One thing I want to add is the ability for
Sue to control her lights and television through an X10 interface
similar to the Misterhouse software. This probably wouldn't be too
difficult with the X10 modules.

It would also be nice if she had a way to tidy things up: clean up her
files, delete words and phrases from the word prediction lists, and also
to control more aspects of the whole environment. Sue is a very sharp
lady, and has high standards with regards to order, punctuation and so
on.

### Q: Do you plan to make the program available?

A: Definitely. I'm going to have it downloadable from [my Web
site](http://www.icogitate.com/~perl/sue) soon, with some detailed
instructions on how to install it. I've hoped all along that other
people could benefit from the program.

### Q: Many attendees found your talk inspiring. What are some ways that you see for the Perl community and other programmers to use their abilities for the good of others?

A: I've been involved in quite a few volunteer projects. There's a
retreat center near me named Mount Madonna Center, for which I've
written programs to help them organize their activities, registration
and so on. They have a private school there as well, for which I wrote a
complete school administration program.

I think people just need to be aware of the needs of others. It is quite
rewarding to write a program that directly benefits someone. But
volunteers are needed everywhere. There are needs for people with
computer expertise in most organizations, if not programming expertise.
Just being present as a person with those skills is helpful.

### Q: After your five-minute talk, the audience roared in applause. Many people are still talking about it as one of their favorite talks of the conference. Has any of this surprised you?

A: There were lots of talks that took much more effort than mine. This
one probably touched a human chord that's present in all of us.
Programmers are often considered stereotypical nerds who relate only to
their computers. But we're human, too! It's nice to have a project that
happens to merge the allure of hacking, which we all understand, with
the opportunity to meet a human need.

### Q: Finally, an off-topic question. What is the best and worst thing about Perl?

A: One of the other lightning talks was by a manager who had been turned
back on to programming. He had lots of good things to say about the Perl
community, with its attitude of sharing and helpfulness. It is quite
infectious, and I'm proud to be part of that. That's the best thing.
That manager fellow said that Perl is more like a home than a hotel.
That sounded just right to me!

The worst thing about Perl may be its flexibility. Being so flexible has
gained Perl a reputation as a hacker's language. A person needs a
certain discipline to write good Perl, since style and strictness are
not enforced.

### Q: Any final words?

A: That's all folks, but I'll continue to work on making that [Web
site](http://www.icogitate.com/~perl/sue) more easily accessed and
complete.


