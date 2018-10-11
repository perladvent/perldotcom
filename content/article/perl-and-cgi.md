{
"title" : "Perl and CGI",
"authors" : ["dave-jacoby"],
"date" : "2018-10-03T18:41:08",
"tags" : ["cgi","module","web"], 
"draft" : true,
"image" : "",
"thumbnail" : "",
"description" : "The CGI module helped Perl grow when the web first blew up. Now it's out of Core and discouraged. What happened?",
"categories" : "cpan"
}

# Perl and CGI

LESS DEPRESSING INTRO HERE

## What is CGI

CGI is Common Gateway Interface, and allows you to use alternate IN OUT ERR

## Processing input (e.g. a form submission)

FORM -> GET

FORM -> POST

## Generating HTML (why not to do it with CGI, TT example)

GRR!

## Configuring CGI on a web server

Apache!

## Why not to use CGI (limitations, alternatives)

## Useful CGI references (articles, books, modules, documentation that might help users)

# IGNORE/STEAL FROM BELOW THIS LINE

[In May 2013, Ricardo Signes, then Perl5 Pumpking, sent this to the Perl5 Porters list](https://www.nntp.perl.org/group/perl.perl5.porters/2013/05/msg202130.html):

> I think it's time to seriously consider removing CGI.pm from the core distribution. It is no longer what I'd point _anyone_ at for writing _any_ sort of web code. It is in the core, as far as I know, because once it was the state of the art, and a major reason for many people to use the language. I don't think either is true now. Finally, if you need CGI, it's easy to install after installing perl, just like everything else we've dropped from the core distribution.
>
> In the past two years, all my interactions with CGI.pm have been to fix bugs or send pull requests to quiet it from making noise in the core. I expect others here have had the same experience.

It was marked deprecated with 5.20, the next major release, and removed from Core with 5.22. This is not catastrophic; it is still available in CPAN, so you would have to install it, or have your administrator install it, depending on your environment.

But it **is** a significant change.

## Starting From The Beginning

Before HTTP was **FTP**, the _File Transfer Protocol_, and it's job was, clearly, to transfer files. There was a technique, called Anonymous FTP, where you were allowed GET access by logging in with `anonymous` as the login. When Tim Berners-Lee created the _HyperText Transfer Protocol_, the users were able to view the downloaded material in the browser instead of using a text editor to view it once it was downloaded. But it was still moving around static material, and for the kind of things we wanted to do on the web (like blogs and catalogs), it would be very useful to allow user input.

The solution was the [_Common Gateway Interface_](https://tools.ietf.org/html/rfc3875#section-6.2.1), or CGI. It allowed the web server to run a program and transfer the output, rather than transfer the program itself.

Of course, you might want to be able to transfer a program. There were two ways around this. The first is to have `cgi-bin` directories where every file gets executed instead of transferred. The Apache httpd.conf file would have this.

```
    <Directory "/home/*/www/cgi-bin">
        Options ExecCGI
        SetHandler cgi-script
    </Directory>
```

The other possibility is to allow CGI to be enabled in a directory, with a configuration that looks like this:

```
<Directory "/home/*/www">
    Options +ExecCGI
    AddHandler cgi-script .cgi
</Directory>
```

And then add a **.htaccess** file that looks like this:

```
AddHandler cgi-script .cgi
Options +ExecCGI
```

So that `foo.pl` will transfer but `foo.cgi` will run, even if both are executable.

## CGI without CGI.pm

A program commonly needs three communication channels: Input, Output and Error. The program's errors end up in the server's error log, likely in `/var/log/httpd/error.log`, and the output goes to standard out, so `print "text"` is all you need.

Almost.

An HTTP message contains two parts: The _Header_ and the _Body_, and, depending on the Header, the Body might not be necessary. The simplest possible CGI program isn't even Perl:

```bash
#!/bin/bash
echo 'location: https://perl.com/'
echo
```

Go to this and you will immediately be transferred to [perl.com](https://perl.com/). I believe that there should be an accompanying status code, such as `echo "status: 302"`, but thanks to [Postel's Law](https://en.wikipedia.org/wiki/Robustness_principle), the above code has always worked.

The simplest program that would return a value would be something more akin to

```bash
#!/bin/bash
echo 'status: 200'
echo 'content-type: text/plain'
echo
echo 'a value'
```

The content-type is a [**Multipurpose Internet Mail Extension (MIME) type**](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types), and it determines how the browser handles the message once it returns. The above example treats the "a value" message as text, and displays it as such. If the content-type was "text/html", it would be parsed for HTML like a web page. If it was "application/json", it might be displayed like text, or formatted into a browsable form, depending on your browser or extensions. If it was "application/vnd.ms-excel" or even "text/csv", the browser would likely open in in Excel or another spreadsheet program.

And, if the program was this --

```bash
#!/bin/bash
echo 'status: 200'
echo 'content-type: image/png'
echo
cat images/author/dave-jacoby.jpg
```

-- you would get this:

![/images/author/dave-jacoby.jpg](/images/author/dave-jacoby.jpg)

## How About Input?

There are two or three main ways to get data into a CGI program, and these are where the value of having Perl and [CGI](https://metacpan.org/pod/CGI/) comes apparent.

Input is passed in via environment variables, which we can see by printing %ENV.

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

What we get could look something like this, minus a few fields for sake of privacy and brevity:

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

Much of this is stuff that will be of minimal use, but the empty `QUERY_STRING` entry might draw your attention. If you simply add `?foo=bar` to the end of the URL and you get these entries:

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

And we lose the values in `QUERY_STRING` but gain a value in `CONTENT_LENGTH`.

```text
CONTENT_LENGTH
	7
QUERY_STRING

REQUEST_METHOD
	POST
```

`CONTENT_LENGTH` tells you how much data to read from STDIN --

```perl
read( STDIN, my $form_data, $ENV{CONTENT_LENGTH} );
```

-- and then you have to parse it, handling repeated key names and such, and this is where **CGI** comes to the rescue, because with CGI, you do

```
#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;
my $method = $ENV{REQUEST_METHOD} ;
my %param = map { $_ => scalar $cgi->param($_) } $cgi->param() ;
print qq{status: 200\n};
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

You can send larger forms via POST. You can also use it to upload files. But both present data in `$cgi->param()`. This allowed me, and presumably, many other developers, to kinda fudge the difference between GET and POST most of the time. When the data was big, or when I really didn't want it in the URL, use POST, otherwise use GET.

Much of the URL is determined from directory paths: if it's `http://example.com/users/jacoby/test.cgi`, you would expect to find test.cgi in `DOCUMENT_ROOT/users/jacoby`. But how about `http://example.com/users/jacoby/wiki.cgi/RecentChanges`?

There, the environment variable `PATH_INFO` would be set to `/RecentChanges`, and it would be up to the code to return a page listing the wiki's most recent changes. Or, if it was `/WebDevelopmentHistory`, it could either show a document much like the one I'm writing now, or a form allowing you to write your own.

Between these three input methods that are given by two methods, CGI shows itself as the Getopt::Long of the Web.

## Headers

And CGI will also handle the headers I mentioned above. Since web pages are the default, `print $cgi->headers` will give you:

```text
Content-Type: text/html; charset=ISO-8859-1
```

But ISO-8859-1 is an old character set, which is mostly ASCII, which excludes a whole lot of characters you may want available, including the symbol for the Euro, languages with non-Latin character sets, and emoji. So, `print $cgi->header(-charset=>'UTF-8')` give you. 

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

You may want to set the **expires** header, which tells the browser and other caches how long that page would be good for. You can also set cookies to sets and retrieves persistent data to insert state into the stateless protocol that is HTTP.

## Writing HTML with CGI

Don't do it.

Don't believe me; believe [the documentation for CGI.pm](https://metacpan.org/pod/CGI#HTML-Generation-functions-should-no-longer-be-used)**.

> All HTML generation functions within CGI.pm are no longer being maintained. Any issues, bugs, or patches will be rejected unless they relate to fundamentally broken page rendering.
>
> The rationale for this is that the HTML generation functions of CGI.pm are an obfuscation at best and a maintenance nightmare at worst. You should be using a template engine for better separation of concerns. See [CGI::Alternatives](https://metacpan.org/pod/CGI::Alternatives) for an example of using CGI.pm with the [Template::Toolkit](https://metacpan.org/pod/Template::Toolkit) module.

The HTML-generation aspects of CGI were pretty rough. To recreate the form used above, to demonstrate the difference between GET and POST, we would have to do this: 

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

And, of course, as HTML changes, the HTML you want to generate changes, and CGI just didn't move forward, with a very clunky interface. 

I will add to this that, while Template Toolkit is a great templating engine, it is an engine that only works with Perl, and to allow you to use the same templates on both client and server, you might want to look at [Text::Handlebars](https://metacpan.org/pod/Text::Handlebars).

(Well, [there is a JS implementation of TT](https://github.com/ashb/template), so...)

## Why You Don't Want to `use CGI`

There are two big issues with code: speed and complexity. You want to increase speed, because the longer a user has to wait, more likely that user is to not wait, but to go to another site. You want to decrease complexity, because the more places you have to go to change, for example, the look and feel of your website, the less likely that change will go to everywhere it needs to.

In 2005, David Heinemeier Hansson released Ruby on Rails, a web framework that addressed both issues. All the endpoints are defined in one web application, rather than being thrown around a large directory structure. You run a persistent applications server, rather than finding, opening and running each executable each time. 

There are a few web frameworks written in Perl; among them are [Catalyst]( https://metacpan.org/pod/Catalyst::Manual), [Dancer](
https://metacpan.org/pod/Dancer2), and [Mojolicious](
https://metacpan.org/pod/Mojolicious). They all use [the PSGI interface](https://plackperl.org/) to run on application servers such as Plack and Starman. These are the tools that are suggested in the CGI documentation.

## Ending

As the Web grew in the 1990s and early 2000s, CGI and Perl grew with it. This fact is borne out by O'Reilly's developer's conference, OSCON, was first the Perl Conference.

But time moved on, and different styles of web development came forward. CGI's still available on CPAN, and many Linux distros still come with pre-5.20 versions of Perl. For many good reasons, it is no longer how we thing you should use Perl for the web.

But you certainly can do some fun things with it.