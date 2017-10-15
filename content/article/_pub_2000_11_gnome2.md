{
   "thumbnail" : null,
   "tags" : [],
   "image" : null,
   "title" : "Programming GNOME Applications with Perl - Part 2",
   "categories" : "apps",
   "date" : "2000-11-28T00:00:00-08:00",
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : "Programming GNOME Applications with Perl, Part Two -> Table of Contents The Cookbook Application The Main Screen Columned Lists Displaying Recipes Where We Are, And Where We're Going Notes on the Last Article Last month's article examined how to create...",
   "slug" : "/pub/2000/11/gnome2.html"
}



<span id="__index__"></span>

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td>Table of Contents</td>
</tr>
<tr class="even">
<td><p>•<a href="#the%20cookbook%20application">The Cookbook Application</a><br />
•<a href="#the%20main%20screen">The Main Screen</a><br />
•<a href="#columned%20lists">Columned Lists</a><br />
•<a href="#displaying%20recipes">Displaying Recipes</a><br />
•<a href="#where%20we%20are,%20and%20where%20we&#39;re%20going">Where We Are, And Where We're Going</a><br />
•<a href="#notes%20on%20the%20last%20article">Notes on the Last Article</a><br />
</p></td>
</tr>
</tbody>
</table>

Last month's article examined how to create a simple \`\`Hello World'' application using Gtk+ and GNOME. This month, we'll build a more sophisticated application - one to store and retrieve recipes.

### <span id="the cookbook application">The Cookbook Application</span>

Before we write a single line of code, let's see how we're going to design this. First, we'll look at the user interface, and then see what that means for our program design.

When designing user interfaces, we need to consider what provides users with the most useful and intuitive view of their data, without overcrowding them. What do we need to be able to get at easily when we're using the application? There are two parts to this question: actions that we can perform, and data we can see.

In terms of the data, I decided that the best way to organize the available recipes was as a list, just like the table of contents in a recipe book; scroll up and down the list to see the recipe titles, and then click on one title to display the whole recipe. We could also display some useful information next to each title. I decided that the most useful things to know would be the cooking time and the date that the recipe was added.

Now we can look at the actions that will be performed - these will be turned into the toolbar buttons. One of the most useful features I wanted was the ability to give the program a list of ingredients that I have and have it tell me things I could cook with them. I also wanted to be able to maintain several different cookbooks, so \`\`Save'' and \`\`Open'' were natural choices. Of course, you need to be able to add new recipes, so an \`\`Add'' button would be useful, too. Note that I didn't want a \`\`Delete'' button - deleting a recipe is something that'll probably happen rarely, and even then, you don't want to make it **too** easy to do. Finally, you need to be able to exit.

That's the interface for the main screen, and this is what it would look like:

<img src="/images/_pub_2000_11_gnome2/gnome-main1.jpg" width="450" />
Now we can think about the data we need to store. We'll need to store recipes with their titles, dates and cooking times. If we want to search by ingredient, we should also store what ingredients each recipe needs. It would also be handy to have a complete list of all the ingredients we know about, and we'll also have some user configuration settings.

Initially, I considered putting the recipes in an SQL database, but decided against it for two reasons: first, connecting recipes to ingredients was unnecessarily complicated, and the whole thing seemed a little overkill, and second, GNOME applications traditionally store all their data in XML files so that data can be easily passed between apps. In the end, I decided to store the configuration settings plus the list of ingredients we know about in a single XML file, and have the recipe book in a separate file.

### <span id="the main screen">The Main Screen</span>

Now that we know what the interface is going to look like for the main screen, we can start coding it. We'll start with the menu items and the toolbar, just like before.

            #!/usr/bin/perl -w
            use strict;
            use Gnome;

            my $NAME    = 'gCookBook';
            my $VERSION = '0.1';

            init Gnome $NAME;

            my $app = new Gnome::App $NAME, $NAME;
            
            signal_connect $app 'delete_event', 
              sub { Gtk->main_quit; return 0 };

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
                type     => 'item',
                label    => 'Cook',
                pixmap_type => 'stock',
                pixmap_info => 'Search',
                hint     => 'Find a recipe by ingedients'
               },
               {
                type     => 'item',
                label    => 'Add',
                pixmap_type => 'stock',
                pixmap_info => 'Add',
                hint     => 'Add a new recipe'
               },
               {
                type     => 'item',
                label    => 'Open...', 
                pixmap_type => 'stock',
                pixmap_info => 'Open',
                hint     => "Open a recipe book"
               },
               {
                type     => 'item',
                label    => 'Save', 
                pixmap_type => 'stock',
                pixmap_info => 'Save',
                hint     => "Save this recipe book"
               },
               { 
                type     => 'item',
                label    => 'Exit',
                pixmap_type => 'stock',
                pixmap_info => 'Quit',
                hint     => "Leave $NAME",
                callback  => sub { Gtk->main_quit;}
               }
              );

        $app->set_default_size(600,400);

        my $bar = new Gnome::AppBar 0,1,"user" ;
        $bar->set_status("");
        $app->set_statusbar( $bar );

        show_all $app;

        main Gtk;

        sub about_box {
          my $about = new Gnome::About $NAME, $VERSION,
          "(C) Simon Cozens, 2000", ["Simon Cozens"], 
          "This program is released under the 
              same terms as Perl itself";
          show $about;
          }

### <span id="columned lists">Columned Lists</span>

Next, we have to show the list of recipes. This is usually done with a `CList`, or \`\`columned list,'' widget. However, the standard Gtk `CList` widget is a little unfriendly to deal with: You can only put data into it, and you can't find out what is in the list, so you have to maintain a separate array containing the data; columned lists usually re-sort themselves when a column title is clicked on, but the programmer has to handle this case himself; data has to be referenced by column number, not by column name; and so on.

Since I realized this was going to be unpleasant every time I wanted a columned list, I wrote a module called `Gtk::HandyCList` that encapsulates all these features. (You'll need to download that module from CPAN if you want to try this. Make sure you get version 0.02, since we use the `hide` method down below, which is new in that version.)

To add it to our program, we first need data to display! Let's create a dummy array of data, like this:

            my @cookbook = (
                    [ "Frog soup", "29/08/99", "12"],
                    [ "Chicken scratchings", "12/12/99", "40"],
                    [ "Pork with beansprouts in a garlic
                        butter sauce and a really really long name
                        that we have to scroll to see",
                      "1/1/99", 30],
                    [ "Eggy bread", "10/10/10", 3]
                   );

Now we need to load the module itself, so:

        use Gtk::HandyCList;

Because we want this list to be scrollable, we put it inside a different widget that handles scroll bars - a `Gtk::ScrolledWindow`.

      my $scrolled_window = new Gtk::ScrolledWindow( undef, undef );
      $scrolled_window->set_policy( 'automatic', 'always' );

Now we create the HandyCList. First, we specify the column names that will be used, then we set up the sizes for each column.

      my $list = new Gtk::HandyCList qw(Name Date Time);
      $list->sizes(350,150,100);

As I mentioned, we want to be able to re-sort the data when we click on the column headings. To make this work we have to tell the module **how** to sort each column. It knows about alphabetical and numeric sorting, but we'll have to tell it about sorting by date by providing it with a subroutine reference. We also set the shadow so that it looks pretty.

      $list->sortfuncs("alpha", \&sort_date, "number");
      $list->set_shadow_type('out');

Now we give the data to the list:

      $list->data(@cookbook);

Next, we add the list to our scrolled window, and tell the application that its main contents are the scrolled window:

      $scrolled_window->add($list);
      $app->set_contents($scrolled_window);

Finally, we'll receive the signal sent when a recipe is clicked on, and use that to display the recipe.

      $list->signal_connect( "select_row", \&display_recipe);

Of course, we need to write those two subroutines, `sort_date` and `display_recipe`. Let's leave the latter one for now, and polish off the date sorting. Here's how I'd write it, because I'm British:

            sub sort_date {
              my ($ad, $am, $ay) = ($_[0] =~ m|(\d+)/(\d+)/(\d+)|);
              my ($bd, $bm, $by) = ($_[1] =~ m|(\d+)/(\d+)/(\d+)|);
              return $ay <=> $by || $am <=> $bm || $ad <=> $bd;
            }

Exercise for the reader: make this subroutine locale-aware.

By now, you should have an application that displays a list of recipes along with their dates and cooking times. Play with it, click on the column headings and watch it re-sort, resize the windows and the columns, and see what happens.

### <span id="displaying recipes">Displaying Recipes</span>

Now let's tackle displaying the recipes. This is where things get more complex. First, we have to store the text for the recipes. We want to store them, along with the titles, dates and cooking times, in the `@cookbook` array. So let's add another column to that array, like so:

        my @cookbook = (
            [ "Frog soup", "29/08/99", "12", 
              "Put frog in water. Slowly raise water temperature 
               until frog is cooked."],
            [ "Chicken scratchings", "12/12/99", "40", 
              "Remove fat from chicken, and fry 
           under a medium grill"],
            [ "Pork with beansprouts in a garlic butter sauce 
               and a really really long name that we have to
               scroll to see",
              "1/1/99", 30, 
          "Pour boiling water into packet and stir"],
            [ "Eggy bread", "10/10/10", 3, 
          "Fry bread. Fry eggs. Combine."]
               );

We don't want to display this information on the main list, so we need to change the data that we're passing to the `Gtk::HandyCList`:

     - my $list = new Gtk::HandyCList qw(Name Date Time);
     + my $list = new Gtk::HandyCList qw(Name Date Time Recipe);
     + $list->hide("Recipe");

(If you don't remember what that syntax means, it's \`\`take out the line starting with the minus, and add in the lines starting with a plus.'')

Now that we have the recipes stored inside our data structure, we want to be able to see them. We'll use a widget called `Gnome::Less`, which is named after the Unix utility `less`. It's a file browser, but we can also give it strings to display.

Let's stop and think about what we're going to do. We need to catch the signal that tells us that the user has double-clicked on a recipe. Then, we want to pop up a window, create a `Gnome::Less` widget inside that window containing the recipe text and allow the user to dismiss the window. We've already connected the \`\`mouse click'' signal to a subroutine called `display_recipe`, so it's time to write that subroutine.

        sub display_recipe {
          my ($clist, $row, $column, $mouse_event) = @_;
          return unless $mouse_event->{type} eq "2button_press";

First, we receive the parameters passed by the signal. The first thing we get is the object that caused the signal - our `HandyCList` widget. That determines what other parameters get sent. In the case of a `HandyCList`, it's the row and column in the list that received the mouse click, and a `Gtk::Gdk::MouseEvent` object that tells us what sort of click it was. In our case, we only want to act on a double click, which is where the type is `"2button_press"`. If this isn't the case, we return.

          my %recipe = %{($clist->data)[$row]};

Given that we know the row that received the signal, we can extract that row from the `HandyCList` via the `data` method. `Data` is a get-set method, which means we can either store data into the list with it, or we can use it to retrieve the data from the list. Each row is stored as a hash reference, which we dereference to a real hash.

          my $recipe_str = $recipe{Name}."\n";
          $recipe_str .= "-" x length($recipe{Name})."\n\n";
          $recipe_str .= "Cooking time : $recipe{Time}\n";
          $recipe_str .= "Date created : $recipe{Date}\n\n";
          $recipe_str .= $recipe{Recipe};

Next, we build the string that we're going to display, using the hash values we've recovered.

          my $db = new Gnome::Dialog($recipe{Name});
          my $gl = new Gnome::Less;
          my $button = new Gtk::Button( "Close" );
          $button->signal_connect( "clicked", sub { $db->destroy } );

We now create three widgets: the pop-up dialog box window (we pass the recipe's name as a window title), the pager that will display the recipe and a close button. We also connect a signal so that when the button is clicked, the dialog box is destroyed.


          $db->action_area->pack_start( $button, 1, 1, 0 );
          $db->vbox->pack_start($gl, 1, 1, 0);

A dialog box consists of two areas: an \`\`action area'' at the bottom that should contain the available \`\`actions,'' or buttons, and a vbox at the top where we put our messages. Accordingly, we pack our button into the action area and our `Less` widget into the vbox

          $gl->show_string($recipe_str);
          show_all $db;
        }

Finally, we tell the pager what string it should display, and then show the dialog box. We can now display recipes.

### <span id="where we are, and where we're going">Where We Are, And Where We're Going</span>

The full source of the application so far can be found [here](/media/_pub_2000_11_gnome2/gcookbook.pl).
So far, we've only dealt with static data, hard-coded into the application, which isn't a very real-life scenario. Next time, we'll look at adding and deleting recipes, as well as saving and restoring cookbooks to disk using XML. Once that's done, we'll have the core of a basic cookbook application. In the final part of this tutorial, we'll add more features, such as searching by ingredients.

### <span id="notes on the last article">Notes on the Last Article</span>

Several people wrote me after [last month's article](/pub/2000/10/gnome.html) saying that they couldn't get the GNOME versions of the application working; if that's a problem, you need to be using the latest version of the Gnome.pm module. The one on CPAN is *not* the latest - instead, use the one from the Gnome.pm Web site, at <http://projects.prosa.it/gtkperl>.

I also got my knuckles rapped for saying that \`\`GNOME is the Unix desktop.'' Fair play - the other project that's providing the same sort of environment for Unix is KDE, but for a long time it was hampered by developers' suspicion of TrollTech and their QPL license. At the same time, big players like Sun and IBM were putting money into the GNOME Foundation to *make* GNOME the Unix desktop, so it seemed a fair thing to say.

Now most people are happy that the same big players have also set up the KDE League. (From [http://www.kde.org/announcements/gfresponse.html:](http://www.kde.org/announcements/gfresponse.html) \`Now we have been asked \`\`Will KDE ever create a KDE Foundation in the same sense as the GNOME Foundation?'' The answer to this is no, absolutely not.' You tell 'em, guys.) KDE looks to be a worthy alternative to GNOME. Obviously, I prefer GNOME, but as <http://segfault.org> puts it: \`\`KDE - GNOME War - Casualties so far: 0''.
