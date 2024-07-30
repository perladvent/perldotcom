{
   "image" : "/images/a-tour-with-net-ftp/kidyes.jpg",
   "thumbnail" : "/images/a-tour-with-net-ftp/thumb_kidyes.jpg",
   "date" : "2020-07-13T11:48:52",
   "categories" : "development",
   "title" : "A tour with Net::FTP",
   "tags" : [
      "ftp",
      "net-ftp",
      "pure-ftpd"
   ],
   "draft" : false,
   "description" : "How to write an FTP client in Perl",
   "authors" : [
      "thibault-duponchelle"
   ]
}

When we want to have a way to exchange files between machines, we often think about rsync, scp, git or even something slow and complex (looking at you Artifactory and S3), but the answer is often right in front of your eyes: FTP!

The "File Transfer Protocol" provides a very simple and convenient way to share files. It's battle-tested, requires almost no maintenance, and has a simple anonymous access mechanism. It can be integrated with several standard auth methods and even some virtual ones, none of which I show here.

![](/images/a-tour-with-net-ftp/battlereadymeow.jpeg)

In this article, I'll install a local FTP server and create a simple FTP client in Perl.

## A bit of context

At `$work` I have to carry on an army of developers that create customized build pipelines from handcrafted local configuration files.

This file is not hosted "by design" like you would have with Travis CI or a GitHub Action, but it is used to feed a "heavy client" that parses, resolves templates, and creates a workspace in some centralized automations servers through HTTP API calls.

It was a lot of support to help developers to create this file according to the spec (yet another file format), and we were blind when we wanted to help them with failing workspace creation/build (no way to retrieve configuration from workspace).

I got the idea to backup and centralize automatically the configuration file during the creation of the build pipeline workspace. It was intended to help both developers (configuration "samples") and support team (see history, versioned then we can check diffs, file to replay). The constraints were to be able to exchange file from various places with variable users. The FTP protocol is a perfect fit for that.

I added also a cronjob to autocommit and push to a git repository and we had magically a website listing versioned configurations files.

In addition, FTP proved later to also require zero support. I mean really zero maintenance!

![](/images/a-tour-with-net-ftp/toolowmaintenance.jpg)

## Download and install ftpd

I decided to use [pure-ftpd](https://www.pureftpd.org/project/pure-ftpd/) but there are some other good alternatives if you want.

First I download the tarball, untar it, and change into its directory:

```bash
$ wget https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.49.tar.gz
$ tar xvzf pure-ftpd-1.0.49.tar.gz
$ cd pure-ftpd-1.0.49/
```

I configure `ftpd` so I can execute it as casual (non-root) user using a non-restricted port, and I'll set the destination directory to my `$HOME/ftpd` :

```bash
$ ./configure --prefix=$HOME/ftpd --with-nonroot && make && make install
```

I create two directories. The _ftp_ is what I'll publish and _run_ is where I'll put the pidfile.

```bash
$ cd $HOME/ftpd
$ mkdir ftp
$ mkdir run
```

Now we can start the ftp server. I need to give some custom configurations:

* `FTP_ANON_DIR` is the directory I want to publish
* `-e` allows anonymous access
* `-M` allows anonymous users to create directories
* `-g` specifies the directory for the pidfile:

```bash
$ FTP_ANON_DIR=`pwd`/ftp ; ./sbin/pure-ftpd -e -M -g run &
```

At this point I should have a running ftp server. Let's check!

## Test with ftp

First, I test with the preinstalled `ftp` client. If everything is fine I see the typical FTP exchange:


```bash
$ ftp localhost 2121
Connected to localhost.
220---------- Welcome to Pure-FTPd ----------
220-You are user number 1 of 50 allowed.
220-Local time is now 11:56. Server port: 2121.
220-Only anonymous FTP is allowed here
220 You will be disconnected after 15 minutes of inactivity.
Name (localhost:tib):
230 Anonymous user logged in
Remote system type is UNIX.
Using binary mode to transfer files.
ftp>
```

If I get `ftp: connect: Connection refused` it's probably one of:

* `ftpd` is not running (check with `ps aux | grep "ftp[d]"`)
* I'm using the wrong port

If I get `421 Can't change directory to /home/tib/ftpd/ftp/ [/]` it's probably because I haven't created the directory I specified in `FTP_ANON_DIR`.

## Simple client in Perl

Ok that's cool, but I only played with ftp server and preinstalled `ftp` client until now. What about writing some Perl now?

![](/images/a-tour-with-net-ftp/whatif.jpg)

[Net::FTP]({{< mcpan "Net::FTP" >}}) is a superb [CPAN](https://metacpan.org/) module dedicated to FTP protocol and I'll use that.

### Simple listing

First, a very simple listing script `ls.pl`. This program connects to the server, asks for a list of files, and outputs each one. It's clear that's super easy and straightforward to play with FTP in Perl!

```perl
#!/usr/bin/env perl

use warnings;
use strict;

use Net::FTP;
my $HOST = "localhost";
my $PORT = 2121;


my $ftp = Net::FTP->new($HOST, Port => $PORT, Debug => 0)
	or die "Cannot connect to $HOST: $@";
$ftp->login() or die "Cannot login ", $ftp->message;
foreach my $f ($ftp->ls()) { print "$f\n"; }
$ftp->quit;
```

### Upload

What next?  Maybe upload something? Again, it's super simple. Instead of listing files, I'm `put`ting them:

```perl
#!/usr/bin/env perl

use warnings;
use strict;

use Net::FTP;
my $HOST = "localhost";
my $PORT = 2121;

my $ftp = Net::FTP->new($HOST, Port => $PORT, Debug => 0)
	or die "Cannot connect to $HOST: $@";
$ftp->login() or die "Cannot login ", $ftp->message;
foreach my $file(@ARGV) {
    $ftp->put("$file", "$file")
    	or die "Cannot put $file", $ftp->message;
}
$ftp->quit;
```

I run this and supply the files I want to upload:

```bash
$ perl upload.pl file1.txt file2.txt`.
```

## Put things together

I propose a more complete client with some command-line parsing and more actions. In addition to the previous code for listing and uploading, here I added a way to view a file. [Getopt::Long]({{< mcpan "Getopt::Long" >}}) to handle command line parameters.

```perl
#!/usr/bin/env perl

use warnings;
use strict;

use Getopt::Long;
use File::Slurp;

use Net::FTP;
my $HOST = "localhost";
my $PORT = 2121;

my %options = ();

GetOptions(
	"action|c=s" => \$options{'action'},
	"file|f=s"   => \$options{'file'},
	"help|h"     => \$options{'help'}
	);

sub print_usage() {
	print "List all files :\n\t$0 -c list\n";
	print "Upload file :\n\t$0 -c upload -f file.txt\n";
	print "Print file :\n\t$0 -c view -f file.txt\n\n";
}

sub get_ftp() {
	my $ftp = Net::FTP->new($HOST, Port => $PORT, Debug => 0)
		or die "Cannot connect to $HOST: $@";
	$ftp->login() or die "Cannot login ", $ftp->message;
}

# ls / on remote ftp
sub list() {
	my $ftp = get_ftp();
	foreach my $f ($ftp->ls()) { print "$f\n"; }
	$ftp->quit;
}

# Upload a file
sub upload($) {
	my $file = shift;
	(-e $file) or return 1;

	my $ftp = get_ftp();
	$ftp->login() or die "Cannot login ", $ftp->message;
	$ftp->put("$file") or die "Cannot put $file ", $ftp->message;
	$ftp->quit;
}

# Read a file
sub view($) {
	my $file = shift;

	my $ftp = get_ftp();
	$ftp->get("$file") or die "Cannot read $file ", $ftp->message;
        if(-e $file) { print read_file($file); }
	$ftp->quit;
}

if($options{'action'} eq 'list') {
	list();
} elsif($options{'action'} eq 'upload') {
	upload($options{'file'});
} elsif($options{'action'} eq 'view') {
	view($options{'file'});
} else {
	print_usage();
}
```

## More about design and security

This thin wrapper can be extended to do more tasks, such as checking allowed or disallowed name patterns or tidying files depending the uploader or the prefix in the name of the file. Remember, this is only on the client side! If you want real garantees you would better have to implement some kind of protections on the server side too. But, the goal was not to discuss security here but to play with FTP! And I hope you had a pleasant tour with me and [Net::FTP]({{< mcpan "Net::FTP" >}})!

