{
"title" : "Perl and CGI",
"authors" : ["dave-jacoby"],
"date" : "2018-10-03T18:41:08",
"tags" : [cgi,module,web],
"draft" : true,
"image" : "",
"thumbnail" : "",
"description" : "The CGI module helped Perl grow when the web first blew up. Now it's out of Core and discouraged. What happened?",
"categories" : "cpan"
}

# Perl and CGI

"It is in the core, as far as I know, because once it was the state of the art, and a major reason for many people to use the language."

[This is what Ricardo Signes wrote to Perl5 Porters in 2013](https://www.nntp.perl.org/group/perl.perl5.porters/2013/05/msg202130.html), when he suggested removing CGI.pm from Core.

In the 1990s, as the web started to grow, we wanted to be able to do more with the web, and that was largely with CGI, with Perl, with the CGI module.

[CGI was removed from Perl Core in May 2014](https://perl5.git.perl.org/perl.git/commitdiff/e9fa5a80), with the release of 5.20. It's available [on CPAN](https://metacpan.org/pod/CGI). GRR GRRR GRR SEGUE

## What is CGI?

If you want to run a command on a remote machine, you can make it less remote, connect to it and run it or just

> `ssh host ls`

We can see CGI as similar, but instead, we're using the hypertext transfer protocol (HTTP) instead of secure shell.

[CGI](https://tools.ietf.org/html/rfc3875.html) stands for _Common Gateway Interface_ and is the way web servers like Apache can run programs instead of just serving static files.

There are the three main connections to a program: the input stream, the output stream, and the error stream. With CGI, STDOUT is what the server sends to the browser, and the error goes to the server's error log.

And input? We'll get to that.

## CGI without CGI

You don't _need_ a lot of overhead to do this work. The basics of a HTTP response are, very simply:

```
HEADER

BODY
```

And `BODY` is optional. Take this very simple CGI program.

```bash
#!/bin/bash
echo 'location: https://perl.com/'
echo
```

This redirects the browser to a new page; in this case, perl.com. The header can have many lines, separated by newlines.

The most common use for this is setting the `Content-Type`, which tells the browser what to expect and what to do with it. Most common is `text/html`, which tells the browser it's a web page.

```bash
#!/bin/bash
echo 'Content-Type: text/html'
echo
echo '<html>HTML!</html>'
```

But it doesn't have to be. Want to make a modern-like AJAX thing? `Content-Type: application/json`. Want to send some comma-separated-value text, which might be the output of a database query? `Content-Type: text/csv` or even `application/vnd.ms-excel`, which should open it in a spreadsheet.

Or even...

```bash
#!/bin/bash
echo content-type: image/jpeg
echo
cat dave_jacoby.jpg
```

Yes, if it has a MIME type, you can send it dynamically.

## CGI.pm: The Good Parts

I mentioned input above, and the way you get input to your program with CGI is basically with environment variables. Our new program, now with perl in the hashbang, looks like this:

```perl
#!/usr/bin/perl
use strict;
use warnings;

print qq{content-type: text/plain\n\n};
for my $k ( sort keys %ENV ) {
    print join "\n\t", $k, $ENV{$k};
    print qq{\n};
}
```

And the output will look something like this:

```text
GATEWAY_INTERFACE
	CGI/1.1
HTTPS
	1
HTTP_ACCEPT
	text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8
HTTP_CONNECTION
	keep-alive
HTTP_HOST
	example.com
HTTP_USER_AGENT
	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36
HTTP_X_FORWARDED_PROTO
	https
PATH
	/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
QUERY_STRING

REQUEST_METHOD
	GET
REQUEST_SCHEME
	http
REQUEST_URI
	/~djacoby/simple.cgi
```

I cut out some for space and some for anonymity, but this gives you the flavor. Much of this is stuff that will be of minimal use, but the empty `QUERY_STRING` entry might draw your attention. If you simply add `?foo=bar` to the end of the URL and you get these entries:

```text
QUERY_STRING
	foo=bar
REQUEST_METHOD
	GET
```

So, now, let's make a web page like this:

```html
<!DOCTYPE html>
<html>
<head>
</head>
<body>
    <form method="POST" action="/path/to/simple.cgi">
        <input type="text" name="foo" value="bar">
        <input type="submit">
    </form>
</body>
</html>
```

And click "submit". The response is like:

```text
QUERY_STRING

REQUEST_METHOD
	POST
```

The `foo=bar` info is somewhere. I have parsed it without CGI. Decades ago. But for the life of me, I forget how.

We have hit the big reason why we want to use the CGI module: it is the [Getopt::Long](https://metacpan.org/pod/Getopt::Long) for the (early) web, because if we start using CGI:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use CGI ;

my $cgi = CGI->new;
my $method = $ENV{REQUEST_METHOD} || 'GET' ;
my %param = map { $_ => scalar $cgi->param($_) } $cgi->param() ;

print qq{content-type: text/plain\n};
print qq{\n};
print qq{METHOD:\t$method\n};
print qq{PARAM:};
for my $k ( sort keys %param ) {
    print join "\t", '',$k, $param{$k},"\n"
}
```

And run it with `?foo=bar`, we get this output:

```text
METHOD:	GET
PARAM:	foo	bar
```

And from that form:

```
METHOD:	POST
PARAM:	foo	bar
```

You can send much more data with POST than with GET, but to the Perl developer using CGI.pm, they are effectively interchangable. For me, this lead me to be agnostic about the differences between REQUEST_METHODs until the rise of AJAX and REST.

We started off handling header information, so let's hit them again. We can get a standard header from CGI like this:

```perl
print $cgi->header;
```

And get this.

```text
Content-Type: text/html; charset=ISO-8859-1
```

We're well into the 21st Century and we like expanded character sets, because then we can have ligatures and emoji and all.

```perl
print $cgi->header(-charset=>'UTF-8');
```

```text
Content-Type: text/html; charset=UTF-8
```

And the two other headers discussed were MIME types and redirects:

```perl
print $cgi->header( -type    => 'image/jpg', );
print $cgi->redirect( 'https://perl.com/' );
```

```text
Content-Type: image/jpg; charset=UTF-8

Status: 302 Found
Location: https://perl.com/
```

## The Other Stuff

When you read [the documentation for CGI.pm](https://metacpan.org/pod/CGI), you see a few things. Right after the description is a section named **CGI.pm HAS BEEN REMOVED FROM THE PERL CORE**, followed by **[HTML Generation functions should no longer be used](https://metacpan.org/pod/CGI#HTML-Generation-functions-should-no-longer-be-used)**.

> All HTML generation functions within CGI.pm are no longer being maintained. Any issues, bugs, or patches will be rejected unless they relate to fundamentally broken page rendering.
>
> The rationale for this is that the HTML generation functions of CGI.pm are an obfuscation at best and a maintenance nightmare at worst. You should be using a template engine for better separation of concerns. See [CGI::Alternatives](https://metacpan.org/pod/CGI::Alternatives) for an example of using CGI.pm with the [Template::Toolkit](https://metacpan.org/pod/Template::Toolkit) module.

Yeah. To demonstrate, this is how to recreate the form above, using CGI to generate the HTML.

```perl
my $output;
$output .= $cgi->start_form(
    -method => "post",
    -action => "/path/to/simple.cgi"
);
$output .= $cgi->textfield( -name => 'foo', -value => 'bar' );
$output .= $cgi->submit;
$output .= $cgi->end_form;
print $output;
```

Or, we could just do a heredoc:

```perl
print <<"END";
    <form method="POST" action="/path/to/simple.cgi">
        <input type="text" name="foo" value="bar">
        <input type="submit">
    </form>
END
```

Or, of course, Template Toolkit.

HTML was, is and will remain a moving target, changing with browser capabilities.

I will add to this that, while Template Toolkit is a great templating engine, it is an engine that only works with Perl, and to allow you to use the same templates for client and server generation, or to just lessen the cognitive load, you might want to look at [Text::Handlebars](https://metacpan.org/pod/Text::Handlebars).

(Well, [there is a JS implementation of TT](https://github.com/ashb/template), so...)

## Why Not CGI?

Cohesive code. Response time. Ruby on Rails.

With CGI and traditional web, the architecture is largely controlled by directory structure, with `http://example.com/code/sample.cgi` being in `DOCUMENT_ROOT/code/sample.cgi`, and each one is likely built to the standards of that developer and the web at that point in time. They may use the same JavaScript and CSS files, but they might not. Each one exists and behaves as their own project, making source control difficult, and this forces you to make changes across perhaps hundreds of files rather than in one place.

Plus, when you call a CGI program, there is an irreducible amount of startup time: find the program, load the Perl executable, parse the code. With frameworks, you have an application server that is already running, so that the startup overhead is removed. This is key. I believe that the current heuristic is that, if the page doesn't load in under two seconds, the user is likely to go somewhere else.

There are many web frameworks in Perl for you to choose from. The big ones are [Catalyst](http://www.catalystframework.org/), [Dancer](http://perldancer.org/) and [Mojolicious](https://mojolicious.org/). They use [PSGI/Plack](https://plackperl.org/) to bring a more cohesive [MVC](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)-style environment for developing more complex web applications.
