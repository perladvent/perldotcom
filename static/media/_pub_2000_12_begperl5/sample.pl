#!/usr/local/bin/perl

use TutorialConfig;

$tut = new TutorialConfig;

$tut->read('tutc.txt') or die "Couldn't read config file: $!";

print "The author's first name is ", $tut->get('author.firstname'), ".\n";

