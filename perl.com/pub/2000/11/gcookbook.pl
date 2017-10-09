#!/usr/bin/perl -w

use strict;
use Gnome;
use Gtk::HandyCList;

my $NAME    = 'gCookBook';
my $VERSION = '0.1'; 

my @cookbook = (
    [ "Frog soup", "29/08/99", "12", "Put frog in water. Slowly raise water temperature until frog is cooked."],
    [ "Chicken scratchings", "12/12/99", "40", "Remove fat from chicken, and fry under a medium grill"],
    [ "Pork with beansprouts in a garlic butter sauce and a really really long name that we have to scroll to see",
      "1/1/99", 30, "Pour boiling water into packet and stir"],
    [ "Eggy bread", "10/10/10", 3, "Fry bread. Fry eggs. Combine."]
);

init Gnome $NAME;

my $app = new Gnome::App $NAME, $NAME;

signal_connect $app 'delete_event', sub { Gtk->main_quit; return 0 };

$app->create_menus(
		   {
		    type => 'subtree',
		    label => '_File',
		    subtree => [
				{ 
				 type => 'item',
				 label => '_New',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_New'
				},
				{
				 type => 'item',
				 label => '_Open...',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Open'
				},
				{
				 type => 'item',
				 label => '_Save',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Save'
				},
				{
				 type => 'item',
				 label => 'Save _As...',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Save As'
				},
				{
				 type => 'separator'
				},
				{
				 type => 'item',
				 label => 'E_xit',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Quit',
				 callback => sub { Gtk->main_quit; return 0 }
				}
			       ]
		   },
		   { 
		    type => 'subtree',
		    label => '_Edit',
		    subtree => [
				{
				 type => 'item',
				 label => 'C_ut',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Cut',
				},
				{
				 type => 'item',
				 label => '_Copy',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Copy'
				},
				{
				 type => 'item',
				 label => '_Paste',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Paste'
				}
			       ]
		   },
		   {
		    type => 'subtree',
		    label => '_Settings',
		    subtree => [
				{
				 type => 'item',
				 label => '_Preferences...',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_Preferences',
				 callback => \&show_prefs
				}
			       ]
		   },
		   {
		    type   => 'subtree',
		    label  => '_Help',
		    subtree => [
				{type => 'item', 
				 label => '_About...',
				 pixmap_type => 'stock',
				 pixmap_info => 'Menu_About',
				 callback => \&about_box
				}
				
			       ]
		   }
		  );


$app->create_toolbar(
		     {
		      type       => 'item',
		      label      => 'Cook',
		      pixmap_type => 'stock',
		      pixmap_info => 'Search',
		      hint       => 'Find a recipe by ingedients'
		     },
		     {
		      type       => 'item',
		      label      => 'Add',
		      pixmap_type => 'stock',
		      pixmap_info => 'Add',
		      hint       => 'Add a new recipe'
		     },
		     {
		      type       => 'item',
		      label      => 'Open...', 
		      pixmap_type => 'stock',
		      pixmap_info => 'Open',
		      hint       => "Open a recipe book"
		     },
		     {
		      type       => 'item',
		      label      => 'Save', 
		      pixmap_type => 'stock',
		      pixmap_info => 'Save',
		      hint       => "Save this recipe book"
		     },
		     { 
		      type       => 'item',
		      label      => 'Exit',
		      pixmap_type => 'stock',
		      pixmap_info => 'Quit',
		      hint       => "Leave $NAME",
		      callback    => sub { Gtk->main_quit;}
		     }
		    );

$app->set_default_size(600,400);

my $scrolled_window = new Gtk::ScrolledWindow( undef, undef );
$scrolled_window->set_policy( 'automatic', 'always' );

my $list = new Gtk::HandyCList qw(Name Date Time Recipe);
$list->hide("Recipe");
$list->sizes(350,150,100);
$list->sortfuncs("alpha", \&sort_date, "number");
$list->set_shadow_type('out');
$list->data(@cookbook);
$scrolled_window->add($list);
$list->signal_connect( "select_row", \&display_recipe);
$app->set_contents($scrolled_window);

# Now the main list
my $bar = new Gnome::AppBar 0,1,"user" ;
$bar->set_status("");
$app->set_statusbar( $bar );

show_all $app;

main Gtk;

sub about_box {
  my $about = new Gnome::About $NAME, $VERSION,
  "(C) Simon Cozens, 2000", ["Simon Cozens"], 
  "This program is released under the same terms as Perl itself";
  show $about;
}


sub display_recipe { 
  my ($clist, $row, $column, $mouse_event) = @_;
  return unless $mouse_event->{type} eq "2button_press";

  my %recipe = %{($clist->data)[$row]};
  my $recipe_str = $recipe{Name}."\n";
  $recipe_str .= "-" x length($recipe{Name})."\n\n";
  $recipe_str .= "Cooking time : $recipe{Time}\n";
  $recipe_str .= "Date created : $recipe{Date}\n\n";
  $recipe_str .= $recipe{Recipe};

  my $db = new Gnome::Dialog($recipe{Name});
  my $gl = new Gnome::Less;

  my $button = new Gtk::Button( "Close" );
  $button->signal_connect( "clicked", sub { $db->destroy } );
  $db->action_area->pack_start( $button, 1, 1, 0 );
  $db->vbox->pack_start($gl, 1, 1, 0);
  $gl->show_string($recipe_str);
  show_all $db;
}

sub sort_date {
  my ($ad, $am, $ay) = ($_[0] =~ m|(\d+)/(\d+)/(\d+)|);
  my ($bd, $bm, $by) = ($_[1] =~ m|(\d+)/(\d+)/(\d+)|);
  return $ay <=> $by || $am <=> $bm || $ad <=> $bd;
}
