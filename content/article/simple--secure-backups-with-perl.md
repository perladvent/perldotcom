{
   "categories" : "apps",
   "draft" : false,
   "slug" : "185/2015/8/27/Simple--secure-backups-with-Perl",
   "authors" : [
      "david-farrell"
   ],
   "title" : "Simple, secure backups with Perl",
   "date" : "2015-08-27T13:09:11",
   "image" : "/images/185/487F38FA-4C68-11E5-A045-6BD5FB9DDBA7.jpeg",
   "description" : "Creating encrypted, compressed archives",
   "tags" : [
      "stasis",
      "gpg",
      "tar",
      "dropbox",
      "aes",
      "encryption",
      "security",
      "privacy",
      "old_site"
   ]
}


Recently I was searching for a backup solution, and ended up rolling my own. The result is [Stasis](https://github.com/dnmfarrell/Stasis) a Perl program that uses `tar` and `gpg` to compress and encrypt files.

### How it works

Stasis takes a list of file and directory paths and builds a temporary compressed gzip archive using `tar`. It then encrypts the temporary archive with `gpg` using [AES 256-bit](https://en.wikipedia.org/wiki/Advanced_Encryption_Standard), saving it to a new location and removes the temporary archive. Stasis supports backups using a passphrase or a GPG key.

### Examples

Let's say I wanted to backup all files in my main home directories. I'd create a text file called `files_to_backup.txt`, that contains:

    /home/dfarrell/Documents
    /home/dfarrell/Downloads
    /home/dfarrell/Music
    /home/dfarrell/Pictures
    /home/dfarrell/Videos

I can save all of these directories and files to Dropbox:

    $ stasis --destination ~/Dropbox --files files_to_backup.txt --passphrase mysecretkey

Or more tersely:

    $ stasis -de ~/Dropbox -f files_to_backup.txt --passphrase mysecretkey

Use passfile instead of passphrase:

    $ stasis -de ~/Dropbox -f files_to_backup.txt --passfile /path/to/passfile

Use the "referrer" argument to provide a GPG key instead of a passphrase:

    $ stasis -de ~/Dropbox -f files_to_backup.txt -r keyname@example.com

Ignore the files matching patterns in `.stasisignore`. This is useful if I wanted to ignore certain types of files, like OSX `.DS_Store` index files or more broadly, all hidden files: `.*`.

    $ stasis -de ~/Dropbox -f files_to_backup.txt -r keyname@example.com -i .stasisignore

### Limiting the number of backups

Stasis accepts the `--limit` option to only retain the most recent x backups:

    $ stasis -de ~/Dropbox -f files_to_backup.txt -r mygpgkey@email.com --limit 4

It works really nicely with the `--days` option, which tells stasis to only create a new archive if one deosn't already exist within x days. So to keep a months' worth of weekly archives, I can do this:

    $ stasis -de ~/Dropbox -f files_to_backup.txt -r mygpgkey@email.com --limit 4 --days 7

Now stasis will only retain the last 4 archives, and only create one new archive a week. My personal laptop isn't always on, so I have a cron job that checks for this every 30 minutes:

    */30 * * * * stasis -de ~/Dropbox -f files_to_backup.txt -r mygpgkey@email.com -l 4 -da 7

### Restoring a backup

First decrypt the the backup with `gpg`:

    $ gpg -d /path/to/backup.tar.gz.gpg > /path/to/output.tar.gz
    gpg: AES256 encrypted data
    gpg: encrypted with 1 passphrase

GPG will ask for the passphrase or GPG key passphrase to unlock the data. You can then inspect the decrypted archive's files with `tar`:

    $ tar --list -f /path/to/output.tar.gz

Or:

    $ tar -zvtf /path/to/output.tar.gz

To unzip the archive:

    $ tar -zvxf /path/to/output.tar.gz

### Disadvantages of Stasis

Stasis suits my needs but it has several drawbacks which mean it might not be ideal for you. For one thing, it creates a standalone, encrypted archive every time it runs instead of incremental backups. Although this is simple, it also wastes space, so consider the implications if you intend to keep many backup copies. Because Stasis creates a temporary copy of the data it archives, it also requires enough disk space to create two compressed archives of the data.

As Stasis creates a new archive every time, it can be a resource intensive process to backup. On my ultrabook, it takes Stasis about 20 seconds to create a new 400MB new archive. If you are intending to archive large amounts of data, you may need another solution.

Archive names are fixed and should not be changed. Stasis creates encrypted archives with the ISO 8601 datetime in the filename like:`stasis-0000-00-00T00:00:00.tar.gz.gpg`. To detect previous backup files, Stasis looks for files matching this pattern in the backup directory. This comes into play of you use the `--limit` option.

### Stasis cheatsheet

    stasis [options]

    Options:

      --destination -de destination directory to save the encrypted archive to
      --days        -da only create an archive if one doesn't exist within this many days (optional)
      --files       -f  filepath to a text file of filepaths to backup
      --ignore      -i  filepath to a text file of glob patterns to ignore (optional)
      --limit       -l  limit number of stasis backups to keep in destination directory (optional)
      --passphrase      passphrase to use
      --passfile        filepath to a textfile containing the password to use
      --referrer    -r  name of the gpg key to use (instead of a passphrase or passfile)
      --temp        -t  temp directory path, uses /tmp by default
      --verbose     -v  verbose, print progress statements (optional)
      --help        -h  print this documentation (optional)

**Updated**:*Added new section covering --days options, removed scripting section 2016-04-02*
\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
