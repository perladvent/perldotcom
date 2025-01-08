{
    "title"       : "Release of new module DateTime::Format::RelativeTime",
    "authors"     : ["jacques-deguest"],
    "date"        : "2025-01-04T12:29:19",
    "tags"        : ["datetime", "l10n", "unicode", "cldr"],
    "draft"       : false,
    "image"       : "/images/release-of-new-module-datetime-format-relativetime/perl-for-relative-time-formatting.jpg",
    "thumbnail"   : "",
    "description" : "Release of the new Perl module DateTime::Format::RelativeTime, designed to mirror its equivalent Web API Intl.RelativeTimeFormat",
    "categories"  : "development"
}

I have the pleasure to announce the release of the new Perl module [`DateTime::Format::RelativeTime`]({{< mcpan "DateTime::Format::RelativeTime">}}), which is designed to mirror its equivalent Web API [`Intl.RelativeTimeFormat`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl/RelativeTimeFormat)

It requires only Perl `v5.10.1` to run, and uses [an exception class]({{< mcpan "DateTime::Format::Intl::Exception">}}) to return error or to die (if the option `fatal` is provided and set to a true value).

You can use it the same way as the Web API:

```perl
use DateTime::Format::RelativeTime;
my $fmt = DateTime::Format::RelativeTime->new(
    # You can use en-GB (Unicode / web-style) or en_GB (system-style), it does not matter.
    'en_GB', {
        localeMatcher => 'best fit',
        # see getNumberingSystems() in Locale::Intl for the supported number systems
        numberingSystem => 'latn',
        # Possible values are: long, short or narrow
        style => 'short',
        # Possible values are: always or auto
        numeric => 'always',
    },
) || die( DateTime::Format::RelativeTime->error );

# Format relative time using negative value (-1).
$fmt->format( -1, 'day' ); # "1 day ago"

# Format relative time using positive value (1).
$fmt->format( 1, 'day' ); # "in 1 day"
```

This will work with 222 possible `locales` as supported by the [Unicode CLDR (Common Locale Data Repository)](https://cldr.unicode.org/). The CLDR data (currently the Unicode version `46.1`) is made accessible via another module I created a few months ago: [Locale::Unicode::Data]({{< mcpan "Locale::Unicode::Data">}})

However, beyond the standard options, and parameters you can pass to the methods `format` and `formatToParts` (or `format_to_parts` if you prefer), you can also provide 1 or 2 `DateTime` objects, and `DateTime::Format::RelativeTime` will figure out for you the greatest difference between the 2 objects.

If you provide only 1 `DateTime` object, `DateTime::Format::RelativeTime` will instantiate a second one with `DateTime->now` and using the first `DateTime` object `time_zone` value.

For example:

```perl
my $dt = DateTime->new(
    year => 2024,
    month => 8,
    day => 15,
);
$fmt->format( $dt );
# Assuming today is 2024-12-31, this would return: "1 qtr. ago"
```

or, with 2 `DateTime` objects:

```perl
my $dt = DateTime->new(
    year => 2024,
    month => 8,
    day => 15,
);
my $dt2 = DateTime->new(
    year => 2022,
    month => 2,
    day => 22,
);
$fmt->format( $dt => $dt2 ); # "2 yr. ago"
```

When using the method `formatToParts` (or `format_to_parts`) you will receive an array reference of hash references, making it easy to customise and handle as you wish. For example:

```perl
use DateTime::Format::RelativeTime;
use Data::Pretty qw( dump );
my $fmt = DateTime::Format::RelativeTime->new( 'en', { numeric => 'auto' });
my $parts = $fmt->formatToParts( 10, 'seconds' );
say dump( $parts );
```

would yield:

```perl
[
    { type => "literal", value => "in " },
    { type => "integer", unit => "second", value => 10 },
    { type => "literal", value => " seconds" },
]
```

You can use a negative number to indicate the past, and you can also use decimals, such as:

```perl
my $parts = $fmt->formatToParts( -12.5, 'hours' );
say dump( $parts );
```

would yield:

```perl
[
    { type => "integer", unit => "hour", value => 12 },
    { type => "decimal", unit => "hour", value => "." },
    { type => "fraction", unit => "hour", value => 5 },
    { type => "literal", value => " hours ago" },
]
```

The possible `units` are: `year`, `quarter`, `month`, `week`, `day`, `hour`, `minute`, and `second`, and those can be provided in singular or plural form.

Of course, you can choose a different numbering system than the default `latn`, i.e. numbers from `0` to `9`, as long as the numbering system you want to use is of `numeric` type. There are 77 of those out of 96 in the CLDR data. See the method `number_system` in [Locale::Unicode::Data]({{< mcpan "Locale::Unicode::Data#number_system">}}) for more information.

So, for example:

```perl
use DateTime::Format::RelativeTime;
use Data::Pretty qw( dump );
my $fmt = DateTime::Format::RelativeTime->new( 'ar', { numeric => 'auto' });
my $parts = $fmt->formatToParts( -3, 'minutes' );
say dump( $parts );
```

would yield:

```perl
[
    { type => "literal", value => "قبل " },
    { type => "integer", value => '٣', unit => "minute" },
    { type => "literal", value => " دقائق" },
]
```

or, here we are explicitly setting the numbering system to `deva`, which is not a system default:

```perl
use DateTime::Format::RelativeTime;
use Data::Pretty qw( dump );
my $fmt = DateTime::Format::RelativeTime->new( 'hi-IN', { numeric => 'auto', numberingSystem => 'deva' });
my $parts = $fmt->formatToParts( -3.5, 'minutes' );
say dump( $parts );
```

would yield:

```perl
[
    { type => "integer", value => '३', unit => "minute" },
    { type => "decimal", value => ".", unit => "minute" },
    { type => "fraction", value => '५', unit => "minute" },
    { type => "literal", value => " मिनट पहले" },
]
```

The option `numeric` can be set to `auto` or `always`. If it is on `auto`, the API will check if it can find a time relative term, such as `today` or `yesterday` instead of returning `in 0 day` or `1 day ago`. If it is set to `always`, then the API will always return a format involving a number like the ones I just mentioned.

Just like its Web API counterpart, you can use the method `resolvedOptions` after having instantiated an object to check how `DateTime::Format::RelativeTime` has resolved the options you provided, or possibly come up with default ones:

```
use DateTime::Format::RelativeTime;
use Data::Pretty qw( dump );
# locale is "Marathi"
my $fmt = DateTime::Format::RelativeTime->new( 'mr', { numeric => 'auto' });
my $options = $fmt->resolvedOptions;
say dump( $options );
```

would yield:

```
{
    locale => "mr",
    numberingSystem => "deva"
    numeric => "auto",
    style => "long",
}
```

`deva` is the [numbering system](https://metacpan.org/pod/Locale::Unicode::Data#number_system) in the CLDR for "Devanagari Digits" used by the following 12 locales: `bgc` (Haryanvi), `bho` (Bhojpuri), `brx` (Bodo), `doi` (Dogri), `hi` (Hindi), `kok` (Konkani), `mai` (Maithili), `mr` (Marathi), `ne` (Nepali), `raj` (Rajasthani), `sa` (Sanskrit) and `xnr` (Kangri).

I hope you will enjoy this module, and that it will be useful to you. I have spent quite a bit of time putting it together, and it has been rigorously tested. If you see any bugs, or opportunities for improvement, kindly [submit an issue on Gitlab](https://gitlab.com/jackdeguest/DateTime-Format-RelativeTime/-/issues)
