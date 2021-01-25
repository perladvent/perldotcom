{
   "authors" : [
      "david-farrell"
   ],
   "image" : null,
   "categories" : "cpan",
   "title" : "Upload to CPAN from the command line",
   "draft" : false,
   "tags" : [
      "configuration",
      "cpan",
      "sysadmin"
   ],
   "description" : "It's super easy with CPAN::Uploader",
   "date" : "2013-06-30T03:44:12",
   "slug" : "31/2013/6/30/Upload-to-CPAN-from-the-command-line"
}


The Perl module [CPAN::Uploader]({{<mcpan "CPAN::Uploader" >}}) comes with a neat command line application called [cpan-upload]({{<mcpan "RJBS/CPAN-Uploader-0.103015/bin/cpan-upload" >}}) which allows Perl module authors to upload to CPAN from the command line. This article describes how to install cpan-upload and use it.

To upload modules to CPAN you must have a registered [PAUSE](http://pause.perl.org/pause/query) account. Registration is free and an account is usually activated within 24 hours. Once you have a registered PAUSE account, install CPAN::Uploader via the command line:

```perl
cpan CPAN::Uploader
```

Once CPAN::Uploader has installed (it has a bunch of dependencies, including C libraries for NetSSLeay) at the command line type:

```perl
cpan-upload
```

You should see the cpan-upload help output displayed:

```perl
Please provide at least one file name.
usage: cpan-upload [options] file-to-upload
    -v --verbose       enable verbose logging
    -h --help          display this help message
    --dry-run          do not actually upload anything

    -u --user          your PAUSE username
    -p --password      the password to your PAUSE account
    -d --directory     a dir in your CPAN space in which to put the files
    --http-proxy       URL of the http proxy to use in uploading
```

### 1 Step method

To upload a file to PAUSE, the syntax is like this:

```perl
cpan-upload -u username -p password My-App-0.01.tar.gz
```

Where username and password are your PAUSE account credentials followed by the filepath(s) to the files you want to upload. On a successful load, cpan-upload will display the following output:

```perl
registering upload with PAUSE web server
POSTing upload for My-App-0.01.tar.gz to https://pause.perl.org/pause/authenquery
PAUSE add message sent ok [200]
```

### 2 step method (recommended)

The 2 step method involves calling cpan-upload with just your username and the filepath to the files to be uploaded. cpan-upload will then prompt for your password, which is entered directly into Perl, in a hidden format:

```perl
cpan-upload -u sillymoos My-App-0.01.tar.gz
PAUSE Password:
POSTing upload for My-App-0.01.tar.gz to https://pause.perl.org/pause/authenquery
PAUSE add message sent ok [200]
```

**Warning:** cpan-upload transmits your credentials via HTTPS (encrypted) to the PAUSE server, but with the 1 step method you do have to type your password in plaintext. which is a security risk as many operating systems will store them in logs, and/or process details. Simply searching through the Terminal history will reveal your PAUSE password. Additionally, someone could read your password as it's typed in. The 2 step method reduces this risk as the password is not logged in the terminal, but goes directly into the Perl program, and the password is not visible on the screen when typed. That said, the password can still be extracted from the computer by a stack trace or system call search. cpan-upload does have the ability to read the credentials from a .pause file in your home directory, which is a slightly more secure method than the 1 step method (although storing passwords in plaintext files raises its own security vulnerabilities). Of these three options the 2 step method seems to be the most secure.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
