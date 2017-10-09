use FileHandle; autoflush STDOUT;

use Patricia;
$patty = new Patricia;


while (@p = getpwent()) {
    insert $patty $p[2], $p[0];
} 

# dtree $patty; # DEBUGGING

print "UID: ";
while (1) {
    my $number = <>;
    last unless defined $number;
    chop $number;
    my $fetched = search $patty $number; 
    if (defined $fetched) {
	print "$fetched\n";
    } else {
	print "no key for $number\n";
    } 
    print "UID: ";
} 
