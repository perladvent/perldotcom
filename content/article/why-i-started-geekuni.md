{
   "date" : "2015-02-18T13:46:33",
   "slug" : "150/2015/2/18/Why-I-Started-Geekuni",
   "authors" : [
      "Andrew Solomon"
   ],
   "description" : "Learn more about Geekuni, the online learning environment",
   "tags" : [
      "geekuni",
      "moodle",
      "online_learning"
   ],
   "image" : "/images/150/B86DC024-B658-11E4-8BDD-633BD495B04B.png",
   "title" : "Why I Started Geekuni",
   "categories" : "community",
   "draft" : false
}


[Geekuni](https://www.geekuni.com) is an online learning environment I created to help people learn Perl programming. Geekuni is different from many other online learning courses because the student's work is evaluated by a Tutor-bot, giving them instant feedback. The focus is on learning by doing rather than theory.

### Background

Before becoming a Perl developer, I was an academic. I spent most of my time researching the [Travelling Salesman Problem](https://en.wikipedia.org/wiki/Travelling_salesman_problem) until one day I was assigned the job of teaching 350 first-year students the Unix command-line interface.

There was nothing especially difficult about the class; I provided a course sheet explaining the common Unix commands like `ls` and `cat`. The class had an exam at the end of the semester. The problem was that the failure rate was staggering. My students were spending most of their time writing Java on Windows so for many, my exam was their only use of Unix.

For the next semester I put together lots of student exercises to do and a little Perl script to automatically check the students' work. Whenever a student attempted an exercise, they'd run my script which would tell them whether they'd got it right, and if not they could try again until they passed. To my surprise, the students completed all of the exercises within the first three weeks and I had to beef-up the course material to keep them engaged. By the end of semester they were writing sophisticated shell scripts, executing processes and using programs like Sed and Awk. The course pass rate was over 90%.

After I left academia I worked as a Perl developer and started developing a more sophisticated Tutor-bot. My key insight was that students learn programming best by doing, and most of the evaluation and feedback process could be automated. Over time this project developed into Geekuni.

### Geekuni's technology stack

The public [site](https://geekuni.com) is a web application where users can view the course outlines and create an account. It's based on [Starman](https://metacpan.org/pod/Starman) and [Dancer2](https://metacpan.org/pod/Dancer2) . Templating is provided by the [Template::Toolkit](https://metacpan.org/pod/Template::Toolkit) integrated with [Bootstrap](http://getbootstrap.com/). The application classes are written in [Moo](https://metacpan.org/pod/Moo) and [DBIx::Class](https://metacpan.org/pod/DBIx::Class) provides the DB interface.

The course notes and exercises are hosted on [Moodle](https://moodle.org/), probably the most established open source Learning Management System used in universities across the world. With help from one of Moodle's core developers, Jamie Pratt, I put together plugins which help the student start an [AWS](http://aws.amazon.com/) instance to get feedback from the Tutor-bot.

Each student's AWS instance is called an "eBox". I manage them using [Net::Amazon::EC2](https://metacpan.org/pod/Net::Amazon::EC2). The eBox integrates with the Moodle API to provide feedback on student submissions. It uses [PPI](https://metacpan.org/pod/PPI) to parse the student's code, and then it traverses down a dependency [Graph](https://metacpan.org/pod/distribution/Graph/lib/Graph.pod) to identify the essence of any problem the student needs to resolve.

### Looking forwards

My former employer NET-A-PORTER has used the course material from Geekuni for their internal Perl training courses. I'd love to help other organizations and individuals use Geekuni for their own training. Much of my current focus is on solving practical day-to-day issues - as an academic I used to study the Travelling Salesman Problem, and now I'm working the on the "Tutor-bot Scaling problem"!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
