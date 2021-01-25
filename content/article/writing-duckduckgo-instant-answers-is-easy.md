{
   "date" : "2015-04-20T12:33:17",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "duckduckgo",
      "perldoc",
      "cheatsheet",
      "app_duckpan"
   ],
   "title" : "Writing DuckDuckGo instant answers is easy",
   "thumbnail" : "/images/169/thumb_5E030C7A-E6E1-11E4-9A7F-886D1846911D.jpeg",
   "description" : "The privacy-focused search engine has a helpful community and great tools",
   "image" : "/images/169/5E030C7A-E6E1-11E4-9A7F-886D1846911D.jpeg",
   "categories" : "community",
   "draft" : false,
   "slug" : "169/2015/4/20/Writing-DuckDuckGo-instant-answers-is-easy"
}


**Editor note:** some of the information in this article is out of date, see our new DuckDuckGo [article](http://perltricks.com/article/189/2015/8/22/Writing-DuckDuckGo-plugins-just-got-easier) for details.

A few weeks ago, I attended NYC [Quack & Hack](http://duckduckgo.ticketleap.com/quackhacknyc/), and learned how to write DuckDuckGo instant answers. Instant answers are really cool: they are micro apps that trigger when a user searches for specific terms. For example if you search for [help tmux](https://duckduckgo.com/?q=help+tmux&ia=answer), you'll see a tmux cheatsheet displayed. This is a awesome - you can commit code that will go live on DuckDuckGo.com and the good news is that you don't have to wait until the next Quack & Hack to learn how to write one yourself; DuckDuckGo provide great tools that make it easy.

### Setting up the development environment

DuckDuckGo support several different types of instant answers, but today I'm going to focus on creating a cheatsheet, which is displayed by the search engine whenever a user searches for a matching set of keywords.

To get going you'll need Perl 5.18 or higher and have installed [App::DuckPAN]({{<mcpan "App::DuckPAN" >}}), which you can do with `cpan` or `cpanminus`:

```perl
$ cpan App::DuckPAN
# or
$ cpanm App::DuckPAN
```

You'll also need a local copy of DuckDuckGo's goodies instant answers repo [repo](https://github.com/duckduckgo/zeroclickinfo-goodies), which you can clone with Git:

```perl
$ git clone https://github.com/duckduckgo/zeroclickinfo-goodies.git
```

With both App::DuckPAN and the goodies repo installed, change into the zeroclickinfo-goodies repo, and launch the duckpan server:

```perl
$ cd zeroclickinfo-goodies
$ duckpan server
```

When you run `duckpan server`, there will probably be a lot of output, but you should see this:

    Checking asset cache...
    Starting up webserver...
    You can stop the webserver with Ctrl-C
    HTTP::Server::PSGI: Accepting connections at http://0:5000/

If you open your browser and navigate to `http://localhost:5000`, you'll be greeted with the DuckDuckGo search page (try `http://0:5000` if localhost doesn't work). Search for "help tmux" and you should see the same instant answer cheatsheet appear as on the live [website](https://duckduckgo.com/?q=help+tmux&ia=answer).

### Creating the instant answer

So now you've got the development environment setup, you're ready to create an instant answer. I'm going to create an instant answer for `perldoc` (taken from my perldoc [article](#)). I can get a headstart on this by creating the skeleton instant answer code with `duckpan new`:

```perl
$ duckpan new PerldocCheatSheet
```

This creates the basic files required for the instant answer:

    Created file: lib/DDG/Goodie/PerldocCheatSheet.pm
    Created file: t/PerldocCheatSheet.t
    Successfully created Goodie: PerldocCheatSheet

All of the logic for the instant answer is in `PerldocCheatSheet.pm`, and `duckpan` has already created a good skeleton:

```perl
package DDG::Goodie::PerldocCheatSheet;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "perldoc_cheat_sheeet";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "PerldocCheatSheeet";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PerldocCheatSheet.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers any => "triggerWord", "trigger phrase";

# Handle statement
handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;

    return unless $_; # Guard against "no answer"

    return $_;
};

1;
```

I'll fill in the answers for the abstract, [metadata](https://duck.co/duckduckhack/metadata) and [triggers](https://duck.co/duckduckhack/goodie_triggers), and the `handle` subroutine:

```perl
package DDG::Goodie::PerldocCheatSheet;
# ABSTRACT: A cheat sheet for perldoc, the Perl documentation program

use DDG::Goodie;

zci answer_type => "perldoc_cheat_sheet";
zci is_cached   => 1;

# Metadata
name "PerldocCheatSheet";
source "http://perltricks.com/article/155/2015/2/26/Hello-perldoc--productivity-booster";
description "A cheat sheet for perldoc, the Perl documentation program";
primary_example_queries "help perldoc", "perldoc cheatsheet", "perldoc commands", "perldoc ref";
category "programming";
topics qw/computing geek programming sysadmin/;
code_url
  "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PerldocCheatSheet.pm";
attribution github  => ["dnmfarrell", "David Farrell"],
            twitter => "perltricks",
            web     => 'http://perltricks.com';

# Triggers
triggers startend => (
        "perldoc",
        "perldoc help",
        "help perldoc",
        "perldoc cheat sheet",
        "perldoc cheatsheet",
        "perldoc commands",
        "perldoc ref");

# Handle statement
my $HTML = share("perldoc_cheat_sheet.html")->slurp(iomode => '<:encoding(UTF-8)');
my $TEXT= share("perldoc_cheat_sheet.txt")->slurp(iomode => '<:encoding(UTF-8)');

handle remainder => sub {
    return
        heading => 'Perldoc Cheat Sheet',
        html    => $HTML,
        answer  => $TEXT,
};

1;
```

The handle subroutine will return a plain text and an HTML version of the cheat sheet to the user. The `share` function loads static files from the `share/goodie/` directory. These files should be created in the `share/goodie/perldoc_cheat_sheet/` directory, and it is **essential** that the filenames are lowercased versions of the instant answer name, separated by underscores. So "PerldocCheatSheet" becomes "perldoc\_cheat\_sheet". You can view the files on [GitHub](https://github.com/dnmfarrell/zeroclickinfo-goodies/tree/perldoc/share/goodie/perldoc_cheat_sheet). Note that the CSS file is not referenced directly by any code: it is automagically loaded by DuckDuckGo (this is why the directory and filename must be correct). I copied the CSS from the tmux [example](https://github.com/duckduckgo/zeroclickinfo-goodies/tree/master/share/goodie/tmux_cheat_sheet), it provides two columns of text that will display side-by-side or wrap to a single column if the screen width is too narrow.

### Testing the instant answer

The quickest way to test that the instant answer is working, is with the `duckpan query` command. I can run it in the terminal:

```perl
$ duckpan query
```

This launches an interactive command line program. I can enter one of the triggers for my perldoc instant answer, and see if the server responds as expected:

    Query: perldoc ref
      You entered: perldoc ref
    ---
    DDG::ZeroClickInfo  {
        Parents       WWW::DuckDuckGo::ZeroClickInfo
        public methods (4) : DOES, has_structured_answer, new, structured_answer
        private methods (0)
        internals: {
            answer        "perldoc [option]

    Module Options
    --------------
    ...

Looking good! (I've cut the output as it's verbose). The next thing I can try is a browser test using `duckpan server`:

```perl
$ duckpan server
```

Then I point my browser at `http://localhost:5000`, and enter a trigger query for the instant answer. That works as well. Finally, I need to complete a unit test script for the instant answer. I've already got a skeleton test script which was created by `duckpan new` at the start:

```perl
#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "perldoc_cheat_sheet";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PerldocCheatSheeet )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'example query' => test_zci('query'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'bad example query' => undef,
);

done_testing;
```

I'll update the test file, and add some comments:

```perl
#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "perldoc_cheat_sheet";
zci is_cached   => 1;

# all responses for this goodie are the same
my @test_zci = (
  # regex for the plain text response
  qr/^perldoc \[option\].*Module Options.*Search Options.*Common Options.*Help.*$/s,
  # check the heading
  heading => 'Perldoc Cheat Sheet',
  # check the html pattern
  html    => qr#$#s,
);

ddg_goodie_test(
    # name of goodie to test
    ['DDG::Goodie::PerldocCheatSheet'],

    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'help perldoc'        => test_zci(@test_zci),
    'help perldoc'        => test_zci(@test_zci),
    "perldoc"             => test_zci(@test_zci),
    "perldoc help"        => test_zci(@test_zci),
    "help perldoc"        => test_zci(@test_zci),
    "perldoc cheat sheet" => test_zci(@test_zci),
    "perldoc cheatsheet"  => test_zci(@test_zci),
    "perldoc commands"    => test_zci(@test_zci),

    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'perl doc help'     => undef,
    'perl documentaton' => undef,
    'perl faq'          => undef,
    'perl help'         => undef,
);

done_testing;
```

Most of this is easy to follow; but there are a few gotchas; `@test_zci` is a variable that stores the expected output from a successful trigger of the instant answer. It's a bit of a hack: its passed to the `test_zci()` function which expects a scalar which matches the plain text response, followed by 2 key/pairs, one for the heading and one for the HTML response (see the [docs](https://duck.co/duckduckhack/test_files) for more detail). I can run this script at the command line:

```perl
$ prove -I t/PerldocCheatSheet.t
```

    t/PerldocCheatSheet.t .. ok
    All tests successful.
    Files=1, Tests=12,  0 wallclock secs ( 0.02 usr  0.00 sys +  0.17 cusr  0.01 csys =  0.20 CPU)
    Result: PASS

All the tests pass, so I'm ready to issue a pull request to the DuckDuckGo community!

### Where to go for help

Whilst the DuckDuckGo tools are great, there is also good [documentation](http://duckduckhack.com/) available and a friendly community supporting development when you need it. I spent some time on the Gitter [chatroom](https://gitter.im/duckduckgo/zeroclickinfo-goodies?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) for the instant answers repo, and the people there were friendly and responsive (and more importantly, they have commit bits :).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
