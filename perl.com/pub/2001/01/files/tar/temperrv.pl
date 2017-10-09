#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Lite
  on_fault => sub { my($soap, $res) = @_; 
    eval { die ref $res ? $res->faultdetail : $soap->transport->status };
    return ref $res ? $res : new SOAP::SOM;
  };

my $soap = SOAP::Lite
  -> uri('http://www.soaplite.com/Temperatures')
  -> proxy('http://services.soaplite.com/temper.cgi');

defined (my $temp = $soap->c2f(37.5)->result) or die;

print $temp;

