{
   "authors" : [
      "simon-cozens"
   ],
   "draft" : null,
   "description" : "Update: Perl Profiling has evolved since this article was written, please see http://www.perl.org/about/whitepapers/perl-profiling.html for the latest information. Everyone wants their Perl code to run faster. Unfortunately, without understanding why the code is taking so long to start with, it's impossible...",
   "slug" : "/pub/2004/06/25/profiling.html",
   "thumbnail" : "/images/_pub_2004_06_25_profiling/111-profiling.gif",
   "tags" : [
      "optimization",
      "profiler",
      "profiling",
      "speed"
   ],
   "title" : "Profiling Perl",
   "image" : null,
   "categories" : "development",
   "date" : "2004-06-24T00:00:00-08:00"
}



**Update:** [Perl Profiling](http://www.perl.org/about/whitepapers/perl-profiling.html) has evolved since this article was written, please see <http://www.perl.org/about/whitepapers/perl-profiling.html> for the latest information.

Everyone wants their Perl code to run faster. Unfortunately, without understanding why the code is taking so long to start with, it's impossible to know where to start optimizing it. This is where "profiling" comes in; it lets us know what our programs are doing.

We'll look at why and how to profile programs, and then what to do with the profiling information once we've got it.

### <span id="Why_Profile?">Why Profile?</span>

There's nothing worse than setting off a long-running Perl program and then not knowing what it's doing. I've recently been working on a new, mail-archiving program for the `perl.org` mailing lists, and so I've had to import a load of old email into the database. Here's the code I used to do this:

        use File::Slurp;
        use Email::Store "dbi:SQLite:dbname=mailstore.db";
        use File::Find::Rule;

        for (File::Find::Rule->file->name(qr/\d+/)->in("perl6-language")) {
            Email::Store::Mail->store(scalar read_file($_));
        }

It's an innocent little program -- it looks for all the files in the *perl6-language* directory whose names are purely numeric (this is how messages are stored in an ezmlm archive), reads the contents of the files into memory with `File::Slurp::read_file`, and then uses [`Email::Store`](http://search.cpan.org/perldoc?Email::Store) to put them into a database. You start it running, and come back a few hours later and it's done.

All through, though, you have this nervous suspicion that it's not doing the right thing; or at least, not doing it very quickly. Sure there's a lot of mail, but should it really be taking this long? What's it actually spending its time doing? We can add some `print` statements to help us feel more at ease:

        use File::Slurp;
        use Email::Store "dbi:SQLite:dbname=mailstore.db";
        use File::Find::Rule;

        print "Starting run...\n";
        $|++;
        for (File::Find::Rule->file->name(qr/\d+/)->in("perl6-language")) {
            print "Indexing $_...";
            Email::Store::Mail->store(scalar read_file($_));
            print " done\n";
        }

Now we can at least see more progress, but we still don't know if this program is working to full efficiency, and the reason for this is that there's an awful lot going on in the underlying modules that we can't immediately see. Is it the `File::Find::Rule` that's taking up all the time? Is it the storing process? Which part of the storing process? By profiling the code we'll identify, and hopefully smooth over, some of the bottlenecks.

### <span id="Simple_Profiling">Simple Profiling</span>

The granddaddy of Perl profiling tools is [`Devel::DProf`](http://search.cpan.org/perldoc?Devel::DProf). To profile a code run, add the `-d:DProf` argument to your Perl command line and let it go:

        % perl -d:DProf store_archive

The run will now take slightly longer than normal as Perl collects and writes out information on your program's subroutine calls and exits, and at the end of your job, you'll find a file called *tmon.out* in the current directory; this contains all the profiling information.

A couple of notes about this:

-   It's important to control the length of the run; in this case, I'd probably ensure that the mail archive contained about ten or fifteen mails to store. (I used seven in this example.) If your run goes on too long, you will end up processing a vast amount of profiling data, and not only will it take a lot time to read back in, it'll take far too long for you to wade through all the statistics. On the other hand, if the run's too short, the main body of the processing will be obscured by startup and other "fixed costs."
-   The other problem you might face is that `Devel::DProf`, being somewhat venerable, occasionally has problems keeping up on certain recent Perls, (particularly the 5.6.x series) and may end up segfaulting all over the place. If this affects you, download the [`Devel::Profiler`](http://search.cpan.org/perldoc?Devel::Profiler) module from CPAN, which is a pure-Perl replacement for it.

The next step is to run the preprocessor for the profiler output, `dprofpp`. This will produce a table of where our time has been spent:

      Total Elapsed Time = 13.89525 Seconds
        User+System Time = 9.765255 Seconds
      Exclusive Times
      %Time ExclSec CumulS #Calls sec/call Csec/c  Name
       24.1   2.355  4.822     38   0.0620 0.1269  File::Find::_find_dir
       20.5   2.011  2.467  17852   0.0001 0.0001  File::Find::Rule::__ANON__
       7.82   0.764  0.764    531   0.0014 0.0014  DBI::st::execute
       4.73   0.462  0.462  18166   0.0000 0.0000  File::Spec::Unix::splitdir
       2.92   0.285  0.769    109   0.0026 0.0071  base::import
       2.26   0.221  0.402    531   0.0004 0.0008  Class::DBI::transform_sql
       2.09   0.204  0.203   8742   0.0000 0.0000  Class::Data::Inheritable::__ANON__
       1.72   0.168  0.359  18017   0.0000 0.0000  Class::DBI::Column::name_lc
       1.57   0.153  0.153  18101   0.0000 0.0000  Class::Accessor::get
       1.42   0.139  0.139     76   0.0018 0.0018  Cwd::abs_path

The first two lines tell us how long the program ran for: around 14 seconds, but it was actually only running for about 10 of those -- the rest of the time other programs on the system were in the foreground.

Next we have a table of subroutines, in descending order of time spent; perhaps surprisingly, we find that `File::Find` and `File::Find::Rule` are the culprits for eating up 20% of running time each. We're also told the number of "exclusive seconds," which is the amount of time spent in one particular subroutine, and "cumulative seconds." This might better be called "inclusive seconds," since it's the amount of time the program spent in a particular subroutine and all the other routines called from it.

From the statistics above, we can guess that `File::Find::_find_dir` itself took up 2 seconds of time, but during its execution, it called an anonymous subroutine created by `File::Find::Rule`, and this subroutine also took up 2 seconds, making a cumulative time of 4 seconds. We also notice that we're making an awful lot of calls to `File::Find::Rule`, `splitdir`, and some `Class::DBI` and `Class::Accessor` routines.

### <span id="What_to_do_now">What to Do Now</span>

Now we have some profiling information, and we see a problem with `File::Find::Rule`. "Aha," we might think, "Let's replace our use of `File::Find::Rule` with a simple globbing operation, and we can shave 4 seconds off our runtime!". So, just for an experiment, we try it:

        use File::Slurp;
        use Email::Store "dbi:SQLite:dbname=mailstore.db";
        $|=1;
        for (<perl6-language/archive/0/*>) {
            next unless /\d+/;
            print "$_ ...";
            Email::Store::Mail->store(scalar read_file($_));
            print "\n";
        }

Now this looks a bit better:

     Total Elapsed Time = 9.559537 Seconds
       User+System Time = 5.329537 Seconds
     Exclusive Times
     %Time ExclSec CumulS #Calls sec/call Csec/c  Name
      13.1   0.703  0.703    531   0.0013 0.0013  DBI::st::execute
      5.54   0.295  0.726    109   0.0027 0.0067  base::import
      5.52   0.294  0.294  18101   0.0000 0.0000  Class::Accessor::get
      3.45   0.184  1.930  19443   0.0000 0.0001  Class::Accessor::__ANON__
      3.13   0.167  0.970    531   0.0003 0.0018  DBIx::ContextualFetch::st::_untain
                                                  t_execute
      3.10   0.165  1.324   1364   0.0001 0.0010  Class::DBI::get
      2.98   0.159  0.376    531   0.0003 0.0007  Class::DBI::transform_sql
      2.61   0.139  0.139     74   0.0019 0.0019  Cwd::abs_path
      2.23   0.119  0.119   8742   0.0000 0.0000  Class::Data::Inheritable::__ANON__
      2.06   0.110  0.744   2841   0.0000 0.0003  Class::DBI::__ANON__
      1.95   0.104  0.159   2669   0.0000 0.0001  Class::DBI::ColumnGrouper::group_cols

Now to be honest, I would never have guessed that removing `File::Find::Rule` would shave 4 seconds off my code run. This is the first rule of profiling: You actually need to profile before optimizing, because **you never know where the hotspots are going to turn out to be.** We've also exercised the second rule of profiling: **Review what you're using.** By using another technique instead of `File::Find::Rule`, we've reduced our running time by a significant amount.

This time, it looks as though we're doing reasonably well -- the busiest thing is writing to a database, and that's basically what this application does, so that's fair enough. There's also a lot of busy calls that are to do with `Class::DBI`, and we know that we use `Class::DBI` as a deliberate tradeoff between convenience and efficiency. If we were being ruthlessly determined to make this program faster, we'd start looking at using plain `DBI` instead of `Class::DBI`, but that's a tradeoff I don't think is worth making at the moment.

This is the third rule of profiling: **Hotspots happen.** If you got rid of all the hotspots in your code, it wouldn't do anything. There are a certain reasonable number of things that your program should be doing for it to be useful, and you simply can't get rid of them; additionally there are any number of tradeoffs that we deliberately or subconsciously make in order to make our lives easier at some potential speed cost -- for instance, writing in Perl or C instead of machine code.

### <span id="From_exclusive_to_inclusive">From Exclusive to Inclusive</span>

The default report produced by *dprofpp* is sorted by exclusive subroutine time, and is therefore good at telling us about individual subroutines that are called a lot and take up disproportionate amounts of time. This can be useful, but it doesn't actually give us an overall view of what our code is doing. If we want to do that, we need to move from looking at exclusive to looking at inclusive times, and we do this by adding the `-I` option to *dprofpp*. This produces something like this:

     Total Elapsed Time = 9.559537 Seconds
       User+System Time = 5.329537 Seconds
     Inclusive Times
     %Time ExclSec CumulS #Calls sec/call Csec/c  Name
      83.8   0.009  4.468      7   0.0013 0.6383  Email::Store::Mail::store
      80.8   0.061  4.308     35   0.0017 0.1231  Module::Pluggable::Ordered::__ANON
                                                  __
      46.3       -  2.472      3        - 0.8239  main::BEGIN
      43.4       -  2.314      7        - 0.3306  Mail::Thread::thread
      43.4       -  2.314      7        - 0.3305  Email::Store::Thread::on_store
      36.2   0.184  1.930  19443   0.0000 0.0001  Class::Accessor::__ANON__
      28.9   0.006  1.543    531   0.0000 0.0029  Email::Store::Thread::Container::_
                                                  _ANON__
      27.3   0.068  1.455    105   0.0006 0.0139  UNIVERSAL::require

This tells us a number of useful facts. First, we find that 84% of the program's runtime is spent in the `Email::Store::Mail::store` subroutine and its descendants, which is the main, tight loop of the program. This means, quite logically, that 16% is not spent in the main loop, and that's a good sign -- this means that we have a 1-second fixed cost in starting up and loading the appropriate modules, and this will amortize nicely against a longer run than 10 seconds. After all, if processing a massive amount of mail takes 20 minutes, the first 1-second startup becomes insignificant. It means we can pretty much ignore everything outside the main loop.

We also find that threading the emails is costly; threading involves a lot of manipulation of `Email::Store::Thread::Container` objects, which are database backed. This means that a lot of the database stores and executes that we saw in the previous, exclusive report are probably something to do with threading. After all, we now spend 2 seconds out of our 4 seconds of processing time on threading in `Mail::Thread::thread`, and even though we only call this seven times, we do 531 things with the container objects. This is bad.

Now, I happen to know (because I wrote the module) that `Email::Store::Thread::Container` uses a feature of `Class::DBI` called `autoupdate`. This means that while we do a lot of fetches and stores that we could conceivably do in memory and commit to the database once we're done, we instead hit the database every single time.

So, just as an experiment, we do two things to optimize `Email::Store::Thread::Container`. First, we know that we're going to be doing a lot of database fetches, sometimes of the same container multiple times, so we cache the fetch. We turn this:

        sub new { 
            my ($class, $id) = @_;
            $class->find_or_create({ message => $id });
        }

Into this:

        my %container_cache = ();
        sub new {
            my ($class, $id) = @_;
            $container_cache{$id} 
                ||= $class->find_or_create({ message => $id });
        }

This is a standard caching technique, and will produce another tradeoff: we trade memory (in filling up `%container_cache` with a bunch of objects) for speed (in not having to do as many costly database fetches).

Then we turn `autoupdate` off, and provide a way of updating the database manually. The reason we wanted to turn off `autoupdate` is that because all these containers form a tree structure (since they represent mails in a thread which, naturally, form a tree structure), it's a pain to traverse the tree and update all the containers once we're done.

However, with this cache in place, we know that we already have a way to get at all the containers in one go: we just look at the values of `%container_hash`, and there are all the objects we've used. So we can now add a `flush` method:

        sub flush {
            (delete $container_cache{$_})->update for keys %container_cache;
        }

This both empties the cache and updates the database. The only remaining problem is working out where to call `flush`. If we're dealing with absolutely thousands of emails, it might be worth calling `flush` after every `store`, or else `%container_hash` will get huge. However, since we're not, we just call `flush` in an `END` block to catch the container objects before they get destroyed by the garbage collector:

        END { Email::Store::Thread::Container->flush; }

Running *dprofpp* again:

     Total Elapsed Time = 7.741969 Seconds
       User+System Time = 3.911969 Seconds
     Inclusive Times
     %Time ExclSec CumulS #Calls sec/call Csec/c  Name
      65.4       -  2.559      7        - 0.3656  Email::Store::Mail::store
      62.9   0.014  2.461     35   0.0004 0.0703  Module::Pluggable::Ordered::__ANON
                                                  __
      56.2   0.020  2.202      3   0.0065 0.7341  main::BEGIN
      31.8   0.028  1.247    105   0.0003 0.0119  UNIVERSAL::require
      29.4   0.004  1.150      7   0.0006 0.1642  Email::Store::Entity::on_store
      22.7   0.025  0.890    100   0.0003 0.0089  Class::DBI::create
      21.0   0.031  0.824    100   0.0003 0.0082  Class::DBI::_create
      18.3   0.235  0.716    109   0.0022 0.0066  base::import
      15.1       -  0.594    274        - 0.0022  DBIx::ContextualFetch::st::execute
      15.1       -  0.592      7        - 0.0846  Mail::Thread::thread
      15.1       -  0.592      7        - 0.0845  Email::Store::Thread::on_store

We find that we've managed to shave another second-and-a-half off, and we've also swapped a per-mail cost (of updating the threading containers every time) to a once-per-run fixed cost (of updating them all at the end of the run). This has taken the business of threading down from two-and-a-half seconds per run to half a second per run, and it means that 35% of our running time is outside the main loop; again, this will amortize nicely on large runs.

We started with a program that runs for 10 seconds, and now it runs for 4. Through judicious use of the profiler, we've identified the hotspots and eliminated the most troublesome ones. We've looked at both exclusive and inclusive views of the profiling data, but there are still a few other things that *dprofpp* can tell us. For instance, the `-S` option gives us a call tree, showing what gets called from what. These trees can be incredibly long and tedious, but if the two views we've already looked at haven't identified potential trouble spots, then wading through the tree might be your only option.

### <span id="Writing_your_own_profiler">Writing your Own Profiler</span>

At least, that is, if you want to use *dprofpp*; until yesterday, that was the only way of reading profiling data. Yesterday, however, I released [`Devel::DProfPP`](https://metacpan.org/pod/Devel::DProfPP), which provides an event-driven interface to reading *tmon.out* files. I intended to use it to write a new version of *dprofpp* because I find the current profiler intolerably slow; ironically, though, I haven't profiled it yet.

Anyway, `Devel::DProfPP` allows you to specify callbacks to be run every time the profiling data shows Perl entering or exiting a subroutine, and provides access to the same timing and call stack information used by *dprofpp*.

So, for instance, I like visualization of complicated data. I'd prefer to see what's calling what as a graph that I can print out and pore over, rather than as a listing. So, I pull together `Devel::DProfPP` and the trusty [`Graphviz`](https://metacpan.org/pod/GraphViz) module, and create my own profiler:

     use GraphViz;
     use Devel::DProfPP;
     
     my $graph = GraphViz->new();
     my %edges = ();
     Devel::DProfPP->new(enter => sub {
         my $pp = shift;
         my @stack = $pp->stack;
         my $to = $stack[-1]->sub_name;
         my $from = @stack > 1 ? $stack[-2]->sub_name : "MAIN BODY";
         $graph->add_edge($from => $to) unless $edges{$from." -> ".$to}++;
     })->parse;
     
     print $graph->as_png;

Every time we enter a subroutine, we look at the call stack so far. We pick the top frame of the stack, and ask for its subroutine name. If there's another subroutine on the stack, we take that off too; otherwise we're being called from the main body of the code. Then we add an edge on our graph between the two subroutines, unless we've already got one. Finally, we print out the graph as a PNG file for me to print out and stick on the wall.

There are any number of other things you can do with `Devel::DProfPP` if the ordinary profiler doesn't suit your needs for some reason; but as we've seen, just judicious application of profiling and highlighting hotspots in your code can cut the running time of a long-running Perl program by 50% or so, and can also help you to understand what your code is spending all its time doing.
