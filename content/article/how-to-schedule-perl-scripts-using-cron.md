{
   "title" : "How to schedule Perl scripts using cron",
   "draft" : false,
   "slug" : "43/2013/10/11/How-to-schedule-Perl-scripts-using-cron",
   "date" : "2013-10-11T01:54:20",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Cron is a job scheduling program available on UNIX-like platforms. Most system commands can be scheduled including the execution of Perl programs. Once a job is setup, cron will run it as scheduled even if the user is not logged in, which can be a great way to automate sysadmin tasks or repetitive jobs. This article describes how to run Perl scripts with cron.",
   "image" : null,
   "categories" : "apps",
   "tags" : [
      "configuration",
      "linux",
      "unix",
      "sysadmin",
      "mac",
      "config",
      "old_site"
   ]
}


Cron is a job scheduling program available on UNIX-like platforms. Most system commands can be scheduled including the execution of Perl programs. Once a job is setup, cron will run it as scheduled even if the user is not logged in, which can be a great way to automate sysadmin tasks or repetitive jobs. This article describes how to run Perl scripts with cron.

### Perl script tips

When preparing a script to be run by cron, there a few things to keep in mind. You may want to add a shebang line to the of the script for the Perl binary you want to execute. For example:

``` prettyprint
#!/usr/local/bin/perl
```

If you plan to run the script on different platforms, you can omit the shebang line, as the location of the Perl binary may vary from platform to platform (more on this later).

Also ensure that any paths used in the script are absolute paths (such as for opening filehandles, database connection strings and external program paths).

### Setup a crontab

To schedule a job with cron, the job needs to be added to the user's crontab. To do this open a terminal and type the following:

``` prettyprint
crontab -e
```

This will open the crontab in a text editor. To add a job, a line must be added in the following format:

``` prettyprint
* * * * * command to be executed
| | | | |
| | | | |
| | | | +----- day of week  (0 - 6, Sunday=0)
| | | +------- month        (1 - 12)
| | +--------- day of month (1 - 31)
| +----------- hour         (0 - 23)
+------------- min          (0 - 59)

An asterisk (*) means all.
```

Here are some example crontab entries:

``` prettyprint
# execute every minute
* * * * * perl /path/to/Beacon.pl

# execute every 5 minutes
*/5 * * * * perl /path/to/Beacon.pl

# execute every hour at 0 minutes past the hour
0 * * * * perl /path/to/Beacon.pl

# execute every 12 hours at half past the hour
30 */12 * * * perl /path/to/Beacon.pl
```

If your script does not contain a shebang line, provide the absolute path to the Perl binary in the crontab. For example:

``` prettyprint
30 */12 * * * /usr/local/bin/perl /path/to/Beacon.pl
```

Save the crontab and exit the text editor. To check the job has been scheduled, you can check your crontab with this command from the terminal:

``` prettyprint
crontab -l
```

This will print your current crontab to the terminal.

### Troubleshooting cron

Working with cron is usually straightforward, but if you are having difficulty getting the Perl script to run, check the following:

-   Check the cron log to be sure that cron is running the job as you expect. It is usually found here: /var/log/cron
-   Check that you are providing the correct absolute path to the Perl binary. Either in the shebang line inside the script or in crontab (if you are not sure what this is type "which perl" at the terminal).
-   Make sure the script permissions allow execution (e.g. "chmod +x /path/to/file")
-   If you are running additional programs within the Perl script, consider adding their binary paths to the crontab as cron does not have the same PATH as the user.
-   If you need to run a script as root, just create a crontab for root using sudo: "sudo crontab -e"

A good list of general cron tips can be found [here](http://askubuntu.com/questions/23009/reasons-why-crontab-does-not-work).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
