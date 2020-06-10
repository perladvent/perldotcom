
  {
    "title"       : "A tour with Net::FTP",
    "authors"     : ["thibault-duponchelle"],
    "date"        : "2020-05-31T11:48:52",
    "tags"        : ["FTP", "Net::FTP", "pure-ftpd"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "/images/a-tour-with-net-ftp/kidyes.jpg",
    "description" : "Install and configure a FTP server then access it with Net::FTP",
    "categories"  : "development"
  }

When we want to have a way to exchange files between machines, we often think about rsync, scp, git or even something slow and complex (looking at you Artifactory and S3), but the answer is often right in front of your eyes: **FTP**!

The **"File Transfer Protocol"** provides a very simple and convenient way to share files. It's battle-tested, requires almost no maintenance, and has a simple anonymous access mechanism.

It can be integrated with several standard auth methods and even some virtual ones, none of which I show here.

![](/images/a-tour-with-net-ftp/battlereadymeow.jpeg)

In this article, I'll install a local **FTP server** and create a simple **FTP client in Perl**.

## A bit of context

### Developers develop
I initially came to this development because I needed to backup **configuration files**.

At `$work` I have to carry on an army of developers that need to compile their code.

As a very first step they can build locally on their laptop : in the past it was in a **specially prepared GNU/Linux environment with synchronization** of some heavy deps, now it's more inside **docker images** that mimics a build server.

It's for development, but when it comes to share their code with others, they request a merge and we have some **classic pipelines checks** (warnings, coverage etc...) and **build** against production level on some *"official"* build systems.

### Customized automation workspaces
In between *local* and *official* buid, we had something else, with a mix of all these notions.

It is an **user customized build system** based on automation framework and build servers.

The user can use semi official **build systems** with a build flow close to *"official"* one but with more customization possibilities.

From a developer point of view, the design is :
1. The developer writes a **configuration file** to list modules and versions to use, eventually overriding flags and various options
2. The developer gives the **configuration file** to a script that connects to automation server and creates the project and jobs thanks to API calls and using templates (that we prepared)
3. The user then can build his project with a **"push button"** approach. He has **history**, **status**, **logs** and can **deliver** for test systems loads.

The **job templates** are centralized to easy maintenance and evolution but the configurations files were totally **"out of control"** (no backup and no generation possible from the workspaces).

A big new kind of support then appeared and occupied us a lot, it consisted in 2 things :
1. Help users to write their "configuration files" : explaining/linking the spec documentation
2. Debug job failures

We have 2 types of developers concerning (1) : the ones that ask before trying (bad) and the ones that ask after trying and because they failed (better).

To help them, the key is almost always the "config file" that we needed to **check**, **replay**, **edit** and **give back** to user.

### Use case
Here comes into play the file transfer use case :)

I got the idea to transfer the config files to a centralized repository so that we keep a trace of what config file corresponds to what workspace.

It was a good idea that solves a lot of problems like :
- When I browse workspaces, I can **check the configuration file** that produced it
- If a user has trouble to create his workspace, I can **test his config file** without asking him the file
- The repository that contains configuration files is **public** and this collection of samples **helps users** when they want to create their config (reuse of compare existing configs)

In term of constraints, the origin of the transfer could be a variable place (either a dev server or a laptop) with variable user (project user or personal user) transfered to a centralized place that we can then periodically backup.

We were not interested in keeping the file ownership, even the contrary as it is more an annoyance than something else. And... `ftp` is also a solution for this need.

### Let's do it
Instead of only doing bulk backup of config files, I took the opportunity to design a more smart tool with various operations like create/update/delete workspaces :
- **CREATION** : creates a remote ftp directory named from the workspace `NAME` (unique name), save `CONFIG` inside (the config file), save `$USER` in a `AUTHOR` file and add a comment in a `CHANGELOG`
- **UPDATE** : updates `CONFIG` file, and add a comment in `CHANGELOG`
- **DELETE** : adds a comment in `CHANGELOG` and remove all other files

On server side, I put all these in git repository then croned an autocommit every 5 minutes using [git-credential-cache](https://git-scm.com/docs/git-credential-cache) to manage credentials.

The `git` repository is perfect to publish our collection of config files and easily follow config changes. And of course, if there is no change, nothing is commited.

To finish about this long story, I added a small cron to check that `ftpd` is alive and restart it if needed and we are all good.

This setup was installed maybe 8 years ago, and we had **ZERO** maintenance since then...

I MEAN REALLY ZERO MAINTENANCE !

![](/images/a-tour-with-net-ftp/toolowmaintenance.jpg)


## Download and install ftpd

I decided to use [pure-ftpd](https://www.pureftpd.org/project/pure-ftpd/) but there are some other good alternatives if you want.

First I download the tarball, untar it, and change into its directory:

```bash
$ wget https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.49.tar.gz
$ tar xvzf pure-ftpd-1.0.49.tar.gz
$ cd pure-ftpd-1.0.49/
```

I'll configure `ftpd` so I can execute it as casual (non-root) user using a non-restricted port, and I'll set the destination directory to my `$HOME/ftpd` :

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

First, I'll test with the preinstalled `ftp` client. If everything is fine I'll see the typical FTP exchange:


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

[Net::FTP](h{{</* mcpan "Net::FTP" */>}}) is a superb [CPAN](https://metacpan.org/) module dedicated to FTP protocol and I'll use that.

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

What next  Maybe upload something? Again, it's super simple. Instead of listing files, I'm `put`ting them:

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

I propose a more complete client with some command-line parsing and more actions. In addition to the previous code for listing and uploading, here I added a way to view a file. [Getopt::Long]({{</* mcpan "Getopt::Long" */>}}) to handle command line parameters.

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

This thin wrapper can be extended to do more tasks, such as checking allowed or disallowed name patterns or tidying files depending the uploader or the prefix in the name of the file.

Remember, this is only on the client side! If you want real garantees you would better have to implement some kind of protections on the server side too. But, the goal was not to discuss security here but to play with FTP! And I hope you had a pleasant tour with me and [Net::FTP]({{</* mcpan "Net::FTP" */>}})!

