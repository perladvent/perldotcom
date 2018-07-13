{
   "authors" : [
      "simon-cozens",
      "mark-fowler",
      "ricardo-signes",
      "aaron-trevena"
   ],
   "draft" : null,
   "description" : " Simon Cozens Serendipity - it means those occasions when things come together to give you moments of inspiration. While preparing perl.com one week, I was editing an article on how to give lightning talks by Mark Fowler and at...",
   "slug" : "/pub/2004/09/09/lightning.html",
   "title" : "Lightning Articles",
   "image" : null,
   "categories" : "development",
   "date" : "2004-09-09T00:00:00-08:00",
   "thumbnail" : "/images/_pub_2004_09_09_lightning/111-lightning_articles.gif",
   "tags" : []
}



#### Simon Cozens

Serendipity -- it means those occasions when things come together to give you moments of inspiration. While preparing perl.com one week, I was editing an article on how to give lightning talks by Mark Fowler and at the same time I was dealing with another author who said he was having difficulty stretching out an article -- a very good article, on a topic I wanted to see covered -- to a full 2,500-words-or-so length.

I then realized there were probably a load of people out there with interesting things to say about what they're doing with Perl, but who couldn't or didn't want to write a full-sized article. This is, after all, the principle that makes lightning talks so popular. Maybe we could create a forum where people could have short, informal articles published on an interesting Perl topic of their choice -- lightning articles.

In the same vein as lightning talks, they can be both about an interesting use of the technology, or social commentary on Perl and its community, or just a bit of fun. If you've got something you want to get off your chest, or you've got an interesting new idea you want to talk about, but don't think you could fill 2,500 words, try writing a lightning article. You have an absolute maximum of 500 words -- as measured by `wc -w` (or `perl -0lne    'print scalar split/\s+/'`) on your POD or plain text file -- to say what you need to say.

Send them to `chromatic@oreilly.com`, and when we've got a good batch of five or six together, we'll publish them here.

### <span id="detecting_problem_automatically">Detecting Problems Automatically</span>

#### Mark Fowler

How many times have you shipped something, and then as soon as it's gone live you've spotted a glaring mistake that, despite staring you in the face the entire time you were developing the code, you've somehow overlooked?

One thing we have problems with at work is double-encoded HTML entities in our web pages. We often use HTML entities to encode letters that aren't ASCII, since this way we then don't have to worry about the text encoding we're using.

For example, we want to render the string `Hello Léon`&gt; into our HTML document. So, instead of including the é into our document directly we transform it into its entity form, replacing it with `&eacute;`:

      <p>Hello L&eacute;on</p>

This can be done automatically by Perl in numerous ways, e.g. with **HTML::Entities**:

      use HTML::Entities;
      
      my $string = "Hello $name";
      encode_entity($string);

Or if you're using the Template Toolkit through the `html_entity` filter:

      <p>Hello [% name | html_entity %]</p>

The root of the troubles we were experiencing was that entity encoding could occur in our code in multiple, different places depending on where the string we were about to render came from. And if we accidentally did it more than once then we ended up with HTML that looked like this:

       <p>Hello L&amp;eactue;on</p>

This means the web browser sees the `&amp;` and converts it to an ampersand and then renders the rest of the `eacute;` as normal text:

      Hello L&eacute;on

Not exactly what we wanted. Of course, these things are fairly trivial to fix once you spot them. The real problem we were having is that these errors kept repeatedly popping up, and having our testing department coming back to us every release with another one of these errors was getting embarrassing. We'd gone blind to the errors -- working so closely with the web site we'd glance at the page and not notice what should have been staring us in the face.

So we decided to automatically test for the problem.

In the end I decided to write **Test::DoubleEncodedEntities**, a **Test::Builder** module that would test for these errors and run under **Test::Harness** like all our other tests. The `ok_dee` function relies on the fact that none of our web sites would ever use strings like `&amp;eacute;` (this is true of most web sites - the only web sites that do are ones like this that feature articles on how to encode HTML).

      use LWP::Simple qw(get);
      use Test::More tests => 2;
      use Test::DoubleEncodedEntities;
      
      my $page = get "http://testserver/index.html";
      ok($page, "got page okay");
      ok_dee($page, "check for double encoded entities")

If the test fails then we get some useful diagnostic output:

      1..2
      ok 1 - got page okay
      not ok 2 - check for double encoded entities
      #     Failed test (t/website.t at line 7)
      # Found 1 "&amp;eacute;"
      # Looks like you failed 1 test of 2.

And now we don't even have to look for these things. Our test suite catches double-encoded entities for us and brings them to our attention. Problem solved.

### <span id="cpan_miniaturized">CPAN, Miniaturized</span>

#### Ricardo Signes

Everyone has seen a problem too boring to solve. Rather than keep a stiff upper lip and trudge forward, you head to the CPAN and find the pre-packaged solution that probably already exists. It's just another display of your complete impatience and laziness, and that's great: with the CPAN at your side, you can solve boring problems effortlessly.

The problem, of course, is that CPAN isn't always at your side. Sure, a simple `install Class::DBI` might be enough to implement half of your project, but when you're offline and stuck on the plane, good luck getting to your usual mirror. I've found myself in that position a number of times, and usually when I've most wanted to get some work done. On the way home from conventions, I've sat in cars and planes, wishing I'd remembered to install `Test::Smoke` or `DBD::SQLite` before leaving home.

The solution, of course, is to just mirror the whole CPAN. It's only three gigs, and if you've got a week to spare on your dial-up, that's just fine. After all, later rsyncs are just a few hours a week!

Other problems loom, not the least of which is the possibility of losing those three gigs when your drive crashes on the road. You can always back up the mirror to a DVD in case you need to re-mirror it quickly... but by this point the solution to your problem has become tedious, and I know how you feel about solving tedious problems.

A better solution to this problem was published a few years ago by Randal Schwartz: mini-CPAN. Its guiding principle is an old programmer standard: "You aren't going to need 90 percent of that crap."

Randal's script only retrieves the CPAN indices, and then the modules listed in the package index -- basically, only the newest version of every distribution -- the only files ever used by CPAN.pm and CPANPLUS to install modules. On subsequent runs, only those distributions that have changed are updated.

With this miniature CPAN, you've cut CPAN down to about 400 MB. Not only does it take a fraction of the time to mirror, but it fits nicely onto a CD. You can stick it in your bag, right behind your rescue disk, and know that no matter what happens, the CPAN will be right by your side.

With the script configured and run, you'll have your own personal CPAN sitting on your machine, ready to be used. Pointing CPAN.pm at it is easy as can be:

            cpan> o conf urllist unshift file:///home/japh/minicpan

Alternately, just edit your CPAN::Config or CPANPLUS::Config.

The only problem left with mini-CPAN is that it was so hard to find. It's been such a fantastic addition to my toolbox that I feel slighted, having spent two years oblivious to its existence. To help others avoid this pain, I've tweaked the script, shoved its guts into a module, and stuck it onto CPAN. Just by installing <a href="{{<mcpan "CPAN%3A%3AMini" class="podlinkpod">CPAN::Mini</a>, you can have `minicpan` dropped into place and ready to go:
" >}}
     minicpan -r http://your.favorite.mirror/of/cpan -l /home/japh/minicpan

...and your personal CPAN is waiting.

### <span id="database_bittwiddling">Bit-twiddling in your Database</span>

#### Aaron Trevena

Why would you use a bit mask in your database ?

They can be useful where you have a many-to-many relationship where one side changes rarely and the other frequently. A good example is facilities provided by a Tourist Resort, where the actual amenities change rarely but resorts are added and updated often.

Normalization would add an intermediate table between them, but that can be painfully slow if you have a significant number of amenities and frequently queried records about many of them.

The same problem can occur to a lesser degree within a single table; perhaps you are doing some statistical analysis on demographics with columns representing gender, marital status, etc. For more than a few thousand records, querying subsets of the table based on these criteria can become expensive very quickly.

How would you use bit masks?

Instead of holding information in a separate table or a group of columns, use a bit mask with each bit representing a column in the table or a record in a second table. For example, use 8 bits to represent gender, marital status, employment status, smoker, drinker, driver, car-owner, and house-owner. A query to find drivers under 25 who don't drink or smoke and own their own car contains six conditions:

        select id, age from people where age < 25 and employment_status =
        'employed' and smoker = 'N' and drinker = 'N' and car_owner = 'Y'
        and driver = 'Y'

While a bitmap would use two:

        select id, age from people where age < 25 where bitmap_col & 00000110

To allow employment status to have values for child, student, unemployed, employed, and retired, you would add extra bits representing each value. This applies to any column with a low number of potential values.

This is a simple bitmap index, and you can use all kinds of bitwise operations on your queries against it. Complex queries can be simplified to a couple of binary operations. Of course, there is a downside. It's harder to maintain, and if mapping a many-to-many relationship, you need to ensure consistency between the bit mask order and the contents of the other table. This can be enforced using a trigger or within the application.

If you split the bitmap into individual columns and rotate it you can make a compressed bitmap index that only stores ranges of records that are true for each column or value of a column. Oracle provides this feature.

These compressed bitmap indexes are even faster to query when used together in combination, and take up very little space. However, as multiple records' values can be held in a single entry in the index, updates to indexed columns can be slower and suffer from excessive locking on the index itself.

Well-designed bitmap indices can have a huge impact on the performance of queries, as they are much smaller than standard b-tree indices and much faster on queries where a large proportion of that dataset is being queried.

-   <a href="http://www.jlcomp.demon.co.uk/bitmaps.doc" class="uri" class="podlinkurl">http://www.jlcomp.demon.co.uk/bitmaps.doc</a>
-   <a href="http://www.dbazine.com/jlewis3.shtml" class="uri" class="podlinkurl">http://www.dbazine.com/jlewis3.shtml</a>
-   <a href="http://www.oracle.com/technology/oramag/oracle/02-may/o32expert.html" class="uri" class="podlinkurl">http://www.oracle.com/technology/oramag/oracle/02-may/o32expert.html</a>

### <span id="goodbye_farewell_amen">Goodbye, Farewell, Amen</span>

#### Simon Cozens

Let me first apologize for this personal note; I won't do it again.

Around the time I was busy being born, or maybe just a little after, Larry Wall was planning to be a missionary with the Wycliffe Bible Translators. Working on a degree in "Natural and Artificial Languages," and then in linguistics graduate school, he learned about the ideas of tagmemics, semantics, and the cultural and anthropological concepts that have found their expression in the Perl language and culture. Unfortunately due to health problems, Larry couldn't do the missionary thing, so he invented Perl. That's why we're all here.

It was the beginning of May 2001 when Mark Dominus asked me if I'd be interesting in taking over the job of managing editor here at perl.com. I was delighted, and excited about the thought of working with the Perl community and hopefully producing and publishing some great resources for Perl programmers. I hope I've done a fair bit of that over the last three years, but now my time is up. I'm moving on, and starting next week the man simply known as "chromatic" will become Mr. Perl.com. Please treat him as well as you've treated me!

I need to thank a bunch of people, who've done all the hard work behind the scenes that you don't hear about: Mark, of course, for getting me involved here; Chris Coleman and Bruce Stewart from the O'Reilly Network who've had the curious experience of trying to manage me; Steve McCannell and Chris Valdez have been the producers of perl.com, and worked incessantly to get articles up on the site, often on shockingly short notice; Tara McGoldrick and others have been the copy editors; and of course, I've worked with a wide range of great authors and contributors. Thank you all. And thanks, of course, to the Perl community -- that's **you** -- without whom this wouldn't be half as much fun.

And about that missionary thing? Well, if Larry's not going to be able to do it, someone has to. Like many Perl programmers, and indeed Larry himself, I've been interested in Japan for a very long time. In fact, I lived in Japan for a year, and was studying Japanese for my university major back when I started at perl.com; last year I decided that the time was right to prepare to move back to Japan, as a fulltime missionary.

So in two weeks I'll be going to All Nations University here in England for a two-year course to get me ready, and then I shall be off! I'm sure you won't have heard the last of me, though, and I certainly won't be stopping programming -- missionaries have things they need to automate too... But for now, farewell! It's been fun, and now it's going to be fun in a different way.

Take care out there, and happy hacking!
