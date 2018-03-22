{
   "tags" : [
      "real-world-perl",
      "chrome",
      "heap"
   ],
   "categories" : "community",
   "title" : "Real World Perl: Analyze Chrome's heap",
   "thumbnail" : "/images/real-world-perl/thumb_earth.jpg",
   "description" : "Using Perl to analyze (and optimize) Chrome's heap",
   "draft" : false,
   "image" : "/images/real-world-perl/earth.jpg",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2018-02-19T18:37:45"
}

Welcome to Real World Perl, a series that aims to showcase everyday uses of Perl. Got a suggestion for a Real World Perl example? [email me](mailto:perl-com-editor@perl.org).

When ordinary tools fail, many programmers reach for Perl. Matthew Hodgson ran into trouble analyzing the Chrome Browser's heap dump file: the programs he used kept running out of memory for large (> 2GB) files. So he whipped up a "quick and dirty" Perl [script](https://github.com/ara4n/heapanalyser/blob/master/heap-analyser.pl) to do it. Instead of parsing the entire heap dump into memory, it saves resources by processing the data one line at a time.

To use the script, you first need a Chrome heap dump file. To get one, launch Chrome, go to Developer tools -> Memory -> Take heap snapshot. Save the file locally.

    $ ./heap-analyser.pl /path/to.heapsnapshot > heap-stats.csv

This will save the statistics in a tab separated format in the file `heap-stats.csv`. From there you can import the file into your favorite spreadsheet software, for further investigation. Matthew has an example of this in the project [repo](https://github.com/ara4n/heapanalyser).

\
Cover image from [pixabay](https://pixabay.com/en/planet-earth-cosmos-continents-1457453/)
