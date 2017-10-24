{
   "image" : "/images/190/9AD864D4-E6E0-11E4-B559-8B6D1846911D.jpeg",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "190/2015/8/28/Check-your-DuckDuckGo-cheatsheets-with-Perl",
   "draft" : false,
   "tags" : [
      "syntax",
      "json",
      "cheatsheet"
   ],
   "title" : "Check your DuckDuckGo cheatsheets with Perl",
   "description" : "Zero-in on any defects with this Perl script",
   "categories" : "testing",
   "date" : "2015-08-28T02:10:48"
}


With DuckDuckGo's global [Quack & Hack](https://duck.co/blog) just around the corner, I've pulled together a [script](https://github.com/dnmfarrell/DDG-cheatsheet-check) for checking [cheatsheets](http://perltricks.com/article/189/2015/8/22/Writing-DuckDuckGo-plugins-just-got-easier). The script checks the cheatsheet is valid JSON and has the required entries and values.

### Setup

To run the script, download it from [Github](https://github.com/dnmfarrell/DDG-cheatsheet-check/blob/master/cheatsheet_check). It requires the [JSON](https://metacpan.org/pod/JSON) and [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny) Perl modules which you can install with `cpan` at the terminal:

``` prettyprint
$ cpan JSON HTTP::Tiny
```

Be sure to give execute permissions to the script too:

``` prettyprint
$ chmod 744 cheatsheet_check
```

### Usage

Once you have a cheatsheet in JSON that you want to check, just pass the filepath to `cheatsheet_check`:

``` prettyprint
$ ./cheatsheet_check /path/to/cheatsheet.json
```

Example output for the `perldoc` cheatsheet:

        # Subtest: file
        ok 1 - file exists
        ok 2 - filename is appropriate
        ok 3 - file content can be read
        ok 4 - content is valid JSON
        1..4
    ok 1 - file
        # Subtest: headers
        ok 1 - has id
        ok 2 - has name
        ok 3 - has description
        1..3
    ok 2 - headers
        # Subtest: metadata
        ok 1 - has metadata
        ok 2 - has metadata sourceName
        ok 3 - has metadata sourceUrl
        ok 4 - sourceUrl is not undef
        ok 5 - fetch sourceUrl
        1..5
    ok 3 - metadata
        # Subtest: sections
        ok 1 - has section_order
        ok 2 - section_order is an array of section names
        ok 3 - has sections
        ok 4 - sections is a hash of section key/pairs
        ok 5 - 'Usage' exists in sections
        ok 6 - 'Module Options' exists in sections
        ok 7 - 'Search Options' exists in sections
        ok 8 - 'Common Options' exists in sections
        ok 9 - 'Search Options' exists in section_order
        ok 10 - 'Search Options' is an array
        ok 11 - 'Search Options' entry: 0 has a key
        ok 12 - 'Search Options' entry: 0 has a val
        ok 13 - 'Search Options' entry: 1 has a key
        ok 14 - 'Search Options' entry: 1 has a val
        ok 15 - 'Search Options' entry: 2 has a key
        ok 16 - 'Search Options' entry: 2 has a val
        ok 17 - 'Common Options' exists in section_order
        ok 18 - 'Common Options' is an array
        ok 19 - 'Common Options' entry: 0 has a key
        ok 20 - 'Common Options' entry: 0 has a val
        ok 21 - 'Common Options' entry: 1 has a key
        ok 22 - 'Common Options' entry: 1 has a val
        ok 23 - 'Common Options' entry: 2 has a key
        ok 24 - 'Common Options' entry: 2 has a val
        ok 25 - 'Common Options' entry: 3 has a key
        ok 26 - 'Common Options' entry: 3 has a val
        ok 27 - 'Common Options' entry: 4 has a key
        ok 28 - 'Common Options' entry: 4 has a val
        ok 29 - 'Module Options' exists in section_order
        ok 30 - 'Module Options' is an array
        ok 31 - 'Module Options' entry: 0 has a key
        ok 32 - 'Module Options' entry: 0 has a val
        ok 33 - 'Module Options' entry: 1 has a key
        ok 34 - 'Module Options' entry: 1 has a val
        ok 35 - 'Module Options' entry: 2 has a key
        ok 36 - 'Module Options' entry: 2 has a val
        ok 37 - 'Module Options' entry: 3 has a key
        ok 38 - 'Module Options' entry: 3 has a val
        ok 39 - 'Usage' exists in section_order
        ok 40 - 'Usage' is an array
        ok 41 - 'Usage' entry: 0 has a key
        ok 42 - 'Usage' entry: 0 has a val
        ok 43 - 'Usage' entry: 1 has a key
        ok 44 - 'Usage' entry: 1 has a val
        1..44
    ok 4 - sections
    1..4

This will run over 20 different tests against the cheatsheet. The script checks that the JSON is valid, that the required headers are present (e.g. id, name and description). It checks that the metadata is valid and points to a live URL. Finally it checks that the sections are valid and correctly mapped.

### Wrap up

Remember, even if the cheatsheet passes all the tests, you still need to check it looks right in the browser. [App::DuckPAN](https://metacpan.org/pod/App::DuckPAN) can help with that. This Saturday I'll be hanging out at the NYC Quack & Hack at [Orbital](http://www.meetup.com/Quack-Hack-New-York-City/events/224567174/). I look forward to seeing everyone there!

**Update:** added HTTP::Tiny dependency. 2015-08-28

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
