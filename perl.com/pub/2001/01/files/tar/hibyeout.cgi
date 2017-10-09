#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Transport::HTTP;

use Demo;

SOAP::Transport::HTTP::CGI   
  -> dispatch_to('Demo')     
  -> handle;
