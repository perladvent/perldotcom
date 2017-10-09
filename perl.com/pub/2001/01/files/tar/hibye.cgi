#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Transport::HTTP;

SOAP::Transport::HTTP::CGI   
  -> dispatch_to('Demo')     
  -> handle;

package Demo;

sub hi {                     
  return "hello, world";     
}

sub bye {                    
  return "goodbye, cruel world";
}

sub languages {                 
  return ("Perl", "C", "sh");   
}
