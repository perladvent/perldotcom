{
   "description" : "... and a lot of of help from WWW::YouTube::Download",
   "thumbnail" : "/images/63/thumb_EC2F7326-FF2E-11E3-B942-5C05A68B9E16.png",
   "draft" : false,
   "slug" : "63/2014/1/26/Download-a-YouTube-video-with-one-line-of-Perl",
   "categories" : "web",
   "image" : "/images/63/EC2F7326-FF2E-11E3-B942-5C05A68B9E16.png",
   "date" : "2014-01-26T22:41:17",
   "authors" : [
      "david-farrell"
   ],
   "title" : "Download a YouTube video with one line of Perl",
   "tags" : [
      "one_liner",
      "youtube"
   ]
}


*Downloading YouTube videos with Perl is easy when you're packing the right module. That module is [WWW::YouTube::Download](https://metacpan.org/pod/WWW::YouTube::Download). Here's how you can download a video in one line of Perl.*

***Edit** - this article was updated on 27/1/2014 to describe the "youtube-download" app that comes with WWW::YouTube::Download.*

### Warning

You should only download videos which you have permission to do so. The following is just an example of how to do this, when you have permission.

### Requirements

You'll need to install WWW::YouTube::Download. The CPAN Testers [results](http://matrix.cpantesters.org/?dist=WWW-YouTube-Download+0.56) for the latest version (0.56 at the time of writing) show that it runs on all major platforms.

You can install the module via CPAN at the command line:

```perl
$ cpan WWW:YouTube::Download
```

### Use the youtube-download app

When you install WWW::YouTube::Download, it comes with a command-line app, "youtube-download". Using it couldn't be easier. Simply open the command line and type the program name with the URL or video id of the video to download. For example:

```perl
$ youtube-download http://www.youtube.com/watch?v=ju1IMxGSuNE
```

***NB** - using the app as shown above is the easiest way to use the tool - however at the time of writing I was not aware of the command line tool. Read on for the one liner example.*

### Download a video in one line of Perl

At the command line, type or paste the following command, replacing $id with the id of the video you want to download:

```perl
$ perl -MWWW::YouTube::Download -e 'WWW::YouTube::Download->new->download(q/$id/)'
```

### Explaining the one liner

This one liner is simple. First we load WWW::YouTube::Download using the "-M" switch. Then the "-e" switch tells Perl to execute the code between the apostrophes. We then initiate a WWW::YouTube::Download object with new, and immediately call the [download](https://metacpan.org/pod/WWW::YouTube::Download#download-video_id-args) method on the new object. We use the quoting construct "q//" to quote strings without using quote marks as this makes the one liner more cross-platform compatible.

### On Windows

On Windows, you'll need to replace the apostrophes with double quotes (").

### How to get the video id

The video id is the alphanumeric code value for "v" in the URL of the video you want to download. For example with this URL:

```perl
http://www.youtube.com/watch?v=ju1IMxGSuNE
```

"ju1IMxGSuNE" is the video id, because if you look in the URL after the question mark, v=ju1IMxGSuNE, which means "the value for v equals ju1IMxGSuNE". If you have a URL but can't work out the video id, WWW::YouTube::Download provides a video\_id method. This one liner will print out the video id, just replace $url with the actual YouTube URL.

```perl
$ perl -MWWW::YouTube::Download -E 'say WWW::YouTube::Download->new->video_id(q{$url})'
```

### A Perl script to download YouTube videos

We can expand the concepts used in the one liner into a fully-fledged Perl script, called "download.pl":

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use WWW::YouTube::Download;

if (@ARGV) {
    my $tube = WWW::YouTube::Download->new;
    my $video_id = $tube->video_id($ARGV[0]);
    $tube->download($video_id, { filename => '{title}{suffix}' }); 
}
```

The script takes a YouTube URL as an argument. It gets the video id of the URL, then downloads the video into the current directory. As an added bonus, the script will save the file with the title of the video, instead of the default which is the video id. You can run the script at the command line, passing the URL of the YouTube video to download. For example:

```perl
$ ./download.pl http://www.youtube.com/watch?v=ju1IMxGSuNE
```

You may need to set the script's permissions to executable using chmod:

```perl
$ chmod 755 download.pl
```

### Conclusion

WWW::YouTube::Download is easy to use, fast and just works. The module's [documentation](https://metacpan.org/pod/WWW::YouTube::Download) is easy to follow. Thanks to Yuji Shimada for writing it!

There is more to WWW::YouTube::Download than shown here - one interesting feature is that you can specify the video format (if more than one is available). By default the module downloads the highest quality video available.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
