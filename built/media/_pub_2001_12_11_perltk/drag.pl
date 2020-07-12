#!/usr/local/bin/perl -w
#
# Local Drag and Drop demonstration. This program allows one to drag
# items from one Canvas to another.
#
# There are two basic types of DND operations, local (intra-application)
# and remote (inter-application). Local drops are fully supported, but
# there is no standard for remote drops. For this reason, this article
# describes only local DND operations. For the record, Perl/Tk supports
# Sun, XDND, KDE and Win32 remote DND protocols. Perhaps a future
# article will discus this issue.
#
# To write DND code we need to be familiar with these concepts:
#
# 1) The drag source is the widget that we drag.  In the case of
#    a Canvas widget, we can arrange for an individual item to
#    be the drag source.
#
# 2) The drop destination is the widget upon which we drop the
#    source widget.
#
# 3) The DND token is a Label widget which tracks the cursor as
#    it moves from the drag source to the drop destination. We
#    can configure the DND token with a text string or image.

use Tk;
use strict;
use Tk::DragDrop;
use Tk::DropSite;
use subs qw/make_bindings move_bbox move_image/;

# Global variables.

our (
     $drag_id,			# Canvas item id of drag source
     $mw,			# Perl/Tk MainWindow reference
);

$mw = MainWindow->new(-background => 'green');

# The drag source - a Canvas full of items. Here we declare that a
# <B1-Motion> event over the source Canvas signals the start of a
# local drag operation.
#
# $drag_source is a Tk::DragDrop object, sometimes called a DND token.
# It's really a disguised Label widget, which we can configure in the
# standard fashion. For our purposes, we set the -text option to
# describe the Canvas item we are dragging, rather than the default
# text of the source widget's class name. But you can assign an image
# to the DND token if desired.
#
# When performing a DND operation, notice that the DND token has a
# flat relief over the source, and a sunken relief over the destination.

my $c_src = $mw->Canvas(qw/-background yellow/)->pack;

my $drag_source = $c_src->DragDrop(
    -event     => '<B1-Motion>',
    -sitetypes => [qw/Local/],
);

# Every Canvas source item has a <ButtonPress-1> binding associated
# with it. The callback bound to this event serves to record the item's
# id in the global variable $drag_id, and to configure the drag Label's
# -text option with the item's id and type.

my $press = sub {
    my ($c_src, $c_src_id, $drag_source) = @_;
    $drag_id = $c_src_id;
    my $type = $c_src->type($drag_id);
    $drag_source->configure(-text => $c_src_id . " = $type");
};

# Okay, let's populate the source Canvas with items of various types.
# For this demonstration, we limit the choices to images, ovals and
# rectangles. As noted earlier, every item gets a <ButtonPress-1>
# binding.

my ($x, $y) = (30, 30);
foreach (<*.gif>) {

    my $id = $c_src->createImage($x, $y, -image => $mw->Photo(-file => $_));
    $x += 80;
    $c_src->bind($id, '<ButtonPress-1>' => [$press, $id, $drag_source]);
    
} # forend

$x = 30;
$y = 80;

foreach (qw/oval rectangle/) {

    my $method = 'create' . ucfirst $_;
    my $id = $c_src->$method($x, $y, $x + 40, $y + 40, -fill => 'orange');
    $x += 80;
    $c_src->bind($id, '<ButtonPress-1>' => [$press, $id, $drag_source]);
    
} # forend

# The drop site destination - another Canvas. As a source Canvas item
# is dropped here, create an identical item in the destination at the
# drop coordinates.

my $c_dest = $mw->Canvas(qw/-background cyan/)->pack;
$c_dest->DropSite(
    -droptypes   => [qw/Local/],
    -dropcommand => [\&move_items, $c_src, $c_dest],
);

# Build the obligatory Quit Button, and enter the main event loop.

my $quit = $mw->Button(-text => 'Quit', -command => [$mw => 'destroy']);
$quit->pack;

MainLoop;

# These subroutines are invoked when a Canvas source item is dropped on
# the destination Canvas. Callback *move_items* is invoked first, with
# these arguments:
#
# $c_src  = source Canvas widget reference
# $c_dest = destiantion Canvas widget reference
# $sel    = selection type, here "XdndSelection"
# $dest_x = Canvas drop site X coordinate
# $dest_y = Canvas drop site Y coordinate
#
# The first two arguments we supplied on the -dropcommand option. The
# remaining arguments are implicitly supplied by Perl/Tk.
#
# *move_items* simply branches according to the item's type, throwing
# an error for Canvas items we are not prepared to handle. Each type
# handler recieves the preceeding arguments plus the item's type.

sub move_items {

    $_ = $_[0]->type($drag_id);
    return unless defined $_;

  CASE: {

    /image/      and do {move_image $_, @_; last CASE};
    /oval/       and do {move_bbox  $_, @_; last CASE};
    /rectangle/  and do {move_bbox  $_, @_; last CASE};
    warn "Unknown Canvas item type '$_'.";

  }# casend

} # end move_items

# Subroutine *move_bbox* handles all Canvas item types described
# by a bounding box. For this demonstration we only proagate the
# -fill attribute from the Canvas source item to the new item.
#
# Subroutine *make_bindings* establishes local bindings on the
# newly created destination item so it can be dragged about the
# destination Canvas.

sub move_bbox {

    my ($item_type, $c_src, $c_dest, $sel, $dest_x, $dest_y) = @_;

    my $fill = $c_src->itemcget($drag_id, -fill);
    my $method = 'create' . ucfirst $item_type;
    my $id = $c_dest->$method($dest_x, $dest_y,
        $dest_x + 40, $dest_y + 40, -fill => $fill,
    );

    make_bindings $c_dest, $id;

} # end move_bbox

# Subroutine *move_image* handles a Canvas image item type.
#
# Subroutine *make_bindings* establishes local bindings as
# previously described.

sub move_image {

    my ($item_type, $c_src, $c_dest, $sel, $dest_x, $dest_y) = @_;

    my $image = $c_src->itemcget($drag_id, -image);
    my $id = $c_dest->createImage($dest_x, $dest_y, -image => $image);

    make_bindings $c_dest, $id;

} # end move_image

# Subroutine *make_bindings* adds drag behavior to our newly dropped
# Canvas items, but without using the DND mechanism. The basic idea
# goes as follows:
#
# On a <ButtonPress-1> event, record the Canvas item's (x,y)
# coordinates in instance variables of the form "x" . $id and
# "y" . $id, where $id is the item's Canvas id.  This ensures
# that each item's position is uniquely maintained.
#
# On a <ButtonRelease-1> event, compute an (x,y) delta from the
# item's orignal position (stored in instance variables) and the
# new postion, and use the Canvas *move* method to relocate it.

sub make_bindings {

    my ($c_dest, $id) = @_;

    $c_dest->bind($id, '<ButtonPress-1>' => [sub {
	my ($c, $id) = @_;
	($c_dest->{'x' . $id}, $c_dest->{'y' . $id}) =
	    ($Tk::event->x, $Tk::event->y);
    }, $id]);

    $c_dest->bind($id, '<ButtonRelease-1>' => [sub {
	my ($c, $id) = @_;
	my($x, $y) = ($Tk::event->x, $Tk::event->y);
	$c->move($id, $x - $c_dest->{'x' . $id}, $y - $c_dest->{'y' . $id});
    }, $id]);

} # end make_bindings
