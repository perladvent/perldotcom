{
   "title" : "Simple web framework FastCGI caching with nginx - part 2",
   "tags" : [
      "module",
      "nginx",
      "dancer",
      "mojolicious",
      "cache"
   ],
   "authors" : [
      "david-farrell"
   ],
   "date" : "2014-03-17T01:54:09",
   "image" : "/images/77/EC900B50-FF2E-11E3-B753-5C05A68B9E16.jpeg",
   "categories" : "web",
   "slug" : "77/2014/3/17/Simple-web-framework-FastCGI-caching-with-nginx---part-2",
   "draft" : false,
   "thumbnail" : "/images/77/thumb_EC900B50-FF2E-11E3-B753-5C05A68B9E16.jpeg",
   "description" : "Safely purge individually cached upstream responses"
}


*In [part 1](http://perltricks.com/article/76/2014/3/11/Simple-web-framework-FastCGI-caching-with-nginx-part-1) of this series, we covered how to cache FastCGI responses with nginx and how to purge the cache on demand. We saw how easy it is to setup caching with the main Perl web frameworks (Catalyst, Dancer and Mojolicious). In this article we'll use Nginx::FastCGI::Cache to manage our cached responses and gain some useful benefits along the way.*

### Requirements

You'll need Perl v5.12.3 or greater to install [Nginx::FastCGI::Cache]({{<mcpan "Nginx::FastCGI::Cache" >}}). The CPAN Testers [results](http://matrix.cpantesters.org/?dist=Nginx-FastCGI-Cache+0.008) show that it runs on most platforms including Windows. To install the module using CPAN, just open the terminal and type:

```perl
$ cpan Nginx::FastCGI::Cache
```

### nginx fastcgi caching explained

In an nginx virtual host file, the "fastcgi\_cache\_path" directive sets the root directory from where nginx will build the cache. nginx uses the variables of the "fastcgi\_cache\_key" directive to create an md5 hexadecimal hash key as the filename. The "levels" value determines the number of subdirectories and the subdirectories name length. For example, with this configuration:

```perl
fastcgi_cache_path  /var/cache/nginx levels=1:2
                    keys_zone=app_cache:50m
                    inactive=60m;
fastcgi_cache_key "$scheme$request_method$host$request_uri";
```

A GET request for "http://perltricks.com/" would have a key of "httpGETperltricks.com/", and be stored at: "/var/cache/nginx/4/85/200d51ef65b0a76de421f8f1ec047854". Note that the name of the first subdirectory is the last letter of the md5 hash ("4") and the second subdirectory name the previous two letters ("85") - this is because of the levels value of "1:2" set in the nginx virtual host file. Deleting the file "/var/cache/nginx/4/85/200d51ef65b0a76de421f8f1ec047854 will purge it from nginx's cache.

### Introducing Nginx::FastCGI::Cache

I wrote [Nginx::FastCGI::Cache]({{<mcpan "Nginx::FastCGI::Cache" >}}) to make it easy to purge individually cached fastcgi responses from the nginx cache. For example:

```perl
use Nginx::FastCGI::Cache;
 
my $nginx_cache = Nginx::FastCGI::Cache->new({ location => '/var/cache/nginx' });
$nginx_cache->purge_file("http://perltricks.com/");
```

This will convert the URL into the md5 hashed cache key, and delete it from the nginx cache directory. By default "purge\_file" assumes the HTTP request type is GET. If you want to purge a file for a different request type, simply include it as a parameter:

```perl
$nginx_cache->purge_file("http://perltricks.com/", "HEAD");
```

If you want to blow away the whole cache, use the "purge\_cache" method:

```perl
$nginx_cache->purge_cache;
```

These two methods should be all that's required to conveniently manage the nginx cache from your favourite Perl web application.

### Portability

In part 1 our purge cache code used a system call to the GNU find program to delete all the files in the cache. Whilst this is fine as a quick hack, using an external program limits the portability of the code (it wouldn't run on Windows for example). Nginx::FastCGI::Cache uses Perl's opendir and unlink functions to read the cache directory and delete files, which should work on all platforms that Perl runs on.

### Safety First

Whenever you have a program that is going to recursively delete all files in a directory, you want to be sure that it's looking at the correct directory. That's why the "location" is a mandatory parameter for the [Nginx::FastCGI::Cache]({{< mcpan "Nginx::FastCGI::Cache" >}}) constructor—no default location is assumed. Additionally, should the Perl process not have sufficient permissions to read the cache directory or delete a cached file, [Nginx::FastCGI::Cache]({{< mcpan "Nginx::FastCGI::Cache" >}}) will [croak]({{< perldoc "Carp" >}}).

### Other nginx considerations

By default, nginx will not cache a fastcgi response that includes a "Set-Cookie" header. Depending on how you are using cookies, you may want to have nginx cache the response and ignore the "Set-Cookie" header. This can be done by adding this line to your virtual host file:

```perl
fastcgi_ignore_headers "Set-Cookie";
```

Bear in mind that the "set-Cookie" header will be removed from the response altogether, so this is useful when serving uniform responses that do not distinguish between users with session cookies and those without.

By default nginx will only cache GET and HEAD requests. This is a good default, but you may want to restrict the cache to just GET responses, or enable other kinds of HTTP requests such as POST. If so, add the fastcgi\_cache\_methods directive to your nginx virtual host file. For example to only cache GET requests:

```perl
fastcgi_cache_methods GET;
```

The nginx [documentation](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html) provides comprehensive detail on the fastcgi module.

### Conclusion

Whether you are using Catalyst, Dancer or Mojolicious, setting the appropriate caching headers is easy (see [part 1](http://perltricks.com/article/76/2014/3/11/Simple-web-framework-FastCGI-caching-with-nginx-part-1)). Consider using [Nginx::FastCGI::Cache]({{<mcpan "Nginx::FastCGI::Cache" >}}) with nginx to conveniently purge the cache on demand.

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F77%2F2014%2F3%2F16%2FSimple-web-framework-FastCGI-caching-with-nginx-part-2&text=Simple+web+framework+FastCGI+caching+with+nginx+-+part+2&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F77%2F2014%2F3%2F16%2FSimple-web-framework-FastCGI-caching-with-nginx-part-2&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
