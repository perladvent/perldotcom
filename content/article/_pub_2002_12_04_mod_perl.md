{
   "title" : "Improving mod_perl Sites' Performance: Part 5",
   "authors" : [
      "stas-bekman"
   ],
   "categories" : "web",
   "date" : "2002-12-04T00:00:00-08:00",
   "image" : null,
   "thumbnail" : null,
   "description" : "Sharing Memory As we have learned in the previous article, sharing memory helps us save memory with mod_perl, giving us a huge speed increase; but we pay the price with a big memory footprint. I presented a few techniques to...",
   "draft" : null,
   "slug" : "/pub/2002/12/04/mod_perl.html",
   "tags" : [
      "mod-perl-shared-memory"
   ]
}



### <span id="sharing_memory">Sharing Memory</span>

As we have learned in the previous article, sharing memory helps us save memory with mod\_perl, giving us a huge speed increase; but we pay the price with a big memory footprint. I presented a few techniques to save memory by trying to share more of it. In this article, we will see other techniques allowing you to save even more memory.

### <span id="preloading_registry_scripts_at_server_startup">Preloading Registry Scripts at Server Startup</span>

What happens if you find yourself stuck with Perl CGI scripts and you cannot or don't want to move most of the stuff into modules to benefit from modules preloading, so the code will be shared by the children? Luckily, you can preload scripts as well. This time the `Apache::RegistryLoader` module comes to your aid. `Apache::RegistryLoader` compiles `Apache::Registry` scripts at server startup.

For example, to preload the script */perl/test.pl*, which is in fact the file */home/httpd/perl/test.pl*, you would do the following:

      use Apache::RegistryLoader ();
      Apache::RegistryLoader->new->handler("/perl/test.pl",
                                "/home/httpd/perl/test.pl");

You should put this code either into a `<Perl>` section or into a startup script.

But what if you have a bunch of scripts located under the same directory and you don't want to list them one by one? Take the benefit of Perl modules and put them to good use - the `File::Find` module will do most of the work for you.

The following code walks the directory tree under which all `Apache::Registry` scripts are located. For each file it encounters with the extension *.pl*, it calls the `Apache::RegistryLoader::handler()` method to preload the script in the parent server, before pre-forking the child processes:

      use File::Find qw(finddepth);
      use Apache::RegistryLoader ();
      {
        my $scripts_root_dir = "/home/httpd/perl/";
        my $rl = Apache::RegistryLoader->new;
        finddepth
          (
           sub {
             return unless /\.pl$/;
             my $url = "$File::Find::dir/$_";
             $url =~ s|$scripts_root_dir/?|/|;
             warn "pre-loading $url\n";
               # preload $url
             my $status = $rl->handler($url);
             unless($status == 200) {
               warn "pre-load of `$url' failed, status=$status\n";
             }
           },
           $scripts_root_dir);
      }

Note that I didn't use the second argument to `handler()` here, as in the first example. To make the loader smarter about the URI to filename translation, you might need to provide a `trans()` function to translate the URI to a filename. URI to filename translation normally doesn't happen until HTTP request time, so the module is forced to roll its own translation. If the filename is omitted and a `trans()` function was not defined, then the loader will try using the URI relative to **ServerRoot**.

A simple `trans()` function can be like this:

      sub mytrans {
        my $uri = shift;
        $uri =~ s|^/perl/|/home/httpd/perl/|;
        return $uri;
      }

You can easily derive the right translation by looking at the `Alias` directive. The above `mytrans()` function is matching our `Alias`:

      Alias /perl/ /home/httpd/perl/

After defining the URI to filename translation function, you should pass it during the creation of the `Apache::RegistryLoader` object:

      my $rl = Apache::RegistryLoader->new(trans => \&mytrans);

I won't show any benchmarks here, since the effect is absolutely the same as with preloading modules.

### <span id="modules_initializing_at_server_startup">Modules Initializing at Server Startup</span>

We have just learned that it's important to preload the modules and scripts at the server startup. It turns out that it's not enough for some modules and you have to prerun their initialization code to get more memory pages shared. Basically you will find an information about specific modules in their respective manpages. I will present a few examples of widely used modules where the code can be initialized.

#### <span id="initializing_dbi.pm">Initializing DBI.pm</span>

The first example is the `DBI` module. As you know, `DBI` works with many database drivers in the `DBD::` namespace, such as `DBD::mysql`. It's not enough to preload `DBI`; you should initialize `DBI` with the `driver(s)` that you are going to use (usually a single driver is used) if you want to minimize memory use after forking the child processes. Note that you want to do this under mod\_perl and other environments where shared memory is important. In other circumstances, you shouldn't initialize drivers.

You probably know already that under mod\_perl you should use the `Apache::DBI` module to make the connection persistent, unless you want to open a separate connection for each user -- in which case, you should not use this module. `Apache::DBI` automatically loads `DBI` and overrides some of its methods, so you should continue coding just as though you were simply using the `DBI` module.

Just as with modules preloading, our goal is to find the startup environment that will lead to the smallest \`\`difference'' between the shared and normal memory reported, which would mean a smaller total memory usage.

And again, in order to make it easy to measure, I will use only one child process. To do this, I will use these settings in *httpd.conf*:

      MinSpareServers 1
      MaxSpareServers 1
      StartServers 1
      MaxClients 1
      MaxRequestsPerChild 100

I'm going to run memory benchmarks on five different versions of the *startup.pl* file. I always preload these modules:

      use Gtop();
      use Apache::DBI(); # preloads DBI as well

**<span id="item_option">option 1</span>**   
Leave the file unmodified.

**option 2**   
Install MySQL driver (I will use MySQL RDBMS for our test):

      DBI->install_driver("mysql");

It's safe to use this method, since just like with `use()`, if it can't be installed it'll `die()`.

**option 3**   
Preload MySQL driver module:

      use DBD::mysql;

**option 4**   
Tell `Apache::DBI` to connect to the database when the child process starts (`ChildInitHandler`) - no driver is preloaded before the child gets spawned!

      Apache::DBI->connect_on_init('DBI:mysql:test::localhost',
                                 "",
                                 "",
                                 {
                                  PrintError => 1, # warn() on errors
                                  RaiseError => 0, # don't die on error
                                  AutoCommit => 1, # commit executes
                                  # immediately
                                 }
                                )
      or die "Cannot connect to database: $DBI::errstr";

Here is the `Apache::Registry` test script that I have used:

      preload_dbi.pl
      --------------
      use strict;
      use GTop ();
      use DBI ();
        
      my $dbh = DBI->connect("DBI:mysql:test::localhost",
                             "",
                             "",
                             {
                              PrintError => 1, # warn() on errors
                              RaiseError => 0, # don't die on error
                              AutoCommit => 1, # commit executes
                                               # immediately
                             }
                            )
        or die "Cannot connect to database: $DBI::errstr";
      
      my $r = shift;
      $r->send_http_header('text/plain');
      
      my $do_sql = "show tables";
      my $sth = $dbh->prepare($do_sql);
      $sth->execute();
      my @data = ();
      while (my @row = $sth->fetchrow_array){
        push @data, @row;
      }
      print "Data: @data\n";
      $dbh->disconnect(); # NOP under Apache::DBI
      
      my $proc_mem = GTop->new->proc_mem($$);
      my $size  = $proc_mem->size;
      my $share = $proc_mem->share;
      my $diff  = $size - $share;
      printf "%8s %8s %8s\n", qw(Size Shared Diff);
      printf "%8d %8d %8d (bytes)\n",$size,$share,$diff;

The script opens a connection to the database *'test'* and issues a query to learn what tables the databases has. When the data is collected and printed the connection would be closed in the regular case, but `Apache::DBI` overrides it with empty method. When the data is processed, some code to print the memory usage follows -- this should already be familiar to you.

The server was restarted before each new test.

So here are the results of the five tests that were conducted, sorted by the *Diff* column:

1.  After the first request:

          Version     Size   Shared     Diff        Test type
          --------------------------------------------------------------------
                1  3465216  2621440   843776  install_driver
                2  3461120  2609152   851968  install_driver & connect_on_init
                3  3465216  2605056   860160  preload driver
                4  3461120  2494464   966656  nothing added
                5  3461120  2482176   978944  connect_on_init

2.  After the second request (all the subsequent request showed the same results):

          Version     Size   Shared    Diff         Test type
          --------------------------------------------------------------------
                1  3469312  2609152   860160  install_driver
                2  3481600  2605056   876544  install_driver & connect_on_init
                3  3469312  2588672   880640  preload driver
                4  3477504  2482176   995328  nothing added
                5  3481600  2469888  1011712  connect_on_init

Now what do we conclude from looking at these numbers. First, we see that only after a second reload do we get the final memory footprint for a specific request in question (if you pass different arguments the memory usage might and will be different).

But both tables show the same pattern of memory usage. We can clearly see that the real winner is the *startup.pl* file's version where the MySQL driver was installed (1). Since we want to have a connection ready for the first request made to the freshly spawned child process, we generally use the second version (2), which uses somewhat more memory, but has almost the same number of shared memory pages. The third version only preloads the driver, resulting in smaller shared memory. The last two versions having nothing initialized (4) and having only the `connect_on_init()` method used (5). The former is a little bit better than the latter, but both significantly worse than the first two versions.

To remind you why do we look for the smallest value in the column *diff*, recall the real memory usage formula:

      RAM_dedicated_to_mod_perl = diff * number_of_processes
                                + the_processes_with_largest_shared_memory

Notice that the smaller the diff is, the bigger the number of processes you can have using the same amount of RAM. Therefore, every 100K difference counts, when you multiply it by the number of processes. If we take the number from the version (1) vs. (4) and assume that we have 256M of memory dedicated to mod\_perl processes, we will get the following numbers using the formula derived from the above formula:

                   RAM - largest_shared_size
      N_of Procs = -------------------------
                            Diff

                    268435456 - 2609152
      (ver 1)  N =  ------------------- = 309
                          860160

                    268435456 - 2469888
      (ver 5)  N =  ------------------- = 262
                         1011712

So you can see the difference - 17 percent more child processes in the first version.

#### <span id="initializing_cgi.pm">Initializing CGI.pm</span>

`CGI.pm` is a big module that by default postpones the compilation of its methods until they are actually needed, thus making it possible to use it under a slow mod\_cgi handler without adding a big overhead. That's not what we want under mod\_perl, and if you use `CGI.pm` you should precompile the methods that you are going to use at the server startup in addition to preloading the module. Use the compile method for that:

      use CGI;
      CGI->compile(':all');

where you should replace the tag group `:all` with the real tags and group tags that you are going to use if you want to optimize the memory usage.

I'm going to compare the shared memory footprint by using a script that is backward compatible with mod\_cgi. You will see that you can improve the performance of these kind of scripts as well, but if you really want a fast code think about porting it to use `Apache::Request` for the CGI interface, and some other module for HTML generation.

So here is the `Apache::Registry` script that I'm going to use to make the comparison:

      preload_cgi_pm.pl
      -----------------
      use strict;
      use CGI ();
      use GTop ();

      my $q = new CGI;
      print $q->header('text/plain');
      print join "\n", map {"$_ => ".$q->param($_) } $q->param;
      print "\n";
      
      my $proc_mem = GTop->new->proc_mem($$);
      my $size  = $proc_mem->size;
      my $share = $proc_mem->share;
      my $diff  = $size - $share;
      printf "%8s %8s %8s\n", qw(Size Shared Diff);
      printf "%8d %8d %8d (bytes)\n",$size,$share,$diff;

The script initializes the `CGI` object, sends a HTTP header and then prints all the arguments and values that were passed to the script if there were any. As usual, at the end, I print the memory usage.

As usual, I am going to use a single child process, using the usual settings in *httpd.conf*:

      MinSpareServers 1
      MaxSpareServers 1
      StartServers 1
      MaxClients 1
      MaxRequestsPerChild 100

I'm going to run memory benchmarks on three different versions of the *startup.pl* file. I always preload this module:

      use Gtop();

**option 1**   
Leave the file unmodified.

**option 2**   
Preload `CGI.pm`:

      use CGI ();

**option 3**   
Preload `CGI.pm` and pre-compile the methods that I'm going to use in the script:

      use CGI ();
      CGI->compile(qw(header param));

The server was restarted before each new test.

So here are the results of the three tests that were conducted, sorted by the *Diff* column:

1.  After the first request:

          Version     Size   Shared     Diff        Test type
          --------------------------------------------------------------------
                1  3321856  2146304  1175552  not preloaded
                2  3321856  2326528   995328  preloaded
                3  3244032  2465792   778240  preloaded & methods+compiled

2.  After the second request (all the subsequent request showed the same results):

          Version     Size   Shared    Diff         Test type
          --------------------------------------------------------------------
                1  3325952  2134016  1191936 not preloaded
                2  3325952  2314240  1011712 preloaded
                3  3248128  2445312   802816 preloaded & methods+compiled

The first version shows the results of the script execution when `CGI.pm` wasn't preloaded. The second version has the module preloaded. The third is when it's both preloaded and the methods that are going to be used are precompiled at the server startup.

By looking at version one of the second table, we can conclude that preloading adds about 20K to the shared size. As I have mentioned at the beginning of this section, that's how `CGI.pm` was implemented -- to reduce the load overhead. This means that preloading CGI almost hardly changes anything. But if we compare the second and the third versions, then we will see a significant difference of 207K (1011712-802816), and I have only used a few methods (the *header* method loads a few more methods transparently for a user). Imagine how much memory I'm going to save if I'm going to precompile all the methods that I'm using in other scripts that use `CGI.pm` and do a little bit more than the script that I have used in the test.

But even in our simple case using the same formula, what do we see? (assuming that I have 256MB dedicated for mod\_perl)

                   RAM - largest_shared_size
      N_of Procs = -------------------------
                            Diff
                            
                    268435456 - 2134016
      (ver 1)  N =  ------------------- = 223
                          1191936
                          
                    268435456 - 2445312
      (ver 3)  N =  ------------------- = 331
                         802816

If I preload `CGI.pm` and precompile a few methods that I use in the test script, I can have 50 percent more child processes than when I don't preload and precompile the methods that I am going to use.

I've heard that the 3.x generation of `CGI.pm` will be less bloated, but it's in a beta state as of this writing.

### <span id="increasing_shared_memory_with_mergemem">Increasing Shared Memory With mergemem</span>

`mergemem` is an experimental utility for linux, which looks *very* interesting for us mod\_perl users: <http://www.complang.tuwien.ac.at/ulrich/mergemem/>

It looks like it could be run periodically on your server to find and merge duplicate pages. It won't halt your httpds during the merge, this aspect has been taken into consideration already during the design of mergemem: Merging is not performed with one big system call. Instead most operation is in userspace, making a lot of small system calls.

Therefore, blocking of the system should not happen. And, if it really should turn out to take too much time you can reduce the priority of the process.

The worst case that can happen is this: `mergemem` merges two pages and immediately afterward, they will be split. The split costs about the same as the time consumed by merging.

This software comes with a utility called `memcmp` to tell you how much you might save.

### <span id="references">References</span>

-   The mod\_perl site's URL: <http://perl.apache.org/>
-   mergemem project <http://www.complang.tuwien.ac.at/ulrich/mergemem/>

