Deployment
==========
Perl.com is organized as a Git repo with a submodule, "tpf.github.com" which is the static site. Pushing commits to the submodule will update the site.

The script `bin/deploy` handles all of this. If you have setup GitHub auth, and have collaborator permissions on both repos, simply run the script from the root repo directory and it will:

- build the site with [hugo](https://gohugo.io)
- commit the changes to the submodule with a message like "generated site"
- push the changes to the submodule remote, updating the website
- commit the submodule changes to the parent repo with a message like "deployed site"
