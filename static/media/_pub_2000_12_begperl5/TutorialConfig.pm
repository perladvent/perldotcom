package TutorialConfig;


sub new {
    my ($class_name) = @_;

    my ($self) = {};
    warn "We just created the variable...\n";

    bless ($self, $class_name);
    warn "and now it's a $class_name object!\n";

    $self->{'_created'} = 1;
    return $self;
}


sub read {
    my ($self, $file) = @_;
    my ($line, $section);

    open (CONFIGFILE, $file) or return 0;

    # We'll set a special property that tells what filename we just read.
    $self->{'_filename'} = $file;
    
    while ($line = <CONFIGFILE>) {

	# Are we entering a new section?
	if ($line =~ /^\[(.*)\]/) {
	    $section = $1;
	} elsif ($line =~ /^([^=]+)=(.*)/) {
	    my ($config_name, $config_val) = ($1, $2);
	    if ($section) {
		$self->{"$section.$config_name"} = $config_val;
	    } else {
		$self->{$config_name} = $config_val;
	    }
	}
    }

    close CONFIGFILE;
    return 1;
}


sub get {
    my ($self, $key) = @_;

    return $self->{$key};
}


sub set {
    my ($self, $key, $value) = @_;

    $self->{$key} = $value;
}


warn "TutorialConfig is successfully loaded!\n";
1;




