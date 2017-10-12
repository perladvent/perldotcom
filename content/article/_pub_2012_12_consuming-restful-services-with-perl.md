{
   "description" : "When JT Smith ported his web game The Lacuna Expanse to a board game, he used Perl to create the board game itself. Here's how he built the web service behind The Game Crafter.",
   "image" : null,
   "authors" : [
      "jt-smith"
   ],
   "thumbnail" : null,
   "draft" : null,
   "tags" : [],
   "title" : "Consuming RESTful Services with Perl",
   "slug" : "/pub/2012/12/consuming-restful-services-with-perl",
   "date" : "2012-12-31T06:00:01-08:00",
   "categories" : "Web"
}





In my previous article I described [how to create board game images
using
`Image::Magick`](/media/_pub_2012_12_consuming-restful-services-with-perl/designing-board-games-with-perl.html),
thus allowing you to design board games using Perl. This time I want to
show you how to upload those images to [The Game
Crafter](https://www.thegamecrafter.com/) so you get get a professional
copy of the game manufactured.

In the last article I [created a board game
version](https://www.thegamecrafter.com/games/lacuna-expanse:-a-new-empire)
of the video game called [The Lacuna
Expanse](http://www.lacunaexpanse.com). This time I'll show how to
upload those images to the site to create a custom board game. Don't
worry if you're not ready to create a board game or if you'll never be
ready; the principles of designing a useful API and using it apply to
all sorts of services you might want to use, from weather tracking to
stocks to medical systems. I picked games for two reasons. One, me and I
team just built this system, so it's shiny and new and I've learned a
lot. Two, games are more fun (and visual) than showing how to record
invoice information in a RESTful ERP application.

Getting Ready
-------------

First, get yourself a copy of
[TheGameCrafter::Client](http://search.cpan.org/~rizen/TheGameCrafter-Client/lib/TheGameCrafter/Client.pm).
It's a Perl module that makes it trivial to interact with The Game
Crafter's RESTful web service API. When you
`use TheGameCrafter::Client;` it imports `tgc_get()`, `tgc_post()`,
`tgc_put()`, and `tgc_delete()` into your program for easy use. *Good
APIs are descriptive and obvious.* From there you can have a look at The
Game Crafter's [developer
documentation](https://www.thegamecrafter.com/developer/) to do any
custom stuff you want. *Good APIs have useful documentation.*

You'll also need to activate the [developer setting in your TGC
account](https://www.thegamecrafter.com/account), and [request an API
key](https://www.thegamecrafter.com/account/apikeys). *Good APIs
demonstrate security in authorization and authentication.*

A Little about The Game Crafter's API
-------------------------------------

`TheGameCrafter::Client` is just a tiny wrapper around our RESTful web
services. I designed the web services atop
[Dancer](http://search.cpan.org/~xsawyerx/Dancer/lib/Dancer.pm) and
[DBIx::Class](http://search.cpan.org/~frew/DBIx-Class/lib/DBIx/Class.pm).
My goal with this was to build a very reliable and consistent API not
only for external use but internal. You see, the *entire* TGC web site
actually runs off these web services. Not only that, but these web
services tie directly into our manufacturing facility, so they are
controlling the physical world in addition to the virtual. *Good APIs
allow you to build multiple clients with different uses.* (They don't
*require* multiple clients, but they don't forbid it and do enable it.)

With Lacuna, I built
[JSON::RPC::Dispatcher](http://search.cpan.org/~rizen/JSON-RPC-Dispatcher/lib/JSON/RPC/Dispatcher.pm.orig)
(JRD), which is a JSON-RPC 2.0 web service handler on top of
[Plack](http://search.cpan.org/~miyagawa/Plack/lib/Plack.pm). I love
JRD, but it has two weaknesses, one of them fatal. One weakness is that
you must format parameters using JSON, which means that it's not easy to
just call a URL and get a result with something like `curl`. (*Good
RESTful APIs allow multiple clients.* If you can't use `curl`, you
probably have a problem.) The fatal weakness of JSON-RPC 2.0 is that
there is no way to do file uploads within the spec. The Game Crafter is
all about file uploads, so that meant I either needed to handle those
separately (aka inconsistently), or develop something new. I opted for
the latter.

With TGC's web services I decided to adopt some of the things I really
liked about JSON-RPC, namely the way it handles responses whether they
be result sets or errors. So you always get a consistent return:

    { "result" : { ... } }

    {
       "error" : {
            "code" : 404,
            "message" : "File not found.",
            "data" : "file_id"
       }
    }

With TGC I also wanted a consistent and easy way of turning
`DBIx::Class` into web services through Dancer. I looked into things
like
[AutoCRUD](http://search.cpan.org/~oliver/Catalyst-Plugin-AutoCRUD-2.122460/lib/Catalyst/Plugin/AutoCRUD.pm),
but I'm not a fan of Catalyst, and it also took too much configuration
(in my opinion) to get it working. I wanted something simpler and
faster, so I decided to roll my own. The result was a thin layer of glue
between Dancer and `DBIx::Class` that allows you to define your web
service interface in your normal `DBIx::Class` declarations. It
automatically then generates the web services, databases tables, web
form handling, and more for you. This little glue layer is now in use in
all web app development within [Plain
Black](http://www.plainblack.com/), and eventually we'll be releasing it
onto CPAN for all to use for free. The best part of that is that you
know you're getting a production-ready system because it's been running
The Game Crafter and other sites for over a year now. (*Good APIs are
often extracted from working systems.*) More on that in a future
article.

Let's Do This Thing Already
---------------------------

Before you can make any API calls, you need to authenticate.

     my $session = tgc_post('session',{
       username    => 'me',
       password    => '123qwe',
       api_key_id  => 'abcdefhij',
     });

Before you can start uploading, fetch your user account information.
This contains several pieces of info that you can use.

     my $user = tgc_get('user', {
       session_id    => $session->{id},           # using our session to do stuff
    });

Think of TGC projects like filesystems: you have folders which contain
folders and files. First create a folder, then upload a file:

     my $folder = tgc_post('folder', {
      session_id  => $session->{id},
      name        => 'Lacuna',
      user_id     => $user->{id},
      parent_id   => $user->{root_folder_id},  # putting this in the home folder
     });

     my $file = tgc_post('file', {
      session_id  => $session->{id},
      name        => 'Mayhem Training',
      file        => ['mayhem.png'],         # the array ref signifies this is a file path
      folder_id   => $folder->{id},       # putting it in the just-created folder
     });

Assuming at this point you've uploaded all of your files, you can now
build out your game. The Game Crafter has this notion of a "Designer",
which is sort of like your very own publishing company. Games are
attached to the designer, so first you must create the designer, then
the game.

     my $designer = tgc_post('designer', {
      session_id  => $session->{id},
      user_id     => $user->{id},
      name        => 'Lacuna Expanse Corp',
     });

     my $game = tgc_post('game', {
      session_id  => $session->{id},
      designer_id => $designer->{id},
      name        => 'Lacuna Expanse: A New Empire',
     });

With a game created and assets uploaded, you can now create a deck of
cards. This is pretty straight forward just like before.

     my $deck = tgc_post('minideck', {
      session_id => $session->{id},
      name       => 'Planet',
      game_id    => $game->{id},
     });

     my $card = tgc_post('minicard', {
      session_id => $session->{id},
      name       => 'Mayhem Training',
      face_id    => $file->{id},
      deck_id    => $deck->{id},
     });

You have probably noticed already how closely this resembles CRUD
operations, because it does. Behind the scenes, who knows what TGC does
with this information? (I do, but that's because I wrote it.) It doesn't
matter to the API, because all of those details are hidden behind a good
API. *Good APIs expose only the necessary details*—in this case, the
relationships between folders and files and between designers and games.

You can also see that the API is as stateless as possible, where the
session identifier is part of every API call. It's easy to imagine a
more complicated API which hides this, but I stuck with the bare-bones
REST for at least two reasons: it's simple, and it's easy to see what's
happening. Someone could build over the top of this API if desired.
*Good APIs allow extension and further abstraction.*

Just like that, you've created a game and added a deck of cards to it.
There are of course lots of other fancy things you can do with the API,
but this should get you started. I wouldn't leave you hanging there,
however. I've [open sourced the actual
code](https://github.com/plainblack/Lacuna-Board-Game) I used to create
[the Lacuna Expanse board
game](https://www.thegamecrafter.com/games/lacuna-expanse:-a-new-empire)
so you'd have something to reference. There's also a [developer's
forum](https://community.thegamecrafter.com/forums/developers) if you
have any questions. Good luck to you, and happy gaming!


