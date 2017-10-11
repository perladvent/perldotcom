{
   "draft" : null,
   "slug" : "/pub/2003/03/13/datetime",
   "date" : "2003-03-13T00:00:00-08:00",
   "tags" : [],
   "thumbnail" : "/images/_pub_2003_03_13_datetime/111-dates_times.gif",
   "categories" : "CPAN",
   "description" : " Some Basic Concepts In order to understand what you might want to do with dates and times, it's good to have a handle on some basic concepts. Here are some terms that I'll be using in this article: datetime...",
   "title" : "The Many Dates and Times of Perl",
   "image" : null,
   "authors" : [
      "dave-rolsky"
   ]
}





### [Some Basic Concepts]{#some_basic_concepts}

In order to understand what you might want to do with dates and times,
it's good to have a handle on some basic concepts. Here are some terms
that I'll be using in this article:

-   **[datetime]{#item_datetime}**\
-   **[UTC (also GMT and Zulu)]{#item_utc}**\
    UTC stands for "Coordinated Universal Time". It is an international
    standard which is kept using atomic clocks, and is kept to within
    0.9 seconds of the rotation of the earth on its axis in order to
    work well with traditional standards of time-keeping. UTC time is
    measured at the prime meridian (O degrees longitude).

    Time zones around the world are specified as an offset from UTC. The
    widely used term GMT (Greenwich Mean Time) refers to a time zone
    that is equivalent to UTC. In other words, it has no offset.

    The US military has a set of terms used for time zones around the
    world based on the alphabet (A-Z). In this system UTC is Z,
    sometimes called "Zulu".

    UTC is a good standard for the *internal* representation of dates
    and times, as it makes comparing datetimes or doing datetime math
    much easier.

-   **[Time zones and Daylight Saving
    Time]{#item_time_zones_and_daylight_saving_time}**\

    Time zones, as mentioned above, are defined as an offset from UTC.
    Most, but *not* all, time zones are in offsets of whole hours.
    Adelaide, Australia has an offset of nine and a half hours ahead of
    UTC, and Nepal has an offset five hours and forty-five minutes ahead
    of UTC.

    Time zones are complicated by the use of Daylight Saving Time, which
    changes the actual offset of a given location to vary over the
    course of the year. The eastern US has an offset of -0500 from UTC,
    five hours behind UTC. This means that 12:00 (noon) UTC becomes
    07:00 (AM). However, when Daylight Saving Time is in effect, the
    offset becomes -0400, four hours behind UTC. Because time zones are
    determined by governments, use of Daylight Saving Time, and the base
    offsets, have changed over time, and may change again in the future.

    This greatly complicates math when dealing with non-UTC datetimes.
    If I have a local datetime for the Eastern US of 2002-10-25 14:15:00
    and I add six months to that datetime, then I will have crossed a
    DST change.

    The upshot of all this is that any code that represents time zones
    as *fixed* offset will probably start producing errors once date
    math gets involved.

    The definitive source of time zone offsets and rules is the Olson
    time zone database. It defines zones according to names like
    "America/New\_York", as opposed to "EST". The latter shorthand is
    commonly used, but it should probably be avoided because these short
    names are not unique or definitive. For example, there is an "EST"
    at -0500 and +1000.

-   **[Local time]{#item_local_time}**\

    The local time is UTC plus the local time zone offset. While UTC is
    great for internal use, most people want to see datetimes in terms
    of *their* location. In a sense, local time is the *display* format,
    while UTC is the *storage* format.

-   **[The epoch]{#item_the_epoch}**\

    Epoch is a generic term referring to the "start" of any particular
    system. For example, the Gregorian calendar's epoch is January 1, 1
    CE.

    The epoch system, as used most operating systems, represents a
    datetime as the number of seconds after a specific date and time.
    For Unix systems, the epoch began on January 1, 1970 at midnight GMT
    (UTC). Other systems have different epochs. Because of this, you
    cannot assume that an epoch time of 2,003,131 means the same thing
    from system to system, because different systems have a different
    "second 0". Storing a datetime as its epoch is not portable.

    Even worse, on most current systems, epochs are represented by a 32
    bit signed integer, which only lets you represent datetimes with a
    range of about 136 years. On most UNIX systems currently in use,
    this means that the latest date you can represent right now is
    sometime in the year 2038, and the earliest is around 1902. This
    doesn't work very well if you're trying to represent the birth date
    of your great-great-grandmother.

    The upshot of all this is I would strongly recommend *not* using
    epochs except when you have no other choice. Of course, you'll often
    have no choice, so it's important to know how this system works.

-   **[The Gregorian Calendar]{#item_the_gregorian_calendar}**\

    There have been many different calendar systems in use throughout
    history. The Gregorian calendar is the current generally agreed upon
    international standard for representing dates, and is what you are
    using when you say "August 8, 1999". Other calendars that are still
    in use include the Hebrew calendar, the Islamic calendar, and the
    Chinese calendar.

    Even though the Gregorian calendar wasn't created until 1582, and it
    wasn't adopted world wide until this century, we can still
    extrapolate backwards in time using the Gregorian calendar.

### [What Needs Doing with Dates and Times?]{#what_needs_doing_with_dates_and_times}

There are a lot of things you can do with dates and times, and different
modules/distributions provide different types of functionality. Broadly
speaking, we can consider the following areas of functionality:

-   **[Parsing/Formatting]{#item_parsing%2fformatting}**\

    There are more datetime formats in use in the computing world than
    you can shake a stick at. You'll often have to parse a datetime in
    one format in order to turn it into something you can work with
    internally, like a bunch of integers or an epoch time.

    On the flip side, you'll often have to take some standard
    representation, like an epoch, and convert it to some other format.

-   **[Basic representation]{#item_basic_representation}**\

    A nice datetime object can be quite handy. These range from
    lightweight wrappers around Perl's [`localtime()`](#item_localtime)
    to objects that try to provide methods for all possible datetime
    operations.

-   **[Math and calculations]{#item_math_and_calculations}**\

    You'll often want to answer questions like "what day is seven days
    after today" or "how much time is there between now and midnight?"
    This is closely related to the task of figuring out the date Easter
    falls on in a given year, or what day of the week Martin Luther
    King's birthday falls on.

There are plenty of other things we can do with datetimes, but these are
largely elaborations of the above areas of functionality.

### [Perl's Built-in Date/Time Functionality]{#perl's_builtin_date/time_functionality}

Perl has some built-in functionality for handling dates and times. This
functionality includes:

-   **[`time()`]{#item_time}**\

    A function that returns the current epoch time.

-   **[`localtime()` and `gmtime()`]{#item_localtime}**\

    These functions convert an epoch time into a set of components
    representing the local time. They both return arrays containing
    things like the hour, minute, month, etc., though some of the values
    returned are awkward to use. For example, the year is the actual
    year minus 1900.

    The [`localtime()`](#item_localtime) function returns the datetime
    of your current location, based on your system's time zone setting,
    while the gmtime function returns the current UTC datetime.

    The `Time::localtime` and `Time::gmtime` modules provide a thin
    object layer around `gmtime()` and [`localtime()`](#item_localtime)
    respectively, so you can do things like `print gmtime()->year`. Of
    course, that *still* prints the year minus 1900.

-   **[Time::Local]{#item_time%3a%3alocal}**\

    This core module provide functions that translate from the array of
    components returned by [`localtime()`](#item_localtime) or
    `gmtime()` back to an epoch time.

-   **[POSIX.pm]{#item_posix%2epm}**\

    The `POSIX` module included with Perl provides interfaces to several
    common C library functions for datetimes, such as `strftime()`. I
    consider this the last refuge for the desperate, because the
    [`POSIX.pm`](#item_posix%2epm) module is a memory hog, and the C
    library interface is rather un-Perlish.

### [The Big Stars]{#the_big_stars}

These are the modules that have the longest history, and are the most
widely used.

-   **[TimeDate distribution]{#item_timedate_distribution}**\

    This distribution, maintained and mostly written by Graham Barr,
    includes three modules. `Date::Format` module provides a few
    functions for formatting datetime output, including a `strftime()`
    similar to the one in the standard C library. It can work with
    either epoch times, or the array of components returned by Perl's
    [`localtime()`](#item_localtime) function.

    `Date::Parse` parses a limited set of common datetime formats,
    returning either an epoch time or an array of components.

    The distribution also includes a number of language modules which
    can be used to localize both parsing and formatting.

    Finally, `Time::Zone` provides an interface to time zone offsets,
    based on short time zone names like "EST" or "GMT". As was mentioned
    before, these names are not official or standardized, so they are of
    limited usefulness.

    All of these modules are limited by their use of epoch time
    internally, but they are fairly quick and light weight. For complex
    datetime problems, these modules probably don't automate enough of
    the dirty work.

-   **[Time::Piece]{#item_time%3a%3apiece}**\

    Written and maintained by Matt Sergeant, this module is based on an
    interface designed by Larry Wall. It provides a convenient object
    API for datetimes, though the API is a bit confusing. For example,
    `$time->mon` returns the month number (1-12) while `$time->month`
    returns the abbreviated name of the month.

    It also implements basic parsing and formatting via the use of the
    C-level `strptime()` and `strftime()` functions. The included
    `Time::Seconds` module allows for basic date math, such as
    `$tomorrow = $time + ONE_DAY`.

    The implementation is fairly lightweight, but is limited by its use
    of epoch time as the internal representation. It is certainly
    useful, but like the TimeDate modules, it doesn't go far enough for
    more complex uses.

    As of this writing, Matt Sergeant has released an experimental
    version of [`Time::Piece`](#item_time%3a%3apiece) based on my
    `DateTime.pm` module. This leaves the
    [`Time::Piece`](#item_time%3a%3apiece) API unchanged, but allows it
    to handle dates that cannot be represented by a given system's
    epoch.

-   **[Date::Manip]{#item_date%3a%3amanip}**\

    Sullivan Beck's [`Date::Manip`](#item_date%3a%3amanip) is really
    huge, weighing in at about 3,000 lines of code. As might be expected
    of that much code, there is something for everyone here. It handles
    parsing, formatting, date math, as well as more esoteric things like
    recurring datetimes and business day calculations. It should be
    noted that it's time zone support is pretty much the same that
    provided by `Time::Zone`.

    This module's most unique feature is its very flexible parser, which
    is capable of handling things like "3 weeks ago Monday" or "next
    Sunday". It also provides some parsing for specifying recurrences,
    like "every 3rd Monday in 2003".

    Unlike everything else we've covered so far, this module is not
    limited to epoch times. It has an entirely functional interface, and
    in my opinion the API could be cleaner. I dislike the fact that some
    functions do many different things, with the output depending either
    on the argument type(s), explicit flags, or both.

    But the biggest problem with this module, which is acknowledged by
    its author, is its size. It uses lots of memory (about 3MB on my
    system), and is fairly slow to load. The former makes it problematic
    for mod\_perl, and the latter causes problems with CGI scripts. You
    can find most of its features elsewhere, in slimmer modules, but if
    size and speed are not an issue, this module almost certainly does
    everything you want.

-   **[Date::Calc]{#item_date%3a%3acalc}**\

    Steffen Beyer's [`Date::Calc`](#item_date%3a%3acalc) distribution is
    where you go when you need functionality combined with speed. This
    modules offers much of the functionality provided by
    [`Date::Manip`](#item_date%3a%3amanip), but the core
    [`Date::Calc`](#item_date%3a%3acalc) module has a much smaller
    memory footprint than [`Date::Manip`](#item_date%3a%3amanip) (about
    1MB on my box), and much greater speed. This is based its core
    implementation is in C.

    This module provides functions for calculating all sorts of
    date-related information, as well some minimal parsing and
    formatting operations. The interface requires some hand-holding to
    use, as every function returns one or more elements, never a data
    structure such as a hash, so you have to constantly deal with
    passing and receiving arrays of values.

    The distribution also includes a class called `Date::Calc::Object`,
    which can represent either a datetime *or* a "delta", the difference
    between two datetimes. This dual nature is odd, since many of the
    methods applicable to one will not work for the other. The class
    supports overloading for date math and comparison, so you can do
    things like `$date + [1, 2, 3]`, which adds one year, two months,
    and three days to the given date.

    Finally, there is a `Date::Calendar` object, which can be used to
    set up a calendar "profile" defining holidays, work days, and
    partial work days in a variety of ways. This is quite useful if you
    need to calculate a day X business days in the future, while taking
    account of a particular organization's holidays.

    None of the modules in this distribution rely on epoch time, though
    they only support positive-numbered years. Time zone support is
    extremely minimal, and is done only as offsets, without support for
    daylight saving rules. Localization for a variety of languages is
    implemented for parsing and formatting.

### [And a Cast of Thousands ...]{#and_a_cast_of_thousands_...}

It wouldn't be Perl if there weren't at least a dozen other modules with
overlapping functionality, right? In this case, there's more than two
dozen! For sanity's sake, I've excluded more than a few modules, in
particular those that either appeared to be unmaintained, or those
without enough comprehensible documentation for me to figure out what
the heck they do. In alphabetical order, those remaining are:

-   **[Astro::Sunrise - Ron
    Hill]{#item_astro%3a%3asunrise_%2d_ron_hill}**\

    This module provides sunrise and sunset times, given a specific date
    and place.

-   **[Astro::Time - Chris
    Phillips]{#item_astro%3a%3atime_%2d_chris_phillips}**\

    Contains a number of functions useful when dealing with datetimes as
    they are used in astronomy.

-   **[Class::Date - Bal&0xE1;zs
    Szab&0xF3;]{#item_class%3a%3adate_%2d_balzs_szab}**\

    This is basically the [`Time::Piece`](#item_time%3a%3apiece) API
    plus more stuff. It appears to provide complete time zone support
    based on the Olson database, by way of
    [`POSIX.pm`](#item_posix%2epm). It is epoch-limited.

-   **[Date::Business - Richard
    DeSimine]{#item_date%3a%3abusiness_%2d_richard_desimine}**\

    A simple interface for doing date math with business dates. In other
    words, weekends don't count, and you can define your own holidays.
    This module is epoch-limited.

-   **[Date::Convert - Mordechai
    Abzug]{#item_date%3a%3aconvert_%2d_mordechai_abzug}**\

    Converts dates between the Gregorian, Hebrew, and Julian calendars.

-   **[Date::Convert::French\_Rev - Jean
    Forget]{#item_date%3a%3aconvert%3a%3afrench_rev_%2d_jean_forget}**\

    Converts to and from the French Revolutionary calendar.

-   **[Date::Day - John Von
    Essen]{#item_date%3a%3aday_%2d_john_von_essen}**\

    Tells you the day of the week for a given date.

-   **[Date::DayofWeek - Rich
    Bowen]{#item_date%3a%3adayofweek_%2d_rich_bowen}**\

    Does exactly the same thing as `Date::Day` but only for years
    1500-2699. On the flip side, it uses a cuter algorithm.

-   **[Date::Decade - Michael
    Diekmann]{#item_date%3a%3adecade_%2d_michael_diekmann}**\

    Provides three decade calculation functions with an API similar to
    that of [`Date::Calc`](#item_date%3a%3acalc).

-   **[Date::Discordian - Rich
    Bowen]{#item_date%3a%3adiscordian_%2d_rich_bowen}**\

    Converts to and from the Discordian calendar.

-   **[Date::Easter - Rich
    Bowen]{#item_date%3a%3aeaster_%2d_rich_bowen}**\

    Calculates the date Easter falls on in a given year.

-   **[Date::Handler - Benoit
    Beausejour]{#item_date%3a%3ahandler_%2d_benoit_beausejour}**\

    A date object comparable to [`Time::Piece`](#item_time%3a%3apiece),
    but with a more consistent interface. It implements localization, a
    variety of date math operations, and includes an object for
    representing datetime spans. It provides time zone support based on
    the native OS implementation, which on some systems means support
    for the Olson database. It is epoch-limited.

-   **[Date::ICal - Rich Bowen]{#item_date%3a%3aical_%2d_rich_bowen}**\

    A date object that provides a simple API, date math, and iCal
    formatting and parsing (see RFC 2445). It only support time zones as
    offsets, but it is not epoch-limited.

-   **[Date::ISO - Rich Bowen]{#item_date%3a%3aiso_%2d_rich_bowen}**\

    A subclass of Date::ICal that adds ISO 8601 format parsing and
    formatting.

-   **[Date::Japanese::Era - Tatsuhiko
    Miyagawa]{#item_date%3a%3ajapanese%3a%3aera_%2d_tatsuhiko_miyagawa}**\
    C

    onverts to and from Japanese Era dates.

-   **[Date::Japanese::Holiday - Tomohiro
    Ikebe]{#item_date%3a%3ajapanese%3a%3aholiday_%2d_tomohiro_ikebe}**\

    Tells you whether or not a given date is a Japanese holiday.

-   **[Date::Leapsecond - Fl&0xE1;vio Soibelmann
    Glock]{#item_date%3a%3aleapsecond_%2d_flvio_soibelmann_glock}**\

    Converts between UT1 and UTC times.

-   **[Date::Leapyear - Rich
    Bowen]{#item_date%3a%3aleapyear_%2d_rich_bowen}**\

    One function to tell you whether or not a given year is a leap year.

-   **[Date::Maya - Abigail]{#item_date%3a%3amaya_%2d_abigail}**\

    Converts between Julian days and the Mayan calendar.

-   **[Date::Passover - Rich
    Bowen]{#item_date%3a%3apassover_%2d_rich_bowen}**\

    Calculates the dates of Passover and Rosh Hashanah for a given year.

<!-- -->

-   **[Date::PeriodParser - Simon
    Cozens]{#item_date%3a%3aperiodparser_%2d_simon_cozens}**\

    Parses English descriptions of time periods like "this morning" or
    "around two weeks ago" and turns them into pairs of epoch times
    representing the beginning and end of the period.

-   **[Date::Range - Tony
    Bowden]{#item_date%3a%3arange_%2d_tony_bowden}**\

    An object for representing a range of dates. Lets you figure out
    whether two ranges overlap, whether a date is included in a given
    range, and a few other useful things.

-   **[Date::Roman - Leo
    Cacciari]{#item_date%3a%3aroman_%2d_leo_cacciari}**\

    An object for representing dates according to the Roman calendar.

-   **[Date::Set - Fl&0xE1;vio Soibelmann
    Glock]{#item_date%3a%3aset_%2d_flvio_soibelmann_glock}**\

    An object that represents sets of datetimes. A set can be either a
    datetime span, a recurring set of dates, or a fixed set of specific
    datetimes. It provides set math operations for all of these, as well
    as allowing you to iterate across the members of the set. Also see
    `Date::Set::Timezone`.

-   **[Date::Simple - John
    Tobey]{#item_date%3a%3asimple_%2d_john_tobey}**\
    A

    date object that represents dates only, without a time component. It
    provides date math. It is not epoch-limited.

-   **[Date::Tie - Fl&0xE1;vio Soibelmann
    Glock]{#item_date%3a%3atie_%2d_flvio_soibelmann_glock}**\

    A basic date object with date math. Its functionality is implemented
    via a tied hash interface. It supports fixed offset time zones, and
    it is epoch-limited.

-   **[HTTP::Date - Gisle Aas]{#item_http%3a%3adate_%2d_gisle_aas}**\

    This module is part of the LWP distribution. It parses many common
    datetime formats, including all of those that are used by the HTTP
    protocol. If `Date::Parse` doesn't understand all the formats you
    need to deal with, this module provides a good alternative.

-   **[Time::Duration - Sean
    Burke]{#item_time%3a%3aduration_%2d_sean_burke}**\

    Given a number of seconds, this module return a human language
    description of the duration. For example, 3660 seconds would be "1
    hour and 1 minute".

-   **[Time::Human - Simon
    Cozens]{#item_time%3a%3ahuman_%2d_simon_cozens}**\

    Given an epoch time, this module can return a string describing that
    time in colloquial terms, such as "half past nine". It has hooks for
    localization.

-   **[Time::Unix - Nathan
    Wiger]{#item_time%3a%3aunix_%2d_nathan_wiger}**\

    Loading this module forces Perl's [`time()`](#item_time) function to
    use the Unix epoch system, regardless of the OS on which the code is
    running.

-   **[Time modules - David Muir
    Sharnoff]{#item_time_modules_%2d_david_muir_sharnoff}**\

    This distribution includes `Time::CTime`, `Time::ParseDate`, and
    `Time::Timezone`, which are slightly more powerful versions of
    Graham Barr's `Date::Format`, `Date::Parse`, and `Time::Zone`.

### [But Wait, There's More!]{#but_wait,_there's_more!}

Not content to leave well enough alone, I've recently started a project
to fix what I see as the fundamental problem with the state of Perl
datetime modules. That fundamental problem is that despite the fact that
almost all the possible functionality you could want exists, it is
scattered over a large number of incompatible modules.

For example, [`Date::Calc`](#item_date%3a%3acalc) provides good
functionality for various datetime calculations and date math, but the
values it returns are not well suited for being passed to
`Date::Format`. And while [`Date::Manip`](#item_date%3a%3amanip) has
powerful parsing, the return value from its parsing routine cannot be
passed to any other module without further massaging. And so and so on.

For example, if I wanted to parse a date with `Date::Parse` and then
calculate the date one week later with
[`Date::Calc`](#item_date%3a%3acalc), and then format it with
`Date::Format`, I'd have to do the following:

    my $time1 = str2time($date_string); # Date::Parse

    # Today() from Date::Calc returns
    # date information for an epoch time
    my ($y1, $m1, $d1) = Today($time);

    my ($y2, $m2, $d2) = Add_Delta_Days($y1, $m1, $d1, 7);

    my $time2 = Date_to_Time($y2, $m2, $d2);

    print strftime('%B %d, %Y', $time2);

Of course, I didn't *have* to use the `strftime()` function for
formatting a date. I could have done it with just
[`Date::Calc`](#item_date%3a%3acalc) as:

    print sprintf('%s %02d %04d',
    Month_to_Text($m2), $d2, $y2);

But I want convenience. If I'm dealing with many datetimes and I need to
parse various inputs, generate different formats, and do lots of
calculations, then a convenient and uniform API can go a long way
towards code maintainability. The extra glue code needed to make
different modules cooperate can quickly obscure the actual intent of the
program.

Efforts in the past to herd all the existing module authors towards a
common API have failed, so rather than try that again, I decided to just
write even more datetime code. As we all know, the best way to put out a
fire is to pour copious amounts of gasoline on it. In order to make my
project sound cool, I'm calling it the "Perl DateTime Suite", which
sounds much better than "more date and time modules".

The goal for this project is to produce a suite of datetime modules that
do everything you'd ever need related to dates and times. The modules in
this suite will cooperate with each other, which means that a module
that parses datetimes will return a standard object, and a module for
formatting datetimes will accept that standard object.

So far, this project has attracted interest from a number of people, and
discussions on the <datetime@perl.org> list have gone well. Recently, I
released alpha versions of the core object, `DateTime.pm`, as well as
`DateTime::TimeZone`, which provides complete time zone support based on
the Olson database. There is also an alpha of `DateTime::Format::ICal`
on CPAN, a module for parsing and formatting iCal datetimes and
durations. In the future, look for more modules in the suite, all of
which will begin with "DateTime::".

### [Further Resources and Reading]{#further_resources_and_reading}

Some excellent online resources include Claus Tondering's Calendar FAQ
at <http://www.tondering.dk/claus/calendar.html,> as well as the US
Naval Observatory Time Service site at <http://tycho.usno.navy.mil/.>
For more information on time zones and the Olson database, see
<http://www.twinsun.com/tz/tz-link.htm.>

If you're interested in discussing anything related to Perl and
datetimes, check out the <datetime@perl.org> list. You can subscribe by
sending a message to <datetime-subscribe@perl.org.>

### [Thanks]{#thanks}

Thanks to Jonathan Scott Duff, Nick Tonkin, and Iain Truskett for
reviewing this article before publication.


