{
   "authors" : [
      "vladi-belperchinov-shabanski"
   ],
   "image" : null,
   "title" : "Throwing Shapes",
   "thumbnail" : "/images/_pub_2005_02_03_rpc_design/111-shapes.gif",
   "categories" : "community",
   "description" : " Sometimes data processing is better when separated into different processes that may run on the same machine or even on different ones. This is the well-known client-server technique. You can do it using a known protocol (such as http)...",
   "tags" : [
      "algorithm-floodcontrol",
      "event-processing",
      "flood-control",
      "vladi-belperchinov-shabanski"
   ],
   "date" : "2005-02-03T00:00:00-08:00",
   "slug" : "/pub/2005/02/03/rpc_design",
   "draft" : null
}





\
Sometimes data processing is better when separated into different
processes that may run on the same machine or even on different ones.
This is the well-known client-server technique. You can do it using a
known protocol (such as http) or by developing your own, specific
protocol. This approach needs implementation for constructor and parser
procedures for each packet type (request and response). It's possible
for different packets to have the same structure so the constructor and
parser will be always the same. Perhaps the simplest solution is to have
key/value pairs packed with newline characters or with other separators
inside a text block. Binary form with length encoding is another
solution.

In an attempt to simplify this client-server interaction, the *Remote
Procedure Call* (RPC) technique appeared. It tries to map functions
inside the client code to their counterparts inside the server. RPC
hides all the details between a client function call and the server
function's response. This includes argument serialization (to make data
appropriate to transfer over the net, also known as marshaling),
transport, the server function call, and returning response data back to
the client (also serialized). In some implementations, RPC also tries to
remove requirements for the client and the server to run on the same
operating system or hardware, or to be written in the same programming
language.

In the Perl world there are several modules that offer different kinds
of RPC, including
[RPC::Simple](http://search.cpan.org/perldoc?RPC::Simple),
[RPC::XML](http://search.cpan.org/perldoc?RPC::XML),
[DCE::RPC](http://search.cpan.org/perldoc?DCE::RPC), and more.

In this article I'll explain how to use Perl-specific features to
develop a compact RPC implementation that I will name *Perl-centric
Remote Call* (PerlRC). As the name suggests, it will run only with Perl
clients and servers.

### Shape

PerlRC needs to simulate a function call environment that seems familiar
to the client. This requires handling the four key properties of a
function call:

-   Function name
-   Function arguments
-   Calling context
-   Return data

The design of the Perl language allows generic argument handling, which
means that it is possible to handle arguments without knowing them
before the function call. There are also ways to discover the calling
context. Finally, the caller can handle results in the same way as the
called function's arguments -- generically, without knowing their
details until the function call returns.

With this in mind, the PerlRC code must follow these steps:

-   *Creating Transport Containers*

    Essentially these are the request and response packets. I'll use
    hashes for both. Each one will be serialized to a scalar which the
    code will send to the other side with a trailing newline terminator.

    A request container resembles:

        # request hash
          $req1 = {
                    'ARGS' => [          # arguments list
                                2,
                                8
                              ],
                    'NAME' => 'power',   # remote function name
                    'WANTARRAY' => 0     # calling context
                  };

          # result hash for scalar context
          $res1 = {
                    'RET_SCALAR' => 256  # result scalar
                  };

          # result hash for array context
          $res2 = {
                    'RET_ARRAY' => [     # result array
                                     12,
                                     13,
                                     14,
                                     15,
                                     16,
                                     17,
                                     18,
                                   ]
                  };

          # result hash for error
          $res3 = {
                    # error description
                    'ERROR' => 'No such function: test'
                  };

-   *Arguments*

    To keep things simple, the first argument will represent the remote
    function name to call. This server must remove this argument from
    the list before passing on the rest to the remote function. The
    request container holds the name for the remote function and a
    separate reference to the argument list.

-   *Calling Context Discovery*

    Find the calling context with the built-in `wantarray` function and
    put this value (0 for scalar and 1 for array context) in the request
    hash.

-   *Transfer Both to the Server*

    Serialize the request to scalar and escape newline chars with `\n`.
    Append the newline terminator and send it to the server.

-   *Unpack Request Data*

    The server takes the request scalar, removes the trailing newline
    terminator, and unpacks the request data into a local hash that
    contains the function name, the calling context, and the argument
    list.

-   *Server-side Function Call*

    Find and call the required function in appropriate context. Take the
    result data or the error. Create a result container with separate
    fields for scalar and array contexts and one field for any error.

-   *Pack Result Data*

    Serialize the result hash, escape newlines, append a terminating
    newline, and send the result data to the client.

-   *Client Unpack of the Result Data*

    When the client receives the result container, remove the trailing
    newline char. Unescape any newline chars and unpack the data into a
    local result hash. Depending on the calling context, return to the
    caller either the scalar or array field from the result hash or die
    with an error description if such exists.

The implementation uses two modules:

-   [`Storable`](http://search.cpan.org/perldoc?Storable) handles the
    serialization of arbitrary data. Serializing data converts it to a
    string of characters suitable for saving or sending across the
    network and unserializable later into the form of the original. The
    rest of the article will also refer to this process as packing and
    unpacking the data.
-   [IO::Socket::INET](http://search.cpan.org/perldoc?IO::Socket::INET)
    handles the creation of Internet domain sockets.

Both modules are standard in the latest Perl distribution packages.

It is possible to use any serialization module including FreezeThaw,
XML::Dumper, or even Data::Dumper + `eval()` instead of Storable.

### Point of No Return

Enough background. Here's the PerlRC implementation of the server:

      use Storable qw( thaw nfreeze );
      use IO::Socket::INET;
      
      # function table, maps caller names to actual server subs
      our %FUNC_MAP = (
                      power => \&power,
                      range => \&range,
                      tree  => \&tree,
                      );                                
      
      # create listen socket
      my $sr = IO::Socket::INET->new( Listen    => 5,
                                      LocalAddr => 'localhost:9999',
                                      ReuseAddr => 1 );
      
      while(4)
        {
        # awaiting connection
        my $cl = $sr->accept() or next; # accept new connection or loop on error
      
        while( my $req = <$cl> ) # read request data, exit loop on empty request
          {
          chomp( $req );
          my $thaw = thaw( r_unescape( $req ) ); # 'unpack' request data (\n unescape)
          my %req = %{ $thaw || {} };            # copy to local hash
          
          my %res;                                # result data
          my $func = $FUNC_MAP{ $req{ 'NAME' } }; # find required function
          if( ! $func ) # check if function exists
            {
            # function name is not found, return error
            $res{ 'ERROR' } = "No such function: " . $req{ 'NAME' };
            }
          else
            {
            # function exists, proceed with execution
            my @args = @{ $req{ 'ARGS' } }; # copy to local arguments hash
            if( $req{ 'WANTARRAY' } )       # depending on the required context...
              {
              my @ret = &$func( @args );    # call function in array context
              $res{ 'RET_ARRAY' } = \@ret;  # return array
              }
            else
              {
              my $ret = &$func( @args );    # call function in scalar context
              $res{ 'RET_SCALAR' } = $ret;  # return scalar
              }  
            }
          
          my $res = r_escape( nfreeze( \%res ) ); # 'pack' result data (\n escape)
          print $cl "$res\n";                     # send result data to the client
          }
        }

The client side is also simple:

      use Storable qw( thaw nfreeze );
      use IO::Socket::INET;
      
      # connect to the server
      my $cl = IO::Socket::INET->new(  PeerAddr => "localhost:9999" ) 
           or die "connect error\n";
      
      # this is interface sub to calling server
      sub r_call
      {
        my %req; # request data
        
        $req{ 'NAME' }      = shift;             # function name to call
        $req{ 'WANTARRAY' } = wantarray ? 1 : 0; # context hint
        $req{ 'ARGS' }      = \@_;               # arguments
        
        my $req = r_escape( nfreeze( \%req ) );  # 'pack' request data (\n escape)
        print $cl "$req\n";                      # send to the server
        my $res = <$cl>;                         # get result line
        chomp( $res );
          
        my $thaw = thaw( r_unescape( $res ) );   # 'unpack' result (\n unescape)
        my %res = %{ $thaw || {} };              # copy result data to local hash
        
        # server error -- break execution!
        die "r_call: server error: $res{'ERROR'}\n" if $res{ 'ERROR' };
        
        # finally return result in the required context
        return wantarray ? @{ $res{ 'RET_ARRAY' } } : $res{ 'RET_SCALAR' };
      }

On both sides there are two very simple functions that escape and
unescape newline chars. This is necessary to prevent serialized data
that contains newline chars from breaking the chosen packet terminator.
(A newline works well there because it interacts well with the
`readline()` operation on the socket.)

      sub r_escape
      {
        my $s = shift;
        # replace all newlines, CR and % with CGI-style encoded sequences
        $s =~ s/([%\r\n])/sprintf("%%%02X", ord($1))/ge;
        return $s;
      }
      
      sub r_unescape
      {
        my $s = shift;
        # convert back escapes to the original chars
        $s =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/ge;
        return $s;
      }

### Waiting In The Wings

That's the client and server. Now they need to do something useful.
Here's some code to run on the server from a client:

      =head2 power()
       
       arguments: a number (n) and power (p)
         returns: the number powered (n**p)
         
      =cut
      
      sub power
      {
        my $n = shift;
        my $p = shift;
        return $n**$p;
      }
      
      =head2 range( f, t )
       
       arguments: lower (f) and upper indexes (t)
         returns: array with number elements between the lower and upper indexes
                  ( f .. t )
      =cut         
      
      sub range
      {
        my $f = shift;
        my $t = shift;
        return $f .. $t;
      }
      
      =head2 tree()
       
       arguments: none
         returns: in scalar context: hash reference to data tree
                  in array  context: hash (array) of data tree
           usage:
                  $data = tree(); $data->{ ... }
                  %data = tree(); $data{ ... }
      =cut
      
      sub tree
      {
        my $ret = {
                  this => 'is test',
                  nothing => [ qw( ever goes as planned ) ],
                  number_is => 42,
                  };
        return wantarray ? %$ret : $ret;
      }

To make these available to clients, the server must have a map of
functions. It's easy:

      # function table, maps caller names to actual server subs
      our %FUNC_MAP = (
                      power => \&power,
                      range => \&range,
                      tree  => \&tree,
                      );

That's all of the setup for the server. Now you can start it.

The client side calls functions in this way:

      r_call( 'test',  1, 2, 3, 'opa' );  # this will receive 'not found' error
      my $r = r_call( 'power',  2,  8 );  # $r = 256
      my @a = r_call( 'range', 12, 18 );  # @a = ( 12, 13, 14, 15, 16, 17, 18 )
      my %t = r_call( 'tree' );           # returns data as hash
      my $t = r_call( 'tree' );           # returns data as reference
      
      print( "Tree is:\n" . Dumper( \%t ) );
      # this will print:

      Tree is:
      $VAR1 = {
                'number_is' => 42,
                'nothing' => [
                               'ever',
                               'goes',
                               'as',
                               'planned'
                             ],
                'this' => 'is test'
              };
      
      # and will be the same as 
      print( "Tree is:\n" . Dumper( $t ) );

### One Wish

At this point everything works, but as usual, someone will want another
feature. Suppose that the server and the client sides each had one wish.

The server side wish may be to have a built-in facility to find callable
functions so as to build the function map can be built automatically.

Automatic map discovery has one major flaw which is that all functions
in the current package are available to the client. This may not be
always desirable. There are simple solutions to the problem. For
example, all functions that need external visibility within a package
could have a specific name prefix. A map discovery procedure can filter
the list of all functions with this prefix and map those externally
under the original names (without the prefix).

The following code finds all defined functions in the current namespace
(the one that called `r_map_discover()`) and returns a hash with
function-name keys and function-code-reference values:

      sub r_map_discover
      {
        my ( $package ) = caller(); # get the package name of the caller
        my $prefix = shift;         # optional prefix
        my %map;

        # disable check for symbolic references
        no strict 'refs';

        # loop over all entries in the caller package's namespace
        while( my ( $k, $v ) = each %{ $package . '::' } ) 
          {
          my $sym = $package . '::' . $k; # construct the full name of each symbol
          next unless $k =~ s/^$prefix//; # allow only entries starting with prefix
          my $r = *{ $sym }{ 'CODE' };    # take reference to the CODE in the glob
          next unless $r;  # reference is empty, no code under this name, skip
          $map{ $k } = $r; # reference points to CODE, assign it to the map
          }
        return %map;
      }

To make the use automatic discovery instead of a static function map,
write:

      # function table, maps caller names to actual server subs, initially empty
      our %FUNC_MAP;

      # run the automatic discovery function
      %FUNC_MAP = r_map_discover();

Now `%FUNC_MAP` has all of the externally-visible functions in the
current package (namespace). That means it's time to modify the names in
the module to work with automatic discovery. Suppose the prefix is `x_`:

      sub x_power
      {
        ...
      }
      
      sub x_range
      {
        ...
      }

The server will discover only those functions:

    %FUNC_MAP = r_map_discover( 'x_' );

and the client will continue to call functions under their usual names:

      my $r = r_call( 'power',  2,  8 );  # $r = 256
      my @a = r_call( 'range', 12, 18 );  # @a = ( 12, 13, 14, 15, 16, 17, 18 )

That's it for the server's wish. Now it's time to grant the client's
wish.

Call remote functions transparently might be most important client wish,
avoiding the use of `r_call()`.

Perl allows the creation of anonymous function references. It's also
possible to install that reference in a namespace under a real name. The
result is a function created at run-time. If the function definition
takes place in a specific lexical context, it will still have access to
that context even when called later from outside that context. Those
functions are closures and they are one way to avoid using `r_call()`:

      sub r_define_subs
      {
        my ( $package ) = caller(); # get the package name of the caller
        for my $fn ( @_ )           # loop over the specified function names
          {
          my $sym = $package . '::' . $fn;    # construct the full symbol name
          no strict;                          # turn off symbolic refs check
          *$sym = sub { r_call( $fn, @_ ); }; # construct and tie the closure
          use strict;                         # turn the check back on
          }
      }
      
      # define/import 'range' and 'tree' functions in the current package
      r_define_subs( 'range', 'tree' );
      
      # now call them as they are normal functions
      my @a = range( 12, 18 );      # @a = ( 12 .. 18 )
      my %t = tree();               # returns data as reference

This approach hides the use of `r_call()` to only one place which the
client doesn't see. Wish granted.

### Limits

The biggest limitations of PerlRC relate to serialization.

First of all, both the client and server must have compatible
serialization modules or versions. This is crucial! To avoid problems
here, either you'll have to write your own serialization code or perform
some kind of version check. If you perform this check, be sure to do it
before sending a request and response, in plain text, without using
serialization at all.

Another problem is in what data you can serialize in the argument or
result containers. Holding references there to something outside the
same container may pull in more data than you want, if your
serialization follows references, or it may not pull in enough data if
your serialization process is very simple. Also there is no way to
serialize file handles, compiled code, or objects (which are not in the
same container really). In some cases, serializing code and objects may
be possible if the serialization modules supports such features (as do
Storable and FreezeThaw), if you have the required class modules on both
sides, and if you trust code on either side.

The documentation of the serialization modules explain further
limitations and workarounds for both approaches.

### Conclusion

There is a bit more work to do on PerlRC before using it in production,
but if you need simple RPC or you need to tweak the way RPC deals with
data or communication, you may have good experiences writing your own
implementation instead fitting your application around readymade
modules. I hope this text is a good starting point.


