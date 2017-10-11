
# Read next node into global variables.  Assumes that file pointer is
# positioned at the header line that starts a node.  Leaves file
# pointer positioned at header line of next node.
# Programmer: note that nodes are separated by a "\n\037\n" sequence.
# Reutrn true on success, false on failure
sub read_next_node {
    undef %info_menu;
    $_ = <INFO>;		# Header line
    if (eof(INFO)) {
	return &start_next_part && &read_next_node;
    }

    ($info_file) = /File:\s*([^,]*)/;
    ($info_node) = /Node:\s*([^,]*)/;
    ($info_prev) = /Prev:\s*([^,]*)/;
    ($info_next) = /Next:\s*([^,]*)/;
    ($info_up)   = /Up:\s*([^,]*)/;

    $_ = <INFO> until /^(\* Menu:|\037)/ || eof(INFO);
    if (eof(INFO)) {
	return &start_next_part;
    } elsif (/^\037/) { 
	return 1;		# end of node, so return success.
    }

    # read menu
    local($key, $ref);
    while (<INFO>) {    
	return 1 if /^\037/;    # end of node, menu is finished, success.
	next unless /^\* \S/;   # next unless lines is a menu item
	if (/^\* ([^:]*)::/) {
	    $key = $ref = $1;
	} elsif (/^\* ([^:]*):\s*([^.]*)[.]/) {
	    ($key, $ref) = ($1, $2);
	} else {
	    print STDERR "Couldn't parse menu item\n\t$_";
	    next;
	}
	$info_menu{$key} = $ref;
    }
    # end-of-file also terminates the node successfully.
    # start up the next file before continuing.
    &start_next_part;
    return 1;
}
	
# Discard commentary before first node of info file
sub start_info_file {
    $_ = <INFO> until (/^\037/ || eof(INFO));
    return &start_next_part if (eof(INFO)) ;
    return 1;
}

# Look for next part of multi-part info file.  
# Return 0 (normal failure) if it isn't there---that just means
# we ran out of parts.  die on some other kind of failure.
sub start_next_part {
    local($path, $basename, $ext);
    if ($info_filename =~ /\//) {
	($path, $basename) = ( $info_filename =~ /^(.*)\/(.*)$/ );
    } else {
	$basename = $info_filename;
	$path = "";
    }
    if ($basename =~ /-\d*$/) {
	($basename, $ext) = ($basename =~ /^([^-]*)-(\d*)$/);
    } else {
	$ext = 0;
    }
    $ext++;
    $info_filename = "$path/$basename-$ext";
    close(INFO);
    if (! (open(INFO, "$info_filename")) ) {
	if ($! eq "No such file or directory") {
	    return 0;
	} else {
	    die "Couldn't open $info_filename: $!";
	}
    }
    return &start_info_file;
}

sub open_info_file {
    ($info_filename) = @_;
    (open(INFO, "$info_filename")) || die "Couldn't open $info_filename: $!";
    return &start_info_file;
}

1;
