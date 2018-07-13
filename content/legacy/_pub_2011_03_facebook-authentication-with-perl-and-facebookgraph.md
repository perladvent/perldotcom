{
   "tags" : [
      "cpan",
      "dancer",
      "facebook",
      "facebook-graph",
      "web-development"
   ],
   "thumbnail" : null,
   "date" : "2011-03-15T10:17:51-08:00",
   "categories" : "web",
   "title" : "Facebook Authentication with Perl and Facebook::Graph",
   "image" : null,
   "description" : "In the first of a series on writing Facebook applications with Perl, JT Smith demonstrates how to register an application and authenticate users with Facebook::Graph.",
   "slug" : "/pub/2011/03/facebook-authentication-with-perl-and-facebookgraph.html",
   "draft" : null,
   "authors" : [
      "jt-smith"
   ]
}



Basic integration of software and web sites with Facebook, Twitter, and other social networking systems has become a litmus test for business these days. Depending on the software or site you might need to fetch some data, make a post, create events, upload photos, or use one or more of the social networking sites as a single sign-on system. This series will show you how to do exactly those things on Facebook using [Facebook::Graph]({{<mcpan "Facebook::Graph" >}}).

This first article starts small by using Facebook as an authentication mechanism. There are certainly simpler things to do, but this is one of the more popular things people want to be able to do. Before you can do anything, you need to have a Facebook account. Then [register your new application](http://apps.facebook.com/developer) (Figure 1).

<img src="/images/_pub_2011_03_facebook-authentication-with-perl-and-facebookgraph/register_app.png" alt="registering a Facebook application" width="696" height="209" />
*Figure 1. Registering a Facebook application.*

Then fill out the "Web Site" section of your new app (Figure 2).

<img src="/images/_pub_2011_03_facebook-authentication-with-perl-and-facebookgraph/register_website.png" alt="registering your application&#39;s web site" width="740" height="224" />
*Figure 2. Registering your application's web site.*

Registering an application with Facebook gives you a unique identifier for your application as well as a secret key. This allows your app to communicate with Facebook and use its API. Without it, you can't do much (besides screen scraping and hoping).

Now you're ready to start creating your app. I've used the [Dancer web app framework](http://perldancer.org/), but feel free to use your favorite. Start with a basic Dancer module:

    package MyFacebook;

    use strict;
    use Dancer ':syntax';
    use Facebook::Graph;

    get '/' => sub {
      template 'home.tt'
    };

    true;

That's sufficient to give the app a home page. The next step is to force people to log in if they haven't already:

    before sub {
        if (request->path_info !~ m{^/facebook}) {
            if (session->{access_token} eq '') {
                request->path_info('/facebook/login')
            }
        }
    };

This little bit of Dancer magic says that if the path is not `/facebook` and the user has no access\_token attached to their session, then redirect them to our login page. Speaking of our login page, create that now:

    get '/facebook/login' => sub {
        my $fb = Facebook::Graph->new( config->{facebook} );
        redirect $fb->authorize->uri_as_string;
    };

This creates a page that will redirect the user to Facebook, and ask them if it's ok for the app to use their basic Facebook information. That code passes `Facebook::Graph` some configuration information, so remember to add a section to Dancer's *config.yml* to keep track of that:

    facebook:
        postback: "http://www.madmongers.org/facebook/postback/"
        app_id: "XXXXXXXXXXXXXXXX"
        secret: "XXXXXXXXXXXXXXXXXXXXXXXXXXX"

Remember, you get the app\_id and the secret from Facebook's developer application after you create the app. The postback tells Facebook where to post back to after the user has granted the app authorization. Note that Facebook requires a slash (/) on the end of the URL for the postback. With Facebook ready to post to a URL, it's time to create it:

    get '/facebook/postback/' => sub {
        my $authorization_code = params->{code};
        my $fb                 = Facebook::Graph->new( config->{facebook} );

        $fb->request_access_token($authorization_code);
        session access_token => $fb->access_token;
        redirect '/';
    };

NOTE: I know it's called a postback, but for whatever reason Facebook does the `POST` as a `GET`.

Facebook's postback passes an authorization code—a sort of temporary password. Use that code to ask Facebook for an access token (like a session id). An access token allows you to request information from Facebook *on behalf of the user*, so all of those steps are, essentially, your app logging in to Facebook. However, unless you store that access token to use again in the future, the next request to Facebook will log you out. Therefore, the example shoves the access token into a Dancer session to store it for future use before redirecting the user back to the front page of the site.

NOTE: The access token we have will only last for two hours. After that, you have to request it again.

Now you can update the front page to include a little bit of information from Facebook. Replace the existing front page with this one:

    get '/' => sub {
        my $fb = Facebook::Graph->new( config->{facebook} );

        $fb->access_token(session->{access_token});

        my $response = $fb->query->find('me')->request;
        my $user     = $response->as_hashref;
        template 'home.tt', { name => $user->{name} }
    };

This code fetches the access token back out of the session and uses it to find out some information about the current user. It passes the name of that user into the home template as a template parameter so that the home page can display the user's name. (How do you know what to request and what responses you get? See the [Facebook Graph API documentation](http://developers.facebook.com/docs/reference/api/).)

While there is a bit of a trick to using Facebook as an authentication system, it's not terribly difficult. Stay tuned for Part II where I'll show you how to post something to a user's wall.
