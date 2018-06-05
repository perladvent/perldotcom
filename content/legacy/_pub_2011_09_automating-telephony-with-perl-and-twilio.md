{
   "tags" : [
      "apis",
      "telephony"
   ],
   "thumbnail" : null,
   "categories" : "networking",
   "title" : "Automating Telephony with Perl and Twilio",
   "image" : null,
   "date" : "2011-09-21T06:00:01-08:00",
   "authors" : [
      "scott-wiersdorf"
   ],
   "draft" : null,
   "slug" : "/pub/2011/09/automating-telephony-with-perl-and-twilio.html",
   "description" : "Perl can make your phone ring. Scott Wiersdorf demonstrates how to use Twilio's API to make and receive phone calls and to automate SMS, all from Perl."
}



Perl can make your phone ring.

[Twilio](http://www.twilio.com/) allows developers to write applications that can make and receive voice calls or SMS messages (though Twilio can do many other interesting telephony things). Twilio’s RESTful API, text-to-speech synthesizer, speech transcription services, and Javascript client make it easy to knock out a conference call application, an in-browser customer service voice application, a weather-by-SMS application, reminder by phone—anything, really—in minutes. This article shows how to make a couple of small applications, one to help you pronounce words correctly and the other to transcribe awkward condiment phone survey answers.

**Twilio Setup**
----------------

First, head over to [Twilio.com](http://www.twilio.com/) and click the “Try Twilio Free” link. While inbound calls cost US $0.01 per minute and outbound calls cost US $0.02 per minute, Twilio has historically given new users a generous account balance to start with for free (currently US $30)—it’s plenty of credit to kick the tires and take it for a spin.

Go ahead and register (I’ll wait here). When you’ve finished, you’ll have an account SID (beginning with “AC”) and an auth token, available from your Twilio Dashboard. These are your Twilio API username and password; you’ll need them for any API application you write.

**Twilio Basics**
-----------------

The Twilio website is full of well-organized documentation and sample applications. I recommend starting with “How It Works” (one of the main navigation links on the home page). Browse the documentation under “Docs” as well.

H. H. Munroe said, “A little inaccuracy sometimes saves tons of explanation.” Keeping that in mind, inbound calls (calls to a Twilio number) work like this:

![](/images/_pub_2011_09_automating-telephony-with-perl-and-twilio/twilio-inbound.png)
*Inbound calls to a Twilio number*

1) the user calls “555-867-5309” on their phone

2) Twilio accepts the call, then makes an HTTP POST to http://example.com/jenny.xml

3) example.com responds with a “TwiML” document (TwiML is a simple XML language that describes how Twilio will interact with callers):

    <?xml version="1.0" encoding="UTF-8" ?>
    <Response>
      <Say voice="woman">This is Jenny!</Say>
    </Response>

4) Twilio’s TwiML parser and text-to-speech synthesizer read this document and then says to the user (in a voice from the uncanny valley), “This is Jenny!”

When you setup a sandbox number, you tell Twilio to map a URL to that number. Twilio will GET/POST to that URL when receiving calls.

Outbound calls (calls from a Twilio number) work like this:

![](/images/_pub_2011_09_automating-telephony-with-perl-and-twilio/twilio-outbound.png)
*Outbound calls from a Twilio number*

1) An application makes an HTTP POST to Twilio’s “Calls” API with the parameters:

    From=+15558675309
    To=+19991234567
    Url=http://example.com/jenny.xml

2) Twilio places the call and waits for an answer

3) Once the user answers, Twilio retrieves the URL specified in the POST (which should return a TwiML document)

4) Twilio parses the TwiML document and passes it to the text-to-speech synthesizer

5) The synthesizer says to the user “This is Jenny!”

Twilio can also record voice input, transcribe it, send and receive SMS messages, make conference calls, and a few other useful things, all using the same familiar RESTful API and TwiML.

**Twilio, meet Perl**
---------------------

CPAN makes writing Twilio applications easy, thanks to [WWW::Twilio::API](https://metacpan.org/pod/WWW::Twilio::API). My (current) favorite way to install CPAN modules comes from the Mojolicious project:

    curl -L cpanmin.us | perl - WWW::Twilio::API

cpanmin.us returns a Perl program which handles all of the build dependencies for you. If you’re leery of running code from a website directly on the command line, install [App::cpanminus](https://metacpan.org/pod/App::cpanminus) and use its `cpanm` program instead.

If you’re like me and don’t want to mess up your clean development environment, tell cpanmin.us or `cpanm` to install things into a temporary location:

    $ mkdir ~/perl-test
    $ export PERL5LIB=~/perl-test/lib/perl5
    $ curl -L cpanmin.us | perl - --local-lib=~/perl-test WWW::Twilio::API
    # or
    $ cpanm --local-lib=~/perl-test WWW::Twilio::API

See [How to install CPAN modules](http://www.cpan.org/modules/INSTALL.html) for more information and options.

**Getting all the necessary Twilio information**
------------------------------------------------

After you install [WWW::Twilio::API](https://metacpan.org/pod/WWW::Twilio::API), but before you make your first call, you need several pieces of information from your Twilio Dashboard:

-   AccountSid: this is a long string begining with “AC”

-   AuthToken: another long hex string, next to the AccountSid; you may have to click a lock icon to reveal it

-   Sandbox number: found on the bottom half of the Dashboard page under “Sandbox App”

That’s all! Now you’re ready to go.

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

That’s the entire application. Run it, and if all went well, you should see a long XML string returned which resembles:

    <?xml version="1.0"?>
    <TwilioResponse>
      <Call>
        <To>+15556667777</To>
        <From>+12223334444</From>
        <Status>queued</Status>
        <Direction>outbound-api</Direction>
      </Call>
    </TwilioResponse>

… and then your phone should ring. I’ve always wondered how to pronounce “plugh”—now I know.

**What could possibly go wrong?**
---------------------------------

Early on in Twilio development, you’re likely to experience a few little gotchas. For example, you might get this message:

    LWP will support https URLs if the LWP::Protocol::https module
    is installed.

That’s LWP telling you to install [LWP::Protocol::https](https://metacpan.org/pod/LWP::Protocol::https). (It will also install or update a few other modules, including [Net::SSLeay](https://metacpan.org/pod/Net::SSLeay)).

If you see XML after running the script, your development environment is probably fine. You might instead see:

    <TwilioResponse>
      <RestException>
        <Status>401</Status>
        <Message>Authenticate</Message>
        <Code>20003</Code>
        <MoreInfo>http://www.twilio.com/docs/errors/20003</MoreInfo>
      </RestException>
    </TwilioResponse>

Notice the “401”? If you’re familiar with [HTTP status codes](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html), you might remember that 401 means “Unauthorized”. You either didn’t present any authorization information, or it was incorrect. In this case, it usually means the AccountSid or AuthToken are incorrect. Log into Twilio.com, go to the Dashboard and make sure your AccountSid and AuthToken are correct.

**What else can we do?**
------------------------

Everything depends on what you put in for the Url parameter. You can browse some of the free applications at [Twilio Labs](http://labs.twilio.com/twimlets/), though most of those are for inbound calls.

Here’s a silly example of using the voicemail Twimlet to conduct a brief phone survey and have the callee’s response transcribed and emailed. Start by changing the Url line in the POST:

    my $email    = 'you@example.com';  ## your email
    my $msg      = 'Please+tell+us+what+you+think+of+Tabasco+sauce';
    my $response = $twilio->POST( 'Calls',
                                  To   => '+15556667777',
                                  From => '+12223334444',
                                  Url  => "http://twimlets.com/voicemail?"
                                        . "Email=$email&Message=$msg" );

Note that this Twimlet’s arguments are case-sensitive. ‘Email’ and ‘Message’ are not the same as ‘email’ and ‘message’. Make sure you use the correct case.

Also, be sure to substitute your phone number for the To parameter and your Twilio Sandbox phone number (also found on your Twilio Dashboard) for the From parameter. Twilio phone numbers always use the international calling prefix (e.g., United States numbers use “+1” followed by the three digit area code followed by the seven digit phone number).

When you run this, you’ll get a call from Twilio asking you to share your insights into Tabasco sauce. Please be honest. Once you’ve given your opinion, Twilio will then transcribe your message and email it to the email address you specified.

**I’m sending out an SMS**
--------------------------

SMS messages are even easier: no TwiML needed. Instead of the Calls API, use the *SMS/Messages* API:

    my $response = $twilio->POST( 'SMS/Messages',
                                  To   => '+15556667777',
                                  From => '+12223334444',
                                  Body => 'Rescue me before '
                                       .  'I fall into despair' );

That’s all you have to do to send an SMS message using Twilio (though the 160 character limit applies).

**Conclusion**
--------------

Twilio and Perl make a potent pair: so much is possible with so little code. The next installment will cover writing larger applications with TwiML.
