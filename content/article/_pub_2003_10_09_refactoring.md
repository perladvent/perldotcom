{
   "slug" : "/pub/2003/10/09/refactoring",
   "date" : "2003-10-09T00:00:00-08:00",
   "tags" : [
      "faster",
      "optimization",
      "perl",
      "refactoring",
      "refactoring-techniques",
      "speed"
   ],
   "draft" : null,
   "image" : null,
   "authors" : [
      "michael-schwern"
   ],
   "categories" : "development",
   "thumbnail" : "/images/_pub_2003_10_09_refactoring/111-refactoring.gif",
   "description" : " About a year ago, a person asked the Fun With Perl mailing list about some code they had written to do database queries. It's important to note that this person was posting from an .it address; why will become...",
   "title" : "A Refactoring Example"
}





About a year ago, a person asked the [Fun With
Perl](http://www.technofile.org/technofile/depts/mlists/fwp.html)
mailing list about some code they had written to do database queries.
It's important to note that this person was posting from an .it address;
why will become apparent later. The code was reading records in from a
text file and then doing a series of queries based on that information.
They wanted to make it faster.

Here's his code:

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($riga=<INPUT>){
    $nump++;
    chop($riga);
    $pagina[$nump] = $riga;

    $sth= $dbh->prepare("SELECT count(*) FROM lognew WHERE
    pageid='$pagina[$nump]' and data>='$startdate'");
    $sth->execute;
    $totalvisit[$nump] = $sth->fetchrow_array();

    $sth = $dbh->prepare("SELECT count(*) FROM lognew WHERE
    (pageid='$pagina[$nump]' and data='$dataoggi')");
    $sth->execute;
    $totalvisittoday[$nump] = $sth->fetchrow_array();

     $sth = $dbh->prepare("SELECT count(*) FROM lognew WHERE
    (pageid='$pagina[$nump]' and data='$dataieri')");
    $sth->execute;
    $totalyvisit[$nump] = $sth->fetchrow_array();

     $sth= $dbh->prepare("SELECT count(*) FROM lognew WHERE
    (pageid='$pagina[$nump]' and data<='$fine30gg' and data>='$inizio30gg')");
    $sth->execute;
    $totalmvisit[$nump] = $sth->fetchrow_array();

     }

I decided that rather than try to read through this code and figure out
what it's doing and how to make it faster, I'd clean it up first. Clean
it up **before** you figure out how it works? Yes, using a technique
called *Refactoring*.

### Refactoring?

In his book, Martin Fowler defines Refactoring as *"the process of
changing a software system in such a way that it does not alter the
external behavior of the code yet improves its internal structure."* In
other words, you clean up your code but don't change what it does.

Refactoring can be as simple as changing this code:

    $exclamation = 'I like '.$pastry.'!';

To this:

    $exclamation = "I like $pastry!";

Still does the same thing, but it's easier to read.

It's important to note that I don't need to know anything about the
contents of `$pastry` or how `$exclamation` is used. The change is
completely self-contained and does not affect surrounding code or change
what it does. This is Refactoring.

On the principle of "show me don't tell me," rather than talk about it,
we'll dive right into refactoring our bit of code.

### Fix the Indentation

Your first impulse when faced with a hunk of code slammed against the
left margin is to indent it. This is our first refactoring.

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($riga=<INPUT>){
        $nump++;
        chop($riga);
        $pagina[$nump] = $riga;

        $sth= $dbh->prepare("SELECT count(*) FROM lognew WHERE
                             pageid='$pagina[$nump]' and data>='$startdate'");
        $sth->execute;
        $totalvisit[$nump] = $sth->fetchrow_array();

        $sth = $dbh->prepare("SELECT count(*) FROM lognew WHERE
                              (pageid='$pagina[$nump]' and data='$dataoggi')");
        $sth->execute;
        $totalvisittoday[$nump] = $sth->fetchrow_array();

        $sth = $dbh->prepare("SELECT count(*) FROM lognew WHERE
                              (pageid='$pagina[$nump]' and data='$dataieri')");
        $sth->execute;
        $totalyvisit[$nump] = $sth->fetchrow_array();

        $sth= $dbh->prepare("SELECT count(*) FROM lognew WHERE
                             (pageid='$pagina[$nump]' and data<='$fine30gg' 
                             and data>='$inizio30gg')");
        $sth->execute;
        $totalmvisit[$nump] = $sth->fetchrow_array();
    }

    close (INPUT);

Already it looks better. We can see that we're iterating over a file,
performing some SELECTs on each line and shoving the results into a
bunch of arrays.

### A Single, Simple Change

One of the most important principles of Refactoring is that you work in
small steps. This re-indentation is a single step. And part of this
single step includes running the test suite, logging the change, and
checking it into CVS.

Checking into CVS after something this simple? Yes. Many programmers ask
the question, "When should I check in?" When you're refactoring it's
simple: check in when you've done one refactoring and have tested that
it works. Our re-indentation is one thing; we test that it works and
check it in.

This may seem excessive, but it prevents us from entangling two
unrelated changes together. By doing one change at a time we know that
any new bugs were introduced by that one change. Also, you will often
decide in the middle of a refactoring that it's not such a good idea.
When you've checked in at every one you can simply rollback to the last
version rather than having to undo it by hand. Convenient, and you're
sure no stray bits of your aborted change are hanging around.

So our procedure for doing a proper refactoring is:

-   Make one logical change to the code.
-   Make sure it passes tests.
-   Log and check in.

### Big Refactorings from Small

The goal of this refactoring is to make the code go faster. One of the
simplest ways to do achieve that is to pull necessary code out of the
loop. Preparing four new statements in every iteration of the loop seems
really unnecessary. We'd like to pull those `prepare()` statements out
of the loop. This is a refactoring. To achieve this larger refactoring,
a series of smaller refactorings must be done.

### Use Bind Variables

Each time through the loop, a new set of SQL statements is created based
on the line read in. But they're all basically the same, just the data
is changing. If we could pull that data out of the statement we'd be
closer to our goal of pulling the `prepare()`s out of the loop.

So my next refactoring pulls variables out of the SQL statements and
replaces them with placeholders. Then the data is bound to the statement
using bind variables. This means we're now `prepare()`ing the same
statements every time through the loop.

Before refactoring:

    $sth= $dbh->prepare("SELECT count(*) FROM lognew WHERE
                         pageid='$pagina[$nump]' and data>='$startdate'");
    $sth->execute;

After refactoring:

    $sth= $dbh->prepare('SELECT count(*) FROM lognew WHERE 
                         pageid=? and data>=?');
    $sth->execute($pagina[$nump], $startdate);

Bind variables also protect against a naughty user from trying to slip
some extra SQL into your program via the data you read in. As a
side-effect of our code cleanup, we've closed a potential security hole.

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($riga=<INPUT>){
        $nump++;
        chop($riga);
        $pagina[$nump] = $riga;

        $sth= $dbh->prepare('SELECT count(*) FROM lognew WHERE 
                             pageid=? and data>=?');
        $sth->execute($pagina[$nump], $startdate);
        $totalvisit[$nump] = $sth->fetchrow_array();

        $sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE
                              (pageid=? and data=?)');
        $sth->execute($pagina[$nump], $dataoggi);
        $totalvisittoday[$nump] = $sth->fetchrow_array();

        $sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE
                              (pageid=? and data=?)');
        $sth->execute($pagina[$nump], $dataieri);
        $totalyvisit[$nump] = $sth->fetchrow_array();

        $sth= $dbh->prepare('SELECT count(*) FROM lognew WHERE
                             (pageid=? and data<=? and data>=?)');
        $sth->execute($pagina[$nump], $fine30gg, $inizio30gg);
        $totalmvisit[$nump] = $sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### Split a Poorly Reused Variable

The next stumbling block to pulling the `prepare()` statements out of
the loop is that they all use the same variable, `$sth`. We'll have to
change it so they all use different variables. While we're at it, we'll
name those statement handles something more descriptive of what the
statement does. Since at this point we haven't figured out what the
statements do, we can base the name on the array it gets assigned to.

While we're at it, throw in some `my()` declarations to limit the scope
of these variables to just the loop.

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($riga=<INPUT>){
        $nump++;
        chop($riga);
        $pagina[$nump] = $riga;

        my $totalvisit_sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE 
                                            pageid=? and data>=?');
        $totalvisit_sth->execute($pagina[$nump], $startdate);
        $totalvisit[$nump] = $totalvisit_sth->fetchrow_array();

        my $totalvisittoday_sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE
                                                 (pageid=? and data=?)');
        $totalvisittoday_sth->execute($pagina[$nump], $dataoggi);
        $totalvisittoday[$nump] = $totalvisittoday_sth->fetchrow_array();

        my $totalyvisit_sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE
                                             (pageid=? and data=?)');
        $totalyvisit_sth->execute($pagina[$nump], $dataieri);
        $totalyvisit[$nump] = $totalyvisit_sth->fetchrow_array();

        my $totalmvisit_sth= $dbh->prepare('SELECT count(*) FROM lognew WHERE
                                            (pageid=? and data<=? and data>=?)');
        $totalmvisit_sth->execute($pagina[$nump], $fine30gg, $inizio30gg);
        $totalmvisit[$nump] = $totalmvisit_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### Getting Better All the Time

The new names are better, but they're not great. This is ok. Naming is
something people often get hung up on. One can spend hours wracking
their brains thinking of the perfect name for a variable or a function.
If you can think of a better one than what's there right now, use it.
The beauty of Refactoring is you an always improve upon it later.

This is an important lesson of Refactoring. Voltare said, "the best is
the enemy of the good". We often get so wound up trying to make code
*great* that we fail to improve it at all. In refactoring, it's not so
important to make your code great in one leap, just a little better all
the time (it's a little known fact John Lennon was into Refactoring.)
These small improvements will build up into a clean piece of code, with
less bugs, more surely than a large-scale code cleanup would.

### Pull Code Out of the Loop

Now it's a simple cut and paste to pull the four `prepare()` statements
out of the loop.

    my $totalvisit_sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE 
                                        pageid=? and data>=?');

    my $totalvisittoday_sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE
                                             (pageid=? and data=?)');

    my $totalyvisit_sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE
                                         (pageid=? and data=?)');

    my $totalmvisit_sth = $dbh->prepare('SELECT count(*) FROM lognew WHERE
                                         (pageid=? and data<=? and data>=?)');

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($riga=<INPUT>){
        $nump++;
        chop($riga);
        $pagina[$nump] = $riga;

        $totalvisit_sth->execute($pagina[$nump], $startdate);
        $totalvisit[$nump] = $totalvisit_sth->fetchrow_array();

        $totalvisittoday_sth->execute($pagina[$nump], $dataoggi);
        $totalvisittoday[$nump] = $totalvisittoday_sth->fetchrow_array();

        $totalyvisit_sth->execute($pagina[$nump], $dataieri);
        $totalyvisit[$nump] = $totalyvisit_sth->fetchrow_array();

        $totalmvisit_sth->execute($pagina[$nump], $fine30gg, $inizio30gg);
        $totalmvisit[$nump] = $totalmvisit_sth->fetchrow_array();
    }

    close (INPUT);

Already the code is looking better. With the SQL separated, the inner
workings of the loop are much less daunting.

Test. Log. Check in.

### A Place to Stop

Remember our goal, to make this code run faster. By pulling the
`prepare()` statements outside the loop we've likely achieved this goal.
Additionally, it still does exactly what it did before even though we
still don't fully understand what that is. If this were a real project,
you'd do some benchmarking to see if the code is fast enough and move on
to another task.

Since this is an example, I'll continue with more refactorings with the
goal of clarifying the code further and figuring out what it does.

Keep in mind that after every refactoring the code still does *exactly
what it did before*. This means we can stop choose to stop after any
refactoring. If a more pressing task suddenly pops up we can pause our
refactoring work and attend to that feeling confident we didn't leave
any broken code lying around.

### Reformat SQL for Better Readability

In order to make sense of the code, we have to make sense of the SQL.
The simplest way to better understand the SQL is to put it into a
clearer format.

The three major parts of an SQL SELECT statement are:

-   The rows (ie. `SELECT count(*)`)
-   The table (ie. `FROM lognew`)
-   The predicate (ie. `WHERE pageid = ...`)

I've chosen a new format that highlights these parts.

I've also removed some unnecessary parenthesis because they just serve
to clutter things up rather than disambiguate an expression.

I've also decided to change the quoting style from single quotes to a
here-doc. It would have also been okay to use `q{}`.

    my $totalvisit_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $totalvisittoday_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $totalyvisit_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $totalmvisit_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   <= ? AND 
           data   >= ?
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($riga=<INPUT>){
        $nump++;
        chop($riga);
        $pagina[$nump] = $riga;

        $totalvisit_sth->execute($pagina[$nump], $startdate);
        $totalvisit[$nump] = $totalvisit_sth->fetchrow_array();

        $totalvisittoday_sth->execute($pagina[$nump], $dataoggi);
        $totalvisittoday[$nump] = $totalvisittoday_sth->fetchrow_array();

        $totalyvisit_sth->execute($pagina[$nump], $dataieri);
        $totalyvisit[$nump] = $totalyvisit_sth->fetchrow_array();

        $totalmvisit_sth->execute($pagina[$nump], $fine30gg, $inizio30gg);
        $totalmvisit[$nump] = $totalmvisit_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### Remove Redundancy

With the SQL in a more readable format, some commonalities become clear.

-   All the statements are doing a `count(*)`.
-   They're all using the `lognew` table
-   They're all looking for a certain `pageid`.

In fact, `$totalvisittoday_sth` and `$totalyvisit_sth` are exactly the
same! Let's eliminate one of them, doesn't matter which, we're going to
rename them in a moment anyway. `$totalyvisit_sth` goes away, making
sure to change all references to it to `$totalvisittoday_sth`.

    my $totalvisit_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $totalvisittoday_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $totalmvisit_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   <= ? AND 
           data   >= ?
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($riga=<INPUT>){
        $nump++;
        chop($riga);
        $pagina[$nump] = $riga;

        $totalvisit_sth->execute($pagina[$nump], $startdate);
        $totalvisit[$nump] = $totalvisit_sth->fetchrow_array();

        $totalvisittoday_sth->execute($pagina[$nump], $dataoggi);
        $totalvisittoday[$nump] = $totalvisittoday_sth->fetchrow_array();

        $totalvisittoday_sth->execute($pagina[$nump], $dataieri);
        $totalyvisit[$nump] = $totalvisittoday_sth->fetchrow_array();

        $totalmvisit_sth->execute($pagina[$nump], $fine30gg, $inizio30gg);
        $totalmvisit[$nump] = $totalmvisit_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### Fix Conflicting Styles

Now the only difference between the statements is the choice of `data`
ranges.

Using the variables are passed into each statement we can make some more
deductions. Let's have a look...

-   `$startdate`
-   `$dataoggi`
-   `$dataieri`
-   `$fine30gg, $inizio30gg`

*One of these things is not like the other.* What's `$startdate` doing
there? Everything else is talking about 'data'. What's 'ieri'? 'oggi'?
Remember, the programmer who submitted this code is Italian. Maybe the
names are in Italian. Grabbing an [Italian-English
dictionary](http://dictionaries.travlang.com/ItalianEnglish/) we find
out that 'data' is Italian for 'date'! Now it makes sense, this code was
probably originally written in English, then worked on by an Italian (or
vice-versa).

This code has committed a cardinal stylistic sin. It uses two different
languages for naming variables. Not just different languages, languages
which have different meanings for the same words. Taken out of context,
we can't know if `$data` represents a hunk of facts or "Thursday."

Since the styles conflict, one of them has to go. Since I don't speak
Italian, I'm going to translate it into English.

Pulling out our Italian-to-English dictionary...

-   "riga" is "line"
-   "pagina" is "page"
-   "nump" is probably short for "numero pagina" which is "page number"
-   "data" is "date"
-   "oggi" is "today"
-   "ieri" is "yesterday"
-   "inizio" is "start"
-   "fine" is "end"
-   "gg" is probably short for "giorni" which is "days"
    -   "fine30gg" would then be "the end of 30 days"
    -   "inizio30gg" would be "the beginning of 30 days"

It would be a straightforward matter of a bunch of search-and-replaces
in any good editor but for one snag, the SQL column 'data.' We'd like to
change this to its English 'date', but databases are very global with
possibly lots of other programs using it. So we can't change the column
name without breaking other code. While in a well-organized programming
shop you might have the ability to find all the code which uses your
database, we won't assume we have that luxury here. For the moment then,
we'll leave that be and deal with it in a separate refactoring.

    my $totalvisit_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $totalvisittoday_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $totalmvisit_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   <= ? AND 
           data   >= ?
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($line=<INPUT>){
        $page_num++;
        chop($line);
        $pages[$page_num] = $line;

        $totalvisit_sth->execute($pages[$page_num], $start_date);
        $totalvisit[$page_num] = $totalvisit_sth->fetchrow_array();

        $totalvisittoday_sth->execute($pages[$page_num], $today);
        $totalvisittoday[$page_num] = $totalvisittoday_sth->fetchrow_array();

        $totalvisittoday_sth->execute($pages[$page_num], $yesterday);
        $totalyvisit[$page_num] = $totalvisittoday_sth->fetchrow_array();

        $totalmvisit_sth->execute($pages[$page_num], $end_of_30_days,
                                                     $start_of_30_days);
        $totalmvisit[$page_num] = $totalmvisit_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### Better Names

With decent variable names in place, the purpose of the program becomes
**much** clearer. This is a program to calculate the number of visits to
a page for various date ranges. Based on this new information we can
give the statement handles and the arrays they put data into better
names.

Looking at the SQL we see we've got:

-   One to get all the visits up to a single day.
-   One to get the visits for a certain date.
-   One to get the visits for a range of dates.

A good set of new names would be:

-   daily
-   up to
-   range

Also, Total Visits is too long. We could shorten that to just Visits, or
even shorter to Hits.

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   <= ? AND 
           data   >= ?
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($line=<INPUT>){
        $page_num++;
        chop($line);
        $pages[$page_num] = $line;

        $hits_upto_sth->execute($pages[$page_num], $start_date);
        $totalvisit[$page_num] = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($pages[$page_num], $today);
        $totalvisittoday[$page_num] = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($pages[$page_num], $yesterday);
        $totalyvisit[$page_num] = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($pages[$page_num], $end_of_30_days,
                                                    $start_of_30_days);
        $totalmvisit[$page_num] = $hits_range_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### Changing Global Variable Names

The array names need work, too. Currently, they're rather ambiguous.
`@totalyvisit`, what does the *y* mean? Looking at each variable name
and the variables that got passed to `execute()` to produce it...

-   `@totalvisit` comes up to a `$start_date`. So that can be
    `@hits_upto`
-   `@totalvisittoday` comes from `$today` and is pretty obvious.
    `@hits_today`
-   `@totalyvisit` comes from `$yesterday` so 'y' must be for
    'yesterday'. `@hits_yesterday`
-   `@totalmvisit` comes from the range produced by the
    \$start\_of\_30\_days and the \$end\_of\_30\_days. So 'm' must be
    'month'. `@hits_monthly`

<!-- -->

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   <= ? AND 
           data   >= ?
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($line=<INPUT>){
        $page_num++;
        chop($line);
        $pages[$page_num] = $line;

        $hits_upto_sth->execute($pages[$page_num], $start_date);
        $hits_upto[$page_num] = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($pages[$page_num], $today);
        $hits_today[$page_num] = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($pages[$page_num], $yesterday);
        $hits_yesterday[$page_num] = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($pages[$page_num], $end_of_30_days,
                                                    $start_of_30_days);
        $hits_monthly[$page_num] = $hits_range_sth->fetchrow_array();
    }

    close (INPUT);

Test... uh-oh, test failed!

There's something **very** different about this change compared to the
others. The variables we changed were *not* declared in our little code
block. Likely they're used in other parts of the code, such as our test
which caused it to break.

In the Real World, we would be sure to **replace all occurrences of the
variable**. The simplest way to do this is to use your editor to perform
a search and replace rather than doing it by your all too fallible
hands. If it could be used over a set of files, grepping through those
files for all occurrences of it and changing those as well would be
necessary.

    # If you don't have rgrep, grep -r does the same thing.
    rgrep '[@$]totalvisit' /path/to/your/project

I do this so often that I've taken to calling grep -r, 'Refactoring
Grep'. Other languages who's syntax is -- ummm -- not as inspired as
Perl's, such as Java, C++ and Python, have tools for doing this sort of
thing automatically. Because of the complexity of Perl's syntax, we
still have to do it mostly by hand, though there are some efforts
underway to rectify this.

Changing the array names in our test as well we get them to pass.

Log. Check in.

### Improve Overly Generic Names

Continuing with our variable name improvements, we're left with the last
few unimproved names. Let's start with `$line`.

Since we can see clearly that `$line = <INPUT>`, calling the variable
'line' tells us nothing new. A better name might be what each line
contains. Looking at how the line is used we see
`$pages[$page_num] = $line` and how that is then used in the SQL. It's a
page id.

But it doesn't make much sense to put a page id into an array called
`@pages`. It doesn't contain pages, it contains `@page_ids`.

What about `$page_num`? It doesn't contain a page number, it contains
the line number of the file we're reading in. Or more conventionally, an
`$index` or `$idx`.

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   <= ? AND 
           data   >= ?
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($page_id=<INPUT>){
        $idx++;
        chop($page_id);
        $page_ids[$idx] = $page_id;

        $hits_upto_sth->execute($page_ids[$idx], $start_date);
        $hits_upto[$idx] = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($page_ids[$idx], $today);
        $hits_today[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($page_ids[$idx], $yesterday);
        $hits_yesterday[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($page_ids[$idx], $end_of_30_days,
                                                       $start_of_30_days);
        $hits_monthly[$idx] = $hits_range_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### Fixing Odd Interfaces

What's wrong with this picture?

    $hits_range_sth->execute($page_ids[$idx], $end_of_30_days,
                                                   $start_of_30_days);

Isn't it a little odd to specify a date range with the end first? Sure
is. It also guarantees someone is going to get it backwards. Reverse it.
Don't forget the SQL, too.

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   >= ? AND
           data   <= ? 
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($page_id=<INPUT>){
        $idx++;
        chop($page_id);
        $page_ids[$idx] = $page_id;

        $hits_upto_sth->execute($page_ids[$idx], $start_date);
        $hits_upto[$idx] = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($page_ids[$idx], $today);
        $hits_today[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($page_ids[$idx], $yesterday);
        $hits_yesterday[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($page_ids[$idx], $start_of_30_days,
                                                       $end_of_30_days);
        $hits_monthly[$idx] = $hits_range_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### s/chop/chomp/

Now that we've stared at the code for a while, you might have noticed
the use of `chop()`. Using `chop()` to strip a newline is asking for
portability problems, so let's fix it by using `chomp()`.

Technically this *isn't* a refactoring since we altered the behavior of
the code by fixing the bug. But using `chop()` where you meant `chomp()`
is such a common mistake we'll make it an honorary refactoring.

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   >= ? AND
           data   <= ? 
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($page_id=<INPUT>){
        $idx++;
        chomp($page_id);
        $page_ids[$idx] = $page_id;

        $hits_upto_sth->execute($page_ids[$idx], $start_date);
        $hits_upto[$idx] = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($page_ids[$idx], $today);
        $hits_today[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($page_ids[$idx], $yesterday);
        $hits_yesterday[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($page_ids[$idx], $start_of_30_days,
                                                       $end_of_30_days,);
        $hits_monthly[$idx] = $hits_range_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### Collect Related Variables into Hashes

The common prefix `hits_` is a dead giveaway that much of the data in
this code is related. Related variables should be grouped together into
a single structure, probably a hash to make the relation obvious and
allow them to be passed around to subroutines more easily. Its easier to
move around one hash than four arrays.

I've decided to collect together all the `@hit_` arrays into a single
hash `%hits` since they'll probably be used together parts of the
program. If this code snippet represents a function it means I can
return one hash reference rather than four array refs. It also makes
future expansion easier, rather than returning an additional array it
simply becomes another key in the hash.

Before.

    $hits{upto}[$idx] = $hits_upto_sth->fetchrow_array();

After.

    $hits_upto[$idx]  = $hits_upto_sth->fetchrow_array();

It's interesting to note what a small, natural change this is.
Circumstantial evidence that this is a good refactoring.

As before, since these arrays are global data, we must be sure to change
them everywhere. This includes the tests.

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   >= ? AND
           data   <= ? 
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($page_id=<INPUT>){
        $idx++;
        chomp($page_id);
        $page_ids[$idx] = $page_id;

        $hits_upto_sth->execute($page_ids[$idx], $start_date);
        $hits{upto}[$idx] = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($page_ids[$idx], $today);
        $hits{today}[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($page_ids[$idx], $yesterday);
        $hits{yesterday}[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($page_ids[$idx], $start_of_30_days,
                                                       $end_of_30_days,);
        $hits{monthly}[$idx] = $hits_range_sth->fetchrow_array();
    }

    close (INPUT);

Test. Log. Check in.

### When Not to Refactor

The statement handles are also related, but I'm not going to collect
them together into a hash. The statement handles are short-lived
lexicals, they're never likely to be passed around. Their short scope
and grouping within the code makes their relationship obvious. The
design would not be improved by the refactoring.

Refactoring is not a set of rules to be slavishly followed, it's a
collection of tools. And like any other tool you must carefully consider
when and when not to use it. Since collecting the statement handles
together doesn't improve the design, I won't do it.

### Eliminate Unnecessary Longhand

Boy, we sure use `$page_ids[$idx]` a lot. It's the current page ID. But
don't we have a variable for that?

Replace all the unnecessary array accesses and just use the more concise
and descriptive `$page_id`.

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   >= ? AND
           data   <= ? 
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($page_id=<INPUT>){
        $idx++;
        chomp($page_id);
        $page_ids[$idx] = $page_id;

        $hits_upto_sth->execute($page_id, $start_date);
        $hits{upto}[$idx] = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($page_id, $today);
        $hits{today}[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($page_id, $yesterday);
        $hits{yesterday}[$idx] = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($page_id, $start_of_30_days,
                                           $end_of_30_days,);
        $hits{monthly}[$idx] = $hits_range_sth->fetchrow_array();
    }

Test. Log. Check in.

### Rearrange Data Structures to Fit Their Use

Currently, `%hits` is accessed by the order the page ID was read out of
the file. Well, that doesn't seem very useful at all. Its purpose seems
to be for listing the page counts in exactly the same order as you read
them in. Even then you need to iterate through `@page_ids`
simultaneously because no where in `%hits` is the page ID stored.

Consider a common operation, looking up the hit counts for a given page
ID. You have to iterate through the whole list of page IDs to do it.

    foreach my $idx (0..$#page_ids) {
        if( $page_ids[$idx] eq $our_page_id ) {
            print "Hits for $our_page_id today: $hits{today}[$idx]\n";
            last;
        }
    }

Cumbersome. A much better layout would be a hash keyed on the page ID.

    $hits{upto}{$page_id} = $hits_upto_sth->fetchrow_array();

Now we can directly access the data for a given page ID. If necessary,
we can still list the hits in the same order they were read in by
iterating through `@page_ids`.

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   >= ? AND
           data   <= ? 
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($page_id=<INPUT>){
        $idx++;
        chomp($page_id);
        $page_ids[$idx] = $page_id;

        $hits_upto_sth->execute($page_id, $start_date);
        $hits{upto}{$page_id} = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($page_id, $today);
        $hits{today}{$page_id} = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($page_id, $yesterday);
        $hits{yesterday}{$page_id} = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($page_id, $start_of_30_days,
                                           $end_of_30_days,);
        $hits{monthly}{$page_id} = $hits_range_sth->fetchrow_array();
    }

Test. Log. Check in.

### Eliminate Unnecessary Variables

Now that `%hits` is no longer ordered by how it was read in, `$idx`
isn't used much anymore. It's only used to stick `$page_id` onto the end
of `@page_ids`, but we can do that with `push`.

This is minor but little things build up to cause big messes.

    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   >= ? AND
           data   <= ? 
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($page_id=<INPUT>){
        chomp($page_id);
        push @page_ids, $page_id;

        $hits_upto_sth->execute($page_id, $start_date);
        $hits{upto}{$page_id} = $hits_upto_sth->fetchrow_array();

        $hits_daily_sth->execute($page_id, $today);
        $hits{today}{$page_id} = $hits_daily_sth->fetchrow_array();

        $hits_daily_sth->execute($page_id, $yesterday);
        $hits{yesterday}{$page_id} = $hits_daily_sth->fetchrow_array();

        $hits_range_sth->execute($page_id, $start_of_30_days,
                                           $end_of_30_days,);
        $hits{monthly}{$page_id} = $hits_range_sth->fetchrow_array();
    }

Test. Log. Check in.

### Pull Logical Chunks Out into Functions

Our final refactoring is one of the most common and most useful.

Let's assume that we need to generate page counts somewhere else in the
code. Rather than repeat the code to do this, we want to put it in a
subroutine so it can be reused. One subroutine for each statement.

In order to do this, start by identifying the code that would go into
the routine.

    $hits_upto_sth->execute($page_id, $start_date);
    $hits{upto}{$page_id} = $hits_upto_sth->fetchrow_array();

Then wrap a subroutine around it.

    sub hits_upto {
        $hits_upto_sth->execute($page_id, $start_date);
        $hits{upto}{$page_id} = $hits_upto_sth->fetchrow_array();
    }

Now look at all the variables used.

`$hits_upto_sth` is a global (well, file-scoped lexical) and is defined
entirely outside the function. We can keep using it in our subroutine in
the same way we are now.

`$hits{upto}{$page_id}` is receiving the result of the calculation. It
contains the return value. So it goes outside the function to receive
the return value. Where its assignment was, we put a `return`.

    sub hits_upto {
        $hits_upto_sth->execute($page_id, $start_date);
        return $hits_upto_sth->fetchrow_array();
    }

`$page_id` and `$start_date` vary from call to call. These are our
function arguments.

    sub hits_upto {
        my($page_id, $start_date) = @_;
        $hits_upto_sth->execute($page_id, $start_date);
        return $hits_upto_sth->fetchrow_array();
    }

Finally, rename things in a more generic manner. This is a subroutine
for calculating the number of hits up to a certain date. Instead of
`$start_date` which was specific to one calculation, we'd call it
`$date`.

    sub hits_upto {
        my($page_id, $date) = @_;
        $hits_upto_sth->execute($page_id, $date);
        return $hits_upto_sth->fetchrow_array();
    }

And that's our new subroutine, does the same thing as the original code.
Then it's a simple matter to use it in the code.

        $hits{upto}{$page_id} = hits_upto($page_id, $start_date);


    my $hits_upto_sth = $dbh->prepare(<<'SQL');
    SELECT count(*)
    FROM   lognew 
    WHERE  pageid =  ? AND 
           data   >= ?
    SQL

    my $hits_daily_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid = ? AND 
           data   = ?
    SQL

    my $hits_range_sth = $dbh->prepare(<<'SQL');
    SELECT count(*) 
    FROM   lognew 
    WHERE  pageid =  ? AND
           data   >= ? AND
           data   <= ? 
    SQL

    open (INPUT, "< $filepageid") || &file_open_error("$filepageid");

    while ($page_id=<INPUT>){
        chomp($page_id);
        push @page_ids, $page_id;

        $hits{upto}{$page_id}      = hits_upto($page_id, $start_date);
        $hits{today}{$page_id}     = hits_daily($page_id, $today);
        $hits{yesterday}{$page_id} = hits_daily($page_id, $yesterday);
        $hits{monthly}{$page_id}   = hits_range($page_id, $start_of_30_days,
                                                            $end_of_30_days,);
    }

    sub hits_upto {
        my($page_id, $date) = @_;
        $hits_upto_sth->execute($page_id, $date);
        return scalar $hits_upto_sth->fetchrow_array();
    }

    sub hits_daily {
        my($page_id, $date) = @_;
        $hits_daily_sth->execute($page_id, $date);
        return scalar $hits_daily_sth->fetchrow_array();
    }

    sub hits_range {
        my($page_id, $start, $end) = @_;
        $hits_range_sth->execute($page_id, $start, $end);
        return scalar $hits_range_sth->fetchrow_array();
    }

Test. Log. Check in.

### Undo.

Some may balk at putting that small of a snippet of code into a
subroutine like that. There are definite performance concerns about
adding four subroutine calls to a loop. But I'm not worried about that
at all.

One of the beauties of Refactoring is that it's reversible. Refactorings
don't change how the program works. We can reverse any of these
refactorings and the code will work exactly the same. If a refactoring
turns out to be a bad idea, undo it. Logging each refactoring in version
control makes the job even easier.

So if it turns out moving the executes into their own functions causes a
performance problem the change can easily be undone.

### Done?

At this point, things are looking pretty nice. The code is well
structured, readable, and efficient. The variables are sensibly named.
The data is organized in a fairly flexible manner.

It's good enough. This is not to say that there's not more that could be
done, but we don't need to. And Refactoring is about doing as much
redesign as you need instead of what you might need.

### Refactoring and the Swiss Army Knife

As programmers we have a tendency towards over-design. We like to design
our code to deal with any possible situation that might arise, since it
was hard to change the design later. This is known as Big Design Up
Front (BDUF). It's like one of those [enormous Swiss Army Knives with 50
functions](http://www.victorinox.com/newsite/en/produkte/neu/inhalt2.cfm?pid=1-6795-XLT).
Most of the time all you need is [a knife with something to open your
beer with and then maybe pick your teeth
afterwards](http://www.victorinox.com/newsite/en/produkte/neu/inhalt2.cfm?pid=2-2363)
but you never know. So you over-engineer because it's hard to improve it
later. If it never gets used then a lot of effort has been wasted.

Refactoring turns design on its ear. Now you can continually evolve your
design as needed. There's no longer a need to write for every possible
situation up front so you can focus on just what you need right now. If
you need more flexibility later, you can add that flexibility through
refactoring. It's like having a Swiss Army knife that you can add tools
to as you need them.

### Further Reference

-   [The original thread on Fun With
    Perl](http://groups.google.com/groups?th=11b4e3caaafb9849&seekm=20021005063711.GE15102%40ool-18b93024.dyn.optonline.net#link1)
-   The [Portland Pattern
    Repository](http://www.c2.com/cgi/wiki?WelcomeVisitors) answers the
    question --
    [WhatIsRefactoring?](http://www.c2.com/cgi/wiki?WhatIsRefactoring)
-   [The Refactoring
    Book](http://www.amazon.com/exec/obidos/tg/detail/-/0201485672) by
    [Martin Fowler](http://www.martinfowler.com)


