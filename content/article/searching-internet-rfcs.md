{
"categories" : "tooling",
"description" : "A smart way to scrape RFCs",
"draft" : true,
"date" : "2020-09-24T07:28:49",
"authors" : [ "edoardo-mantovani" ],
"title" : "Searching Internet RFCs",
"tags" : [ "Request for Comments", "perl tools","protocols knoweledge" ]
}

During the quarantine I was able to find the good side of the home confination: I hadn't enough time to read a book due to school's tests, but for my luck, I had enough time for reading one or two Request For Comments (RFC) documents.

Since my first days studying computer security, the concept of "protocol" fascinated me. Maybe for their enormous diffusion in almost every computer system, our daily lives heavily depends from these processes. As I say "trust on machines but don't trust humans".
The RFC approach reminds the open source philosophy, which has the same objective (give everyone the opportunity to learn new things through sharing) and the same propagation channel: the internet.

I find it too hard to search for these documents on [the IETF website](https://www.ietf.org), so I made a fast and efficient script that permits me to download RFCs through a keyword and lets me decide which ones to read and which ones to ignore.

What are RFCs?
--------------

"Request For Comments" are one of the best online references for learning how networking really works at the protocol level. These are simply text documents that define every single standard that has been approved by the Internet Engineering Task Force. These documents are a good entry point for developing the study of protocol analysis: an emerging field that uses formal verification to find exploits.

Every RFC has a title and its associated number, for example the RFC 3607 is the "Chinese Lottery Cryptanalysis Revisited: The Internet as a Codebreaking Tool".

My script uses [Net::RFC::Search]({{< mcpan "Net::RFC::Search" >}}) for the search, and [Term::ANSIColor]({{< mcpan "Term::ANSIColor" >}}) for the display—there will be a lot of text in the terminal and different coulrs can help!.

```perl
#!/usr/bin/perl
# Made by Edoardo Mantovani in 2020

use strict;
use warnings;

use File::Path qw(make_path);
use File::Spec::Functions;
use LWP::Protocol::https; # Net::RFC::Search needs this
use Net::RFC::Search;
use Term::ANSIColor;

my $folder = shift or die "./RFC <Folder> <Query>\n";
my $query  = shift or die "./RFC <Folder> <Query>\n";

make_path $folder;

my $rfc_interface = Net::RFC::Search->new();
my @rfc_nums = $rfc_interface->search_by_header( $query );

print "RFCs [@rfc_nums]\n";

foreach my $rfc_num ( @rfc_nums ) {
  my $local_file = catfile( $folder, $rfc_num ); # i.e final folder = /tmp/1110
  if ( $rfc_interface->get_by_index( $rfc_num, $local_file ) ) {
    print colored( "Downloaded: $rfc_num\n", "green" );
    view_rfc( $local_file );
  }
  else {
    print "Error with RFC $rfc_num\n";
  }
}

sub view_rfc {
  my( $file ) = @_;

  open my $fh, '<', $file or do {
    warn "Could not open file [$file]: $!\n";
    return;
  };

  while( <$fh> ) {
  	print;
  	next unless $. == 25;
    print colored("Do you want to save this RFC? [Y/N] ", "red");
    my $input = <STDIN>;
    chomp( $input );
	unlink $file if uc($input) eq "N";
    last;
  }
}
```

Running the program requires a directory name and a query. I create the directory if it doesn't already exist:

```
$ ./rfc_search rfcs cookie
```

I display the first 25 lines of each matching RFC and prompt to save it.

![](/images/searching_internet_rfcs/searching.gif)

How it works
------------

The `search_by_header` returns the RFC numbers for each of the documents that has the query word:

```perl
my @rfc_nums = $rfc_interface->search_by_header( $query );
```

I then fetch each document by specifying its number and local filename. I do this even if I won't keep it because I don't know what's in it yet:

```perl
$rfc_interface->get_by_index( $rfc_num, $local_file );
```

For the last part, I look at the first 25 lines of the file. I have a prompt that asks me if I want to save it. If I enter "N", I delete that file. I color the prompt so I can see it against the RFC text:

```perl
sub view_rfc {
  my( $file ) = @_;

  open my $fh, '<', $file or do {
    warn "Could not open file [$file]: $!\n";
    return;
  };

  while( <$fh> ) {
  	print;
  	next unless $. == 25;
    print colored("Do you want to save this RFC? [Y/N] ", "red");
    my $input = <STDIN>;
    chomp( $input );
    rmtree(@_) if uc($input) eq "N";
    last;
  }
}
```


Other uses and suggestions
--------------------------

I made this simple script mainly for save time and have a better interface for interacting with the RFC site, I want to recommend to see the TODO part in the [Net::RFC::Search]({{< mcpan "Net::RFC::Search" >}}) page. For a better script, it would be cool to implement `curl` and `lynx` to retrieve cancelled RFC's. Of course the script can be implemented with custom functions but this is script is only for educational purposes.

**resources**
- [Request for Comments: User Stories and Scenarios](https://blogs.helsinki.fi/mildred/2017/01/31/request-for-comments-user-stories-and-scenarios/)
- [Wikipedia's RFC entry](https://en.wikipedia.org/wiki/Request_for_Comments)
