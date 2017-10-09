#!/usr/local/bin/perl

# We will use a command line argument to determine the log filename.
$logfile = $ARGV[0];

unless ($logfile) { die "Usage: a3-httpd.pl <httpd log file>"; }

analyze($logfile);
report();

sub analyze {
    my ($logfile) = @_;

    open (LOG, "$logfile") or die "Could not open log $logfile - $!";

    while ($line = <LOG>) {
	@fields = split(/\s/, $line);

	# Make /about/ and /about/index.html the same URL.
	$fields[6] =~ s{/$}{/index.html};

	# Log successful requests by file type.  URLs without an extension
	# are assumed to be text files.
	if ($fields[8] eq '200') {
	   if ($fields[6] =~ /\.([a-z]+)$/i) {
	       $type_requests{$1}++;
	   } else {
	       $type_requests{'txt'}++;
	   }
	}

	# Log the hour of this request
	$fields[3] =~ /:(\d{2}):/;
	$hour_requests{$1}++;

	# Log the URL requested
	$url_requests{$fields[6]}++;

	# Log status code
	$status_requests{$fields[8]}++;

	# Log bytes, but only for results where byte count is non-zero
	if ($fields[9] ne "-") {
	    $bytes += $fields[9];
	}
    }

    close LOG;
}


sub report {
    print "Total bytes requested: ", $bytes, "\n";

    print "\n";

    report_section("URL requests:", %url_requests);
    report_section("Status code results:", %status_requests);
    report_section("Requests by hour:", %hour_requests);
    report_section("Requests by file type:", %type_requests);
}


sub report_section {
    my ($header, %type) = @_;

    print $header, "\n";
    for $i (sort keys %type) {
	print $i, ": ", $type{$i}, "\n";
    }

    print "\n";
}

