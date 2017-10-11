#!/usr/bin/perl -w

use strict;
use Socket qw(inet_ntoa);
use POE qw( Wheel::SocketFactory  Wheel::ReadWrite
            Filter::Line          Driver::SysRW );
use constant PORT => 31008;

POE::Session->create(
  inline_states => {
    _start => \&server_start,
    accept_new_client => \&accept_new_client,
    accept_failed => \&accept_failed,
    _stop  => \&server_stop,
  },
);

$poe_kernel->run();
exit;


sub server_start {
  $_[HEAP]->{listener} = new POE::Wheel::SocketFactory
    ( BindPort     => PORT,
      Reuse        => 'yes',
      SuccessEvent => "accept_new_client",
      FailureEvent => "accept_failed",
    );
  print "SERVER: Started listening on port ", PORT, ".\n";
}


sub server_stop {
  print "SERVER: Stopped.\n";
}


sub accept_new_client {
  my ($socket, $peeraddr, $peerport) = @_[ARG0 .. ARG2];
  $peeraddr = inet_ntoa($peeraddr);

  POE::Session->create(
    inline_states => {
      _start      => \&child_start,
      _stop       => \&child_stop,
      child_input => \&child_input,
      child_done  => \&child_done,
      child_error => \&child_error,
    },
    args => [ $socket, $peeraddr, $peerport ],
  );
  print "SERVER: Got connection from $peeraddr:$peerport.\n";
}


sub accept_failed {
  my ($function, $error) = @_[ARG0, ARG2];

  delete $_[HEAP]->{listener};
  print "SERVER: call to $function() failed: $error.\n";
}


sub child_start {
  my ($heap, $socket) = @_[HEAP, ARG0];

  $heap->{readwrite} = new POE::Wheel::ReadWrite
    ( Handle => $socket,
      Driver => new POE::Driver::SysRW (),
      Filter => new POE::Filter::Line (),
      InputEvent   => 'child_input',
      ErrorEvent   => 'child_error',
    );
  $heap->{readwrite}->put( "Hello, client!" );

  $heap->{peername} = join ':', @_[ARG1, ARG2];
  print "CHILD: Connected to $heap->{peername}.\n";
}


sub child_stop {
  print "CHILD: Stopped.\n";
}


sub child_input {
  my $data = $_[ARG0];

  $data =~ tr{0-9+*/()-}{}cd;
  return unless length $data;
  my $result = eval $data;
  chomp $@;
  $_[HEAP]->{readwrite}->put( $@ || $result );
  print "CHILD: Got input from peer: \"$data\" = $result.\n";
}


sub child_done {
  delete $_[HEAP]->{readwrite};
  print "CHILD: disconnected from ", $_[HEAP]->{peername}, ".\n";
}


sub child_error {
  my ($function, $error) = @_[ARG0, ARG2];

  delete $_[HEAP]->{readwrite};
  print "CHILD: call to $function() failed: $error.\n" if $error;
}
