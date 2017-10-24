{
   "slug" : "71/2014/2/20/Easy-application-dependency-management-with-Stratopan",
   "tags" : [
      "community",
      "sysadmin",
      "config",
      "stratopan",
      "cloud",
      "old_site"
   ],
   "categories" : "tooling",
   "image" : "/images/71/EC623B08-FF2E-11E3-92DE-5C05A68B9E16.png",
   "draft" : false,
   "date" : "2014-02-20T03:55:29",
   "title" : "Easy application dependency management with Stratopan",
   "description" : "Get the right modules and versions everytime",
   "authors" : [
      "david-farrell"
   ]
}


*Good Perl authors write modular code and leverage CPAN as much as possible. The downside of this approach is that Perl applications accumulate hundreds of CPAN module dependencies. Fortunately for Perl, Stratopan makes it simple to manage your application dependencies and quickly deploy it to new environments.*

### How many dependencies?!

Perl application dependencies grow rapidly. This is because every time you import a module, you take on that module's dependencies, and those of its imports and so on. The cover picture above shows the dependencies graph for the PerlTricks.com application; it's 283 modules. That's a lot of code to manage.

### Manage module dependencies with Stratopan

[Stratopan](https://stratopan.com), the cloud-based module hosting service, let's you upload Perl modules to a personal repository in the cloud. On our [PerlTricks](https://stratopan.com/sillymoose/webstuff/perltricks) stack, we've uploaded the exact versions of all of the modules used in our production environment. Many of the modules are not up to date, but that doesn't matter as these are the module versions that *work*.

### Rapid Deployment

Deploying this stack to a fresh environment couldn't be easier. We can use [cpanm](https://metacpan.org/pod/release/MIYAGAWA/App-cpanminus-1.7001/bin/cpanm) to read our Makefile.PL and recursively install our application dependencies, using Stratopan as the source. In the terminal we navigate to the root application directory and enter:

``` prettyprint
$ cpanm -n --installdeps --mirror-only --mirror https://stratopan.com/sillymoose/WebStuff/perltricks .
```

Let's review this code: first we use cpanm's "-n" switch to turn off module tests to install the modules super-fast. The "--installdeps" switch makes cpanm look for application dependencies. The "mirror" switches instruct cpan to use our Stratopan stack as the install source. The trailing period indicates to search for dependencies in the current directory. This is the perfect marriage: Stratopan recursively pulled our module dependencies into our stack, and cpanm recursively installs all dependencies it finds. Even though our Makefile lists ~40 modules, cpanm ends up installing all 283.

When we want to upgrade our modules we can do it in a controlled way by making a copy of our stack upgrading the modules for testing in a development environment, before upgrading production.

### Conclusion

Without Stratopan and cpanm, deploying the PerlTricks application to a new server would be a lot more work. We'd either have to list and source the specific module versions and deploy them manually, or else install the newest versions of all of 283 dependencies and hope they still play nice with each other. Two of our dependences are no longer even on CPAN!

Want to get started with Stratopan? Check out our [quick start user guide](http://perltricks.com/article/48/2013/11/15/A-Stratopan-quick-start-user-guide).

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F71%2F2014%2F2%2F20%2FEasy-application-dependency-management-with-Stratopan&text=Easy+application+dependency+management+with+Stratopan&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F71%2F2014%2F2%2F20%2FEasy-application-dependency-management-with-Stratopan&via=perltricks) it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
