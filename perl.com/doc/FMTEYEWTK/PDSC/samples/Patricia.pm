package Patricia;


use English;
use Carp;

# use strict;
use integer;

$Patricia::MAXB = 9999999;

sub new {
    if (@ARG > 1) {
	confess  "usage: new Patricia";
    } 
    if (@ARG == 1) {
	my $self = shift;
	if ($self ne "Patricia" && ref $self ne "Patricia") { 
	    confess "invalid obref";
	}
    } 

    my $node = bless {};

    %$node = (
	"LEFT" 	=> $node,
	"RIGHT"	=> $node,
	"KEY" 	=> 0,
	"INFO" 	=> "",
	"BITS" 	=> $Patricia::MAXB,
    );

    return $node;

} 

sub search { my ($head,$v) = @ARG;

    if (@ARG != 2)               { confess "usage: search TREE KEY" } 
    if (ref $head ne "Patricia") { confess "invalid obref" }

    my $p = $head;
    my $x = $head->{"LEFT"};

    while ($p->{"BITS"} > $x->{"BITS"}) {
	$p = $x;
	$x = $x->{ bits($v, $x->{"BITS"}, 1) ? "RIGHT" : "LEFT" };
    } 
    if ($v == $x->{"KEY"}) {
	return $x->{"INFO"};
    } else {
	return undef;
    } 
} 

sub insert { my ($head, $v, $info) = @ARG;

    if (@ARG != 3) 		 { confess "usage: insert TREE KEY INFO" }
    if (ref $head ne "Patricia") { confess "invalid obref" }

    my ($p, $t, $x);

    my $i = $Patricia::MAXB;
    $p = $head;
    $t = $head->{"LEFT"};

    while ( $p->{"BITS"} > $t->{"BITS"} ) {
	$p = $t;
	$t = $t->{bits($v, $t->{"BITS"}, 1) ? "RIGHT" : "LEFT"};
    } 

    if ($v == $t->{"KEY"}) { return }

    while (bits($t->{"KEY"}, $i, 1) == bits($v, $i, 1)) { $i-- } 

    $p = $head;
    $x = $head->{"LEFT"};
    while ($p->{"BITS"} > $x->{"BITS"} && $x->{"BITS"} > $i) {
	$p = $x;
	$x = bits($v, $x->{"BITS"}, 1) ? $x->{"RIGHT"} : $x->{"LEFT"};
    } 

    $t = new();
    $t->{"KEY"} = $v; $t->{"INFO"} = $info; $t->{"BITS"} = $i;
    $t->{"LEFT"}  = (bits($v, $t->{"BITS"}, 1)) ? $x : $t;
    $t->{"RIGHT"} = (bits($v, $t->{"BITS"}, 1)) ? $t : $x;
    $p->{ bits($v, $p->{"BITS"}, 1) ? "RIGHT" : "LEFT" } = $t;
} 

sub bits {
    my($x, $k, $j) = @_;
    ($x >> $k) & ~(~0 << $j);
} 

sub print {	my($node) = @ARG;
    if (@ARG != 1) 		 { confess "usage: dump TREE" }
    if (ref $node ne "Patricia") { confess "invalid obref" }

    print <<EOF;
Node is $node
	BITS	$node->{"BITS"} 	
	KEY	$node->{"KEY"} 	
	INFO	$node->{"INFO"} 	
	LEFT	$node->{"LEFT"} 
	RIGHT	$node->{"RIGHT"} 	
EOF
} 

sub dtree {
    local %Patricia::seen;
    &Patricia::rdumpdree;
}

sub rdumpdree {
    my($node) = @ARG;
    $node->{"LEFT"}->rdumpdree()  unless $Patricia::seen{$node}++;
    $node->print();
    $node->{"RIGHT"}->rdumpdree() unless $Patricia::seen{$node}++;
}
