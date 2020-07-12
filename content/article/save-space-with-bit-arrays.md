{
   "draft" : false,
   "tags" : [
      "bit-array",
      "bitwise",
      "binary",
      "boolean",
      "bigint",
      "integer"
   ],
   "thumbnail" : "/images/save-space-with-bit-arrays/thumb_binary-msg.png",
   "title" : "Save space with bit arrays",
   "authors" : [
      "david-farrell"
   ],
   "description" : "An old school data structure that efficiently stores data",
   "image" : "/images/save-space-with-bit-arrays/binary-msg.png",
   "categories" : "data",
   "date" : "2016-08-23T08:58:54"
}

"Big data" is an overused term, but when you're actually working with big data, every bit can count. Shaving several bits from data structure used billions of times can save a lot of space. A few months ago I was working on a job distribution system; it would send millions of jobs out every day. We wanted to capture every decision made by the system, so that a user could later query the system to understand _why_ a job had or hadn't been sent to a partner.

The problem was that the system was making billions of decisions a day, so we needed a way to pack those decisions as efficiently as possible. A colleague of mine had the bright idea to use a [bit array](https://en.wikipedia.org/wiki/Bit_array), and it worked very well - we were able to compress the data by a factor of 18 or more. If you're not familiar with bit arrays, or a little rusty on the code, keep reading and I'll show you how to use them with Perl.

### Bit array basics

Bit arrays are a way of storing multiple booleans in single number. Consider the number 0 as a byte/octet represented as bits:

    00000000

Instead of treating it like a number, using [bitwise operators](https://en.wikipedia.org/wiki/Bitwise_operation) we can treat each bit as a separate column. As this is an 8 bit number, we can store up to 8 booleans in it:

    0|0|0|0|0|0|0|0

To store a boolean in the first bit of the array, we can use bitwise or equals (`|=`). Here's how that looks in C pseudocode:

```perl
short bit_array = 0;
bit_array |= 1 << 6;
```

Let's take this one step at a time. First I initialize an 8 bit integer called `bit_array`. Next, I create a binary number with the bit set that I wish to set in `bit_array`. I do this with the left bitshift code `1 << 6`. This means, "shift the bits in the number on the left, 6 places to the left", which does this:

    00000001 << 6;
    01000000

This is called a bitmask. Next I use or equals to update `bit_array` with the bitmask `01000000`. Bitwise or (`|`) works by setting any bit to 1 in its left operand that is set to 1 in its right operand. Adding a equals sign on the end simply assigns the resulting value to `bit_array`.

If we wanted to store a boolean in the fourth bit, we'd do this:

```perl
bit_array |= 1 << 3;
```

So now the `bit_array` looks like this:

    01001000

To test if a particular bit is set, I can use bitwise and (`&`):

```perl
if (bit_array & (1 << 6)) {
  /* the seventh column is true */
}
```

Bitwise and returns a number with every bit set to 0 in its left operand which is 0 in its right operand. So the code `1 << 6` bitshifts a number that only has one particular bit set to 1 (`01000000`). This is the bitmask. If the bit array has that bit set to 1, it will return non-zero (true), else it returns zero (false).

### Bit arrays in Perl

I'm going to use a contrived example to show how bit arrays work in Perl. Imagine we're working on an ordering system at a pizza restaurant. We need to store all the toppings required for the pizza. In Perl we store numbers in scalars, which are usually 32 or 64 bits long; that's a lot of toppings we can pack into a single number!

Here is the class:

```perl
package Pizza::Order;
use utf8;

my %toppings = (
  tomato        => 1 << 0,
  cheese        => 1 << 1,
  onion         => 1 << 2,
  sausage       => 1 << 3,
  pepperoni     => 1 << 4,
  ham           => 1 << 5,
  chicken       => 1 << 6,
  bbq_chicken   => 1 << 7,
  olives        => 1 << 8,
  vegetables    => 1 << 9,
  jalapeńo      => 1 << 10,
  ranch         => 1 << 11,
  eggplant      => 1 << 12,
  garlic        => 1 << 13,
);

sub new {
  my $class = shift;
  my $self = 0;
  return bless \$self, $class;
}

sub print_state {
  my $self = shift;
  printf "%014b\n", $$self;
}

sub available_toppings {
  return keys %toppings;
}

sub add_topping {
  my ($self, $topping) = @_;
  # bitwise OR equals to set a bit field
  return $$self |= $toppings{ $topping };
}

sub remove_topping {
  my ($self, $topping) = @_;
  # bitwise NOT to invert a field and bitwise AND equals to unset it
  return $$self &= ~$toppings{ $topping };
}

sub get_toppings {
  my $self = shift;
  my @ordered_toppings = ();
  for my $topping (keys %toppings) {
    push @ordered_toppings, $topping
      # bitwise AND to test if this bit is set
      if $$self & $toppings{ $topping };
  }
  return @ordered_toppings;
}
1;
```

I create a class called `Pizza::Order`. The `%toppings` hash stores names of pizza toppings and their associated bitmask. I could only think of 14 toppings, leaving 18 spare slots for the future (if we want to stick to 32 bit integers). The `new` subroutine is a constructor which creates a blessed scalar as the `Pizza::Order` object.

The `print_state` method uses [printf]({{</* perlfunc "printf" */>}}) to print the Pizza::Order object state as a binary number. This is a really useful feature of `printf` which many other languages don't have (C & Python for example). Both `add_topping` and `get_toppings` use the techniques described earlier to set and check for set bits.

More interesting perhaps, is the `remove_topping` method. This uses bitwise not (`~`) to invert a bitmask and then bitwise and (`&`) equals to unset it. Pretty nifty, huh? Here's a quick script to test it:

```perl
#!/usr/bin/perl
use Pizza::Order;

my $order = Pizza::Order->new();
$order->add_topping('cheese');
$order->add_topping('eggplant');
$order->remove_topping('cheese');
$order->add_topping('tomato');
$order->print_state();
print "$_\n" for $order->get_toppings();
```

This prints:

```perl
01000000000001
eggplant
tomato
```

The first line is the current state of the `$order` object. It shows the first, and second-to-last bits set, which correspond to the tomato and eggplant bitmasks. It then prints out those toppings. Yay, it works!

### Bit array limitations

One thing to watch out for when storing bit arrays on disk is code change. Imagine if I had several years' worth of pizza orders saved in a database. Then one day, we stopped offering bbq chicken. It would be tempting to update the toppings hash like this:

```perl
my %toppings = (
  tomato        => 1 << 0,
  cheese        => 1 << 1,
  onion         => 1 << 2,
  sausage       => 1 << 3,
  pepperoni     => 1 << 4,
  ham           => 1 << 5,
  chicken       => 1 << 6,
  olives        => 1 << 7, # deleted bbq_chicken
  vegetables    => 1 << 8,
  jalapeńo      => 1 << 9,
  ranch         => 1 << 10,
  eggplant      => 1 << 11,
  garlic        => 1 << 12,
);
```

I deleted the `bbq_chicken` entry and bumped up the remaining toppings bitmasks. The problem is compatibility: in all the historical pizza orders, `olives` (for example) had a bitmask of `00000010000000` but in the new code, its bitmask is one lower. So if I tried to load a historical order with this class, the toppings data would be wrong. One way to handle this is remove, but not reuse, the bitmask for the deleted entry.

```perl
my %toppings = (
  tomato        => 1 << 0,
  cheese        => 1 << 1,
  onion         => 1 << 2,
  sausage       => 1 << 3,
  pepperoni     => 1 << 4,
  ham           => 1 << 5,
  chicken       => 1 << 6,
  # reserved
  olives        => 1 << 8,
  vegetables    => 1 << 9,
  jalapeńo      => 1 << 10,
  ranch         => 1 << 11,
  eggplant      => 1 << 12,
  garlic        => 1 << 13,
);
```

This limitation makes bitmasks less useful for long-term storage of data, unless the existing bitmasks are unlikely to change. Note that it's fine to add additional toppings and bitmasks, it's just re-using existing bitmasks that causes issues.

Another thing to consider is upper limits (update - see [using bit arrays with large integers](http://perltricks.com/article/using-bitmasks-with-large-integers/)). If you want your Perl code to be compatible with 32 bit and 64 bit Perls, you should probably stick to a maximum of 32 bitmasks (using a module like [bigint]({{<mcpan "bigint" >}}) may *not* work because of addressable memory limitations). You can see the settings your Perl has been compiled with by typing `perl -V | grep longsize` at the command line. The longsize value is the number of bytes your Perl can store in an integer natively.

Finally, in order to get the data back out of a bit array it needs to be tested with all the available bitmasks. Consider the `get_toppings` method in `Pizza::Order`. To find out what toppings are set, the code has to check every topping's bitmask. This is pretty inefficient. So bitmasks are good for compact data storage, but not fast access.

### References

* Wikipedia has useful entries on [bit arrays](https://en.wikipedia.org/wiki/Bit_array) and [bitwise operators](https://en.wikipedia.org/wiki/Bitwise_operation)
* Use Perl's builtin functions [sprintf]({{</* perlfunc "sprintf" */>}}) (`perldoc -f sprintf`) and [printf]({{</* perlfunc "printf" */>}}) (`perldoc -f printf`) to inspect binary values
* Perl's official [operator documentation]({{< perldoc "perlop" >}}) covers the bitwise operators. You can read it in the terminal with the command `perldoc perlop`
* Stringifying / printing numbers as binary isn't the only nice binary feature Perl has over other languages. Another is the ability to write binary numbers inline, just like octal and hexadecimal numbers, for example: `0b00001000`. This is great for comparing binary numbers
* [bigint]({{<mcpan "bigint" >}}) is one of several modules on CPAN for working with large integers, see [using bit arrays with large integers](http://perltricks.com/article/using-bitmasks-with-large-integers/)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
