{
   "slug" : "/pub/2007/07/12/options-and-configuration.html",
   "description" : " When you first fire up your editor and start writing a program, it's tempting to hardcode any settings or configuration so you can focus on the real task of getting the thing working. But as soon as you have...",
   "draft" : null,
   "authors" : [
      "jon-allen"
   ],
   "date" : "2007-07-12T00:00:00-08:00",
   "image" : null,
   "title" : "Option and Configuration Processing Made Easy",
   "categories" : "cpan",
   "thumbnail" : null,
   "tags" : [
      "argument-processing",
      "cli",
      "configuration-files",
      "getopt",
      "getopt-argvfile",
      "getopt-long"
   ]
}



When you first fire up your editor and start writing a program, it's tempting to hardcode any settings or configuration so you can focus on the real task of getting the thing working. But as soon as you have users, even if the user is only yourself, you can bet there will be things they want to choose for themselves.

A search on CPAN reveals almost 200 different modules dedicated to option processing and handling configuration files. By anyone's standards that's quite a lot, certainly too many to evaluate each one.

Luckily, you already have a great module right in front of you for handling options given on the command line: [Getopt::Long]({{<mcpan "Getopt::Long" >}}), which is a core module included as standard with Perl. This lets you use the standard double-dash style of option names:

    myscript --source-directory "/var/log/httpd" --verbose \ --username=JJ

#### Using Getopt::Long

When your program runs, any command-line arguments will be in the `@ARGV` array. [Getopt::Long]({{<mcpan "Getopt::Long" >}}) exports a function, `GetOptions()`, which processes `@ARGV` to do something useful with these arguments, such as set variables or run blocks of code. To allow specific option names, pass a list of option specifiers in the call to `GetOptions()` together with references to the variables in which you want the option values to be stored.

As an example, the following code defines two options, `--run` and `--verbose`. The call to `GetOptions()` will then assign the value `1` to the variables `$run` and `$verbose` respectively if the relevant option is present on the command line.

    use Getopt::Long;
    my ($run,$verbose);
    GetOptions( 'run'     => \$run,
                 'verbose' => \$verbose );

When [Getopt::Long]({{<mcpan "Getopt::Long" >}}) has finished processing options, any remaining arguments will remain in `@ARGV` for your script to handle (for example, specified filenames). If you use this example code and call your script as:

    myscript --run --verbose file1 file2 file3

then after `GetOptions()` has been called the `@ARGV` array will contain the values `file1`, `file2`, and `file3`.

#### Types of Command-Line Options

The option specifier provided to `GetOptions()` controls not only the option name, but also the option type. [Getopt::Long]({{<mcpan "Getopt::Long" >}}) gives a lot of flexibility in the types of option you can use. It supports Boolean switches, incremental switches, options with single values, options with multiple values, and even options with hash values.

Some of the most common specifiers are:

    name     # Presence of the option will set $name to 1
    name!    # Allows negation, e.g. --name will set $name to 1,
             #    --noname will set $name to 0
    name+    # Increments the variable each time the option is found, e.g.
             # if $name = 0 then --name --name --name will set $name to 3
    name=s   # String value required
             #    --name JJ or --name=JJ will set $name to JJ
             # Spaces need to be quoted
             #    --name="Jon Allen" or --name "Jon Allen"

So, to create an option that requires a string value, format the call to `GetOptions()` like this:

    my $name;
    GetOptions( 'name=s' => \$name );

The value is required. If the user omits it, as in:

    myscript --name

then the call to `GetOptions()` will `die()` with an appropriate error message.

#### Options with Multiple Values

The option specifier consists of four components: the option name; data type (Boolean, string, integer, etc.); whether to expect a single value, a list, or a hash; and the minimum and maximum number of values to accept. To require a list of string values, build up the option specifier:

    Option name:   name
    Option value:  =s    (string)
    Option type:   @     (array)
    Value counter: {1,}  (at least 1 value required, no upper limit)

Putting these all together gives:

    my $name;
    GetOptions('name=s@{1,}' => \$name);

Now invoking the script as:

    myscript --name Barbie Brian Steve

will set `$name` to the array reference `['Barbie','Brian','Steve']`.

Giving a hash value to an option is very similar. Replace `@` with `%` and on the command line give arguments as key=value pairs:

    my $name;
    GetOptions('name=s%{1,}',\$name);

Running the script as:

    myscript --name Barbie=Director JJ=Member

will store the hash reference `{ Barbie => 'Director', JJ => 'Member' }` in `$name`.

#### Storing Options in a Hash

By passing a hash reference as the first argument to `GetOptions`, you can store the complete set of option values in a hash instead of defining a separate variable for each one.

    my %options;
    GetOptions( \%options, 'name=s', 'verbose' );

Option names will be hash keys, so you can refer to the `name` value as `$options{name}`. If an option is not present on the command line, then the corresponding hash key will not be present.

#### Options that Invoke Subroutines

A nice feature of [Getopt::Long]({{<mcpan "Getopt::Long" >}}) is that, as an alternative to simply setting a variable when an option is found, you can tell the module to run any code of your choosing. Instead of giving `GetOptions()` a variable reference to store the option value, pass either a subroutine reference or an anonymous code reference. This will then be executed if the relevant option is found.

    GetOptions( version => sub{ print "This is myscript, version 0.01\n"; exit; }
                help    => \&display_help );

When used in this way, [Getopt::Long]({{<mcpan "Getopt::Long" >}}) also passes the option name and value as arguments to the subroutine:

    GetOptions( name => sub{ my ($opt,$value) = @_; print "Hello, $value\n"; } );

You can still include code references in the call to `GetOptions()` even if you use a hash to store the option values:

    my %options;
    GetOptions( \%options, 'name=s', 'verbose', 'dest=s',
                'version' => sub{ print "This is myscript, version 0.01\n"; exit; } );

#### Dashes or Underscores?

If you need to have option names that contain multiple words, such as a setting for "Source directory," you have a few different ways to write them:

    --source-directory
    --source_directory
    --sourcedirectory

To give a better user experience, [Getopt::Long]({{<mcpan "Getopt::Long" >}}) allows option aliases to allow either format. Define an alias by using the pipe character (`|`) in the option specifier:

    my %options;
    GetOptions( \%options, 'source_directory|source-directory|sourcedirectory=s' );

Note that if you're storing the option values in a hash, the first option name (in this case, `source_directory`) will be the hash key, even if your user gave an alias on the command line.

If you have a lot of options, it might be helpful to generate the aliases using a function:

    use strict;
    use warnings;
    use Data::Dumper;
    use Getopt::Long;

    my %specifiers = ( 'source-directory' => '=s',
                       'verbose'          => '' );
    my %options;
    GetOptions( \%options, optionspec(%specifiers) );

    print Dumper(\%options);

    sub optionspec {
      my %option_specs = @_;
      my @getopt_list;

      while (my ($option_name,$spec) = each %option_specs) {
        (my $variable_name = $option_name) =~ tr/-/_/;
        (my $nospace_name  = $option_name) =~ s/-//g;
        my  $getopt_name   = ($variable_name ne $option_name)
            ? "$variable_name|$option_name|$nospace_name" : $option_name;

        push @getopt_list,"$getopt_name$spec";
      }

      return @getopt_list;
    }

Running this script with each format in turn shows that they are all valid:

    varos:~/writing/argvfile jj$ ./optionspec.pl --source-directory /var/spool
    $VAR1 = {
              'source_directory' => '/var/spool'
            };

    varos:~/writing/argvfile jj$ ./optionspec.pl --source_directory /var/spool
    $VAR1 = {
              'source_directory' => '/var/spool'
            };

    varos:~/writing/argvfile jj$ ./optionspec.pl --sourcedirectory /var/spool
    $VAR1 = {
              'source_directory' => '/var/spool'
            };

Additionally, [Getopt::Long]({{<mcpan "Getopt::Long" >}}) is case-insensitive by default (for option names, not values), so your users can also use `--SourceDirectory`, `--sourceDirectory`, etc., as well:

    varos:~/writing/argvfile jj$ ./optionspec.pl --SourceDirectory /var/spool
    $VAR1 = {
              'source_directory' => '/var/spool'
            };

#### Configuration Files

The next stage on from command-line options is to let your users save their settings into config files. After all, if your program expands to have numerous options it's going to be a real pain to type them in every time.

When it comes to the format of a configuration file, there are a lot of choices, such as XML, INI files, and the Apache *httpd.conf* format. However, all of these formats share a couple of problems. First, your users now have two things to learn: the command-line options and the configuration file syntax. Second, even though many CPAN modules are available to parse the various config file formats, you still must write the code in your program to interact with your chosen module's API to set whatever variables you use internally to store user settings.

#### Getopt::ArgvFile to the Rescue

Fortunately, someone out there in CPAN-land has the answer (you can always count on the Perl community to come up with innovative solutions). [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) tackles both of these problems, simplifying the file format and the programming interface in one fell swoop.

To start with, the file format used by [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) is extremely easy for users to understand. Config settings are stored in a plain text file that holds exactly the same directives that a user would type on the command line. Instead of typing:

    myscript --source-directory /usr/local/src --verbose --logval=alert

your user can use the config file:

    --source-directory /usr/local/src
    --verbose
    --logval=alert

and then run `myscript` for instant user gratification with no steep learning curve.

Now to the clever part. [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) itself doesn't actually care about the contents of the config file. Instead, it makes it appear to your program that all the settings were actually options typed on the command line--the processing of which you've already covered with [Getopt::ArgvFile]({{<mcpan "Getopt::Long" >}}). As well as saving your users time by not making them learn a new syntax, you've also saved yourself time by not needing to code against a different API.

The most straightforward method of using [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) involves simply including the module in a `use` statement:

    use Getopt::ArgvFile home=>1;

A program called *myscript* that contains this code will search the user's home directory (whatever the environment variable `HOME` is set to) for a config file called *.myscript* and extract the contents ready for processing by [Getopt::Long]({{<mcpan "Getopt::Long" >}}).

Here's a complete example:

    use strict;
    use warnings;
    use Getopt::ArgvFile home=>1;
    use Getopt::Long;

    my %config;
    GetOptions( \%config, 'name=s' );

    if ($config{name}) {
      print "Hello, $config{name}\n";
    } else {
      print "Who am I talking to?\n";
    }

Save this as *hello*, then run the script with and without a command-line option:

    varos:~/writing/argvfile jj$ ./hello
    Who am I talking to?

    varos:~/writing/argvfile jj$ ./hello --name JJ
    Hello, JJ

Now, create a settings file called *.hello* in your home directory containing the `--name` option. Remember to double quote the value if you want to include spaces.

    varos:~/writing/argvfile jj$ cat ~/.hello
    --name "Jon Allen"

Running the script without any arguments on the command line will show that it loaded the config file, but you can also override the saved settings by giving the option on the command line as normal.

    varos:~/writing/argvfile jj$ ./hello
    Hello, Jon Allen

    varos:~/writing/argvfile jj$ ./hello --name JJ
    Hello, JJ

#### Advanced Usage

In many cases the default behaviour invoked by loading the module will be all you need, but [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) can also cater to more specific requirements.

#### User-Specified Config Files

Suppose your users want to save different sets of options and specify which one to use when they run your program. This is possible using the `@` directive on the command line:

    varos:~/writing/argvfile jj$ cat jj.conf
    --name JJ

    varos:~/writing/argvfile jj$ ./hello
    Hello, Jon Allen

    varos:~/writing/argvfile jj$ ./hello @jj.conf
    Hello, JJ

Note that there's no extra programming required to use this feature; handling `@` options is native to [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}).

#### Changing the Default Config Filename or Location

Depending on your target audience, the naming convention offered by [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) for config files might not be appropriate. Using a dotfile (*.myscript*) will render your user's config file invisible in his file manager or when listing files at the command prompt, so you may wish to use a name like *myscript.conf* instead.

Again, it may also be helpful to allow for default configuration files to appear somewhere other than the user's home directory, for example, if you need to allow system-wide configuration.

A further consideration here is [PAR](http://par.perl.org/) , the tool for creating standalone executables from Perl programs. PAR lets you include data files as well as Perl code, so you can bundle a default settings file using a command such as:

    pp hello -o hello.exe -a hello.conf

which will be available to your script as `$ENV{PAR_TEMP}/inc/hello.conf`.

I mentioned earlier that [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) can load arbitrary config files if the filename appears with the `@` directive on the command line. Essentially, what the module does when loaded with:

    use Getopt::ArgvFile home=>1;

is to prepend `@ARGV` with `@$ENV{HOME}/.scriptname`, then resolve all `@` directives, leaving `@ARGV` with the contents of the files. This means that running the script as:

    myscript --name=JJ

is basically equivalent to writing:

    myscript @$ENV{HOME}/.myscript --name-JJ

To load other config files, [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) supports disabling the automatic `@ARGV` processing and triggering it later. With a little manipulation of `@ARGV` first, you can make:

    myscript --name=JJ

equivalent to:

    myscript @/path/to/default.conf @/path/to/system.conf @/path/to/user.conf \
        --name=JJ

which will load the set of config files in the correct priority order.

All you need to do to enable this feature is change the `use` statement to read:

    use Getopt::ArgvFile qw/argvFile/;

Loading the module in this way tells [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}) to export the function `argvFile()`, which your program needs to call to process the `@` directives, and also prevents any automated processing from occurring.

Here's an example that first loads a config file from the application bundle (if packaged by PAR) and then from the directory containing the application binary:

    use File::Basename qw/basename/;
    use FindBin qw/$Bin/;
    use Getopt::ArgvFile qw/argvFile/;

    # Define config filename as <application_name>.conf
    (my $configfile = basename($0)) =~ s/^(.*?)(?:\..*)?$/$1.conf/;

    # Include config file from the same directory as the application binary
    if (-e "$Bin/$configfile") {
      unshift @ARGV,'@'."$Bin/$configfile";
    }

    # If we have been packaged with PAR, include the config file from the
    # application bundle
    if ($ENV{PAR_TEMP} and -e "$ENV{PAR_TEMP}/inc/$configfile") {
      unshift @ARGV,'@'."$ENV{PAR_TEMP}/inc/$configfile";
    }

    argvFile();  # Process @ARGV to load specified config files

You can also use this technique together with [`File::HomeDir`]({{<mcpan "File::HomeDir" >}}) to access the user's application data directory in a cross-platform manner, so that the location of the config file conforms to the conventions set by the user's operating system.

#### Summary

[Getopt::Long]({{<mcpan "Getopt::Long" >}}) provides an easy to use, extensible system for processing command-line options. With the addition of [Getopt::ArgvFile]({{<mcpan "Getopt::ArgvFile" >}}), you can seamlessly handle configuration files with almost no extra coding. Together, these modules should be first on your list when writing scripts that need any amount of configuration.
