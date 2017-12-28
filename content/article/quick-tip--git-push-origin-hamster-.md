{
   "slug" : "206/2015/12/24/Quick-tip--git-push-origin-hamster-",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-12-24T17:20:05",
   "draft" : false,
   "image" : "/images/206/7CC46A3A-AA60-11E5-B179-9189815E78B2.jpeg",
   "description" : "Making git do you what mean with symbolic references",
   "title" : "Quick tip: git push origin hamster?",
   "tags" : [
      "git",
      "symbolic",
      "ref",
      "master",
      "branch"
   ],
   "categories" : "apps"
}


My typing is horrible. I make mistakes all the time. I'm an avid [Vim](http://www.vim.org/) user but I still use the arrow keys. I'm one of those people who need technology that does what they meant, not what they asked for. So if you're a coder like me, you probably see this a lot:

```perl
$ git push origin amster
error: src refspec amster does not match any.
```

Fortunately there is a simple workaround: Git's [symbolic references](https://git-scm.com/docs/git-symbolic-ref). I can add a symbolic reference for `amster`:

```perl
$ git symbolic-ref refs/heads/amster refs/heads/master
```

And now Git does what I meant:

```perl
$ git push origin amster
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (3/3), done.
Writing objects: 100% (3/3), 695 bytes | 0 bytes/s, done.
Total 3 (delta 2), reused 0 (delta 0)
To git@github.com:user/SomeProject.git
   ec208c7..fb0cb8f  amster -> master
```

Because it's a symbolic reference, anytime I mean to type `master` but actually type `amster`, Git will do the right thing. Try it!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
