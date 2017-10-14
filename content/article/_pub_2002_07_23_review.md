{
   "date" : "2002-07-23T00:00:00-08:00",
   "draft" : null,
   "image" : null,
   "categories" : "Graphics",
   "tags" : [],
   "description" : " I recently received Martien Verbruggen's long-awaited \"Graphics Programming in Perl,\" and I wasn't quite sure what to make of it. As he notes himself, \"I didn't think there would be enough coherent material to write such a book, and...",
   "thumbnail" : null,
   "authors" : [
      "simon-cozens"
   ],
   "slug" : "/pub/2002/07/23/review.html",
   "title" : "Graphics Programming with Perl"
}





I recently received Martien Verbruggen's long-awaited "Graphics
Programming in Perl," and I wasn't quite sure what to make of it. As he
notes himself, "I didn't think there would be enough coherent material
to write such a book, and I wasn't entirely certain there would be much
room for one." Sure, you can write a chapter or so on business graphing
-- something on GraphViz -- and a few chapters on GD, Imager and
`Image::Magick`. But an entire book?

Like Martien, the more I look at this topic, the more there is to say,
and the more comfortable I am with the way Martien says it. The book
seems to concentrate primarily on `Image::Magick`, with some examples of
`GD`.

All technical books seem to begin with a certain amount of introductory
waffle; in "Graphics Programming in Perl," the waffle is at least to
some degree relevant - there's a fundamental introduction to such things
as color spaces, including some relatively fearsome equations converting
between the various color systems. The introduction is carried on
through chapter 2, a review of graphics file formats. I can't really
categorize this as waffle, though, since a thorough understanding of
these things are fundamental to graphics programming.

The real Perl meat starts around the middle of chapter 2, with sections
on finding the size of an image and converting between images.
Unfortunately, there's more introductory material again in chapter 3,
with sections on the CPAN and descriptions on the modules that will be
used in the rest of the book. Hence, I wouldn't really say this was the
fastest-starting book around, and most people will be able to happily
skip the first 30 or 35 pages without much loss of continuity.

Chapter 4 is where we actually start using Perl to draw things, the
stated purpose of the book. We begin with drawing simple objects in GD,
which is adequately explained, but unfortunately, there's no mention of
how to save the images yet, so we can't check them or play with the
examples and examine the results!

Next, the same examples are implemented using `Image::Magick`, a good
comparison of the two modules; there's also another good comparison in
the middle of an ill-fitting chapter on module interface design. In the
middle, there's precisely the sort of thing you'd expect for a book of
this nature: font handling, business graphs, 3D rendering, (although a
little more detail on this topic would have been nice) and so on. The
section on designing graphics for the Web is, if you'll allow a slight
exaggeration, flawless.

I find the "bullet-point annotated code" style of explanation gets the
important points across well, and Martien has achieved a nice balance of
explanatory prose and demonstration code. The material occasionally
seems to be let down by the odd bug or two in Image::Magick, but we can
hardly blame the author for that.

What really disappointed me about this book was the glaring and complete
omission of the `Imager` module; this is another module for doing
programmatic graphics creation, and I personally favor it above
`Image::Magick` and `GD`, which both require an intermediary external C
library on top of the various libraries for handling graphics formats.

Similarly, much more could have been made of the interaction between
Perl and the Gimp - there were a few pages on creating animated GIFs,
but nothing about using Gimp plug-ins and the like.

Hence, in conclusion, I think if you take this book as being a complete
reference to everything you can do with graphics and Perl, you're going
to be disappointed. However, if you have certain tasks in mind and need
to know how to do them, or you're particularly interested in what you
can do with the `Image::Magick` module, then this book is for you.

[Graphics Programming With
Perl](http://www.manning.com/verbruggen/index.html) is available from
[Manning](http://www.manning.com) and all good computer bookshops.


