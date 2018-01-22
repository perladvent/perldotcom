
  {
    "title"       : "Free Wildcard TLS with Net::ACME2 and Let’s Encrypt",
    "authors"     : ["felipe-gasper"],
    "date"        : "2018-01-15T08:59:24",
    "tags"        : ["tls", "ssl", "networking", "net-acme", "net-acme2", "acme"],
    "draft"       : true,
    "image"       : "/images/free-wildcard-tls-with-net-acme2-and-let-s-encrypt/lets_encrypt_padlock.svg",
    "thumbanail"  : "/images/free-wildcard-tls-with-net-acme2-and-let-s-encrypt/thumb_lets_encrypt_padlock.svg",
    "description" : "Wildcards for all!",
    "categories"  : "security"
  }

Much of the credit for the recent improvement in TLS deployment across
the Internet must go to [Let’s Encrypt](http://letsencrypt.org) (LE),
who provide free TLS certificates via an open-access RESTful API. That
API has a large number of clients in many languages, including Perl.
(The list includes the [cPanel](http://cpanel.com)-derived
[Net::ACME](https://metacpan.org/pod/Net::ACME)
as well as [Crypt::LE](https://metacpan.org/pod/Crypt::LE),
[Protocol::ACME](https://metacpan.org/pod/Protocol::ACME),
[WWW::LetsEncrypt](https://metacpan.org/pod/WWW::LetsEncrypt), and
[Mojo::ACME](https://metacpan.org/pod/Mojo::ACME).)

LE has worked with the [IETF](http://ietf.org) to standardize their
“ACME” (Automated Certificate Management Environment) protocol as an
Internet standard. The forthcoming standard breaks compatibility with the
previous version of the protocol, which necessitates updates to the client
logic.

As an incentive for clients to adopt the new protocol, though, LE will
offer free wildcard TLS via their new API.

I thought I would take the opportunity to rework Net::ACME for support of
the new protocol and quickly decided that a new distribution would suit
the need best. Besides the significant protocol changes that have taken
place, I wanted to make some “deeper” changes like:

* I wanted to incorporate [X::Tiny](https://metacpan.org/pod/X::Tiny)
to reduce some logic duplication and gain the benefits of that library.

* The new protocol suggests some changes to the class structure that
would have been unwieldy to incorporate in the prior version.

And so, [Net::ACME2](https://metacpan.org/pod/Net::ACME2) is now available.
This is a generic client library for any standard ACME implementation,
though the only known public ACME implementation right now is
Let’s Encrypt’s. Their API only provides testing certificates for now,
but once there’s a production endpoint I will update Net::ACME2 to use it.

Like its predecessor, Net::ACME2:

* … supports both RSA and ECDSA

* … runs anywhere that Perl runs—no XS required except for core
modules. (cf. [Crypt::Perl](https://metacpan.org/pod/Crypt::Perl))

* … reports detailed errors via typed exceptions

* … has minimal dependencies (no Moose, &c.)

I've created some example [scripts](https://github.com/FGasper/p5-Net-ACME2/tree/master/examples) to get you started. After you’ve installed the module, try:

```
./examples/http-01.pl
```

… or:

```
./examples/dns-01.pl
```

These walk you through the following steps (with Let’s Encrypt):

1. Read the terms of service and, if you accept them, proceed.

2. Create an RSA or ECC private key. Net::ACME2 will extract the public
key from it and send it to the ACME server as your account identifier.
(The example scripts create a new key for each invocation, but for a
production deployment you should reuse a key.)

3. Create a certificate order by telling Net::ACME2 which domains the
certificate will include. The ACME server will respond with options for
“challenges”—i.e., how to prove that you control those domains. Currently
there are two available methods: HTTP and DNS. (NOTE: Wildcard domains
require the DNS method.)

4. Set up the verification. For HTTP that means making a specific
URL on the domain respond with specific content; for DNS it means creating
a TXT record with a specific name and content. (The example scripts use
the same challenge method for all domains, but your application can be
more flexible.)

5. Indicate to the ACME server which challenge you’re accepting for each
domain.

6. Finalize the certificate order. This will tell you if any challenges
failed or are still pending.

7. If all domains’s challenges succeeded, you’ll get a URL whose content
will be the newly-issued certificate.

Net::ACME2 is, like the ACME standard itself, still subject to
change, but it’ll get the job done for now. Give it a try!
