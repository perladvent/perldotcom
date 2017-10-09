#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Lite +autodispatch =>
  uri => 'Temperatures',
  proxy => 'http://services.soaplite.com/temper.cgi';

my $temperatures = Temperatures->new(100);
print $temperatures->as_fahrenheit($object);
