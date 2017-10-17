{
   "description" : " As it happens, no matter how much I write about Perl/Tk, there's always something left unsaid. A case in point is the topic of drag and drop, which didn't make it into our book, Mastering Perl/Tk. This article describes...",
   "slug" : "/pub/2001/12/11/perltk.html",
   "authors" : [
      "steve-lidie"
   ],
   "draft" : null,
   "date" : "2001-12-11T00:00:00-08:00",
   "categories" : "graphics",
   "title" : "A Drag-and-Drop Primer for Perl/Tk",
   "image" : null,
   "tags" : [
      "drag-drop-tk",
      "perl",
      "perl-tk"
   ],
   "thumbnail" : "/images/_pub_2001_12_11_perltk/111-dragndrop.gif"
}



As it happens, no matter how much I write about Perl/Tk, there's always something left unsaid. A case in point is the topic of drag and drop, which didn't make it into our book, *Mastering Perl/Tk*.

This article describes the Perl/Tk drag-and-drop mechanism, often referred to as DND. We'll illustrate DND operations local to a single application, where we drag items from one Canvas to another.

There are two basic types of DND operations, local (intra-application) and remote (inter-application). Local drops are fully supported, but there is no standard for remote drops. For this reason, this article describes only local DND operations. Note: Perl/Tk supports Sun, XDND, KDE, and Win32 remote DND protocols.

To write DND code you should be comfortable with these concepts:

1.  The drag source is the widget that we drag. In the case of a Canvas widget, we can arrange for an individual item to be the drag source.
2.  The drop destination is the widget upon which we drop the source widget.
3.  The DND token is a `Label` widget that tracks the cursor as it moves from the drag source to the drop destination. We can configure the DND token with a text string or an image.

![](/images/_pub_2001_12_11_perltk/drag.jpg)

This figure shows what we will end up with--one Canvas populated by various types of objects, which we can drag around the application and drop onto another Canvas. Let's now look at the code.

Here we have a rather typical Perl/Tk prologue. `Tk::DragDrop` is required if coding a program with a drag source, while `Tk::DropSite` is required for programs declaring a drop destination.

        use Tk;
        use strict;
        use Tk::DragDrop;
        use Tk::DropSite;
        use subs qw/make_bindings move_bbox move_image/;

### Global variables

A drag begins with a `<ButtonPress-1>` event, where we record the ID of the specified Canvas item in the variable `$drag_id`. `$mw` is, of course, a reference to the program's MainWindow.

        our (
             $drag_id,              # Canvas item id of drag source
             $mw,                   # Perl/Tk MainWindow reference
        );

    $mw = MainWindow->new(-background => 'green');

Define the drag source--a Canvas full of items. Here we declare that a `<B1-Motion>` event over the source Canvas signals the start of a local drag operation.

`$drag_source` is a `Tk::DragDrop` object, sometimes called a DND token. It's really a disguised `Label` widget, which we can configure in the standard fashion. For our purposes, we set the `-text` option to describe the `Canvas` item we are dragging, rather than the default text of the source widget's class name. But you can assign an image to the DND token if desired.

When performing a DND operation, notice that the DND token has a flat relief over the source, and a sunken relief over the destination.

        my $c_src = $mw->Canvas(qw/-background yellow/)->pack;

        my $drag_source = $c_src->DragDrop(
            -event     => '<B1-Motion>',
            -sitetypes => [qw/Local/],
        );

Every `Canvas` source item has a `<ButtonPress-1>` binding associated with it. The callback bound to this event serves to record the item's ID in the global variable `$drag_id`, and to configure the drag `Label`'s `-text`/ option with the item's ID and type.

        my $press = sub {
            my ($c_src, $c_src_id, $drag_source) = @_;
            $drag_id = $c_src_id;
            my $type = $c_src->type($drag_id);
            $drag_source->configure(-text => $c_src_id . " = $type");
        };
      

OK, let's populate the source Canvas with items of various types. For this demonstration, we limit the choices to ovals, rectangles, and all the GIF files in the current directory. As noted earlier, every item gets a `<ButtonPress-1>` binding.

        my ($x, $y) = (30, 30);
        foreach (<*.gif>) {

            my $id = $c_src->createImage($x, $y,
                -image => $mw->Photo(-file => $_));
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
      

Define the drop-site destination--another `Canvas`. As a source `Canvas` item is dropped here, create an identical item in the destination at the drop coordinates.

        my $c_dest = $mw->Canvas(qw/-background cyan/)->pack;
        $c_dest->DropSite(
            -droptypes   => [qw/Local/],
            -dropcommand => [\&move_items, $c_src, $c_dest],
        );
      

Build the obligatory Quit Button, and enter the main event loop.

        my $quit = $mw->Button(-text => 'Quit', -command => [$mw => 'destroy']);
        $quit->pack;

        MainLoop;
      

These subroutines are invoked when a `Canvas` source item is dropped on the destination `Canvas`. Callback "`move_items`" is invoked first, with these arguments:

>     $c_src  = source Canvas widget reference
>     $c_dest = destination Canvas widget reference
>     $sel    = selection type, here "XdndSelection"
>     $dest_x = Canvas drop site X coordinate
>     $dest_y = Canvas drop site Y coordinate
>       

The first two arguments we supplied on the `-dropcommand` option. The remaining arguments are implicitly supplied by Perl/Tk.

"`move_items`" simply branches according to the item's type, throwing an error for `Canvas` items we are not prepared to handle. Each type handler receives the preceding arguments plus the item's type.

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
      

Subroutine "`move_bbox`" handles all `Canvas` item types described by a bounding box. (For this demonstration, we only propagate the `-fill` attribute from the `Canvas` source item to the new item.) It uses the subroutine "`make_bindings`" given below to establish local bindings on the newly created destination item, so it can be dragged about the destination Canvas.

        sub move_bbox {

            my ($item_type, $c_src, $c_dest, $sel, $dest_x, $dest_y) = @_;

            my $fill = $c_src->itemcget($drag_id, -fill);
            my $method = 'create' . ucfirst $item_type;
            my $id = $c_dest->$method($dest_x, $dest_y,
                $dest_x + 40, $dest_y + 40, -fill => $fill,
            );

            make_bindings $c_dest, $id;

        } # end move_bbox
      

Subroutine "`move_image`" handles a `Canvas` image item type. It uses the "`make_bindings`" subroutine just described.

        sub move_image {

            my ($item_type, $c_src, $c_dest, $sel, $dest_x, $dest_y) = @_;

            my $image = $c_src->itemcget($drag_id, -image);
            my $id = $c_dest->createImage($dest_x, $dest_y, -image => $image);

            make_bindings $c_dest, $id;

        } # end move_image
      

"`make_bindings`" itself adds drag behavior to our newly dropped `Canvas` items, but without using the DND mechanism. The basic idea is as follows:

-   On a `<ButtonPress-1>` event, record the `Canvas` item's (x,y) coordinates in instance variables of the form `"x" . $id` and `"y" . $id`, where `$id` is the item's `Canvas` ID. This ensures that each item's position is uniquely maintained.
-   On a `<ButtonRelease-1>` event, compute an (x,y) delta from the item's original position (stored in instance variables) and the new position, and use the `Canvas` "`move`" method to relocate it.

<!-- -->

        sub make_bindings {

            my ($c_dest, $id) = @_;

            $c_dest->bind($id, '<ButtonPress-1>' => [sub {
            my ($c, $id) = @_;
            ($c_dest->{'x' . $id}, $c_dest->{'y' . $id}) =
                ($Tk::event->x, $Tk::event->y);
            }, $id]);

            $c_dest->bind($id, '$lt;ButtonRelease-1>' => [sub {
            my ($c, $id) = @_;
            my($x, $y) = ($Tk::event->x, $Tk::event->y);
            $c->move($id, $x - $c_dest->{'x' . $id}, $y - $c_dest->{'y' . $id});
            }, $id]);

        } # end make_bindings
      

The entire source code to this program is available [here](/media/_pub_2001_12_11_perltk/drag.pl), and for more information about Perl/Tk programming, check out [Mastering Perl/Tk](http://www.oreilly.com/catalog/mastperltk/).

------------------------------------------------------------------------

O'Reilly & Associates will soon release (January 2002) [Mastering Perl/Tk](http://www.oreilly.com/catalog/mastperltk/).

-   You can also look at the [Full Description](http://oreilly.com/catalog/mastperltk/desc.html) of the book.

-   For more information, or to order the book, [click here](http://www.oreilly.com/catalog/mastperltk/).


