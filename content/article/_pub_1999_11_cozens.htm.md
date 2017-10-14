{
   "date" : "1999-11-16T00:00:00-08:00",
   "categories" : "Community",
   "image" : null,
   "tags" : [],
   "draft" : null,
   "thumbnail" : null,
   "description" : null,
   "title" : "Perl as a First Language",
   "slug" : "/pub/1999/11/cozens.htm",
   "authors" : [
      "nathan-torkington"
   ]
}



Teaching Perl to First-Time Programmers
---------------------------------------

\

One of the criticisms often leveled against Perl is that it's too big
and too complicated for people who haven't programmed before. Simon
Cozens disagrees. He teaches Perl to first-time programmers, and says,
"Perl is an ideal first programming language."

Cozens is a linguist who has taught both formal and informal classes in
Perl to people with a range of programming experience. He found that
beginning programmers took quickly to Perl because "it allows you to
express yourself naturally." For instance, the automatic conversion
between string and numeric types is what non-programmers expect: the
string `"3"` doesn't mean 51; it means 3. And if you add `"4"` to it,
you expect to get `"7"` back.

"Take the implicit things in Perl, like `<>` and `$_`. They can be more
of a bonus than it might appear, and that's because of the way people
think. We use implied objects like 'it' to describe what we're doing,
rather than spelling out things like 'the variable' explicitly every
time."

Even things like regular expressions work well for beginners, says
Cozens. "They're wonderful because people don't think of text or data in
character-by-character terms. They see the whole lot at once, and they
look for patterns in the string; that's the way the brain operates.
Regular expressions work the way people do; you quite naturally say
things like, 'I want to find these characters, but only at the beginning
of the string,' or 'Find three numbers, a space, and three letters,' and
these translate very easily into regular expressions."

When asked whether any parts of Perl caused problems for beginners,
Cozens replied, "There's nothing about Perl that is difficult to
understand if presented appropriately; the difficulty is presenting some
of the concepts in an appropriate way, and that's a question about how
good the teacher is, not the language.

"For instance, references don't have to be hard. You can make them hard,
but not if you talk about putting more than one value into a hash and
leading on from there. There's no need to talk about pointers to areas
of storage and all that sort of thing -- we're not teaching C, we're
teaching Perl.

"Scoping is also tricky because Perl gives you the choice of whether you
want to write good, efficient code, or sloppy, hurried code. I tend to
bring in `use strict` early on because it encourages people to really
think about what they're doing with their variables.''

Cozens firmly believes that Perl should be a first programming language.
"Oh, absolutely! It's ideal because it's a real-world language, unlike
one designed specifically for teaching, such as BASIC (Visual or
otherwise). It's a high-level language that deals naturally with natural
concepts like strings and lines of text, unlike something like C; and it
allows easy data and text manipulation without a tortuous syntax, unlike
something like Python or Tcl. In fact, I don't know if there's a
*better* first programming language."

Cozens is so impressed with Perl for first-time programmers that he's
writing a book, Beginning Perl, to be published by [Wrox
Press](http://www.wrox.com). Says Cozens, "It's aimed at both current
programmers and first-timers alike; it should be accessible to everyone
-- I'm taking a lot of time to make sure it's not too fast-paced but
also not too patronizing to those who already know what a variable or a
subroutine is. Look out for it in January 2000!"
