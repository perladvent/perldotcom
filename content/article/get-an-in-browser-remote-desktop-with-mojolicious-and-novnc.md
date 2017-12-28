{
   "categories" : "web",
   "description" : "Using Mojolicious as a TCP/WebSocket Bridge",
   "draft" : false,
   "date" : "2016-02-02T13:41:18",
   "tags" : [
      "mojolicious",
      "websockets",
      "novnc"
   ],
   "slug" : "212/2016/2/2/Get-an-in-browser-remote-desktop-with-Mojolicious-and-noVNC",
   "authors" : [
      "joel-berger"
   ],
   "title" : "Get an in-browser remote desktop with Mojolicious and noVNC",
   "image" : "/images/212/0156BEFE-C9B2-11E5-A2BB-E80C3AD1818C.jpeg"
}


While SSH is a staple of remote system administration, sometimes only a GUI will do. Perhaps the remote system doesn't have a terminal environment to connect to; perhaps the target application doesn't present an adequate command line interface; perhaps there is an existing GUI session you need to interact with. There can be all kinds of reasons.

For this purpose, a generic type of remote desktop service called VNC is commonly used. The servers are easy to install, start on seemingly all platforms and lots of hardware has a VNC server embedded for remote administration. Clients are similarly easy to use, but when building a management console in the web, wouldn't it be nice to have the console view right in your browser?

Luckily there is a pure JavaScript VNC client called [noVNC](https://github.com/kanaka/noVNC) noVNC listens for VNC traffic over WebSockets, which is convenient for browsers but isn't supported by most VNC servers. To overcome this problem they provide a command-line application called [Websockify](https://github.com/kanaka/websockify).

Websockify is a relay that connects to a TCP connection (the VNC server) and exposes the traffic as a WebSocket stream such that a browser client can listen on. While this does fix the problem it isn't an elegant solution. Each VNC Server needs its own instance of Websockify requiring a separate port. Further you either need to leave these connected at all times in case of a web client or else spawn them on demand and clean them up later.

Mojolicious to the Rescue
-------------------------

Mojolicious has a built-in event-based [TCP Client](http://mojoliciou.us/perldoc/Mojo/IOLoop/Client) and native [WebSocket](http://mojolicious.org/perldoc/Mojolicious/Guides/Tutorial#WebSockets) handling. If you are already serving your site with Mojolicious, why not let it do the TCP/WebSocket relay work too? Even if you aren't, the on-demand nature of the solution I'm going to show would be useful as a stand-alone app for this single purpose versus the websockify application.

Here is a [Mojolicious::Lite](http://mojolicio.us/perldoc/Mojolicious/Guides/Tutorial) application which serves the noVNC client when you request a url like `/192.168.0.1`. When the page loads, the client requests the WebSocket route at `/proxy?target=192.168.0.1` which establishes the bridge. This example is bundled with my forthcoming wrapper module with a working name of [Mojo::Websockify](https://github.com/jberger/Mojo-Websockify/blob/master/ex/client.pl). The code is remarkably simple:

```perl
use Mojolicious::Lite;

use Mojo::IOLoop;

websocket '/proxy' => sub {
  my $c = shift;
  $c->render_later->on(finish => sub { warn 'websocket closing' });

  my $tx = $c->tx;
  $tx->with_protocols('binary');

  my $host = $c->param('target') || '127.0.0.1';
  my $port = $host =~ s{:(\d+)$}{} ? $1 : 5901;

  Mojo::IOLoop->client(address => $host, port => $port, sub {
    my ($loop, $err, $tcp) = @_;

    $tx->finish(4500, "TCP connection error: $err") if $err;
    $tcp->on(error => sub { $tx->finish(4500, "TCP error: $_[1]") });

    $tcp->on(read => sub {
      my ($tcp, $bytes) = @_;
      $tx->send({binary => $bytes});
    });

    $tx->on(binary => sub {
      my ($tx, $bytes) = @_;
      $tcp->write($bytes);
    });

    $tx->on(finish => sub {
      $tcp->close;
      undef $tcp;
      undef $tx;
    });
  });
};

get '/*target' => sub {
  my $c = shift;
  my $target = $c->stash('target');
  my $url = $c->url_for('proxy')->query(target => $target);
  $url->path->leading_slash(0); # novnc assumes no leading slash :(
  $c->render(
    vnc  =>
    base => $c->tx->req->url->to_abs,
    path => $url,
  );
};

app->start;
```

The `get` route shown at the bottom and isn't very exciting. It's the frontend route that renders the noVNC client and tells it the WebSocket url.

The `websocket` route is the more interesting one, which I will explain in detail. After shifting off the controller, we tell the server not to attempt to render a template (`render_later`), then subscribe to the finish handler. This is actually a hint to the server that we intend to initiate a WebSocket connection later. Typically this is done by either subscribing to one of the message events or else by sending data upon connection, but in this case we won't do either until the TCP connection is established. Then after extracting the target host and port from the query argument we are ready to make the TCP connection.

[`Mojo::IOLoop->client`](http://mojolicious.org/perldoc/Mojo/IOLoop#client) simply takes connection arguments and a callback for what to do once connected. We use this callback to establish our relay. The WebSocket protocol reserves all closing statuses below 4000 for internal use, so I've taken to using the standard HTTP statuses and prepending a 4 to them. Thus when setting up the TCP error handling, either on initially connecting or for subsequent errors, the status passed to the WebSocket `finish` method is 4500.

The relay itself is the next two method calls. First, when the TCP socket emits a `read` event, we take its raw bytes and send them (as binary messages) to the WebSocket client. Then when the WebSocket emits a binary frame (i.e. when it receives a binary message) we write that back to the TCP connection. Finally when the Websocket is closed, we also close the TCP connection and cleanup our handlers.

Simple, isn't it?!

Additional Notes
----------------

There are a few things missing. First is that I haven't addressed security in this example. If any part of the stream is publicly available you will want to encrypt the traffic and put the servers behind authentication. Another risk is the issue of "back pressure" where a stream starts sending floods of data.

You may have noticed I skipped one line, which until a recent version of Chrome wasn't necessary. When the WebSocket connection is first established it calls `with_protocols('binary')`. Early versions of noVNC also supported sending the TCP traffic as base64 encoded text, since early implementations of WebSockets didn't distinguish between text and binary frame types as the modern ones do. The WebSocket protocol allows the client to request an application-defined "sub-protocol" which noVNC used to request binary or base64, the latter of which has long since been deprecated and removed. The client still asks for the binary sub-protocol and recent versions of Chrome have started to refuse to connect if the server doesn't indicate that it can handle this request.

Shouldn't This Be On CPAN?
--------------------------

I'm hoping to wrap this TCP/WebSocket bridge logic up as a module called `Mojo::Websockify` and include the noVNC client as an example. It turns out however, that the logic which is simple to show here is remarkably hard to package in a generic, extensible way. For example, you may want to check if the TCP service is already in use via some database-locking table, or to allow remote-takeover of sessions using a message broker between clients. I'll probably just simplify things for the common case and build in some protection for the "back pressure" problem. In the meantime I hope you have enjoyed seeing how beautifully simple Mojolicious' WebSocket and TCP services are.

Happy Perling!

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
