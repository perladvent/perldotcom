{
   "description" : "How I setup and controlled headless Chrome with Perl",
   "categories" : "web",
   "tags" : [
      "chrome",
      "selenium",
      "chromedriver",
      "selenium-remote-driver",
      "headless",
      "spider"
   ],
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/spidering-websites-with-headless-chrome-and-selenium/chrome.png",
   "thumbnail" : "/images/spidering-websites-with-headless-chrome-and-selenium/thumb_chrome.png",
   "date" : "2019-01-13T20:31:37",
   "title" : "Spidering websites with Headless Chrome and Selenium"
}

Over the holidays I was working on a project that needed to download content from different websites. I needed a web spider, but the typical Perl options like [WWW:Mechanize]({{< mcpan "WWW::Mechanize" >}}) wouldn't cut it, as with JavaScript controlling the content on many websites, I needed a JavaScript-enabled browser. But browsers consume lots of memory - what to do?

The answer was to use headless Chrome, which works exactly like normal except it has no graphical display, reducing its memory footprint. I can control it using [Selenium::Remote::Driver]({{< mcpan "Selenium::Remote::Driver" >}}) and Selenium server. Here's how I did it.

Non-Perl Setup
--------------
Obviously I needed to install the Chrome browser. On Linux that usually involves adding the Chrome repo, and then installing the Chrome package. On Fedora it was as easy as:

    sudo dnf install fedora-workstation-repositories
    sudo dnf config-manager --set-enabled google-chrome
    sudo dnf install google-chrome-stable

I also needed ChromeDriver, which implements WebDriver's wire protocol for Chrome. In other words, it's the means by which Selenium talks with Chrome:

    wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip
    unzip chromedriver_linux64.zip

I put it under `/usr/bin`:

    sudo chown root:root chromedriver
    sudo chmod 755 chromedriver
    sudo mv chromedriver /usr/bin/

I downloaded Selenium server:

    wget https://selenium-release.storage.googleapis.com/3.14/selenium-server-standalone-3.14.0.jar

This version of Selenium requires Java version 8, which I installed via its package:

    sudo dnf install java-1.8.0-openjdk

Finally I launched Selenium server:

    java -Dwebdriver.chrome.driver=/usr/bin/chromedriver -jar selenium-server-standalone-3.14.0.jar

This must be running in order for Perl to communicate with Chrome using Selenium.

A basic spider
--------------
I wrote a basic spider script, here's a simplified version:

```perl
#!/usr/bin/env perl
use Selenium::Remote::Driver;
use Encode 'encode';

my $driver = Selenium::Remote::Driver->new(
  browser_name => 'chrome',
  extra_capabilities => { chromeOptions => {args => [
    'window-size=1920,1080',
    'headless',
  ]}},
);

my %visited = ();
my $depth = 1;
my $url = 'https://example.com';

spider_site($driver, $url, $depth);

$driver->quit();
```

This script initializes a `Selenium::Remote::Driver` object. Note how it passes options to Chrome: the `window-size` option is an example of a key-pair option, whereas `headless` is a boolean. Chrome accepts a _lot_ of [options](https://peter.sh/experiments/chromium-command-line-switches/). Some others which were useful for me:

* `allow-running-insecure-content` - let Chrome load websites with invalid security certificates
* `disable-infobars` - disable the "Chrome is being controlled by software" notification
* `no-sandbox` - disable the sandbox security feature, lets you run headless Chrome as root

The script initializes a `%visited` hash to store URLs the browser visits, to avoid requesting the same URL twice. The `$depth` variable determines how many levels deep the spider should go: with a value of 1 it will visit all links on the first page it loads, but none after that. The `$url` variable determines the starting web page to visit.

The `spider_site` function is recursive:

```perl
sub spider_site {
  my ($driver, $url, $depth) = @_;
  warn "fetching $url\n";
  $driver->get($url);
  $visited{$url}++;

  my $text = $driver->get_body;
  print encode('UTF-8', $text);

  if ($depth > 0) {
    my @links = $driver->find_elements('a', 'tag_name');
    my @urls = ();
    for my $l (@links) {
      my $link_url = eval { $l->get_attribute('href') };
      push @urls, $link_url if $link_url;
    }
    for my $u (@urls) {
      spider_site($driver, $u, $depth - 1) unless ($visited{$u});
    }
  }
}
```

It fetches the given `$url`, printing the text content of the webpage to STDOUT. It encodes the output before printing it: I found this was necessary to avoid multibyte encoding issues. If the spider hasn't reached full depth, it gets all links on the page, and spiders each one that it hasn't already visited. I wrapped the `get_attribute` method call in `eval` because it can fail if the link disappears from the website after it was found.

An improved spider
------------------
The spider script shown above is functional but rudimentary. I wrote a more [advanced](https://gist.github.com/dnmfarrell/5dde6d3957bf9ae037e170cdb44f75a5) one that has some nice features:

* Pings Selenium server on startup and quits if it's not responding
* Restricts the links followed to those which match the domain of the starting URL to avoid downloading content from unrelated websites
* Converts static variables like `$depth` into command line options
* Adds a debugging mode to print out the decisions made by the spider
* Accepts a list of URLs instead of just one at a time
* Spiders URLs in parallel using [Parallel::ForkManager]({{< mcpan "Parallel::ForkManager" >}})
* Prints website content as gzipped files to separate content from different starting URLs _and_ save disk space

There are other improvements I'd like to make, but those were enough to get the job done.
