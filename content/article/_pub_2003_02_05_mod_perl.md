{
   "title" : "Improving mod_perl Sites' Performance: Part 7",
   "tags" : [
      "mod-perl-apache-performance"
   ],
   "categories" : "web",
   "date" : "2003-02-05T00:00:00-08:00",
   "slug" : "/pub/2003/02/05/mod_perl",
   "description" : " Correct configuration of the MinSpareServers, MaxSpareServers, StartServers, MaxClients, and MaxRequestsPerChild parameters is very important. There are no defaults. If they are too low, then you will underutilize the system's capabilities. If they are too high, then chances are that...",
   "image" : null,
   "authors" : [
      "stas-bekman"
   ],
   "thumbnail" : null,
   "draft" : null
}





Correct configuration of the `MinSpareServers`, `MaxSpareServers`,
`StartServers`, `MaxClients`, and `MaxRequestsPerChild` parameters is
very important. There are no defaults. If they are too low, then you
will underutilize the system's capabilities. If they are too high, then
chances are that the server will bring the machine to its knees.

All the above parameters should be specified on the basis of the
resources you have. With a plain Apache server, it's no big deal if you
run many servers since the processes are about 1Mb and don't eat a lot
of your RAM. Generally, the numbers are even smaller with memory
sharing. The situation is different with mod\_perl. I have seen
mod\_perl processes of 20Mb and more. Now, if you have `MaxClients` set
to 50, then 50x20Mb = 1Gb. Maybe you don't have 1Gb of RAM - so how do
you tune the parameters? Generally, by trying different combinations and
benchmarking the server. Again, mod\_perl processes can be made much
smaller when memory is shared.

Before you start this task, you should be armed with the proper weapon.
You need the **crashme** utility, which will load your server with the
mod\_perl scripts you possess. You need it to have the ability to
emulate a multiuser environment and to emulate the behavior of multiple
clients calling the mod\_perl scripts on your server simultaneously.
While there are commercial solutions, you can get away with free ones
that do the same job. You can use the ApacheBench utility that comes
with the Apache distribution, the `crashme` script which uses
`LWP::Parallel::UserAgent`, httperf or http\_load all discussed in one
of the previous articles.

It is important to make sure that you run the load generator (the client
which generates the test requests) on a system that is more powerful
than the system being tested. After all, we are trying to simulate
Internet users, where many users are trying to reach your service at
once. Since the number of concurrent users can be quite large, your
testing machine must be very powerful and capable of generating a heavy
load. Of course, you should not run the clients and the server on the
same machine. If you do, then your test results would be invalid.
Clients will eat CPU and memory that should be dedicated to the server,
and vice versa.

### [Configuration Tuning with ApacheBench]{#configuration_tuning_with_apachebench}

I'm going to use the `ApacheBench` (`ab`) utility to tune our server's
configuration. We will simulate 10 users concurrently requesting a very
light script at `http://www.example.com/perl/access/access.cgi`. Each
simulated user makes 10 requests.

      % ./ab -n 100 -c 10 http://www.example.com/perl/access/access.cgi

The results are:

      Document Path:          /perl/access/access.cgi
      Document Length:        16 bytes
      
      Concurrency Level:      10
      Time taken for tests:   1.683 seconds
      Complete requests:      100
      Failed requests:        0
      Total transferred:      16100 bytes
      HTML transferred:       1600 bytes
      Requests per second:    59.42
      Transfer rate:          9.57 kb/s received
      
      Connnection Times (ms)
                    min   avg   max
      Connect:        0    29   101
      Processing:    77   124  1259
      Total:         77   153  1360

The only numbers we really care about are:

      Complete requests:      100
      Failed requests:        0
      Requests per second:    59.42

Let's raise the request load to 100 x 10 (10 users, each making 100
requests):

      % ./ab -n 1000 -c 10  http://www.example.com/perl/access/access.cgi
      Concurrency Level:      10
      Complete requests:      1000
      Failed requests:        0
      Requests per second:    139.76

As expected, nothing changes -- we have the same 10 concurrent users.
Now let's raise the number of concurrent users to 50:

      % ./ab -n 1000 -c 50  http://www.example.com/perl/access/access.cgi
      Complete requests:      1000
      Failed requests:        0
      Requests per second:    133.01

We see that the server is capable of serving 50 concurrent users at 133
requests per second! Let's find the upper limit. Using
`-n 10000 -c 1000` failed to get results (Broken Pipe?). Using
`-n 10000 -c 500` resulted in 94.82 requests per second. The server's
performance went down with the high load.

The above tests were performed with the following configuration:

      MinSpareServers 8
      MaxSpareServers 6
      StartServers 10
      MaxClients 50
      MaxRequestsPerChild 1500

Now let's kill each child after it serves a single request. We will use
the following configuration:

      MinSpareServers 8
      MaxSpareServers 6
      StartServers 10
      MaxClients 100
      MaxRequestsPerChild 1

Simulate 50 users each generating a total of 20 requests:

      % ./ab -n 1000 -c 50  http://www.example.com/perl/access/access.cgi

The benchmark timed out with the above configuration. I watched the
output of **`ps`** as I ran it, the parent process just wasn't capable
of respawning the killed children at that rate. When I raised the
`MaxRequestsPerChild` to 10, I got 8.34 requests per second. Very bad -
18 times slower! You can't benchmark the importance of the
`MinSpareServers`, `MaxSpareServers` and `StartServers` with this type
of test.

Now let's reset `MaxRequestsPerChild` to 1500, but reduce `MaxClients`
to 10 and run the same test:

      MinSpareServers 8
      MaxSpareServers 6
      StartServers 10
      MaxClients 10
      MaxRequestsPerChild 1500

I got 27.12 requests per second, which is better but still four to five
times slower. (I got 133 with `MaxClients` set to 50.)

**Summary:** I have tested a few combinations of the server
configuration variables (`MinSpareServers`, `MaxSpareServers`,
`StartServers`, `MaxClients` and `MaxRequestsPerChild`). The results I
got are as follows:

`MinSpareServers`, `MaxSpareServers` and `StartServers` are only
important for user response times. Sometimes users will have to wait a
bit.

The important parameters are `MaxClients` and `MaxRequestsPerChild`.
`MaxClients` should be not too big, so it will not abuse your machine's
memory resources, and not too small, for if it is, your users will be
forced to wait for the children to become free to serve them.
`MaxRequestsPerChild` should be as large as possible, to get the full
benefit of mod\_perl, but watch your server at the beginning to make
sure your scripts are not leaking memory, thereby causing your server
(and your service) to die very fast.

Also, it is important to understand that we didn't test the response
times in the tests above, but the ability of the server to respond under
a heavy load of requests. If the test script was heavier, then the
numbers would be different but the conclusions similar.

The benchmarks were run with:

-   HW: RS6000, 1Gb RAM
-   SW: AIX 4.1.5 . mod\_perl 1.16, apache 1.3.3
-   Machine running only mysql, httpd docs and mod\_perl servers.
-   Machine was \_completely\_ unloaded during the benchmarking.

After each server restart when I changed the server's configuration, I
made sure that the scripts were preloaded by fetching a script at least
once for every child.

It is important to notice that none of the requests timed out, even if
it was kept in the server's queue for more than a minute! That is the
way **ab** works, which is OK for testing purposes but will be
unacceptable in the real world - users will not wait for more than five
to 10 seconds for a request to complete, and the client (i.e. the
browser) will time out in a few minutes.

Now let's take a look at some real code whose execution time is more
than a few milliseconds. We will do some real testing and collect the
data into tables for easier viewing.

I will use the following abbreviations:

      NR    = Total Number of Request
      NC    = Concurrency
      MC    = MaxClients
      MRPC  = MaxRequestsPerChild
      RPS   = Requests per second

Running a mod\_perl script with lots of mysql queries (the script under
test is mysqld limited)
(http://www.example.com/perl/access/access.cgi?do\_sub=query\_form),
with the configuration:

      MinSpareServers        8
      MaxSpareServers       16
      StartServers          10
      MaxClients            50
      MaxRequestsPerChild 5000

gives us:

         NR   NC    RPS     comment
      ------------------------------------------------
         10   10    3.33    # not a reliable figure
        100   10    3.94    
       1000   10    4.62    
       1000   50    4.09

**Conclusions:** Here I wanted to show that when the application is slow
(not due to perl loading, code compilation and execution, but limited by
some external operation) it almost does not matter what load we place on
the server. The RPS (Requests per second) is almost the same. Given that
all the requests have been served, you have the ability to queue the
clients, but be aware that anything that goes into the queue means a
waiting client and a client (browser) that might time out!

Now we will benchmark the same script without using the mysql (code
limited by perl only): (http://www.example.com/perl/access/access.cgi),
it's the same script but it just returns the HTML form, without making
SQL queries.

      MinSpareServers        8
      MaxSpareServers       16
      StartServers          10
      MaxClients            50
      MaxRequestsPerChild 5000

         NR   NC      RPS   comment
      ------------------------------------------------
         10   10    26.95   # not a reliable figure
        100   10    30.88   
       1000   10    29.31
       1000   50    28.01
       1000  100    29.74
      10000  200    24.92
     100000  400    24.95

**Conclusions:** This time the script we executed was pure perl (not
limited by I/O or mysql), so we see that the server serves the requests
much faster. You can see the number of requests per second is almost the
same for any load, but goes lower when the number of concurrent clients
goes beyond `MaxClients`. With 25 RPS, the machine simulating a load of
400 concurrent clients will be served in 16 seconds. To be more
realistic, assuming a maximum of 100 concurrent clients and 30 requests
per second, the client will be served in 3.5 seconds. Pretty good for a
highly loaded server.

Now we will use the server to its full capacity, by keeping all
`MaxClients` clients alive all the time and having a big
`MaxRequestsPerChild`, so that no child will be killed during the
benchmarking.

      MinSpareServers       50
      MaxSpareServers       50
      StartServers          50
      MaxClients            50
      MaxRequestsPerChild 5000
      
         NR   NC      RPS   comment
      ------------------------------------------------
        100   10    32.05
       1000   10    33.14
       1000   50    33.17
       1000  100    31.72
      10000  200    31.60

Conclusion: In this scenario, there is no overhead involving the parent
server loading new children, all the servers are available, and the only
bottleneck is contention for the CPU.

Now we will change `MaxClients` and watch the results: Let's reduce
`MaxClients` to 10.

      MinSpareServers        8
      MaxSpareServers       10
      StartServers          10
      MaxClients            10
      MaxRequestsPerChild 5000
      
         NR   NC      RPS   comment
      ------------------------------------------------
         10   10    23.87   # not a reliable figure
        100   10    32.64 
       1000   10    32.82
       1000   50    30.43
       1000  100    25.68
       1000  500    26.95
       2000  500    32.53

**Conclusions:** Very little difference! Ten servers were able to serve
almost with the same throughput as 50. Why? My guess is because of CPU
throttling. It seems that 10 servers were serving requests five times
faster than when we worked with 50 servers. In that case, each child
received its CPU time slice five times less frequently. So having a big
value for `MaxClients`, doesn't mean that the performance will be
better. You have just seen the numbers!

Now we will start drastically to reduce `MaxRequestsPerChild`:

      MinSpareServers        8
      MaxSpareServers       16
      StartServers          10
      MaxClients            50

         NR   NC    MRPC     RPS    comment
      ------------------------------------------------
        100   10      10    5.77 
        100   10       5    3.32
       1000   50      20    8.92
       1000   50      10    5.47
       1000   50       5    2.83
       1000  100      10    6.51

**Conclusions:** When we drastically reduce `MaxRequestsPerChild`, the
performance starts to become closer to plain mod\_cgi.

Here are the numbers of this run with mod\_cgi, for comparison:

      MinSpareServers        8
      MaxSpareServers       16
      StartServers          10
      MaxClients            50
      
         NR   NC    RPS     comment
      ------------------------------------------------
        100   10    1.12
       1000   50    1.14
       1000  100    1.13

**Conclusion**: mod\_cgi is much slower. :) In the first test, when
NR/NC was 100/10, mod\_cgi was capable of 1.12 requests per second. In
the same circumstances, mod\_perl was capable of 32 requests per second,
nearly 30 times faster! In the first test, each client waited about 100
seconds to be served. In the second and third tests, they waited 1,000
seconds!

### [Choosing MaxClients]{#choosing_maxclients}

The `MaxClients` directive sets the limit on the number of simultaneous
requests that can be supported. No more than this number of child server
processes will be created. To configure more than 256 clients, you must
edit the `HARD_SERVER_LIMIT` entry in `httpd.h` and recompile. In our
case, we want this variable to be as small as possible, so we can limit
the resources used by the server children. Since we can restrict each
child's process size with `Apache::SizeLimit` or `Apache::GTopLimit`,
the calculation of `MaxClients` is pretty straightforward:

                   Total RAM Dedicated to the Webserver
      MaxClients = ------------------------------------
                         MAX child's process size

So if I have 400Mb left for the Web server to run with, then I can set
`MaxClients` to be of 40 if I know that each child is limited to 10Mb of
memory (e.g. with `Apache::SizeLimit`).

You will be wondering what will happen to your server if there are more
concurrent users than `MaxClients` at any time. This situation is
signified by the following warning message in the `error_log`:

      [Sun Jan 24 12:05:32 1999] [error] server reached MaxClients setting,
      consider raising the MaxClients setting

There is no problem -- any connection attempts over the `MaxClients`
limit will normally be queued, up to a number based on the
`ListenBacklog` directive. When a child process is freed at the end of a
different request, the connection will be served.

It **is an error** because clients are being put in the queue rather
than getting served immediately, despite the fact that they do not get
an error response. The error can be allowed to persist to balance
available system resources and response time, but sooner or later you
will need to get more RAM so you can start more child processes. The
best approach is to try not to have this condition reached at all, and
if you reach it often you should start to worry about it.

It's important to understand how much real memory a child occupies. Your
children can share memory between them when the OS supports that. You
must take action to allow the sharing to happen. We have disscussed this
in one of the previous article whose main topic was shared memory. If
you do this, then chances are that your `MaxClients` can be even higher.
But it seems that it's not so simple to calculate the absolute number.
If you come up with a solution, then please let us know! If the shared
memory was of the same size throughout the child's life, then we could
derive a much better formula:

                   Total_RAM + Shared_RAM_per_Child * (MaxClients - 1)
      MaxClients = ---------------------------------------------------
                                  Max_Process_Size

which is:

                        Total_RAM - Shared_RAM_per_Child
      MaxClients = ---------------------------------------
                   Max_Process_Size - Shared_RAM_per_Child

Let's roll some calculations:

      Total_RAM            = 500Mb
      Max_Process_Size     =  10Mb
      Shared_RAM_per_Child =   4Mb

                  500 - 4
     MaxClients = --------- = 82
                   10 - 4

With no sharing in place

                     500
     MaxClients = --------- = 50
                     10

With sharing in place you can have 64 percent more servers without
buying more RAM.

If you improve sharing and keep the sharing level, let's say:

      Total_RAM            = 500Mb
      Max_Process_Size     =  10Mb
      Shared_RAM_per_Child =   8Mb

                  500 - 8
     MaxClients = --------- = 246
                   10 - 8

392 percent more servers! Now you can feel the importance of having as
much shared memory as possible.

### [Choosing MaxRequestsPerChild]{#choosing_maxrequestsperchild}

The `MaxRequestsPerChild` directive sets the limit on the number of
requests that an individual child server process will handle. After
`MaxRequestsPerChild` requests, the child process will die. If
`MaxRequestsPerChild` is 0, then the process will live forever.

Setting `MaxRequestsPerChild` to a non-zero limit solves some memory
leakage problems caused by sloppy programming practices, whereas a child
process consumes more memory after each request.

If left unbounded, then after a certain number of requests the children
will use up all the available memory and leave the server to die from
memory starvation. Note that sometimes standard system libraries leak
memory too, especially on OSes with bad memory management (e.g. Solaris
2.5 on x86 arch).

If this is your case, then you can set `MaxRequestsPerChild` to a small
number. This will allow the system to reclaim the memory that a greedy
child process consumed, when it exits after `MaxRequestsPerChild`
requests.

But beware -- if you set this number too low, you will lose some of the
speed bonus you get from mod\_perl. Consider using `Apache::PerlRun` if
this is the case.

Another approach is to use the `Apache::SizeLimit` or the
`Apache::GTopLimit` modules. By using either of these modules you should
be able to discontinue using the `MaxRequestPerChild`, although for some
developers, using both in combination does the job. In addition the
latter module allows you to kill any servers whose shared memory size
drops below a specified limit.

[References]{#references}
=========================

-   The mod\_perl site's URL: <http://perl.apache.org/>
-   `Apache::GTopLimit`
    <http://search.cpan.org/search?dist=Apache-GTopLimit>


