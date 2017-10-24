{
   "draft" : false,
   "image" : "/images/69/EC51073E-FF2E-11E3-94AE-5C05A68B9E16.png",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "69/2014/2/17/Is-PearlBee-Perl-s-next-great-blogging-platform-",
   "categories" : "apps",
   "tags" : [
      "community",
      "blog",
      "github",
      "movable_type",
      "evozon",
      "open_source"
   ],
   "date" : "2014-02-17T04:09:21",
   "description" : "We review the new open source blogging platform",
   "title" : "Is PearlBee Perl's next great blogging platform?"
}


*Last year the Perl-based Movable Type blogging platform turned closed-source and left Perl without a major open source blogging platform. The wait is over; PearlBee is a new open source blogging platform written in Perl and developed by Evozon. But is it any good? We took it for a spin to find out.*

### Setup

I tested the PearlBee on a machine running Fedora 19, MariaDB v5.5.34 and Perl 5.16.3. Installation was simple, I followed the readme instructions from the project's GitHub [repository](https://github.com/perl-evozon/pearlbee).

### Writing a blog post

PearlBee comes with an administration portal from where you can write new blog posts. It's accessed via a login page at /admin. The default login credentials are "admin" and "password".

![PearlBee login page screenshot](/images/69/admin_login.png)

Once logged in, by default the new post form will display:

![PearlBee new post page screenshot](/images/69/new_post.png)

The form is well put together: it has title, slug and cover image file upload controls and a WYSIWYG editor for the main blog text. To the right of the main form is a details form, for setting the blog post category and adding tags. PearlBee creates a tag object for every tag text entered, allowing the tags to be searched against and reused in later posts.

![PearlBee new post page screenshot](/images/69/completed_post.png)

Having completed the form, press "Publish" to save the post and make it live. PearlBee will display a helpful success message:

![PearlBee saved post page screenshot](/images/69/saved_post.png)

And the post will now be live on the main blog page:

![PearlBee page frontpage screenshot](/images/69/post_on_frontpage.png)

Notice how PearlBee has updated the categories and tags on the right side of the screen for convenient filtering.

One thing that could be better is the image handling. I found that a square image was unevenly flattened into landscape proportions (but it displays correctly on the blog front page).

![PearlBee saved post flat image page screenshot](/images/69/flat_onion_image.png)

I tested PearlBee's image upload with both jpeg and png files and both worked fine.

### Basic Administration

PearlBee's admin portal has a slick and clean interface. Menu drop-down lists expand and contract smoothly and forms are provided to manage the site's data. We've encountered some of the database model objects already: posts, categories and tags. Here is the post management page:

![PearlBee post management page screenshot](/images/69/post_management.png)

The page lists all posts and provides there high level attributes such as author, title and categories. It also provides switches to quickly change a post's status. This is useful if a post needs to be taken-down and edited, or re-posted. At the time of review the page contained a couple of typos and unfortunately the link to view the article did not work (neither the link on the title or the eye icon). These can be worked around though.

One other opportunity for improvement here: PearlBee should create the appropriate META tags for blog posts, using the post's attributes. This would help with SEO.

There is also a site-wide settings page for the blog. From here you can set the blog's timezone and enable / disable use of social media buttons.

### Comments

PearlBee comes with a comments system built-in. The comments form appears beneath a blog post, with existing comments showing there as well:

![PearlBee comment management page screenshot](/images/69/comment_posted.png)

I thought the styling on the comments form looks professional and reminded me of the "Disqus" comments system design. PearlBee provides a CAPTCHA on the form out-of-the-box, which is a useful spam filter.

All comments are moderated, and require approval before going live. I tested the comment submission and moderation process and it worked first time. This is the comments management page:

![PearlBee comment management page screenshot](/images/69/comment_management.png)

Once approved, comments appear beneath the blog post.

Comments can be security risk as they allow users to upload text which is then displayed on the site. For example if a user uploads malicious JavaScript, they can carry out a XSS attack whenever a visitor loads the page with the comment (or an administrator reviews it). PearlBee does not yet implement comment content filtering which can prevent this type of attack by removing code characters from the comment text. This would need to be in place before a PearlBee site was used in a production environment.

### User Management

PearlBee recognizes two types of users: "administrators" who can manage the site's data, and "authors" who can write blog posts but not do much else. As with the other database objects, PearlBee provides a form-driven interface for managing the site's users. During testing I was able to create a new author, login with that author and write blog posts. It worked well. PearlBee created a default, random, encrypted password for the account and sent the new user an email with instructions on how to login (the email actually wasn't sent, more on this later). PearlBee uses [Crypt::RandPasswd](https://metacpan.org/pod/Crypt::RandPasswd) to generate the initial password, and [Digest::SHA1](https://metacpan.org/pod/Digest::SHA1) to encrypt it. This should be set to a stronger encryption method, as Digest::SHA1 contains [security weaknesses](https://www.schneier.com/blog/archives/2005/02/cryptanalysis_o.html).

Additional roles might be useful here: an editor role that can edit and publish posts, but not change the site's settings or create new users would bridge the gap between the current admin and author roles. I would probably remove the author role's permission to publish articles.

### Customization

PearlBee is built in a responsive design with the Twitter Bootstrap framework. The design is clever and works well at many different screen resolutions and form factors. At this time of writing there are no publicly available alternative themes, so you're stuck with the existing theme unless you want to code an alternative one yourself. I did find an example alternative theme online: the "Built in Perl" [blog](http://blog.builtinperl.com/).

Apart from the design, you'll want to edit the PearlBee templates to use your blog's name, and update the default footer information. It would be awesome if PearlBee were able to read this from the config.yml file, rather than requiring code edits to the template toolkit view files.

PearlBee requires a local SMTP server to send emails (such as the new user welcome email). I found the email settings were hard-coded to use the default and not configurable, which meant I wasn't able to test the email functionality. Contrary to the Makefile, PearlBee uses [Email::Template](https://metacpan.org/pod/Email::Template) and not MIME::Email or Email::Sender::Simple to handle email. PearlBee does come with some pre-configured email templates which look useful.

### Conclusion

PearlBee is a promising platform that is still in development. It looks good, has a solid data model and runs fast on the Dancer2 framework with DBIx::Class. In my interactions with the development team they were responsive and helpful. It feels about 80% complete - the core functionality is in place but there are some rough edges. PearlBee needs better security, SEO integration and to be more configurable. If the development team can resolve these issues in time for the first major release of PearlBee, it could be a milestone Perl development for what has been a barren couple of years in blogging technology.

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F69%2F2014%2F2%2F17%2FIs-PearlBee-Perl-s-next-great-blogging-platform-&text=Is+PearlBee+Perl%27s+next+great+blogging+platform%3F&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F69%2F2014%2F2%2F17%2FIs-PearlBee-Perl-s-next-great-blogging-platform-&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
