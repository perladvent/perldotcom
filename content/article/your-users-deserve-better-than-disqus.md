{
   "categories" : "community",
   "date" : "2014-07-29T11:46:55",
   "image" : "/images/104/49B63AE6-16BF-11E4-B121-52952D77B041.png",
   "slug" : "104/2014/7/29/Your-users-deserve-better-than-Disqus",
   "description" : "Why Disqus is not the commenting system you're looking for",
   "authors" : [
      "david-farrell"
   ],
   "thumbnail" : "/images/104/thumb_49B63AE6-16BF-11E4-B121-52952D77B041.png",
   "title" : "Your users deserve better than Disqus",
   "tags" : [
      "security",
      "disqus",
      "comments",
      "privacy"
   ],
   "draft" : false
}


*Occasionally readers of this site will contact us to lament our lack of a commenting system. The message usually goes like this: "I love the site but I wish you had a comments section". Some readers even recommend a solution: "you should get Disqus" they say. We are considering adding a comments system to PerlTricks.com, but it probably won't be Disqus. This article explains why.*

### What is Disqus?

Disqus is a third-party commenting system; you add some JavaScript code to your page and when a visitor's browser loads the page, it runs the code which fetches the Disqus interface, and any existing comments from Disqus' servers. This makes Disqus easy to install and as such, Disqus is a popular commenting system ("used by over 3 million websites").

Disqus solves a lot of problems for the site owner: it has a good spam filter, provides notifications, authentication, a management interface and it looks good. Some users like it too: Disqus notifies users when their comment is replied to for example. For these reasons, when many site owners are facing the prospect of developing their own solution, the ease of installing Disqus makes it a natural choice. Disqus developers seem to have anticipated the typical doubts; concerned about your comments being stored by a third party? No problem, you can download them at any time. For site owners with time or cost pressures, Disqus is a compelling pitch.

### Disqus' drawbacks

Security is a concern. Disqus' popularity makes it an inviting target for hackers as a repeatable exploit will be effective against potentially millions of websites. Exploits for Disqus are regularly discovered, just last [month](http://thehackernews.com/2014/06/Disqus-wordpress-plugin-flaw-leaves.html) a remote code execution exploit was found in the Wordpress Disqus plugin that left an estimated 1.4 million sites vulnerable. In December 2013, a [hack](http://cornucopia-en.cornubot.se/2013/12/flash-disqus-cracked-security-flaw.html) was published that allows a malicious user to obtain the email address of any Disqus user. As a site owner, you have a responsibility to treat your users well; yet a security hole in Disqus could lead to a hacker posting malicious code on your website, that attacks users as they visit the site ([XSS attacks](https://en.wikipedia.org/wiki/Cross-site_scripting)). Morality aside, who knows what the legal costs for the site owner could be if an attack was successful?

Disqus is basically a marketing company; they collect vast amounts of user data and sell advertising to third parties. Disqus tracks users across different websites - whether they are entering comments [or not](http://en.wikipedia.org/wiki/Disqus#Criticism_.26_Privacy_Concerns). Once a user has entered a comment with Disqus, they can be tracked ("followed") by any other Disqus user, and are not able to opt out. If this is starting to sound creepy to you, it's because it is creepy. Disqus' [privacy policy](https://help.disqus.com/customer/portal/articles/466259-privacy-policy) for Personally Identifiable Information (PII) makes it clear that Disqus will disclose PII to third parties "for the purpose of providing the service to you" which sounds reasonable until you stop to question why Disqus would ever need to share PII with a third party. Meanwhile the non-PII that Disqus openly shares with third parties includes: browser cookie data, ip addresses, location and device identifiers. The issue here is that some third parties are so ubiquitous they are a third party to Disqus, but a first party to your users and as such non-PII quickly [becomes](http://cyberlaw.stanford.edu/node/6701) PII. You could argue that users of the site are free to block Disqus with tools like NoScript and Ghostery, which is true, but it also prevents the comments section from appearing for those users. What if they want to read the comments without being tracked?

Most of the features that Disqus provides are easily obtainable elsewhere; need to prevent XSS content? Use [HTML::Entities]({{<mcpan "HTML::Entities" >}}) to HTML encode all outgoing comment text. Want to prevent spam? Add a CAPTCHA for new users posting comments. Want a decent-looking comments section? Copy the Disqus style (ha-ha). The problem is that these features are not tied up in one neat package - a developer will have to assemble the disparate components into a solution. That's called software development.

As a technologist, I see many parallels between Disqus and PHP; they're both so easy to set up but deep-down you know that using them will cost you later. History [shows](http://www.psychologytoday.com/blog/the-inertia-trap/201302/why-are-people-bad-evaluating-risks) that humans consistently underestimate risk and in that regard, Disqus is no different. Site owners, don't let the short-term convenience of Disqus get the better of you, your users deserve better. But what do you think? Let us know in the comments section below\*.

\*J/k let us know on [Reddit](http://www.reddit.com/r/programming/comments/2c19of/your_users_deserve_better_than_disqus/) or [Twitter](https://twitter.com/PerlTricks) instead.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
