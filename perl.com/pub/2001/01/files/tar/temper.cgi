#!perl -w

# -- SOAP::Lite -- guide.soaplite.com -- Copyright (C) 2001 Paul Kulchenko --

use SOAP::Transport::HTTP;

SOAP::Transport::HTTP::CGI
  -> dispatch_to('Temperatures')
  -> handle;

package Temperatures;

sub f2c {
  my ($class, $f) = @_;
  return 5/9*($f-32);
}

sub c2f {
  my ($class, $c) = @_;
  return 32+$c*9/5;
}

sub new {
  my $self = shift;
  my $class = ref($self) || $self;
  bless {_temperature => shift} => $class;
}

sub as_fahrenheit {
  return shift->{_temperature};
}

sub as_celsius {
  return 5/9*(shift->{_temperature}-32);
}
