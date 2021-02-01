{
   "authors" : [
      "david-farrell"
   ],
   "description" : "",
   "image" : "/images/promoting-perl-community-articles/newspaper.png",
   "categories" : "community",
   "date" : "2016-05-26T08:53:36",
   "draft" : false,
   "tags" : [
      "ruby",
      "perl",
      "perly_bot",
      "reddit",
      "twitter",
      "stackoverflow",
      "perlmonks"
   ],
   "thumbnail" : "/images/promoting-perl-community-articles/thumb_newspaper.png",
   "title" : "Promoting Perl community articles"
}

The last part of Justin Searls' [talk](https://vimeo.com/165527044#t=28m10s) has some great advice for promoting Ruby that applies to Perl too. If you haven't seen it, I'd encourage you to watch it. Justin points out that some tech projects like Ruby on Rails are essentially, done. They're feature complete and achieve everything they set out to accomplish. This means that they're no longer cutting edge tech, and consequently fewer articles are written about them.

We see this with Perl too. Modules like [Moose]({{<mcpan "Moose" >}}) and [Mojolicious]({{<mcpan "Mojolicious" >}}) are battle-tested, proven libraries that do a wonderful job. So we don't see many hype articles about them either. The solution to this is to focus on evergreen story telling:

> Tell stories that help people solve problems. And if you love Ruby, tell your story in Ruby.
>
> Justin Searls

As Perl programmers we're using the language to solve problems every day. And we'll never run out of problems to solve: there are always new systems to integrate, new data challenges, algorithms to implement and bugs to fix. That's why it doesn't matter that so much has already been written about Perl - new experiences will always be around the corner. And new is good.

So let's tell more stories in Perl.

### Promoting content
Many Perl programmers are regularly writing about Perl, so another thing we can always improve on is promoting new Perl content. This isn't an exhaustive list, just a few suggestions on how to help.

Last week I added the "Community Articles" toolbar to this website. It's a JavaScript widget that's powered by [Perly::Bot](https://github.com/dnmfarrell/Perly-Bot). You can add this widget to your website with the following code:

    <script src="https://perltricks.com/widgets/toplinks/toplinks.js" type="text/javascript"></script>
    <div id="toplinks"></div>

The list of links is updated hourly, served over HTTPS and hosted on GitHub pages. The widget is clever enough to skip links to articles from the host domain too (it never shows links to PerlTricks.com on this site).

If you'd rather not add that sidebar, consider adding a widget for `/r/perl` (*Editor's note: this is no longer a Reddit feature*). The Reddit widget respects Do Not Track.

Finally, participate on [/r/perl](https://reddit.com/r/perl) and Twitter! Link to Perl resources and content you like; upvote or retweet Perl-related tweets. If you have something to say, reply to tweets or add yours comments to the subreddit links. Use the `#perl` hashtag.

### Stuff we're already good at
[StackOverflow.com](https://stackoverflow.com/questions/tagged/perl) has excellent Perl answers that are regularly updated; this is a great resource for Perl programmers. [PerlWeekly](http://perlweekly.com) is a fantastic newsletter that links to the best Perl content of the week, subscribe if you haven't already. [PerlMonks](http://perlmonks.org) has tonnes of in-depth Perl guides and resources.

<br/>*Cover image by [jaguarpaw](http://newspaper.jaguarpaw.co.uk/)*<br/>

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
