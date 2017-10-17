{
   "authors" : [
      "david-farrell"
   ],
   "image" : "/images/94/ED0BC132-FF2E-11E3-B6DA-5C05A68B9E16.png",
   "description" : "App::revealup converts markdown to slick HTML slide shows",
   "date" : "2014-06-06T12:59:56",
   "slug" : "94/2014/6/6/Create-professional-slideshows-in-seconds-with-App--revealup",
   "title" : "Create professional slideshows in seconds with App::revealup",
   "categories" : "apps",
   "tags" : [
      "app",
      "javascript",
      "github",
      "reveal_js",
      "old_site"
   ],
   "draft" : false
}


*[App::revealup](https://metacpan.org/pod/App::revealup) is a command line app that creates slide shows from markdown documents. We listed it in this this month's "What's new on CPAN", but the app is so much fun I thought it was worth a separate feature.*

### Requirements

You'll need to grab App::revealup from CPAN. The latest version (0.03) should run on most platforms including Windows. At the command line type:

``` prettyprint
$ cpan App::revealup
```

### Create a presentation

App::revealup transforms markdown documents into slide shows, so let's start by creating a basic presentation file, called presentation.md:

``` prettyprint
A quick guide to markdown  as served by `App::revealup`  
David Farrell  
[PerlTricks.com](http://perltricks.com)
June 2014
```

As you can see, markdown is easy to read. The code above is a single slide presentation. The only two interesting things going on here is the use of backticks ("\`App::revealup\`") to create inline code and the hyperlink "[PerlTricks.com](http://perltricks.com)".

To view this slide in presentation mode, at the command line type:

``` prettyprint
$ revealup server presentation.md --port 5000
```

Now open your browser and navigate to http://localhost:5000. You should see something like this:

![](/images/94/slide1.png)

Let's add a second slide to showcase how different headers appear. In App::revealup the horizontal slide separator is three hyphens in a row ("---").

``` prettyprint
A quick guide to markdown  as served by `App::revealup`  
David Farrell  
[PerlTricks.com](http://perltricks.com)
June 2014  

---
# This is H1
## This is H2
### This is H3
#### This is H4
```

App::reveal dynamically reads the source presentation file, so you can leave the process running and just save the changes to the source presentation file. Reloading the browser at http://localhost:5000 should show the updated presentation. Press → to move to the second slide.

![](/images/94/slide2.png)

You can add vertical slides too. These are delimited by three underscores ("\_\_\_"):

``` prettyprint
A quick guide to markdown  as served by `App::revealup`  
David Farrell  
[PerlTricks.com](http://perltricks.com)
June 2014  

---
# This is H1
## This is H2
### This is H3
#### This is H4

---

+ Unordered
- lists are
* made with plus, minus or asterisk
___

1. Ordered
2. lists are
3. made with numbers and a period
```

Refreshing the browser, we get two additional slides. Press ↓ to move down one slide:

![](/images/94/slide3.png)

![](/images/94/slide4.png)

Instead of trawling through every slide, I've completed the rest of the presentation and put it on [GitHub](https://gist.github.com/dnmfarrell/1b118c5813a7a10ea7e2). The presentation content is an overview of the markdown syntax. Try running it with App::revealup!

One nice feature is if you ever want to zoom out, just press the escape key:

![](/images/94/slide_zoom.png)

### How App::revealup works

App::revealup is the glue between the [reveal.js](http://lab.hakim.se/reveal-js/#/) library and the source markdown file. It launches a PSGI web server, and compiles a basic HTML document which loads reveal.js and any required libraries or css. You can override the default css theme by passing an extra command line option:

``` prettyprint
$ revealup server presentation.md --port 5000 --theme solarized.css
```

App::revealup installs all of the basic reveal.js [themes](https://github.com/hakimel/reveal.js/tree/master/css/theme) or you can provide your own:

``` prettyprint
$ revealup server presentation.md --port 5000 --theme "/path/to/custom.css"
```

### Conclusion

App::revealup is great example of Perl as a glue language - pulling together useful libraries to create something greater than the sum of its parts. If you'd like to learn more about the markdown syntax, check out this [cheetsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet).

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F94%2F2014%2F6%2F6%2FCreate-professional-slideshows-in-seconds-with-App-revealup&text=Create+professional+slideshows+in+seconds+with+App%3A%3Arevealup&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F94%2F2014%2F6%2F6%2FCreate-professional-slideshows-in-seconds-with-App-revealup&via=perltricks) about it!

*Update: command changed to match v0.10 (see [changelog](https://metacpan.org/changes/distribution/App-revealup)) 2014-08-24.*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
