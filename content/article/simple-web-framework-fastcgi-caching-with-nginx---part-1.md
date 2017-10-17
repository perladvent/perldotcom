{
   "description" : "How to cache responses from fastcgi apps and how to clear the cache",
   "draft" : false,
   "tags" : [
      "nginx",
      "catalyst",
      "dancer",
      "mojolicious",
      "cache",
      "old_site"
   ],
   "image" : "/images/76/EC83FACC-FF2E-11E3-BBAC-5C05A68B9E16.jpeg",
   "date" : "2014-03-11T03:18:00",
   "categories" : "web",
   "authors" : [
      "david-farrell"
   ],
   "title" : "Simple web framework FastCGI caching with nginx - part 1",
   "slug" : "76/2014/3/11/Simple-web-framework-FastCGI-caching-with-nginx---part-1"
}


*Fastcgi server caching is a wonderful technique for improving response times and reducing load on a web application. In part 1 of this series we look at how to cache responses with Catalyst, Dancer and Mojolocious and how to clear the cache on-demand when using the nginx web server. Before you know it, your web application will be faster than a racing llama!*

### FastCGI server caching explained

FastCGI server caching is when the FastCGI application sets a caching header in its response to an upstream server. The [max-age header](http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.9.3) defines in seconds from the time of the request how long to cache the response message for. If it's correctly configured, the upstream server will cache the response, and for the duration of the max-age value, return the cached response to all requests to the same URL. As a bonus the max-age header can be passed back to the requester, and it will be cached in their browser as well.

FastCGI server caching brings the following benefits:

-   Cut response times by as much as 95%.
-   Reduce load on the the FastCGI application (imagine 1 request per hour per URL).
-   Reduce load on the the web server with browser caching.
-   Avoid corrupt memory risks of simultaneous read/write when caching responses in the FastCGI application.

### How to cache your Catalyst / Mojolicious / Dancer response

All of the major Perl frameworks support server caching and the good news is it's easy to implement. For example, if $seconds is number of seconds to cache the response for, in Catalyst add this line to a controller method.

``` prettyprint
$c->response->header('Cache-Control' => "max-age=$seconds");
```

In Mojolicious, add this code to your controller action:

``` prettyprint
$self->res->headers->cache_control('max-age=$seconds');
```

And for Dancer, update a route with:

``` prettyprint
header 'max-age' => '$seconds';
```

### How to setup nginx FastCGI caching

To enable nginx caching, add the fastcgi cache directives to to your virtual host config file. For example:

``` prettyprint
fastcgi_cache_path  /var/nginx/cache levels=1:2
                    keys_zone=fcgi_cache:50m
                    inactive=60m;
fastcgi_cache_key "$scheme$request_method$host$request_uri";
fastcgi_buffers 256 4k; 
```

This code specifies the cache directory, zone name, cache key and buffers (see the [manual](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html) for details). The code should be outside your server declaration. Within your server declaration, add:

``` prettyprint
fastcgi_cache fcgi_cache;
fastcgi_cache_valid 200 1s;
```

This code defines the cache zone to use ("fcgi\_cache"), sets the cache size to 200mb and by default caches a response for 1 second. The max-age header will override the default cache time, but you may want to choose a value other than 1 second, depending on your application's needs. Here is a complete example virtual host file with fastcgi caching:

``` prettyprint
fastcgi_cache_path  /var/nginx/cache levels=1:2
                    keys_zone=PerlTricks:50m
                    inactive=60m;
fastcgi_cache_key "$scheme$request_method$host$request_uri";
fastcgi_buffers 256 4k;

server {
    listen 80 default;
    server_name perltricks.com;
    try_files $uri @fcgi;
    location @fcgi {
        fastcgi_cache PerlTricks;
        fastcgi_cache_valid 200 5m;
        fastcgi_pass unix:/tmp/perltricks.socket;
        include /etc/nginx/fastcgi.conf;
        fastcgi_param SCRIPT_NAME /;
    }   
}
```

For an in-depth look at the configuring the nginx fastcgi cache, check out this [useful article](https://www.digitalocean.com/community/articles/how-to-setup-fastcgi-caching-with-nginx-on-your-vps).

### Clearing the cache

Whilst caching responses can deliver huge benefits, it would be nice to be able to clear the cache on-demand, in case the application state changes. Fortunately with nginx this is super-easy with Perl - all you have to do is delete all files in the fastcgi\_cache\_path declared in the virtual host config file. For example, on Unix-based systems this works:

``` prettyprint
sub clear_cache {
    if (-e '/var/nginx/cache') {
        system('find /var/nginx/cache -type f -exec rm -f {} \;');
    }
}
```

### Conclusion

All of the major Perl web frameworks support FastCGI server caching. It's easy to set up and with nginx, easy to manage. However there is more that can be done: in part 2 of this series we'll make our cache management more precise by adding the ability to clear specific URL responses from the cache, rather than obliterating the whole cache in one go. We'll also look at how to make the "clear\_cache" subroutine safer and Windows compatible.

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F76%2F2014%2F3%2F11%2FSimple-web-framework-FastCGI-caching-with-nginx-part-1&text=Simple+web+framework+FastCGI+caching+with+nginx+-+part+1&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F76%2F2014%2F3%2F11%2FSimple-web-framework-FastCGI-caching-with-nginx-part-1&via=perltricks) it!

*Cover picture © David Hoshor licensed via [Creative Commons](http://creativecommons.org/licenses/by/2.0/). The picture has been digitally enhanced.*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
