{
   "thumbnail" : null,
   "date" : "2018-11-12T10:36:08",
   "categories" : "web",
   "draft" : false,
   "title" : "Perl and CGI",
   "description" : "The CGI module helped Perl grow when the web first blew up. Now it's out of Core and discouraged. What happened?",
   "authors" : [
      "dave-jacoby"
   ],
   "tags" : [
      "cgi",
      "mvc",
      "catalyst",
      "dancer",
      "mojolicious",
      "template-toolkit"
   ],
   "image" : null
}

CGI stands for [Common Gateway Interface](https://tools.ietf.org/html/rfc3875#section-6.2.1), it's a protocol for executing scripts via web requests, and in the late 1990's was the main way to write dynamic programs for the Web. It's also the name of the Perl [module]({{< mcpan "CGI" >}}) we used (and for me, still use) to code for the web.

**Warning** you probably don't want to use CGI for modern web development, see [Why Not to Use CGI](#why-not-to-use-cgi).

## CGI and HTTP

You've probably heard of HTTP (HyperText Transfer Protocol), which is the communications protocol used by most Internet services. Broadly speaking, CGI programs receive HTTP requests, and return HTTP responses. An HTTP response header must include the status and the content-type. CGI (the interface) makes this easy.

We could hardcode a Perl script to return an HTTP response header and HTML in the body:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
print <<'END';
Status: 200
Content-type: text/html

<!doctype html>
<html> HTML Goes Here </html>
END
```

But CGI.pm can handle the header for us:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use CGI;
my $cgi = CGI->new();
print $cgi->header;

print <<'END';
<!doctype html>
<html> HTML Goes Here </html>
END
```

Of course, you don't have to just send HTML text. 

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use CGI;
my $cgi = CGI->new();
print $cgi->header( -type => 'text/plain' );

print <<'END';
This is now text
END
```

But that is not the limit, by far. The content-type is a [Multipurpose Internet Mail Extension (MIME) type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types), and it determines how the browser handles the message once it returns. The above example treats the "This is now text" message as text, and displays it as such. If the content-type was "text/html", it would be parsed for HTML like a web page. If it was "application/json", it might be displayed like text, or formatted into a browsable form, depending on your browser or extensions. If it was "application/vnd.ms-excel" or even "text/csv", the browser would likely open in in Excel or another spreadsheet program, or possibly directly into a gene sequencer, like happens to those I generate at work.

And, if the program was this --

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use CGI;
my $cgi = CGI->new();
print $cgi->header( -type => 'image/jpg' );
open my $img, '<', '/home/user/images/author/dave-jacoby.jpg';
while (<$img>) { print }
```

-- you would get this:

![/images/author/dave-jacoby.jpg](/images/author/dave-jacoby.jpg)

## Processing input

The first way to pass data is with the query string, (the portion of a URI beginning with `?`), which you see in URLs like `https://example.com/?foo=bar`. This uses the "GET" request method, and becomes available to the program as `$ENV->{QUERY_STRING}`, which in this case is `foo=bar` (CGI programs receive their arguments as environment variables). But CGI provides the `param` method which parses the query string into key value pairs, so you can work with them like a hash:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;
my %param = map { $_ => scalar $cgi->param($_) } $cgi->param() ;
print $cgi->header( -type => 'text/plain' );
print qq{PARAM:\N};
for my $k ( sort keys %param ) {
    print join ": ", $k, $param{$k};
    print "\n";
}
# PARAM:
# foo: bar
```

So, now, let's make a web page like this:

```html
<!DOCTYPE html>
<html>
<head>
</head>
<body>
    <form method="POST" action="/url/of/simple.cgi">
        <input type="text" name="foo" value="bar">
        <input type="submit">
    </form>
</body>
</html>
```

And click submit. The browser will send an HTTP "POST" request, with the form input as key value pairs in the request body. CGI handles this and places the data in `$cgi->param`, just like with "GET". Only, with "POST" the size of input can be much larger (URL's are generally limited to 2048 bytes by browsers).

## Generating HTML

Let's make that form above, using the HTML-generation techniques that come with CGI.

```perl
my $output;
$output .= $cgi->start_form(
    -method => "post",
    -action => "/path/to/simple.cgi"
);
print $cgi->textfield( -name => 'foo', -value => 'bar' );
print $cgi->submit;
print $cgi->end_form;
```

The problem with this, is the code to generate HTML with CGI can get very long and unreadable. The maintainers of CGI agree, which is why this is at the top of [the documentation for CGI.pm](https://metacpan.org/pod/CGI#HTML-Generation-functions-should-no-longer-be-used):

> All HTML generation functions within CGI.pm are no longer being maintained. [...] The rationale for this is that the HTML generation functions of CGI.pm are an obfuscation at best and a maintenance nightmare at worst. You should be using a template engine for better separation of concerns. See [CGI::Alternatives]({{< mcpan "CGI::Alternatives" >}}) for an example of using CGI.pm with the [Template::Toolkit]({{< mcpan "Template::Toolkit" >}}) module.

Using Template Toolkit, that form might look like:

```perl
#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use Template;

my $cgi      = CGI->new;
my $template = Template->new();
my $input    = join "\n", <DATA>;
my $data     = { action => '/url/of/program'} ;

print $cgi->header;
$template->process(\$input,$data)
    || die "Template process failed", $template->error();

__DATA__
    <form method="POST" action="[% action %]">
        <input type="text" name="foo" value="bar">
        <input type="submit">
    </form>
```

I use Template Toolkit for all my server-side web work. It's also the default in many of Perl's web frameworks.

## Configuring CGI on Apache

To use CGI, your web server should have [mod_cgi](http://httpd.apache.org/docs/current/mod/mod_cgi.html) installed. Once installed, you will have to to configure your server to execute CGI programs.

The first way is to have `cgi-bin` directories where every file gets executed instead of transferred. 

    <Directory "/home/*/www/cgi-bin">
        Options ExecCGI
        SetHandler cgi-script
    </Directory>

The other is to allow CGI to be enabled per directory, with a configuration that looks like this:

    <Directory "/home/*/www">
        Options +ExecCGI
        AddHandler cgi-script .cgi
    </Directory>

And then add a `.htaccess` file in each directory that looks like this:

    AddHandler cgi-script .cgi
    Options +ExecCGI

So that `foo.pl` will transfer but `foo.cgi` will run, even if both are executable.

## Why not to use CGI

[In May 2013, Ricardo Signes, then Perl5 Pumpking, sent this to the Perl5 Porters list](https://www.nntp.perl.org/group/perl.perl5.porters/2013/05/msg202130.html):

> I think it's time to seriously consider removing CGI.pm from the core distribution. It is no longer what I'd point _anyone_ at for writing _any_ sort of web code. It is in the core, as far as I know, because once it was the state of the art, and a major reason for many people to use the language. I don't think either is true now.

It was marked deprecated with 5.20 and removed from Core with 5.22. This is not catastrophic; it is still available in CPAN, so you would have to install it, or have your administrator install it, depending on your circumstances.

So, why did CGI drop from "state of the art" to discouraged by its own maintainers? 

There are two big issues with CGI: speed and complexity. Every HTTP request triggers the forking of a new process on the web server, which is costly for server resources. A more efficient and faster way is to use a multi-process daemon which does its forking on startup and maintains a pool of processes to handle requests.

CGI isn't good at managing the complexity of larger web applications: it has no MVC architecture to help developers separate concerns. This tends to lead to hard-to-maintain programs.

The rise of web frameworks such as Ruby on Rails, and the application servers they run on, have done much to solve both problems. There are many web frameworks written in Perl; among the most popular are [Catalyst]( {{< mcpan "Catalyst::Manual" >}}), [Dancer]({{< mcpan "Dancer2" >}}), and [Mojolicious]({{< mcpan "Mojolicious" >}}).

CGI also contains a security [vulnerability](https://metacpan.org/pod/distribution/CGI/lib/CGI.pod#Fetching-the-value-or-values-of-a-single-named-parameter) which must be coded around to avoid parameter injection.

## References

The "good" parts of CGI.pm, the header creation and parameter parsing, are well-explained in the module's [documentation]({{< mcpan "CGI" >}}). As for the deprecated HTML generation functions, they are documented [separately]({{< mcpan "CGI::HTML::Functions" >}}).

Lincoln Stein, the creator of CGI.pm also wrote the [Official Guide](https://www.amazon.com/Official-Guide-Programming-CGI-pm-Lincoln/dp/0471247448). The book is 20 years old, and out of date but remains a clear and concise resource about CGI.pm.

Lee Johnson, the current maintainer of CGI.pm wrote a long form blog [post](https://leejo.github.io/2016/02/22/all_software_is_legacy/) about the history of CGI, its current state and future.
