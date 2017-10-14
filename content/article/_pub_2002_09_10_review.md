{
   "draft" : null,
   "categories" : "Web",
   "image" : null,
   "tags" : [],
   "date" : "2002-09-10T00:00:00-08:00",
   "authors" : [
      "simon-cozens"
   ],
   "title" : "Writing CGI Applications with Perl",
   "slug" : "/pub/2002/09/10/review.html",
   "description" : " It seems every month or so, there's a new Perl and CGI book out; huge thick volumes promising to teach you all you need to know about programming for the Web in 24 hours. They all start with \"Hello...",
   "thumbnail" : null
}





It seems every month or so, there's a new Perl and CGI book out; huge
thick volumes promising to teach you all you need to know about
programming for the Web in 24 hours. They all start with "Hello world"
and they invariably finish with a shopping cart example. All this I find
a little tedious.

*Writing CGI Applications with Perl* is not like this. Although, I have
to admit, it has the obligatory shopping cart example. It starts on a
firm footing - security, trustworthiness of user input and the
environment, and tainting. Indeed, security is a recurrent - and a
welcome - theme throughout the book.

Brent and Kevin are both well-known members of the Perl community, and
the style and idiomatic nature of their code is second to none. If you
learn Web programming from this book, then you'll be learning quality
code, guaranteed.

If I had to find the biggest criticism of this book, then it would be
that its audience is quite unclear; you'll need a reasonably firm basic
knowledge of Perl to get the most out of it, and if your Perl is
reasonably strong, then you may find the patient, line-by-line
explanation of the code segments a little tedious. On the other hand,
the beginner may enjoy this style of exposition, but become lost as the
book progresses to more advanced subjects, such as the Perl DBI,
graphics manipulation and `mod_perl`.

Another issue I have is that the organization of material isn't
particularly great - applications developed in the middle of the book
use a backend database, but the DBI is only explained in a later
chapter. However, I have to admit that if you stick to a strict order of
introducing material, then the examples for the first half of the book
end up being horribly contrived. Kevin and Brent have sacrificed a
little linearity to end up with much more interesting, real-life
applications.

What struck me most of all about this book was the clarity of
presentation; both of the explanation of the code, but also of the
physical layout of the book. A large left margin is perfect for
scribbling notes, and the code stands out beautifully. Pulling together
all of the code for a recap at the end of the chapter helps, too, except
in the case of longer examples where you end up with pages of
uncommented code.

However, some of the longer examples, particularly the full-chapter
document management example (something that's come in particularly handy
when we've been developing a similar application ourselves ... .) could
do with many more screenshots so the reader can tell what the result is
going to be.

I was impressed to find that the book covers the more practical areas of
CGI programming - uploading your files to the server, debugging, testing
off-line, dealing with Web caches and so on. There's even a welcome
section on how to read the Perl documentation. In fact, it was a bit of
shame to look up the dreaded "premature end of script headers" error
message in the index and not find an entry; but in real life, the entry
for "debugging" pointed to a soultion that would work.

On the whole, the book covers the complete range of things you're likely
to be doing with CGI: from basic uses of the protocol, through file
upload forms, using mod\_perl, and the ever-popular Web page hit
counter, right up to full-size production applications. In short, I'd
consider this **the** book for those wishing to convert a little Perl
experience into solid Web developer knowledge.

*Writing CGI Applications with Perl is published by Addison-Wesley*


