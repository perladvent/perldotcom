{
   "image" : null,
   "date" : "2013-04-10T21:48:42",
   "slug" : "16/2013/4/10/Test-if-the-user-is-root",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "flow",
      "linux",
      "unix",
      "variable",
      "windows",
      "mac"
   ],
   "title" : "Test if the user is root",
   "description" : "When Perl is executing a program, it maintains the user id of the process owner in a global variable ($<). When a Perl program is executed by root or a user with root privileges (e.g. using the sudo command), the user id variable is always set to zero. This can be checked at the command line:",
   "categories" : "development",
   "draft" : false
}


When Perl is executing a program, it maintains the user id of the process owner in a global variable ($\<). When a Perl program is executed by root or a user with root privileges (e.g. using the sudo command), the user id variable is always set to zero. This can be checked at the command line:

``` prettyprint
$ perl -e 'print $< . \n;'
1000
$ sudo perl -e 'print $< . \n;'
0
```

Because the root user id is always zero and in Perl zero is treated as false, it is a trivial task to test if the user is root during runtime. This can be used to for flow control, such as exiting the program early:

``` prettyprint
use Carp qw/croak/;

if ($<) {
    croak "Error: exiting program as not executed by root\n";
}
```

In Windows the user id variable is always set to zero and is of limited use. However the Perl [Win32](https://metacpan.org/module/Win32) module has the Win32::IsAdminUser() method that can be used instead of $\<, like this:

``` prettyprint
use Win32;
use Carp qw/croak/;

if (not Win32::IsAdminUser()) {
    croak "Error: exiting program as not executed by root\n";
}
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
