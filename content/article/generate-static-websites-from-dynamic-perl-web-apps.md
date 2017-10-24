{
   "slug" : "102/2014/7/15/Generate-static-websites-from-dynamic-Perl-web-apps",
   "draft" : false,
   "title" : "Generate static websites from dynamic Perl web apps",
   "tags" : [
      "nginx",
      "mvc",
      "static",
      "web",
      "wallflower",
      "psgi",
      "framework"
   ],
   "description" : "App::Wallflower generates static apps from PSGI applications",
   "image" : "/images/102/72C9C7DC-0AF2-11E4-B70D-23925E2B53EB.jpeg",
   "categories" : "web",
   "date" : "2014-07-15T12:26:52",
   "authors" : [
      "david-farrell"
   ]
}


*Static websites aren't suitable for every situation, but they have several advantages over dynamic apps; they're more efficient, more secure and simpler to deploy. That said, developing and maintaining a static site is a pain, there's just too much repetitive boilerplate code. Enter [Wallflower](https://metacpan.org/pod/wallflower), it generates static websites from PSGI compatible Perl web applications. You get the best of both worlds: develop the routes, templates and unit tests in your favourite web framework but deploy it as a static website with Wallflower.*

### Requirements

The CPAN Testers [results](http://matrix.cpantesters.org/?dist=App-Wallflower+1.004) for the latest version (v1.004) of App::Wallflower show it runs on just about any Perl and operating system, including Windows. You can install it from CPAN by going to the command line and typing:

``` prettyprint
$ cpan App::Wallflower
```

### Wallflower in action

Let's create a simple application using [Dancer2](https://metacpan.org/pod/Dancer2):

``` prettyprint
$ dancer2 -a MyApp
```

This will create a skeleton application for us. Now change into the root application directory and create a new directory to hold the static files, we'll call it "static":

``` prettyprint
$ cd MyApp
$ mkdir static
```

That's all we need to generate the static site with wallflower:

``` prettyprint
$ wallflower --a bin/app.pl --d static
```

Wallflower will request the application root page ('/') and spider all links it finds from there, copying the files to the static folder. This includes files referenced in your html and css, such as JavaScript files. If your app has links to all of its pages, this is all you need.

### Test the static site with nginx

Let's deploy the site with nginx locally (you'll need nginx installed for this). First create the virtual host file:

``` prettyprint
server {
    listen 80;
    server_name localhost;
    root /var/www/MyApp/static;
    location / {
        index index.html;
        rewrite ^/$ /index.html break;
    }
}
```

Assuming a unix-like platform, save the virtual host file to "/etc/nginx/sites-available/localhost". Next enter these commands:

``` prettyprint
$ sudo mkdir /var/www/MyApp
$ sudo cp static /var/www/MyApp
$ cd /etc/nginx/sites-enabled
$ sudo ln -s ../sites-available/localhost
```

Now we need to start nginx. On RHEL/Fedora/CentOS you can start nginx with:

``` prettyprint
$ sudo nginx
```

On Ubuntu:

``` prettyprint
sudo service nginx start
```

Now check out the site at http://localhost:

![The default Dancer app - statically deployed](/images/102/dancer2.png)

Looks pretty good to me!

### Wallflower Tips

A few things I've found whilst using Wallflower:

-   Use absolute urls over relative ones. So if you host your font files in your css directory, use: "/css/MyFont.ttf" instead of "MyFont.ttf" in your css files.
-   Think about files you use but aren't directly linked to in your app's HTML pages, the sitemap.xml file for example. Feed urls for these files to Wallflower with the -F option.
-   Watch out for urls in commented code as Wallflower will copy these too!
-   The Wallflower docs recommend using extensions in your urls to ensure the correct content-type is set. I found this wasn't required when I deployed the files with nginx.

### Conclusion

Whether you prefer developing applications with Catalyst, Dancer or Mojolicious, Wallflower is a useful tool that can be incorporated into your development and deployment process. For further examples of Wallflower in action, check out the [tutorial](https://metacpan.org/pod/Wallflower::Tutorial) and advent calendar [entry](http://www.perladvent.org/2012/2012-12-22.html) by Wallflower creator Philippe Bruhat (BooK).

*Cover image [©](http://creativecommons.org/licenses/by/4.0/) [Ruth Hartnup](https://www.flickr.com/photos/ruthanddave/9432335346/in/photolist-9YgULK-6CwkPH-m68vYZ-4P7TsV-4Pc9dL-7UqEXc-8rbEQq-mPFbgf-Hw6fU-2JcQ24-7ZdMJc-5q1xn5-fnvbFu-fpNhu5-bY6j7J-6HC9cQ-7Y666Z-4RGjZ5-c5bJ5A-5Ma2Kx-7UshUJ-buamir-qLy2D-26mzb-nUfKdk-818aoT-4ne9U5-azaNvR-c7Ztsj-sbu9W-4hrgcG-8r8yrv-hdmVrd-a72iqb-4Kebyi-aEpfqd-6cdRLZ-7iqNqm-6XsteA-b8crZZ-ubPgJ-8pBxDZ-6R63RH-6AnSCX-byKj2-8b97G8-d6X7B-dddPtT-6pUqhf-ejhHg3|)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
