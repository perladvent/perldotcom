#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Lite;

print SOAP::Lite                                            
  -> uri('http://www.soaplite.com/Temperatures')                                    
  -> proxy('http://services.soaplite.com/temper.cgi')
  -> c2f(37.5)                                              
  -> result;

