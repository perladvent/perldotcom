{
   "categories" : "security",
   "thumbnail" : "/images/115/thumb_BCF626CC-4583-11E4-951D-2D78FA3BB728.jpeg",
   "draft" : false,
   "authors" : [
      "david-farrell"
   ],
   "slug" : "115/2014/9/26/Shellshock-and-Perl",
   "image" : "/images/115/BCF626CC-4583-11E4-951D-2D78FA3BB728.jpeg",
   "title" : "Shellshock and Perl",
   "tags" : [
      "perl",
      "shellshock",
      "exploit",
      "bug",
      "vulnerability",
      "env",
      "system",
      "exec"
   ],
   "description" : "Understanding the Shellshock bug what it means for Perl",
   "date" : "2014-09-26T13:28:54"
}


Recently the tech media have been foaming at the mouth over a serious Bash [bug](https://securityblog.redhat.com/2014/09/24/bash-specially-crafted-environment-variables-code-injection-attack/) called Shellshock. The media [hype machine](http://www.wired.com/2014/09/internet-braces-crazy-shellshock-worm/) was in full-swing, replete with the absurd doomsday-like predictions that are rolled out every time a significant security vulnerability is found (remember heartbleed the "[ultimate web nightmare](http://mashable.com/2014/04/09/heartbleed-nightmare/)"?). Whilst it's wise to ignore the hype, don't ignore the issue; Shellshock is a serious risk that allows remote code injection and execution using Bash environment variables. This is also important for Perl as Perl has several touchpoints with the system shell, from the built-in functions [exec]({{</* perlfunc "exec" */>}}) and [system]({{</* perlfunc "system" */>}}) to the `%ENV` global variable.

### Is system "x" affected?

If the platform is a Unix-based operating system and Bash is the default terminal, it might be at risk. Redhat Linux, CentOS and Fedora, openSUSE, arch Linux as well as Mac OSX are vulnerable out of the box. A surprising number of platforms are not; freeBSD uses [tsch](https://www.freebsd.org/doc/en/articles/linux-users/shells.html), and modern versions of Debian and Ubuntu use [dash](https://wiki.ubuntu.com/DashAsBinSh) by default.

Every version of Bash through 4.3 is vulnerable to Shellshock. To find out your Bash version, fire up the terminal and enter this command to print the version:

```perl
$ echo $BASH_VERSION
4.2.47(1)-release
```

Seeing as my version of Bash is below 4.3, my system is possible vulnerable to Shellshock.

### How does Shellshock work?

Shellshock exploits a flaw in how Bash parses environment variables; Bash allows functions to be stored in environment variables, but the issue is Bash will execute any code placed after the function in the environment variable value. Let's craft an example:

```perl
$ export SHELLSHOCK="() { ignore; };echo danger"
```

This code creates a new environment variable called `SHELLSHOCK` (it's customary to have environment variable names in uppercase). The value of the new variable is an anonymous function which does nothing: `() { ignore; };` followed by: `echo danger` and it's the latter portion of this code which is the risk. Every time Bash processes its environment variables, that code will be executed. For example if I run that statement and then type:

```perl
$ bash -c "echo Hello, World"
danger
Hello, World
```

You can see that the word danger was printed, indicating my code embedded in the `SHELLSHOCK` variable was executed automatically by Bash. In the case of `echo danger` it's harmless, but an attacker could craft a malicious payload that caused irreparable harm, such as identity theft, data destruction or hardware damage.

In order for the Shellshock exploit to work, the attacker would need to achieve two things. First deliver an environment variable containing malicious code to the target host. Second, get the target host to start a new Bash process. The obvious target candidate for this are web servers hosting CGI scripts. CGI works by passing the request parameters as environment variables (such as the user agent name), if the target CGI script starts a new Bash process, the attack will work. You might be wondering why a script would start a new Bash process, which leads me on to how all of this relates to Perl in the first place.

### Perl shock

The first thing to say is that Perl has nothing to do with Shellshock, but there are a number of places where Perl may invoke the system shell, and it's these cases to be wary of. On Unix based systems Perl uses the shell binary located at `/bin/sh`, which is usually a symlink to the default shell binary (such as Bash). This means if Bash is the default shell on your system, when Perl calls out to `/bin/sh` a new Bash process will start, and the environment variables will be processed, thus Perl could be a trigger for invoking a Shellshock attack.

The Perl built-in functions `exec` and `system` will invoke a new shell process when used. You can also use backticks to invoke a system command. Other Perl functions *may* invoke the shell, for example `open` can be used to run system commands.

Let's see an example of Perl triggering Shellshock by invoking the shell via Perl:

```perl
$ perl -e 'system "echo test"'
test
```

Hmm what happened here? The command ran fine but "danger" was not printed - Shellshock failed. It turns out that Perl doesn't *always* invoke the shell using: `/bin/sh -c`. Instead to be more efficient, Perl will usually call [execvp](http://www.csl.mtu.edu/cs4411.ck/www/NOTES/process/fork/exec.html). According to [perldoc]({{</* perlfunc "system" */>}}), only when the system command contains [metacharacters](http://www.sal.ksu.edu/faculty/tim/unix_sg/shell/metachar.html), will Perl invoke the shell directly. Let's test that:

```perl
$ perl -e 'system "echo test >> test.log"'
danger
```

Aha, this worked! We used the metacharacters `>>` to redirect the output of `echo` into a log file, and Perl invoked the shell directly.

### The best defense is a great offense

Instead of worrying about whether our system calls contain metacharacters, we can go one better and delete the `SHELLSHOCK` environment variable before executing any system command. Perl stores the environment variables in `%ENV`, so I'll start by delete the variable from there:

```perl
$ perl -e 'delete $ENV{SHELLSHOCK};system "echo test >> shellshock.log"'
```

In this one liner, I'm front-running the risky `system`command with a `delete` of the `SHELLSHOCK` environment variable. I can see this thwarted Shellshock as "danger" was not printed out. Of course in this test environment I know the name of the dangerous environment variable, but usually I won't, so to find it, you'd have to iterate through the `%ENV` hash and delete (or substitute) any suspicious variable. This one liner prints risky environment variables by using a regex to identify any environment variable that contains code after a function declaration:

```perl
$ perl -E 'for (keys %ENV) { say if $ENV{$_} =~ /};.+/ }'
SHELLSHOCK
```

As you can see, it correctly identified the `SHELLSHOCK` environment variable and printed it to command line. From here it's a trivial step to delete the variable instead of printing it:

```perl
$ perl -e 'for (keys %ENV) { delete $ENV{$_} if $ENV{$_} =~ /};./ }'
```

This is just a proof-of-concept and may not handle all maliciously crafted Shell environment variables, but with more research, a robust regex could be deployed that completely nullified Shellshock.

### Conclusion

To recap, a successful Shellshock attack would need to pass an environment variable containing malicious code to a CGI script on a web server (like Apache), hosted on a vulnerable system, and the CGI script would have to invoke the Shell. For Perl CGI scripts, the system invocation would need to include metacharacters. This seems like a tall order, not yet understood by everyone; like the security [blogger](http://blog.erratasec.com/2014/09/bash-shellshock-bug-is-wormable.html#.VCVkj_ldVqU) who mistakenly labelled a cPanel CGI script as vulnerable. Although CGI was popular back in the day, all the modern Perl web frameworks use [FastCGI](http://www.fastcgi.com/drupal/node/6?q=node/15) and are immune to Shellshock. Modern web servers do not enable CGI by default and some like nginx do not even ship with CGI capability.

The safest way to handle Shellshock on a vulnerable system is to patch Bash to the latest version. Although I've shown it's possible to thwart the attack using Perl, there may be other unanticipated attack vectors that remain open.

**Correction:** *removed erroneous description of $SHELL as it is the current user's default login shell, not the default shell. Removed reference to .bashrc as Bash will only process .bashrc during interactive shell startup. 2014-09-27*

*Cover image Ebola virus particles [©](https://creativecommons.org/licenses/by/4.0/) [NIAID](https://www.flickr.com/photos/niaid/8425030684/in/photolist-dQuu6J-o15Y5n-oq5wzY-oD1uxC-oq68Cn-8r1Hp8-oDe3A2-oDe3za-dPiDp3-ossh3B-2j1bum-jQvxq9-oq59Z4-oq5muj-omJEd1-omJzrD-4JZtfw-aronSf-8GSyC4-68Zxqv-9y7vkf-dPzNiw-5WLSVq-6hZDW8-nds12g-5Wtkeh-6hNQv2-6irCWw-6iQKwC-bS1gap-Jx5bZ-bjfWK2-bjfWiv-dQSzhC-6iUKSo-6ik4Ki-6i3YrM-cXXqXy-64vTm8-cCwK63-8LVkQh-sxxGP-dTpMUd-Dj4uW-6mhvwX-6iGBED-9rwqiP-8R5WMy-9yXaMc-6isfVm)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
