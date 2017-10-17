{
   "draft" : false,
   "categories" : "apps",
   "description" : "Introducing every, the cron scheduling app written in Perl",
   "title" : "Schedule jobs like a boss with every",
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "slug" : "55/2013/12/22/Schedule-jobs-like-a-boss-with-every",
   "date" : "2013-12-22T15:08:51",
   "tags" : [
      "linux",
      "sysadmin",
      "config",
      "osx",
      "cron",
      "old_site"
   ]
}


Scheduling jobs on cron is often a trial-and-error process but every, a command line app written in Perl makes it a lot easier.

###### Requirements

You need to have cron, which comes with most Unix-based platforms (e.g. Linux, Mac OSX, BSD) and have Perl installed.

###### Get every

every was developed by [Rebecca](http://re-becca.org/) and is hosted on her [Github](https://github.com/iarna/App-Every) page. You can download it directly from the command line using wget:

``` prettyprint
$ wget 'https://raw.github.com/iarna/App-Every/master/packed/every'
```

Or curl:

``` prettyprint
$ curl -O 'https://raw.github.com/iarna/App-Every/master/packed/every'
```

Save every to /usr/bin or add the parent directory to your PATH variable so you can run every from the command line.

###### Scheduling jobs with every

The command to every to schedule a job takes the form: "every [num] unit program" (num defaults to one). So for example if you wanted to schedule a shell script to run every minute, type the following:

``` prettyprint
$ every minute script.sh
```

Which creates the following crontab:

``` prettyprint
SHELL=/bin/bash
PATH=/home/sillymoose/perl5/perlbrew/bin:/home/sillymoose/perl5/perlbrew/perls/perl-5.16.3/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/home/sillymoose/.local/bin:/home/sillymoose/bin:
*/1 * * * * cd "/home/sillymoose";  script.sh
```

every translates the command into a new crontab entry and prints it on the command line. Helpfully it will set the SHELL variable and copy the user's PATH into the crontab. The icing on the cake is that every prepends a change directory command to ensure that cron executes the job from the script's parent directory. By doing these things, every eliminates (probably) the three most common causes of failed cron jobs.

Other units that every recognizes are: hour, day, week, month and the day of the week (e.g. Wednesday). The following are all valid every commands:

``` prettyprint
$ every 10 hours script.sh

$ every mon script.sh

$ every 3 months script.sh
```

One really cool feature of modern cron installs is that you can schedule a job to run on reboot. every also supports this:

``` prettyprint
$ every @reboot script.sh
```

### Further info

every has more options than described above. Run "every --help" to see the full panoply of options.

every was written in Perl by [Rebecca](http://re-becca.org/). She is also on twitter ([@ReBeccaOrg](https://twitter.com/ReBeccaOrg)). So if you use every and find it useful, maybe reach out and say thank you.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
