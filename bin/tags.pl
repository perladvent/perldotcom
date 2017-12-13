#!/usr/bin/perl
use strict;
use warnings;
use v5.14.0; # s///r

# find missing perl.com categories from our tags
my $parent_dir = 'tpf.github.io/tags/';
my @tags = map { s/$parent_dir//r } <$parent_dir*>;
while (my $keyword = <DATA>) {
  chomp $keyword;
  print "$keyword\n" unless grep { $keyword eq $_ } @tags;
}

__DATA__
advocacy
binaries
biology
books-and-magazines
bug-trackingreporting
business
c-and-perl
cgi
communications
community
compiler
courses-and-training
cpan
databases
data-structures
debugging
dynamic-content
editors
email
files
finance
games
graphics
http
installation
java
language-development
larry-wall
lingua
linux
lists
macintosh
mail-and-usenet-news
mod-perl
modules
music
net
networking-applications
objects
oddities
officebusiness
open-source
perl-6
perl-internals
porting
programming
regular-expressions
school
screen-io
security
statistics
style-guides
sysadmin
system-administration-applications
text-tools
tools
troubleshooting
tutorials
user-interfaces
version-control-systems
webcgi
web-development
web-management
win32
xml
y2k
