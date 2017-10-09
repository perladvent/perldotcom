#! perl

# compound_interest_file.pl - the miracle of compound interest, part 2

use 5.010;

use strict;
use warnings;

# First, we'll set up the variables we want to use.
my $outfile  = 'interest.txt';    # This is the filename of our report.
my $nest_egg = 10000;             # $nest_egg is our starting amount
my $year     = 2008;              # This is the starting year for our table.
my $duration = 10;                # How many years are we saving up?
my $apr      = 9.5;               # This is our annual percentage rate.

my $report_fh = open_report( $outfile );
print_headers(   $report_fh );
interest_report( $report_fh, $nest_egg, $year, $duration, $apr );
report_footer(   $report_fh, $nest_egg, $duration, $apr );

sub open_report {
    my ($outfile) = @_;
    open my $report, '>', $outfile or die "Can't open '$outfile': $!";
    return $report;
}

sub print_headers {
    my ($report_fh) = @_;

    # Print the headers for our report.
    say $report_fh "Year\tBalance\tInterest\tNew balance";
}

sub calculate_interest {
    # Given a nest egg and an APR, how much interest do we collect?
    my ( $nest_egg, $apr ) = @_;

    return int( ( $apr / 100 ) * $nest_egg * 100 ) / 100;
}

sub interest_report {
    # Get our parameters.  Note that these variables won't clobber the
    # global variables with the same name.
    my ( $report_fh, $nest_egg, $year, $duration, $apr ) = @_;

    # Calculate interest for each year.
    for my $i ( 1 .. $duration ) {
        my $interest = calculate_interest( $nest_egg, $apr );
        my $line     =
            join "\t", $year + $i, $nest_egg, $interest, $nest_egg + $interest;

        say $report_fh $line;

        $nest_egg += $interest;
    }
}

sub report_footer {
    my ($report_fh, $nest_egg, $duration, $apr) = @_;

    say $report_fh "\n Our original assumptions:";
    say $report_fh "   Nest egg: $nest_egg";
    say $report_fh "   Number of years: $duration";
    say $report_fh "   Interest rate: $apr";
}
