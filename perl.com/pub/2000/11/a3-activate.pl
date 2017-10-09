#!/usr/local/bin/perl -w

$hard_way = 1;    # Use s/// to do everything in one regexp?

$filename = $ARGV[0];

unless ($filename) { die "Usage: a3-activate.pl <filename>"; }

open (FILENAME, "$filename") or die "Can't open $filename - $!";

while ($sentence = <FILENAME>) {
    print activate($sentence);
}

close FILENAME;


sub activate {
    my ($sentence) = @_;

    if ($hard_way == 1) {
	# We can do this with just one regexp...

	$sentence =~ s/(.*) was (.*) by (.*)\./$3 $2 $1\./;
    } else {
	# ...but it might be easier to understand if we do it the long way.
	
	if ($sentence =~ /(.*) was (.*) by (.*)\./) {
	    my ($object, $verb, $subject) = ($1, $2, $3);
	    $sentence = $subject . ' ' . $verb . ' ' . $object . '.';
	}
    }

    return $sentence;
}
