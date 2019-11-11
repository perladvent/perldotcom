
  {
    "title"       : "Why I Hate JSON (and you can, too)",
    "authors"     : ["felipe-gasper"],
    "date"        : "2019-11-10T21:52:51",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Another look at this ubiquitous serialization …",
    "categories"  : "data"
  }

[JSON](https://www.json.org/) needs no introduction among most programmers.
Since its “discovery” by Douglas Crockford in the early 2000s it has become
one of the most popular data serialization formats yet created, having
effectively supplanted XML as the web’s “go-to” format for representing
structured data in APIs.

For all its popularity, though, JSON carries a number of liabilities that
make it less than ideal in some contexts where it nonetheless enjoys
widespread use. This article will discuss some of these and propose
alternative formats that I think deserve your attention.


# 1. UTF-8

JSON’s chief liability is its UTF-8 restriction: all JSON documents must
be UTF-8, from start to finish. This means any application that wants to
exchange binary data either cannot use JSON, or—perhaps more commonly—uses
a secondary encoding like Base64 to store binary strings as text.
Such techniques carry performance penalties and eventually create consistency
problems, such as in the
[WAMP](https://wamp-proto.org/_static/gen/wamp_latest_ietf.html) protocol,
where it’s impossible to distinguish an “encoded” binary
string from a text string that happens to fit the pattern that the protocol
recommends for encoding binary strings to JSON.

UTF-8 is a fine way of encoding text, but applications that use JSON bind
themselves to a restriction that may prove to have been imprudent—sometimes
only long after an ecosystem has already developed and a serialization change
would be painful.

# 2. UTF-8, Redux

JSON carries the same UTF-8 liability that JavaScript does: when using the
`\uXXXX` notation it represents all
UTF-8 characters via UTF-16 notation. While that’s fine for applications whose
strings consist solely of characters from the Basic Multilingual Plane
(BMP)—Unicode code points below 65,536—it’s awkward for anything
outside this range. Given the prevalence of emoji characters nowadays,
it’s not unlikely to need to represent Unicode characters above the BMP
in a JSON document.

You can do this by encoding the raw UTF-8, but some JSON has be encoded as
plain ASCII. In that context we have to encode all characters as UTF-16 would
represent them. This makes it a bit harder for a human to read and write JSON;
for example, the pile-of-poo emoji (💩, U+1f4a9) is encoded as `"\ud83d\udca9"`.

# 3. Human Unfriendliness: Comments

[json.org](https://json.org) describes JSON as “easy for humans to read and
write.” This is true, but it’s only part of the picture: while it may be easy
for a human to read and write an isolated JSON document, JSON is an
unfriendly format for teams of humans to _maintain_.

This is true firstly because JSON disallows comments. While some
JSON implementations do allow them, these are not mutually consistent—for
example, CPAN’s popular [JSON::XS](https://metacpan.org/pod/JSON::XS)
uses `#` rather than `//` for end-of-line comments—and interoperability
problems can arise when a deviation, however minor, from a global
standard becomes an in-house standard.

JSON’s lack of support for comments is particularly
awkward in configuration files, which leaves developers to make choices like:

1. Use a nonstandard JSON variant that allows comments. This builds in a
dependency either on specific implementations, which defeats the point of
having a standard format, or on a “normalization” step in the workflow,
which adds additional maintenance overhead.

2. Alter the data schema to incorporate strings that the application ignores
but that developers can use to annotate the document.

3. Store comments in a separate file, perhaps alongside the JSON.

4. Forgo comments entirely.

None of these is especially inviting. (The “normalization”
approach—[Crockford’s erstwhile recommendation](https://archive.is/8FWsA)—seems
the least offensive.) It would be better to keep things simple by using
a configuration format that allows comments.

# 4. Human Unfriendliness: Commas

A secondary displeasure that JSON brings is the annoyance at its rejection
of trailing commas. While modern JavaScript engines now tolerate these,
the JSON standard still forbids them, which adds additional overhead when
maintaining JSON documents.

# 5. Inefficiency: Strings

Every C programmer deals with the two fundamental ways of encoding strings:
either delimit them with a “special” character (in C’s case, the NUL byte)
or transmit their length along with their “body”.

JSON, being derived from a programming language, uses the former method.
Unlike C strings, of course, JSON provides an escaping mechanism that allows
storage of the delimiter character (for JSON, that’s `"`). That, however,
entails a significant level of complexity for an encoder: a JSON encoder
cannot encode a string without first inspecting it to look for characters
that need to be escaped. A string of _n_ bytes can be up to _2n_ bytes in
length, and the only way to know for certain is to inspect each individual
character in the string. (And since these are UTF-8 strings, that means
parsing the UTF-8 first!)

It’s far more efficient—particularly for documents that are primarily
strings—to use a serialization format that encodes string length directly
and thus obviates any need to escape strings. Both encoding and decoding then
become a simple copy from one buffer to another.

# 6. Iffy Standardization

I’ve been linking in this article to [json.org](https://json.org) rather than
a formal
reference for the format because there **is**, in fact, no unified JSON
standard. Both the IETF and ECMA maintain JSON standards—the IETF has
issued no fewer than **3** recensions of theirs!

Even putting that aside, JSON has some peculiar encoding nits. Contrary
to widespread belief, JSON is _not_ a subset of JavaScript/ECMAScript
because JSON, unlike JavaScript, permits Unicode line and paragraph
separators (U+2028 and U+2029, respectively).

JSON is also—again, contrary to widespread misconception—_not_ a subset of
[YAML](https://yaml.org/), another widely-used serialization format. YAML,
for example, does not allow the `\/` sequence in encoded strings; this
sequence is common (though not required) in JSON encoders to avoid HTML
encoding problems when JSON is output directly into the body of an HTML
`<script>` tag.

So, JSON is its own little beast.

What to Use Instead?
=======================

I find [TOML](https://github.com/toml-lang/toml) a compelling format for
configuration files. It fixes JSON’s UTF-16 problem (by allowing both
`\uXXXX` and `\UXXXXXXXX` formats) and allows for comments.
Projects as diverse as Rust’s [Cargo](https://doc.rust-lang.org/cargo/)
package manager and [Hugo](https://gohugo.io/)—which powers this site!—are
some of TOML’s most prominent users.

For applications I recommend either the IETF’s [CBOR](https://cbor.io/)
or Booking.com’s [Sereal](https://github.com/Sereal/Sereal). (Disclaimer:
I wrote 2 of CPAN’s 3 CBOR libraries.) Both of these
offer improved efficiency compared to JSON and,
critically, can store binary strings. CBOR is probably better for applications
that need to communicate across multiple languages, whereas Sereal boasts
especially good Perl support, including storage of regular
expressions—with modifiers!

(Another format, [MessagePack](https://msgpack.org/), is a forerunner to
CBOR in many respects. MessagePack remains in wide use but
has only [one CPAN implementation](https://metacpan.org/pod/Data::MessagePack),
which appears to be unmaintained.)

This all having been said: if you are confident that your application
will _never_ need to serialize anything that isn’t UTF-8, and if human
readability is of greater concern to you than performance, then by all means
use JSON! Just remember the limitations you’re imposing on
yourself and all future maintainers by so doing.
