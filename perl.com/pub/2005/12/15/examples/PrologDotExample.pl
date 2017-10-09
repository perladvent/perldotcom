#!/usr/bin/perl -w

use strict;
use AI::Prolog;

use constant { modInit   => 0,
               modTag    => 1,
               modValue  => 2 };

###############################################################
## Sample Perl example that reads in rules as valid Prolog
##   code and data as Dot relations.  
##   written by Robert Pratte
##   rpratte@gmail.com
###############################################################

MAIN: {
   ##-------------------------------------------
   ##  Read in Prolog logic and 
   ##  start up the Prolog instance 
   ##-------------------------------------------
   open( PROLOGFILE, 'ancestry.pl' ) or die "$! \n";
   local $/ = undef;
   my $prologDB = AI::Prolog->new( <PROLOGFILE> );
   close( PROLOGFILE );


   ##-------------------------------------------
   ##  Read in Dot file containing relations 
   ##  and feed it into the Prolog instance 
   ##-------------------------------------------
   open( DOTFILE, 'family_tree.dot' ) or die "$! \n";
   my $parsedDigraph = parse_dotFile( <DOTFILE> );
   close( DOTFILE );

   foreach ( @$parsedDigraph ) {
      $prologDB->do("assert($_).");
   }


   ##-------------------------------------------
   ##  Run the query 
   ##-------------------------------------------
   $prologDB->query( "is_cousin(joe, sara)." );
   while (my $results = $prologDB->results) { print "@$results\n"; }
}  ## end MAIN


sub parse_dotFile {
   ##----------------------------------------
   ##  Examine data a word at a time 
   ##----------------------------------------
   my @dotData = split( /\s+/, shift() );

   my ( $familyBlock, $personName, @prologQry ) = ();
   my $personModPosition                        = modInit;
   my $relationship                             = 'parent';

   for ( my $idx = 3; $idx < @dotData; $idx++ ) {
      chomp( $dotData[$idx] );

      SWITCH: {
         if ( $dotData[ $idx ] =~ /[{}=\]]/ ) {        ## ignore
            last SWITCH; }

         if ( $dotData[ $idx ] eq '[' ) {              ## begin adding attributes
            $personModPosition = modTag;
            last SWITCH; }
   
         if ( $dotData[ $idx ] eq '->' ) {             ## switch from parents to children
            $relationship = 'child';
            last SWITCH; }

         if ( $dotData[ $idx ] =~ /\;/ ) {             ## end of this block
           ##-----------------------------------------
           ##  Generate is_parent rules for Prolog 
           ##-----------------------------------------
            foreach my $parentInBlock ( @{ $familyBlock->{ parent } } ) {
               foreach my $childInBlock ( @{ $familyBlock->{ child } } ) {
                  push( @prologQry, "is_parent(${parentInBlock}, ${childInBlock})" );
               }
            }
            $familyBlock = ();
            $relationship = 'parent';
            last SWITCH; }

         else {                                        ## we have a noun, need to set something
            if ( $personModPosition == modTag ) {         ## we have a modifier tag, next is the value
               $personModPosition = modValue;
               last SWITCH;
            } elsif ( $personModPosition == modValue ) {
                 ##--------------------------------------
                 ##  Set modifier value and reset
                 ##  We currently assume it is color
                 ##--------------------------------------
               if ( $dotData[ $idx ] eq 'blue' ) {
                  push( @prologQry, "is_male(${personName})" ); 
               } else {
                  push( @prologQry, "is_female(${personName})" ); 
               }
               $personModPosition = modInit;
               $personName        = ();
               last SWITCH;
            } else {
                 ##--------------------------------------
                 ##  Grab the name and id as parent or child
                 ##--------------------------------------
               $personName = $dotData[ $idx ];
               push( @{ $familyBlock->{ $relationship } }, $personName );
            }
         }  ## end if/then/else for $dotData[ $idx ]
      }  ## end SWITCH 
   }  ## end for 

   return( \@prologQry );
}  ## end parse_dotFile 




