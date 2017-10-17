{
   "description" : " Andy Duncan is the co-author of Perl for Oracle DBAs. My coauthor, Jared Still, and I had the task of writing a book, Perl for Oracle DBAs, about two of our favorite subjects, Perl and Oracle. Our goal was...",
   "slug" : "/pub/2002/09/04/perlfororacle.html",
   "draft" : null,
   "authors" : [
      "andy-duncan"
   ],
   "date" : "2002-09-04T00:00:00-08:00",
   "categories" : "data",
   "title" : "The Fusion of Perl and Oracle",
   "image" : null,
   "tags" : [
      "oracle",
      "oracle-dba",
      "perl"
   ],
   "thumbnail" : "/images/_pub_2002_09_04_perlfororacle/111-oracleperl.gif"
}



*Andy Duncan is the co-author of [Perl for Oracle DBAs](http://www.oreilly.com/catalog/oracleperl/).*

My coauthor, Jared Still, and I had the task of writing a book, *Perl for Oracle DBAs*, about two of our favorite subjects, Perl and Oracle. Our goal was to link Perl and ready-canned Perl applications to the job of making an Oracle DBA's life both easier and better. Besides covering the entire spread of Perl, and in particular, relating the examination and control of Oracle databases, we also created a wide-ranging, open source Perl Toolkit for Oracle DBAs. The toolkit contains all the Perl scripts we've used as DBAs for the past decade, wrapped up into a single, object-oriented project for both Unix and Win32, and which forms the heart of our book. We've also included a comprehensive guide to all of the Perl Oracle DBA tools already out there, including Orac, Oracletool, DDL::Oracle, StatsView, Senora, Apache::OWA, and many more.

I thought that in this article, we'd go beyond our passionate and committed belief that Perl is simply the finest scripting language ever invented for helping Oracle DBAs in their daily working lives, and question just why Perl possesses such a good symbiosis with the Oracle database. We'll also try to explain how the answers to this question helped us construct our Perl DBA Toolkit.

### Objectivism

At first glance, Perl and Oracle seem like strange bedfellows, so how can they be linked so well to each other? We think there's is perhaps even a philosophical link stretching between Perl and Oracle, all the way back to Aristotle and Athens, the first state in the world to champion the rights of the individual. This link, we believe, is "Objectivism." This most modern of philosophies was created by Ayn Rand, an escapee of 1920s Leningrad, who is more famous as the author of *Atlas Shrugged*. It remains perhaps one of the most influential books of the past 100 years, in the same league as *Brave New World*, *Animal Farm*, and *1984*; it is also the fictional representation of Objectivism.

Ayn Rand's ideas form a philosophy in defense of the individual and his or her rights, which spring principally from an individual's right to life, and the pursuit of his or her own happiness, within the rule of law. To demonstrate this, in a dramatic sense, Ayn Rand's books portrayed what she later called "Ideal" men. In one of her earlier books, *The Fountainhead*, Ayn Rand's hero was Howard Roark, a maverick architect, and the best of his generation, who insists on clean, simple, and strong design. Virtually everyone else is stuck in ornament and the nineteenth century, whereas Roark creates great soaring towers of glass and steel that take one's breath away. Although Roark often takes payment and credit, he is so dedicated to his craft that he often misses out on both, handing them on to other, lesser architects just so he can see his bold designs completed.

Roll the clock forward 50 years, and if Ayn Rand were to write *The Fountainhead* now, it would be surprising if she didn't replace her building architect with a computer language architect, perhaps someone like Larry Wall. Howard Roark's architecture brings joy to millions of ordinary, hard-working people. In the same way, Perl has increased the productivity and creative expression of Oracle DBAs and system administrators everywhere because it is so deliberately tailored toward the individual. It is all things to all people, and you can blend it with any architecture to create exactly the software you want. You are limited only by your system administrator's disk quota for DBA users. Similarly, with our toolkit, we have tried to keep it free from adornment and left it highly configurable for your own individual needs. We've also tried to aid the construction of further solutions, and keep this as simple as possible by providing ready-built modules that you can plug right into your own designs and interfaces. Our main architectural modules are summarized below, in Table 1.

#### Table 1. Main PDBA Toolkit Supporting Modules

| Module             | Description                                                                                                                      |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------|
| `PDBA::CM`         | Connection manager that simplifies Perl-to-Oracle connectivity.                                                                  |
| `PDBA::ConfigFile` | Finds and opens configuration files.                                                                                             |
| `PDBA::ConfigLoad` | Finds, opens, parses, and loads configuration files into memory.                                                                 |
| `PDBA::DBA`        | Designed for DBA-specific tasks; many methods are data- dictionary related.                                                      |
| `PDBA::Daemon`     | Runs Perl script daemons on Unix.                                                                                                |
| `Win32::Daemon`    | This module, by Dave Roth, is included (with permission) because it is so important to toolkit daemon services on Win32 systems. |
| `PDBA::GQ`         | Generic Query module that simplifies single tables queries.                                                                      |
| `PDBA::LogFile`    | Creates and locks log files; used by many scripts in the toolkit to perform logging actions.                                     |
| `PDBA::OPT`        | Processes command line arguments unhandled by calling scripts.                                                                   |
| `PDBA::PWC`        | Password client module.                                                                                                          |
| `PDBA::PWD`        | Password server module.                                                                                                          |
| `PDBA::PWDNT`      | Password server modules for Win32.                                                                                               |
| `PDBA::PidFile`    | Used to control script execution.                                                                                                |
| `PDBA`             | Modular collection of widely used methods.                                                                                       |

With architecture, as with Perl, what you see is what you get, and it is impossible to hide steel and glass constructions from rival architects. However, your inspiration and artistic ability are your own, and it is your signature at the bottom of the blueprints, just as it is Larry Wall's copyright name on the Perl Artistic License. So if Larry Wall is an "Ideal" man in Ayn Rand's Objectivist mold, what about the other Larry in our story, Mr. Ellison of Redwood Shores?

### Proprietary Technology

In *Atlas Shrugged* one of the main "Ideal" men is Hank Rearden. Using his own capital, determination, and research ability, Hank Rearden creates a proprietary super-strength metal, of which the whole world is unable to get enough. It is used in fast trains, speeding bullets, and tall buildings. This entirely new metal is cheaper, lighter, and stronger than any other known type of steel or alloy; Rearden Metal is a product that transforms the world. Once again, rolling forward a couple of generations and modernizing the names, if Ayn Rand were to replace the key productive technology of 1950s America with that of early twenty-first century America, she would probably choose to write about databases. Her hero, Larry Rearden, would be a rugged individualist running a database corporation that creates cutting-edge products used throughout the world in a thousand different industries. Remind you of anyone?

We think Oracle and Perl work together so well because they were both created by incredible individuals for other individual businesses, individual Oracle DBAs, and individual Perl programmers. With both there are no imposed limits, and just as much help as you might need, from either [Oracle support](http://technet.oracle.com), or the worldwide [Perl community](http://www.perl.com). And of course, *Perl for Oracle DBAs*.

### The Perl DBA Toolkit

To take advantage of this synergy between Perl and Oracle in our toolkit, we've blended the two streams together into four key DBA areas. These are password serving, the performance of routine DBA tasks, the monitoring of the database, and the building of a database repository for informational time-traveling.

The completed Perl DBA Toolkit scripts described below in Table 2 allow it to work securely around a network without clear passwords being passed around, thereby enabling you to have one toolkit point of control for all of your databases, no matter where they're located.

#### Table 2. Password serving

| Script           | Description                                                                                                                                       |
|------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `pwd.pl`         | Password server daemon that encrypts passwords via a TCP socket; works remotely with the other Perl scripts via the toolkit module set.           |
| `pwc.pl`         | Client that remotely retrieves encrypted passwords from the password server, easing the secure database access overhead imposed by other scripts. |
| `pwd_service.pl` | Installs the password server as a daemon (on Unix) or service (on Win32).                                                                         |

The scripts in Table 3 perform a wide variety of DBA tasks, including the creation of new users from the command line, the creation of new users via duplicated accounts, and the creation of multiple accounts with automatically mailed passwords. They also cover the maintenance of indexes, the killing of sniped database sessions, the management of extent usage, and the extraction of DDL and data for SQL\*Loader transfer.

#### Table 3. Routine database administration

| Script           | Description                                                                                                                                                                                                                                                                                                  |
|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ddl_oracle.pl`  | Generates the DDL necessary to recreate schemas, tables, indexes, views, PL/SQL, materialized views, and other objects.                                                                                                                                                                                      |
| `sqlunldr.pl`    | Dumps entire schemas to comma-delimited files and generates the SQL\*Loader scripts necessary to reload them. Also dumps LONG RAW and BLOB objects, converting them to hex format via the Oracle HEX\_TO\_RAW function in the SQL\*Loader control file in order to convert the data back into binary format. |
| `create_user.pl` | Creates Oracle users from the command line. You can create a user and assign passwords, tablespaces, and privileges, all with one easy command-line call. Best of all, you can use this script to pre-configure different groups of runtime privileges.                                                      |
| `drop_user.pl`   | Drops a database user by first dropping all of their tables and indexes before dropping the account. Doing so avoids most of the resource- intensive SQL recursion incurred when dropping an account containing many tables and indexes.                                                                     |
| `dup_user.pl`    | Duplicates an account, with the source user's system privileges, object privileges, roles, and quotas assigned directly to the target user.                                                                                                                                                                  |
| `mucr8.pl`       | When creating a large number of users, this utility creates them all with a single operation. Configurable permissions are granted, and the passwords automatically generated get emailed back to the new account owners.                                                                                    |
| `kss.pl`         | Kills sniped sessions (which are lapsed sessions on busy databases consuming unnecessary memory resource).                                                                                                                                                                                                   |
| `kss_NT.pl`      | Win32 version of kss.pl.                                                                                                                                                                                                                                                                                     |
| `kss_service.pl` | Used to create an appropriate snipe killing service on Win32.                                                                                                                                                                                                                                                |
| `idxr.pl`        | Determines if an index should be rebuilt and, if so, rebuilds it. Checks on a per-schema basis, and is configured to check indexes based on days since the index was last analyzed. A configurable time limit is imposed, which allows index rebuilds to fit within a predefined time schedule.              |
| `maxext.pl`      | Monitors the size and number of extents in tables and indexes. If they're nearing a maximum allowed or if the object will be unable to extend because of limited free space, it notifies the DBA. This script is most useful for databases that use dictionary-managed extents.                              |

Table 4 lists our remote monitoring scripts, which help to maximize the availability of your databases by alerting you to both error conditions reported in the Oracle alert log and to problems with database connectivity. Some of them can even phone you up.

#### Table 4. Database monitoring

| Script                | Description                                                                                                                                                                                                                                      |
|-----------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `chkalert.pl`         | Daemon that monitors Oracle alert logs for error conditions and notifies the DBA via either email messages or pager calls. Oracle's alert.log files contain important error messages as well as a log of database startup and shutdown messages. |
| `chkalert_NT.pl`      | Win32 version of chkalert.pl.                                                                                                                                                                                                                    |
| `chkalert_service.pl` | Utility script that creates a Win32 service for chkalert\_NT.pl.                                                                                                                                                                                 |
| `dbup.pl`             | Working alongside chkalert.pl, a highly configurable database connectivity monitor that checks to see if databases are up and available.                                                                                                         |
| `dbup_NT.pl`          | Win32 version of dbup.pl.                                                                                                                                                                                                                        |
| `dbup_service.pl`     | Creates the Win32 service for dbup\_NT.pl.                                                                                                                                                                                                       |
| `dbignore.pl`         | Utility script used with dbup.pl to temporarily disable connectivity checks on an individual database (e.g., while maintenance is being performed).                                                                                              |

Table 5 summarizes what we've called repository scripts. These compare different database schema versions over time, detecting database changes (official or otherwise). They also store SQL execution plans within a library cache to allow comparison between current execution plans and plans previously collected; this way, the scripts can report on changed execution plans and the reasons behind the changes.

#### Table 5. Repository and DDL "time travel"

| Script        | Description                                                                                                                                                                                        |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `baseline.pl` | Creates the baseline for the PDBA repository, establishes "time travel" control of DDL (Data Definition Language), and stores the entire database structural change record across time boundaries. |
| `spdrvr.pl`   | Perl driver for SQL\*Plus that reports on information created by baseline.pl.                                                                                                                      |
| `sxp.pl`      | Collects and stores SQL statements from the data dictionary and generates accompanying execution plans for later comparison with other plans.                                                      |
| `sxpcmp.pl`   | Examines the current SQL statements, generating execution plans.                                                                                                                                   |
| `sxprpt.pl`   | Generates reports based on the stored SQL and execution plans.                                                                                                                                     |

### Perl Philosophy

There is something else that makes Perl different from other computer languages, which may move it closer towards the rugged individualists of American business; it has three major philosophical virtues. And so does Objectivism. Coincidence? I'll leave it to you to decide whether the two sets of virtues below are in any way related:

The three great virtues of the Perl programmer, as originally defined by Larry Wall, are: Laziness, the quality that makes you write labor-saving programs to increase productivity; Impatience, the injustice you feel when applications are inefficient, which makes you write clever programs to anticipate your needs, and Hubris, the pride that makes you create great solutions, which others will say only good things about.

The three cardinal virtues of Objectivist ethics are: *Purpose*, the recognition that productive work is how man's mind sustains his life; *Reason*, the use of rationality as the only guide to considered action and wealth creation, and *Self-Esteem*, the recognition that as man is a being of self-made wealth, it is this route through which he can acquire the pride of the self-made soul.

Ayn Rand's life works were about wealth creation, and the individual. However they were not just about money. They were also about any form of wealth or ideas creation, where wealth is the product of one person's mind. And with the Perl Artistic License copyright, it is clear the wealth of Perl was created and is owned by Larry Wall. Although he decides to give it away, this is entirely his right. Perl even possesses its own culture of freedom, reflected in the Perl catch phrase TMTOWTDI--There's More Than One Way To Do It-- and its own free-trade area, the Comprehensive Perl Archive Network, or [CPAN](http://www.cpan.org). This is where thousands of worldwide Perl developers swap modules, in exchange for respect from the rest of Perl society. Indeed, the respect that Larry Wall has duly earned is priceless. He may remain unable to buy MiG jets with it, but it still makes him a major keynote speaker at technology conferences, just like our other shrugging Atlas in this article, Larry Ellison.

In following this established Perl philosophy, we've created our toolkit as an entirely open source project. We'll wait and see how it develops, but we're looking forward to your comments and suggestions on how it can be further improved to meet your own specialized requirements; we're hoping it will match the runaway success of Steve Feuerstein's [utPLSQL project](http://oracle.oreilly.com/utplsql/).

### The Sign of the Dollar

The Two Larrys are both free men of the mind who live on two sides of the same coin. They have created between them two of the world's great American productive inventions, Perl and Oracle, which work well together because they arise from the same intellectual substrate. Without the pioneering work of both Wall and Ellison, the world would be both spiritually and materially poorer. And here's a final thought. For those who've read *Atlas Shrugged*, you'll know the basic value symbol of the free men of the mind; it was a golden dollar symbol. And by a bizarre twist in our tale, every Perl script ever written is full of basic value variables, each preceded by a dollar symbol. Another coincidence? Possibly. But more bizarrely, if you take a vinyl copy of John Lennon's 1970s anthem, "Imagine," and play it backward, it says "Perl for Oracle DBAs." No kidding.

(If you'd like to learn more about Ayn Rand's work, check out this [Web site](http://www.aynrand.org/).)
