{
   "title" : "Radiator",
   "slug" : "/pub/2002/10/15/radiator.html",
   "authors" : [
      "simon-cozens"
   ],
   "thumbnail" : "/images/_pub_2002_10_15_radiator/111-radiator.gif",
   "description" : " Are you fed up with those who think that commercial applications need to be written in an \"enterprise\" language such as Java or C++? While we're big fans of open source at Perl.com, we're bigger fans of Perl, and...",
   "tags" : [
      "radiator-radius-commercial-enterprise"
   ],
   "image" : null,
   "categories" : "Community",
   "draft" : null,
   "date" : "2002-10-15T00:00:00-08:00"
}





Are you fed up with those who think that commercial applications need to
be written in an "enterprise" language such as Java or C++? While we're
big fans of open source at Perl.com, we're bigger fans of Perl, and
we're frustrated when people claim there's something that Perl can't do;
so we spoke to Mike McCauley at Open System Consultants.

Open Systems produces
[Radiator](http://www.open.com.au/radiator/index.html), a commercial
RADIUS server implementation, first released four years ago and with new
versions and enhancements continually developed. It has about 5,000
paying installations worldwide. Mike explains: "It's used to
authenticate dialup and wireless access to an ISP or corporate network.
In order to authenticate users, it can look up user details in a wide
range of data sources, such as SQL, LDAP, flat files, Unix password
files, OPIE, PAM, Windows NT SAM, Active Directory, third-party billing
packages, and so on."

Mike was particularly impressed with Perl's write-once-run-anywhere
nature, which has completely obviated the need for porting or
platform-specific alteration. As he says, "The finished product runs
without change on almost every platform known to humanity. That means we
can appeal to more potential customers, with less effort spent on
porting and maintenance."

But there were other reasons for choosing Perl as an implementation
language: "The richness of Perl allows us to express complicated
algorithms quickly and concisely, and know they will work wherever the
customer wants to run the code; and the connect easily to lots of
different data sources." Perl's reusability and the great library of
code already available also played its part. "The modules from CPAN mean
we can talk to servers like SQL, LDAP, NISPLUS, Active Directory,
OpenSSL, and **lots** of other things. We can concentrate on writing the
product, rather than coding and maintaining interfaces."

We asked about the performance of going with Perl instead of, for
example, C, but this seemed not to be the problem that many people might
expect. "Most authentications rely on some external server or system,
such as an LDAP or SQL server, and so the speed determining step is
usually that extenal system. Also, the interfaces to those systems are
generally compiled Perl modules written in C. And where there is no
external server, we can use clever hashing mechanisms to make lookups
faster than some C based Radius servers. That means that Radiator can be
up there with a server written in C, and with much more features and
flexibility."

Mike also explained that good Perl programming practice can keep
performance high: "In order to get the best performance, you have to
code so that you use as much of Perl's internal lovingly hand-wrought C
code as possible. That means using complex operators like `map`, `grep`,
hashes etc, to do the maximum of work with as few Perl operators as
possible. You have to balance that against readability though, otherwise
you can end up with unmaintainable code that looks like line noise.
Radiator makes heavy use of Perl's Object Oriented support, which costs
in performance, but we think the benefits in maintainability and easy
extensibility (for us and the customer) are worth it."

One common concern with businesses releasing Perl products is that
they're worried about piracy; if the source code is visible by anyone,
isn't it easy for people to run away with it? The evaluation version of
Radiator is shipped with a small portion of the code encrypted, and only
made available to bona fide equirers. However, the full product is
shipped completely unencrypted. Mike flips over the concern and sees the
advantages. "Most network operators really like the idea of a product
with full source code: They can be sure that the product does what it
claims, and they can change or enhance it if necessary. ... We like to
offer full source code, but we also need to be paid for our hard work,
and partial encryption of demos seems to be a good compromise that
results in most of our demos turning into sales."

What, then, about people making customizations or passing on copies to
their friends? "Actually, we don't mind if customers change their code
to suit their own needs. But we don't like it if they give the code to
someone else, so that we get to support them without being paid. There
is a little bit of that goes on, but ours is not really a mass-market
consumer product, and I think that most people realise they get more
benefit from an honest relationship with us. In the end, a license is
not very expensive, especially since the support is so good."

Finally, we asked Mike to sum up his thoughts on commercial development
with Perl. "Technically, I think it is unsurpassed for almost any
application. In Perl, I can be five to 10 times more productive,
line-for-line than in C or C++ (and I'm no slouch at them, either). For
software vendors, that means a more maintainable product delivered to
market faster. For customers it means a better product for less money.
And interoperability and portability is fantastic. As you can tell, we
really like it!"

"Commercially, a qualified yes, provided you have control over licensing
and distribution issues, which might be hard in anything other than a
niche market. You can't keep writing software unless you get to pay the
mortgage and feed the kids, too."

Mike McCauley is chief software developer at Open System Consultants in
Melbourne, Australia. He has a bachelor of engineering from the
University of Queensland, and has worked in the computer software
industry for 20 years. When he is not writing software, he flies light
planes and has fun with his family.


