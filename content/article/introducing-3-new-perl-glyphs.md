{
   "tags" : [
      "icomoon",
      "fontforge",
      "svg",
      "glyph",
      "bootstrap",
      "icon",
      "font"
   ],
   "title" : "Introducing 3 new Perl Glyphs",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-01-23T13:55:03",
   "slug" : "146/2015/1/23/Introducing-3-new-Perl-Glyphs",
   "draft" : false,
   "image" : "/images/146/62C9158A-A2B0-11E4-8BBD-CE8C9EE10EC8.png",
   "categories" : "community",
   "thumbnail" : "/images/146/thumb_62C9158A-A2B0-11E4-8BBD-CE8C9EE10EC8.png",
   "description" : "What will you use them for?"
}


Recently I changed our site's menu links from bitmap images to glyphs. A glyph (or "font icon") is an svg file which can be packaged in a font file. Glyphs hold several advantages over bitmaps as icons: they look smooth at any resolution, can be colored and aligned just like text, and usually occupy less disk space than a regular bitmap.

PerlTricks.com uses bootstrap, which comes with [many](http://getbootstrap.com/components/) stock glyphs, but alas! no Perl ones. Seeing as Perl culture has some pretty powerful iconography, it seemed high time the community had some ready-made glyphs to use. So over the holidays, I learned how to make svgs, and have created 3 new Perl glyphs to share.

First a couple of Perl 5 classics, colored:

image/svg+xml

image/svg+xml

And a black-and-white Camelia for Perl 6:

image/svg+xml

Of course, being svg you can color them however you like.

### Creating font icon sets

These svg files are nice, but they're easier to use in a font file. I like to use IcoMoon.io's app for compiling font files. It's free, simple and fast. To create your own font Perl icon set, first download the svg [files](https://github.com/dnmfarrell/Perl-Icons/tree/master/Icons) or clone the [repo](https://github.com/dnmfarrell/Perl-Icons). Now point your browser at the IcoMoon.io app [page](http://icomoon.io/app). Click the "import" button, and select the Perl svg files you downloaded.

![icomoon\_app](https://farm8.staticflickr.com/7543/16158980357_1b37c2a633.jpg)

You should see the icons appear as an "untitled set". Click each icon so that it is selected for inclusion in the font file.

![icomoon\_import](https://farm8.staticflickr.com/7567/15724931783_ff9a3cbf19.jpg)

Click the "Generate Font" button in the bottom-right corner of the screen. This will load the download font window. The window should show the 3 Perl glyph, and a unicode identifier for each glyph (like "e600" etc). Remember these unicode ids as you'll need them to use the font icons.

![icomoon\_download](https://farm9.staticflickr.com/8660/16318921836_8ce352635b.jpg)

Finally, click the "download" button to download the fonts archive. Inside the archive you'll find the font files in eot, ttf, woff and svg formats, along with examples of how to use them. The easiest way to test the icons is by opening `demo.html` that comes with the IcoMoon fonts archive. Test out the glyphs by typing into the "Font Test Drive" editor. To type a glyph in HTML just type: `` replacing "e600" with the unicode id of the glyph, for example:

![icomoon\_demo\_html](https://farm8.staticflickr.com/7494/16161405249_fc513e7389.jpg)

When you go to use the fonts on the web, make sure you use the bulletproof @font-face [syntax](http://www.paulirish.com/2009/bulletproof-font-face-implementation-syntax/). Another benefit of using IcoMoon.io's app: the `style.css` file in the archive includes the bulletproof syntax.

If you want lower-level access to font files, check out [FontForge](http://sourceforge.net/projects/fontforge/). Using FontForge you can create or edit font files in a variety of formats. You can set the font metadata (creator, name etc), and specify the alignment of individual glyphs more precisely than with IcoMoon.io's free app.

### Licensing

I've released these files under the FreeBSD license, but keep in mind that there may be additional restrictions on use, which is out of my hands. Check out the repo [README](https://github.com/dnmfarrell/Perl-Icons/blob/master/README.pod) for the specifics.

**Update** *I've added a fourth glyph to the repo, the Perl 5 Raptor! Thanks to Marcus Smith for the suggestion. 2015-01-23*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
