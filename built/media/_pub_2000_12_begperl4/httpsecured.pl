#!/usr/local/bin/perl -w

use CGI ':standard';

$logfile = "/var/log/httpd/access_log";

print header();
print start_html( -title => "HTTP Log report" );

# Make sure that the "number" form item has a reasonable value
($number) = (param('number') =~ /(\d+)/);
if ($number < 10) {
    $number = 10;
} elsif ($number > 50) {
    $number = 50;
}

print "<P>Analyzing log file...</P>\n";

analyze($logfile);

print "<P>Done.</P><HR>\n";

report();

print end_html();


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
    for $i (param('report')) {
	if ($i eq 'url') {
	    report_section("URL requests", %url_requests);
	} elsif ($i eq 'status') {
	    report_section("Status code requests", %status_requests);
	} elsif ($i eq 'hour') {
	    report_section("Requests by hour", %hour_requests);
	} elsif ($i eq 'type') {
	    report_section("Requests by file type", %type_requests);
	}
    }
}


sub report_section {
    my ($header, %type) = @_;
    my (@type_keys);

    # Are we sorting by the KEY, or by the NUMBER of accesses?
    if (param('number') ne 'ALL') {
	@type_keys = sort { $type{$b} <=> $type{$a}; } keys %type;

	# Chop the list if we have too many results
	if ($#type_keys > $number - 1) {
	    $#type_keys = $number - 1;
	}
    } else {
	@type_keys = sort keys %type;
    }

    # Begin a HTML table
    print "<TABLE>\n";

    # Print a table row containing a header for the table
    print "<TR><TH COLSPAN=2>", $header, "</TH></TR>\n";

    # Print a table row containing the value, and the count
    for $i (@type_keys) {
	print "<TR><TD>", $i, "</TD><TD>", $type{$i}, "</TD></TR>\n";
    }

    # Finish the table
    print "</TABLE>\n";
}

