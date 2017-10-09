#!/usr/bin/perl -w

use strict;

###############################################################
## Sample perl utility for converting
##   iCal data into Dot.
##   written by Robert Pratte
##   rpratte@gmail.com  
###############################################################

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  Configuration info, global variables, etc.
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##-----------------------------------------
##  The path to application data
##  typically, I keep this in a config file
##-----------------------------------------

  ## Information about our iCal files
my $cal = ();
$cal->{'srcDir'} = '/Users/'. $ENV{USER} .'/Library/Application Support/iCal/Sources/B8BDD930-2BD8-4139-84F5-554E42DDEB4A.calendar';
$cal->{'sfx'}    = 'ics';


  ## Information about our Dot files
my $dot = ();
$dot->{'destDir'} = '/Users/'. $ENV{USER} .'/Documents';
$dot->{'sfx'}     = 'dot';


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  Main
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
MAIN: {
     ## Get name of iCal file to parse 
   my $inFile = getSrcFile( $cal );

     ## read in file selected by user
   my $inData = readFile( $inFile, $cal );

     ## parse data into a nice hash structure
   my $hashData = readICS( $inData );


     ## Get file to write to 
   my $outFile = getDestFile( $inFile, $dot );

     ## Convert our hash to Dot and write to file
   writeDot( $hashData, $outFile );

     ## Close our Dot file
   close( $$outFile )
       or die "Error closing destination file: $!\n";

     ## Notify the user that we are done
   print "\nYour file, ${inFile}.". $dot->{'sfx'} .', should be in your '. $dot->{'destDir'} ." folder\n";
}



##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  Generic file functions
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sub getSrcFile {
   my $src = shift;

   ##-----------------------------------------
   ## read source directory
   ##-----------------------------------------
   opendir( SRCDIR, $src->{'srcDir'} )
       or die "Error opening source directory: $!\n";
   my @fileList = readdir( SRCDIR );
   closedir SRCDIR;


   ##-----------------------------------------
   ## choose file to convert 
   ##-----------------------------------------
   print "Here are the available input files:\n";
   foreach ( @fileList ) {
      if ( $_ =~ /.$src->{'sfx'}$/ ) {
         $_ =~ s/.$src->{'sfx'}$//;
         print "   $_ \n";
      }
   }

     ## get user choice
   print "\n Which one would you like to convert? ";
   chomp( my $srcFile = <> );
   return( $srcFile );
}


##-----------------------------------------
## import source file
##-----------------------------------------
sub readFile {
   my ( $file, $src ) = @_;

    ## read in file contents
  open( RAWFILE, $src->{'srcDir'} .'/'. $file .'.'. $src->{'sfx'} )
      or die "Error reading in source file: $!\n";
  my @rawData = <RAWFILE>;
  close( RAWFILE );

  return( \@rawData );
}


##-----------------------------------------
## open destination file
##-----------------------------------------
sub getDestFile {
  my ( $file, $dest ) = @_;

    ## Get file to write to 
  open( my $outFile, ">". $dest->{'destDir'} .'/'. $file .'.'. $dest->{'sfx'} )
      or die "Error opening new file: $!\n";

  return( $outFile );
}



##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  iCal related functions
##  typically, I would keep these in a single file 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##-----------------------------------------
## read in ics 
##-----------------------------------------
##    RFC 2446 specifies the following format for an iCalendar object:
##       VEVENT              1+
##            DTSTAMP        1
##            DTSTART        1
##            ORGANIZER      1
##            SUMMARY        1       Can be null.
##            UID            1
##            RECURRENCE-ID  0 or 1  only if referring to an instance of a
##                                   recurring calendar component.  Otherwise
##                                   it MUST NOT be present.
##            SEQUENCE       0 or 1  MUST be present if value is greater than
##                                   0, MAY be present if 0
##            ATTACH         0+
##            CATEGORIES     0 or 1  This property may contain a list of values
##            CLASS          0 or 1
##            COMMENT        0 or 1
##            CONTACT        0+
##            CREATED        0 or 1
##            DESCRIPTION    0 or 1  Can be null
##            DTEND          0 or 1  if present DURATION MUST NOT be present
##            DURATION       0 or 1  if present DTEND MUST NOT be present
##            EXDATE         0+
##            EXRULE         0+
##            GEO            0 or 1
##            LAST-MODIFIED  0 or 1
##            LOCATION       0 or 1
##            PRIORITY       0 or 1
##            RDATE          0+
##            RELATED-TO     0+
##            RESOURCES      0 or 1 This property MAY contain a list of values
##            RRULE          0+
##            STATUS         0 or 1 MAY be one of TENTATIVE/CONFIRMED/CANCELLED
##            TRANSP         0 or 1
##            URL            0 or 1
##            X-PROPERTY     0+
##       
##            ATTENDEE       0
##            REQUEST-STATUS 0
##       
##       VALARM              0+
##       VFREEBUSY           0
##       VJOURNAL            0
##       VTODO               0
##       VTIMEZONE           0+    MUST be present if any date/time refers to
##                                 a timezone
##       X-COMPONENT         0+
##-----------------------------------------
sub readICS {
   my $raw = shift;

   my ( $calHash, $eventHash ) = ();

     ## iCalendar files have CR-LF for newline
   $/ = "\x0d\x0a";

     ## create dot diagram header info
   foreach ( @$raw ) {
      chomp;

      SWITCH: {
              if ( $_ =~ /BEGIN:VEVENT/ ) {
                 ##-----------------------------------------
                 ## We have a new event, so start fresh.
                 ##-----------------------------------------
                 $eventHash = ();
                 last SWITCH; }


              if ( $_ =~ /END:VEVENT/ ) {
                 ##-----------------------------------------
                 ## We hit the event end, so store it.
                 ##-----------------------------------------
                 $calHash->{$eventHash->{'UID'}} = { 'UID'         => $eventHash->{'UID'},
                                                     'LOCATION'    => $eventHash->{'LOCATION'},
                                                     'START'       => $eventHash->{'START'},
                                                     'END'         => $eventHash->{'END'},
                                                     'SUMMARY'     => $eventHash->{'SUMMARY'},
                                                     'DESCRIPTION' => $eventHash->{'DESCRIPTION'},
                                                     'URL'         => $eventHash->{'URL'} };
                 last SWITCH; }


                 ##-----------------------------------------
                 ## since our data is in key:value format
                 ## we will split the string and grab the latter half of the array
		 ## not foolproof, but should work in general
                 ##-----------------------------------------
              if ( $_ =~ /^UID/ ) {
                 $eventHash->{'UID'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }


              if ( $_ =~ /^LOCATION/ ) {
                 $eventHash->{'LOCATION'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }


              if ( $_ =~ /^DTSTART/ ) {
                 s/^DTSTART\;//;
                 $eventHash->{'START'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }


              if ( $_ =~ /^DTEND/ ) {
                 s/^DTEND\;//;
                 $eventHash->{'END'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }

 
              if ( $_ =~ /^SUMMARY/ ) {
                 $eventHash->{'SUMMARY'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }


              if ( $_ =~ /^DESCRIPTION/ ) {
                 $eventHash->{'DESCRIPTION'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }


              if ( $_ =~ /^X-WR-CALNAME/ ) {
                 $eventHash->{'CALNAME'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }

    
              if ( $_ =~ /^X-WR-RELCALID/ ) {
                 $eventHash->{'CALID'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }


              if ( $_ =~ /^URL/ ) {
                 $eventHash->{'DESCRIPTION'} = ( split( /:/, $_ ) )[1];
                 last SWITCH; }
      } # end switch
   }    # end foreach

   return( $calHash );
}



##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##  Dot related functions
##  typically, I would keep these in a single file 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##-----------------------------------------
## write dot file
##-----------------------------------------
sub writeDot {
   my ( $raw, $file )  = @_;

   my ( $key, $tasks, @timeLine ) = ();


   ##-----------------------------------------
   ## Name our Dot graph
   ##-----------------------------------------
   if ( $raw->{'CALNAME'} ) {
      print { $$file } 'digraph "'. $raw->{'CALNAME'} ."\" {\n\n";
   } elsif ( $raw->{'CALID'} ) {
      print { $$file } 'digraph "'. $raw->{'CALID'} ."\" {\n\n";
   } else {
      print { $$file } "digraph unnamed {\n\n";
   }


   ##-----------------------------------------
   ## Some optional rendering info
   ##-----------------------------------------
   print { $$file } '   size     = "10,7";'. "\n".
                    '   compound = true;'  . "\n".
                    '   ratio    = fill;'  . "\n".
                    '   rankdir  = LR;'    . "\n\n";

 
   ##-----------------------------------------
   ## Generate our Dot data
   ##   we will wrap most data in double-quotes
   ##   since most Dot interpreters don't like spaces,
   ##   something allowed in iCal data
   ##-----------------------------------------
   foreach $key ( keys %$raw ) {
      if ( ref( $raw->{$key} ) eq 'HASH' ) {
         my $block = $raw->{$key};

           ##------------------------------
           ## graphViz doesn't like - in names
           ##------------------------------
         $block->{'UID'} =~ s/-/_/g;

           ##------------------------------
           ## produce list of all unique tasks
           ##------------------------------
         push( @{ $tasks->{$block->{'SUMMARY'}} }, '"'. $block->{'UID'} .'"' );

           ##------------------------------
           ## build record
           ##------------------------------
         my $eventBlock = '"'. $block->{'UID'} .
                          '" [ shape = record, label = "'.  $block->{'SUMMARY'} .
                           ' | <START> Start | <END> End ';

         if ( $block->{'DESCRIPTION'} ) {
            $eventBlock .= ' | '. $block->{'DESCRIPTION'};
         }
         $eventBlock .= '"];';

         print { $$file } '   '. $eventBlock ."\n\n"; 


           ##------------------------------
           ## build relations based upon time
           ##------------------------------
         push( @timeLine, '"'. $block->{'START'} .'"' );
         print { $$file } '   "'. $block->{'UID'} .'":START  -> "'. $block->{'START'} ."\"\;\n\n";

         if ( $block->{'END'} ) {
            push( @timeLine, '"'. $block->{'END'} .'"' );
            print { $$file } '   "'. $block->{'UID'} .'":END    -> "'. $block->{'END'} ."\"\;\n\n";
         }

         print { $$file } "\n\n";
      }
   }


   ##-----------------------------------------
   ## tie non-unique tasks
   ##-----------------------------------------
    print { $$file } '   // Create tasks relationships'. "\n\n";
    foreach ( keys %$tasks ) { 
       if ( @{ $tasks->{$_} } > 1 ) {
          print { $$file } '   '. join( ' -> ', @{ $tasks->{$_} } ) ."\;\n\n";  
       }
    }
    print { $$file } "\n\n";

 
   ##-----------------------------------------
   ## Render our timeline
   ##-----------------------------------------
    print { $$file } '   // Create timeline relationships'. "\n\n";
    print { $$file } '   '. join( ' -> ', sort( @timeLine ) ) ."\;\n\n";


   ##-----------------------------------------
   ## Close off dot file
   ##-----------------------------------------
    print { $$file } "}\n";
}

exit( 0 );
