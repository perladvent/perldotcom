{
   "description" : " In this article we continue talking about how to optimize your site for performance without touching code, buying new hardware or telling casts. A few simple httpd.conf configuration changes can improve the performance tremendously. Choosing MinSpareServers, MaxSpareServers and StartServers...",
   "slug" : "/pub/2003/03/04/mod_perl.html",
   "authors" : [
      "stas-bekman"
   ],
   "draft" : null,
   "thumbnail" : null,
   "tags" : [
      "mod-perl-apache-performance"
   ],
   "date" : "2003-03-04T00:00:00-08:00",
   "title" : "Improving mod_perl Sites' Performance: Part 8",
   "image" : null,
   "categories" : "web"
}



In this article we continue talking about how to optimize your site for performance without touching code, buying new hardware or telling casts. A few simple *httpd.conf* configuration changes can improve the performance tremendously.

### <span id="choosing_minspareservers,_maxspareservers_and_startservers">Choosing MinSpareServers, MaxSpareServers and StartServers</span>

With mod\_perl enabled, it might take as much as 20 seconds from the time you start the server until it is ready to serve incoming requests. This delay depends on the OS, the number of preloaded modules and the process load of the machine. It's best to set [`StartServers`](#item_startservers) and [`MinSpareServers`](#item_minspareservers) to high numbers, so that if you get a high load just after the server has been restarted, the fresh servers will be ready to serve requests immediately. With mod\_perl, it's usually a good idea to raise all three variables higher than normal.

In order to maximize the benefits of mod\_perl, you don't want to kill servers when they are idle, rather you want them to stay up and available to handle new requests immediately. I think an ideal configuration is to set [`MinSpareServers`](#item_minspareservers) and [`MaxSpareServers`](#item_maxspareservers) to similar values, maybe even the same. Having the [`MaxSpareServers`](#item_maxspareservers) close to [`MaxClients`](#item_maxclients) will completely use all of your resources (if [`MaxClients`](#item_maxclients) has been chosen to take the full advantage of the resources), but it'll make sure that at any given moment your system will be capable of responding to requests with the maximum speed (assuming that number of concurrent requests is not higher than [`MaxClients`](#item_maxclients)).

Let's try some numbers. For a heavily loaded Web site and a dedicated machine, I would think of (note 400Mb is just for example):

      Available to webserver RAM:   400Mb
      Child's memory size bounded:  10Mb
      MaxClients:                   400/10 = 40 (larger with mem sharing)
      StartServers:                 20
      MinSpareServers:              20
      MaxSpareServers:              35

However, if I want to use the server for many other tasks, but make it capable of handling a high load, I'd try:

      Available to webserver RAM:   400Mb
      Child's memory size bounded:  10Mb
      MaxClients:                   400/10 = 40
      StartServers:                 5
      MinSpareServers:              5
      MaxSpareServers:              10

These numbers are taken off the top of my head, and shouldn't be used as a rule, but rather as examples to show you some possible scenarios. Use this information with caution.

### <span id="summary_of_benchmarking_to_tune_all_5_parameters">Summary of Benchmarking to Tune All 5 Parameters</span>

OK, we've run various benchmarks -- let's summarize the conclusions:

-   **<span id="item_maxrequestsperchild">MaxRequestsPerChild</span>**
    If your scripts are clean and don't leak memory, then set this variable to a number as large as possible (10000?). If you use `Apache::SizeLimit`, then you can set this parameter to 0 (treated as infinity). You will want this parameter to be smaller if your code becomes gradually more unshared over the process' life. As well as this, `Apache::GTopLimit` can help, with its shared memory limitation feature.
-   **<span id="item_startservers">StartServers</span>**
    If you keep a small number of servers active most of the time, then keep this number low. Keep it low especially if [`MaxSpareServers`](#item_maxspareservers) is also low, as if there is no load, Apache will kill its children before they have been utilized at all. If your service is heavily loaded, then make this number close to [`MaxClients`](#item_maxclients), and keep [`MaxSpareServers`](#item_maxspareservers) equal to [`MaxClients`](#item_maxclients).
-   **<span id="item_minspareservers">MinSpareServers</span>**
    If your server performs other work besides Web serving, then make this low so the memory of unused children will be freed when the load is light. If your server's load varies (you get loads in bursts) and you want fast response for all clients at any time, then you will want to make it high, so that new children will be respawned in advance and are waiting to handle bursts of requests.
-   **<span id="item_maxspareservers">MaxSpareServers</span>**
    The logic is the same as for [`MinSpareServers`](#item_minspareservers) - low if you need the machine for other tasks, high if it's a dedicated Web host and you want a minimal delay between the request and the response.
-   **<span id="item_maxclients">MaxClients</span>**
    Not too low, so you don't get into a situation where clients are waiting for the server to start serving them (they might wait, but not for very long). However, do not set it too high. With a high MaxClients, if you get a high load, then the server will try to serve all requests immediately. Your CPU will have a hard time keeping up, and if the child size \* number of running children is larger than the total available RAM, then your server will start swapping. This will slow down everything, which in turn will make things even slower, until eventually your machine will die. It's important that you take pains to ensure that swapping does not normally happen. Swap space is an emergency pool, not a resource to be used routinely. If you are low on memory and you badly need it, then buy it. Memory is cheap.

    But based on the test I conducted above, even if you have plenty of memory like I have (1Gb), increasing [`MaxClients`](#item_maxclients) sometimes will give you no improvement in performance. The more clients are running, the more CPU time will be required, the less CPU time slices each process will receive. The response latency (the time to respond to a request) will grow, so you won't see the expected improvement. The best approach is to find the minimum requirement for your kind of service and the maximum capability of your machine. Then start at the minimum and test as I did, successively raising this parameter until you find the region on the curve of the graph of latency and/or throughput against MaxClients where the improvement starts to diminish. Stop there and use it. When you make the measurements on a production server you will have the ability to tune them more precisely, since you will see the real numbers.

    Don't forget that if you add more scripts, or even just modify the existing ones, then the processes will grow in size as you compile in more code. When you do this, your parameters probably will need to be recalculated.

### <span id="keepalive">KeepAlive</span>

If your mod\_perl server's *httpd.conf* includes the following directives:

      KeepAlive On
      MaxKeepAliveRequests 100
      KeepAliveTimeout 15

you have a real performance penalty, since after completing the processing for each request, the process will wait for `KeepAliveTimeout` seconds before closing the connection and will therefore not be serving other requests during this time. With this configuration, you will need many more concurrent processes on a server with high traffic.

If you use some server status reporting tools, then you will see the process in *K* status when it's in `KeepAlive` status.

The chances are that you don't want this feature enabled. Set it Off with:

      KeepAlive Off

The other two directives don't matter if `KeepAlive` is `Off`.

You might want to consider enabling this option if the client's browser needs to request more than one object from your server for a single HTML page. If this is the situation, then by setting `KeepAlive` `On` you will save the HTTP connection overhead for all requests but the first one for each page.

For example: If you have a page with 10 ad banners, which is not uncommon today, then your server will work more effectively if a single process serves them all during a single connection. However, your client will see a slightly slower response, since banners will be brought one at a time and not concurrently as is the case if each `IMG` tag opens a separate connection.

Since keepalive connections will not incur the additional three-way TCP handshake, turning it on will be kinder to the network.

SSL connections benefit the most from `KeepAlive` in cases where you haven't configured the server to cache session ids.

You have probably followed the usual advice to send all the requests for static objects to a plain Apache server. Since most pages include more than one unique static image, you should keep the default `KeepAlive` setting of the non-mod\_perl server, i.e. keep it `On`. It will probably be a good idea also to reduce the timeout a little.

One option would be for the proxy/accelerator to keep the connection open to the client but make individual connections to the server, read the response, buffer it for sending to the client and close the server connection. Obviously, you would make new connections to the server as required by the client's requests.

Also, you should know that `KeepAlive` requests only work with responses that contain a `Content-Length` header. To send this header do:

      $r->header_out('Content-Length', $length);

### <span id="perlsetupenv_off">PerlSetupEnv Off</span>

`PerlSetupEnv Off` is another optimization you might consider. This directive requires mod\_perl 1.25 or later.

*mod\_perl* fiddles with the environment to make it appear as if the script were being called under the CGI protocol. For example, the `$ENV{QUERY_STRING}` environment variable is initialized with the contents of *Apache::args()*, and the value returned by *Apache::server\_hostname()* is put into `$ENV{SERVER_NAME}`.

But `%ENV` population is expensive. Those who have moved to the Perl Apache API no longer need this extra `%ENV` population, and can gain by turning it **Off**. Scripts using the `CGI.pm` module require `PerlSetupEnv On` because that module relies on a properly populated CGI environment table.

By default it is "On."

Note that you can still set environment variables. For example, when you use the following configuration:

      PerlSetupEnv Off
      PerlModule Apache::RegistryNG
      <Location /perl>
        PerlSetupEnv On
        PerlSetEnv TEST hi
        SetHandler perl-script
        PerlHandler Apache::RegistryNG
        Options +ExecCGI
      </Location>

and issue a request (for example <http://localhost/perl/setupenvoff.pl)> for this script:

      setupenvoff.pl
      --------------
      use Data::Dumper;
      my $r = Apache->request();
      $r->send_http_header('text/plain');
      print Dumper(\%ENV);

you should see something like this:

      $VAR1 = {
                'GATEWAY_INTERFACE' => 'CGI-Perl/1.1',
                'MOD_PERL' => 'mod_perl/1.25',
                'PATH' => '/usr/lib/perl5/5.00503:... snipped ...',
                'TEST' => 'hi'
              };

Notice that we have got the value of the environment variable *TEST*.

### <span id="reducing_the_number_of_stat()_calls_made_by_apache">Reducing the Number of `stat()` Calls Made by Apache</span>

If you watch the system calls that your server makes (using *truss* or *strace*) while processing a request, then you will notice that a few `stat()` calls are made. For example, when I fetch http://localhost/perl-status and I have my DocRoot set to */home/httpd/docs* I see:

      [snip]
      stat("/home/httpd/docs/perl-status", 0xbffff8cc) = -1
                          ENOENT (No such file or directory)
      stat("/home/httpd/docs", {st_mode=S_IFDIR|0755,
                                     st_size=1024, ...}) = 0
      [snip]

If you have some dynamic content and your virtual relative URI is something like */news/perl/mod\_perl/summary* (i.e., there is no such directory on the web server, the path components are only used for requesting a specific report), then this will generate `five(!)` `stat()` calls, before the `DocumentRoot` is found. You will see something like this:

      stat("/home/httpd/docs/news/perl/mod_perl/summary", 0xbffff744) = -1
                          ENOENT (No such file or directory)
      stat("/home/httpd/docs/news/perl/mod_perl",         0xbffff744) = -1
                          ENOENT (No such file or directory)
      stat("/home/httpd/docs/news/perl",                  0xbffff744) = -1
                          ENOENT (No such file or directory)
      stat("/home/httpd/docs/news",                       0xbffff744) = -1
                          ENOENT (No such file or directory)
      stat("/home/httpd/docs",
                          {st_mode=S_IFDIR|0755, st_size=1024, ...})  =  0

How expensive are those calls? Let's use the `Time::HiRes` module to find out.

      stat_call_sample.pl
      -------------------
      use Time::HiRes qw(gettimeofday tv_interval);
      my $calls = 1_000_000;

      my $start_time = [ gettimeofday ];

      stat "/app" for 1..$calls;

      my $end_time = [ gettimeofday ];

      my $elapsed = tv_interval($start_time,$end_time) / $calls;

      print "The average execution time: $elapsed seconds\n";

This script takes a time sample at the beginning, then does 1,000,000 `stat()` calls to a nonexisting file, samples the time at the end and prints the average time it took to make a single `stat()` call. I'm sampling a million stats, so I'd get a correct average result.

Before we actually run the script, one should distinguish between two different situations. When the server is idle, the time between the first and the last system call will be much shorter than the same time measured on the loaded system. That is because on the idle system, a process can use CPU very often, and on the loaded system lots of processes compete over it and each process has to wait for a longer time to get the same amount of CPU time.

So first we run the above code on the unloaded system:

      % perl stat_call_sample.pl
      The average execution time: 4.209645e-06 seconds

So it takes about 4 microseconds to execute a `stat()` call. Now let's start a CPU intensive process in one console. The following code keeps the CPU busy all the time.

      % perl -e '1**1 while 1'

And now run the *stat\_call\_sample.pl* script in the other console.

      % perl stat_call_sample.pl
      The average execution time: 8.777301e-06 seconds

You can see that the average time has more than doubled (about 8 microseconds). And this is obvious, since there were two processes competing for the CPU. Now if we run 4 occurrences of the above code:

      % perl -e '1**1 while 1' &
      % perl -e '1**1 while 1' &
      % perl -e '1**1 while 1' &
      % perl -e '1**1 while 1' &

And when running our script in parallel with these processes, we get:

      % perl stat_call_sample.pl
      2.0853558e-05 seconds

about 20 microseconds. So the average `stat()` system call is five times longer now. Now, if you have 50 mod\_perl processes that keep the CPU busy all the time, the `stat()` call will be 50 times slower and it'll take 0.2 milliseconds to complete a series of call. If you have five redundant calls as in the strace example above, then they add up to 1 millisecond. If you have more processes constantly consuming CPU, then this time adds up. Now multiply this time by the number of processes that you have and you get a few seconds lost. As usual, for some services, this loss is insignificant, while for others a very significant one.

So why does Apache make all these redundant `stat()` calls? You can blame the default installed `TransHandler` for this inefficiency. Of course, you could supply your own, which will be smart enough not to look for this virtual path and immediately return `OK`. But in cases where you have a virtual host that serves only dynamically generated documents, you can override the default `PerlTransHandler` with this one:

      <VirtualHost 10.10.10.10:80>
        ...
        PerlTransHandler  Apache::OK
        ...
      </VirtualHost>

As you see it affects only this specific virtual host.

This has the effect of short circuiting the normal `TransHandler` processing of trying to find a filesystem component that matches the given URI -- no more 'stat's!

Watching your server under strace/truss can often reveal more performance hits than trying to optimize the code itself!

For example, unless configured correctly, Apache might look for the *.htaccess* file in many places, even if you don't have one, and make many unnecessary `open()` calls.

Let's start with this simple configuration. We will try to reduce the number of irrelevant system calls.

      DocumentRoot "/home/httpd/docs"
      <Location /app/test>
        SetHandler perl-script
        PerlHandler Apache::MyApp
      </Location>

The above configuration allows us to make a request to */app/test* and the Perl `handler()` defined in `Apache::MyApp` will be executed. Notice that in the test setup there is no file to be executed (like in `Apache::Registry`). There is no *.htaccess* file as well.

This is a typical generated trace.

      stat("/home/httpd/docs/app/test", 0xbffff8fc) = -1 ENOENT
            (No such file or directory)
      stat("/home/httpd/docs/app",      0xbffff8fc) = -1 ENOENT
            (No such file or directory)
      stat("/home/httpd/docs",
            {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
      open("/.htaccess", O_RDONLY)                 = -1 ENOENT
            (No such file or directory)
      open("/home/.htaccess", O_RDONLY)            = -1 ENOENT
            (No such file or directory)
      open("/home/httpd/.htaccess", O_RDONLY)      = -1 ENOENT
            (No such file or directory)
      open("/home/httpd/docs/.htaccess", O_RDONLY) = -1 ENOENT
            (No such file or directory)
      stat("/home/httpd/docs/test", 0xbffff774)    = -1 ENOENT
            (No such file or directory)
      stat("/home/httpd/docs",
            {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0

Now we modify the `<Directory>` entry and add AllowOverride None, which among other things disables *.htaccess* files and will not try to open them.

      <Directory />
        AllowOverride None
      </Directory>

We see that the four `open()` calls for *.htaccess* have gone:

      stat("/home/httpd/docs/app/test", 0xbffff8fc) = -1 ENOENT
            (No such file or directory)
      stat("/home/httpd/docs/app",      0xbffff8fc) = -1 ENOENT
            (No such file or directory)
      stat("/home/httpd/docs",
            {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0
      stat("/home/httpd/docs/test", 0xbffff774)    = -1 ENOENT
            (No such file or directory)
      stat("/home/httpd/docs",
            {st_mode=S_IFDIR|0755, st_size=1024, ...}) = 0

Let's try to shortcut the *app* location with:

      Alias /app /

Which makes Apache to look for the file in the */* directory and not under */home/httpd/docs/app*. Let's run it:

      stat("//test", 0xbffff8fc) = -1 ENOENT (No such file or directory)

Wow, we've got only one stat call left!

Let's remove the last `Alias` setting and use:

        PerlTransHandler  Apache::OK

as explained above. When we issue the request, we see no `stat()` calls. But this is possible only if you serve only dynamically generated documents, i.e. no CGI scripts. Otherwise, you will have to write your own *PerlTransHandler* to handle requests as desired.

For example, this *PerlTransHandler* will not lookup the file on the filesystem if the URI starts with */app*, but will use the default *PerlTransHandler* otherwise:

      PerlTransHandler 'sub { return shift->uri() =~ m|^/app| \
                            ? Apache::OK : Apache::DECLINED;}'

Let's see the same configuration using the `<Perl>` section and a dedicated package:

      <Perl>
        package My::Trans;
        use Apache::Constants qw(:common);
        sub handler{
           my $r = shift;
           return OK if $r->uri() =~ m|^/app|;
           return DECLINED;
        }

        package Apache::ReadConfig;
        $PerlTransHandler = "My::Trans";
      </Perl>

As you see we have defined the `My::Trans` package and implemented the `handler()` function. Then we have assigned this handler to the `PerlTransHandler`.

Of course you can move the code in the module into an external file, (e.g. *My/Trans.pm*) and configure the `PerlTransHandler` with

      PerlTransHandler My::Trans

in the normal way (no `<Perl>` section required).

------------------------------------------------------------------------

<span id="references">References</span>
=======================================

-   The mod\_perl site's URL: <http://perl.apache.org/>
-   `Time::HiRes`: <https://metacpan.org/pod/Time::HiRes>

