{
   "authors" : [
      "chris-ball"
   ],
   "description" : " Screen-scraping is the process of emulating an interaction with a Web site - not just downloading pages, but filling out forms, navigating around the site, and dealing with the HTML received as a result. As well as for traditional...",
   "image" : null,
   "draft" : null,
   "thumbnail" : "/images/_pub_2003_01_22_mechanize/111-mechanize.gif",
   "categories" : "web",
   "date" : "2003-01-22T00:00:00-08:00",
   "slug" : "/pub/2003/01/22/mechanize",
   "tags" : [
      "screen-scraping-web-mechanize"
   ],
   "title" : "Screen-scraping with WWW::Mechanize"
}





Screen-scraping is the process of emulating an interaction with a Web
site - not just downloading pages, but filling out forms, navigating
around the site, and dealing with the HTML received as a result. As well
as for traditional lookups of information - like the example we'll be
exploring in this article - we can use screen-scraping to enhance a Web
service into doing something the designers hadn't given us the power to
do in the first place. Here's an example:

I do my banking online, but get quickly bored with having to go to my
bank's site, log in, navigate around to my accounts and check the
balance on each of them. One quick Perl module
([`Finance::Bank::HSBC`](http://search.cpan.org/author/CHRIS/Finance-Bank-HSBC-1.01/HSBC.pm))
later, and now I can loop through each of my accounts and print their
balances, all from a shell prompt. Some more code, and I can do
something the bank's site doesn't ordinarily let me - I can treat my
accounts as a whole instead of individual accounts, and find out how
much money I have, could possibly spend, and owe, all in total. Another
step forward would be to schedule a *crontab* every day to use the HSBC
option to download a copy of my transactions in Quicken's QIF format,
and use Simon Cozens'
[`Finance::QIF`](http://search.cpan.org/author/SIMON/Finance-QIF-1.00/QIF.pm)
module to interpret the file and run those transactions against a
budget, letting me know whether I'm spending too much lately. This takes
a simple Web-based system from being merely useful to being automated
and bespoke; if you can think of how to write the code, then you can do
it. (It's probably wise for me to add the caveat, though, that you
should be extremely careful working with banking information
programatically, and even more careful if you're storing your login
details in a Perl script somewhere.)

Back to screen-scrapers, and introducing
[`WWW::Mechanize`](http://search.cpan.org/author/PETDANCE/WWW-Mechanize-0.33/lib/WWW/Mechanize.pm),
written by Andy Lester and based on Skud's
[](http://search.cpan.org/author/SKUD/WWW-Automate-0.20/lib/WWW/Automate.pm)`WWW::Automate`.
Mechanize allows you to go to a URL and explore the site, following
links by name, taking cookies, filling in forms and clicking "submit"
buttons. We're also going to use
[`HTML::TokeParser`](http://search.cpan.org/author/GAAS/HTML-Parser-3.27/lib/HTML/TokeParser.pm)
to process the HTML we're given back, which is a process I've written
about [previously](/pub/a/2001/11/15/creatingrss.html).

The site I've chosen to demonstrate on is the BBC's [Radio
Times](http://www.radiotimes.beeb.com) site, which allows users to
create a "Diary" for their favorite TV programs, and will tell you
whenever any of the programs is showing on any channel. Being a [London
Perl M\[ou\]nger](http://london.pm.org/), I have an obsession with Buffy
the Vampire Slayer. If I tell this to the BBC's site, then it'll tell me
when the next episode is, and what the episode name is - so I can check
whether it's one I've seen before. I'd have to remember to log into
their site every few days to check whether there was a new episode
coming along, though. Perl to the rescue! Our script will check to see
when the next episode is and let us know, along with the name of the
episode being shown.

Here's the code:

      #!/usr/bin/perl -w
      use strict;

      use WWW::Mechanize;
      use HTML::TokeParser;

If you're going to run the script yourself, then you should register
with the Radio Times site and create a diary, before giving the e-mail
address you used to do so below.

      my $email = ";
      die "Must provide an e-mail address" unless $email ne ";

We create a WWW::Mechanize object, and tell it the address of the site
we'll be working from. The Radio Times' front page has an image link
with an ALT text of "My Diary", so we can use that to get to the right
section of the site:

      my $agent = WWW::Mechanize->new();
      $agent->get("http://www.radiotimes.beeb.com/");
      $agent->follow("My Diary");

The returned page contains two forms - one to allow you to choose from a
list box of program types, and then a login form for the diary function.
We tell WWW::Mechanize to use the second form for input. (Something to
remember here is that WWW::Mechanize's list of forms, unlike an array in
Perl, is indexed starting at 1 rather than 0. Our index is,
therefore,'2.')

      $agent->form(2);

Now we can fill in our e-mail address for the '&lt;INPUT name="email"
type="text"&gt;' field, and click the submit button. Nothing too
complicated.

      $agent->field("email", $email);
      $agent->click();

WWW::Mechanize moves us to our diary page. This is the page we need to
process to find the date details from. Upon looking at the HTML source
for this page, we can see that the HTML we need to work through is
something like:

      <input>
      <tr><td></td></tr>
      <tr><td></td><td></td><td class="bluetext">Date of episode</td></tr>
      <td></td><td></td>
      <td class="bluetext"><b>Time of episode</b></td></tr>
      <a href="page_with_episode_info"></a>

This can be modeled with `HTML::TokeParser` as below. The important
methods to note are `get_tag` - which will move the stream on to the
next opening for the tag given - and `get_trimmed_text`, which returns
the text between the current and given tags. For example, for the HTML
code "&lt;b&gt;Bold text here&lt;/b&gt;",
`my $tag = get_trimmed_text("/b")` would return `"Bold text here"` to
`$tag`.

Also note that we're initializing HTML::TokeParser on
'\\\$agent-&gt;{content}' - this is an internal variable for
WWW::Mechanize, exposing the HTML content of the current page.

      my $stream = HTML::TokeParser->new(\$agent->{content});
      my $date;
      
      # <input>
      $stream->get_tag("input");

      # <tr><td></td></tr><tr>
      $stream->get_tag("tr"); $stream->get_tag("tr");

      # <td></td><td></td>
      $stream->get_tag("td"); $stream->get_tag("td");

      # <td class="bluetext">Date of episode</td></tr>
      my $tag = $stream->get_tag("td");
      if ($tag->[1]{class} and $tag->[1]{class} eq "bluetext") {
          $date = $stream->get_trimmed_text("/td");
          # The date contains '&nbsp;', which we'll translate to a space.
          $date =~ s/\xa0/ /g;
      }
     
      # <td></td><td></td>
      $stream->get_tag("td");

      # <td class="bluetext"><b>Time of episode</b>  
      $tag = $stream->get_tag("td");

      if ($tag->[1]{class} eq "bluetext") {
          $stream->get_tag("b");
          # This concatenates the time of the showing to the date.
          $date .= ", from " . $stream->get_trimmed_text("/b");
      }

      # </td></tr><a href="page_with_episode_info"></a>
      $tag = $stream->get_tag("a");

      # Match the URL to find the page giving episode information.
      $tag->[1]{href} =~ m!src=(http://.*?)'!;

We have a scalar, \$date, containing a string that looks something like
"Thursday 23 January, from 6:45pm to 7:30pm.", and we have an URL, in
\$1, that will tell us more about that episode. We tell WWW::Mechanize
to go to the URL:

      $agent->get($1);

The navigation we want to perform on this page is far less complex than
on the last page, so we can avoid using a TokeParser for it - a regular
expression should suffice. The HTML we want to parse looks something
like this:

      <br><b>Episode</b><br>  The Episode Title<br>

We use a regex delimited with '!' in order to avoid having to escape the
slashes present in the HTML, and store any number of alphanumeric
characters after some whitespace, all between &lt;br&gt; tags after the
Episode header:

      $agent->{content} =~ m!<br><b>Episode</b><br>\s+?(\w+?)<br>!;

\$1 now contains our episode, and all that's left to do is print out
what we've found:

      my $episode = $1;
      print "The next Buffy episode ($episode) is on $date.\n";

And we're all set. We can run our script from the shell:

      $ perl radiotimes.pl
      The next Buffy episode (Gone) is Thursday Jan. 23, from 6:45 to 7:30 p.m.

I hope this gives a light-hearted introduction to the usefulness of the
modules involved. As a note for your own experiments, WWW::Mechanize
supports cookies - in that the requestor is a normal LWP::UserAgent
object - but they aren't enabled by default. If you need to support
cookies, then your script should call "`use HTTP::Cookies;`
`$agent->cookie_jar(HTTP::Cookies->new)`;" on your agent object in order
to enable session-volatile cookies for your own code.

Happy screen-scraping, and may you never miss a Buffy episode again.


