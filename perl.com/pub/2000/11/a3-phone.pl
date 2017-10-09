#!/usr/local/bin/perl

@phones = ('2125551000', '416.555.3350', '555-9777x552',
	   '(604) 555-3600 extension 40');

for $i (@phones) {
    print fix_phone($i), "\n";
}

sub fix_phone {
    my ($phone) = @_;
    my ($return);

    # Our phone numbers contain either ten or seven digits,
    # broken down into groups of either 3-3-4 or 3-4.  We match
    # for ten digits first.
    if ($phone =~ /(\d{3}).*(\d{3}).*(\d{4})/) {
	$return = "($1) $2-$3";
    } elsif ($phone =~ /(\d{3}).*(\d{4})/) {
	$return = "(123) $1-$2";
    }

    # Now we want to find any numbers that follow an "x" - if we find any,
    # that's the extension for this phone number, which we will add to
    # the end.  We use the \D metacharacter to match anything that is NOT
    # a digit.
    if ($phone =~ /x\D*(\d+)/i) {
	$return .= " Ext $1";
    }

    return $return;
}

