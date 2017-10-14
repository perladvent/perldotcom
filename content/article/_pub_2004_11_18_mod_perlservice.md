{
   "thumbnail" : null,
   "description" : "Mod_perlservice? What is That? Mod_perlservice is a cool, new way to do remoting - sharing data between server and client processes - with Perl and Apache. Let's start by breaking that crazy name apart: mod + perl + service. Mod...",
   "slug" : "/pub/2004/11/18/mod_perlservice.html",
   "title" : "Cross-Language Remoting with mod_perlservice",
   "authors" : [
      "michael-collins"
   ],
   "date" : "2004-11-18T00:00:00-08:00",
   "image" : null,
   "categories" : "Networking",
   "tags" : [
      "michael-w-collins",
      "mod-perl",
      "mod-perlservice",
      "perl-remoting",
      "perl-server"
   ],
   "draft" : null
}





### Mod\_perlservice? What is That?

`Mod_perlservice` is a cool, new way to do remoting -- sharing data
between server and client processes -- with Perl and Apache. Let's start
by breaking that crazy name apart: mod + perl + service.

*Mod* means that it's a module for the popular and ubiquitous Apache
HTTP Server. *Perl* represents the popular and ubiquitous programming
language. *Service* is the unique part. It's the new ingredient that
unifies Apache, Perl, and XML into an easy-to-use web services system.

With mod\_perlservice, you can write Perl subs and packages on your
server and call them over the internet from client code. Clients can
pass scalars, arrays, and hashes to the server-side subroutines and
obtain the return value (scalar, array, or hash) back from the remote
code. Some folks refer to this functionality as "remoting" or "RPC," so
if you like you can say mod\_perlservice is remoting with Perl and
Apache. You can write client programs in a variety of languages;
libraries for C, Perl, and Flash Action Script are all ready to go.

Now that you know what mod\_perlservice is, let's look at why it is. I
believe that mod\_perlservice has a very clean, easy-to-use interface
when compared with other RPC systems. Also, because it builds on the
Apache platform it benefits from Apache's ubiquity, security, and status
as a standard. Mod\_perlservice sports an embedded Perl interpreter to
offer high performance for demanding applications.

![mod\_perlservice](/images/_pub_2004_11_18_mod_perlservice/mod_perlservicelogo.jpg){width="200"
height="120"}
### How Can I Use mod\_perlservice?

Mod\_perlservice helps create networked applications that require
client-server communication, information processing, and sharing.
Mod\_perlservice is for applications, not for creating dynamic content
for your HTML pages. However, you surely can use it for Flash remoting
with Perl. Here are some usage examples:

-   A desktop application (written using your favorite C++ GUI library)
    that records the current local air temperature and sends it to an
    online database every 10 minutes. Any client can query the server to
    obtain the current and historical local air temperature of any other
    participating client.
-   A Flash-based stock portfolio management system. You can create
    model stock portfolios and retrieve real-time stock quote
    information and news.
-   A command-line utility in Perl that accepts English sentences on
    standard input and outputs the sentences in French. Translation
    occurs in server-side Perl code. If the sentence is idiomatic and
    the translation is incorrect, the user has the option of sending the
    server a correct translation to store in an online idiom database.

### How Do I Start?

Let's move on to the fun stuff and set up a working installation. Before
we begin, make sure you have everything you need! You need [Apache
HTTPD](http://httpd.apache.org/), [Perl](http://www.perl.org/),
[Expat](http://expat.sourceforge.net/),
[mod\_perlservice](http://www.ivorycity.com/mod_perlservice/), and a
mod\_perlservice client library ([Perl
Client](http://www.ivorycity.com/mod_perlservice/perl_client.html) | [C
Client](http://www.ivorycity.com/mod_perlservice/c_client.html) | [Flash
Client](http://www.ivorycity.com/mod_perlservice/flash_client.html)).
You must download a client library separately, as the distribution does
not include any clients! In your build directory:

    myhost$ tar -xvzf mod_perlservice.tar.gz 
    myhost$ cd mod_perlservice
    myhost$ ./configure
    myhost$ make
    myhost$ make install

If everything goes to plan, you'll end up with a fresh
*mod\_perlservice.so* in your Apache modules directory, (usually
*/etc/apache/modules*). Now it's time to configure Apache to use
mod\_perlservice. `cd` into your Apache configuration directory (usually
*/etc/apache/conf*) Add the following lines to the file *apache.conf*
(or *httpd.conf*, if you have only a single configuration file):

    LoadModule perlservice_module modules/mod_perlservice.so
    AddModule mod_perlservice.c

Add the following lines to *commonapache.conf*, if you have it and
*httpd.conf* if you don't:

    <IfModule mod_perlservice.c>  
    <Location /perlservice>   SetHandler
    mod_perlservice   
       Allow From All PerlApp
       myappname /my/app/dir
       #Examples
       PerlApp stockmarket /home/services/stockmarket   
       PerlApp temperature /home/services/temperature  
    </Location>
    </IfModule>

*Pay close attention to the `PerlApp` directive.* For every
mod\_perlservice application you want to run, you need a `PerlApp`
directive. If I were creating a stock market application, I might create
a directory: */home/services/stockmarket* and add the following
`PerlApp` directive:

    PerlApp stockmarket /home/services/stockmarket

This tells mod\_perlservice to host an application called `stockmarket`
with the Perl code files located in the */home/services/stockmarket*
directory. You may run as many service applications as you wish and you
may organize them however you wish.

With the configuration files updated, the next step is to restart
Apache:

    myhost$ /etc/init.d/apache restart
    or
    myhost$ apachectl restart

Now if everything went as planned, mod\_perlservice should be installed.
Congratulations!

### An Example

Let's create that stock portfolio example mentioned earlier. It won't
support real-time quotes, but will instead create a static database of
common stock names and historical prices. The application will support
stock information for General Electric (GE), Red Hat (RHAT), Coca-Cola
(KO), and Caterpillar (CAT).

The application will be *stockmarket* and will keep all of the Perl
files in the stock market application directory
(*/home/services/stockmarket*). The first file will be *quotes.pm*,
reading as follows:

    our $lookups = {
        "General Electric" => "GE",
        "Red Hat"          => "RHAT",
        "Coca Cola"        => "KO",
        "Caterpillar Inc"  => "CAT"
    };
    our $stocksymbols = {
        "GE" => {
            "Price"            => 33.91,
            "EarningsPerShare" => 1.544
        },
        "RHAT" => {
            "Price" => 14.96,
            "EarningsPerShare" => 0.129
        },
        "KO"   => {
            "Price"            => 42.84,
            "EarningsPerShare" => 1.984
        },
        "CAT" => {
            "Price"            => 75.74,
            "EarningsPerShare" => 4.306
        }
    };

    package quotes;

    sub lookupSymbol {
        my $companyname = shift;
        return $lookups->{$company_name};
    }

    sub getLookupTable {
        return $lookups;
    }

    sub getStockPrice {
        my $stocksymbol = shift;
        return $stocksymbols->{$stocksymbol}->{"Price"};
    }
    sub getAllStockInfo {
        my $stocksymbol = shift;
        return $stocksymbols{$stocksymbol};
    }
    1;

That's the example of the server-side program. Basically, two static
"databases" (`$lookups` and `$stocksymbols`) provide information about a
limited universe of stocks. The above methods query the static
databases; the behavior should be fairly self-explanatory.

You may have as many *.pm* files in your application as you wish and you
may also define as many packages within a *.pm* file as you wish. An
extension to this application might be a file called *news.pm* that
enables you to fetch current and historical news about your favorite
stocks.

Now let's talk some security. As it stands, this code won't work;
mod\_perlservice will restrict access to any file and method you don't
explicitly export for public use. Use the *.serviceaccess* file to
export things. Create this file in each application directory you
declare with mod\_perlservice or you'll have no access. An example file
might read:

    <ServiceAccess>
      <AllowFile name="quotes.pm">
        Allow quotes::*
      </AllowFile>
    </ServiceAccess>

In the stock market example, this file should be
*/home/services/stockmarket/.serviceaccess*. Be sure that the `apache`
user does not own this file; that could be bad for security. This file
allows access to the file *quotes.pm* and allows public access to all
(`*`) the methods in package *quotes*.

If I want to restrict access only to `getStockPrice`, I would have
written `Allow quotes::getStockPrice`. After that, I could add access to
`lookupSymbol` with `Allow quotes::lookupSymbol`. To make *quotes.pm*
public carte blanche, use *Allow \**. You won't need to restart Apache
when you make changes to this file as it reloads automatically.

### Client Code

Well, so far I've only shown you half the story. It's time to create
some client-side code. This client example uses the Flash "PerlService"
library, just one of the client-side interfaces to mod\_perlservice. The
Flash client works well for browser interfaces while the Perl and C
clients can create command-line or GUI (ie, GTK or Qt) applications.
This article is on the web, so we'll give the Flash interface a spin and
then go through an example in Perl.

The first code smidgen should go in the first root frame of your Flash
application. It instantiates the global `PerlService` object and creates
event handlers for when remote method calls return from the server. The
event handlers output the requested stock information to the display
box.

    #include "PerlService-0.0.2.as"
    // Create a global PerlService object
    // Tell the PerlService object about the remote code we want to use:
    // arg1) host: www.ivorycity.com
    // arg2) application: stockmarket
    // arg3) file: quotes.pm
    // arg4) package: quotes
    _global.ps = new PerlService("www.ivorycity.com","stockmarket","quotes.pm","quotes");
    // First declare three callback functions to handle return values
    function onStockPrice(val) { 
        output.text = "StockPrice: " + symbolInput.text + " " + val + "\n" + output.text;
    }

    function onAllStockInfo(val) { 
        output.text = "Stock Info: " + allInfoInput.text + "\n" + "\tPrice: "
                      + val.Price + "\n" + "\tEarnings Per Share: "
                      + val.EarningsPerShare + "\n" + output.text;
    }

    function onLookupSymbol(val) { 
        output.text = "Lookup Result: " + symbolInput.text + " " + val + "\n"
                      + output.text;
    }

    // Register callback handlers for managing return values from remote  methods
    // ie, onStockPrice receives the return value from remote method getStockPrice

    ps.registerReplyHandler( "getStockPrice", onStockPrice );
    ps.registerReplyHandler( "getAllStockInfo", onAllStockInfo );
    ps.registerReplyHandler( "lookupSymbol", onLookupSymbol );

Now for the code that makes things happen. The following code attaches
to three separate buttons. When clicked, the buttons call the remote
Perl methods using the global `PerlService` object. Flash Action Script
is an event-driven system, so click event-handlers will call the remote
code and return event-handlers will do something with those values.

![buttons and code
associations](/images/_pub_2004_11_18_mod_perlservice/flashclientdgm.jpg){width="400"
height="206"}\
*Figure 1. Button and code associations.*

When a user presses Button 1, call the remote method `getStockPrice` and
pass the text in the first input box as an argument.

    on (release) {
        ps.getStockPrice(box1.text);
    }

When the user presses Button 2, call the remote method `getAllStockInfo`
and pass the text in the second input box as an argument.

    on (release) {
        ps.getAllStockInfo(box2.text);
    }

When the user presses Button 3, call the remote method `lookupSymbol`
and pass the text in the third input box as an argument.

    on (release) {
        ps.lookupSymbol(box3.text);
    }

That's the entire Flash example. Here is the finished product.

#### Perl Client

Not everyone uses Flash, especially in the Free Software community. The
great thing about mod\_perlservice is that everyone can join the party.
Here's a Perl Client that uses the same server-side stock market API.

    use PService;

    my $hostname = "www.ivorycity.com";
    my $appname  = "stockmarket";
    my $filename = "quotes.pm";
    my $package  = "quotes";              

    #Create the client object with following arguments:      
    #1) The host you want to use
    #2) The application on the host
    #3) The perl module file name
    #4) The package you want to use

    my $ps = PSClient->new( $hostname, $appname, $filename, $package );

    # Just call those remote methods and get the return value
    my $price  = $ps->getStockPrice("GE");
    my $info   = $ps->getAllStockInfo("RHAT");
    my $lookup = $ps->lookupSymbol("Coca Cola");                   

    #Share your exciting new information with standard output
    print "GE Price: " . $price . "\n";
    print "Red Hat Price: " . $info->{Price} . "\n";
    print "Red Hat EPS: " . $info->{EarningsPerShare} . "\n";
    print "Coca-Cola's ticker symbol is " . $lookup . "\n";

Using the *PSClient* object to call remote methods might feel a little
awkward if you expect to call them via `quotes::getStockPrice()`, but
think of the `$ps` instance as a proxy class to your remote methods, if
you like.

If things don't work, use `print $ps->get_errmsg();` to print an error
message. \$ps-&gt;get\_errmsg(); That's a local reserved function, so it
doesn't call the server. It's one of a few reserved functions detailed
in the [Perl client
reference](http://www.ivorycity.com/mod_perlservice/perl_client.html).

As you can see, it requires much less work to create an example with the
Perl client. You simply instantiate the PSClient object, call the remote
methods, and do something with the return values. That's it. There is no
protocol decoding, dealing with HTTP, CGI arguments, or any of the old
annoyances. Your remote code may as well be local code.

### Thanks for Taking the Tour

That's mod\_perlservice. I'm sure many of you who are developing
client-server applications can see the advantages of this system.
Personally, I've always found the existing technologies to be inflexible
and/or too cumbersome. The mod\_perlservice system offers a clean,
simple, and scalable interface that unites client-side and server-side
code in the most sensible way yet.

What's next? mod\_parrotservice!


