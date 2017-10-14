{
   "thumbnail" : null,
   "description" : " Creating a Task Tracking System For $0 in Licensing Fees, Hardware, and Software Costs CONEXANT (formerly Rockwell Semiconductor Systems) Supply Chain Management Planning and Execution Systems needed a way to keep track of in-house tasks. When associate departments requested...",
   "authors" : [
      "sam-schulte"
   ],
   "image" : null,
   "categories" : "Windows",
   "tags" : [
      "task-management-system",
      "win32"
   ],
   "title" : "A Zero Cost Solution",
   "date" : "1998-11-17T00:00:00-08:00",
   "slug" : "/pub/1998/11/article.html",
   "draft" : null
}





Creating a Task Tracking System For \$0 in Licensing Fees, Hardware, and
Software Costs
\

CONEXANT (formerly Rockwell Semiconductor Systems) Supply Chain
Management Planning and Execution Systems needed a way to keep track of
in-house tasks. When associate departments requested something be done
for them, a centralized repository of their requests needed to be
created for tracking and management purposes, and the ability to assign
tasks to programmer/analysts needed to be integrated into this
repository of data.

We looked for a simple software solution to meet our needs with no luck.
There were many solutions found that did LOTS more than we needed them
to do, with steep learning curves for users due to the products'
complexities, and more often than not, enormous pricetags accompanied
most of these products. We needed a system that could accomodate as many
as 200 users down the road, and licensing fees for this quantity of
users were outrageous.

So I decided to build one in-house. I had a couple of criteria: 1) The
system had to be able to run on both an Alpha-powered Digital Unix
server, and on a Microsoft NT 4.0 server. 2) The system needed to be
developed fast. Our tasks were piling up and the system was needed to
keep track of them in a way that all concerned could get at the data,
search it, assign tasks from it, modify it, etc.

Enter Perl. I'd been using it for basic CGI for a little over 6 months,
mainly to dynamically generate web pages from text files FTP'd to me by
Oracle database queries. Open a filehandle, read in the text file,
process a few loops, and print some HTML. I looked around the web for a
simple text database management system, found a couple, but didn't
understand how the programmers had come up with the code I saw. I'm
still learning the basics of Perl, and figured I could try to code a
solution that would do the job we needed done, and I could learn a lot
in the process!

Perl amazed me. I was able to logically think of what I wanted to do,
and the language allowed me to stumble and fall gracefully as the
solution quickly came together. It was actually very fun to do! I worked
with *Learning Perl*, *Programming Perl*, and *Effective Perl
Programming* close at hand, and only needed one trip to the Perl
newsgroup to ask a silly question, which was very promptly and
courteously answered.

I got the majority of the basic add, delete, modify, search and assign
(email) process written in about a week, and from start to completely
finished product, it took me only 4 weeks. I must thank Matt Wright for
his [FormMail](http://www.worldwidemart.com/scripts/) Perl script that I
use on the Alpha for form to email processing in the "assign task" code.

The Home screen greets the user, and lets them know they can use any
browser they wish to use the system, and a few other minor tidbits.

![Home Screen](/images/_pub_1998_11_article/home.gif){width="330"
height="226"}\
**Home screen**

The Add screen is where a new task is added to the database. The
database is an ASCII text delimited file, and I provide a link to it on
the Home screen so that users can download it and play in Access or
Excel or whatever. Drop down menus were built with as much information
as possible to make data entry easier on the users throughout the
system.

![Add Screen](/images/_pub_1998_11_article/add.gif){width="449"
height="279"}\
**Add screen**

The Delete screen is presented when the delete menu item is selected. A
radio button allows the user to select which task record is to be
deleted.

![Delete Screen](/images/_pub_1998_11_article/delete.gif){width="450"
height="338"}\
**Delete screen**

The first Modify screen is similiar to the Delete screen...a radio
button selects the task record for modification.

The second Modification screen brings the record back to textboxes,
where the user can modify fields and the information is written back to
the database.

![The second modify
screen](/images/_pub_1998_11_article/modify.gif){width="418"
height="278"}\
**Second modify screen**

The first Assign screen is similiar to the Delete screen...a radio
button selects the task record for assignment.

The second Assign screen brings the record back to the user, where after
review the user selects the task recipient from a drop down menu, and
identifys themself from another drop down menu. When the "Assign Task"
button is pressed, the record data is passed to the sendmail daemon on
the Alpha through Matt Wright's FormMail script.

![Second assignment
screen](/images/_pub_1998_11_article/assign.gif){width="449"
height="246"}\
**Second assign screen**

The Search screen facilitates entry of data for search on a single field
in the database. (As I learn more Perl, I'll add the ability to search
on more than one field at a time, but this works for now!)

![Search screen](/images/_pub_1998_11_article/search.gif){width="316"
height="262"}\
**Search screen**

And finally there is a Show All function, returning all records.

![Show all screen](/images/_pub_1998_11_article/showall.gif){width="450"
height="338"}\
**Show All screen**

The program is currently running on [Gurusamy Sarathy's 5.004\_02 Win32
binary distribution](/CPAN-local/ports/win32/Standard/x86/) on a NT 4.0
server, and works great! It was fun to write, and I suspect I'll be
fiddling with it, adding capabilties as the users request them, for some
time to come. Big thanks to all the Perl community for helping to
develop such a great tool for rapid application development, a tool
easily learned, and very forgiving to us Perl newbies!


