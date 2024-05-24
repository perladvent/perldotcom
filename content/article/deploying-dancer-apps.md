
  {
    "title"       : "Deploying Dancer Apps",
    "authors"     : ["dave-cross"],
    "date"        : "2024-05-23T16:32:11",
    "tags"        : ["devops", "deployment", "dancer", "psgi"],
    "draft"       : false,
    "image"       : "/images/deploying-dancer-apps/deploying-dancer-apps.png",
    "thumbnail"   : "/images/deploying-dancer-apps/thumb-deploying-dancer-apps.png",
    "description" : "Some thoughts about deploying Dancer apps as persistant daemons",
    "categories"  : "tooling"
  }

# Deploying Dancer Apps

Over the last week or so, as a background task, I've been moving domains
from an old server to a newer and rather cheaper server. As part of this
work, I've been standardising the way I deploy web apps on the new
server and I thought it might be interesting to share the approach I'm
using and talking about a couple of CPAN modules that are making my life
easier.

As an example, let's take my Klortho app. It dispenses useful (but
random) programming advice. It's a Dancer2 app that I wrote many years
ago and have been lightly poking at occasionally since then. The [code
is on GitHub](https://github.com/davorg/klortho) and it's currently
running at [klortho.perlhacks.com](https://klortho.perlhacks.com/). It's
a simple app that doesn't need a database, a cache or anything other
than the Perl code.

Dancer apps are all built on PSGI, so they have all of the deployment
flexibility you get with any PSGI app. You can take exactly the same
code and run it as a CGI program, a mod_perl handler, a FastCGI program
or as a stand-alone service running behind a proxy server. That last
option is my favourite, so that's what I'll be talking about here.

Starting a service daemon for a PSGI app is simple enough -- just
running "plackup app.psgi" is all you really need. But you probably
won't get a particularly useful service daemon out of that. For example,
you'll probably get a non-forking server that will only respond to a
single request at a time. It'll be good enough for testing, but you'll
want something more robust for production. So you'll want to tell
"plackup" to use [Starman](https://metacpan.org/pod/Starman) or
something like that.  And you'll want other options to tell the service
which port to run on. You'll end up with a quite complex start-up
command line to start the server. So, if you're anything like me, you'll
put that all in a script which gets added to the code repo.

But it's still all a bit amateur. Linux has a flexible and sophisticated
framework for starting and stopping service daemons. We should probably
look into using that instead. And that's where my first module
recommendation comes into play
-- [Daemon::Control](https://metacpan.org/pod/Daemon::Control).
Daemon::Control makes it easy to create service daemon control scripts
that fit in with the standard Linux way of doing things. For example, my
Klortho repo contains a file called
[klortho_service](https://github.com/davorg/klortho/blob/master/bin/klortho_service)
which looks like this:


```perl
#!/usr/bin/env perl

use warnings;
use strict;
use Daemon::Control;

use ENV::Util –load_dotenv;

use Cwd qw(abs_path);
use File::Basename;

Daemon::Control->new({
  name      => ucfirst lc $ENV{KLORTHO_APP_NAME},
  lsb_start => ‘$syslog $remote_fs’,
  lsb_stop  => ‘$syslog’,
  lsb_sdesc => ‘Advice from Klortho’,
  lsb_desc  => ‘Klortho knows programming. Listen to Klortho’,
  path      => abs_path($0),

  program      => ‘/usr/bin/starman’,
  program_args => [ ‘–workers’, 10, ‘-l’, “:$ENV{KLORTHO_APP_PORT}”,
                    dirname(abs_path($0)) . ‘/app.psgi’ ],

  user  => $ENV{KLORTHO_OWNER},
  group => $ENV{KLORTHO_GROUP},

  pid_file    => “/var/run/$ENV{KLORTHO_APP_NAME}.pid”,
  stderr_file => “$ENV{KLORTHO_LOG_DIR}/error.log”,
  stdout_file => “$ENV{KLORTHO_LOG_DIR}/output.log”,

  fork => 2,
})->run;
```

This code takes my hacked-together service start script and raises it to
another level. We now have a program that works the same way as other
daemon control programs like "apachectl" that you might have used. It
takes command line arguments, so you can start and stop the service
(with "klortho_service start", "klortho_service stop" and
"klortho_service restart") and query whether or not the service is
running with "klortho_service status". There are several other options,
which you can see with "klortho_service status". Notice that it also
writes the daemon's output (including errors) to files under the
standard Linux logs directory. Redirecting those to a more modern
logging system is a task for another day.

Actually, thinking about it, this is all like the old "System V" service
management system. I should see if there's a replacement that works with
"systemd" instead.

And if you look at line 7 in the code above, you'll see the other CPAN
module that's currently making my life a lot easier --
[ENV::Util](https://metacpan.org/pod/ENV::Util). This is a module that
makes it easy to work with "dotenv" files. If you haven't come across
"dotenv" files, here's a brief explanation -- they're files that are
tied to your deployment environments (development, staging, production,
etc.) and they contain definitions of environment variables which are
used to control how your software acts in the different environments.
For example, you'll almost certainly want to connect to a different
database instance in your different environments, so you would have a
different "dotenv" file in each environment which defines the connection
parameters for the appropriate database in that environment. As you need
different values in different environments (and, also, because you'll
probably want sensitive information like passwords in the file) you
don't want to store your "dotenv" files in your source code control. But
it's common to add a file (called something like ".env.sample") which
contains a list of the required environment variables along with sample
values.

My Klortho program doesn't have a database. But it does need a few
environment variables. Here's its ".env.sample" file:

```bash
export KLORTHO_APP_NAME=klortho
export KLORTHO_OWNER=someone
export KLORTHO_GROUP=somegroup
export KLORTHO_LOG_DIR=/var/log/$KLORTHO_APP_NAME
export KLORTHO_APP_PORT=9999
```

And near the top of my service daemon control program, you'll see the
line:

```perl
use ENV::Util -load_dotenv;
```

That looks to see if there's a ".env" file in the current directory and,
if it finds one, it is loaded and the contents are inserted in the
"%ENV" hash -- from where they can be accessed by the rest of the code.

There's one piece of the process missing. It's nothing clever. I just
need to generate a configuration file so the proxy server (I use
"nginx") reroutes requests to
[klortho.perlhacks.com](https://klortho.perlhacks.com/) so that they're
processed by the daemon running on whatever port is configured in
"KLORTHO_APP_PORT". But "nginx" configuration is pretty well-understood
and I'll leave that as an exercise for the reader (but feel free to get
in touch if you need any help).

So that's how it works. I have about half a dozen Dancer2 apps running
on my new server using this layout. And knowing that I have standardised
service daemon control scripts and "dotenv" files makes looking after
them all far larger.

And before anyone mentions it, yes, I should rewrite them so they're all
Docker images. That's a work in progress. And I should run them on some
serverless system. I know my systems aren't completely up to date. But
we're getting there.

If you have any suggestions for improvement, please let me know.

---

This article was originally published at
[Perl Hacks](https://perlhacks.com/2024/05/deploying-dancer-apps/).
