{
   "draft" : false,
   "categories" : "community",
   "date" : "2015-08-29T09:46:29",
   "title" : "How to choose a DuckDuckGo cheatsheet topic",
   "tags" : [
      "seo",
      "goodie",
      "duckduckhack",
      "old_site"
   ],
   "image" : "/images/191/5E030C7A-E6E1-11E4-9A7F-886D1846911D.jpeg",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Some sources of inspiration",
   "slug" : "191/2015/8/29/How-to-choose-a-DuckDuckGo-cheatsheet-topic"
}


If you want to develop a [DuckDuckGo cheatsheet](http://perltricks.com/article/189/2015/8/22/Writing-DuckDuckGo-plugins-just-got-easier) and you've got the technicals down, the next task is to choose a cheatsheet topic. As with [naming things](http://martinfowler.com/bliki/TwoHardThings.html), this can be harder than it sounds.

Certain topics are better suited to be cheatsheets than others; because the cheatsheet is a static file, it's better to provide information which is unlikely to change, such as a [list of the members of the Wu-Tang Clan](https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/share/goodie/cheat_sheets/json/wu-tang.json). With that in mind, here are some good sources of inspiration for your cheatsheet.

### Scan the cheatsheet corpus

Get inspiration from association. The DuckDuckGo goodie repo maintains all of the static [cheatsheets](https://github.com/duckduckgo/zeroclickinfo-goodies/tree/master/share/goodie/cheat_sheets/json). Have a look at them, maybe you'll get an idea for something similar to what's already been done. I made the GNU Screen cheatsheet after I saw the tmux one - there was a lot of copy and paste involved!

### Check the instant answer request list

One way to get cheatsheet ideas is to think about technical and trivia subjects you're interested in. That's "supply". Another way is to look at "demand" - i.e. what people have asked for. Helpfully, the DuckDuckGo community maintains an extensive [list](https://duck.co/ideas) of instant answer ideas. Have a browse!

### Mine Google AdWords

Another way to view demand is to check search traffic. This is an old SEO trick to find common associations with a keyword using the [Google AdWords](https://adwords.google.com) keywords planner tool. For example I used the tool to find the top 50 searches associated with the term "cheatsheet":

| Keyword                           | Avg. Monthly Searches (exact match only) |
|-----------------------------------|------------------------------------------|
| markdown cheatsheet               | 1900                                     |
| vim cheatsheet                    | 1600                                     |
| git cheatsheet                    | 1600                                     |
| regex cheatsheet                  | 1300                                     |
| vi cheatsheet                     | 1000                                     |
| jquery cheatsheet                 | 480                                      |
| fantasy football cheatsheet       | 390                                      |
| cheatsheets                       | 390                                      |
| html cheatsheet                   | 390                                      |
| subnet cheatsheet                 | 390                                      |
| python cheatsheet                 | 390                                      |
| fantasy football cheatsheets      | 320                                      |
| xss cheatsheet                    | 320                                      |
| sql cheatsheet                    | 320                                      |
| gdb cheatsheet                    | 320                                      |
| emacs cheatsheet                  | 260                                      |
| latex cheatsheet                  | 260                                      |
| linux cheatsheet                  | 210                                      |
| screen cheatsheet                 | 210                                      |
| r cheatsheet                      | 210                                      |
| svn cheatsheet                    | 170                                      |
| php cheatsheet                    | 170                                      |
| html5 cheatsheet                  | 170                                      |
| sql injection cheatsheet          | 170                                      |
| ruby cheatsheet                   | 170                                      |
| regular expression cheatsheet     | 140                                      |
| bash cheatsheet                   | 140                                      |
| uml cheatsheet                    | 140                                      |
| css3 cheatsheet                   | 110                                      |
| xpath cheatsheet                  | 90                                       |
| perl cheatsheet                   | 70                                       |
| unix cheatsheet                   | 70                                       |
| django cheatsheet                 | 70                                       |
| subnet mask cheatsheet            | 70                                       |
| c\# cheatsheet                    | 70                                       |
| powershell cheatsheet             | 70                                       |
| asciidoc cheatsheet               | 70                                       |
| fantasy cheatsheet                | 50                                       |
| rails cheatsheet                  | 50                                       |
| mediawiki cheatsheet              | 40                                       |
| regular expressions cheatsheet    | 40                                       |
| zfs cheatsheet                    | 40                                       |
| free fantasy football cheatsheets | 30                                       |
| dailybeast cheatsheet             | 30                                       |
| dmv cheatsheet                    | 30                                       |
| fantasy football draft cheatsheet | 30                                       |
| fantasy baseball cheatsheet       | 30                                       |
| photobert cheatsheet              | 30                                       |
| cheatsheet html                   | 30                                       |
| autosys cheatsheet                | 30                                       |

If nothing in this list appeals, try searching against similar terms like "cheat sheet", "help", "FAQ" and "usage" to find something that inspires you.

### Conclusion

Developing cheatsheets should be fun. If you're wrestling with a potential cheatsheet topic remember that there is a large developer community waiting to help you. The [DuckDuckHack site](http://duckduckhack.com/) is a good source of information. It has a [FAQ](https://duck.co/duckduckhack/faq#goodie), a [guide](https://duck.co/duckduckhack/determine_your_instant_answer_type) to picking the right plugin type for your idea and information on how to join the DuckDuckGo Slack site. Useful information can also be found in the [quack and hack cheatsheet](https://duckduckgo.com/?q=quack+hack+help&ia=cheatsheet)!

Once you've drafted your cheatsheet, consider using my [cheatsheet checker tool](http://perltricks.com/article/190/2015/8/28/Check-your-DuckDuckGo-cheatsheets-with-Perl). It finds common syntax and data errors which can make developing a cheatsheet easier.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
