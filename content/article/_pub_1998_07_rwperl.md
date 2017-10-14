{
   "description" : " This article is the first in a series that will provide examples of Perl solving real-world problems, particularly in an organization. If you have your own real-life story to tell, send it to Perl.com Editor. How many times have...",
   "thumbnail" : null,
   "authors" : [
      "brent-michalski"
   ],
   "title" : "How Perl Creates Orders For The Air Force",
   "slug" : "/pub/1998/07/rwperl.html",
   "date" : "1998-07-22T00:00:00-08:00",
   "draft" : null,
   "tags" : [
      "air-force",
      "databases",
      "languages",
      "perl",
      "programming"
   ],
   "categories" : "community",
   "image" : null
}





\
*This article is the first in a series that will provide examples of
Perl solving real-world problems, particularly in an organization. If
you have your own real-life story to tell, send it to [Perl.com
Editor](mailto:dale@songline.com).*

How many times have I been in a meeting where someone questions using
Perl for a key business application? Someone says we shouldn't use Perl
because it is *freeware*. Most programming languages, I argue, are not
*owned* by anyone. Are C and C++ any different from Perl in that regard?
If I win that point, someone brings up yet another. I once had a
webmaster tell me that we shouldn't use Perl because of virus concerns.

I just have to accept the fact that educating everyone about Perl is
part of the price I pay to use Perl. Fortunately, most people are easily
persuaded and when I start talking about Perl, it is hard to shut me up.

While I was in the Air Force, I worked in the Base Network Control
Center. It was our responsibility to handle all computer hardware and
software purchases for the base.

The process of ordering equipment was not simple. Many forms had to be
filled out and then signed by the right people in all of the right
places.

We had created a database to track all of this for us but it was still a
difficult process. A single order might have to be on 10 different forms
and have 2 or 3 different documents generated. Also, there were 13
different times that the database entries had to be updated, from the
start of an order until the equipment was received and picked up. This
left too much room for human error. Updating the database was a bother
and many times it just didn't get done. Because of this, the integrity
of the database was always in question. Even *if* the database was
religiously maintained, the ordering process itself was cumbersome. With
nearly 1,000 orders per year, this was a lot of work!

Since I was doing Web development for the base, I proposed a web-based
solution written in Perl. In a meeting to discuss the project, I was
candid. I said I wasn't sure I could do it but I'd give it a try. There
were other solutions proposed but my Web-based solution won out.

We had a list of requirements for the application:

-   Web-based database
-   Customer ability to check their order status
-   Eliminate unnecessary database entries
-   Automate as many necessary entries as possible
-   Generate forms from a web-based interface
-   Generate letters automatically when necessary
-   Notify customers via e-mail when their equipment arrives

The new Perl application was built around a database. It was actually a
flat-file text database. There were two data files that we used; open
and closed. The open database had around 1,000 records, and the closed
database had around 6,000 records. Each record had 33 fields. (In
retrospect, I might not do it with text files again. On a smaller
project, text files are fine but something of this size should have been
on a real database.) Overall, the speed wasn't a problem since 95% of
what we did was on the smaller, open database file.

Our personnel were able to create and update database entries from their
web browser. The application also created forms and other documents that
they needed. For instance, we generated printable order forms compatible
with the Delrina Form Flow software that was in place for creating
equipment orders. We also stored the form data so that forms could be
called up and changed or reprinted at a later time.

We also handled other documents in Rich Text Format (RTF), which the
Perl application could easily manipulate. We could modify the RTF files
on the fly and send the results to the client for printing.

Once the equipment arrived on site, our personnel used the Web interface
to bring up the order number, check which items had come in and the
database was updated. Perhaps the best feature was that the customers
were automatically e-mailed a message that listed the items that had
come in.

This solution saved us an *official* estimate of 900 man-hours per year.
That is all that I could justify on paper. I personally think that this
estimate was low. It simplified so many areas of the ordering process
that I could safely say it saved well over 1,500 man-hours per year.

Not only did it save time:

-   Our customers were able to check the status of their orders from
    their desktop
-   Our customers got the most current information available
-   The database integrity was greatly improved
-   The manual database updates were cut down from 13 to 5
-   Many database functions were masked behind the web interface
-   Saved 20-30 phone calls per week because customers could check
    status on their own

This is just one example of how Perl can be used to create programs that
simplify difficult processes and save time and money for any
organization. Sure, there are many other languages and commercial
applications that you can choose to develop in, but they too have pros
and cons. I have had many of the more *seasoned* web developers ask me
*"why don't I develop in Java?"* I ask them back "*Why don't you develop
in Perl?"* I have never been faced with a Web application that I could
not do in Perl.


