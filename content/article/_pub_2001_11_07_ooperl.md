{
   "draft" : null,
   "thumbnail" : "/images/_pub_2001_11_07_ooperl/111-perlobj.gif",
   "authors" : [
      "simon-cozens"
   ],
   "description" : " I've recently started learning to play the game of Go. Go and Perl have many things in common - the basic stuff of which they are made, the rules of the game, are relatively simple, and hide an amazing...",
   "image" : null,
   "categories" : "development",
   "slug" : "/pub/2001/11/07/ooperl",
   "date" : "2001-11-07T00:00:00-08:00",
   "title" : "Object-Oriented Perl",
   "tags" : [
      "object-oriented",
      "perl"
   ]
}





I've recently started learning to play the game of Go. Go and Perl have
many things in common -- the basic stuff of which they are made, the
rules of the game, are relatively simple, and hide an amazing complexity
of possibilities beneath the surface. But I think the most interesting
thing I've found that Go and Perl have in common is that there are
various different stages in your development as you learn either one.
It's almost as if there are several different plateaus of experience,
and you have to climb up a huge hill before getting onto the next
plateau.

For instance, a Go player can play very simply and acquit himself quite
decently, but to stop being a beginner and really get into the game, he
has to learn how to attack and defend economically. Then, to move on to
the next stage, he has to master fighting a repetitive sequence called a
"ko." As I progress, I expect there to be other difficult strategies I
need to master before I can become a better player.

Perl, too, is not without its plateaus of knowledge, and in my
experience, the one that really separates the beginner from the
intermediate programmer is an understanding of object-oriented (OO)
programming. Once you've understood how to use OO Perl, the door is
opened to a huge range of interesting and useful CPAN modules, new
programming techniques, and mastery of the upper plateaus of Perl
programming.

### So what is it?

Object-oriented programming is one of those buzzwordy manager-speak
phrases, but unlike most of them, it actually means something. Let's
take a look at some perfectly ordinary procedural Perl code, bread and
butter programming to most beginning programmers:

    my $request = accept_request($client);
    my $answer = process_request($request);
    answer_request($client, $answer);
    $new_request = redirect_request($client, $request, $new_url);

The example here is of something like a Web server: we receive a request
from a client, process it in some way to obtain an answer, and send the
answer to the client. Additionally, we can also redirect the request to
a different URL.

The same code, written in an object-oriented style, would look a little
different:

    my $request = $client->accept();
    $request->process();
    $client->answer($request);
    $new_request = $request->redirect($new_url);

What's going on here? What are these funny arrows? The thing to remember
about object-oriented programming is that we're no longer passing the
data around to subroutines, to have subroutines do things for us -- now,
we're telling the data to do things for itself. You can think of the
arrows, (`->`, formally the "method call operator") as instructions to
the data. In the first line, we're telling the data that represents the
client to accept a request and pass us something back.

What is this "data that represents the client," and what does it pass
back? Well, if this is object-oriented programming, we can probably
guess the answer: they're both objects. They look like ordinary Perl
scalars, right? Well, that's just because objects really are like
ordinary Perl scalars.

The only difference between `$client` and `$request` in each example is
that in the object-oriented version, the scalars happen to know where to
find some subroutines that they can call. (In OO speak, we call them
"methods" instead of "subroutines.")

This is why we don't have to say `process_request` in the OO case: if
we're calling the `process` method on something that knows it's a
request, it knows that it's processing a request. Simple, eh? In OO
speak, we say that the `$request` object is in the Request "class" -- a
class is the "type of thing" that the object is, and classes are how
objects locate their methods. Hence, `$request->redirect` and
`$mail->redirect` will call completely different methods if `$request`
and `$mail` are in different classes; what it means to redirect a
Request object is very different to redirecting a Mail object.

You might wonder what's actually going on when we call a method. Since
we know that methods are just the OO form of subroutines, you shouldn't
be surprised to find that methods in Perl really are just subroutines.
What about classes? Well, the purpose of a class is to distinguish one
set of methods from another. And what's a natural way to distinguish one
set of subroutines from another in Perl? You guessed it -- in Perl,
classes are just packages. So if we've got an object called `$request`
in the `Request` class and we call the redirect method, this is what
actually happens:

    # $request->redirect($new_url)

    Request::redirect($request, $new_url)
        

That's right -- we just call the `redirect` subroutine in the
appropriate package, and pass in the object along with any other
parameters. Why do we pass in the object? So that `redirect` knows what
object it's working on.

At a very basic level, this is all OO Perl is -- it's another syntax for
writing subroutine calls so that it looks like you're performing actions
on some data. At that, for most users of OO Perl modules, is as much as
you need to know.

### Why is it a win?

So if that's all it is, why does everyone think that OO Perl is the best
thing since sliced bread? You'll certainly find that a whole host of
interesting and useful modules out there depend on OO techniques. To
understand what everyone sees in it, let's go back to procedural code
for a moment. Here's something that extracts the sender and subject of a
mail message:

    sub mail_subject {
        my $mail = shift;
        my @lines = split /\n/, $mail;
        for (@lines) {
            return $1 if /^Subject: (.*)/;
            return if /^$/; # Blank line ends headers
        }
    }
    sub mail_sender {
        my $mail = shift;
        my @lines = split /\n/, $mail;
        for (@lines) {
            return $1 if /^From: (.*)/;
            return if /^$/;
        }
    }

    my $subject = mail_subject($mail);
    my $from    = mail_sender($mail);

All well and good, but notice that we have to run through the whole mail
each time we want to get new information about it. Now, it's true we
could replace the body of these two subroutines with quite a complicated
regular expression, but that's not the point: we're still doing more
work than we ought to.

For our equivalent OO example, let's use the CPAN module `Mail::Header`.
This takes a reference to an array of lines, and spits out a mail header
object to which we can then do things.

    my @lines = split /\n/, $mail;
    my $header = Mail::Header->new(\@lines);

    my $subject = $header->get("subject");
    my $from    = $header->get("from");

Not only are we now looking at the problem from a perspective of "doing
things to the header", we're also giving the module an opportunity to
make this more efficient. How come?

One of the main benefits of CPAN modules is that they give us a set of
functions we can call, and we don't have to care how they're
implemented. OO programming calls this "abstraction" - the
implementation is abstracted from the user's perspective. Similarly, we
don't have to care what `$mail_obj` really is. It could just be our
reference to an array of lines, but on the other hand, `Mail::Header`
can do clever things with it.

In reality, `$header` is a hash reference under the hood. Again, we
don't need to care whether or not it's a hash reference or an array
reference or something altogether different, but as it's a hash
reference, this allows the constructor, `new` (a constructor is just a
method that creates a new object) to do all the pre-processing on our
array of lines once and for all, and then store the subject, sender, and
all sorts of other fields into some hash keys. All that `get` does,
essentially, is retrieve the appropriate value from the hash. This is
obviously vastly more efficient than running through the whole message
each time.

That's what an object really is: it's something that the module can
rearrange and use any representation of your data that it likes so that
it's most efficient to operate on in the future. You, as an end user,
get the benefits of a smart implementation (assuming, of course, that
the person who wrote the module is smart...) and you don't need to care
about, or even actually see, see what's going on underneath.

### Using it

We've seen a simple use of OO techniques by using `Mail::Header`. Let's
now look at a slightly more involved program, to solidify our knowledge.
This is a very simple system information server for a Unix machine.
(Don't be put off -- these programs will work on non-Unix systems as
well.) Unix has a client/server protocol called "finger," by which you
can contact a server and ask for information about its users. I run
"finger" on my username at a local machine, and get:

    % finger simon
    Login name: simon       (messages off)  In real life: Simon Cozens
    Office: Computing S
    Directory: /v0/xzdg/simon               Shell: /usr/local/bin/bash
    On since Nov  6 10:03:46                5 minutes 38 seconds Idle Time
       on pts/166 from riot-act.somewhere
    On since Nov  6 12:28:08
       on pts/197 from riot-act.somewhere
    Project: Hacking Perl for Sugalski
    Plan:

    Insert amusing anecdote here.

What we're going to do is write our own finger client and a server which
dishes out information about the current system, and we're going to do
this using the object-oriented `IO::Socket` module. Of course, we could
do this completely procedurally, using `Socket.pm`, but it's actually
comparatively much easier to do it this way.

First, the client. The finger protocol, as much as we need to care about
it, is really simple. The client connects and sends a line of text --
generally, a username. The server sends back some text, and then closes
the connection.

By using `IO::Socket` to manage the connection, we can come up with
something like this:

    #!/usr/bin/perl
    use IO::Socket::INET;

    my ($host, $username) = @ARGV;

    my $socket = IO::Socket::INET->new(
                            PeerAddr => $host,
                            PeerPort => "finger"
                          ) or die $!;

    $socket->print($username."\n");

    while ($_ = $socket->getline) {
        print;
    }

This is pretty straightforward: the `IO::Socket::INET` constructor `new`
gives us an object representing the connection to peer address `$host`
on port `finger`. We can then call the `print` and `getline` methods to
send and receive data from the connection. Compare this with the non-OO
equivalent, and you may realize why people prefer dealing with objects:

    #!/usr/bin/perl -w
    use strict;
    use Socket;
    my ($remote,$port, $iaddr, $paddr, $proto, $user);

    ($remote, $user) = @ARGV; 

    $port    = getservbyname('finger', 'tcp')   || die "no port";
    $iaddr   = inet_aton($remote)               || die "no host: $remote";
    $paddr   = sockaddr_in($port, $iaddr);

    $proto   = getprotobyname('tcp');
    socket(SOCK, PF_INET, SOCK_STREAM, $proto)  || die "socket: $!";
    connect(SOCK, $paddr)                       || die "connect: $!";
    print SOCK "$user\n";
    while (<SOCK>)) {
       print;
    }

    close (SOCK)            || die "close: $!";

Now, to turn to the server. We'll also use another OO module,
`Net::hostent`, which allows us to treat the result of `gethostbyaddr`
as an object, rather than as a list of values. This means we don't have
to worry about remembering which element of the list means what we want.

    #!/usr/bin/perl -w
    use IO::Socket;
    use Net::hostent;

    my $server = IO::Socket::INET->new( Proto     => 'tcp',
                                        LocalPort => 'finger',
                                        Listen    => SOMAXCONN,
                                        Reuse     => 1);
    die "can't setup server" unless $server;

    while ($client = $server->accept()) {
      $client->autoflush(1);
      $hostinfo = gethostbyaddr($client->peeraddr);
      printf "[Connect from %s]\n", $hostinfo->name || $client->peerhost;
      my $command = client->getline();
      if    ($command =~ /^uptime/) { $client->print(`uptime`); }
      elsif ($command =~ /^date/)   { $client->print(scalar localtime, "\n"); }
      else  { $client->print("Unknown command\n");
      $client->close;
    }

This is chock-full of OO Perl goodness -- a method call on nearly every
line. We start in a very similar way to how we wrote the client: using
`IO::Socket::INET->new` as a constructor. Did you notice anything
strange about this? `IO::Socket::INET` is a package name, which means it
must be a class, rather than an object. But we can still call methods on
classes (they're generally called "class methods," for obvious reasons)
and this is how most objects actually get instantiated: the class
provides a method called `new` that produces an object for us to
manipulate.

The big `while` loop calls the `accept` method that waits until a client
connects and, when one does, returns another `IO::Socket::INET` object
representing the connection to the client. We can call the client's
`autoflush` method, which is the equivalent to setting `$|` for its
handle; the `peeraddr` method returns the address of the client, which
we can feed to `gethostbyaddr`.

As we mentioned earlier, this isn't the usual Perl `gethostbyadd`, but
one provided by `Net::Hostent`, and it returns yet another object! We
use the `name` method from this object, which represents information
about a given host, to find the host's name.

The rest isn't anything new. If you think back to our client, it sent a
line and awaited a response -- so our server has to read a line, and
send a response. You get bonus points for adding more possible responses
to our server.

### Conclusion

So there we are. We've seen a couple of examples of using
object-oriented modules. It wasn't that bad, was it? Hopefully now
you'll be well-enough equipped to be able to start using some of the
many OO modules on CPAN for yourself.

If, on the other hand, you feel you need a little more in-depth coverage
of OO Perl, you could take a look at the "perlboot," "perltoot," and
"perltootc" pages in the Perl documentation. *The Perl Cookbook*, an
invaluable book for any serious Perl programmer, has a very
comprehensive and easy to follow treatment of OO techniques. Finally,
the most in-depth treatment of all can be found in Damian Conway's
"Object-Oriented Perl", which will see you through from a complete
beginner way up to Perl 4 or 5 dan...


