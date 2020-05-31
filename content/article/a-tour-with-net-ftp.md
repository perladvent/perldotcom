
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

When we want to have a way to exchange files between machines, we often think about rsync, scp, git or even some *over-complex-and-slow-kind-of-fancy-artifacts-repositories* (put the name you want here)...

...but the answer is often right in front of your eyes : **FTP** !

**"Files Transfer Protocol"** means what it means and provides a very simple and convenient way to achieve the task.

In addition it's battle-tested, requires generally almost zero maintenance when in place and provides a simple anonymous access mechanism. 

![](/images/a-tour-with-net-ftp/battlereadymeow.jpeg)

It can be integrated with several standard auth methods and even some virtual one (disconnect users from any auth provider which provides more flexibility)

In the next paragraphs, I will install a FTP server locally (on a GNU/Linux machine) then create a simple FTP client.

## Download and install ftpd

As a `ftpd` I decided to use [pure-ftpd](https://www.pureftpd.org/project/pure-ftpd/) but there are some other good alternatives if you want.

First download the tarball :

```bash
wget https://download.pureftpd.org/pub/pure-ftpd/releases/pure-ftpd-1.0.49.tar.gz
```

Next we untar and go inside the directory newly created directory :
```bash
tar xvzf pure-ftpd-1.0.49.tar.gz
cd pure-ftpd-1.0.49/
```
Next step deserves more details.. 

We will configure `ftpd` so we can execute it as *casual user* (use non restricted port for instance) and we will set the destination directory to our `$HOME/ftpd` :

```bash
./configure --prefix=$HOME/ftpd --with-nonroot && make && make install
```

Then we go there and create 2 directories :

```bash
cd $HOME/ftpd
mkdir ftp
mkdir run
```

`ftp` is what will be published and `run` is where we will put the pidfile.

Now we can start the ftp server. 

We need to give some custom configurations :
* like the `FTP_ANON_DIR` which means **"I want to publish this directory"**
* the `-e` for anonymous access and `-M` to allow anonymous users to create directories 
* and finally the `-g` to change where the ftp server will put the `pidfile`: :

```bash
FTP_ANON_DIR=`pwd`/ftp ; ./sbin/pure-ftpd -e -M -g run &
```

At this point we should have a running ftp server... Let's check !

## Test with ftp

We will test with the preinstalled `ftp` client (command line syntax can change) :

```bash
ftp localhost 2121
```

If everything is fine it will give you :

```bash
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


If you get `ftp: connect: Connection refused` it's because :
* either your ftpd is not running (check with `ps aux | grep "ftp[d]"`) 
* or you're targetting the wrong port (if you forgot `--non-root` configure option your `ftpd` is probably serving on port `21`)

If you get `421 Can't change directory to /home/tib/ftpd/ftp/ [/]` it's probably because you haven't created the directory.

## Simple client in Perl

Ok that's cool but what about writing some Perl now... ? 

![](/images/a-tour-with-net-ftp/whatif.jpg)

We only played with ftp server and preinstalled `ftp` client until now :D 

[Net::FTP](https://metacpan.org/pod/Net::FTP) is a superb [CPAN](https://metacpan.org/) module dedicated to **FTP protocol** and we will use it.

### Simple listing

First a very simple listing script `ls.pl` :

```perl
#!/usr/bin/env perl

use warnings;
use strict;

use Net::FTP;
my $HOST = "localhost";
my $PORT = 2121;


my $ftp = Net::FTP->new($HOST, Port => $PORT, Debug => 0) or die "Cannot connect to $HOST: $@";
$ftp->login() or die "Cannot login ", $ftp->message;
foreach my $f ($ftp->ls()) { print "$f\n"; }
$ftp->quit;
```

Honestly, I don't know what to explain here, variables and functions names are self documenting.

I'ts clear that's super easy and straightforward to play with FTP in Perl ! :D



What next ? Maybe upload something ? :D

### Upload

Here again it is super simple, believe me.

In the `upload.pl` :
```perl
#!/usr/bin/env perl

use warnings;
use strict;

use Net::FTP;
my $HOST = "localhost";
my $PORT = 2121;


my $ftp = Net::FTP->new($HOST, Port => $PORT, Debug => 0) or die "Cannot connect to $HOST: $@";
$ftp->login() or die "Cannot login ", $ftp->message;
foreach my $file(@ARGV) {
    $ftp->put("$file", "$file") or die "Cannot put $file", $ftp->message;
}
$ftp->quit;
```

That you can use like `perl upload.pl file1.txt file2.txt`.

By default, anonymous users can't delete files (but they can overwrite files...).

This setup is for educational purposes, a real life design should configure a bit more the `ftpd` service so it can use **virtual users** (puredb) and/or **chrooting**.
 
## Put things together 

I propose a more complete client with some command line parsing and more actions :

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
	"file|f=s" => \$options{'file'},
	"help|h" => \$options{'help'} 
	);

sub print_usage() { 
	print "List all files :\n\t$0 -c list\n";
	print "Upload file :\n\t$0 -c upload -f file.txt\n";
	print "Print file :\n\t$0 -c view -f file.txt\n\n";
}

# ls / on remote ftp 
sub list() {
	my $ftp = Net::FTP->new($HOST, Port => $PORT, Debug => 0) or die "Cannot connect to $HOST: $@";
	$ftp->login() or die "Cannot login ", $ftp->message;
	foreach my $f ($ftp->ls()) { print "$f\n"; }
	$ftp->quit;
}

# Upload a file
sub upload($) { 
	my $file = shift;

	(-e $file) or return 1;

	my $ftp = Net::FTP->new($HOST, Port => $PORT, Debug => 0) or die "Cannot connect to $HOST: $@";
	$ftp->login() or die "Cannot login ", $ftp->message;
	$ftp->put("$file") or die "Cannot put $file ", $ftp->message;
	$ftp->quit;
} 

# Read a file
sub view($) { 
	my $file = shift;

	my $ftp = Net::FTP->new($HOST, Port => $PORT, Debug => 0) or die "Cannot connect to $HOST: $@";
	$ftp->login() or die "Cannot login ", $ftp->message;
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

This thin wrapper can be extended to do more task like checking allowed/disallowed name patterns or tidying files depending the uploader or the prefix in the name of the file... But remember it's still only on the client side ! 

Then if you want real garantees you would better have to implement some kind of protections on server side. 

It means authenticated connections with virtual users or something else. Eventually homedirs created and chroot per user accessing the ftp server.

And as an extra security activate TLS or use another SFTP implementation (there are multiple). 

Anyway the goal was not to discuss security here but to play with [Net::FTP](https://metacpan.org/pod/Net::FTP) !  

And I hope you had a pleasant tour with me and Net::FTP :D

