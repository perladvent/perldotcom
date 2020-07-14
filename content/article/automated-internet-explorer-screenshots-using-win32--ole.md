{
   "slug" : "139/2014/12/11/Automated-Internet-Explorer-screenshots-using-Win32--OLE",
   "authors" : [
      "sinan-unur"
   ],
   "description" : "With Perl it is always easier than you think",
   "categories" : "web",
   "date" : "2014-12-11T14:44:25",
   "image" : "/images/139/31233122-80D8-11E4-8F6A-124BB3613736.png",
   "draft" : false,
   "thumbnail" : "/images/139/thumb_31233122-80D8-11E4-8F6A-124BB3613736.png",
   "title" : "Automated Internet Explorer screenshots using Win32::OLE",
   "tags" : [
      "windows",
      "perl",
      "ole",
      "screenshot",
      "internet_explorer",
      "win32"
   ]
}


### Background

Some time ago I [wrote](http://blog.nu42.com/2012/06/using-win32ole-with-events-to-capture.html) about using Perl's Win32::OLE to drive Internet Explorer in response to a [question](http://stackoverflow.com/a/11220026/100754) on Stackoverflow.

At the time I was still clinging to Windows XP. Since then, I have upgraded to Windows 8.1 Pro 64-bit, and instead of using [PPMs](http://www.activestate.com/activeperl/ppm-perl-modules) for [ActivePerl](http://www.activestate.com/activeperl), I have been using [Visual Studio 2013](http://blog.nu42.com/2014/11/64-bit-perl-5201-with-visual-studio.html) to build `perl`, and the modules I need.

I have been using Perl's [Win32::OLE]({{<mcpan "Win32::OLE" >}}) to drive Internet Explorer for various purposes for almost 10 years now. There is really not much to it other than having to read copious amounts of Microsoft documentation. It always amazes me how, after all these years, there is no language or environment as well documented as Perl, not just in terms of the amount of information provided, but also the ease with which you can find clear, correct, and useful information.

In any case, while the organization of the information leaves a lot to be desired, a good starting point for finding information on driving Internet Explorer via OLE is the InternetExplorer object [documentation](http://msdn.microsoft.com/en-us/library/aa752084%28v=vs.85%29) on MSDN. If you want to interact with the content within an InternetExplorer object, you can consult the MSHTML Scripting Object Interfaces [topic](http://msdn.microsoft.com/en-us/library/hh801967%28v=vs.85%29.aspx). It also helps to know a little bit about the [OLE](http://msdn.microsoft.com/en-us/library/19z074ky.aspx) interface.

Reading brian d foy's article on [controlling Firefox from Perl](https://perltricks.com/article/138/2014/12/7/Controlling-Firefox-from-Perl), I noticed that Win32::IE::Mechanize has disappeared from CPAN. The [discussion on PerlMonks](http://www.perlmonks.org?node_id=1061372) did not make much sense to me, as I remember very clearly using Win32::OLE to drive Internet Explorer 8 for a massive scraping job.

I decided to look at my old screenshot utility, and see what changes were needed to get it to run on Windows 8, using Internet Explorer 10. My [revised working script is available in a GitHub gist](https://gist.github.com/nanis/3dac6b386bd056095e12). Here, I am going to cover the highlights.

### Tracing execution

The idea is to use the [DWebBrowserEvents2](http://msdn.microsoft.com/en-us/library/aa768283%28v=vs.85%29.aspx) to figure out the right time to capture the browser window. I decided to see if my answer from 2012 still worked. I pointed it to my personal website, and it failed:

    Win32::OLE(0.1712) error 0x80020009: "Exception occurred"
        in METHOD/PROPERTYGET "StatusText" at iescreenshot.pl line 38.

The cause of the problem lay in accessing the `StatusText` property of the [Internet Explorer object](http://msdn.microsoft.com/en-us/library/aa752084%28v=vs.85%29). Apparently, IE10 no longer exposes this property. Well, I had only used it so as to give some idea of what was happening. I decided instead to write a quick logging function which could be used with all events:

```perl
sub log_browser_event {
    my $event = shift;
    no warnings 'uninitialized';
    my $args = eval { join(' ' => map valof($_), @_) };
    say "$event: $args";
    return;
}
```

Not an example of perfect code, but, I am trying to keep this short and sweet.

### Event handling

We are only interested in two events: [DocumentComplete](http://msdn.microsoft.com/en-us/library/aa768282%28v=vs.85%29.aspx), so we know when to take a screenshot, and [onQuit](http://msdn.microsoft.com/en-us/library/aa768340%28v=vs.85%29.aspx), so we can quit cleanly if the user closes the browser window before we get to that point.

You initialize OLE events using the call:

```perl
Win32::OLE->WithEvents(
    $object,
    $handler,
    $interface
);
```

Then, presumably, your `$handler` has some giant switch statement, dispatching on the basis of the actual events received. Instead, I opted for a dispatch table:

```perl
const my %BrowserEvents => (
    DocumentComplete => sub {
        $do_take_screenshot = 1;
        Win32::MessageLoop->QuitMessageLoop;
    },
    OnQuit => sub {
        $do_take_screenshot = 0;
        Win32::MessageLoop->QuitMessageLoop;
    },
    _ => sub { },
);
```

Notice the use of [Win32::MessageLoop-\>QuitMessageLoop]({{<mcpan "Win32::MessageLoop" >}}) instead of `Win32::OLE->QuitMessageLoop` to avoid spurious sleep calls.

Then, I initialize the OLE events interface using:

```perl
Win32::OLE->WithEvents(
    $browser,
    sub { $handler->(\%BrowserEvents, @_) },
    'DWebBrowserEvents2'
);
```

The `$handler` in this case just logs the event, and consults the dispatch table to see if we are interested in the event:

```perl
sub WebBrowserEventHandler {
    my $handlers = shift;
    my $browser = shift;
    my $event = shift;

    log_browser_event($event, @_);

    my $handler = exists $handlers->{$event}
                ? $handlers->{$event}
                : $handlers->{_}
    ;
    $handler->($browser, $event, @_);
    return;
}
```

Upon receiving either `DocumentComplete` or `onQuit`, we terminate the message loop, which returns control to the navigation function. At that point, the only thing left is to check if we should capture a screenshot. After that, the program terminates.

### Capturing the Internet Explorer window

When I ran this revised script, and tried to take screenshots using [Imager::Screenshot]({{<mcpan "Imager::Screenshot" >}}), I got screenshots with only the frame of the browser, and none of the content. I am not sure what's going on, and I will try to diagnose that issue later. For now, since I was using the venerable [Win32::GuiTest]({{<mcpan "Win32::GuiTest" >}}) module anyway, I decided to use the `Win32::GuiTest::DibSect` class it provides:

```perl
sub take_screenshot {
    my $browser = shift;

    wait_until_ready($browser);

    my $hwnd = $browser->{HWND};
    my $title = $browser->{Document}{title};
    $title =~ s/[^A-Za-z0-9_-]+/-/g;

    my $ds = Win32::GuiTest::DibSect->new;

    my $fgwnd = GetForegroundWindow();
    SetForegroundWindow $hwnd;
    $ds->CopyWindow($hwnd);
    SetForegroundWindow $fgwnd;

    $ds->SaveAs("$title.bmp");
    $ds->Destroy;

    return;
}
```

### Waiting for the document to be rendered

With that in place, I was still getting the occasional screenshot with a blank document area. If I understand this correctly, the fact that the `DocumentReady` event fired does not mean the document has been fully rendered. It just means that you can manipulate the DOM. So, I added a simple spin loop for the browser to stop being [busy](http://msdn.microsoft.com/en-us/library/aa752050%28v=vs.85%29). This is by no means foolproof, but it has worked for most sites have tried. Sites with a lot of AJAXy stuff tend to have issues with this. There are site-specific ways of dealing with that, but that's beyond the scope of this article.

```perl
sub wait_until_ready {
    my $browser = shift;
    {
        local $| = 1;
        while ($browser->Busy) {
            print '.';
            sleep 1;
        }
    }
    return;
}
```

At this point, you can run the script from the command line with a simple `perl iescreenshot.pl perltricks.com`.

### The WebDriver API

The [WebDriver API](http://msdn.microsoft.com/en-us/library/ie/dn725045%28v=vs.85%29.aspx) might obviate the need for using any other solution to drive Internet Explorer, but, until that is available everywhere, [Win32::OLE]({{<mcpan "Win32::OLE" >}}) is more than adequate.

### Conclusion

Using [Win32::OLE]({{<mcpan "Win32::OLE" >}}) to drive Internet Explorer has been very helpful to me in the past. Taking a screenshot is just a simple, proof-of-concept exercise. The beauty of using Perl is that once you reach a page containing the information you want, you can use Perl's excellent HTML parsing modules to get exactly what you want out of it, and then, say, save it to an Excel worksheet, generate PDF document, or just stuff it in a database somewhere.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
