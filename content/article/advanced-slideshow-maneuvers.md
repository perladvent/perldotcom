{
   "authors" : [
      "david-farrell"
   ],
   "date" : "2014-11-13T13:38:30",
   "description" : "Get the most out of your markdown-driven presentations",
   "image" : "/images/134/4DCE5ABA-6826-11E4-80A8-F16A95E830D2.png",
   "thumbnail" : "/images/134/thumb_4DCE5ABA-6826-11E4-80A8-F16A95E830D2.png",
   "slug" : "134/2014/11/13/Advanced-slideshow-maneuvers",
   "draft" : false,
   "tags" : [
      "revealjs",
      "app_revealup",
      "speaker_notes",
      "markdown"
   ],
   "categories" : "apps",
   "title" : "Advanced slideshow maneuvers"
}


Back in June I wrote an [overview](http://perltricks.com/article/94/2014/6/6/Create-professional-slideshows-in-seconds-with-App--revealup) of [App::revealup](https://metacpan.org/pod/App::revealup), a Perl app that enables markdown-driven presentations with [reveal.js](https://github.com/hakimel/reveal.js). Today I want to share some of the advanced features that I've found useful, but are not always intuitive to include when working with reveal.js and markdown.

### Speaker notes

The speaker notes screen is one of the "killer features" of reveal.js. It's a separate browser window that displays your current slide, the next slide, the speaker notes and the time elapsed so far ([example](https://camo.githubusercontent.com/69f044f8126bdd09cf4caafa2d9239839612a8de/68747470733a2f2f662e636c6f75642e6769746875622e636f6d2f6173736574732f3632393432392f313738393338352f62316565323431652d363935362d313165332d383166652d6535363630643531323130612e706e67)). You can even control the slide transition from the speaker notes screen, enabling you to share the presentation on a large screen whilst driving the presentation from the speaker notes screen on your laptop. To add speaker notes to a slide in presentation, use the `Note:` syntax:

```perl
# This is my title #

Note:
This is the title slide for the presentation.
```

Now, if I launch this presentation I can view the speaker notes by pressing the `s` key.

### Slide transitions

The default slide transition is cute, but it can get a bit tiresome after a while. The good news is reveal.js gives you fine-grained control of slide transitions, the bad news is that the syntax is ugly as hell. You have to include the slide transition commands as HTML comments within your markdown:

```perl
<!-- .slide: data-transition="none" -->
# This is my title #

Note:
This is the title slide for the presentation.
```

The first line of this markdown instructs reveal.js to use "none" as the slide transition style (you can choose from default/cube/page/concave/zoom/linear/fade). The rest of the markdown is the same as before. Although it's nice to have this control at the slide level, one downside is that you must include the slide-transition instruction on every slide where you don't want the default transition.

Another option is to use App::revealup's `transition` command line option:

```perl
$ revealup server slides.md --port 5000 --transition zoom
```

This will apply the transition style to the entire presentation. What's nice about this option is that you can override the transition style using the inline notation described above. So choose your base transition style on the command line option, and tailor it for specific slides with the inline syntax.

### Fragments

Fragments are slide elements that you can introduce sequentially on to a slide. I use them all the time to keep the audience's focus on the item I'm currently talking about. This slide displays a rather uncontroversial opinion:

```perl
I <!-- .element: class="fragment" data-fragment-index="1" --> 

 ❤ <!-- .element: class="fragment" data-fragment-index="2" --> 

Perl<!-- .element: class="fragment" data-fragment-index="3" --> 
```

Like slide transitions, fragments are driven by HTML comments. In this case, when the slide first loads it will be blank, clicking three times will gradually display "I ❤ Perl".

### Background

Fade your presentation to black and get your audience's undivided attention by pressing the `b` key. Press `b` again to bring your presentation back. Simple!

### Styling

Like slide transitions, I found the default reveal.js theme to be a novelty that quickly wears off. The good news is you can define your own CSS to get a style that works for you. Don't start with a blank slate! App::revealup ships with all the [standard themes](https://metacpan.org/source/YUSUKEBE/App-revealup-0.14/share/revealjs/css/theme) so grab one of those and edit it to meet your needs. Test out your new theme by loading it at the command line:

```perl
$ revealup server presentation.md --port 5000 --theme /path/to/theme.css
```

You can also use custom CSS to develop a "house-style" for your organisation. This can help encourage adoption away from those awful stock PowerPoint templates.

### Save as PDF

Presentations can be saved as PDF but you must be using Google Chrome for this to work. There are step-by-step [instructions](https://github.com/hakimel/reveal.js#pdf-export), but one thing that wasn't clear to me was that if you're running the presentation on `http://localhost:5000` you should append "?print-pdf" to the URL so it becomes `http://localhost:5000?print-pdf`. Then reveal.js will load the presentation ready for saving to PDF.

### Wrap-up

Hopefully these tips are useful. Combined with the previous [article](http://perltricks.com/article/94/2014/6/6/Create-professional-slideshows-in-seconds-with-App--revealup), you should have everything you need to craft an awesome markdown-driven presentation. Try [App::revealup](https://metacpan.org/pod/App::revealup) out at your local Perl Mongers!

**Updated: *added slide transition command line option 2014-12-19***

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
