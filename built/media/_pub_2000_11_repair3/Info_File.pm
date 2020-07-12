        package Info_File;
        use FileHandle;

       	sub open_info_file {
      	    my ($class, $info_filename) = @_;
            my $fh = new FileHandle;        
      	    open($fh, $info_filename) || return;
            my $object = { FH => $fh, NAME => $info_filename };
      	    bless $object => $class;
            return unless $object->start_info_file;            
            return $object;
      	}

      	sub start_info_file {
            my ($object) = @_;
            my $fh = $object->{FH};
      	    while (<$fh>) {
              return 1 if /^\037/;
            }
      	    $object->start_next_part;
      	}

      	sub start_next_part {
            my ($object) = @_;
            my $info_filename = $object->{NAME};
      	    if ($info_filename =~ /^([^-]*)-(\d*)$/) {
      		$info_filename = $1 . '-' . ($2 + 1);
      	    } else {
      		$info_filename .= '-1';
      	    }
            my $fh = $object->{FH};
            print STDERR "SWITCHING TO $info_filename\n";
      	    return unless open($fh, $info_filename);
            $object->{NAME} = $info_filename;         # ***
      	    return $object->start_info_file;
      	}

      	sub read_next_node {
            my ($object) = @_;
            my ($fh) = $object->{FH};
      	    local $_ = <$fh>;		# Header line
      	    if (! defined $_) {
      		return unless  $object->start_next_part;      
                return $object->read_next_node;
      	    }

            my (%header, %menu);
            for my $label (qw(File Node Prev Next Up)) {
              ($header{$label}) = /$label:\s*([^,]*)/;
            }

            do { 
              $_ = <$fh>; 
              return %header if /^\037/ || ! defined $_ 
            } until /^\* Menu:/ ;
    
     	    while (<$fh>) {    
                my ($key, $ref);
      		last if /^\037/;        # end of node
      		next unless /^\* \S/;   # next unless lines is a menu item
      		if (/^\* ([^:]*)::/) {  # menu item that ends with ::
      		    $key = $ref = $1;
      		} elsif (/^\* ([^:]*):\s*([^.]*)[.]/) {
      		    ($key, $ref) = ($1, $2);
      		} else {
      		    warn "Couldn't parse menu item at line $. 
                          of file $object->{NAME}";
      		    next;
      		}
      		$menu{$key} = $ref;
      	    }

            return (%header, Menu => \%menu);
        }

1;
