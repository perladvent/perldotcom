  {
    "title"  : "Track Module Changes While You Sleep",
    "authors": ["brian-d-foy"],
    "date"   : "2017-03-27T08:47:28",
    "tags"   : ["perlmodules.net","module-extact-use", "changes"],
    "draft"  : false,
    "image"  : "",
    "description" : "Let Perlmodules.net do the work",
    "categories": "cpan"
  }

I created [Module::Extract::Use]({{<mcpan "Module::Extract::Use" >}}) as a simple tool to list the modules a program uses, and I recently added some features to make it easier to create some input I could give to [Perlmodules.net](https://www.perlmodules.net) to create a feed of changes for those modules.

Much of my day-to-day work involves helping people turn legacy stuff into something testable, distributable, and installable (I find that special sort of drudgery quite interesting because every mess is different).  Jonathan Yu worked with my [Module::Extract::Use]({{<mcpan "Module::Extract::Use" >}}) to create the example program <i>examples/extract_modules</i> which I extended a bit. Here are some examples using the script on itself. The first example is for human inspection:

    # print a verbose text listing
    $ extract_modules extract_modules
    Modules required by examples/extract_modules:
     - Getopt::Std (first released with Perl 5)
     - Module::CoreList (first released with Perl 5.008009)
     - Pod::Usage (first released with Perl 5.006)
     - strict (first released with Perl 5)
     - warnings (first released with Perl 5.006)
    5 module(s) in core, 0 external module(s)

I added some options to create an undecorated list of one module per line:

    # print a succint list, one module per line
    $ extract_modules -l extract_modules
    Getopt::Std
    Module::CoreList
    Pod::Usage
    open
    strict
    warnings

And since I like that `xargs -0` allows me to represent several lines as a single string with null octets as separators, I added a switch for that:

    # print a succinct list, modules separated by null bytes
    # you might like this with xargs -0
    $ extract_modules -l -0 extract_modules
    Getopt::StdModule::CoreListPod::Usageopenstrictwarnings

While I'm in there, I might as well add JSON output:

    # print the modules list as JSON
    $ extract_modules -j extract_modules
    [
      "Getopt::Std",
      "Module::CoreList",
      "Pod::Usage",
      "open",
      "strict",
      "warnings"
    ]

If you want XML, tough. Well, I'll accept patches, actually, but maybe you could write a JSON-to-XML converter and chain some programs. Remember that Perl is a glue language!

Note that this program can only detect explicitly declared namespaces in static `use` and `require` statements. You don't see the [Module::Extract::Use]({{<mcpan "Module::Extract::Use" >}}) in the output because this program uses it implicitly. That's a rare situation that doesn't bother me that much, and it's something that I try to refactor out of code when I can.

One of my immediate uses is to install all of the dependencies from a standalone program:

    $ extract_modules -l -0 some_program | xargs -0 cpan

This is much better than what I use to do: keep trying to run the program until it doesn't complain about missing dependencies. Sometimes that will still happen will implicit dependencies, but as I said, it's rare. From there, I can also use this list to construct the text I need to put into a _Makefile.PL_. I've considered writing a program for that, but I don't think it would save me that much time. I usually want to look at the list, so the no-look automation isn't as compelling.

There's another thing I like to do with these module lists. Alexander Karelas created the website [PerlModules.net](https://www.perlmodules.net) to create feeds of changes to sets of modules. He was kind enough to support my _Learning Perl 6_ Kickstarter campaign by sponsoring this article on PerlTricks.

From a list of modules, he figures out which distribution they are in and diff all of those _Changes_ files so he can present all of those diffs to you. You (and most people) probably don't pay attention to all the changes. Perhaps you look at the _Changes_ for one of the main modules. You might ignore those other changes because it's a bunch of work to go through all the distributions.

You create a feed that specifies the modules that you want to track. For each new release, he diffs the Changes file and adds that diff to your feed. If you like, you could have one feed per application. When the module changes, you'll see an entry in your feed and can read the diff without tracking down the module.

![Personal Feeds](/images/perlmodules-net/personal-feeds.png)

To get the list of modules I want to track, I can use `extract_modules` with its `-l` switch to make a one-namespace-per-line list of the dependencies. Here I use `extract_modules` on all of the modules in a project:

    $ find lib -name "*.pm" -print0 | xargs -0 extract_modules -l
    Archive::Extract
    Archive::Tar
    Archive::Zip
    ... # long list elided
    YAML::XS
    base
    parent
    strict
    subs
    vars
    warnings

I can paste this list directly into the [PerlModules.net](https://www.perlmodules.net) feed creator (or the motivated can automate this if they want to create many, many feeds).

![Upload List](/images/perlmodules-net/upload-list.png)

Once I've created the feed, I can view it in a variety of ways. Although I could visit the website to see what's changed or get email when there's a change. I prefer the RSS feed though. With that feed, a motivated Perler effectively has a way to programmatically get a list of the changes by fetching and parsing that feed.

![Changes List](/images/perlmodules-net/changes-list.png)

But, now comes the hard part: Making good _Changes_ files in our distributions. That's something I'll save for a different PerlTricks article.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
