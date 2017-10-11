#!/usr/local/bin/perl -w

# compound_interest_file.pl - the miracle of compound interest, part 2

# First, we'll set up the variables we want to use.
$outfile = "interest.txt";  # This is the filename of our report.
$nest_egg = 10000;          # $nest_egg is our starting amount
$year = 2000;               # This is the starting year for our table.
$duration = 10;             # How many years are we saving up?
$apr = 9.5;                 # This is our annual percentage rate.


&open_report;
&print_headers;
&interest_report($nest_egg, $year, $duration, $apr);
&report_footer;


sub open_report {
    open (REPORT, ">$outfile") or die "Can't open report: $!";
}


sub print_headers {
    # Print the headers for our report.
    print REPORT "Year", "\t", "Balance", "\t", "Interest", "\t",
                 "New balance", "\n";
}


sub calculate_interest {
    # Given a nest egg and an APR, how much interest do we collect?
    my ($nest_egg, $apr) = @_;

    return int (($apr / 100) * $nest_egg * 100) / 100;
}


sub interest_report {
    # Get our parameters.  Note that these variables won't clobber the
    # global variables with the same name.
    my ($nest_egg, $year, $duration, $apr) = @_;

    # We have two local variables, so we'll use my to declare them here.
    my ($i, $line);

    # Calculate interest for each year.
    for $i (1 .. $duration) {
	$year++;
	$interest = &calculate_interest($nest_egg, $apr);

	$line = join("\t", $year, $nest_egg, $interest, 	     
		     $nest_egg + $interest) . "\n";

	print REPORT $line;

	$nest_egg += $interest;
    }
}


sub report_footer {
    print REPORT "\n Our original assumptions:\n";
    print REPORT "   Nest egg: $nest_egg\n";
    print REPORT "   Number of years: $duration\n";
    print REPORT "   Interest rate: $apr\n";

    close REPORT;
}

