{
   "image" : "/images/111/0D9A013A-2F12-11E4-9950-DF3A7BB45C3F.jpeg",
   "title" : "Facing the music with Perl",
   "draft" : false,
   "slug" : "111/2014/8/29/Facing-the-music-with-Perl",
   "description" : "A few Perl modules make it easy",
   "date" : "2014-08-29T15:03:09",
   "tags" : [
      "sysadmin",
      "cd",
      "file_find",
      "music",
      "apple",
      "itunes",
      "metadata",
      "file_copy",
      "digest_md5"
   ],
   "authors" : [
      "brian-d-foy"
   ],
   "categories" : "data"
}


My digital music libraries were messed up. Spread across several devices and a couple of flirtations with iTunes Match and iCloud, I didn't have everything in one place—ironically. Not only that, but Apple had replaced some files with what it considered better versions. Although I don't want to perform the experiment to confirm it, I'm sure that the new files had different metadata. I needed to sort it out to start on a better system. I thought the task would be arduous, and it was until I settled on a simpler problem that a couple of Perl modules solved quickly.

For my first step, I needed to find all the music I had. I had backed up my files before I let Apple replace them with better versions. But I seemed to have made several backups, each with a different subset of my music. One backup would have most of the Led Zepplin but none of the Beatles, while another had no Zepplin and some of the Beatles. Another had all of the Beatles but no Cat Stevens.

I started by collecting all the unique files from the directories in which I had found music. This program has some of my favorite things about Perl, especially since I still have the wounds from moving files around during my C phase.

``` prettyprint
use v5.10;
use strict;
use warnings;

use Digest::MD5 qw(md5_hex);
use File::Copy  qw(copy);
use File::Find;
use File::Map   qw(map_file);
use File::Path  qw(make_path);
use File::Spec::Functions qw(catfile);

my $wanted = sub {
    state $Seen  = {};

    my $full_name = $File::Find::name;
    return if -d $full_name;

    map_file my $map, $full_name, '+<';
    my $digest_hex = md5_hex( $map );
    return if $Seen->{ $digest_hex }++;
    
    my( $extension )     = $full_name  =~ /(\.[^.]+)\z/;
    my( $n, $m, $o, $p ) = $digest_hex =~ /\A (..) (..) (..) (..)/x;

    my $basename = $_;
    my $dir = catfile( $new_dir, $n, $m, $o, $p );
    my $new_file = catfile( $dir, $basename );
    return if -e $new_file;

    make_path( $dir ) unless -d $dir;

    copy(
        $full_name, 
        catfile( $dir, $basename )
        );
    };

find( $wanted, @ARGV );
```

[File::Find](http://www.metacpan.org/module/File::Find) provides the code to traverse the file structure for me. I give find the list of starting directories, in this case those in `@ARGV`, and a callback subroutine as a reference. The meat of my program is in that `$wanted` subroutine. The hardest part of this code is remembering that `$File::Find::name` is the full path and `$_` is the filename only. I put those into variables to remind me which is which.

[File::Map](http://www.metacpan.org/pod/File::Map) allows me to access a file's data directly from disk as a memory map rather than reading it into memory. I don't need to change the file to get its digest (using [Digest::MD5](http://www.metacpan.org/pod/Digest::MD5)), so memory mapping is a big win across tens of thousands of music files. If I have seen that digest before, I move on to the next file. Otherwise I do some string manipulations to create new file paths, putting the pieces together with the cross-plaform [File::Spec](http://www.metacpan.org/pod/File::Spec). I copy the file to the new location with [File::Copy](http://www.metacpan.org/pod/File::Copy). I specifically make a copy so I leave the original files where they are for now. I anticipate messing up at least a couple of times. The new path is four levels deep with each deeper level based on the next two characters in the file's digest. That way, no directory gets too big, slowing down all directory operations.

Some rough calculations showed me that no particular music library was more than 85% complete. This was where the real fun began, but also my embarrassing tales of woe. Out of the newly copied files, I needed to select the ones I wanted to keep.

First, I merely cleaned out my iTunes library and reimported everything to see what I was working with. Most music I had in duplicates, and some in triplicates. iTunes Match had upgraded MP3 files to M4A (encoded in Apple's AAC codec) and had done the same for M4P files, the DRM-ed versions of music I had purchased. Each version had a different digest, so several versions of the same content survived.

I struggled with the next part of the problem because I have too much computer power at my disposal. I could collect all of the metadata for each file and store it in a database. I could throw it into a NoSQL thingy. I even thought about redis. Any one of these technologies are fun diversions but they require too much work. I started and abandoned several approaches, including a brief attempt to use AppleScript to interact with iTunes directly. Oh, the insanity.

Working from the digested directory each time was a bad decision. I'd have to collect the metadata then group files by album or artist. iTunes had already done that for me, although I didn't realize this for a week. When I imported the music, it copied the files into folders named after the artist and album (something I could have done instead of using the digests). Most of my work would be limited to the files in a single directory. I don't need a data structure to hold all of that. I certainly didn't need a database.

If I could enter a directory, examine each file in that directory, then process them on the way out of that directory, removing the duplicate files becomes much easier. I remembered that [File::Find](http://www.metacpan.org/pod/File::Find) has a `post_process` option that allows me to do this, although I haven't used it in years:

``` prettyprint
use File::Find qw(find);

find( 
    { 
    wanted      => $wanted,   #code refs
    postprocess => $post,
    },
    @ARGV,
    );
```

While I was in each directory, I could collect information on each file. Each file is already sorted by artist and album but I still need to choose which one of the duplicate files to keep. After a bit of thought, the solution turned out to be simple. I could sort on file extension, looking up the ordering in a hash. When I have two files with the same extension I'll choose the one with the higher bitrate. When the bitrates match, I'll choose the one with the shortest filename. With the various music libraries, I had some files like *Susie Q.m4a* and *Susie Q 1.m4a*; essentially the same file except for some slight metadata differences. I used [Music::Tag](http://www.metacpan.org/pod/Music::Tag) to get the metadata since it automatically delegated to plugins for the various file formats.

After sorting, I mark for deletion everything except the first element in the list. I don't delete them right away; I print the list to a file which I can use later to delete files. I've been around too long to delete files right away.

``` prettyprint
#!/Users/brian/bin/perls/perl5.18.1
use v5.18;
use Digest::MD5 qw( md5_hex );
use Data::Dumper;
use File::Basename qw( basename );
use File::Find;
use File::Map   qw( map_file );
use File::Copy  qw( copy );
use File::Path  qw( make_path );
use File::Spec::Functions  qw(abs2rel rel2abs splitdir);
use Music::Tag;

my $extensions_order = {
    m4a => -2,        
    mp3 => -1,
    m4p =>  0,
    };

open my $fh, '>', 'delete_files.txt';

my $hash = {};

my( $wanted, $post ) = make_subs( $dir, $hash );

find( 
    { 
    wanted      => $wanted,
    postprocess => $post,
    },
    @ARGV,
    );
    
sub make_subs {
    my( $dir, $hash ) = @_;
    
    sub { # wanted
        # my $path     = $File::Find::name;
        # my $filename = $_;
        
        state $count = 0;

        return if( -d $File::Find::name or -l $File::Find::name );
        return if $_ eq '.DS_Store';

        my $filename = basename( $File::Find::name );
        my $relative = abs2rel( $File::Find::name, $dir );
        
        my $basename_no_ext = $filename =~ s/\.[^.]+\z//r;

        my( $extension ) = $filename =~ m/ \. ( [^.]+ ) \z /x;
        return unless exists $extensions_order->{$extension};

        my $this_file = {};

        my $info = eval { Music::Tag->new( $filename )->get_tag };
        
        my $title = eval{ $info->title };
        if( $@ ) { 
            warn "Title had a problem: $@";
            }

        $this_file->{tag} = {
            title   => $title,
            bitrate => eval{ $info->bitrate },
            };    
        $this_file->{file} = {
            extension => $extension,
            basename  => $filename,
            relative  => $relative,
            no_ext    => $basename_no_ext,
            'File::Find::name' => $File::Find::name,
            '_' => $_,
            };    
        
        push @{ $hash->{$File::Find::dir}{$title} }, $this_file;

        $hash->{extensions}{$extension}++;
        },
        
    sub { # postprocess        
        my $this = $hash->{$File::Find::dir};

        TITLE: foreach my $title ( sort keys %$this ) {
            my $songs = $this->{ $title };
            next if @$songs == 1; # no duplicates, no problem

            my @sorted = sort {
              state $e = $extensions_order;
                
              $e->{ $a->{file}{extension} } <=> $e->{ $b->{file}{extension} }
                    or
              length $a->{file}{basename} <=> length $b->{file}{basename}
                    or
              $b->{tag}{bitrate} <=> $a->{tag}{bitrate}
              } @$songs;

            # everything without the chosen key will be deleted
            $sorted[0]{chosen}++;
            
            SONG: foreach my $song ( @sorted ) {
                $hash->{seen}++;
                next unless exists $extensions_order->{
                    $song->{file}{extension} };
                $hash->{examined}++;
                next if $song->{chosen};
                
                # ignore other files, such as videos and e-books
                next unless exists $extensions_order->{
                    $song->{file}{extension} };

                $hash->{deleted}++;
                print { $fh } "delete:\t$song->{file}{relative}\n";
                }
            }

        delete $hash->{$File::Find::dir};
        }
    }
```

And that was it. This left behind a couple of problems, such as messed up metadata, but I wasn't going to be able to solve that programmatically anyway. Getting a complete set of files with no duplicates solved most of the problem and leaves me with the joy of flipping through physical albums that only us grey beards remember.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
