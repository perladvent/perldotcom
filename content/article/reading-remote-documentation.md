
  {
    "title"       : "Reading remote documentation",
    "authors"     : ["david-farrell"],
    "date"        : "2018-02-11T20:41:57",
    "tags"        : ["perldoc","cpandoc","pod","metacpan","sh"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "How to read the documentation for modules you don't have",
    "categories"  : "cpan"
  }

When I need to read Perl documentation, I use [perldoc]({{< relref "hello-perldoc--productivity-booster.md" >}}). I spend most of my time working at the terminal, so it's convenient to drop to a command prompt and bring up the documentation for some module or command right there in the terminal.

### Pod::Cpandoc

Sometimes I need to check the documentation of a module I don't have installed on my machine, and in those cases, `perldoc` can't help me. Instead I could use [cpandoc]({{<mcpan "Pod::Cpandoc">}}), as it behaves like perldoc, but it will fetch remote documentation if the module is not installed on your system.

    $ cpandoc Foo::Bar
    # displays Foo::Bar pod in pager app

As `cpandoc` supports the same options as `perldoc`, you can use it for useful [tricks](http://perladvent.org/2011/2011-12-15.html) like browsing the source code for a module without installing it.

### ♥ Metacpan ♥

Now, reading documentation in the terminal is fine and all, but I really like [metacpan's](http://metacpan.org) distribution pages, which not only include documentation, but also incorporate CPAN Testers' results, a release history, open issues, and other useful links and data. So lately I've taken to reading documentation on metacpan.

Getting there though, can be tiresome. I open a new browser tab, start typing "metacpan", my browser then autocompletes it to the most recent metacpan address I viewed, which is inevitably **not** the one I want, so I highlight the module name in the URL, and replace it with the one I'm looking for.

After having performed this routine more times than I'd like to admit, I finally wrote a shell script to do it for me:

```bash
#!/bin/sh
URL="https://metacpan.org/pod/$1"

if [[ "$OSTYPE" == "linux-gnu"  ]]; then
  xdg-open "$URL" &>/dev/null
elif [[ "$OSTYPE" == "darwin"*  ]]; then
  open "$URL" &>/dev/null
elif [[ "$OSTYPE" == "cygwin"   ]]; then
  cygstart "$URL" &>/dev/null
elif [[ "$OSTYPE" == "msys"     ]]; then
  start "$URL"
elif [[ "$OSTYPE" == "win32"    ]]; then
  start "$URL"
elif [[ "$OSTYPE" == "freebsd"* ]]; then
  xdg-open "$URL" &>/dev/null
else
  echo "OS not recognized"
fi
```

It constructs the metacpan URL using the first argument passed to the script, and then opens the URL in a new browser tab. I named the script `pod` and placed it in my local path (I was going to call it `mcpan` but that's a little similar to `cpanm` for my tastes, plus "pod" is faster to type). So now if I want to view something on metacpan, all I have to do is type:

    $ pod Foo::Bar

And the script does the rest. I've added commands for other operating systems, but I've only tested it on Linux and MacOS.
