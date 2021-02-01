{
   "authors" : [
      "stas-bekman"
   ],
   "draft" : null,
   "slug" : "/pub/2002/06/19/mod_perl.html",
   "description" : " In this article we will talk about tools that we need before we can start working on the performance of our service. Essential Tools In order to improve performance, we need measurement tools. The main tool categories are benchmarking...",
   "categories" : "web",
   "image" : null,
   "title" : "Improving mod_perl Sites' Performance: Part 2",
   "date" : "2002-06-19T00:00:00-08:00",
   "tags" : [
      "mod-perl-benchmarking-test"
   ],
   "thumbnail" : null
}



*In this article we will talk about tools that we need before we can start working on the performance of our service.*

Essential Tools
-------------------------------------------------

In order to improve performance, we need measurement tools. The main tool categories are benchmarking and code profiling.

It's important to understand that, in a large number of the benchmarking tests that we will execute, we will not look at the absolute result numbers but the relation between two or more result sets. The purpose of the benchmarks is to try to show which coding approach is preferable. You shouldn't try to compare the **absolute** results presented in the articles with those that you get while running the same benchmarks on your machine, since you won't have the exact hardware and software setup anyway. This kind of comparison would be misleading. If you compare the relative results from the tests running on your machine, then you will do the right thing.

### Benchmarking Applications

How much faster is mod\_perl than mod\_cgi (aka plain Perl/CGI)? There are many ways to benchmark the two. I'll present a few examples and numbers below. Check out the `benchmark` directory of the mod\_perl distribution for more examples.

There is no need to write a special benchmark though. If you want to impress your boss or colleagues, then just take some heavy CGI script you have (e.g. a script that crunches some data and prints the results to STDOUT), open two xterms and call the same script in mod\_perl mode in one xterm and in mod\_cgi mode in the other. You can use `lwp-get` from the `LWP` package to emulate the browser. The `benchmark` directory of the mod\_perl distribution includes such an example.

#### Benchmarking Perl Code

If you are going to write your own benchmarking utility, then use the `Benchmark` module and the `Time::HiRes` module where you need better time precision (&lt;10msec).

An example of the `Benchmark.pm` module usage:

      benchmark.pl
      ------------
      use Benchmark;

      timethis (1_000,
       sub {
        my $x = 100;
        my $y = log ($x ** 100)  for (0..10000);
      });

      % perl benchmark.pl
      timethis 1000: 25 wallclock secs (24.93 usr +  0.00 sys = 24.93 CPU)

If you want to get the benchmark results in microseconds, then you will have to use the `Time::HiRes` module. Its usage is similar to `Benchmark`'s.

      use Time::HiRes qw(gettimeofday tv_interval);
      my $start_time = [ gettimeofday ];
      sub_that_takes_a_teeny_bit_of_time();
      my $end_time = [ gettimeofday ];
      my $elapsed = tv_interval($start_time,$end_time);
      print "The sub took $elapsed seconds."

#### Benchmarking a Graphic Hits Counter with Persistent DB Connections

Here are the numbers from Michael Parker's mod\_perl presentation at the Perl Conference (Aug, 98). The script is a standard hits counter, but it logs the counts into a mysql relational DataBase:

        Benchmark: timing 100 iterations of cgi, perl...  [rate 1:28]

        cgi: 56 secs ( 0.33 usr 0.28 sys = 0.61 cpu)
        perl: 2 secs ( 0.31 usr 0.27 sys = 0.58 cpu)

        Benchmark: timing 1000 iterations of cgi,perl...  [rate 1:21]

        cgi: 567 secs ( 3.27 usr 2.83 sys = 6.10 cpu)
        perl: 26 secs ( 3.11 usr 2.53 sys = 5.64 cpu)

        Benchmark: timing 10000 iterations of cgi, perl   [rate 1:21]

        cgi: 6494 secs (34.87 usr 26.68 sys = 61.55 cpu)
        perl: 299 secs (32.51 usr 23.98 sys = 56.49 cpu)

We don't know what server configurations were used for these tests, but I guess the numbers speak for themselves.

The source code of the script was available online, but, sadly, isn't anymore. However, you can reproduce the same performance speedup with pretty much any CGI script written in Perl.

#### Benchmarking Response Times With ApacheBench

ApacheBench (**ab**) is a tool for benchmarking your Apache HTTP server. It is designed to give you an idea of the performance that your current Apache installation can give. In particular, it shows you how many requests per second your Apache server is capable of serving. The **ab** tool comes bundled with the Apache source distribution.

Let's try it. We will simulate 10 users concurrently requesting a light script at `www.example.com/perl/test.pl`. Each simulated user makes 10 requests.

      % ./ab -n 100 -c 10 www.example.com/perl/test.pl

The results are:

      Document Path:          /perl/test.pl
      Document Length:        319 bytes

      Concurrency Level:      10
      Time taken for tests:   0.715 seconds
      Complete requests:      100
      Failed requests:        0
      Total transferred:      60700 bytes
      HTML transferred:       31900 bytes
      Requests per second:    139.86
      Transfer rate:          84.90 kb/s received

      Connection Times (ms)
                    min   avg   max
      Connect:        0     0     3
      Processing:    13    67    71
      Total:         13    67    74

We can see that under load of 10 concurrent users our server is capable of processing 140 requests per second. Of course, this benchmark is correct only when the script under test is used. We can also learn about the average processing time, which in this case was 67 milliseconds. Other numbers reported by `ab` may or may not be of interest to you.

For example, if we believe that the script *perl/test.pl* is not efficient, then we will try to improve it and run the benchmark again to see whether we have any improvement in performance.

#### Benchmarking Response Times With httperf

httperf is a utility written by David Mosberger. Just like ApacheBench, it measures the performance of the Web server.

A sample command line is shown below:

      httperf --server hostname --port 80 --uri /test.html \
       --rate 150 --num-conn 27000 --num-call 1 --timeout 5

This command causes httperf to use the Web server on the host with IP name `hostname`, running at port 80. The Web page being retrieved is */test.html* and, in this simple test, the same page is retrieved repeatedly. The rate at which requests are issued is 150 per second. The test involves initiating a total of 27,000 TCP connections and on each connection one HTTP call is performed. A call consists of sending a request and receiving a reply.

The timeout option defines the number of seconds that the client is willing to wait to hear back from the server. If this timeout expires, then the tool considers the corresponding call to have failed. Note that with a total of 27,000 connections and a rate of 150 per second, the total test duration will be approximately 180 seconds (27,000/150), independently of what load the server can actually sustain. Here is a result that one might get:

         Total: connections 27000 requests 26701 replies 26701 test-duration 179.996 s

         Connection rate: 150.0 conn/s (6.7 ms/conn, <=47 concurrent connections)
         Connection time [ms]: min 1.1 avg 5.0 max 315.0 median 2.5 stddev 13.0
         Connection time [ms]: connect 0.3

         Request rate: 148.3 req/s (6.7 ms/req)
         Request size [B]: 72.0

         Reply rate [replies/s]: min 139.8 avg 148.3 max 150.3 stddev 2.7 (36 samples)
         Reply time [ms]: response 4.6 transfer 0.0
         Reply size [B]: header 222.0 content 1024.0 footer 0.0 (total 1246.0)
         Reply status: 1xx=0 2xx=26701 3xx=0 4xx=0 5xx=0

         CPU time [s]: user 55.31 system 124.41 (user 30.7% system 69.1% total 99.8%)
         Net I/O: 190.9 KB/s (1.6*10^6 bps)

         Errors: total 299 client-timo 299 socket-timo 0 connrefused 0 connreset 0
         Errors: fd-unavail 0 addrunavail 0 ftab-full 0 other 0

#### Benchmarking Response Times With http\_load

`http_load` is yet another utility that does Web server load testing. It can simulate a 33.6 modem connection (*-throttle*) and allows you to provide a file with a list of URLs, which we be fetched randomly. You can specify how many parallel connections to run using the *-parallel N* option, or you can specify the number of requests to generate per second with *-rate N* option. Finally, you can tell the utility when to stop by specifying either the test time length (*-seconds N*) or the total number of fetches (*-fetches N*).

A sample run with the file *urls* including:

      http://www.example.com/foo/
      http://www.example.com/bar/

We ask to generate three requests per second and run for only two seconds. Here is the generated output:

      % ./http_load -rate 3 -seconds 2 urls
      http://www.example.com/foo/: check-connect SUCCEEDED, ignoring
      http://www.example.com/bar/: check-connect SUCCEEDED, ignoring
      http://www.example.com/bar/: check-connect SUCCEEDED, ignoring
      http://www.example.com/bar/: check-connect SUCCEEDED, ignoring
      http://www.example.com/foo/: check-connect SUCCEEDED, ignoring
      5 fetches, 3 max parallel, 96870 bytes, in 2.00258 seconds
      19374 mean bytes/connection
      2.49678 fetches/sec, 48372.7 bytes/sec
      msecs/connect: 1.805 mean, 5.24 max, 0.79 min
      msecs/first-response: 291.289 mean, 560.338 max, 34.349 min

So you can see that it has reported 2.5 requests per second. Of course, for the real test you will want to load the server heavily and run the test for a longer time to get more reliable results.

Note that when you provide a file with a list of URLs make sure that you don't have empty lines in it. If you do, then the utility won't work, complaining:

      ./http_load: unknown protocol -

#### Benchmarking Response Times With crashme Script

This is another crashme suite originally written by Michael Schilli (and was located at <http://www.linux-magazin.de> site, but now the link has gone). I made a few modifications, mostly adding `my()` operators. I also allowed it to accept more than one url to test, since sometimes you want to test more than one script.

The tool provides the same results as **ab** above but it also allows you to set the timeout value, so requests will fail if not served within the time out period. You also get values for **Latency** (seconds per request) and **Throughput** (requests per second). It can do a complete simulation of your favorite Netscape browser :) and give you a better picture.

I have noticed while running these two benchmarking suites, that **ab** gave me results from two and a half to three times better. Both suites were run on the same machine, with the same load and the same parameters, but the implementations were different.

Sample output:

      URL(s):          http://www.example.com/perl/access/access.cgi
      Total Requests:  100
      Parallel Agents: 10
      Succeeded:       100 (100.00%)
      Errors:          NONE
      Total Time:      9.39 secs
      Throughput:      10.65 Requests/sec
      Latency:         0.85 secs/Request

And the code:

      #!/usr/bin/perl -w

      use LWP::Parallel::UserAgent;
      use Time::HiRes qw(gettimeofday tv_interval);
      use strict;

      ###
      # Configuration
      ###

      my $nof_parallel_connections = 10;
      my $nof_requests_total = 100;
      my $timeout = 10;
      my @urls = (
                'http://www.example.com/perl/faq_manager/faq_manager.pl',
                'http://www.example.com/perl/access/access.cgi',
               );


      ##################################################
      # Derived Class for latency timing
      ##################################################

      package MyParallelAgent;
      @MyParallelAgent::ISA = qw(LWP::Parallel::UserAgent);
      use strict;

      ###
      # Is called when connection is opened
      ###
      sub on_connect {
        my ($self, $request, $response, $entry) = @_;
        $self->{__start_times}->{$entry} = [Time::HiRes::gettimeofday];
      }

      ###
      # Are called when connection is closed
      ###
      sub on_return {
        my ($self, $request, $response, $entry) = @_;
        my $start = $self->{__start_times}->{$entry};
        $self->{__latency_total} += Time::HiRes::tv_interval($start);
      }

      sub on_failure {
        on_return(@_);  # Same procedure
      }

      ###
      # Access function for new instance var
      ###
      sub get_latency_total {
        return shift->{__latency_total};
      }

      ##################################################
      package main;
      ##################################################
      ###
      # Init parallel user agent
      ###
      my $ua = MyParallelAgent->new();
      $ua->agent("pounder/1.0");
      $ua->max_req($nof_parallel_connections);
      $ua->redirect(0);    # No redirects

      ###
      # Register all requests
      ###
      foreach (1..$nof_requests_total) {
        foreach my $url (@urls) {
          my $request = HTTP::Request->new('GET', $url);
          $ua->register($request);
        }
      }

      ###
      # Launch processes and check time
      ###
      my $start_time = [gettimeofday];
      my $results = $ua->wait($timeout);
      my $total_time = tv_interval($start_time);

      ###
      # Requests all done, check results
      ###

      my $succeeded     = 0;
      my %errors = ();

      foreach my $entry (values %$results) {
        my $response = $entry->response();
        if($response->is_success()) {
          $succeeded++; # Another satisfied customer
        } else {
          # Error, save the message
          $response->message("TIMEOUT") unless $response->code();
          $errors{$response->message}++;
        }
      }

      ###
      # Format errors if any from %errors
      ###
      my $errors = join(',', map "$_ ($errors{$_})", keys %errors);
      $errors = "NONE" unless $errors;

      ###
      # Format results
      ###

      #@urls = map {($_,".")} @urls;
      my @P = (
            "URL(s)"          => join("\n\t\t ", @urls),
            "Total Requests"  => "$nof_requests_total",
            "Parallel Agents" => $nof_parallel_connections,
            "Succeeded"       => sprintf("$succeeded (%.2f%%)\n",
                                       $succeeded * 100 / $nof_requests_total),
            "Errors"          => $errors,
            "Total Time"      => sprintf("%.2f secs\n", $total_time),
            "Throughput"      => sprintf("%.2f Requests/sec\n",
                                       $nof_requests_total / $total_time),
            "Latency"         => sprintf("%.2f secs/Request",
                                       ($ua->get_latency_total() || 0) /
                                       $nof_requests_total),
           );

      my ($left, $right);
      ###
      # Print out statistics
      ###
      format STDOUT =
      @<<<<<<<<<<<<<<< @*
      "$left:",        $right
      .

      while(($left, $right) = splice(@P, 0, 2)) {
        write;
      }

#### Benchmarking PerlHandlers

The `Apache::Timeit` module does `PerlHandler` Benchmarking. With the help of this module you can log the time taken to process the request, just like you'd use the `Benchmark` module to benchmark a regular Perl script. Of course, you can extend this module to perform more advanced processing like putting the results into a database for a later processing. But all it takes is adding this configuration directive inside *httpd.conf*:

      PerlFixupHandler Apache::Timeit

Since scripts running under `Apache::Registry` are running inside the PerlHandler these are benchmarked as well.

An example of the lines which show up in the *error\_log* file:

      timing request for /perl/setupenvoff.pl:
        0 wallclock secs ( 0.04 usr +  0.01 sys =  0.05 CPU)
      timing request for /perl/setupenvoff.pl:
        0 wallclock secs ( 0.03 usr +  0.00 sys =  0.03 CPU)

The `Apache::Timeit` package is a part of the *Apache-Perl-contrib* files collection available from CPAN.

References
---------------------------------------

- [The mod\_perl site's URL](http://perl.apache.org)
- [httperf](http://www.hpl.hp.com/personal/David_Mosberger/httperf.html) -- webserver Benchmarking tool
- [http\_load](http://www.acme.com/software/http_load/) -- another webserver Benchmarking tool
- [Apache-Perl-contrib package](http://perl.apache.org/download/third_party.html)
- [Time::HiRes]({{<mcpan "Time::HiRes" >}}) and [Benchmark]({{<mcpan "Benchmark" >}}) is a part of the Core Perl
- [LWP (libwww-perl)](https://metacpan.org/release/libwww-perl)

