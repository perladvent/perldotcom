
  {
    "title"       : "Use terminal colors to distinguish information",
    "authors"     : ["brian d foy"],
    "date"        : "2018-10-03T16:49:36",
    "tags"        : [],
    "draft"       : true,
    "image"       : "/images/use-terminal-colors-to-distinguish-information/packages-at-post-office.jpg",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "development"
  }

The <?{{mcpan Term::ANSIColor}}> module is one of my favorite Perl tools. It doesn't make my program work better but it allows me to quickly identify the output that's important to me without missing out on the other stuff. I recently used it to track the shipments of my latest book.

[Learning Perl 6](https://www.learningperl6.com), was published and the paper versions were available. This meant that I owed about 100 people a signed copy. From my years of publishing a print Perl magazine, I know that physically shipping stuff is an exercise in pain and memory. Did I send the book? When did I send it? I'm never quite sure the task is finished because a parcel might go missing without the recipient realizing they are missing something. Months later I get the complaint. No big whoop—that's life in retail.

I ship these through the US Postal Service and get a tracking number for each parcel. I could check those by hand at the USPS website, but I also wrote the <?{{mcpan Business::US::USPS::WebTools}}> module to handle that for me. I can use the post office's web API (rudimentary as it is) to get the status of packages.

Curiously, this summer I had just given up this module because I didn't want to maintain it anymore. I hadn't used it in a couple of years and the interfaces had changed slightly. A couple weeks later I had another use for it. Go figure. It now lives in the the [CPAN Adoptable Modules](https://github.com/CPAN-Adoptable-Modules) GitHub organization that I set up. If you have repos for modules that you no longer want, let me know about them. I'll pull them into that organization and you can delete them from your own account. Anyone who wants to maintain them later will still find them. And, there's also [GitPAN](https://github.com/gitpan), but that's not quite the same thing.

To use this program, [grab the module sources from GitHub](https://github.com/CPAN-Adoptable-Modules/business-us-usps-webtools). I had to update a few things to make it work and I might even make further changes. Commit 27c9443 from October 2, 2018 should be good. (And yes, it feels very strange not to point to a version on CPAN).

You'll also need credentials from the [WebTools site](https://www.usps.com/business/web-tools-apis/welcome.htm). They make it sound like a government official is going to scrutinize your application but you'll get an email a couple minutes later. No one from the USPS has ever contacted me to ask me what I was doing with the module. But I also like to note that as a curiosity of the US Government, the Post Office has their own police force (mostly for  mail theft or mail fraud). But, I don't need to worry about that because this program is the intended use of the service.

I'll start with a short program that gets the record for a single tracking number. I have my credentials in the environment so I can easily grab them for any other WebTools program I create. This one  prints a summary of the shipment (although there is a chain of steps from acceptance when I drop off the parcel to when they deliver it):

```perl
use v5.28;
use utf8;
use strict;
use warnings;
use lib qw(/path/to/business-us-usps-webtools/lib);

use Business::US::USPS::WebTools::TrackConfirm;

my $tracker = Business::US::USPS::WebTools::TrackConfirm->new( {
	UserID   => $ENV{USPS_WEBTOOLS_USERID},
	Password => $ENV{USPS_WEBTOOLS_PASSWORD},
	} );

my $tracking_number = $ARGV[0];

my $details = $tracker->track( TrackID => $tracking_number );

if( $tracker->is_error ) {
	warn "Oh No! $tracker->{error}{description}\n";
	}
else {
	no warnings 'uninitialized';
	state @keys = qw(EventTime EventDate Event EventCity);
	printf "%-22s %8s %-20s %s %s\n",
		$tracking_number, $details->[0]->@{@keys};
	}
```
The output is servicable but boring (and I've mutated the tracking numbers so they aren't valid and don't represent actual shipments):

	$ perl track-one.pl 84058036993006920289
	84058036993006920289  8:38 am September 14, 2018   Delivered, In/At Mailbox NEW YORK
	$ perl track-one.pl CJ6467937US
	CJ6467937US           9:38 am September 26, 2018   Departed PARIS

Using this program is much quicker than me going to the USPS website to paste numbers into their form. It can be better—what I really want to know is if I need to do anything for a this shipment. I can read the output to figure that out. If it's "Delivered" than I should be fine. If not, it can still be lost. But reading is hard! Adding color to that relieves me of the burden of scanning a whole line of text. The program can read the text for me and categorize it with color.

<?{{mcpan Term::ANSIColor}}> works by outputting [special escape sequences](http://wiki.bash-hackers.org/scripting/terminalcodes) that instruct the (ANSI) terminal to switch colors. The new color is in effect until you output the special reset sequence (or change to another color):

	$ perl -MTerm::ANSIColor=:constants -e 'print RED, "Hello World", RESET'
	Hello World

I can do that in my tracking program. I'll use green to indicate an outstanding shipment (a brighter color on my dark background) and blue (a darker color that subdues the line) to indicate a delivered shipment. I can know the status just by the color:

```perl
use v5.28;
use utf8;
use strict;
use warnings;
use lib qw(/path/to/business-us-usps-webtools/lib);

use Business::US::USPS::WebTools::TrackConfirm;
use Term::ANSIColor;

my $tracker = Business::US::USPS::WebTools::TrackConfirm->new( {
	UserID   => $ENV{USPS_WEBTOOLS_USERID},
	Password => $ENV{USPS_WEBTOOLS_PASSWORD},
	} );

my $tracking_number = $ARGV[0];
my $details = $tracker->track( TrackID => $tracking_number );

if( $tracker->is_error ) {
	warn "Oh No! $tracker->{error}{description}\n";
	}
else {
	no warnings 'uninitialized';
	state @keys = qw(EventTime EventDate Event EventCity );
	print color(
		$details->[0]{Event} =~ m/Delivered/ ? 'blue' : 'green'
		);
	printf "%-22s %8s %-20s %s %s\n", $tracking_number, $details->[0]->@{@keys};
	print color('reset');
	}
```

That's fine, but I don't want to do these individually. I have all the tracking numbers in a file (a spreadsheet really, but that's not important here). I want to check them all at once. I can do that in a `while` loop that takes the lines from standard input. Of course the data are a bit dirty so I remove whitespace (the USPS formats it in different ways on different pages) and then skip lines that are empty. I do have some could that checks the validity of tracking numbers but it's a bit old and doesn't cover some of the new (undocumented) numbers they have been giving me. So, I'm stuck with these simple checks. Otherwise, the program is mostly the same:

```perl
use v5.28;
use utf8;
use strict;
use warnings;
use lib qw(/path/to/business-us-usps-webtools/lib);

use Business::US::USPS::WebTools::TrackConfirm;
use Term::ANSIColor;

my $tracker = Business::US::USPS::WebTools::TrackConfirm->new( {
	UserID   => $ENV{USPS_WEBTOOLS_USERID},
	Password => $ENV{USPS_WEBTOOLS_PASSWORD},
	} );

while( <> ) {
	chomp;
	s/\s+//g;
	next unless length $_;

	my $details = $tracker->track( TrackID => $_ );

	if( $tracker->is_error ) {
		warn "Oh No! $tracker->{error}{description}\n";
		}
	else {
		no warnings 'uninitialized';
		state @keys = qw(EventTime EventDate Event EventCity );
		print color(
			$details->[0]{Event} =~ m/Delivered/ ? 'blue' : 'green'
			);
		printf "%-22s %8s %-20s %s %s\n", $_, $details->[0]->@{@keys};
		print color('reset');
		}

	}
```

Now the outstanding shipments stand out from the delivered ones. Even with the heavily blurred screenshot I can make out which lines are the ones that I want to investigate. I've blurred this image a bit to protect the personal information but even then I can pick out the shipments that are still out there.

![blurred output](/images/use-terminal-colors-to-distinguish-information/blurred-term-ansicolor.png)

It's amazing that this works. The international cooperation for many countries is pretty good. I can get tracking all the way to the final delivery in many countries.

