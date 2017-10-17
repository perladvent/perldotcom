{
   "image" : null,
   "title" : "Writing on Walls with Facebook::Graph",
   "categories" : "web",
   "date" : "2011-04-04T18:03:13-08:00",
   "thumbnail" : null,
   "tags" : [
      "cpan",
      "dancer",
      "facebook",
      "facebook-graph",
      "web-development"
   ],
   "authors" : [
      "jt-smith"
   ],
   "draft" : null,
   "slug" : "/pub/2011/04/writing-on-walls-with-facebookgraph.html",
   "description" : "JT Smith shows how to write Facebook applications with offline permissions to post to user walls with Perl and Facebook::Graph."
}



In my first article about [Facebook::Graph](http://search.cpan.org/perldoc?Facebook::Graph), I showed you how to [use Facebook as an authentication mechanism for your site](/pub/2011/03/facebook-authentication-with-perl-and-facebookgraph.html). This time let me show you how to build on that authentication to post something to a user's Facebook wall.

First things first. The application needs additional permissions from the user. The previous app requested only basic rights to view the most basic of information about the user. Any app that wants to post to auser's wall needs to ask the user for permission to post to their wall. Replace the existing login method with:

    get '/facebook/login' => sub {
        my $fb = Facebook::Graph->new( config->{facebook} );
        redirect $fb
            ->authorize
            ->extend_permissions( qw(publish_stream) )
            ->uri_as_string;
    };

The only difference between this version and the original is the `extend_permissions` line which asks for `publish_stream` access. Facebook maintains [a table of Facebook application permissions](http://developers.facebook.com/docs/authentication/permissions/) and their implications.

When a user grants this additional permission, the application can post almost anything to the user's wall. For example, if you have a shop of some kind, you could post something to a user's wall after a purchase:

    my $fb = Facebook::Graph->new( config->{facebook} );
    $fb->add_post
      ->set_message('I just bought Widget X from The Cool Shop for only $4.99.')
      ->publish;

Or more descriptive:

    $fb->add_post
      ->set_message('I just bought Widget X from The Cool Shop for only $4.99.')
      ->set_picture_uri('http://images.coolshop.com/widgetx.jpg'),
      ->link_uri('http://www.coolshop.com/products/widget-x'),
      ->link_caption('Widget X')
      ->publish;

If you publish links, do yourself a favor by making sure the page you are linking uses [Open Graph Protocol](http://ogp.me/) meta tags. Facebook can refer to these tags, and will therefore link that metadata into your post, which means if anybody posts your link *http://www.coolshop.com/products/widget-x* into a Facebook post, it will automatically pull in images, description, and other things.

**NOTE:** Make sure whatever you post abides by [Facebook's Platform Polices](http://developers.facebook.com/policy/). If you don't, Facebook can and will ban your application.

This works well for posting something to Facebook when a logged-in user performs an action in your application, but but what if you want to post something *not* as the result of a direct user action? Maybe your site isn't a shop. Maybe it's a reminders site that posts stuff like "Happy Birthday Maggie!" or a random quote of the day. To post on behalf of the user even when they aren't logged in to your site, you must request offline access. This requires another update to the login page:

    get '/facebook/login' => sub {
        my $fb = Facebook::Graph->new( config->{facebook} );
        redirect $fb
            ->authorize
            ->extend_permissions( qw(offline_access publish_stream) )
            ->uri_as_string;
    };

You can see the `offline_access` permission in addition to `publish_stream` this time. Another necessary change is to store the resulting access token in something more robust than a Dancer session this time:

    get '/facebook/postback/' => sub {
        my $params = request->params;
        my $fb     = Facebook::Graph->new( config->{facebook} );

        $fb->request_access_token($params->{code});
        session access_token => $fb->access_token;

        my $user = $fb->fetch('me');

        database->quick_insert( 'facebook', {
            uid          => $user->{uid},=20
            name         => $user->{name},=20
            access_token => $fb->access_token,
           }
        );
        redirect '/';
    };

In addition to storing the `access_token` in a Dancer session, the code also stores it in a database table for future reference (using [Dancer::Plugin::Database](http://search.cpan.org/perldoc?Dancer::Plugin::Database), which is a wrapper around [DBI](http://search.cpan.org/perldoc?DBI)). This sort of thing can be good for other reasons too. For example, Facebook recommends caching data that you fetch from it for faster response times. If you want to display the user's name on every page, it's much faster to pull it out of the local database based upon the access token you have in your Dancer session than it is to request it from Facebook again.

As you can see, `Facebook::Graph` makes it quite easy to post to Facebook on behalf of your users. Stay tuned for Part III, where I'll show you how to publish calendar events and RSVP to them.
