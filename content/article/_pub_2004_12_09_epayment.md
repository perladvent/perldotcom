{
   "categories" : "community",
   "tags" : [
      "inline-java",
      "perl-billing",
      "perl-electronic-payment",
      "perl-evangelism",
      "perl-success-stories",
      "university-of-new-york-at-buffalo"
   ],
   "image" : null,
   "authors" : [
      "jim-brandt"
   ],
   "draft" : null,
   "date" : "2004-12-09T00:00:00-08:00",
   "slug" : "/pub/2004/12/09/epayment.html",
   "title" : "The Evolution of ePayment Services at UB",
   "thumbnail" : "/images/_pub_2004_12_09_epayment/111-success.gif",
   "description" : " In the summer of 2001, the State University of New York at Buffalo (UB) hired a new Provost. She surveyed various school services and came up with a short list of must-do projects. Given the level of competition in..."
}





In the summer of 2001, the State University of New York at Buffalo (UB)
hired a new Provost. She surveyed various school services and came up
with a short list of must-do projects. Given the level of competition in
higher education, it's no surprise that she felt that we must be able to
accept payments over the internet. In general, we try to make it as easy
as possible for students and their parents to manage the business side
of their education. Electronic payment is a key, new component of that.

### How to Start?

Determining how to accept an electronic payment requires skills from a
wide variety of groups on campus. So we first put together a committee
with representatives from Accounting, Student Accounts, and some offices
that wanted to accept electronic payments. My department, Administrative
Computing Services, also sat on the committee since we would have to
implement the actual technology. Our role was to work with the people
who handled the manual payment system and figure out how to automate
that system through the web.

We had no experience taking money over the internet, so we looked at our
options:

-   *Purchase a fully outsourced solution.*

    We evaluated many all-in-one systems, but most didn't do exactly
    what we wanted. The biggest problem was integration with our
    existing system, which had grown over time and had many legacy
    components. Many vendors had systems that worked only with their
    complete accounting systems.

-   *Partially outsourced solution.*

    With this approach, we would do some work on our end and offload
    some to a vendor. This ended up being our initial approach since it
    allowed us to write the custom parts to interface with our systems,
    but still outsource the financial parts to reduce our initial risk.

-   *Mostly custom solution with payment processing outsourced.*

    With this configuration, we'd host all of the web components
    in-house. We would use an external vendor for the payment-processing
    components, including validating credit cards, encumbering the funds
    from cards, and processing the actual payments through the payment
    networks and banks.

-   *Complete in-house system.*

    Some companies actually act as their own payment processor in
    addition to running the front-end website components. There is
    nothing preventing you from processing your own payments, but we
    found the banking world incredibly complex, especially with regard
    to credit card transactions. Although we could theoretically save
    money by doing this work ourselves, we weren't *interested* in doing
    this work. Our Accounting department agreed.

After evaluating the options, we chose to start with a partially
outsourced solution. Over time our needs changed and we became more
knowledgeable; we since made the transition to a mostly in-house
solution.

### Initial Solution: Partial Outsourcing

Our initial solution was mostly outsourced, with us building just a few
front-end components. This allowed us to get our feet wet with
electronic payment without running everything. Even with a vendor doing
most of the work, we encountered some challenges.

To implement this model, we built a website with a few pages that would
collect personal data and track some data on the transaction. On the
final page of our site, the user clicked a submit button and we shipped
them off to the vendor website to enter the credit card information.
This way we didn't directly deal with any credit card issues. Each night
we would receive a remittance file with the day's transactions and we
would reconcile these with our data using a unique identifier.

The key issues for this first phase were:

1.  Purchase and install a certificate from a widely accepted
    certificate issuer.
2.  Make sure all users used SSL. We simply redirected all http requests
    to the site to https so users couldn't accidentally use unencrypted
    connections.
3.  Accurately record a unique identifier to match up transactions when
    we received the remittance file from the vendor.
4.  Follow the vendor's protocol to integrate properly with their site.
5.  Understand the payment-processing system so we could date and post
    transactions accurately in our batch jobs.

The first two were basically normal tasks for setting up a secure
server. The third required a little work, but not much. The challenge
was integrating with the vendor. They had limits on the size of a unique
identifier that were smaller than we wanted to provide, so we needed to
shorten the value we sent. We also had concerns with how we would track
down any "orphan" payments in the payment system that we couldn't track
to a particular user. We were lucky that, in practice, this never
occurred.

Number four also presented a challenge. My department is largely a Perl
shop and we didn't use Java on our website. During the development
process, we discovered that the vendor link required Java to encrypt the
data we sent to their system. They used Cryptix PGP with some custom
code, available in Java only. That summer at OSCON I learned about the
Inline modules and I decided to try one. Since it was only one small
Java component, I followed their examples to code the Java encryption
subroutine and stuck it at the bottom of the final Perl submission
script using [`Inline::Java`](http://search.cpan.org/dist/Inline-Java).

We have since moved on to a different system for processing our
payments, so this code is a bit dated. However, when we were using it,
it looked something like this:

    my $encrypt = new encrypt();

    # We had several calls like this one, one for each parameter we
    # needed to encrypt.
    # Each call returned a string with the encrypted data.
    my $vendor_code = $encrypt->send_to_vendor($pay_code);

    # CGI code to create a form with the encrypted data as hidden fields.
    # The form also acted as a confirmation page, so the user saw
    # "Please review your information and click to continue".

    # Java code at the bottom of the file.
    use Inline ( Java => <<'END_OF_JAVA_CODE',
      import xjava.security.Cipher;
      import cryptix.pgp.*;

    class encrypt {
      public encrypt(){
      }

      public String send_to_vendor (String value_string){
          PGP pgpObj = new PGP();

          /* Initialize the object with base values. */
         pgpObj.init("/pgp_dir", "client name", "passwd","sender_key_name");

          /* Add the receiver name to the list. */
          pgpObj.addReceiver("vendor name");

         /* Create the encoded string. */
         String encvalue = pgpObj.encodeString(value_string);

         return (encvalue);
       }
    }
    END_OF_JAVA_CODE
    SHARED_JVM => 1,
    CLASSPATH => 'paths to cryptix libraries',
    );

The code itself is very simple. The Java code simply creates a new
object, calls a few methods, and returns the encrypted string. The
interesting part is how relatively easy it was to embed the Java code in
a Perl CGI script and have it work seamlessly. When we initially
implemented this in 2001, `Inline::Java` was fairly new and there was
little documentation on how to do this. Patrick LeBoutillier, the
author, was very helpful as I was trying to get it working. Now the
`Inline::Java` documentation has a section on using `Inline::Java` in
CGI scripts.

The last item on the list was far more difficult than we anticipated.
For most days, it was a simple formula to tag a record with a date the
money would be available. However, weekends had special rules; we saw
results that were inconsistent with the documentation we were working
from. To nail down the problem, we ended up having to run small test
transactions at various times on various days to see when our
accountants saw the money actually arrive in the UB account.

For example, if the documentation said there was a 4 p.m. cut-off time
for payments on a given day, we would run a \$1.11 transaction at 3:55
p.m., then another \$1.12 transaction at 4:05 p.m. Our accounting people
would watch the system to see when the payments came through. We needed
to increment the amounts because we used the same credit card to process
the transactions and there was no other way to keep them straight.

Following this method, we learned a lot about the backend banking
system. Different credit card companies process things on different
schedules and handle things differently. The most important thing we
found was a bug in the vendor's processing system. After many weeks of
running test transactions and comparing the clearing times with the
vendor documentation, we finally tracked it back to a problem in the
vendor system that they quickly fixed.

The final product worked well. During the first run of the final
confirmation script, `Inline::Java` compiles and saves the code to run
again, so it was quite fast. The vendor received the encrypted
information correctly and could decrypt it successfully; it didn't
matter to them that we actually generated the request in Perl. Our
remittance files arrived on a regular schedule and we posted the results
on a daily cycle.

### The World Happens in Real Time

As described above, the vendor did much of the work, but since we passed
users off to their system, we were unable to see the results of
transactions until the next day. This wasn't a problem for some
payments. For example, the graduate school application fee just needs to
be received by a particular date. It's not crucial that we know the
results of the transaction in real time.

For tuition payment, however, we needed a real-time solution. At UB and
many universities, you can't register for your next semester if you have
an outstanding balance from the previous semester. When a student is in
this situation, called a checkstop, he needs to be able to pay and have
the checkstop lifted immediately. Students often find out about their
checkstop while trying to register online, so they need to be able to
pay, clear their accounts, and return to the registration system while
some courses are still available. What's more, this often happens on a
Saturday morning when many services may not be available.

#### Real-Time Integration Challenges

The existing accounts system at UB runs on a mainframe, but most new
development happens in our distributed Solaris environment. To allow
real-time payments, we needed a vendor who could provide an immediate
payment response, and we needed to apply that result to the mainframe.
We also wanted to design the system to be open for future applications.

We selected VeriSign as our new vendor and they returned real-time
results. To then apply real-time results to our system, we could no
longer pass users off to another site; we needed to manage the entire
transaction. We redesigned our system to handle this.

We currently use this redesigned system. The key steps in our current
process are:

1.  Manage the web transaction using Perl CGI scripts and an Oracle
    database.
2.  After the user enters credit card information and clicks Submit,
    make a SOAP call to our internal payment server. The payment server
    logs all events.
3.  Perl scripts on the payment server call our mainframe system to
    determine if the student's account is eligible to receive a payment.
4.  If the student has an active account, we call VeriSign using their
    Perl module.
5.  Receive and log results from VeriSign.
6.  If VeriSign approved the payment, call the mainframe again and
    credit the student's account with the amount of the payment. If
    student paid in full, remove the checkstop from the account.
7.  Return the response for the initial SOAP call and present the user
    with the result of the transaction.

From a design perspective, most of the steps are necessary given the
disparate components we're working with. Despite all of the things we
do, the entire process usually takes about 10 seconds.

We have several systems that access our mainframe in real-time through
Perl. The Perl part is a basic socket call to a port on the mainframe.
Special software runs on the mainframe as a server that can receive
formatted requests and return results after processing against mainframe
systems. One major advantage of the mainframe software is that it allows
us to use existing mainframe systems through a new internet front-end.

The interface with VeriSign was likewise fairly easy to integrate. They
provide a Perl module to call their system and retrieve results. The
majority of the work was in learning all of the non-success response
codes and designing the system to handle them appropriately.

However, you may wonder why we included a SOAP call between internal
servers. When we designed the system, we tried to make all of the parts
as flexible as possible. For this phase, we built both the front-end
(the user websites) and the backend (the payment server). Given a
generic enough interface, we speculated that other campus users may want
to build their own front-end website and interface directly with the
payment server. Constructing a SOAP interface using
[`SOAP::Lite`](http://search.cpan.org/dist/SOAP-Lite) allowed us to
potentially provide a service in a technology-neutral manner. The system
has worked well and performance hasn't been a problem. Thus far, we
haven't had an external, campus-entity interface with our system, but we
have built other internal systems that use the interface.

We also have a process in place for payments that don't need immediate
application (not real time). For these payments, we follow a similar
process but skip the live mainframe connections. At night, we have batch
Perl jobs that run and apply the changes to the mainframe.

### Challenges

Most of our challenges with the ePayment system are with the user
interface, specifically providing enough information. We will frequently
receive a result of "declined," or "declined with possible approval."
Some declines are the simple type where the user simply doesn't have
enough room on their credit card. However, many credit and debit cards
have a maximum charge limit per day that card holders aren't aware of.
They tend to hit this limit when using a credit card to make a large
charge like a tuition payment. This type of decline is conditional; the
card issuer can approve the transaction after a phone call from the card
holder.

The problem is that the return code from VeriSign isn't always clear
enough for us to tell users exactly what they need to do. The correct
response can also vary from one credit card issuer to another. The
challenge is presenting them with messages that give them enough
information, but no incorrect information. Even when we can provide them
with a clear message such as "You need to call your credit card issuer,"
they often assume it's a problem with our system and contact us anyway.

### Your eUniversity

UB's ePayment project has been very successful and our users have
received it well. In our last payment cycle, approximately 40% of
payments came through the internet, instead of the traditional methods
of mailing a check, going to the payment office, or paying over the
phone. Even with this level of activity, the level of support required
has been very reasonable.

With so many internet payment systems available -- some specifically
designed for education -- some may question custom-building so much of
the system. When dealing with legacy components, however, it's often
difficult to purchase a solution for just part of the process. Replacing
entire systems at a university the size of UB is a much larger project
than we usually want to tackle at any one time. In these situations,
we've found Perl to be very flexible, allowing us to patch together
disparate systems and external resources to build a cohesive, effective
system.


