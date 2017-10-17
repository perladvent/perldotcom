{
   "title" : "Making the Larry Wall shirt",
   "description" : "How to create your own pop art images",
   "draft" : false,
   "date" : "2015-12-03T12:52:01",
   "slug" : "201/2015/12/3/Making-the-Larry-Wall-shirt",
   "tags" : [
      "gimp",
      "inkscape",
      "stencil",
      "old_site"
   ],
   "categories" : "community",
   "image" : "/images/201/A73A0F48-995A-11E5-A40D-AF14E7E91CBA.png",
   "authors" : [
      "david-farrell"
   ]
}


A few months ago [brian d foy](http://www.learning-perl.com/)and I were throwing around some t-shirt ideas and we came up with a concept for series of shirts highlighting our computer heroes. This culminated in us recently launching our first [Kickstarter project](https://www.kickstarter.com/projects/1422827986/heroes-of-the-revolution-t-shirts-larry-wall) for the Larry Wall shirt (shown above). If you like the design [back it](https://www.kickstarter.com/projects/1422827986/heroes-of-the-revolution-t-shirts-larry-wall)! - we'd love to produce more designs for other famous programmers like Ritchie, Norvig et al. This article is about how to create similar pop art style images using [GIMP](http://www.gimp.org/) and [Inkscape](https://inkscape.org/en/).

### Selecting & preparing an image

First find an image you want to convert and open it in GIMP. I'm going to use my profile photo:

![](/images/201/0BwRnByTz2iUXNWNOWmlnb1lxT1E)

To prepare the image for stenciling, I need to reduce the image contrast. The first thing I do is remove the background. I use a variety of techniques for this: if it is a single color, I use the color selection tool and delete it; else a combination of the lasso select with delete and the eraser usually do the trick:

![](/images/201/0BwRnByTz2iUXSEN5ZHBTOFRvcHM)

I use the same techniques to remove my body:

![](/images/201/0BwRnByTz2iUXd3FCS0tsZ2hRSVE)

Next I convert the image to black and white (go to Image-\>mode-\>grayscale) and crop it (Image-\>Autocrop Image).

### Creating the stencil

With the image adequately prepped, I can use GIMP's color threshold tool to convert it to a rough stencil (Colors-\>Threshold). I adjust the default threshold until I get an appearance I like:

![](/images/201/0BwRnByTz2iUXTE9aR0F6RGNSVkk)

I export this image from GIMP as a PNG file and open it with Inkscape. Within Inkscape I left-click the image so that it is selected and then trace the bitmap (Path-\>Trace Bitmap). This creates a new, smoother version of the image. Then I delete the original image from Inkscape. At this point the image is good but it's too small for general use, so when I export it as a PNG (File-\>Export PNG Image) I adjust the image dimensions to the size required. This works because an SVG will scale to any dimension (click [here](/images/201/0BwRnByTz2iUXQnJvajhCY3VWMmM) for a larger version).

![](/images/201/0BwRnByTz2iUXc1l5NXlldGV4OE0)

At this stage I could put this image on any color of t-shirt. Instead I'll re-import the image into GIMP and add a funky background color:

![](/images/201/0BwRnByTz2iUXeUs0WGpVdDQ1Q0E)

Don't forget to back the [Kickstarter](https://www.kickstarter.com/projects/1422827986/heroes-of-the-revolution-t-shirts-larry-wall) project if you want a t-shirt. Best of all, it's Larry Wall approved ™

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
