{
   "description" : " Introduction PerlMx is a utility by ActiveState that allows Perl programs to interface with Sendmail connections. It's quite a powerful tool, and once installed, it's very easy to use. This article will detail how to install and setup PerlMx,...",
   "thumbnail" : "/images/_pub_2001_10_10_perlmx/111-perlmx.jpg",
   "authors" : [
      "mike-degraw-bertsch"
   ],
   "title" : "Filtering Mail with PerlMx",
   "slug" : "/pub/2001/10/10/perlmx.html",
   "date" : "2001-10-10T00:00:00-08:00",
   "draft" : null,
   "image" : null,
   "categories" : "web",
   "tags" : [
      "perlmx-activestate-sendmail"
   ]
}





### Introduction

PerlMx is a utility by ActiveState that allows Perl programs to
interface with Sendmail connections. It's quite a powerful tool, and
once installed, it's very easy to use. This article will detail how to
install and setup PerlMx, and provide an overview both of what you can
do with PerlMx, and how to do it. This overview will be based on spamNX,
the anti-spam code I developed, available at
<https://sourceforge.net/projects/spamnx>. My next PerlMx article will
go through spamNX in depth, to demonstrate how to harness the power of
PerlMx.

### Prerequisites

PerlMx is made possible by the excellent Milter code provided in
Sendmail versions 8.10.0 and higher. This code, when compiled into
Sendmail, allows external programs to hook into the Sendmail connection
process via C callbacks. PerlMx passes these C hooks to the Perl
interpreter, where you can access the information with a simple `shift`.

Versions 8.12 and higher of Sendmail enable Milter by default. In prior
versions, you must first enable the code in Sendmail. To do so, go to
the `devtools/site` directory off of the Sendmail source code. Add the
following lines to your `site.config.m4` file:

    dnl Milter
    APPENDDEF(`conf_sendmail_ENVDEF', `-D_FFR_MILTER=1')
    APPENDDEF(`conf_libmilter_ENVDEF', `-D_FFR_MILTER=1')

Now compile and install Sendmail. Once installed, add the following
lines to your `config.mc` file (again, for Sendmail below version 8.12):

    define(`_FFR_MILTER','1')dnl
    INPUT_MAIL_FILTER(`<filter_name>', `S=inet:3366@localhost, F=T')

Be warned that if you enable Milter in your configuration file, all
Sendmail connections will fail unless PerlMx is running. So wait until
your code is ready to go before you change your config file.

Your Sendmail installation is now ready to go. PerlMx also needs Perl
5.6.0 or higher, with ithreads enabled, and cannot have big integer (nor
really big) support enabled. Prior to 5.6.1, PerlMx will also need the
File-Temp module installed. With Perl properly configured, run the
installation program provided by ActiveState.

Once PerlMx is installed and your code is ready to go, run:

    pmx <package> &

To launch PerlMx. At this point, you can safely turn on the Milter code
in your Sendmail configuration. There are a few command-line options
available for PerlMx. Most are unnecessary, but I've found I need to
allow more than the default five threads. To do so, run:

    pmx -r <# of threads> <package> &

You can read about all the available options by running `pmx -h`.

[ActiveState has an FAQ
available](http://aspn.activestate.com/ASPN/Reference/Products/PerlMx/FAQ.html)
if you run into any trouble or have questions that aren't covered here.

Sendmail, Perl, and PerlMx should now be installed and ready to go. The
following section provides an overview of how to write PerlMx code.

### Programming Overview

PerlMx allows you to hook into the connection at many stages of the
connection, which are called by PerlMx from your code. I'll now go
through an outline of spamNX, to show how to start using PerlMx.

    package spamNX;
    use strict;
    use PerlMx;

The basic building blocks: give your package a name, and tell it to use
PerlMx. Code executed here is only run once, so you can open a database
connection or perform similar operations here.

    sub new {
      return bless {
        NAME    => "spamNX",
        CONNECT => \&cb_connect,
        HELO    => \&cb_helo,
        ENVFROM => \&cb_from,
        ENVRCPT => \&cb_rcpt,
        HEADER  => \&cb_header,
        BODY    => \&cb_body,
        EOM     => \&cb_eom,
        ABORT   => \&cb_abort,
        CLOSE   => \&cb_close,
      }, shift;
    }

This sub returns a blessed instance of your package's subroutines. Each
key in the hash relates to a specific point in the SMTP connection, and
the associated function is called at that point in the connection. Your
program may define any or all of the above functions; if it isn't
defined in your blessed return, PerlMx won't try to run any code.

Upon each function call, an object reference and relevant information
are passed to the function via the argument list. The object reference
allows calls to various methods and is stateful, allowing you to store
information for use later in the connection. The information provided
ranges from the name of the connecting host to the body of the message.
These functions, and their associated arguments, are discussed below, in
order of when they're called. The `cb_helo` function, which is
relatively simple, will be discussed in detail to familiarize you with
how a PerlMx function is written.

The first function called is `cb_connect`. This function is called for
every Sendmail connection, and is passed the standard object reference,
the name that the connecting host claims to be, and the real IP address
of the host.

    sub cb_connect {
      # Standard object reference
      my $ctx = shift;
      # (Possibly faked) name of the connecting host
      my $host = shift;
      # IP address of the connectin host
      my $ip = shift;
    }

This is followed by `cb_helo`:

    sub cb_helo {
      # Standard object reference
      my $ctx = shift;
      # Connecting host's HELO
      my $helo = shift;
      # Get the name of the host from the $ctx object reference
      my $host = $ctx->{host};
      # Store the HELO in the ctx object for any future reference
      $ctx->{helo} = $helo;

      # Compare the host's real name to what they provide in the HELO
      if ($host =~ /$helo/) {
        # Since the RFC spec's that the HELO should be the connecting 
        # host's domain name, reject the mail if the HELO doesn't at 
        # all match the hostname
        return SMFIS_REJECT;
      }

      # Continue with the connection, including any further function calls
      return SMFIS_CONTINUE;
    }

The preceding code looks at the value the connecting host provides for a
HELO. If that value does not appear in the host's actual name, then the
mail is rejected. Otherwise, the connection continues. Note that there
are other possible return values. They are:

`SMFIS_ACCEPT` -- accept the message without perfoming any further
PerlMx checks.
`SMFIS_TEMPFAIL` -- returns a temporary failure, for cases such as
hostname lookup failure.
`SMFIS_DISCARD` -- accepts the message, but silently drops it in the bit
bucket. Not usually a good idea.
Related to the SMFIS returns, the
`$ctx->setreply($code, $xcode, $message)` method is available to each
callback, that sets the response code to `$code`, the extended response
to `$xcode`, and the response message to `$message`.

The next function called is `cb_from`, which processes the sender's
`MAIL FROM`.

    sub cb_from {
      # Object ref
      my $ctx = shift;
      # MAIL FROM value
      my $from = shift
    }

Next is `cb_rcpt`, which is called once per recipient. Each call is
passed the value of one `RCPT TO` call. To keep track of every
recipient, create an array in the `ctx` object reference with each
recipient's address.

    sub cb_rcpt {
      # Object ref
      my $ctx = shift;
      # Recipient, a la RCPT TO: line
      my $rcpt = shift;

      # Store the recipient's name
      push(@{$ctx->{rcpts}}, $rcpt);
    }

The next code block, `cb_header`, is the first part of code that doesn't
deal directly with the connection or an SMTP protocol field. This code
is called during the `DATA` portion of the SMTP connection, prior to the
blank line that seperates headers from body. This function is called
once per header. As the `Received` lines are often multi-lined, the
value that you are passed may be folded. You can use `Mail::Header`, by
Graham Barr, to unfold multi-lined headers into one line.

    sub cb_header {
      # Object ref
      my $ctx = shift;
      # The header name (e.g. "Cc" or "Received")
      my $name = shift;
      # The header value (i.e. the latter half of XYZ: abc)
      my $value = shift;
    }

We next come to `cb_body`, which is also called during the DATA block,
after the headers have finished. The code here processes the actual text
of the email message -- very useful for virus scanning or natural
language searches. `cb_body` may be called repeatedly for large bodies
of text. A caveat to keep in mind for the future: the built-in
`replacebody` function, which replaces the text of a message, behaves
similarly. On the first call, the message body is replaced. On all
following calls, the text is appended to the new message. More on this
potentially frustrating feature in my second article.

    sub cb_body {
      # Object ref
      my $ctx = shift;
      # Message body
      my $body = shift;
    }

After the text of the message is sent, the SMTP connection is complete,
and `cb_eom` is called. This block of code is not passed any special
variables outside of the standard object reference, however there are a
few functions available here that are not available at any other point
in the code -- the `replacebody` function, for example. The special
functions are:

`$ctx->replacebody($body)` -- Replaces the body of a message with given
text. As noted above, can be called multiple times for large chunks of
data.
`$ctx->addrcpt($recipient)` -- Adds a message recipient.
`$ctx->delrcpt($recipient)` -- Removes a message recipient.
`$ctx->addheader($name, $value)` -- Adds a header to the message.
`$ctx->chgheader($name, $index, $value)` -- Changes the (1-based) Nth
occurence of the named header to the given value.
\
    sub cb_eom {
      # Object ref
      my $ctx = shift;
    }

After the connection is completed, and `cb_eom` finishes, the `cb_close`
function is called. This call does not get passed anything aside from
the object ref, and simply provides a means to clean up the `ctx` object
reference and anything else you may have done during the connection.
`cb_close` is virtually identical to `cb_abort` (which I won't detail,
since they're essentially the same); the only difference is that
`cb_abort` is called when a connection is prematurely closed.

    sub cb_close {
      # Object ref
      my $ctx = shift;

      # Don't keep a reference to previous recipients
      undef $ctx->{rcpts};
    }

### Conclusion

We've now walked through an outline of a complete PerlMx program, and
seen how to configure Sendmail and Perl to use PerlMx. In my next
article, I'll walk through the interesting bits of my spamNX code, to
demonstrate the power of PerlMx and some tricks that are available to
programmers.


