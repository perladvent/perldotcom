{
   "tags" : [
      "apis",
      "telephony"
   ],
   "date" : "2011-09-21T06:00:01-08:00",
   "slug" : "/pub/2011/09/automating-telephony-with-perl-and-twilio",
   "draft" : null,
   "authors" : [
      "scott-wiersdorf"
   ],
   "image" : null,
   "title" : "Automating Telephony with Perl and Twilio",
   "categories" : "Networking",
   "thumbnail" : null,
   "description" : "Perl can make your phone ring. Scott Wiersdorf demonstrates how to use Twilio's API to make and receive phone calls and to automate SMS, all from Perl."
}





Perl can make your phone ring.

[Twilio](http://www.twilio.com/) allows developers to write applications
that can make and receive voice calls or SMS messages (though Twilio can
do many other interesting telephony things). Twilioâs RESTful API,
text-to-speech synthesizer, speech transcription services, and
Javascript client make it easy to knock out a conference call
application, an in-browser customer service voice application, a
weather-by-SMS application, reminder by phoneâanything, reallyâin
minutes. This article shows how to make a couple of small applications,
one to help you pronounce words correctly and the other to transcribe
awkward condiment phone survey answers.

**Twilio Setup**
----------------

First, head over to [Twilio.com](http://www.twilio.com/) and click the
âTry Twilio Freeâ link. While inbound calls cost US \$0.01 per minute
and outbound calls cost US \$0.02 per minute, Twilio has historically
given new users a generous account balance to start with for free
(currently US \$30)âitâs plenty of credit to kick the tires and take it
for a spin.

Go ahead and register (Iâll wait here). When youâve finished, youâll
have an account SID (beginning with âACâ) and an auth token, available
from your Twilio Dashboard. These are your Twilio API username and
password; youâll need them for any API application you write.

**Twilio Basics**
-----------------

The Twilio website is full of well-organized documentation and sample
applications. I recommend starting with âHow It Worksâ (one of the main
navigation links on the home page). Browse the documentation under
âDocsâ as well.

H. H. Munroe said, âA little inaccuracy sometimes saves tons of
explanation.â Keeping that in mind, inbound calls (calls to a Twilio
number) work like this:

![](/images/_pub_2011_09_automating-telephony-with-perl-and-twilio/twilio-inbound.png)\
*Inbound calls to a Twilio number*

1\) the user calls â555-867-5309â on their phone

2\) Twilio accepts the call, then makes an HTTP POST to
http://example.com/jenny.xml

3\) example.com responds with a âTwiMLâ document (TwiML is a simple XML
language that describes how Twilio will interact with callers):

    <?xml version="1.0" encoding="UTF-8" ?>
    <Response>
      <Say voice="woman">This is Jenny!</Say>
    </Response>

4\) Twilioâs TwiML parser and text-to-speech synthesizer read this
document and then says to the user (in a voice from the uncanny valley),
âThis is Jenny!â

When you setup a sandbox number, you tell Twilio to map a URL to that
number. Twilio will GET/POST to that URL when receiving calls.

Outbound calls (calls from a Twilio number) work like this:

![](/images/_pub_2011_09_automating-telephony-with-perl-and-twilio/twilio-outbound.png)\
*Outbound calls from a Twilio number*

1\) An application makes an HTTP POST to Twilioâs âCallsâ API with the
parameters:

    From=+15558675309
    To=+19991234567
    Url=http://example.com/jenny.xml

2\) Twilio places the call and waits for an answer

3\) Once the user answers, Twilio retrieves the URL specified in the POST
(which should return a TwiML document)

4\) Twilio parses the TwiML document and passes it to the text-to-speech
synthesizer

5\) The synthesizer says to the user âThis is Jenny!â

Twilio can also record voice input, transcribe it, send and receive SMS
messages, make conference calls, and a few other useful things, all
using the same familiar RESTful API and TwiML.

**Twilio, meet Perl**
---------------------

CPAN makes writing Twilio applications easy, thanks to
[WWW::Twilio::API](http://search.cpan.org/perldoc?WWW::Twilio::API). My
(current) favorite way to install CPAN modules comes from the
Mojolicious project:

    curl -L cpanmin.us | perl - WWW::Twilio::API

cpanmin.us returns a Perl program which handles all of the build
dependencies for you. If youâre leery of running code from a website
directly on the command line, install
[App::cpanminus](http://search.cpan.org/perldoc?App::cpanminus) and use
its `cpanm` program instead.

If youâre like me and donât want to mess up your clean development
environment, tell cpanmin.us or `cpanm` to install things into a
temporary location:

    $ mkdir ~/perl-test
    $ export PERL5LIB=~/perl-test/lib/perl5
    $ curl -L cpanmin.us | perl - --local-lib=~/perl-test WWW::Twilio::API
    # or
    $ cpanm --local-lib=~/perl-test WWW::Twilio::API

See [How to install CPAN
modules](http://www.cpan.org/modules/INSTALL.html) for more information
and options.

**Getting all the necessary Twilio information**
------------------------------------------------

After you install
[WWW::Twilio::API](http://search.cpan.org/perldoc?WWW::Twilio::API), but
before you make your first call, you need several pieces of information
from your Twilio Dashboard:

-   AccountSid: this is a long string begining with âACâ

-   AuthToken: another long hex string, next to the AccountSid; you may
    have to click a lock icon to reveal it

-   Sandbox number: found on the bottom half of the Dashboard page under
    âSandbox Appâ

Thatâs all! Now youâre ready to go.

**Your first phone call**
-------------------------

Fire up your favorite editor:

    #!/usr/bin/env perl

    use strict;
    use warnings;
    use WWW::Twilio::API;

    my $twilio = WWW::Twilio::API->( AccountSid  => 'ACxxxxxxxxx',
                                     AuthToken   => 'xxxxxxxxxxx',
                                     API_VERSION => '2010-04-01' );

    ## A hollow voice says 'plugh'
    my $response = $twilio->POST( 'Calls',
                                  To   => '+15556667777', ## maybe your cell phone
                                  From => '+12223334444', ## your Twilio sandbox
                                  Url  => 'http://twimlets.com/message?'
                                        . 'Message%5B0%5D=plugh' );

    print STDERR $response->{content};

Thatâs the entire application. Run it, and if all went well, you should
see a long XML string returned which resembles:

    <?xml version="1.0"?>
    <TwilioResponse>
      <Call>
        <To>+15556667777</To>
        <From>+12223334444</From>
        <Status>queued</Status>
        <Direction>outbound-api</Direction>
      </Call>
    </TwilioResponse>

â¦ and then your phone should ring. Iâve always wondered how to pronounce
âplughâânow I know.

**What could possibly go wrong?**
---------------------------------

Early on in Twilio development, youâre likely to experience a few little
gotchas. For example, you might get this message:

    LWP will support https URLs if the LWP::Protocol::https module
    is installed.

Thatâs LWP telling you to install
[LWP::Protocol::https](http://search.cpan.org/perldoc?LWP::Protocol::https).
(It will also install or update a few other modules, including
[Net::SSLeay](http://search.cpan.org/perldoc?Net::SSLeay)).

If you see XML after running the script, your development environment is
probably fine. You might instead see:

    <TwilioResponse>
      <RestException>
        <Status>401</Status>
        <Message>Authenticate</Message>
        <Code>20003</Code>
        <MoreInfo>http://www.twilio.com/docs/errors/20003</MoreInfo>
      </RestException>
    </TwilioResponse>

Notice the â401â? If youâre familiar with [HTTP status
codes](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html), you
might remember that 401 means âUnauthorizedâ. You either didnât present
any authorization information, or it was incorrect. In this case, it
usually means the AccountSid or AuthToken are incorrect. Log into
Twilio.com, go to the Dashboard and make sure your AccountSid and
AuthToken are correct.

**What else can we do?**
------------------------

Everything depends on what you put in for the Url parameter. You can
browse some of the free applications at [Twilio
Labs](http://labs.twilio.com/twimlets/), though most of those are for
inbound calls.

Hereâs a silly example of using the voicemail Twimlet to conduct a brief
phone survey and have the calleeâs response transcribed and emailed.
Start by changing the Url line in the POST:

    my $email    = 'you@example.com';  ## your email
    my $msg      = 'Please+tell+us+what+you+think+of+Tabasco+sauce';
    my $response = $twilio->POST( 'Calls',
                                  To   => '+15556667777',
                                  From => '+12223334444',
                                  Url  => "http://twimlets.com/voicemail?"
                                        . "Email=$email&Message=$msg" );

Note that this Twimletâs arguments are case-sensitive. âEmailâ and
âMessageâ are not the same as âemailâ and âmessageâ. Make sure you use
the correct case.

Also, be sure to substitute your phone number for the To parameter and
your Twilio Sandbox phone number (also found on your Twilio Dashboard)
for the From parameter. Twilio phone numbers always use the
international calling prefix (e.g., United States numbers use â+1â
followed by the three digit area code followed by the seven digit phone
number).

When you run this, youâll get a call from Twilio asking you to share
your insights into Tabasco sauce. Please be honest. Once youâve given
your opinion, Twilio will then transcribe your message and email it to
the email address you specified.

**Iâm sending out an SMS**
--------------------------

SMS messages are even easier: no TwiML needed. Instead of the Calls API,
use the *SMS/Messages* API:

    my $response = $twilio->POST( 'SMS/Messages',
                                  To   => '+15556667777',
                                  From => '+12223334444',
                                  Body => 'Rescue me before '
                                       .  'I fall into despair' );

Thatâs all you have to do to send an SMS message using Twilio (though
the 160 character limit applies).

**Conclusion**
--------------

Twilio and Perl make a potent pair: so much is possible with so little
code. The next installment will cover writing larger applications with
TwiML.


