{
   "draft" : false,
   "tags" : [
      "configuration",
      "module",
      "__data__"
   ],
   "title" : "3 ways to include data with your Perl distribution",
   "thumbnail" : "/images/66/thumb_EC3CE0E2-FF2E-11E3-8F16-5C05A68B9E16.png",
   "authors" : [
      "david-farrell"
   ],
   "description" : "TIMTOWDI",
   "slug" : "66/2014/2/7/3-ways-to-include-data-with-your-Perl-distribution",
   "image" : "/images/66/EC3CE0E2-FF2E-11E3-8F16-5C05A68B9E16.png",
   "date" : "2014-02-07T04:05:13",
   "categories" : "data"
}


*As a module author, being able to include data in your Perl distribution is super-useful. Data can be used for things like configuration and writing data-driven tests. Here are three ways to include data in a Perl distribution.*

EDIT: *Article updated on 9th February 2014 to include ExtUtils::MakeMaker solution option 3.*

### Use \_\_DATA\_\_

The "\_\_DATA\_\_" token is a Perl keyword that signifies the end of the code in the file. Any text that appears after the token is automatically read into the DATA filehandle at runtime. For example, let's include the Perl TIOBE statistics for the past decade as YAML data in a Perl test file:

```perl
use strict;
use warnings;
use YAML::XS;
use Test::More;

my $yaml = do { local $/; <main::DATA> };
my $data = Load $yaml;

do { ... };

done_testing();

__DATA__
---
2014: 0.917
2013: 2.264
2012: 2.768
2011: 2.857
2010: 3.562
2009: 4.303
2008: 5.247
2007: 6.237
2006: 7.045
2005: 8.861
```

Here we use a do block to slurp the main::DATA filehandle into $yaml. We then use the YAML::XS "Load" function to decode $yaml into a Perl data structure stored in $data. From here we're free to use the data in our tests.

What's nice about the \_\_DATA\_\_ approach is that it is simple, fast to code, cross platform functional and you should never have trouble locating the data (unlike with an external file). The downside with \_\_DATA\_\_ is that it forces you to include the data in the same file as the code. What if you have a large volume of data? Every time the module is used, the data would increase the burden of using that module, whether or not the data is actually used. Additionally the content of \_\_DATA\_\_ is largely fixed - only the developer can overwrite it.

### Use FindBin to locate the data file

FindBin is a fabulous little module that comes with core Perl and provides the "Bin" function which returns the absolute path of the current file's directory. So the pattern here is to include a data file in the same directory as the Perl file and reference the data file using FindBin's Bin function. Let's look at an example:

First we have our Tiobe Perl YAML data, saved in the file perl\_tiobe.yaml:

```perl
---
2014: 0.917
2013: 2.264
2012: 2.768
2011: 2.857
2010: 3.562
2009: 4.303
2008: 5.247
2007: 6.237
2006: 7.045
2005: 8.861
```

Next we reference the file in our modified test script:

```perl
use strict;
use warnings;
use YAML::XS;
use Test::More;
use FindBin;

open (my $DATA, '<', "$FindBin::Bin/perl_tiobe.yaml") or die $!;
my $yaml = do { local $/; <$DATA> };
my $data = Load $yaml;

do { ... };

done_testing();
```

Let's review what's changed in this script from the previous version. First of all we're importing Findbin. We're then opening a filehandle called $DATA that points to the current directory returned by FindBin::Bin plus the name of the data file.

The FindBin pattern works well if you can guarantee the data file will be in the same place as the code file. This makes it great for test files, as (by convention) they are always in the t directory and are not copied elsewhere as part of the module installation. You can use this pattern when distributing data files with Perl application (e.g. in the Makefile include both the binary and the data file in the EXE\_FILES directive). However this does mean that the data file will be copied to the target bin directory, which is the kind of file pollution that attracts ire quickly.

### Update Makefile.PL / Build.PL and use File::Share

Another way to include data files with a Perl distribution is to place them in a 'share' directory within the distribution root directory, update the Makefile.PL / Build.PL to copy the data files during install and then use File::Share to access the files.

If your distribution uses ExtUtils::MakeMaker, you can use [File::ShareDir::Install]({{<mcpan "File::ShareDir::Install" >}}) in your Makefile.PL to copy the data files. Here is a vanilla Makefile.PL for a fictional module " Data::File":

```perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;
use File::ShareDir::Install;

install_share dist => 'share';

WriteMakefile(
    NAME             => 'Data::Dir',
    AUTHOR           => q{David Farrell },
    VERSION_FROM     => 'lib/Data/Dir.pm',
    ABSTRACT_FROM    => 'lib/Data/Dir.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Data-Dir-*' },
);

package MY;
use File::ShareDir::Install 'postamble';
```

In the Makefile we import File::ShareDir:Install, and pass our "share" directory as an argument to the "install\_share" function. The strange last two lines of the Makefile include a package declaration for MY and an import of File::ShareDir::Install's "postamble" method. Be sure to include those two lines else the data files will not be copied.

If you are using [Module::Build]({{<mcpan "Module::Build::API" >}}), update Build.PL file with the `share\_dir` directive. Here's a vanilla Build.PL for a fictional module "Data::File":

```perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Data::File',
    license             => 'Artistic_2_0',
    dist_author         => q{David Farrell },
    dist_version_from   => 'lib/Data/File.pm',
    release_status      => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        #'ABC'              => 1.6,
        #'Foo::Bar::Module' => 5.0401,
    },
    add_to_cleanup     => [ 'Data-File-*' ],
    create_makefile_pl => 'traditional',
    share_dir => 'share',
);

$builder->create_build_script();
```

The "share\_dir" directive in the example Build.PL above instructs Module::Build to copy any files in the distributions share directory to the distribution's auto directory at install time.

Whether your distribution uses a Makefile.PL or a Build.PL, accessing the data file is now a matter of code. Here is a stripped-own File.pm file from our fictional module "Data::File":

```perl
package Data::File;
use strict;
use warnings;
use YAML::XS;
use File::Share ':all';

sub read_data {
    my $data_location = dist_file('Data-File', 'perl_tiobe.yaml');
    open (my $DATA, '<', $data_location) or die $!;
    my $yaml = do { local $/; <$DATA> };
    my $data = Load $yaml;

    do { ... };
}

1;
```

Much of this code should look familiar. In the "read\_data" subroutine we use the "dist\_file" function of [File::Share]({{<mcpan "File::Share" >}}) to get the absolute filepath for the data file. The "dist\_file" function is great: it will find the data file during testing and once the module is installed. After that line we open a filehandle to the file and process it as normal.

This method requires more work than the first two, but also offers a lot in return: we are able to include data with the distribution and access it at install and runtime. Our code files are not clogged with additional data that we may not need and we are not restricted to including the data files in the same directory as the consuming code file. It's even possible to share data from distribution with another (using "dist\_file").

### Conclusion

The examples have focused on including YAML data, but the solutions would work for most data types. Including data with Perl distributions is not as easy as it should be. However with the three solutions described here, you should be equipped to tackle the typical scenarios.

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F66%2F2014%2F2%2F7%2F3-ways-to-include-data-with-your-Perl-distribution&text=3%20ways%20to%20include%20data%20with%20your%20Perl%20distribution&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F66%2F2014%2F2%2F7%2F3-ways-to-include-data-with-your-Perl-distribution&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
