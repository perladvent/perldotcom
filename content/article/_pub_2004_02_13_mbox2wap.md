{
   "draft" : null,
   "slug" : "/pub/2004/02/13/mbox2wap",
   "tags" : [
      "cellphone-email",
      "cellphone-mail",
      "email-wap",
      "mail-to-wap-gateway",
      "mobile-mail",
      "wap"
   ],
   "date" : "2004-02-13T00:00:00-08:00",
   "description" : "It's coming up to Valentine's day again, and invariably my thoughts turn back to last year's rather memorable weekend-break to Stockholm, in which I learned two things: Stockholm makes a great Valentine's destination. My girlfriend of the time was not...",
   "thumbnail" : "/images/_pub_2004_02_13_mbox2wap/111-wap_gate.gif",
   "categories" : "Email",
   "title" : "Mail to WAP Gateways",
   "image" : null,
   "authors" : [
      "pete-sergeant"
   ]
}





It's coming up to Valentine's day again, and invariably my thoughts turn
back to last year's rather memorable weekend-break to Stockholm, in
which I learned two things:

1.  Stockholm makes a great Valentine's destination.
2.  My girlfriend of the time was not happy with me cracking out my
    iBook and checking my email halfway into the break.

The relationship, predictably, didn't last much longer, but it did occur
to me that a quick and easy way to check my email when away from my
computer would be very useful. One of the items that travels everywhere
with me, and has some limited Internet access is my phone -- although
admittedly this has only WAP access. WAP access, it seemed, would have
to do...

The tool I ended up building fills **my** needs very well, but possibly
won't be such a great match for others. This article looks at
considerations when rendering email for display online, especially when
space is very limited.

### [Overview of Messages]{#Overview_of_messages}

The first challenge is reading the contents of our target mailbox. For
this, we turn to the Perl Email Project's
[`Email::Folder`](http://search.cpan.org/perldoc?Email::Folder):

     use Email::Folder;
     
     my $folder = Email::Folder->new( '/home/sheriff/mbox' );
     
     for my $message ( $folder->messages ) {
     
            ...

[`Email::Folder`](http://search.cpan.org/perldoc?Email::Folder)'s
messages() function returns
[`Email::Simple`](http://search.cpan.org/perldoc?Email::Simple) objects.
For my folder-view, I chose to group messages by date, and use the
sender's "real name" as the subject. Something like:

     30 Jan 2004
        Michael Roberts
      * Paul Makepeace
        Uri Guttman
     29 Jan 2004
        Kate Pugh

Extracting header fields from
[`Email::Simple`](http://search.cpan.org/perldoc?Email::Simple) objects
couldn't be simpler:

     my $from = $message->header('from')

But people familiar with the various email RFCs will know that since
email headers have to use only printable US-ASCII, they're very often
encoded: your header field might well look like:

      =?iso-8859-1?q?Pete=20Sergeant?= <pete@clueball.com>

This will not look pretty if you use it literally. Thankfully,
[`MIME::WordDecoder`](http://search.cpan.org/perldoc?MIME::WordDecoder)
exports the function `unmime`{lang="und" lang="und"} -- rendering the
above as "Pete Sergeant &lt;pete@clueball.com&gt;."

Getting the date from an email is also somewhat nontrivial -- an example
"Date" header looks like:

     Fri, 30 Jan 2004 14:09:51 -0000

And that's if you're lucky, and it's well-formed, without starting to
think about time zones. If we want to do anything useful with dates,
we're going to want the date as an epoch time. Luckily,
[`DateTime::Format::Mail`](http://search.cpan.org/perldoc?DateTime::Format::Mail)
steps in, and not only parses our date, but returns a highly useful
[`DateTime`](http://search.cpan.org/perldoc?DateTime) object, allowing
us to do all kinds of fun date stuff. To simply reformat the date as
Day/Month/Year:

     my $datetime = DateTime::Format::Mail->new( loose => 1 );
     my $time = $datetime->parse_datetime( $message->header('date') );
     my $day_month_year = $time->dmy;

Finally, we're going to want to know if an email is new or not. Luckily,
most MUAs will set/edit an email's status header. Rather than checking
if an email is new, we check if it's been read -- denoted by a
`R`{lang="und" lang="und"} in the status header:

     $new_flag++ if $message->header('Status') !~ m/R/;

Now let's put this all together to produce a listing of a folder. We'll
use the well-known Schwartzian transform to make the sorting efficient,
but unlike the usual practice, we keep the array reference around, as
we'll be using the date as well.

     use Email::Folder;
     use MIME::WordDecoder qw( unmime );
     use DateTime::Format::Mail;

     my $folder = Email::Folder->new( '/home/sheriff/mbox' );
     my @to_sort;
     my $prev_date = "";
     for (sort { $a->[1] cmp $b->[1]    }
          map  { [$_, message2dmy($_) ] } 
          $folder->messages) {
         my ($message, $date) = @$_;
         if ($date ne $prev_date) { print $date, "\n"; $prev_date = $date; }
         print $message->header('Status') =~ m/R/ ? "   " : " * ";
         print unmime($message->header('from')), "\n";
     }

     sub message2dmy {
         my $message = shift;
         my $datetime = DateTime::Format::Mail->new( loose => 1 );
         my $time = $datetime->parse_datetime( $message->header('date') );
         my $day_month_year = $time->dmy;
     }

### [Displaying Individual Messages]{#Displaying_individual_messages}

Those are the main challenges of a folder-view. Viewing an individual
message presents a different set of challenges.

First and foremost is the appalling habit people have of sending each
other HTML-"enriched" emails, with all sorts of attachments. If you're
trying to read the email on a cell phone over a slow connection, you
don't want to be battling with this -- you want a nice plain-text
representation of the email. So,
[`Email::StripMIME`](http://search.cpan.org/perldoc?Email::StripMIME) is
your friend. Assuming we have an
[`Email::Simple`](http://search.cpan.org/perldoc?Email::Simple) object,
we can simply:

     my $string = $email_simple_object->as_string();
     $string = Email::StripMIME::strip_mime( $string );
     $email_simple_object = Email::Simple->new( $string );

Of course, if we really wanted to cut down on the amount of content
we're receiving, and we're only using this tool to get an overview of
our messages, we can cut out quoted text, remnants of the email that the
sender was replying to, and so on.
[`Text::Original`](http://search.cpan.org/perldoc?Text::Original) does
just this for us, as well as stripping out attribution lines:

     my $body = $email_simple_object->body();
     $body = first_lines( $body, 20);
     $email_simple_object->body( $body );

The final problem is in creating actual real WML. Sadly, this is
nontrivial, and in the past, I've tended to resort to outputting it by
hand. But it doesn't have to be that way --;
[`CGI::WML`](http://search.cpan.org/perldoc?CGI::WML) just about handles
the task for us. [`CGI::WML`](http://search.cpan.org/perldoc?CGI::WML)
is a subclass of [`CGI`](http://search.cpan.org/perldoc?CGI), with
methods specific to WAP.

### [Conclusion]{#Conclusion}

There is no fully working demo at the end of this article. My personal
tool works in a way that's probably a little too specific for most
people's needs. Hopefully however, it's introduced you to one or more
modules you didn't know existed, and given you some inspiration to
tinker around with Perl and email-handling.


