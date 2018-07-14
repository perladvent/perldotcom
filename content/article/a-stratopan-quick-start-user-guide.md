{
   "title" : "A Stratopan quick start user guide",
   "tags" : [
      "sysadmin",
      "config",
      "stratopan",
      "cloud",
      "saas"
   ],
   "date" : "2013-11-15T04:23:53",
   "description" : "Learn how to manage your Perl modules in the cloud with Stratopan",
   "image" : "/images/48/EBD9AC70-FF2E-11E3-AD4C-5C05A68B9E16.png",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "48/2013/11/15/A-Stratopan-quick-start-user-guide",
   "categories" : "tooling",
   "draft" : false,
   "thumbnail" : "/images/48/thumb_EBD9AC70-FF2E-11E3-AD4C-5C05A68B9E16.png"
}


*[Stratopan](https://stratopan.com/) is a cloud-based Perl module repository service. Users can create repositories of modules in the cloud and use them to manage their local installations of Perl modules. This makes it easy to configure a network of machines to have exactly the same modules (and versions), deploy Perl applications quickly and cleanly and host private (i.e. non CPAN) Perl software in a secure, central location. The [Stratopan](https://stratopan.com/) beta has officially started and so there has never been a better time to check out this amazing service. Read on for an unofficial quick start guide to Stratopan!*

### Getting started - create a repository

Head over to Stratopan, sign up to create a new account and login. You should be presented with this message:

![stratopan screenshot](/images/Stratopan/stratopan_1_600.png)

Click the create repository link and complete the information on the following screen. Be sure to select the private option if you want your repository not to be publicly visible.

![stratopan screenshot](/images/Stratopan/stratopan_2_600.png)

You should now have a new repository.

![stratopan screenshot](/images/Stratopan/stratopan_19_600.png)

### Add or pull modules

Modules reside in "stacks" which belong to a repository and helpfully Stratopan creates a default "master" stack for you. To insert modules into a stack you can "pull" them from CPAN or "add" them from a local machine. Let's start by pulling a module onto our master stack. Click the "pulling" link to launch the pull module screen and start typing the name of the module you want to pull. Note that this must be the distribution name and not the module name. For example to pull the module "Method::Signatures", you should type "Method-Signatures". Helpfully Stratopan provides a case-insensitive predictive text search and lists the module version numbers available too, in case you need a specific variant. Let's pull my wildly unpopular [WWW::CheckHTML]({{<mcpan "WWW::CheckHTML" >}}) module:

![stratopan screenshot](/images/Stratopan/stratopan_3_600.png)

Decide if you want Stratopan to recursively pull all module dependencies; this is usually a good option. What's nice about this is the "recursive" pull will grab all the modules dependent on your chosen module's dependencies.

![stratopan screenshot](/images/Stratopan/stratopan_4_600.png)

It can be surprising how many dependencies there are - for example [WWW::CheckHTML]({{<mcpan "WWW::CheckHTML" >}}) has 5 direct dependencies and 69 indirect ones. Obviously when there are more dependent modules, Stratopan will take longer to pull them into the stack (usually a minute or two). When it's finished, Stratopan will present the the latest view of the stack.

![stratopan screenshot](/images/Stratopan/stratopan_5_600.png)

Stratopan provides some useful stack features. A link to [metapcan](https://metacpan.org) is provided for every module (except for private modules that have been added from a local machine) and it's possible to browse the \*.pm files in a module by clicking on it:

![stratopan screenshot](/images/Stratopan/stratopan_20_600.png)

Each stack has it's own commit history, accessed via the aptly-named "history" link:

![stratopan screenshot](/images/Stratopan/stratopan_22_600.png)

The "graphs" link is much more interesting. It opens this cool, rotatable dependencies chart:

![stratopan screenshot](/images/Stratopan/stratopan_21_600.png)

Finally the "settings" link let's you update the stack name, description and target Perl version. You can also delete the stack from here.

![stratopan screenshot](/images/Stratopan/stratopan_23_600.png)

### Installing modules from your Stratopan stack

To install modules from Stratopan you'll need [cpanm](https://cpanmin.us). You can install this via cpan from the terminal:

```perl
cpan App::cpanminus
```

Once cpanm has installed, open one of your stacks on Stratopan and copy the stack URL (shown in red below).

![stratopan screenshot](/images/Stratopan/stratopan_24_600.png)

At the terminal type "cpanm --mirror-only --mirror " and paste your copied stack URL and enter one or more module names that you wish to install. For example to install [WWW::CheckHTML]({{<mcpan "WWW::CheckHTML" >}}) from my master stack:

```perl
cpanm --mirror-only --mirror
https://stratopan.com/sillymoose/WebStuff/master WWW::CheckHTML
```

If all goes well you should see the following installation dialogue:

```perl
--> Working on WWW::CheckHTML
Fetching https://stratopan.com/sillymoose/WebStuff/master/authors/id/S/SI/SILLYMOOS/WWW-CheckHTML-0.04.tar.gz ... OK
Configuring WWW-CheckHTML-0.04 ... OK
Building and testing WWW-CheckHTML-0.04 ... OK
Successfully installed WWW-CheckHTML-0.04
1 distribution installed
```

### Conclusion

[Stratopan](https://stratopan.com) is an awesome new service which can hugely simplify the configuration of your Perl platforms. Hopefully this guide has given you a better idea of how to get started with it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
