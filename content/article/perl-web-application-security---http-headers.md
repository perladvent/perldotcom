{
   "image" : "/images/81/ECAB3C5E-FF2E-11E3-B4AE-5C05A68B9E16.jpeg",
   "date" : "2014-03-31T12:27:39",
   "categories" : "security",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Instantly upgrade your web application security with these headers",
   "slug" : "81/2014/3/31/Perl-web-application-security---HTTP-headers",
   "tags" : [
      "catalyst",
      "dancer",
      "mojolicious",
      "mvc"
   ],
   "thumbnail" : "/images/81/thumb_ECAB3C5E-FF2E-11E3-B4AE-5C05A68B9E16.jpeg",
   "title" : "Perl web application security - HTTP headers",
   "draft" : false
}


*HTTP headers are included in every HTTP response from a web server. Setting the appropriate HTTP headers can reduce the risk of man-in-the-middle and cross-site-scripting attacks on a web application. You can also reduce information leaks about the web application configuration - vital data that gives a would-be attacker clues about potential vulnerabilities. Read on to find out how to set the appropriate headers in your Perl web application.*

### Application

All three of major Perl web frameworks provide some kind of identifying header. Dancer and Mojolicious use "X-Powered-By" and Catalyst uses "X-Catalyst". The problem with this header is it informs the requester the language of the application (Perl) and the web framework being used. In some cases it also reveals the version number. With this information a would-be attacker can focus on exploits that are specific to Perl or the web framework. Here's how you can disable it:

-   By default Catalyst does not turn on its application header. The header is controlled by the "enable\_catalyst\_header" config option, normally located in the root application class (e.g. lib/MyApp.pm) or the application config file.
-   Mojolicious does not set this header since [version 4.00](https://github.com/kraih/mojo/blob/b5da0c7afcdd793c85e8e2a67eb29f7f36bdb601/Changes#L538).
-   Dancer (and Dancer2) use the [server tokens](https://metacpan.org/pod/release/XSAWYERX/Dancer2-0.11/lib/Dancer2/Config.pod#server_tokens-%28boolean%29) directive.

### Server

Web servers often broadcast information about themselves by default. For example:

```perl
Server: nginx/1.4.6
```

This is risky for the same reason that revealing information about the underlying Perl web application is. To disable the server header in nginx, just add this line to your nginx.conf or virtual host file:

```perl
server_tokens off;
```

For Apache 1.3x add these lines to your virtual host file:

```perl
ServerTokens Prod
ServerSignature Off
```

For Apache 2.x, these lines will load the mod\_headers module, and remove the server header:

```perl
LoadModule headers_module /usr/lib/apache/modules/mod_headers.so
Header unset Server
```

All of the major Perl web frameworks ship with web servers that set the server header:

```perl
# Catalyst
Server: HTTP::Server::PSGI

# mojolicious
Server: Mojolicious (Perl)

# Dancer
Server: Perl Dancer 1.3121
```

These headers can be overwritten within the application code. For instance, if we wanted to change the server to appear to be nginx:

```perl
# Catalyst
$c->response->header('Server' => 'nginx');

# Mojolicious
$self->res->headers->header('Server' => 'nginx');

# Dancer / Dancer2
header 'Server' => 'nginx';
```

### X-Frame-Options

This header can prevent your application responses from being loaded within frame or iframe HTML elements (see the [spec](http://tools.ietf.org/html/rfc7034)). This is to prevent clickjacking requests where your application response is displayed on another website, within an invisible iframe, which then hijacks the user's request when they click a link on your website. Here's how to disable it in the respective web frameworks:

```perl
# Catalyst
$c->response->header('X-Frame-Options' => 'DENY');

# Mojolicious
$self->res->headers->header('X-Frame-Options' => 'DENY');

# Dancer / Dancer2
header 'X-Frame-Options' => 'DENY';
```

### Strict-Transport-Security

This header instructs the requester to load all content from the domain via HTTPS and not load any content unless there is a valid ssl certificate. This header can help prevent man-in-middle attacks as it ensures that all HTTP requests and responses are encrypted. The Strict-Transport-Security header has a max-age parameter that defines how long in seconds to enforce the policy for. Here's how to add it to your Perl web application:

```perl
# Catalyst
$c->response->header('Strict-Transport-Security' => 'max-age=3600');

# Mojolicious
$self->res->headers->header('Strict-Transport-Security' => 'max-age=3600');

# Dancer / Dancer2
header 'Strict-Transport-Security' => 'max-age=3600';
```

### Content-Security-Policy

The CSP header sets a whitelist of domains from which content can be safely loaded. This prevents most types of XSS attack, assuming the malicious content is not hosted by a whitelisted domain. For example this line specifies that all content should only be loaded from the responding domain:

```perl
X-Content-Security-Policy: default-src 'self'
```

There is [a lot to CSP](http://www.html5rocks.com/en/tutorials/security/content-security-policy%0A) ([spec](http://www.w3.org/TR/CSP/)) and browser support is [fairly good](http://caniuse.com/#feat=contentsecuritypolicy). One downside to the whitelist approach is it's not compatible with ad services like Google's adsense as you won't know the domains in advance in order to whitelist them. To set the header in your facourite Perl web application, use on of these lines:

```perl
# Catalyst
$c->response->header('X-Content-Security-Policy' => "default-src 'self'");

# Mojolicious
$self->res->headers->header('X-Content-Security-Policy' => "default-src 'self'");

# Dancer / Dancer2
header 'X-Content-Security-Policy' => "default-src 'self'";
```

### X-Content-Type-Options

This is an IE only header that is used to disable mime sniffing. The vulnerability is that IE will auto-execute any script code contained in a file when IE attempts to detect the file type. This is disabled by default in IE anyway, but to enforce it:

```perl
# Catalyst
$c->response->header('X-Content-Type-Options' => 'nosniff');

# Mojolicious
$self->res->headers->header('X-Content-Type-Options' => 'nosniff');

# Dancer / Dancer2
header 'X-Content-Type-Options' => 'nosniff';
```

### X-Download-Options

This is another IE-only header that prevents IE from opening an HTML file directly on download from a website. The security issue here is, if a browser opens the file directly, it can run as if it were part of the site. To add this header, use one of these lines:

```perl
# Catalyst
$c->response->header('X-Download-Options' => 'noopen');

# Mojolicious
$self->res->headers->header('X-Download-Options' => 'noopen');

# Dancer / Dancer2
header 'X-Download-Options' => 'noopen';
```

### X-XSS-Protection

This is the final IE-only header. It was introduced in IE8 as part of the cross-site-scripting (XSS) filter functionality (more [here](http://blogs.msdn.com/b/ieinternals/archive/2011/01/31/controlling-the-internet-explorer-xss-filter-with-the-x-xss-protection-http-header.aspx)). The header can force IE to turn on its XSS filter. Additionally it has an optional setting called "mode" that can force IE to block the entire page if an XSS attempt is detected. Here's how to add it:

```perl
# Catalyst
$c->response->header('X-XSS-Protection' => "1; 'mode=block'");

# Mojolicious
$self->res->headers->header('X-XSS-Protection' => "1; 'mode=block'");

# Dancer / Dancer2
header 'X-XSS-Protection' => "1; 'mode=block'";
```

### Adding headers in the web server

You may prefer to add these headers in the web server configuration, rather than at the application level. For nginx, use the "add\_header" directive - see [here](https://gist.github.com/plentz/6737338) for a good example. For Apache use the "Header set" directive in mod\_headers ([1.3](http://moko.ru/doc/apache/mod/mod_headers.html), [2.x](http://httpd.apache.org/docs/2.0/de/mod/mod_headers.html)).

### Testing the headers

tThere are a number of ways to check which headers your application is returning. Firstly you can use curl (replace perltricks.com with the URL to check):

```perl
curl -I perltricks.com
```

This will return the HTTP headers only:

```perl
HTTP/1.1 200 OK
Server: nginx
Date: Mon, 31 Mar 2014 01:54:59 GMT
Content-Type: text/html; charset=utf-8
Connection: keep-alive
Cache-Control: max-age=3600
X-Frame-Options: DENY
```

You can use [SecurityHeaders.com's](https://securityheaders.com/) excellent checking tool. Or you can inspect the headers yourself by using your browser's developer mode.

### Conclusion

These HTTP headers are easy to add and can make a reduce your application's vulnerability to XSS and man-in-the-middle attacks, particularly for applications that allow users to upload content.

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F81%2F2014%2F3%2F31%2FPerl-web-application-security-HTTP-headers&text=Perl+web+application+security+-+HTTP+headers&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F81%2F2014%2F3%2F31%2FPerl-web-application-security-HTTP-headers&via=perltricks) it!

*Cover photo © [Andy Wright](http://www.flickr.com/photos/rightee/259084010/in/photostream/)*

*Updates: Mojolicious application header corrected. Web frameworks server header added. (31/3/2014)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
