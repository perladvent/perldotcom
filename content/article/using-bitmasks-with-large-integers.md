
  {
    "title"  : "Using bit arrays with large integers",
    "authors": ["david-farrell"],
    "date"   : "2016-09-15T17:40:12",
    "tags"   : ["bigint","bit-array","bitmask","integer","memory"],
    "draft"  : false,
    "image"  : "",
    "description" : "Testing huge bit arrays with Perl",
    "categories": "data"
  }

A few weeks ago I wrote [Save space with bit arrays](http://perltricks.com/article/save-space-with-bit-arrays/) and employed some hand-waving around maximum bitmask lengths. Specifically, I said:

> using a module like bigint may not work because of addressable memory limitations
>

Now I'm not sure exactly where the "addressable memory limitation" line is, but this was something that I'd read elsewhere, and believed to be true, but didn't have time to research. The more I thought about it, the less sense that sentence made. The amount of memory a system can address is controlled by [many factors](https://superuser.com/questions/168114/how-much-memory-can-a-64bit-machine-address-at-a-time#168121), but I don't believe you'd ever want to create a bit array using all the addressable memory just for storing bitmasks. I decided to test bit arrays with large integers and see if they behaved correctly under [bigint]({{<mcpan "bigint" >}}).

### Testing large bitmasks

For these tests I wanted to check the typical operations that a bit array would be used for: setting / unsetting a bitmask and converting the bit array into a binary string. I came up with the follow test script:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use bigint;
use Test::More tests => 60;

for my $shift_size (8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096) {
  my $bitmask  = 1 << ($shift_size - 1);
  my $bit_array = 0;

  ok !($bit_array & $bitmask),  'bitmask is not set';
  ok $bit_array |= $bitmask,    'set bitmask';
  ok $bit_array  & $bitmask,    'bitmask is set';
  ok !($bit_array &= ~$bitmask),'bitmask is unset';
  ok !($bit_array & $bitmask),  'bitmask is not set';

  cmp_ok length(sprintf "%b", $bitmask), '==', $shift_size,
    'bitmask string is correct length';
}
```

This script loops over numbers of increasing size, creating bitmasks with them, and then testing the bit array against the bitmask. The bitwise operations were explained in my previous [article](http://perltricks.com/article/save-space-with-bit-arrays/). Finally the script uses `sprintf` to convert the bitmask to a binary string, and check its length is correct. Running this script I got some interesting failures. Here's a snippet of the output:

    ...
    not ok 24 - bitmask string is correct length
    #   Failed test 'bitmask string is correct length'
    #   at ./bigint-test line 18.
    #          got: 64
    #     expected: 128
    ok 25 - bitmask is not set
    ok 26 - set bitmask
    ok 27 - bitmask is set
    ok 28 - bitmask is unset
    ok 29 - bitmask is not set
    not ok 30 - bitmask string is correct length
    #   Failed test 'bitmask string is correct length'
    #   at ./bigint-test line 18.
    #          got: 64
    #     expected: 256
    ...

Whilst all of the bitwise operations passed, the string length test failed as soon as the bitmask size was larger than 64 bits (my machine is 64 bit, I expect on a 32 bit compiled Perl it would fail after 32 bits). So what to do about this? Is it that `sprintf` cannot print integers larger than 64 bit? After trying a bunch of different functions, I tried the simplest: including a length argument to `sprintf`. So this line:

```perl
cmp_ok length(sprintf "%b", $bitmask), '==', $shift_size,
```

Became:

```perl
cmp_ok length(sprintf "%0${shift_size}b", $bitmask), '==', $shift_size,
```

I'm pleased to report that the change worked, and all tests passed (on Perl 5.10 and higher). Here is the finished script:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use bigint;
use Test::More tests => 60;

for my $shift_size (8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096) {
  my $bitmask  = 1 << ($shift_size - 1);
  my $bit_array = 0;

  ok !($bit_array & $bitmask),  'bitmask is not set';
  ok $bit_array |= $bitmask,    'set bitmask';
  ok $bit_array  & $bitmask,    'bitmask is set';
  ok !($bit_array &= ~$bitmask),'bitmask is unset';
  ok !($bit_array & $bitmask),  'bitmask is not set';

  cmp_ok length(sprintf "%0${shift_size}b", $bitmask), '==', $shift_size,
    'bitmask string is correct length';
}
```

I'm not sure at what point you would hit "addressable memory limitations", but a 4096 bit integer is a huge number. This suggests to me that you *could* use a 4096 bit array with Perl, although whether you *should* is another question, TIMTOWTDI.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
