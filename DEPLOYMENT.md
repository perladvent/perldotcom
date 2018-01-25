Deployment
==========
This document is aimed at any Perl.com editor who wants to update the live site. Perl.com is organized as a Git repo which is built with [hugo](https://gohugo.io) and the generated files are pushed to the private perl.com-staging repo managed by the TPF organization. Changes pushed to that repo are reflected on the live site within a few minutes.

To deploy the site:
1. Clone this repo
2. Clone the private TPF perl.com-staging repo
3. Install [hugo](https://gohugo.io)
4. Change into the root perldotcom dir and run `bin/deploy`
5. The live site will be updated a short while after
