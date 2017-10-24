{
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "categories" : "development",
   "date" : "2013-07-17T03:10:55",
   "tags" : [
      "functional",
      "subroutine",
      "sysadmin"
   ],
   "slug" : "34/2013/7/17/Re-use-code-with-Perl-s-anonymous-functions",
   "description" : "An anonymous function in Perl is an unnamed subroutine. But what are they good for? This article shows how through using anonymous functions it's possible to write more generic, re-usable Perl code.",
   "title" : "Re-use code with Perl's anonymous functions",
   "draft" : false
}


An anonymous function in Perl is an unnamed subroutine. But what are they good for? This article shows how through using anonymous functions it's possible to write more generic, re-usable Perl code.

Imagine that you've developed the following script. The script receives a directory path as a parameter and recursively searches the child directories of the path, printing any file name it finds:

``` prettyprint
use strict;
use warnings;
use feature qw/say/;

die "Error: you must supply a directory path argument $!" unless @ARGV;

sub listFiles {
    my $dir = shift;
    opendir(my $DH, $dir) or die "Error: failed to open $dir $!";

    while (readdir $DH) {
        my $path = $dir . $_;
        if(-d $path ){
            # recurse but ignore Linux symlinks . and ..
            listFiles($path .'/') if $_ !~ /^\.{1,2}$/;
        }
        elsif(-f $path){
            say $path;
        }
    }
}

listFiles($ARGV[0]);
```

The most re-usable aspect of this script is the recursive directory searching logic. If you wanted to develop a file name searching script (similar to the find program in Linux), you could start by copying and pasting the script above, and then updating the code to provide the required behavior. An alternative way would be to change the core subroutine to accept an anonymous function as an argument, and then execute that function on every file it finds. Such a subroutine would look like this:

``` prettyprint
use strict;
use warnings;
use feature qw/say/;

die "Error: you must supply a directory path argument $!" unless @ARGV;

sub walkDir {
    my ($dir, $function) = @_;

    # validate args
    opendir(my $DH, $dir) or die "Error: failed to open $dir $!";
    ref($function) eq 'CODE' or 
        die "Error: second argument to walkDir must be an anonymous function $!";

    while (readdir $DH) {
        my $path = $dir . $_;
        if(-d $path ){ 
            # recurse but ignore Linux symlinks . and ..
            walkDir($path . '/', $function) if $_ !~ /^\.{1,2}$/;
        }
        elsif(-f $path){
            $function->($path);
        }
    }
}

walkDir($ARGV[0], sub { say shift });
```

The "walkDir" subroutine in the code above accepts two arguments: the directory path and a function. It recursively searches the directories as before, however when it encounters a file, it de-references and executes the function, passing the file path to the function as an argument. The final line of code provides the file name printing behaviour by calling "walkDir" and passing the target directory path, and an anonymous function to print (say) the default argument.

We can re-use the same walkDir subroutine for our file-searching script and all we have to do is update the anonymous function behavior:

``` prettyprint
walkDir($ARGV[0], 
        sub { 
            my $filename = shift;
            say $filename if $filename =~ /$ARGV[1]/i;
        });
```

To create a grep-like tool, we would replace the previous code with this:

``` prettyprint
use File::Slurp;
walkDir($ARGV[0],
        sub {
            my $filename = shift;
            say $filename if read_file($filename) =~ qr/$ARGV[1]/i;
        });
```

In fact we could quickly create a whole library of useful sysadmin scripts with this approach. We could even put the "walkDir" subroutine code into a module to augment further re-use. Hopefully these examples show how by using anonymous functions, Perl let's you re-use useful code.

This article was inspired by [Higher Order Perl](http://hop.perl.plover.com/) by Mark Jason Dominus. Higher Order Perl explores anonymous functions and other functional programming techniques like recursion, currying and laziness. It's free to read online and in ebook format.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
