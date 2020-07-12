{
   "draft" : false,
   "tags" : [
      "go",
      "threads",
      "microsoft",
      "java",
      "router-xs",
      "catalyst",
      "kelp",
      "text-xslate"
   ],
   "image" : "/images/when-perl-isn-t-fast-enough/rocket.png",
   "title" : "When Perl isn't fast enough",
   "categories" : "programming-languages",
   "thumbnail" : "/images/when-perl-isn-t-fast-enough/thumb_rocket.png",
   "description" : "Losing in a competition to Java and Go",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2018-01-28T21:50:37"
}

Last year at $work we held a web application "bake off" competition, in order to find a suitable technology stack for serving some important pages on our website, as fast as possible. Our developers were allowed to compete individually or in a team, and they could use any programming language they wanted.

The existing solution was based on Perl's [Catalyst]({{<mcpan "Catalyst" >}}) framework using [Template::Toolkit]({{<mcpan "Template::Toolkit" >}}), and the code had become utterly bloated, to the point at which it took several hundred ms to serve the pages. The issue wasn't with the technology per se: a vanilla Catalyst application can serve responses in under 10ms, the problem was that the application code was shared among several different teams, and as each team added various features and functions, performance degraded.

The overall aim then, was to see what we could do if we "burned it down" and started again. The bake off generated a lot of buzz: we were given carte blanche to spend as much time as needed working on it, and it was a lot of fun. We had entries in Python, Go, Java, Haskell, Lua, Node, Elixir and of course, Perl.

# Round 1

The goal of the first round was to develop a web application that would respond to certain GET requests by serving a particular template. Much of the template was static, but there was some dynamic logic to it.

My team built a solution on top of [Plack]({{<mcpan "Plack" >}}). We created thin request and response classes in [Moo]({{<mcpan "Moo" >}}), a router coded in C ([Router::XS]({{<mcpan "Router::XS" >}})), and used [Text::XSlate]({{<mcpan "Text::XSlate" >}}) for the template. The solution kicked ass - it was able to serve over 10,000 requests per second, and we placed second overall, losing out only to a Java entry.

# Round 2

In round 2 things got trickier: our solutions would be required to make several requests to other internal services, in order to formulate the response. Additionally, our solutions would be judged for a "joy" factor: _would developers love working with this stack?_

To satisfy the "joy" factor, we merged our code with another team's entry, based on [Kelp]({{<mcpan "Kelp" >}}). That gave us a real web framework to develop with, as opposed to the threadbare classes we had developed in round 1.

The requirement to make several requests to other services hurt us though. The kicker was, we had to make the requests concurrently *and* compute concurrently on the responses. This was because the data needed for one request was coming from two separate data stores that could be fetched and processed and rendered concurrently. In other words, we needed threading.

Perl can do asynchronous programming with modules like [IO::Async]({{<mcpan "IO::Async" >}}) or [Coro]({{<mcpan "Coro" >}}), but it's single threaded. You *can* compile Perl with [threads]({{</* perldoc "threads" */>}}), which provide multi-threaded computing. They were developed back in the day by Microsoft to enable [mod_perl](https://perl.apache.org/) to run on Windows, in lieu of `fork()`. Perl's threads work by cloning the Perl interpreter's internal data structures, and passing around a thread context variable to tell Perl which thread is requesting what data. These have predictable drawbacks: they require more system resources because of the cloned data, and each thread runs _slower_ than a single threaded Perl because of all the thread context checks.

Perl's inability to multi-thread efficiently forced us to stay single-threaded and it really burnt us: the best performing Java and Go entries' throughput were within 3% of each other, but our solution was 50% slower.

# Conclusion

Perl is such a versatile language: from the terminal, to scripting and application programming, it excels in many areas. We were able to develop a lightning-fast application that competed with, and bested several high performance language competitors. Ultimately though, $work decided to use Go as for this solution we needed a highly scalable, performant stack.

Perl 6 might be a viable alternative soon. The latest 6.c [release](https://perl6.org/downloads/) includes a hybrid (M:N) threading model via a scheduler which comes into play when using [higher level constructs](https://docs.perl6.org/language/concurrency). To bypass the scheduler and get more control, it has a [Thread](https://docs.perl6.org/type/Thread) class, for which each instance maps 1:1 with an OS thread. I suspect it is too slow to compete right now, but I will be watching future Perl 6 benchmarks with interest.

\
Cover image from [psdgraphics.com](http://www.psdgraphics.com/psd/rocket-icon-psd/)
