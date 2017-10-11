{
   "date" : "2001-01-29T00:00:00-08:00",
   "tags" : [],
   "slug" : "/pub/2001/01/soap",
   "draft" : null,
   "authors" : [
      "paul-kulchenko"
   ],
   "image" : null,
   "title" : "Quick Start with SOAP",
   "description" : "Quick Start with SOAP -> Table of Contents ÂQuick Start with SOAPÂWriting a CGI-based ServerÂClientÂPassing ValuesÂAutodispatchingÂObjects accessÂError handlingÂService dispatch (different services on one server)ÂTypes and NamesÂConclusion Part 2 of this series SOAP (Simple Object Access Protocol) is a way for...",
   "thumbnail" : null,
   "categories" : "web"
}





\

+-----------------------------------------------------------------------+
| Table of Contents                                                     |
+-----------------------------------------------------------------------+
| â¢[Quick Start with SOAP](#quick%20start%20with%20soap)\               |
| â¢[Writing a CGI-based Server](#writing%20a%20cgibased%20server)\      |
| â¢[Client](#client)\                                                   |
| â¢[Passing Values](#passing%20values)\                                 |
| â¢[Autodispatching](#autodispatching)\                                 |
| â¢[Objects access](#objects%20access)\                                 |
| â¢[Error handling](#error%20handling)\                                 |
| â¢[Service dispatch (different services on one                         |
| server)](#service%20dispatch%20(different%20services%20on%20one%20ser |
| ver))\                                                                |
| â¢[Types and Names](#types%20and%20names)\                             |
| â¢[Conclusion](#conclusion)\                                           |
| \                                                                     |
| **[Part 2 of this series](/media/_pub_2001_01_soap/soap.html)**       |
+-----------------------------------------------------------------------+

SOAP (Simple Object Access Protocol) is a way for you to remotely make
method calls upon classes and objects that exist on a remote server.
It's the latest in a long series of similar projects like CORBA, DCOM,
and XML-RPC.

SOAP specifies a standard way to encode parameters and return values in
XML, and standard ways to pass them over some common network protocols
like HTTP (web) and SMTP (email). This article, however, is merely
intended as a quick guide to writing SOAP servers and clients. We will
hardly scratch the surface of what's possible.

We'll be using the **SOAP::Lite** module from CPAN. Don't be mislead by
the "Lite" suffix--this refers to the effort it takes to use the module,
not its capabilities.

### [Writing a CGI-based Server]{#writing a cgibased server}

[Download source files mentioned in this article
here.](/media/_pub_2001_01_soap/SOAP-Lite-guide.tar.gz)

Here's a simple CGI-based SOAP server (hibye.cgi):

     #!perl -w

      use SOAP::Transport::HTTP;

      SOAP::Transport::HTTP::CGI   
        -> dispatch_to('Demo')     
        -> handle;

      package Demo;

      sub hi {                     
        return "hello, world";     
      }

      sub bye {                    
        return "goodbye, cruel world";
      }

+-----------------------------------------------------------------------+
| --------------------------------------------------------------------- |
| ---                                                                   |
|                                                                       |
| \                                                                     |
| ****                                                                  |
| [Paul Kulchenko](/pub/au/Kulchenko_Paul) is a featured speaker at the |
| upcoming O'Reilly Open Source Convention in San Diego, CA, July 23 -  |
| 27, 2001. Take this opportunity to rub elbows with open source        |
| leaders while relaxing in the beautiful setting of the beach-front    |
| Sheraton San Diego Hotel and Marina. For more information, visit our  |
| [conference home page](http://conferences.oreilly.com/oscon/). You    |
| can register online.                                                  |
|                                                                       |
| --------------------------------------------------------------------- |
| ---                                                                   |
|                                                                       |
| \                                                                     |
+-----------------------------------------------------------------------+

There are basically two parts to this: the first four lines set up a
SOAP wrapper around a class. Everything from 'package Demo' onward is
the class being wrapped.

In the previous version of specification (1.0), SOAP over HTTP was
supposed to use a new HTTP method, M-POST. Now it's common to try a
normal POST first, and then use M-POST if the server needs it. If you
don't understand the difference between POST and M-POST, don't worry,
you don't need to know all the specific details to be able to use the
module.

### [Client]{#client}

This client prints the results of the `hi()` method call (hibye.pl):

     #!perl -w
      
      use SOAP::Lite;

      print SOAP::Lite                                             
        -> uri('http://www.soaplite.com/Demo')                                             
        -> proxy('http://services.soaplite.com/hibye.cgi')
        -> hi()                                                    
        -> result;

The [`uri()`](#item_uri) identifies the class to the server, and the
[`proxy()`](#item_proxy) identifies the location of the server itself.
Since both look like URLs, I'll take a minute to explain the difference,
as it's **quite important**.

**[`proxy()`]{#item_proxy}**\

:   [`proxy()`](#item_proxy) is simply the address of the server to
    contact that provides the methods. You can use http:, mailto:, even
    ftp: URLs here.

**[`uri()`]{#item_uri}**\

:   Each server can offer many different services through the one
    proxy() URL. Each service has a unique URI-like identifier, which
    you specify to SOAP::Lite through the uri() method. If you get
    caught up in the gripping saga of the SOAP documentation, the
    "namespace" corresponds to the uri() method.

<!-- -->

If you're connected to the Internet, you can run your client, and you
should see:

     hello, world

That's it!

If your method returns multiple values (hibye.cgi):

     #!perl -w

      use SOAP::Transport::HTTP;

      SOAP::Transport::HTTP::CGI      
        -> dispatch_to('Demo')        
        -> handle;

      package Demo;

      sub hi {                        
        return "hello, world";        
      }

      sub bye {                       
        return "goodbye, cruel world";
      }

      sub languages {                 
        return ("Perl", "C", "sh");   
      }

Then the `result()` method will only return the first. To access the
rest, use the `paramsout()` method (hibyeout.pl):&gt;

     #!perl -w

      use SOAP::Lite;

      $soap_response = SOAP::Lite                                  
        -> uri('http://www.soaplite.com/Demo')                                             
        -> proxy('http://services.soaplite.com/hibye.cgi')
        -> languages();

      @res = $soap_response->paramsout;

      $res = $soap_response->result;                               
      print "Result is $res, outparams are @res\n";

This code will produce:

     Result is Perl, outparams are Perl C sh

### [Passing Values]{#passing values}

Methods can take arguments. Here's a SOAP server that translates between
Fahrenheit and Celsius (temper.cgi):

     #!perl -w

      use SOAP::Transport::HTTP;

      SOAP::Transport::HTTP::CGI
        -> dispatch_to('Temperatures')
        -> handle;

      package Temperatures;

      sub f2c {
          my ($class, $f) = @_;
          return 5 / 9 * ($f - 32);
      }

      sub c2f {
          my ($class, $c) = @_;
          return 32 + $c * 9 / 5;
      }

And here's a sample query (temp.pl):

     #!perl -w

      use SOAP::Lite;

      print SOAP::Lite                                            
        -> uri('http://www.soaplite.com/Temperatures')                                    
        -> proxy('http://services.soaplite.com/temper.cgi')
        -> c2f(37.5)                                              
        -> result;

You can also create an object representing the remote class, and then
make method calls on it (tempmod.pl):

     #!perl -w

      use SOAP::Lite;

      my $soap = SOAP::Lite                                        
        -> uri('http://www.soaplite.com/Temperatures')                                     
        -> proxy('http://services.soaplite.com/temper.cgi');

      print $soap                                                  
        -> c2f(37.5)                                               
        -> result;

### [Autodispatching]{#autodispatching}

This being Perl, there's more than one way to do it: SOAP::Lite provides
an alternative client syntax (tempauto.pl).

     #!perl -w

      use SOAP::Lite +autodispatch =>

        uri => 'http://www.soaplite.com/Temperatures',
        proxy => 'http://services.soaplite.com/temper.cgi';

      print c2f(37.5);

After you specify the uri and proxy parameters, you are able to call
remote functions with the same syntax as local ones (e.g., c2f). This is
done with UNIVERSAL::AUTOLOAD, which catches all unknown method calls.
Be warned that **all** calls to undefined methods will result in an
attempt to use SOAP.

### [Objects access (it's 'Simple **Object** access protocol', isn't it?)]{#objects access}

Methods can also return real objects. Let's extend our `Temperatures`
class with an object-oriented interface (temper.cgi):

     #!perl -w

      use SOAP::Transport::HTTP;

      SOAP::Transport::HTTP::CGI
        -> dispatch_to('Temperatures')
        -> handle;

      package Temperatures;

      sub f2c {
          my ($class, $f) = @_;
          return 5/9*($f-32);
      }

      sub c2f {
          my ($class, $c) = @_;
          return 32+$c*9/5;
      }

      sub new {
          my $self = shift;
          my $class = ref($self) || $self;
          bless {_temperature => shift} => $class;
      }

      sub as_fahrenheit {
          return shift->{_temperature};
      }

      sub as_celsius {
          my $self = shift;
          return $self->f2c( $self->{_temperature} );
      }

Here is a client that accesses this class (tempobj.pl):

     #!perl -w
      
      use SOAP::Lite;

      my $soap = SOAP::Lite
        -> uri('http://www.soaplite.com/Temperatures')
        -> proxy('http://services.soaplite.com/temper.cgi');

      my $temperatures = $soap
        -> call(new => 100) # accept Fahrenheit  
        -> result;

      print $soap
        -> as_celsius($temperatures)
        -> result;

Similar code with autodispatch is shorter and easier to read
(tempobja.pl):

     #!perl -w

      use SOAP::Lite +autodispatch =>
        uri => 'http://www.soaplite.com/Temperatures',
        proxy => 'http://services.soaplite.com/temper.cgi';

      my $temperatures = Temperatures->new(100);
      print $temperatures->as_fahrenheit();

### [Error handling]{#error handling}

A SOAP call may fail for numerous reasons, such as transport error,
incorrect parameters, or an error on the server. Transport errors (which
may occur if, for example, there is a network break between the client
and the server) are dealt with below. All other errors are indicated by
the `fault()` method (temperr.pl):

     #!perl -w

      use SOAP::Lite;

      my $soap = SOAP::Lite
        -> uri('http://www.soaplite.com/Temperatures')
        -> proxy('http://services.soaplite.com/temper.cgi');

     my $result = $soap->c2f(37.5);

      unless ($result->fault) {
        print $result->result();
      } else {
        print join ', ', 
          $result->faultcode, 
          $result->faultstring, 
          $result->faultdetail;
      }

`faultcode()` gives you information about the main reason for the error.
Possible values may be:

**[Client: you provided incorrect information in the request.]{#item_client%3a_you_provided_incorrect_information_in_th}**\

:   This error may occur when parameters for the remote call are
    incorrect. Parameters may be out-of-bounds, such as negative
    numbers, when positive integers are expected; or of an incorrect
    type, for example, a string is provided where a number was expected.

**[Server: something is wrong on the server side.]{#item_server%3a_something_is_wrong_on_the_server_side%2e}**\

:   This means that provided information is correct, but the server
    couldn't handle the request because of temporary difficulties, for
    example, an unavailable database.

**[MustUnderstand: Header elements has mustUnderstand attribute, but wasn't understood by server.]{#item_mustunderstand%3a_header_elements_has_mustundersta}**\

:   The server was able to parse the request, but the client is
    requesting functionality that can't be provided. For example,
    suppose that a request requires execution of SQL statement, and the
    client wants to be sure that several requests will be executed in
    one database transaction. This could be implemented as three
    different calls with one common TransactionID.

    In this case, the SOAP header may be extended with a new header
    element called, say, 'TransactionID', which carries a common
    identifier across the 3 separate invocations. However, if server
    does not understand the provided TransactionID header, it probably
    won't be able to maintain transactional integrity across
    invocations. To guard against this, the client may indicate that the
    server 'mustUnderstand' the element 'TransactionID'. If the server
    sees this and does NOT understand the meaning of the element, it
    will not try and process the requests in the first place.

    This functionality makes services more reliable and distributed
    systems more robust.

**[VersionMismatch: the server can't understand the version of SOAP used by the client.]{#item_versionmismatch%3a_the_server_can%27t_understand_t}**\

:   This is provided for (possible) future extensions, when new versions
    of SOAP may have different functionality, and only clients that are
    knowledgeable about it will be able to properly use it.

**[Other errors]{#item_other_errors}**\

:   The server is allowed to create its own errors, like
    **Client.Authentication**.

`faultstring()` provides a readable explanation, whereas `faultdetail()`
gives access to more detailed information, which may be a string,
object, or more complex structure.

For example, if you change **uri** to something else (let's try with
`'Test'` instead of `'Temperatures'`), this code will generate:

     Client, Bad Class Name, Failed to access class (Test)

By default client will **die with diagnostic** on *transport errors* and
**do nothing** for *faulted calls*, so, you'll be able to get fault info
from result. You can alter this behavior with `on_fault()` handler
either per object, so it will die on both transport errors and SOAP
faults (temperrh.pl):

     #!perl -w

      use SOAP::Lite;

      my $soap = SOAP::Lite
        -> uri('http://www.soaplite.com/Temperatures')
        -> proxy('http://services.soaplite.com/temper.cgi')

        -> on_fault(sub { my($soap, $res) = @_; 
             die ref $res ? $res->faultdetail : $soap->transport->status, "\n";
           });

Or you can set it globally (temperrg.pl):

     #!perl -w

      use SOAP::Lite

        on_fault => sub { my($soap, $res) = @_; 
          die ref $res ? $res->faultdetail : $soap->transport->status, "\n";
        };

      my $soap = SOAP::Lite
        -> uri('http://www.soaplite.com/Temperatures')
        -> proxy('http://services.soaplite.com/temper.cgi');

Now, wrap your SOAP call into an `eval {}` block, and catch both
transport errors and SOAP faults (temperrg.pl):

     #!perl -w

      use SOAP::Lite

        on_fault => sub { my($soap, $res) = @_; 
          die ref $res ? $res->faultdetail : $soap->transport->status, "\n";
        };

      my $soap = SOAP::Lite
        -> uri('http://www.soaplite.com/Temperatures')
        -> proxy('http://services.soaplite.com/temper.cgi');

      eval { 
        print $soap->c2f(37.5)->result; 
      1 } or die;

You may also consider this variant that will return `undef` and setup
`$!` on failure, just like many Perl functions do (temperrv.pl):

     #!perl -w

      use SOAP::Lite
        on_fault => sub { my($soap, $res) = @_; 
          eval { die ref $res ? $res->faultdetail : $soap->transport->status };
          return ref $res ? $res : new SOAP::SOM;
        };

      my $soap = SOAP::Lite
        -> uri('http://www.soaplite.com/Temperatures')
        -> proxy('http://services.soaplite.com/temper.cgi');

      defined (my $temp = $soap->c2f(37.5)->result) or die;

      print $temp;

And finally, if you want to ignore errors (however, you can still check
for them with the `fault()` method call):

     use SOAP::Lite
        on_fault => sub {};

or

     my $soap = SOAP::Lite
        -> on_fault(sub{})
        ..... other parameters

### [Service dispatch (different services on one server)]{#service dispatch (different services on one server)}

So far our CGI programs have had a single class to handle incoming SOAP
calls. But we might have one CGI program that dispatches SOAP calls to
many classes.

What exactly is **SOAP dispatch**? When a SOAP request is recieved by a
server, it gets bound to the class specified in the request. The class
could be already loaded on server side (on server startup, or as a
result of previous calls), or might be loaded on demand, according to
server configuration. **Dispatching** is the process of determining of
which class should handle a given request, and loading that class, if
necessary. **Static** dispatch means that name of the class is specified
in configuration, whereas **dynamic** means that only a pool of classes
is specified, in, say, a particular directory, and that any class from
this directory can be accessed.

Imagine that you want to give access to two different classes on the
server side, and want to provide the same 'proxy' address for both. What
should you do? Several options are available:

**[Static internal]{#item_static_internal}**\

:   ... Which you are already familiar with (hibye.cgi):

          use SOAP::Transport::HTTP;

          SOAP::Transport::HTTP::CGI   
            -> dispatch_to('Demo')     
            -> handle;

          package Demo;

          sub hi {                     
            return "hello, world";     
          }

          sub bye {                    
            return "goodbye, cruel world";
          }

          1;

**[Static external]{#item_static_external}**\

:   Similar to [`Static    internal`](#item_Static_internal), but the
    module is somewhere outside of server code (hibyeout.cgi):

          use SOAP::Transport::HTTP;

          use Demo;

          SOAP::Transport::HTTP::CGI   
            -> dispatch_to('Demo')     
            -> handle;

    The following module should, of course, be somewhere in a directory
    listed in @INC (Demo.pm):

         package Demo;

          sub hi {                     
            return "hello, world";     
          }

          sub bye {                    
            return "goodbye, cruel world";
          }

          1;

**[Dynamic]{#item_dynamic}**\

:   As you can see in both [`Static    internal`](#item_Static_internal)
    and [`Static    external`](#item_Static_external) modes, the module
    name is hardcoded in the server code. But what if you want to be
    able to add new modules dynamically without altering the server?
    Dynamic dispatch allows you to do it. Specify a directory, and any
    module in this directory becomes available for dispatching
    (hibyedyn.cgi):

         #!perl -w

          use SOAP::Transport::HTTP;

          SOAP::Transport::HTTP::CGI

            -> dispatch_to('/home/soaplite/modules')

            -> handle;

    Then put `Demo.pm` in `/home/soaplite/modules` directory (Demo.pm):

         package Demo;

          sub hi {                     
            return "hello, world";     
          }

          sub bye {                    
            return "goodbye, cruel world";
          }

          1;

    That's it. **Any** module you put in `/home/soaplite/modules` is
    available now, but don't forget that the URI specified on the client
    side should match module/class name you want to dispatch your call
    to.

**[Mixed]{#item_mixed}**\

:   What do we need this for? Unfortunately, dynamic dispatch also has a
    significant disadvantage: Access to @INC is disabled for the
    purposes of dynamic dispatch, for security reasons. To work around
    this, you can combine dynamic and static approaches. All you need to
    do is this (hibyemix.cgi):

         #!perl -w

          use SOAP::Transport::HTTP;

          SOAP::Transport::HTTP::CGI

            -> dispatch_to('/home/soaplite/modules', 'Demo', 'Demo1', 'Demo2')

            -> handle;

    Now Demo, Demo1, and Demo2 are pre-loaded from anywhere in @INC, but
    dynamic access is enabled for any modules in
    `/home/soaplite/modules`, and they'll be loaded on demand.

### [Types and Names]{#types and names}

So far as Perl is typeless language (in a sense that there is no
difference between integer `123` and string `'123'`), it greatly
simplifies the transformation process from SOAP message to Perl data.
For most simple data, we can just ignore typing at this stage. However,
this approach has drawbacks also: we need to provide additional
information during generation of our SOAP message, because the other
server or client may expect type information. SOAP::Lite doesn't force
you to type every parameter explicitly, but instead tries to guess each
data type based on actual values in question (according to another of
Perl's mottos, DWIM, or 'Do What I Mean').

For example, a variable that has the value `123` becomes an element of
type `int` in a SOAP message, and a variable that has the value `'abc'`
becomes type `string`. However, there are more complex cases, such as
variables that contain binary data, which must be Base64-encoded, or
objects (blessed references), as another example, which are given type
and name (unless specified) according to their Perl package.

The autotyping may not work in all cases, though. There is no default
way to make an element with type `string` or type `long` from a value of
`123`, for example. You may alter this behavior in several ways. First,
you may disable autotyping completely (by calling the `autotype()` with
a value of 0), or change autotyping for different types.

Alternately, you may use objects from the SOAP::Data class to explicitly
specify a type for a particular variable:

     my $var = SOAP::Data->type( string => 123 );

`$var` becomes an element with type `string` and value `123`. You may
use this variable in ANY place where you use ordinary Perl variables in
SOAP calls. This also allows you to provide not only specific **data
types**, but also specific **name** and **attributes**.

Since many services count on **names** of parameters (instead of
**positions**) you may specify names for request parameters using the
same syntax. To add a name to `$var` variable, call
`$var->name('myvar')`, or even chain calls with the `type()` method:

     my $var = SOAP::Data->type(string => 123)->name('myvar');

      # -- OR --
      my $var = SOAP::Data->type('string')->name(myvar => 123);

      # -- OR --
      my $var = SOAP::Data->type('string')->name('myvar')->value(123);

You may always get or set the value of a variable with `value()` method:

     $var->value(321);            # set new value

      my $realvalue = $var->value; # store it in variable

### [Conclusion]{#conclusion}

This should be enough to get you started building SOAP applications. You
can read the manpages (or even the source, if you're brave!) to learn
more, and don't forget to keep checking
[www.soaplite.com](http://www.soaplite.com/) for more documentation,
examples, and SOAP-y fun.

**Part 2 of this article can be found
[here](/media/_pub_2001_01_soap/soap.html)**

------------------------------------------------------------------------

Major contributors:

**[Nathan Torkington]{#item_nathan_torkington}**\

:   Basically started this work and pushed the whole process.

**[Tony Hong]{#item_tony_hong}**\

:   Invaluable comments and input help me keep this material fresh and
    simple.

    This piece continues [here](/media/_pub_2001_01_soap/soap.html)


