#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Lite;

my $soap = SOAP::Lite
  -> uri('Temperatures')
  -> proxy('http://services.soaplite.com/temper.cgi');

my $temperatures = $soap
  -> call(new => 100) # accept Fahrenheits 
  -> result;

print $soap
  -> as_celsius($temperatures)
  -> result;
