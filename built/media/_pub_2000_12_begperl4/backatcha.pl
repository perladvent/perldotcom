#!/usr/local/bin/perl

use CGI;
$cgi = new CGI;

print $cgi->header();
print $cgi->start_html();

print "<TABLE>";

for $i ($cgi->param()) {
    print "<TR><TD>", $i, "</TD><TD>", $cgi->param($i), "</TD></TR>";
}

print "</TABLE>";
print $cgi->end_html();
