{
   "tags" : [
      "configuration",
      "syntax"
   ],
   "date" : "2013-03-25T23:39:55",
   "image" : null,
   "authors" : [
      "david-farrell"
   ],
   "description" : "",
   "slug" : "5/2013/3/25/You-don-t-need-a-shebang-line",
   "categories" : "development",
   "draft" : false,
   "title" : "You don't need a shebang line"
}


The shebang line is the first line of code in a Perl script and usually looks like this:

```perl
#!/usr/bin/perl
```

The shebang line is the path to the Perl binary, and allows programmers to invoke Perl scripts directly instead of passing the script filename as an argument to Perl itself.

```perl
./myperltrick.pl #execute directly, no need to type 'perl' first
```

However, the shebang line is **not mandatory**, and reduces the portability of Perl scripts (by requiring execute permissions and maintaining the shebang). It also obfuscates which version of Perl is being called when a script is executed, which can make debugging more difficult.

```perl
./myperltrick.pl
Cant locate Catalyst.pm in @INC (@INC contains: /etc/perl /usr/local/lib/perl/5.14.2 /usr/local/share/perl/5.14.2 /usr/lib/perl5 /usr/share/perl5 /usr/lib/perl/5.14 /usr/share/perl/5.14 /usr/local/lib/site_perl .) at ./perltricks.pl line 2.
BEGIN failed--compilation aborted at ./perltricks.pl line 2.
BEGIN failed--compilation aborted.
# Hmm which version of Perl did I run ?
```

By not including the shebang line, programmers can write one-less line of code and retain modularity by separating the behaviour of the script from the executing programme.

```perl
perl myperltricks.pl #this works fine
```

Perl being Perl, it will try to 'Do What You Mean' if a script that contains a shebang line is passed to the Perl program as an argument, the shebang line will be ignored. So write or don't write the shebang, but you don't need it.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
