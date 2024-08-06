  {
    "title"       : "Deploying Dancer Apps (Addendum)",
    "authors"     : ["dave-cross"],
    "date"        : "2024-08-06T16:49:00",
    "tags"        : ["devops", "deployment", "dancer", "psgi"],
    "draft"       : false,
    "image"       : "/images/deploying-dancer-apps/deploying-dancer-apps.png",
    "thumbnail"   : "/images/deploying-dancer-apps/thumb-deploying-dancer-apps.png",
    "description" : "Some more thoughts about deploying Dancer apps as persistent daemons",
    "categories"  : "tooling"
  }

*This article was originally published at
[Perl Hacks](https://perlhacks.com/2024/08/deploying-dancer-apps-addendum/).*

---

Back in May, I wrote a blog post about how [I had moved a number of Dancer2
applications](https://www.perl.com/article/deploying-dancer-apps/) to a new
server and had, in the process, created a standardised procedure for
deploying Dancer2 apps. It’s been about six weeks since I did that and I
thought it would be useful to give a little update on how it all went and
talk about a few little changes I’ve made.

I mentioned that I was moving the apps to a new server. What I didn’t say was
that I was convinced my old server was overpowered (and overpriced!) for what
I needed, so the new server has less RAM and, I think, a slower CPU than the
old one. And that turned out to be a bit of a problem. It turned out there
was a time early each morning when there were too many requests coming into
the server and it ran out of memory. I was waking up most days to a dead
server. My previous work meant that fixing it wasn’t hard, but it really
wasn’t something that I wanted to do most mornings.

So I wanted to look into reducing the amount of memory used by the apps. And
that turned out to be a two-stage approach.

You might recall that the apps were all controlled using a standardised
driver program called “app_service”. It looked like this:

```perl
#!/usr/bin/env perl
 
use warnings;
use strict;
use Daemon::Control;
 
use ENV::Util -load_dotenv;
 
use Cwd qw(abs_path);
use File::Basename;
 
Daemon::Control->new({
  name      => ucfirst lc $ENV{KLORTHO_APP_NAME},
  lsb_start => '$syslog $remote_fs',
  lsb_stop  => '$syslog',
  lsb_sdesc => 'Advice from Klortho',
  lsb_desc  => 'Klortho knows programming. Listen to Klortho',
  path      => abs_path($0),
 
  program      => '/usr/bin/starman',
  program_args => [ '--workers', 10, '-l', ":$ENV{KLORTHO_APP_PORT}",
                    dirname(abs_path($0)) . '/app.psgi' ],
 
  user  => $ENV{KLORTHO_OWNER},
  group => $ENV{KLORTHO_GROUP},
 
  pid_file    => "/var/run/$ENV{KLORTHO_APP_NAME}.pid",
  stderr_file => "$ENV{KLORTHO_LOG_DIR}/error.log",
  stdout_file => "$ENV{KLORTHO_LOG_DIR}/output.log",
 
  fork => 2,
})->run;
```

We’re deferring most of the clever stuff to
[Daemon::Control](https://metacpan.org/pod/Daemon::Control). But we’re
building the parameters to pass to the constructor. And two of the parameters
(“program” and “program_args”) control how the service is run. You’ll see
I’m using Starman. The first fix was obvious when you look at my code.
Starman is a pre-forking server and we always start with 10 copies of the
app. Now, I’m very proud of some of my apps, but I think it’s optimistic
to think my Klortho server will ever need to respond to 10 simultaneous
requests. Honestly, I’m pleasantly surprised if it gets 10 requests in a
month. So the first change was to make it easy to change the number of
workers.

In the previous article, I talked about using
[ENV::Util](https://metacpan.org/pod/ENV::Util) to load environment variables
from a “.env” file. And we can continue to use that approach here. I
rewrote the “program_args” code to be this:

```perl
program_args => [ '--workers', ($ENV{KLORTHO_APP_WORKERS} // 10),
                  '-l', ":$ENV{KLORTHO_APP_PORT}",
                  dirname(abs_path($0)) . '/app.psgi' ],
```

I made similar changes to all the “app_service” files, added appropriate
environment variables to all the “.env” files and restarted all the
apps. Immediately, I could see an improvement as I was now running maybe
a third of the app processes on the server. But I felt I could do better.
So I had a close look at the Starman documentation to see if there was
anything else I could tweak. That’s when I found the “–preload-app”
command-line option.

Starman works by loading a main driver process which then fires up as many
worker processes as you ask it for. Without the “–preload-app” option,
each of those processes loads a copy of the application. But with this
option, each worker process reads the main driver’s copy of the
application and only loads its own copy when it wants to write something.
This can be a big memory saving – although it’s important to note that the
documentation warns:

> Enabling this option can cause bad things happen when resources like sockets
> or database connections are opened at load time by the master process and
> shared by multiple children.

I’m pretty sure that most of my apps are not in any danger here, but I’m
keeping a close eye on the situation and if I see any problems, it’s easy
enough to turn preloading off again.

When adding the preloading option to “app_service”, I realised I should
probably completely rewrite the code that builds the program arguments. It
now looks like this:

```perl
my @program_args;
if ($ENV{KLORTHO_WORKER_COUNT}) {
  push @program_args, '--workers', $ENV{KLORTHO_WORKER_COUNT};
}
if ($ENV{KLORTHO_APP_PORT}) {
  push @program_args, '-l', ":$ENV{KLORTHO_APP_PORT}";
}
if ($ENV{KLORTHO_APP_PRELOAD}) {
  push @program_args, '--preload-app';
}
push @program_args, dirname(abs_path($0)) . '/bin/app.psgi';
```

The observant among you will notice that I’ve subtly changed the behaviour
of the worker count environment variable. Previously, a missing variable
would use a default value of 10. Now, it just omits the argument which
uses Starman’s default value of 5.

I’ve made similar changes in all my “app_service” programs and set
environment variables to turn preloading on. And now my apps use
substantially less memory. The server hasn’t died since I implemented this
stuff at the start of this week. So that makes me very happy.

But programming is the pursuit of minimisation. I’ve already seen two places
where I can make these programs smaller and simpler.

1. That last code snippet looks too repetitive. It should be a loop 
   iterating over a hash. The keys are the names of the environment variables 
   and the values are references to arrays containing the values that are added to the 
   program arguments if that environment variable is set.

1. I now have five or six “app_service” programs that look very similar.
   I must be able to turn them into one standard program. Do those environment
   variables really need to include the application name?

The [Klortho service driver program](https://github.com/davorg/klortho/blob/master/app_service)
is on GitHub. Can you suggest any more improvements?

