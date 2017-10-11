#!/usr/bin/perl -w

use strict;
use IO::Socket;
use IO::Select;
use Getopt::Long;
use Curses;

use constant DATA_num_channels => 113;
use constant DATA_num_elements => 8;
use constant DATA_header_size  => 5;
use constant DATA_packet_size  =>
  DATA_num_channels * DATA_num_elements + DATA_header_size;

use constant DATA_max_element  => 7;
use constant DATA_element_size =>
  (DATA_num_elements + 1) * 4; # 4-byte elements

use constant DATA_inbound_pack => "A4c";
use constant DATA_inbound_header => ('DATA',0);

grep { $_ eq '-h' } @ARGV and do { Usage() };

my $x_plane_ip     = '127.0.0.1';
my $receive_port   = 49999;
my $transmit_port  = 49000;
my $destination_os = 'Mac';
GetOptions("x=s" => \$x_plane_ip,
           "r=s" => \$receive_port,
           "t=s" => \$transmit_port,
           "d=s" => \$destination_os);
$destination_os = $destination_os =~/Mac/ ? 1 : 0;

# {{{ Usage statement
sub Usage {
  print STDERR <<_EOF_;
$0: $0 [options]
	-h	Print this help screen and quit
	-x	IP of the machine X-Plane is on (default 127.0.0.1)
	-r	Port to receive data from X-Plane on (default 49999)
	-t	Port to transmit data to X-Plane on (default 49000)
	-d	Destination O/S ('Win' or 'Mac', default 'Mac')
_EOF_
  exit 1;
}
# }}}

my $port=IO::Socket::INET->new(
  LocalPort => $receive_port,
  LocalAddr => $x_plane_ip,
  Proto     => 'udp')
  or die "error creating receive port for $x_plane_ip: $@\n";

my $receive = IO::Select->new();
$receive->add($port);

my $sport=IO::Socket::INET->new(
  PeerPort  => $transmit_port,
  PeerAddr  => $x_plane_ip,
  ReusePort => 1,
  Proto     => 'udp')
  or die "error creating transmit port for $x_plane_ip: $@\n";

my $transmit = IO::Select->new();
$transmit->add($sport);

my $DATA_buffer = {};

# Initialize curses after the common causes of dying are found
# because Curses plays with the terminal settings
#
my $win = Curses->new();

# These formats are represented by X-Plane as floating point
#
my @float_formats = qw( f deg mph pct );

# {{{ Field type formats
# Some fields need special formatting.
#
my $typedef = {
  deg => { format => "%+03.3f", len => 8 },
  mph => { format => "%03.3f", len => 7 },
  pct => { format => "%+01.3f", len => 6 },
};
# }}}

# {{{ The DATA packet structure
#
# The packet header goes on later.
#
my $DATA_packet = {
  #
  # The outer hash reference contains a sparse array of data frames
  #
  0 => {
    #
    # The inner hash reference contains a sparse array of data elements
    #
    0 => { type => 'f', label => 'Frame Rate',
           label_x => 0, label_y => 0,
           x => 12, y => 0 },
  },
  2 => {
    0 => { type => 'mph', label => 'True Speed',
           label_x => 0, label_y => 1,
           x => 12, y => 1},
  },
  12 => {
    0 => { type => 'bool', label => 'Gear',
           label_x => 0, label_y => 3,
           x => 6, y => 3 },
  },
  16 => {
    0 => { type => 'deg', label => 'Pitch',
           label_x => 40, label_y => 0,
           x => 50, y => 0 },
    1 => { type => 'deg', label => 'Roll',
           label_x => 40, label_y => 1,
           x => 50, y => 1 },
  },
  18 => {
    0 => { type => 'deg', label => 'Latitude',
           label_x => 40, label_y => 3,
           x => 50, y => 3  },
    1 => { type => 'deg', label => 'Longitude',
           label_x => 40, label_y => 4,
           x => 50, y => 4 },
  },
  23 => {
    0 => { type => 'pct', label => 'Thr 1',
           label_x => 0, label_y => 6,
           x => 10, y => 6  },
    1 => { type => 'pct', label => 'Thr 2',
           label_x => 0, label_y => 7,
           x => 10, y => 7 },
    2 => { type => 'pct', label => 'Thr 3',
           label_x => 0, label_y => 8,
           x => 10, y => 8  },
    3 => { type => 'pct', label => 'Thr 4',
           label_x => 0, label_y => 9,
           x => 10, y => 9 },
  },
};
# }}}

# {{{ Display the labels in the window
sub setup_display {
  for my $channel (values %$DATA_packet) {
    for my $element (values %$channel) {
      $win->addstr($element->{label_y},
                   $element->{label_x},
                   $element->{label}) if $element->{label};
    }
  }
}
# }}}

# {{{ Create pack() strings
#
# X-Plane uniformly sends 4-byte floats outbound,
# but accepts a mixture of floats and integers inbound.
#
sub create_pack_strings {
  for my $row (values %$DATA_packet) {
    $row->{unpack} = 'x4';
    $row->{pack} = 'l';
    for my $j (0..DATA_max_element) {
      if(exists $row->{$j}) {
        my $col = $row->{$j};
        $row->{pack} .=
          (grep { $col->{type} eq $_ } @float_formats) ? 'f' : 'l';
        $row->{unpack} .= 'f';
      }
      else {
        $row->{pack} .= 'f';
        $row->{unpack} .= 'x4';
      }
    }
  }
}
# }}}

# {{{ Transmit a message
sub transmit_message {
  my ($socket,$pack_format,@message) = @_;
  my ($server) = $socket->can_write(60);
  $server->send(pack($pack_format,@message));
}
# }}}

# {{{ Receive a message
sub receive_DATA {
  my ($message) = @_;
  $DATA_buffer = { };
  for (my $i = 0;
       $i < (length($message)-&DATA_header_size-1) / DATA_element_size;
       $i++) {
    my $channel = substr($message,
                         $i * DATA_element_size + DATA_header_size,
                         DATA_element_size);

    my $index = unpack "l", $channel;
    next unless exists $DATA_packet->{$index};

    my $row = $DATA_packet->{$index};
    my @element = unpack $row->{unpack}, $channel;
    my $ctr = 0;
    for my $j (0..DATA_max_element) {
      next unless exists $row->{$j};
      my $col = $row->{$j};
      $DATA_buffer->{$index}{$j} = $element[$ctr];
      if($col->{type} eq 'bool') {
        $win->addstr($col->{y},
                     $col->{x},
                     $element[$ctr]==1.0 ? '[#]' : '[ ]');
      }
      elsif(defined $typedef->{$col->{type}}) {
        $win->addstr($col->{y},
                     $col->{x},
                     ' ' x $typedef->{$col->{type}}{len});
        $win->addstr($col->{y},
                     $col->{x},
                     sprintf($typedef->{$col->{type}}{format},$element[$ctr]));
      }
      else {
        $win->addstr($col->{y},
                     $col->{x},
                     $element[$ctr]);
      }
      $ctr++;
    }
  }
}
# }}}

# {{{ transmit_DATA
sub transmit_DATA {
  my ($socket, @message) = @_;
  my $pack_str = DATA_inbound_pack;
  for(my $packet = 0;
      $packet < @message;
      $packet += (DATA_num_elements + 1)) {
    $pack_str .= $DATA_packet->{$message[$packet]}{pack};
  }
  transmit_message($socket,$pack_str,DATA_inbound_header,@message,0);
}
# }}}

# {{{ Fill in a DATA channel
sub _fill_channel {
  my ($packet) = @_;
  my @buffer = (-999) x DATA_num_elements;
  for(0..7) {
    $buffer[$_] = $packet->{$_} if defined $packet->{$_};
  }
  return @buffer;
}
# }}}

# {{{ Send outbound messages if there are any
sub transmit_socket {
  my ($socket,$ch) = @_;
  if($ch eq 'g') {
    transmit_DATA(
      $socket,
      12,
      $DATA_buffer->{12}{0} ? 0 : 1,
      (-999) x 7);
  }
  elsif($ch eq 'i') {
    my @engine =
      map { $_ != -999 ? $_+0.1 : -999 }
      _fill_channel($DATA_buffer->{23});
    transmit_DATA( $socket, 23, @engine );
  }
  elsif($ch eq 'k') {
    my @engine =
      map { $_ != -999 ? $_-0.1 : -999 }
      _fill_channel($DATA_buffer->{23});
    transmit_DATA( $socket, 23, @engine );
  }
}
# }}}

# {{{ Listen to the inbound socket
sub receive_socket {
  my ($socket) = @_;

  my ($server) = $socket->can_read(60);
  my $message;
  $server->recv($message,DATA_packet_size);

  receive_DATA($message);

  $win->refresh();
}
# }}}

# {{{ Main Curses loop
sub main_loop {
  my ($receive,$transmit) = @_;

  while(1) {
    if(my $ch = $win->getch()) {
      last if $ch =~ /q/i;
      transmit_socket($transmit,$ch);
    }
    receive_socket($receive);
  }
}
# }}}

noecho();
cbreak();
$win->timeout(1);

setup_display();
create_pack_strings();
main_loop($receive,$transmit);

endwin();
