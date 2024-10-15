{
   "slug" : "/pub/2006/12/21/using-java-classes.html",
   "description" : " I started a new job recently to refocus my career from systems administration to web development. Part of that move meant using Java as my primary language at work and using a relatively new technology from the Java Community...",
   "draft" : null,
   "authors" : [
      "andrew-hanenkamp"
   ],
   "date" : "2006-12-21T00:00:00-08:00",
   "categories" : "development",
   "title" : "Using Java Classes in Perl",
   "image" : null,
   "tags" : [
      "inline-java",
      "java-bindings",
      "java-classes",
      "jcr",
      "perl-bindings"
   ],
   "thumbnail" : "/images/_pub_2006_12_21_using-java-classes/111-inline_java.gif"
}



I started a new job recently to refocus my career from systems administration to web development. Part of that move meant using Java as my primary language at work and using a relatively new technology from the [Java Community Process](https://www.jcp.org/en/home/index) (JCP), the [Content Repository API for Java](https://jcp.org/en/jsr/detail?id=170) (JCR), which is a hierarchical database standard for storing content. However, not wanting to let the skills in my favorite language waste away, I've been toying with similar technologies at home using Perl. I decided to make a direct port of the JCR to Perl and did so by making Perl use an existing Java implementation via [Inline::Java]({{<mcpan "Inline::Java" >}}). While I ran into some snags along the way, I was happily surprised to find the process of using Java classes from Perl was fabulously easy.

### Bringing the JCR to Perl

The key to using JCR from Perl is `Inline::Java`. This library allows a Perl program to call Java methods with very little effort. For an introduction to Inline::Java, I suggest starting where I did, Phil Crow's 2003 [Bringing Java into Perl](/pub/2003/11/07/java.html) article on [Perl.com](https://www.Perl.com) about Inline::Java. I also relied heavily upon the documentation for [Inline::Java]({{<mcpan "Inline::Java" >}}), which is very complete, if not exhaustive.

To get started on using the JCR, I used the reference implementation, [Jackrabbit](http://jackrabbit.apache.org/jcr/index.html). I downloaded the Jackrabbit JAR file, along with all the prerequisites, which I found on the Jackrabbit website under [First Hops](http://jackrabbit.apache.org/jcr/getting-started-with-apache-jackrabbit.html). Then, I wrote a small script using `Inline::Java` to load the Java classes from Jackrabbit, create a repository, and then quit. I was able to take the First Hop with Jackrabbit in Perl as fast or faster than in Java:

    #!/usr/bin/perl
    use strict;
    use warnings;
    use Inline
        Java => 'STUDY',
        STUDY => [ qw(
            org.apache.jackrabbit.core.TransientRepository
            javax.jcr.Repository
        ) ],
        AUTOSTUDY => 1;

    my $repository = org::apache::jackrabbit::core::TransientRepository->new;
    my $session = $repository->login;
    eval {
        my $user = $session->getUserID;
        my $name = $repository
            ->getDescriptor($javax::jcr::Repository::REP_NAME_DESC);
        print "Logged in as $user to a $name repository.\n";
    };

    if ($@) {
        print STDERR "Exception: ", $@->getMessage, "n";
    }

    $session->logout;

This code is a direct Perl port of the first tutorial on the Jackrabbit website. To run the code, you must make sure your class path is correct. Because I initially dropped the JCR files into my working directory, I just ran these commands to get it to work:

    % export CLASSPATH=$CLASSPATH:`echo *.jar | tr ' ' ':'`
    % perl firsthop.pl

Within five minutes, I had a Perl script that could access the Jackrabbit libraries, create a repository, and login as anonymous. This answered my first question: Can I port the JCR to Perl? *Yes.*

### First Snags

After proceeding to the "Second Hop" in the Jackrabbit tutorial, I ran into my first snag. To create nodes and properties with Jackrabbit, you must log in using a username and password. However, the JCR uses an array of characters for the password argument. Because `Inline::Java` helpfully translates Java string objects into Perl scalars, I could not determine a way to do so.

I also realized that I did not want to use lengthy Java namespaces in my Perl code. Writing out `org::apache::jackrabbit::core::TransientRepository` or `javax::jcr::Repository` is not a very productive use of my time and makes for odd-looking Perl code.

In addition, I didn't want a library that depended on Jackrabbit. There are several other JCR implementations either already written or on the way. Day has [CRX](https://www.day.com/day/en/products/crx.html), there's another Open Source implementation named [Jaceira](http://freshmeat.sourceforge.net/projects/jeceira) in the works, and [eXo](https://exojcr.jboss.org) has also created a JCR implementation, to name a few.

Given these difficulties and the potential for other problems that I knew would come up, it was time to build this project as a Perl module.

### Creating the Wrappers

To create the abstraction I desired, it quickly became apparent that I needed a way to build wrappers around the stubs generated by `Inline::Java`. Therefore, I set about writing a script that could generate a Perl package for each library in the JCR. Each wrapper package would, in addition to helping wrap special cases, clean up the Java namespace using naming conventions that are more common to Perl code (particularly my Perl code, which is similar to Conway's conventions from [Perl Best Practices](https://www.oreilly.com/catalog/perlbp/)).

### Using Java Reflection

I first needed to discover the classes, methods, and fields to wrap. There are more than 50 classes, interfaces, and exceptions in the JCR specification--I'm too lazy to type all that. Furthermore, the JCR is currently under revision via [JSR 283](https://jcp.org/en/jsr/detail?id=283), I don't want to update the class list again later. Finally, I want my wrappers to handle each method specifically because the use of `AUTOLOAD()` is evil (sometimes useful, but still evil).

I wrote a Java program to find all the classes in the JCR JAR file and write those class names out with additional information about methods, constructors, and fields. I used a [YAML](http://yaml.org/)-formatted file to store the information. I made heavy use of the [Java Reflection API](https://docs.oracle.com/javase/tutorial/reflect/index.html) to make this happen. You can see the full source of JCR package generator (_inc/JCRPackageGenerator.java_) in the [Java::JCR]({{<mcpan "Java::JCR" >}}) distribution. Here's one entry in the YAML JCR package output file (_inc/packages.yml_):

    javax.jcr.SimpleCredentials:
      isa:
       - java.lang.Object
       - javax.jcr.Credentials
      has_constructors: 1
      methods:
        instance:
          getAttributeNames: Array:java.lang.String
          getUserID: java.lang.String
          toString: java.lang.String
          getPassword: Array:char
          getAttribute: java.lang.Object
          setAttribute: void
          removeAttribute: void

The information I chose to place in the YAML file is mostly the outcome of experimentation with the Perl generator script. Because I wrote a generic handler to perform the required unwrapping that can handle any set of arguments, I didn't bother to remember them here. On the other hand, knowing the return type, recorded after each method name, is helpful to my implementation.

### Code Generation with Perl

Next, I wrote a Perl script to load the information in the YAML file and generate the packages. You can see the full source for `inc/package-generator.pl` as well. This script is pretty ugly. I do all the work of generating the information in Perl with embedded here-documents. A much better way to do this would be to use a templating tool like Andy Wardley's [Template Toolkit](http://www.template-toolkit.org/), which is what I'd ultimately like to do.

Basically, this program iterates over all the entries loaded from the YAML file and generates a package for each class. It creates a Perl package name from the Java package name and a Perl package file at the appropriate location in the distribution.

For example, `javax.jcr.nodetype.ItemDefinition` gets a Perl package name of `Java::JCR::Nodetype::ItemDefinition` and a file location of *lib/Java/JCR/Nodetype/ItemDefinition.pm*.

The code injects a stock header and footer into the package file. All the real magic happens in between these.

### Handling Static Fields

The code adds static fields by modifying the symbol table so that the wrappers point to the automatically generated stubs. For example, `Java::JCR::PropertyType` gets several entries like:

    *STRING = *Java::JCR::javax::jcr::PropertyType::STRING;
    *BINARY = *Java::JCR::javax::jcr::PropertyType::BINARY;
    *LONG = *Java::JCR::javax::jcr::PropertyType::LONG;

For those who may not know, the first line makes the name `Java::JCR::PropertyType::STRING` exactly identical to using the longer name, `Java::JCR::javax::jcr::Property::STRING` by modifying the [symbol table]({{< perldoc "perlmod" "Symbol-Tables-symbol-table-stash-%25%3a%3a-%25main%3a%3a-typeglob-glob-alias" >}}) directly.

OK, looking at that, you probably want to know why all the `Inline::Java` stubs now have `Java::JCR` on the front of them. The reason is that in the generated code, I use the `study_classes()` routine to import the Java code and specify that the base package for the import should be `Java::JCR`:

    study_classes(['javax.jcr.PropertyType'], 'Java::JCR');

Why? It's really not that critical, but I figured that because the name of the package I was putting on CPAN was `Java::JCR`, I really didn't want to drop packages into an external namespace while I was at it. Because the wrappers hide all the long names, the actual length of the internal names doesn't matter anyway.

### Dealing with Constructors and Methods

After fields, the code checks whether the Java class provides a constructor (that is, if it's a class rather than an interface). As it turns out, I never actually use the code for dealing with constructors for two reasons:

-   *Exceptions*. For reasons I'll explain later, I don't generate the exception classes. Therefore, these constructors go unused.
-   *`SimpleCredentials`*. The only remaining class that has a constructor is `java.jcr.SimpleCredentials`, which is the special case I've already mentioned. Therefore, I only need to cope with constructors as a special case. I'll cover the special cases later as well.

After the constructor, the program runs through each method and generates both the static and instance method wrappers. Here's a typical method wrapper from `Java::JCR::Repository`:

    sub login {
        my $self = shift;
        my @args = Java::JCR::Base::_process_args(@_);

        my $result = eval { $self->{obj}->login(@args) };
        if ($@) { my $e = Java::JCR::Exception->new($@); croak $e }

        return Java::JCR::Base::_process_return($result, "javax.jcr.Session", "Java::JCR::Session");
    }

### Camel Case

This particular example doesn't show it, but I also changed the camel-case Java names of every method to all lowercase with underscores, which is a much more common way of naming methods in Perl. I may add aliases using the Java names in the future, but I don't care for Java-style naming conventions in Perl code. The most interesting part of this process was handing names that include all-caps abbreviations. That required two lines of Perl:

    my $perl_method_name = $method_name;
    $perl_method_name =~ s/(p{IsLu}+)/_L$1E/g;

The `/(\p{IsLu}+)/` matches any uppercase letter or string of uppercase letters. The replacement applies the `\L` modifier to the regular expression to convert the matched snippet to all lowercase. I prepend an underscore to complete the conversion. Thus, the method named `getDescriptor` becomes `get_descriptor` and the method named `getNodeByUUID` becomes `get_node_by_uuid`. This won't work very well, by the way, if there are any names that have abbreviations before the end (for example, if there had been a `getUUIDNode`, which would become `get_uuidnode`) Fortunately, this case never shows up in the JCR API.

### Method Wrappers

`Java::JCR::Base::_process_arg()` processes the arguments passed to each method. This function looks for any of the generated wrapper objects (anything that `isa` `Java::JCR::Base`) in the list of arguments and unwraps the generated stub by pulling the `obj` key out of the blessed hash.

    sub _process_args {
        my @args;
        for my $arg (@_) {
            if (UNIVERSAL::isa($arg, 'Java::JCR::Base')) {
                push @args, $arg->{obj};
            }
            else {
                push @args, $arg;
            }
        }

        return @args;
    }

The wrapper then executes the wrapped method on the generated stub by passing it the unwrapped arguments (as if the wrappers weren't there).

I make sure to wrap every call in an `eval` because `Inline::Java` passes Java exceptions as Perl exception objects. If an exception is thrown, I wrap it in a custom class named `Java::JCR::Exception`, which I wrote by hand.

Finally, the code returns the result. If the return type has a wrapper, as is the case in `login()`), I use `Java::JCR::Base::_process_return()` to cast the class and wrap it.

    sub _process_return {
        my $result = shift;
        my $java_package = shift;
        my $perl_package = shift;

        # Null is null
        if (!defined $result) {
            return $result;
        }

        # Process array results
        elsif ($java_package =~ /^Array:(.*)$/) {
            my $real_package = $1;
            return [
                map { bless { obj => cast($real_package, $_) }, $perl_package }
                    @{ $result }
            ];
        }

        # Process scalar results
        else {
            return bless {
                obj => cast($java_package, $result),
            }, $perl_package;
        }
    }

This brings up two considerations: Why the custom exception class? Why do I need to cast the object? In both cases, I do this to handle minor issues in `Inline::Java`.

In the case of exceptions, the generated exception objects don't handle Perl stringification very well. Because a lot of exception handlers assume that exceptions are strings or properly stringified, this can be (and has been for me) a problem. My exception class makes sure stringification works the right way.

As for the cast, `Inline::Java` works on the assumption that you want to use the class in its most specific form, but if it hasn't studied that form, you get a generic object on which you cannot call any methods. Rather than engage the potentially costly `AUTOSTUDY` option to make sure `Inline::Java` studies everything and then smarten up the wrappers more, I've chosen to cast the objects into the expected return type. This does limit some of the flexibility.

### Loading Packages

Other than the custom pieces, I needed some additional helpers to get the job done. I didn't want to write out a lot of `use` statements to use this library. As a JAPH, I like to keep things simple. Therefore, if I need to use the JCR and Jackrabbit, I just want to say:

    use Java::JCR;
    use Java::JCR::Jackrabbit;

I included a package loader in the main package, [Java::JCR]({{<mcpan "Java::JCR" >}}), that will take care of these details and then created a package for each of the subpackages in the JCR. The loader looks like:

    sub import_my_packages {
        my ($package_name, $package_file) = caller;
        my %excludes = map { $_ => 1 } @_;

        my $package_dir = $package_file;
        $package_dir =~ s/.pm$//;
        my $package_glob = File::Spec->catfile($package_dir, '*.pm');

        for my $package (glob $package_glob) {
            $package =~ s/^$package_dir///;
            $package =~ s/.pm$//;
            $package =~ s///::/g;

            next if $excludes{$package};

            eval "use ${package_name}::$package;";
            if ($@) { carp "Error loading $package: $@" }
        }
    }

I make sure to call that method once the package has finished loading and pass in exclusions to keep it from loading all the subpackages. This needs further enhancement to allow for future extensions under the `Java::JCR` namespace, so as not to load them automatically, but this is a good starting point. I built one class for each subpackage, then, that inherits from Java::JCR and then calls this method to load each of those classes.

### Connecting to Jackrabbit

Obviously, the next step was to create the code to connect to Jackrabbit. This was done in [Java::JCR::Jackrabbit]({{<mcpan "Java::JCR::Jackrabbit" >}}). The initial implementation is very simple:

    use base qw( Java::JCR::Base Java::JCR::Repository );

    use Inline (
        Java => 'STUDY',
        STUDY => [],
    );
    use Inline::Java qw( study_classes );

    study_classes(['org.apache.jackrabbit.core.TransientRepository'], 'Java::JCR');

    sub new {
        my $class = shift;

        return bless {
            obj => Java::JCR::org::apache::jackrabbit::core::TransientRepository
                    ->new(@_),
        }, $class;
    }

I extended [Java::JCR::Repository]({{<mcpan "Java::JCR::Repository" >}}) to add a constructor that calls the Jackrabbit constructor. Done.

### Handling Special Cases

With all that work, I still couldn't make the second hop because I still hadn't resolved the whole problem of passing an array of characters. However, with the infrastructure I had in place, this was now solvable.

I created an additional YAML configuration file named _specials.yml_. This file contains hand-coded alternatives to use where appropriate. I then wrote an alternative for the new constructor:

    javax.jcr.SimpleCredentials:
      new: |-
        sub new {
            my $class = shift;
            my $user = shift;
            my $password = shift;

            my $charArray = Java::JCR::PerlUtils->charArray($password);

            return bless {
                obj => Java::JCR::javax::jcr::SimpleCredentials->new($user, $charArray),
            }, $class;
        }

Then, I reran the generator script. Fortunately, I had already improved it to use any implemented method or constructor rather than generating one automatically.

To perform the conversion, I also needed to embed a little extra Java code. I wrote a very small Java class called `PerlUtils` for handling the conversion:

    use Inline (
        Java => <<'END_OF_JAVA',

    class PerlUtils {
        public static char[] charArray(String str) {
            return str.toCharArray();
        }
    }

    END_OF_JAVA
    );

Given a string, it returns an array of characters to pass back into the `SimpleCredentials` constructor. No other work is necessary. I could now perform the JCR second hop in Perl (_ex/secondhop.pl_). That script attaches to a Jackrabbit repository, logs in as "username" with password "password" and then creates a node.

### Using Handles as InputStreams

The third (and final) hop of the Jackrabbit tutorial demonstrates node import using an XML file. However, in order to perform the import shown, you must pass an `InputStream` off to the `importXML()` method. While `Inline::Java` provides the ability to use Java `InputStream`s as Perl file handles, it doesn't provide the mapping in the opposite direction. Thus I needed another special handler and an additional set of helper methods.

The special code configuration looks like:

    javax.jcr.Session:
      import_xml: |-
        sub import_xml {
            my $self = shift;
            my $path = shift;
            my $handle = shift;
            my $behavior = shift;

            my $input_stream = Java::JCR::JavaUtils::input_stream($handle);

            $self->{obj}->importXML($path, $input_stream, $behavior);
        }

This calls the `input_stream()` method, which is a Perl subroutine.

    sub input_stream {
        my $glob = shift;
        my $glob_val = $$glob;
        $glob_val =~ s/^\*//;
        my $glob_caller = Java::JCR::GlobCaller->new($glob_val);
        return Java::JCR::GlobInputStream->new($glob_caller);
    }

As you can see, this subroutine uses two separate Java classes to provide the interface from a Perl file handle to Java `InputStream`. The first class, `Java::JCR::GlobCaller`, performs most of the real work using the callback features provided by `Inline::Java`. It gets passed to the `Java::JCR::GlobInputStream`, which calls `read()` whenever the JCR reads from the stream:

    public int read() throws InlineJavaException, InlineJavaPerlException {
        String ch = (String) CallPerlSub(
                "Java::JCR::JavaUtils::read_one_byte", new Object[] {
                    this.glob
               });
        return ch != null ? ch.charAt(0) : -1;
    }

The `read_one_byte()` function is a very basic wrapper for the Perl built-in `getc`.

    sub read_one_byte {
        my $glob = shift;
        my $c = getc $glob;
        return $c;
    }

With this in place, you can now perform the [third JCR hop in Perl] (_ex/thirdhop.pl_). By executing this script, you will connect to a repository, log in, and then create nodes and properties from an XML file.

### Getting Ready to Distribute

The implementation is now, more or less, complete. You can use `Java::JCR` to connect to a Jackrabbit repository, log in, create nodes and properties, and import data from XML. There's a lot left untested, but the essentials are now present. With this done, I was ready to begin getting ready for the distribution. However, because some Java libraries are requirements to use the library, the library has some special needs to build and install easily. You should be able to install it by just running:

    % cpan Java::JCR

I needed a way to build this library. My preferred build tool is Ken Williams' [Module::Build]({{<mcpan "Module::Build" >}}). It's in common use, compatible with the CPAN installer, and cooperates well with *g-cpan.pl*, which is a packaging tool for my favorite Linux distribution, [Gentoo](https://www.gentoo.org/). Finally, it's easy to extend.

When customizing `Module::Build`, I prefer to create a custom build module rather than by placing the extension directly inline with the *Build.PL* file. In this case, I've called the module [Java::JCR::Build]({{<mcpan "Java::JCR::Build" >}}). I placed it inside a directory named *inc/* with the rest of the tools I built for generating the package.

After creating the basic module that extends `Module::Build`, I added a custom action to fetch the JAR files called `get_jars`. I also added the code to execute this action on build by extending the `code` ACTION:

    sub ACTION_get_jars {
        my $self = shift;

        eval "require LWP::UserAgent"
            or die "Failed to load LWP::UserAgent: $@";

        my $mirror_dir
            = File::Spec->catdir($self->blib, 'lib', 'Java', 'JCR');
        mkpath( $mirror_dir, 1);

        my $ua = LWP::UserAgent->new;

        print "Checking for needed jar files...n";
        while (my ($file, $url) = each %jars) {
            my $path = File::Spec->catfile($mirror_dir, $file);
            $self->add_to_cleanup($path);

            next if -f $path;

            my $response = $ua->mirror($url, $path);
            if ($response->is_success) {
                print "Mirroring $url to $file.n";
            }

            elsif ($response->is_error) {
                die "An error occurred fetching $url to $file: ",
                    $response->status_line, "n";
            }
        }
    }

    sub ACTION_code {
        my $self = shift;

        $self->ACTION_get_jars;
        $self->SUPER::ACTION_code;
    }

I use Gisle Aas's [LWP::UserAgent]({{<mcpan "LWP::UserAgent" >}}) to fetch the JAR files from the public Maven repositories and drop them into the build library folder, *blib*. `Module::Build` will take care of the rest by copying those JAR files to the appropriate location during the install process.

I also needed some code in `Java::JCR` to set the `CLASSPATH` correctly ahead of time:

    my $classpath;
    BEGIN {
        my @classpath;
        my $this_path = $INC{'Java/JCR.pm'};
        $this_path =~ s/.pm$//;
        my $jar_glob = File::Spec->catfile($this_path, "*.jar");
        for my $jar_file (glob $jar_glob) {
            push @classpath, $jar_file;
        }
        $classpath = join ':', @classpath, ($ENV{'CLASSPATH'} || '');
        $ENV{'CLASSPATH'} = $classpath;
    }

This bit of code asks Perl for the path to the location of this library, which I assume is the installed location of the JAR files. Then, I find each file ending with *.jar* in that directory and put them into the `CLASSPATH`. Unfortunately, my code assumes a Unix environment when it uses the colon as the path separator. A future revision could make sure that this works on other systems as well, but because I use only Unix-based operating systems, my motivation is lacking.

With all that, you can now deploy this by downloading the tarball and running:

    % perl Build.PL
    % ./Build
    % ./Build test
    % ./Build install

It works!

### Testing

I haven't mentioned this yet, but during the whole process of building this library, I also built a series of test cases. You can find these in the _t/_ directory of the distribution. The first few tests are actually just variations on the Jackrabbit tutorial, as well as a test to make sure the POD documentation contains no errors (every module author should use this test; you can just copy and paste it into any project).

### Final Thoughts

I love Perl. This port from Java to Perl was easier than I would have thought possible. I wanted to share my success in the hopes of spurring on others. Kudos go to Ken Williams and Patrick LeBoutillier and the others that have assisted them to build the tools that made this possible.

Cheers.
