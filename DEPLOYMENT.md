# Deployment

This document is aimed at any Perl.com editor who wants to update the [live site](https://www.perl.com).
Perl.com is organized as a Git [repository](https://github.com/perladvent/perldotcom/tree/master) which is built with [Hugo](https://gohugo.io) and the generated files are pushed to the **private** [`perl.com-staging`](https://github.com/tpf/perl.com-staging) repository managed by the [TPF](https://www.perlfoundation.org) organization.
Changes pushed to that repository are reflected on the live site within a few minutes.

## Steps

1. Clone this repository
2. Clone the private TPF [`perl.com-staging`](https://github.com/tpf/perl.com-staging) repository
3. Install [Hugo](https://gohugo.io). **Warning** packaged versions of hugo are often very out of date, and may not work. You're usually better off with a [pre-compiled binary](https://github.com/gohugoio/hugo/releases). The site is tested against v0.31.1 and higher
4. Change into the root `perldotcom` directory and run [`bin/deploy`](bin/deploy)
5. The live site will be updated a short while after
