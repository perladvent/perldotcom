#!/usr/bin/env perl

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Lite +autodispatch =>
  uri => 'Temperatures',
  proxy => 'http://services.soaplite.com/temper.cgi';

print c2f(37.5);
