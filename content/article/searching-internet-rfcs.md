Since my first days studying computer security, the concept of "protocol" fascinated me. Maybe for their enormous diffusion in almost every computer system,in fact  our daily lives heavily depends from these mathematical-logical processes. As I say "trust on machines but don't trust humans", this because if machines are programmed correctly, there won't be any problems related to security, the problem comes when us write code.

Returning to us,during the quarantine I was able to find the good side of the home confination: effectively I hadn't enough time to read an entire book due to school's tests, but for my luck, I had enough time for reading one or two _Request For Comments_ (RFC) documents.

What are RFCs?
--------------

"Request For Comments" are one of the best online references for learning how networking really works internally, this guarantee a complete and an in-depth approach, which can be extremely helpfull for understanding which operations are executed in our computer daily routine.
Essentially RFCs are simply text documents which define every single standard that has been approved by the Internet Engineering Task Force (IETF). Obviously These documents are a good entry point for developing the philosophy and the main idea of the _protocol analysis_: an emerging security field which uses logic instructions and an high level of abstraction for evaluating  the security of the specified protocol.

Every RFC has a title and its associated number, for example the RFC 3607 is the "Chinese Lottery Cryptanalysis Revisited: The Internet as a Codebreaking Tool", in a more perl-ish notation this would be equal to:

```perl
my %RFC = (
  $number => $name,
);
```

The official  [IETF website](https://www.ietf.org) is a great resource for finding RFCs, but lacks some "preview" features, which complicate the documents search.

For this reason I decided to create a fast and efficient script which permits to download RFCs through a keyword and lets decide the user which document wants to read ( and  at a later time, to save ) and which ones to ignore (and delete).

My script uses [Net::RFC::Search]({{< mcpan "Net::RFC::Search" >}}) as back-end search engine, and [Term::ANSIColor]({{< mcpan "Term::ANSIColor" >}}) for the display—there will be a lot of text in the terminal and different colors can help to distinguish the various informations!.

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

Running the program requires the directory name for saving the files and a query. if the folder doesn't exists, automatically will be created one.

```
$ ./rfc_search rfcs cookie
```

I've also decided to display only the first 25 lines of each matching RFC and prompt to save it.

![](/images/searching_internet_rfcs/searching.gif)

How it works
------------

The `search_by_header` returns the RFC numbers for each of the documents that has the query word:

```perl
my @rfc_nums = $rfc_interface->search_by_header( $query );
```

Then, I fetch each document by specifying its number and local filename. I do this even if I won't keep it because I don't know what's in it yet:

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

I made this simple script mainly for save time and have a better interface for interacting with the RFC site, I want to recommend to see the TODO part in the [Net::RFC::Search]({{< mcpan "Net::RFC::Search" >}}) page. 
For a better script, it would be cool to implement `curl` and `lynx` to retrieve cancelled RFC's, this an optional part which could be a good exercise for extending the script. 


**resources**
- [Request for Comments: User Stories and Scenarios](https://blogs.helsinki.fi/mildred/2017/01/31/request-for-comments-user-stories-and-scenarios/)
- [Wikipedia's RFC entry](https://en.wikipedia.org/wiki/Request_for_Comments)
