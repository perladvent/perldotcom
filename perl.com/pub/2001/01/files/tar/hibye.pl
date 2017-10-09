#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Lite;

print SOAP::Lite                                             
  -> uri('http://www.soaplite.com/Demo')                                             
  -> proxy('http://services.soaplite.com/hibye.cgi')
  -> hi()                                                    
  -> result;

