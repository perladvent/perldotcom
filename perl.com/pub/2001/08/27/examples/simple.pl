use strict;
use Tk;

my $mw = MainWindow->new;

my $msg = "";

sub show {
    my $let = shift;
    if ($let eq "Quit") {
        exit;
    } elsif ($let eq "Clear") {
        $msg = "";
    } else {
        $msg .= $let;
    }
}

$mw->Label(-textvariable => \$msg, font => "Arial 15 bold")->pack;
my ($lab, $timer);
for my $let (qw(A B C D E Clear Quit)) {
    $lab = $mw->Label(-text => $let, font => "Arial 15 bold")->pack;
	$lab->bind("<Enter>", sub {
		$timer = $mw->after(500, [ \&show, $let ])
    });
	$lab->bind("<Leave>", sub {
		$timer->cancel;
	});
}
MainLoop;

