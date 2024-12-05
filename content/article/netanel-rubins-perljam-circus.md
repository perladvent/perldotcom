{
   "date" : "2016-03-01T08:57:00",
   "categories" : "security",
   "image" : "/images/netanel-rubins-perljam-circus/cover.jpg",
   "description" : "Responding to a misguided attack on Perl",
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/netanel-rubins-perljam-circus/thumb_cover.jpg",
   "title" : "Netanel Rubin's Perl Jam circus",
   "tags" : [
      "chaos_communication_congress",
      "ccc",
      "black_hat",
      "netanel_rubin",
      "infosec"
   ],
   "draft" : false
}


I've just watched Netanel Rubin's Perl Jam 2 [talk](https://www.youtube.com/watch?v=eH_u3C2WwQ0) from this year's Chaos Communication Congress. As he's due to give the same talk at [Black Hat Asia](https://www.blackhat.com/asia-16/), I thought it would be good to set the record straight concerning his claims about Perl ([others](https://gist.github.com/preaction/978ce941f05769b064f4) have already done so). He makes 3 major claims:

1. The Perl language is insecure
2. Bugzilla & CGI.pm are representative of idiomatic Perl
3. Perl doesn't improve

I'm going to address each claim in turn and show why it is false. In my view, Perl remains a powerful, general-purpose language well-suited to tasks like building dynamic web applications, processing big data, and managing systems.

### Claim 1: The Perl language is insecure

> Function declarations cannot specify argument data types
>
> -- <cite>Netanel Rubin, The Perl Jam 2</cite>

This isn't true. Since 2008 Perl has supported subroutine signatures, with type checks using the [Method::Signatures]({{<mcpan "Method::Signatures" >}}) module. Since 2006 the [Moose]({{<mcpan "Moose" >}}) object system provided a fully-fledged [type system]({{<mcpan "Moose::Util::TypeConstraints" >}}) and meta object programming interface (there's also [MooseX::Method::Signatures]({{<mcpan "MooseX::Method::Signatures" >}})).

> Developers treat hashes and arrays as "secure" data types ... this is the Perl standard. You're not expected to use it, you have to, as you don't have any other choice. This security mess is a fundamental part of the language.
>
> -- <cite>Netanel Rubin, The Perl Jam 2</cite>

Netanel starts by describing taint mode and claims that hashes are so secure, hash keys bypass Perl's taint check. It's true that hash keys are never considered tainted. This is documented in [perlsec]({{< perldoc "perlsec" "Taint-mode" >}}) and discussed in depth in Chapter 2 of [Mastering Perl](http://masteringperl.org). But it's not because hashes are assumed to be secure, it's because hash keys aren't full scalar values. He never explains his claim as to why arrays are considered secure.

Perl's `ref` function is a reliable and secure way to determine the data type of a reference. Arguments passed to functions are always passed as an array of scalars via `@_`. There is no doubt, no ambiguity. It's not required security-wise, but if you want to use them you can use function signatures, types and meta-object programming in Perl. They've been available for years.

> But I felt all of these points will go unnoticed without an extreme example of Perl's absurdity. So I found an extreme example. One that will clearly show the ridiculousness nature of the language.
>
> -- <cite>Netanel Rubin, The Perl Jam 2</cite>

This is the vulnerable code, from an example CGI application:

```perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;

if ($cgi->upload( 'file' )) {
  my $file = $cgi->param( 'file' );
  while (<$file>) {
    print "$_";
  }
}
```

The issue with this code is that if `$file` has the value of `ARGV`, the diamond operator `<$file>` will call `open` on every value in `@ARGV`. CGI populates `@ARGV` with the HTTP query parameters which creates the vulnerability. So if the HTTP query parameter is `ls|`, Perl will execute `ls`. If the CGI program was running in taint mode, this attack vector would fail. Regardless, it's a well-understood risk, {{<stale-link "the PLEAC project's Perl recommendations from 1999" "http://web.archive.org/web/20160317035754/ramenlabs.com/pleac-pdf/pleac_perl.pdf" "http://ramenlabs.com/pleac-pdf/pleac_perl.pdf">}}  shows how to properly parse file descriptors in CGI parameters (ex 19.4). O'Reilly's [CGI Programming on the Web](http://www.oreilly.com/openbook/cgi/ch07_04.html) by Shishir Gundavaram recommended parsing metacharacters like `|` from user input, which also prevents this attack. That book was published in 1996.

The piping open behavior is well documented in [open]({{< perlfunc "open" >}}), [perlipc]({{< perldoc "perlipc" "Using-open%28%29-for-IPC" >}}) and [perlsec]({{< perldoc "perlsec" >}}). Chapter 2 of [Mastering Perl](http://masteringperl.org) also covers it. It's a useful feature when you want to efficiently process a lot of data from an external command: just like a shell pipe, it creates a socket between the Perl program and the external binary, avoiding the need to read the entire output into memory at once.

Netanel also identified a SQL injection vulnerability in Bugzilla. The weakness was caused by a poorly-coded function which failed to properly validate input used in a dynamic SQL query. The developers should have used the safer pass-by-parameter [DBI]({{<mcpan "DBI" >}}) `prepare` and `execute` functions.

In both cases Perl provided methods for securely parsing untrusted input, but the developers didn't use them.

### Claim 2: Bugzilla & CGI.pm are representative of idiomatic Perl
> Like every other Perl project, Bugzilla is heavily using functions that treat scalar and non-scalar argument types very differently.
>
> -- <cite>Netanel Rubin, The Perl Jam 2</cite>

Netanel is referring to this code from his talk, which uses the argument type to decide what to do:

```perl
sub test {
  $arg1 = @_; # Get an argument

  if (ref $arg1 eq 'HASH')
    print $arg1{'key'};
  else
    print $arg1;
}
```

Aside from the fact that Netanel's code contains a big error which means it would never work, the claim that every other Perl project is coded in this way is preposterous. [Dist::Zilla]({{<mcpan "Dist::Zilla" >}}) is a popular Perl project with over 20,000 lines of code. Can you guess how frequently Dist::Zilla uses the construct Netanel describes? A quick grep of the code shows zero instances. Bugzilla was developed in 1998, it is not an example of [Modern Perl](http://modernperlbooks.com/books/modern_perl_2014/index.html).

Regarding CGI.pm, I can't say it better than the official [documentation]({{<mcpan "CGI" >}}):

> CGI.pm HAS BEEN REMOVED FROM THE PERL CORE
>
> The rationale for this decision is that CGI.pm is no longer considered good practice for developing web applications, including quick prototyping and small web scripts. There are far better, cleaner, quicker, easier, safer, more scalable, more extensible, more modern alternatives available at this point in time.
>
> -- <cite>CGI.pm documentation</cite>

### Claim 3: Perl doesn't improve
Things get interesting during the Q&A section of the talk when an audience member says:

> We use Perl for almost every module that we have at work, and it works really fine. I don't know why you are picking Perl as a language to attack. It's a really old language, and every language you can pick has problems, it doesn't mean that ... you have to stop using it.
>
> -- <cite>Audience Member, The Perl Jam 2</cite>

Netanel responds:

> C got criticized and it improved. PHP got criticized and it improved. Why can't Perl be criticized too? ... why don't they improve the language?
>
> -- <cite>Netanel Rubin, The Perl Jam 2</cite>

The funny thing is Perl is improving all the time. Every year there is a major release of Perl which brings new features and enhancements to the language ([history]({{< perldoc "index-history" >}})). Last year's [release]({{< perldoc "perldelta" >}}) included a new operator, the [double diamond](http://www.effectiveperlprogramming.com/2015/05/use-perl-5-22s-operator-for-safe-command-line-handling/) `<< >>` which disables the piping open behavior shown earlier. CGI.pm was removed from Perl's core modules list in May 2014. Both of those occurrences predate Netanel's talk.

Instead of waiting for a major release milestone, the Perl development team can fix critical security issues in a minor release if needed (for example see [5.16.3]({{< perldoc "perl5163delta" >}})).

Perl also has a strong toolchain for evaluating Perl code. [Perl::Critic]({{<mcpan "Perl::Critic" >}}) is a linter that reviews Perl code against recommended coding practices. There is even a [policy]({{<mcpan "Perl::Critic::Policy::ValuesAndExpressions::PreventSQLInjection" >}}) to check for potential SQL injection vulnerabilities.

### Conclusion
> You can't always live in the fear of not knowing what data type you are trying to handle ... not trusting your hashes, not trusting your arrays, what's next, not trusting your own code?
>
> -- <cite>Netanel Rubin, The Perl Jam 2</cite>

As someone who has years of experience writing professional Perl code, and working with Perl programmers, I do not recognize this experience at all. All Netanel has shown is an attack on some example code from a neglected module and a SQL injection bug in a legacy application.

Is the Ruby language to blame for a vulnerability in [Ruby-on-Rails](http://arstechnica.com/business/2012/03/hacker-commandeers-github-to-prove-vuln-in-ruby/)? Is PHP insecure because over 950 [exploits](https://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=wordpress) were found for WordPress? This isn't a dynamic language issue either; in [Static vs. dynamic languages: a literature review](http://danluu.com/empirical-pl) author Dan Luu found little evidence that statically typed languages were safer than dynamic ones.

Anytime you fail to adequately parse untrusted input you're going to have a bad day. Blaming Perl for developers' bad code is like blaming the Alphabet for being turned into 50 Shades of Grey.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
