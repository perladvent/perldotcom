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

CGI stands for [_Common Gateway Interface_](https://tools.ietf.org/html/rfc3875#section-6.2.1), and was the main way we had automated actions on web servers for years.

CGI is also [CGI.pm](https://metacpan.org/pod/CGI/), the module we used (and for me, still use) to code for the web.

## What is CGI

HTTP stands for HyperText Transfer Protocol, which means the server could be sending almost anything, so there are two things we must do; the status and the content-type. CGI (the interface) makes this very easy.

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

CGI (the module) makes it easier.

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

But that is not the limit, by far. The content-type is a [**Multipurpose Internet Mail Extension (MIME) type**](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types), and it determines how the browser handles the message once it returns. The above example treats the "This is now text" message as text, and displays it as such. If the content-type was "text/html", it would be parsed for HTML like a web page. If it was "application/json", it might be displayed like text, or formatted into a browsable form, depending on your browser or extensions. If it was "application/vnd.ms-excel" or even "text/csv", the browser would likely open in in Excel or another spreadsheet program, or possibly directly into a gene sequencer, like happens to those I generate at work.

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

The first way to pass data is with the query string, which you see in URLs like `https://example.com/?foo=bar`, which could be part of any link. This uses the "GET" request method, and becomes available to the program as `$ENV->{QUERY_STRING}`, which in this case is `foo=bar`. But CGI does better than that.

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
    <form method="POST" action="/path/to/simple.cgi">
        <input type="text" name="foo" value="bar">
        <input type="submit">
    </form>
</body>
</html>
```

And click submit. We are now using the "POST" method, where we receive the content length, which we then use to know how many bytes we are to pull from STDOUT, and then parse.

Or, again, use CGI. The module handles this and places the results in `$cgi->param`, just like with "GET". Only, with "POST" the size of input can be much larger.

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

Or, we could just do a heredoc:

```perl
print <<'END';
    <form method="POST" action="/path/to/simple.cgi">
        <input type="text" name="foo" value="bar">
        <input type="submit">
    </form>
END
```

The HTML you see in the heredoc looks like HTML, and can be pulled out and validated or prettified like HTML, while the code to generate it with CGI can get very long and unreadable.

The maintainers of CGI agree, which is why this is at the top of [the documentation for CGI.pm](https://metacpan.org/pod/CGI#HTML-Generation-functions-should-no-longer-be-used)**.

> All HTML generation functions within CGI.pm are no longer being maintained. [...] The rationale for this is that the HTML generation functions of CGI.pm are an obfuscation at best and a maintenance nightmare at worst. You should be using a template engine for better separation of concerns. See [CGI::Alternatives](https://metacpan.org/pod/CGI::Alternatives) for an example of using CGI.pm with the [Template::Toolkit](https://metacpan.org/pod/Template::Toolkit) module.

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
my $data     = { action => '/path/to/program'} ;

print $cgi->header;
$template->process(\$input,$data)
    || die "Template process failed", $template->error();

__DATA__
    <form method="POST" action="[% action %]">
        <input type="text" name="foo" value="bar">
        <input type="submit">
    </form>
```

I use Template Toolkit for all my server-side web work. TT is also the default in many of Perl's web frameworks. 

## Configuring CGI on Apache

To use CGI, your web server should have [**mod_cgi**](http://httpd.apache.org/docs/current/mod/mod_cgi.html) installed. Once installed, you will have to to configure your server to execute CGI programs.

The first way is to have `cgi-bin` directories where every file gets executed instead of transferred. 

```
    <Directory "/home/*/www/cgi-bin">
        Options ExecCGI
        SetHandler cgi-script
    </Directory>
```

The other is to allow CGI to be enabled per directory, with a configuration that looks like this:

```
<Directory "/home/*/www">
    Options +ExecCGI
    AddHandler cgi-script .cgi
</Directory>
```

And then add a **.htaccess** file in each directory that looks like this:

```
AddHandler cgi-script .cgi
Options +ExecCGI
```

So that `foo.pl` will transfer but `foo.cgi` will run, even if both are executable.

## Why not to use CGI

[In May 2013, Ricardo Signes, then Perl5 Pumpking, sent this to the Perl5 Porters list](https://www.nntp.perl.org/group/perl.perl5.porters/2013/05/msg202130.html):

> I think it's time to seriously consider removing CGI.pm from the core distribution. It is no longer what I'd point _anyone_ at for writing _any_ sort of web code. It is in the core, as far as I know, because once it was the state of the art, and a major reason for many people to use the language. I don't think either is true now.

It was marked deprecated with 5.20 and removed from Core with 5.22. This is not catastrophic; it is still available in CPAN, so you would have to install it, or have your administrator install it, depending on your circumstances.

So, why did CGI drop from "state of the art" to discouraged by it's own maintainers? 

There are two big issues with code: speed and complexity. You want to increase speed, because the longer a user has to wait, more likely that user is to not wait, but to go to another site. You want to decrease complexity, because the more places you have to go to change, for example, the look and feel of your website, the less likely that change will go to everywhere it needs to.

The rise of web frameworks such as Ruby on Rails, and the application servers they run on, have done much to solve both problems. There are a few web frameworks written in Perl; among them are [Catalyst]( https://metacpan.org/pod/Catalyst::Manual), [Dancer](
https://metacpan.org/pod/Dancer2), and [Mojolicious](
https://metacpan.org/pod/Mojolicious). 

## References

The "good" parts of CGI.pm, the header creation and parameter parsing, are well-explained in [the module's documentation](https://metacpan.com/pod/CGI). [Earlier versions of the module's documentation](https://metacpan.org/release/LDS/CGI.pm-3.04) cover more about what you can do with the older, deprecated parts. 
