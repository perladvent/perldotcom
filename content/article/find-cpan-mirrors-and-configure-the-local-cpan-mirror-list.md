{
   "description" : "CPAN mirrors are online repositories which host or \"mirror\" the Perl module distributions on CPAN. There are hundreds of CPAN mirrors dispersed throughout the World. When the CPAN program is run for the first time on a machine, it will configure the CPAN mirror list to use for checking for new versions of modules and downloading Perl distributions.  All CPAN mirrors are not created equally though: the distribution list's age, speed and the geographic location vary from mirror to mirror and so you may want to re-configure your local CPAN mirror list to suit your needs. This article describes how to find CPAN mirrors and edit the local CPAN mirror configuration.",
   "tags" : [
      "configuration",
      "cpan",
      "module",
      "sysadmin",
      "config",
      "old_site"
   ],
   "title" : "Find CPAN mirrors and configure the local CPAN mirror list",
   "slug" : "44/2013/10/20/Find-CPAN-mirrors-and-configure-the-local-CPAN-mirror-list",
   "categories" : "managing_perl",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "date" : "2013-10-20T19:07:00",
   "image" : null
}


CPAN mirrors are online repositories which host or "mirror" the Perl module distributions on CPAN. There are hundreds of CPAN mirrors dispersed throughout the World. When the CPAN program is run for the first time on a machine, it will configure the CPAN mirror list to use for checking for new versions of modules and downloading Perl distributions. All CPAN mirrors are not created equally though: the distribution list's age, speed and the geographic location vary from mirror to mirror and so you may want to re-configure your local CPAN mirror list to suit your needs. This article describes how to find CPAN mirrors and edit the local CPAN mirror configuration.

### Finding CPAN mirrors

An online list of public CPAN mirrors can be found [here](http://mirrors.cpan.org/). The list is frequently updated and lists mirrors by location, the scheme used (ftp, http), the age of the module list and some test results. Viewing this list you can see that some mirrors do not refresh their module list for days at a time - if you are using these mirrors you could be missing out on the latest version of your favourite module! A JSON formatted CPAN mirror list can be found [here](http://www.cpan.org/indices/mirrors.json).

### Start the CPAN shell

Once you have identified the URLs of the CPAN mirrors you want to use, fire up the terminal and load the cpan shell:

``` prettyprint
cpan

cpan shell -- CPAN exploration and modules installation (v2.00)
Enter 'h' for help.

cpan[1]>
```

### View the local CPAN mirror list

The CPAN mirror list is stored in the "urllist" variable. To view the list of mirrors, type "o conf urllist" in the CPAN shell:

``` prettyprint
cpan[1]>o conf urllist
    urllist           
    0 [http://httpupdate3.cpanel.net/CPAN/]
    1 [http://httpupdate23.cpanel.net/CPAN/]
    2 [http://mirrors.servercentral.net/CPAN/]
    3 [ftp://cpan.cse.msu.edu/]
```

### Add a CPAN mirror

To add a CPAN mirror use the "unshift" or "push" functions to add the mirror's url to the front or end of the mirror list. Make sure that the URL for the mirror **includes the scheme** (http, ftp).

``` prettyprint
cpan[2]> o conf urllist push http://mirror.waia.asn.au/pub/cpan/
```

### Remove a CPAN mirror

To remove a CPAN mirror use the "shift" or "pop" functions to remove the mirror URL from the front or end of the mirror list:

``` prettyprint
cpan[3]> o conf urllist pop
```

### Completely replace the existing mirror list

To overwrite the existing mirror list with a new one, just provide the URLs to the new mirrors as a space separated list:

``` prettyprint
cpan[4]> o conf urllist http://mirror.waia.asn.au/pub/cpan/ ftp://mirrors.coopvgg.com.ar/CPAN/
```

### Saving changes

Once you have updated the CPAN mirror list, make sure you commit the changes to file so they are saved beyond the current session:

``` prettyprint
cpan[5]> o conf commit
commit: wrote '/home/sillymoose/.cpan/CPAN/MyConfig.pm'
```

### Edit the CPAN configuration file directly

You can also edit the CPAN config file directly. For local user Perl installations this is \*/CPAN/MyConfig.pm and system Perl installations \*/CPAN/Config.pm (the parent directory will depend on the platform). When editing the file, urllist is a hash key for an array reference of mirror urls. Note the urls are quoted using Perl's quoting operator ("q"). Simply edit and save the file.

``` prettyprint
'urllist' => [
    q[http://httpupdate3.cpanel.net/CPAN/], 
    q[http://httpupdate23.cpanel.net/CPAN/], 
    q[http://mirrors.servercentral.net/CPAN/], 
    q[ftp://cpan.cse.msu.edu/]
],
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
