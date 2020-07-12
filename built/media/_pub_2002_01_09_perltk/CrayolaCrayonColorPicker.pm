$Tk::CrayolaCrayonColorPicker::VERSION = '1.0';

package Tk::CrayolaCrayonColorPicker;

use Tk::widgets qw/Balloon/;
use base        qw/Tk::Derived Tk::DialogBox/;
use subs        qw/pick_color/;

use strict;

Construct Tk::Widget 'CrayolaCrayonColorPicker';

# Class global variables.

our (
     $crayons,                  # Photo of a bunch of crayons
     $cray_w,                   # Photo width
     $cray_h,                   # Photo height
);

# Class initializer.

sub ClassInit {

    # ClassInit is called once per MainWindow, and serves to 
    # perform tasks for the class as a whole.  Here we create
    # a Photo object used by all instances of the class.

    my ($class, $mw) = @_;

    $crayons = $mw->Photo(-file => 'crayons.gif', -format => 'gif');
    ($cray_w, $cray_h) = ($crayons->width, $crayons->height);

    $class->SUPER::ClassInit($mw);

} # end ClassInit

# Instance initializer.

sub Populate {

    # Create a CrayolaCrayonColorPicker instance, depicted in
    # *** Figure 1 ***. This widget is a subclass of Tk::DialogBox,
    # with an overridden Show() method that doesn't do a grab. We
    # do this so that Balloon help will work - Balloons fail with
    # a local or global grab in effect.
    #
    # The widget consists of a Canvas with a Photo of a box of
    # Crayola crayons.  Clicking anywhere on the Photo invokes a
    # callback that fetches the RGB components of the pixel under 
    # the click.
    #
    # Additionally, transparent, trapezoidal, Canvas polygons have
    # been superimposed over the tips of each crayon, and each of
    # these items has a ballon help message associated with it. The
    # message indicates the crayon's Crayola color.

    my ($self, $args) = @_;

    # Since we are a DialogBox, setup a default Button.

    $args->{'-buttons'} = ['Cancel'] unless defined $args->{'-buttons'};
    $self->SUPER::Populate($args);

    $self->withdraw;

    # Create the Canvas with its Photo, and store the image id as an
    # instance variable.

    $self->{can} = $self->Canvas(
        -width  => $cray_w,
        -height => $cray_h,
    )->pack;
    $self->{iid} = $self->{can}->createImage(0, 0,
        -anchor => 'nw',
        -image  => $crayons,
    );

    # A button click fetches and returns an RGB triplet.

    $self->{can}->CanvasBind('<ButtonRelease-1>' => [\&pick_color, $self]);

    # Create the 64 polygon items. Create the Ballon help widget and
    # attach a Balloon message to all of the polygon items.
    
    $self->{col} = {};	        # anonymous hash indexes colors by id
    $self->make_balloon_items;

    $self->{bal} = $self->Balloon;
    $self->{bal}->attach($self->{can},
        -balloonposition => 'mouse', 
        -msg             => $self->{col},
    );

} # end Populate

# Class private methods;

sub make_balloon_items {

    # The 64-crayon Crayola box in divided into 4 sections of 16 crayons
    # each.  Each section contains two rows of eight crayons.  These
    # subroutine calls create each section, starting with the section's
    # background row, followed by the section's foreground row.
    #
    # We create the polygons items from back to front so that the
    # Canvas stacking order is back to front.  This ensures that the Balloon
    # help of foreground polygons items takes precedence over background
    # items.

    my ($self) = @_;

    # 16 northwest crayons.

    $self->make_poly(132,   8, 'red');
    $self->make_poly(150,  18, 'white');
    $self->make_poly(170,  20, 'carnation pink');
    $self->make_poly(194,  22, 'red orange');
    $self->make_poly(216,  31, 'yellow');
    $self->make_poly(235,  36, 'yellow green');
    $self->make_poly(258,  43, 'blue green');
    $self->make_poly(282,  48, 'green');

    $self->make_poly(113,  19, 'yellow orange');
    $self->make_poly(133,  27, 'violet');
    $self->make_poly(152,  34, 'black');
    $self->make_poly(172,  40, 'blue');
    $self->make_poly(192,  45, 'brown');
    $self->make_poly(213,  53, 'blue violet');
    $self->make_poly(233,  55, 'orange');
    $self->make_poly(255,  61, 'red violet');

    # 16 northeast crayons.

    $self->make_poly(306,  61, 'gray');
    $self->make_poly(328,  63, 'green yellow');
    $self->make_poly(351,  68, 'apricot');
    $self->make_poly(375,  75, 'violet red');
    $self->make_poly(400,  83, 'cadet blue');
    $self->make_poly(422,  89, 'tan');
    $self->make_poly(447,  96, 'wisteria');
    $self->make_poly(479, 106, 'timber wolf');

    $self->make_poly(288,  70, 'chestnut');
    $self->make_poly(308,  78, 'dandelion');
    $self->make_poly(332,  89, 'ceruleon');
    $self->make_poly(354,  92, 'scarlet');
    $self->make_poly(379,  98, 'melon');
    $self->make_poly(404, 106, 'sky blue');
    $self->make_poly(428, 109, 'peach');
    $self->make_poly(462, 116, 'indigo');

    # 16 southwest crayons.

    $self->make_poly(107,  97, 'brick red');
    $self->make_poly(124, 107, 'robin\'s egg blue');
    $self->make_poly(144, 111, 'forest green');
    $self->make_poly(164, 115, 'periwinkle');
    $self->make_poly(186, 126, 'tickle me pink');
    $self->make_poly(206, 131, 'magenta');
    $self->make_poly(227, 138, 'burnt orange');
    $self->make_poly(248, 149, 'plum');

    $self->make_poly( 88, 108, 'orchid');
    $self->make_poly(106, 120, 'bittersweet');
    $self->make_poly(126, 134, 'asparagus');
    $self->make_poly(145, 138, 'wild strawberry');
    $self->make_poly(164, 144, 'silver');
    $self->make_poly(186, 153, 'gold');
    $self->make_poly(207, 158, 'pacific blue');
    $self->make_poly(228, 163, 'turquoise blue');

    # 16 southeast crayons.

    $self->make_poly(270, 157, 'tumbleweed');
    $self->make_poly(292, 163, 'mohagany');
    $self->make_poly(317, 167, 'sepia');
    $self->make_poly(340, 177, 'cornflower');
    $self->make_poly(363, 182, 'granny smith apple');
    $self->make_poly(389, 190, 'macaroni and cheese');
    $self->make_poly(417, 197, 'mauvelous');
    $self->make_poly(443, 204, 'purple mountain\'s majesty');

    $self->make_poly(250, 171, 'lavender');
    $self->make_poly(273, 181, 'burnt sienna');
    $self->make_poly(296, 191, 'salmon');
    $self->make_poly(319, 199, 'sea green');
    $self->make_poly(343, 204, 'olive green');
    $self->make_poly(368, 211, 'spring green');
    $self->make_poly(394, 215, 'goldenrod');
    $self->make_poly(420, 219, 'raw sienna');

} # end make_balloon_items

sub make_poly {

    # Given the coordinates of the point of a crayon, create a transparent
    # polygon over the tip so we can attach a Balloon message to it.
    # The message is the crayon's color, and is stored in the hash
    # pointed to by $self->{col}, indexed by polygon Canvas id.
    #
    # The transparent stipple is very important, as it allows Balloon
    # events to be seen.  The fill color in irrelevant, we just need 
    # something to fill the polygon items so events are registered.
    #
    # If we remove the stipple, the polygon items covering the crayon tips
    # become visible, as shown in *** Figure 2 ***.

    my ($self, $x, $y, $color) = @_;

    my $id = $self->{can}->createPolygon(
        $x-3, $y, $x+3, $y, $x+11, $y+38, $x-11, $y+38, $x-3, $y,
        -fill    => 'yellow',
        -stipple => 'transparent',
    );

    $self->{col}->{$id} = $color;

} # end make_poly

sub pick_color {

    # Since we're a subclass of Tk::DialogBox, the Show() method is
    # waiting for the widget instance variable $self->{'selected_button'}
    # to change.  When the user clicks on the Crayola image, we fetch the
    # pixel's RGB values and update the instance variable, thus unblocking
    # the waitVariable() and returning the RGB data to the user.
    #
    # In case you're interested, early-on in the coding I determined the
    # coorinates of each crayon's point by printing $x and $y in this
    # callback. 

    my ($canvas, $self) = @_;
    my ($x, $y) = ($Tk::event->x, $Tk::event->y);
    my $i = $canvas->itemcget($self->{iid}, -image);
    $self->{'selected_button'} = $i->get($x, $y);

} # end pick_color

# Public methods.

sub Show {

    # We can't use the standard DialogBox Show() method because the
    # grab interfers with Balloon help.  So we roll our own, forgoing
    # the modal approach.  Control passes from waitVariable() in one
    # of two ways: 1) a color is selected (see pick_color() above),
    # or, 2), the Cancel button is activated.

    my ($self) = @_;
    $self->Popup;
    $self->waitVariable(\$self->{'selected_button'});
    $self->withdraw;
    return $self->{'selected_button'};

} # end Show

1;

__END__


=head1 NAME

Tk::CrayolaCrayonColorPicker - choose a color from a box of 64 Crayola crayons.

=head1 SYNOPSIS

S<    >I<$cccp> = I<$parent>-E<gt>B<CrayolaCrayonColorPicker>(I<-opt> =E<gt> I<val>, ... );

=head1 DESCRIPTION

Tk::CrayolaCrayonColorPicker is a DialogBox derived widget that allows
a user to select a color from a Photo of a box of Crayola crayons.
Nominally, one positions the cursor over the desired crayon and clicks
button-1, whereupon the RGB values of the pixel under the cursor are
returned.  However, in reality, one can click anywhere over the Photo.

Balloon help is provided, so that if the cursor lingers over a crayon,
a ballon pops up, displaying the crayon's actual color - for instance,
"robin's egg blue".

Because Tk::CrayolaCrayonColorPicker is a subclass of Tk::DialogBox, the
widget can have one or more buttons, with the default being a single Cancel
button. This functionality is provided automatically by the superclass,
Tk::DialogBox.

This widget also overrides the Tk::DialogBox::Show method with one of its
own.  We do this because, by definition, dialogs are modal, which means
they perform a grab.  Unfortunately, balloon help does not work with a
grab in effect, so Tk::CrayolaCrayonColorPicker::Show deiconifies the
color picker window itself, waits for a color selection or Cancel, and
then hides the window.  All this without a grab.

The return value from the Show() method is either a reference to an array
of three integers, the red, green and blue pixel triplet, or a string
indicating which Dialog button was clicked.

=head1 OPTIONS

Tk::CrayolaCrayonColorPicker supports the option/value pairs defined by
Tk::DialogBox.

=head1 METHODS

=head2 $cccp->Show;

Display the CrayolaCrayonColorPicker widget.

=head1 ADVERTISED WIDGETS

Component subwidgets can be accessed via the B<Subwidget> method.
This mega widget has no advertised subwidgets.

=head1 EXAMPLE

    my $cccp = $mw->CrayolaCrayonColorPicker(-title => 'Crayon Picker');

    my $color = $cccp->Show;

    if ( ref($color) =~ /ARRAY/ ) {
        my ($r, $g, $b) = @$color;
        print "r/g/b=$r/$g/$b!\n";
    } else {
        print "no color selected, response=$color!\n";
    }

=head1 AUTHOR

Stephen.O.Lidie@Lehigh.EDU

Copyright (C) 2001 - 2002, Steve Lidie. All rights reserved.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 KEYWORDS

CrayolaCrayonColorPicker, Canvas, Dialog, DialogBox

=cut
