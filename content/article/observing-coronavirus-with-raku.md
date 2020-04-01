
  {
    "title"       : "Observing Coronavirus Pandemic with Raku",
    "authors"     : ["andrew-shitov"],
    "date"        : "2020-03-31T10:00:00",
    "tags"        : ["covid-19", "data processing", "csv"],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Using the Raku programming language to process and display statistical data",
    "categories"  : "raku"
  }

Every few years, a new unknown virus pops up and starts spreading around the globe. This year, the situation with COVID-19 is different not only because of the nature of the virus but also because of how deeply the Internet came to our lives. What is really good is not only that we have instant access to information updates (which is often seen from a panic angle) but also the ability to access raw data.

The group at the Johns Hopkins University Center for Systems Science and Engineering gathers data from a number of different sources, displays then on their [online dashboard](https://gisanddata.maps.arcgis.com/apps/opsdashboard/index.html#/bda7594740fd40299423467b48e9ecf6) and publishes [daily updates in CSV files](https://github.com/CSSEGISandData/COVID-19) on GitHub.

I decided to work with these raw data to display them under a different perspective to reduce panic and provide a way to quickly see real numbers and trends. The result is the launched website, [covid.observer](https://covid.observer). The [source files](https://github.com/ash/covid.observer) of it are available in the GitHub repository.

For years, Perl has been known for its BioPerl. Let’s see what Raku can bring to the society by being a good instrument for working with text data files and how we can use it to process and present data in the way we want. The heart of the site is a Raku program and a few modules that parses data and create static HTML pages.

\
![covid-observer](/images/observing-coronavirus-with-raku/covid-observer.png)
\
\

In this article, I would like to show a few most useful features that Raku offers to a developer.

### The `MAIN` function

The program works in three modes: parsing population data, getting the updates from the COVID raw data, and generating HTML files. Raku gives us a very handy way to process the command line arguments by defining different variants of the `MAIN` function. Depending on the command line parameters, a correct function is automatically called, which helps me to run the program in the desired mode.

Here are the functions that make the main work:

```perl
multi sub MAIN('population') {
    . . .
}

multi sub MAIN('fetch') {
    . . .
}

multi sub MAIN('generate') {
    . . .
}
```

In other words, we don’t need to parse the command-line options ourselves, neither need we to use any modules such as `Getopt::Long` from Perl. Moreover, Raku generates a simple help message if you miss the command or enter a wrong one:

```bash
$ ./covid.raku
Usage:
  ./covid.raku population
  ./covid.raku fetch
  ./covid.raku generate
```

Salve J. Nilsen [proposed to add](https://github.com/ash/covid.observer/pull/5) another `MAIN` function that prints the SQL commands for initializing the database. Here, you can also see how to use Boolean flags in the command line:

```perl
multi sub MAIN('setup', Bool :$force=False, Bool :$verbose=False) {
    . . .
}
```

Note the `:` before the name of the parameter. We’ll see it again later.

An additional POD comment can be added before each version of the function to print a better usage description, for example:

```perl
#| Fetch the latest data and rebuild the database
multi sub MAIN('fetch') {
    . . .
}
```

Having this done, you deliver a better usage message for the user:

```bash
Usage:
  ./covid.raku population -- Parse population CSV files
  ./covid.raku fetch -- Fetch the latest data and rebuild the database
  ./covid.raku generate -- Generate the website

```

### Reduction operators

Reduction operators are really useful. Let me remind what a reduction operator is. Actually, this is a meta-operator having a pair of square brackets, which you use to surround any infix operator (such operators take two operands).

In the program, the reduction operator is widely used for computing the totals across the data sets (e.g. for the world, or across China provinces). Let us examine a few cases with increasing difficulty.

First, there’s a simple hash, and we need to add up its values:

```perl
my %data =
    IT => 59_138,
    CN => 81_397,
    ES => 28_768;

my $total = [+] %data.values;
say $total; # 169303
```

The above example is a classical use case of the reduction operator. What I also [noticed](https://andrewshitov.com/2020/03/16/a-couple-of-syntax-sweets-in-raku/) during the work, is how the `[-]` construct helps when you need to reduce some value by a few other values:

```perl
my %data =
    confirmed => 100,
    failed    => 1,
    recovered => 70;

my $active = [-] %data<confirmed recovered failed>;
say "$active active cases";
```

Using a hash slice in the form of `%h<a b c>` also helps to make the code more compact. Compare this with the straightforward approach:

```perl
my $active = %data<confirmed> - %data<failed> - %data<recovered>;
```

### Filtering data

In the second case, the values are nested hashes. The `>>` hyperoperator can be used to extract the deeply located parts: `%data.values>><confirmed>`. Let me demonstrate this on a simplified data fragment:

```perl
my %data =
    IT => {
        confirmed => 59_138,
        population => 61, # millions
    },
    CN => {
        confirmed => 81_397,
        population => 1434
    },
    ES => {
        confirmed => 28_768,
        population => 47,
    };

my $total = [+] %data.values>><confirmed>;
say $total; # 169303
```

An alternative, and probably, a cleaner way is using the `map` method to access the desired part:

```perl
my $total2 = [+] %data.values.map: *<confirmed>;
say $total2; # 169303
```

Finally, to exclude a country from the results, you can `grep` the keys in-place.

```perl
my %x = %data.grep: *.key ne 'CN';
my $excl2 = [+] %x.values.map: *<confirmed>;
say $excl2; # 87906
```

Notice that calling `grep` directly on the hash (as in the above example) is much handier than trying to loop over the keys and filter them:

```perl
my $excluding-china =
    [+] %data{%data.keys.grep: * ne 'CN'}.values.map: *<confirmed>;
say $excluding-china; # 87906
```

### Hyper operators

In the previous section, we’ve already seen how to apply the same action to each element of the list using `>>`. Now, let us take a look at a real usage of the hyper operator `>>->>` that I used to compute the deltas of number series.

```perl
my @confirmed = 10, 20, 40, 70, 150;
my @delta = @confirmed[1..*] >>->> @confirmed;
say @delta; # [10 20 30 80]
```

The array here is a series of values for the given period of time. The task is to compute how many new cases happen in each day. Instead of making a loop, it is possible to simply ‘subtract‘ an array from itself but shifted by one element.

The `>>->>` operator takes two data series: the slice `@confirmed[1..*]` of the original data without the first element, and the original `@confirmed` array. For a given binary operator (`-` in this example), you can construct four hyper operators: `>>-<<`, `>>->>`, `<<->>`, `<<-<<`. The chosen form allows us to ignore the extra item at the end of `@confirmed` when it is applied against `@confirmed[1..*]`.

### Junctions

Let me demonstrate an example of using the junction operator `|`, which I did not discover earlier. It chooses the ending for the given ordinal number:

```perl
for 1..31 -> $day {
    my $ending = do given $day {
        when 1|21|31 {'st'}
        when 2|22    {'nd'}
        when 3       {'rd'}
        default      {'th'}
    }

    say "$day$ending";
}
```

The `when` blocks catch the corresponding numbers that need special endings. Junctions such as `1|21|31` look more elegant than a regular expression or a chain of comparisons.

### Optional and named parameters

Passing parameters to a function is a pleasant work by itself in Raku. You can pass hashes or arrays with ease:

```perl
sub chart-daily(%countries, %totals) {
    . . .
}
```

What is even more attractive is how you can add optional named parameters:

```perl
sub chart-daily(%countries, %totals, :$cc?, :$cont?, :$exclude?) {
   . . .
}
```

A column before the name makes the parameter named, and the question mark makes it optional. I am using this to modify the behaviour of the same statistical function for aggregating data over the continents, the whole world, or to exclude a single country or a region, as shown in the following examples.

Generating data for the whole world:

```perl
chart-daily(%countries, %per-day);
```

For a single country:

```perl
my $cc = 'CN';
chart-daily(%countries, %per-day, :$cc);
```

For a continent:

```perl
my $cont = 'Europe';
chart-daily(%countries, %per-day, :$cont);
```

World data excluding China:

```perl
chart-daily(%countries, %per-day, exclude => 'CN');
```

Getting data for China without its most affected province:

```perl
chart-daily(%countries, %per-day, cc => 'CN', exclude => 'CN/HB');
```

### A built-in template engine

The project generates more than 200 HTML files, so templating is an important part of it. Fortunately, Raku has a great out-of-the-box templating mechanism, which is much more powerful than simple variable interpolation.

A minimal example is substituting variables:

```perl
return qq:to/HTML/;
    <div id="countries-list">
        $html
    </div>
    HTML
```

By the way, notice that Raku lets you keep the indentation of a multi-line string by simply indenting its closing symbol. No extra spaces at the beginning of the lines will appear in the result.

A more exciting thing is that you can embed Raku code blocks into strings, and those blocks can contain any logic you need to make a right decision somewhere in the middle of the template.

```perl
my $content = qq:to/HTML/;
    <h1>Coronavirus in {$country-name}</h1>

    <div class="affected">
        {
            if $chart2data<confirmed> {
                'Affected 1 of every ' ~
                    fmtnum((1_000_000 * $population /
                        $chart2data<confirmed>).round())
            }
            else {
                'Nobody affected'
            }
        }
    </div>
    HTML
```

Here, the string builds itself depending on data. For each generated country, the string ’chooses‘ which phrase to embed and how to format the number. The `if` block is a relatively big chunk of Raku code that generates a string, which is used in place of the whole block in curly braces. Thus, inside this embedded code block you can freely manipulate data from the outside code.

### Afterword

I must say that it is quite exciting to use Raku for a real project. As you could see from the examples, many of its ‘strange‘ features demonstrate how useful they are in different circumstances. Examine the code in the [GitHub repository](https://github.com/ash/covid.observer) and follow the updates about the site [in my blog](https://andrewshitov.com/category/covid-19/).
