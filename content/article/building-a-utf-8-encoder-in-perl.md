{
   "image" : "/images/building-a-utf8-encoder-in-perl/bart-simpson-utf8.png",
   "description" : "Learn UTF-8 by encoding it yourself",
   "date" : "2016-08-02T08:47:57",
   "tags" : [
      "unicode",
      "utf8",
      "encode",
      "decode",
      "binary",
      "bitmask",
      "codepoint"
   ],
   "title" : "Building a UTF-8 encoder in Perl",
   "thumbnail" : "/images/building-a-utf8-encoder-in-perl/thumb_bart-simpson-utf8.png",
   "draft" : false,
   "categories" : "data",
   "authors" : [
      "david-farrell"
   ]
}

This week I wrote a UTF-8 encoder/decoder. Perl already comes with UTF-8 encoding features built-in, so this wasn't necessary, but sometimes it's nice to understand how things work. The UTF-8 scheme is defined in [RFC 3629](https://tools.ietf.org/html/rfc3629).

### What does a UTF-8 encoder do?

UTF-8 is a scheme for encoding [Unicode](https://en.wikipedia.org/wiki/Unicode) sequences of codepoints as bytes/octets. A codepoint is just a number, that identifies the Unicode entry (such as 0x24 which is a dollar sign).

Unicode defines codepoints in the range 0x0000..0x10FFFF, so the encoder must take a codepoint and convert it to bytes according to the UTF-8 scheme, which looks like this:

    Char. number range  |     UTF-8 bytes/octets sequence
       (hexadecimal)    |              (binary)
    --------------------+------------------------------------
    0000 0000-0000 007F | 0xxxxxxx
    0000 0080-0000 07FF | 110xxxxx 10xxxxxx
    0000 0800-0000 FFFF | 1110xxxx 10xxxxxx 10xxxxxx
    0001 0000-0010 FFFF | 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx

This has some interesting properties. First of all, codepoints in the range 0x00..0x7F (0-127) will have the same bytes as with ASCII encoding, which is convenient. Second it's a _variable width_ encoding, which means that a single codepoint can be 1-4 bytes long.

Decoding is simply the process in reverse: converting a sequence of bytes back into a codepoint.

### Encoding UTF-8

To encode UTF-8, I need to convert a codepoint (which is just a number), into a sequence of bytes. As there are four different byte sequences defined in the UTF-8 table, there are four scenarios to handle:

```perl
sub codepoint_to_bytes {
  my $codepoint = shift;

  if ($codepoint < 0x80) {
    return pack 'C', $codepoint;
  }
  elsif ($codepoint < 0x800) {
    return pack 'CC',
           $codepoint >>  6 | 0b11000000,
           $codepoint       & 0b00111111 | 0b10000000;
  }
  elsif ($codepoint < 0x10000) {
    return pack 'CCC',
           $codepoint >> 12 | 0b11100000,
           $codepoint >>  6 & 0b00111111 | 0b10000000,
           $codepoint       & 0b00111111 | 0b10000000;
  }
  else {
    return pack 'CCCC',
           $codepoint >> 18 | 0b11110000,
           $codepoint >> 12 & 0b00111111 | 0b10000000,
           $codepoint >>  6 & 0b00111111 | 0b10000000,
           $codepoint       & 0b00111111 | 0b10000000;
  }
}
```

The first is the easiest: if the codepoint is between 0x00 and 0x7F, no transformation is required, so I just [pack]({{</* perlfunc "pack" */>}}) the codepoint as-is. The byte value of a character is the same as the codepoint (e.g. `'U' == 56 == 0x38 == 00111000`).

For the second scenario I have to populate the bitmask `110xxxxx 10xxxxxx` with the codepoint, which means I need to return two bytes. This is how I do it:

1. For the first byte, bitshift the codepoint 6 places to the right (as the second byte will get those 6 bits).
2. Use bitwise OR to set the two most significant bits to one (`xxxxxxxx | 11000000 == 11xxxxxx`). I'm using Perl's inline binary notation (`0b...`) which makes it easy to compare the binary numbers with the bitmask.
4. For the second byte use bitwise AND to set the two most significant bits to zero (`xxxxxxxx & 00111111 == 00xxxxxx`).
5. Use bitwise OR to set the most significant bit to 1 (`xxxxxxxx | 10000000 == 1xxxxxxx`).
6. Use [pack]({{</* perlfunc "pack" */>}}) to combine the bytes into a scalar and return it.

The process for three byte and four byte encoding follows the same approach, with the rules updated according to the UTF-8 scheme.

If I wanted to get UTF-8 encoded bytes for the [Television](http://www.fileformat.info/info/unicode/char/1f4fa/fontsupport.htm) codepoint (U+1F4FA) I could use the code like so:

```perl
my $bytes = codepoint_to_bytes(0x1F4FA);
```

### Decoding UTF-8

To decode UTF-8 bytes, we need to reverse the encoding process to get back to the original Unicode codepoint number. The decoder must check how many bytes it received, extract the appropriate bits and add them together.

Perl tries "to make the easy things easy, and the hard things possible" as the saying goes, but sometimes it makes easy things harder than they are in simpler languages like C. Binary data is one such area: Perl needs to be told to turn off its character features before you can safely work with the data.

There are two ways to do that. The old, discouraged way is to use the [bytes pragma]({{<mcpan "bytes" >}}). The newer way is to use the [Encode]({{<mcpan "Encode#SYNOPSIS" >}}) module to encode the scalar as bytes and remove its UTF-8 flag. After that, Perl's functions will treat the scalar as a sequence of bytes instead of characters:

```perl
use Encode 'encode';

sub bytes_to_codepoint {
  # treat the scalar as bytes/octets
  my $input    = encode('UTF-8', shift);

  # length returns number of bytes
  my $len      = length $input;
  my $template = 'C' x $len;
  my @bytes    = unpack $template, $input;

  ...
}
```

In the subroutine `bytes_to_codepoint` I use `encode()` to populate `$input` with the bytes passed to it. Next I use the `length` function to return the number of bytes in `$input` - this is different from its usual behavior which returns the number of characters; this is the effect of using `encode()` to convert the scalar to bytes. Finally I use [unpack]({{</* perlfunc "unpack" */>}}) to extract the bytes from `$input`.

Now I know the number of bytes passed to `bytes_to_codepoint`, it's just a matter of reversing the binary operations from the encoding process:


```perl
if ($len == 1) {
  return $bytes[0];
}
elsif ($len == 2) {
  return (($bytes[0] & 0b00011111) <<  6) +
          ($bytes[1] & 0b00111111);
}
elsif ($len == 3) {
  return (($bytes[0] & 0b00001111) << 12) +
         (($bytes[1] & 0b00111111) <<  6) +
         ( $bytes[2] & 0b00111111);
}
else {
  return (($bytes[0] & 0b00000111) << 18) +
         (($bytes[1] & 0b00111111) << 12) +
         (($bytes[2] & 0b00111111) <<  6) +
          ($bytes[3] & 0b00111111);
}
```

If there is just one byte, I return it as-is because the codepoint number is the same as the byte value. As with encoding, it gets interesting with two bytes:

1. Remove the bitmask from the first byte with bitwise AND. Remember bitwise AND returns any bits as zero which are zero in the right operand (`xxxxxxxx & 00011111 == 000xxxxx`).
2. Bit shift the resulting number 6 places to the left to get the original value. So `00000010` would become `10000000`.
3. Remove the bitmask from the second byte with bitwise AND (`xxxxxxxx & 00111111 == 00xxxxxx`).
4. Add the numbers together.

The same logic applies to three byte and four byte sequences, I just update the bitwise operations to match the UTF-8 scheme. The final code looks like this:

```perl
use Encode 'encode';

sub bytes_to_codepoint {
  # treat the scalar as bytes/octets
  my $input    = encode('UTF-8', shift);

  # length returns number of bytes
  my $len      = length $input;
  my $template = 'C' x $len;
  my @bytes    = unpack $template, $input;

  # reverse encoding
  if ($len == 1) {
    return $bytes[0];
  }
  elsif ($len == 2) {
    return (($bytes[0] & 0b00011111) <<  6) +
            ($bytes[1] & 0b00111111);
  }
  elsif ($len == 3) {
    return (($bytes[0] & 0b00001111) << 12) +
           (($bytes[1] & 0b00111111) <<  6) +
           ( $bytes[2] & 0b00111111);
  }
  else {
    return (($bytes[0] & 0b00000111) << 18) +
           (($bytes[1] & 0b00111111) << 12) +
           (($bytes[2] & 0b00111111) <<  6) +
            ($bytes[3] & 0b00111111);
  }
}
```

Let's say I wanted to get the codepoint for the [Tokyo Tower](http://www.fileformat.info/info/unicode/char/1f5fc/index.htm) I can call the code like this:

```perl
use utf8;
my $codepoint = bytes_to_codepoint('🗼');
```

### Notes

1. This is a naive implementation - it doesn't handle UTF-16 reserved characters (U+D800..U+DFFF), noncharacters and only encodes/decodes one codepoint at a time.
2. Take a look at [Unicode::UTF8]({{<mcpan "Unicode::UTF8" >}}) if you need a fast UTF-8 encoder and don't want to use Perl's builtin tools.
3. UTF-8 is by far the most popular Unicode encoding. It was created by Ken Thompson and Rob Pike in [just a few days](http://doc.cat-v.org/bell_labs/utf-8_history).
4. Building your own UTF-8 encoder? Check out Markus Kuhn's [decoder test file](https://www.cl.cam.ac.uk/~mgk25/ucs/examples/UTF-8-test.txt) which contains several difficult or edge case tests for UTF-8 decoding. Markus also wrote a comprehensive [UTF-8 and Unicode FAQ for Unix/Linux](https://www.cl.cam.ac.uk/~mgk25/unicode.html).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
