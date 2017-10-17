{
   "categories" : "data",
   "draft" : false,
   "image" : null,
   "date" : "2013-09-17T03:18:10",
   "title" : "How to Load YAML Config Files",
   "description" : "Reading YAML config files is easy with Perl",
   "tags" : [
      "configuration",
      "config",
      "yaml",
      "libyaml",
      "old_site"
   ],
   "authors" : [
      "david-farrell"
   ],
   "slug" : "29/2013/9/17/How-to-Load-YAML-Config-Files"
}


Config files are used by programmers to store local variables as it's usually better to update a config file than to edit source code. [YAML](http://www.yaml.org/spec/1.2/spec.html#Introduction) is a popular data serialization language that's easy to read and can serialize the common Perl variables (scalars, arrays and hashes). This article describes how to read a YAML config file in Perl and access the config file's variables.

### The config file

YAML defines different types of [data collections](http://www.yaml.org/spec/1.2/spec.html#id2759963) that can be used to serialize (represent or store) Perl variables. Let's define a YAML config file to store some local email data. The config.yaml file could look like this:

    ---
    emailName: David
    emailAddresses: 
        - sillymoos@cpan.org
        - perltricks.com@gmail.com
    credentials:
        username: sillymoose
        password: itsasecret

Let's walkthrough config.yaml: the config file starts with three hyphens ("---") to signify the start of the document, "emailName": is a scalar mapping with the value "David", "emailAddresses" is a sequence of email addresses and "credentials" is a mapping of scalar mappings for the email username and password.

### Load the config file

Perl's [YAML::XS](https://metacpan.org/module/YAML::XS) module provides a `LoadFile` subroutine that can be used to read any YAML file into a scalar variable. This script loads the "config.yaml" config file and prints it using [Data::Dumper](https://metacpan.org/pod/Data::Dumper):

``` prettyprint
use strict;
use warnings;
use YAML::XS 'LoadFile';
use Data::Dumper;
    
my $config = LoadFile('config.yaml');

print Dumper($config);
```

If we run this script we get the following results:

``` prettyprint
$VAR1 = {
          'emailName' => 'David',
          'credentials' => {
                           'password' => 'itsasecret',
                           'username' => 'sillymoose'
                         },
          'emailAddresses' => [
                              'sillymoos@cpan.org',
                              'perltricks.com@gmail.com'
                            ]
        };
```

These results show that config.yaml has been read into `$config` as a hash reference with three keys: "emailName", "credentials" and "emailAddresses".

### Accessing the config data

So far the script reads the contents of config.yaml into `$config`. To access the config data we need to dereference the data from `$config`. The following script shows examples of accessing the config scalar, array and hash data.

``` prettyprint
use YAML::XS 'LoadFile';
use feature 'say';

my $config = LoadFile('config.yaml');

# access the scalar emailName
my $emailName = $config->{emailName};

# access the array emailAddresses directly
my $firstEmailAddress = $config->{emailAddresses}->[0];
my $secondEmailAddress= $config->{emailAddresses}->[1];

# loop through and print emailAddresses
for (@{$config->{emailAddresses}}) { say }

# access the credentials hash key values directly
my $username = $config->{credentials}->{username};
my $password = $config->{credentials}->{password};

# loop through and print credentials
for (keys %{$config->{credentials}}) {
    say "$_: $config->{credentials}->{$_}";
}
```

### More YAML

[YAML::XS](https://metacpan.org/module/YAML::XS) uses the libyaml C library and provides strong performance and adherence to the YAML specification. However if you have difficulty installing YAML::XS, there are pure Perl alternatives available: [YAML](https://metacpan.org/module/YAML) is not actively maintained and has several bugs but excellent documentation and generally works, [YAML::Tiny](https://metacpan.org/module/YAML::Tiny) is a newer module that implements a useful subset of the YAML specification.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
