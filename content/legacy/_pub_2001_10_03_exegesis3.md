{
   "date" : "2001-10-03T00:00:00-08:00",
   "categories" : "perl-6",
   "image" : null,
   "title" : "Exegesis 3",
   "tags" : [],
   "thumbnail" : "/images/_pub_2001_10_03_exegesis3/111-exegesis.jpg",
   "slug" : "/pub/2001/10/03/exegesis3.html",
   "description" : " Editor's note: this document is out of date and remains here for historic interest. See Synopsis 3 for the current design information. Diamond lives (context-aware); Underscore space means concatenate; fat comma means pair; A pre-star will flatten; colon-equals will...",
   "draft" : null,
   "authors" : [
      "damian-conway"
   ]
}



*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 3](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the current design information.*

> *Diamond lives (context-aware);*
> *Underscore space means concatenate; fat comma means pair;*
> *A pre-star will flatten; colon-equals will bind;*
> *And binary slash-slash yields left-most defined.*
>
> > -- Sade, "Smooth operator" (Perl 6 remix)

In [Apocalypse 3](/pub/2001/10/02/apocalypse3.html), Larry describes the changes that Perl 6 will make to operators and their operations. As with all the Apocalypses, only the new and different are presented -- just remember that the vast majority of operator-related syntax and semantics will stay precisely as they are in Perl 5.

### <span id="for example..."></span>For example...

To better understand those new and different aspects of Perl 6 operators, let's consider the following program. Suppose we wanted to locate a particular data file in one or more directories, read the first four lines of each such file, report and update their information, and write them back to disk.

We could do that with this:

        sub load_data ($filename ; $version, *@dirpath) {
            $version //= 1;
            @dirpath //= @last_dirpath // @std_dirpath // '.';
            @dirpath ^=~ s{([^/])$}{$1/};

            my %data;
            foreach my $prefix (@dirpath) {
                my $filepath = $prefix _ $filename;
                if (-w -r -e $filepath  and  100 < -s $filepath <= 1e6) {
                    my $fh = open $filepath : mode=>'rw'
                        or die "Something screwy with $filepath: $!";
                    my ($name, $vers, $status, $costs) = <$fh>;
                    next if $vers < $version;
                    $costs = [split /\s+/, $costs];
                    %data{$filepath}{qw(fh name vers stat costs)} =
                                    ($fh, $name, $vers, $status, $costs);
                }
            }
            return %data;
        }

        my @StartOfFile is const = (0,0);

        sub save_data ( %data) {
            foreach my $data (values %data) {
                my $rest = <$data.{fh}.irs(undef)>
                seek $data.{fh}: *@StartOfFile;
                truncate $data.{fh}: 0;
                $data.{fh}.ofs("\n");
                print $data.{fh}: $data.{qw(name vers stat)}, _@{$data.{costs}}, $rest;
             }
        }

        my %data = load_data(filename=>'weblog', version=>1);

        my $is_active_bit is const = 0x0080;

        foreach my $file (keys %data) {
            print "$file contains data on %data{$file}{name}\n";

            %data{$file}{stat} = %data{$file}{stat} ~ $is_active_bit;

            my @costs := @%data{$file}{costs};

            my $inflation;
            print "Inflation rate: " and $inflation = +<>
                until $inflation != NaN;

            @costs = map  { $_.value }
                     sort { $a.key <=> $b.key }
                     map  { amortize($_) => $_ }
                            @costs ^* $inflation;

            my sub operator:∑ is prec(\&operator:+($)) (*@list : $filter //= undef) {
                   reduce {$^a+$^b}  ($filter ?? grep &$filter, @list :: @list);
            }

            print "Total expenditure: $( ∑ @costs )\n";
            print "Major expenditure: $( ∑ @costs : {$^_ >= 1000} )\n";
            print "Minor expenditure: $( ∑ @costs : {$^_ < 1000} )\n";

            print "Odd expenditures: @costs[1..Inf:2]\n";
        }

        save_data(%data, log => {name=>'metalog', vers=>1, costs=>[], stat=>0});

### <span id="i was bound under a flattening star"></span>I was bound under a flattening star

The first subroutine takes a filename and (optionally) a version number and a list of directories to search:

        sub load_data ($filename ; $version, *@dirpath) {

Note that the directory path parameter is declared as `*@dirpath`, not `@dirpath`. In Perl 6, declaring a parameter as an array (i.e `@dirpath`) causes Perl to expect the corresponding argument will be an actual array (or an array reference), not just any old list of values. In other words, a `@` parameter in Perl 6 is like a `\@` context specifier in Perl 5.
To allow `@dirpath` to accept a list of arguments, we have to use the *list context specifier* -- unary `*` -- to tell Perl to "slurp up" any remaining arguments into the `@dirpath` parameter.

This slurping-up process consists of flattening any arguments that are arrays or hashes, and then assigning the resulting list of values, together with any other scalar arguments, to the array (i.e. to `@dirpath` in this example). In other words, a `*@` parameter in Perl 6 is like a `@` context specifier in Perl 5.

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 3](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the current design information.*

### <span id="it's a setup"></span>It's a setup

In Perl 5, it's not uncommon to see people using the `||=` operator to set up default values for subroutine parameters or input data:

        $offset ||= 1;
        $suffix ||= $last_suffix || $default_suffix || '.txt';
        # etc.

Of course, unless you're sure of your range of values, this can go horribly wrong -- specifically, if the variable being initialized already has a valid value that Perl happens to consider false (i.e if `$suffix` or `$last_suffix` or `$default_suffix` contained an empty string, or the offset really *was* meant to be zero).

So people have been forced to write default initializers like this:

        $offset = 1 unless defined $offset;

which is OK for a single alternative, but quickly becomes unwieldy when there are several alternatives:

        $suffix = $last_suffix    unless defined $suffix;
        $suffix = $default_suffix unless defined $suffix;
        $suffix = '.txt'          unless defined $suffix;

Perl 6 introduces a binary 'default' operator -- `//` -- that solves this problem. The default operator evaluates to its left operand if that operand is defined, otherwise it evaluates to its right operand. When chained together, a sequence of `//` operators evaluates to the first operand in the sequence that is defined. And, of course, the assignment variant -- `//=` -- only assigns to its lvalue if that lvalue is currently undefined.

The symbol for the operator was chosen to be reminiscent of a `||`, but one that's taking a slightly different angle on things.

So `&load_data` ensures that its parameters have sensible defaults like this:

        $version //= 1;
        @dirpath //= @last_dirpath // @std_dirpath // '.';

Note that it will also be possible to provide default values directly in the specification of optional parameters, probably like this:
        sub load_data ($filename ; $version //= 1, *@dirpath //= @std_dirpath) {...}

### <span id="...and context for all"></span>...and context for all

As if it weren't broken enough already, there's another nasty problem with using `||` to build default initializers in Perl 5. Namely, that it doesn't work quite as one might expect for arrays or hashes either.
If you write:

        @last_mailing_list = ('me', 'my@shadow');

        # and later...

        @mailing_list = @last_mailing_list || @std_mailing_list;

then you get a nasty surprise: In Perl 5, `||` (and `&&`, for that matter) always evaluates its left argument in *scalar* context. And in a scalar context an array evaluates to the number of elements it contains, so `@last_mailing_list` evaluates to `2`. And that's what's assigned to `@mailing_list` instead of the actual two elements.
Perl 6 fixes that problem, too. In Perl 6, both sides of an `||` (or a `&&` or a `//`) are evaluated in the same context as the complete expression. That means, in the example above, `@last_mailing_list` is evaluated in list context, so its two elements are assigned to `@mailing_list`, as expected.

### <span id="substitute our vector, victor!"></span>Substitute our vector, Victor!

The next step in `&load_data` is to ensure that each path in `@dirpath` ends in a directory separator. In Perl 5, we might do that with:
        s{([^/])$}{$1/} foreach @dirpath;

but Perl 6 gives us another alternative: hyper-operators.
Normally, when an array is an operand of a unary or binary operator, it is evaluated in the scalar context imposed by the operator and yields a single result. For example, if we execute:

        $account_balance   = @credits + @debits;
        $biblical_metaphor = @sheep - @goats;

then `$account_balance` gets the total number of credits plus the number of debits, and `$biblical_metaphor` gets the numerical difference between the number of `@sheep` and `@goats`.
That's fine, but this scalar coercion also happens when the operation is in a list context:

        @account_balances   = @credits + @debits;
        @biblical_metaphors = @sheep - @goats;

Many people find it counter-intuitive that these statements each produce the same scalar result as before and then assign it as the single element of the respective lvalue arrays.
It would be more reasonable to expect these to act like:

        # Perl 5 code...
        @account_balances   =
                map { $credits[$_] + $debits[$_] } 0..max($#credits,$#debits);
        @biblical_metaphors =
                map { $sheep[$_] - $goats[$_] } 0..max($#sheep,$#goats);

That is, to apply the operation element-by-element, pairwise along the two arrays.
Perl 6 makes that possible, though *not* by changing the list context behavior of the existing operators. Instead, Perl 6 provides a "vector" version of each binary operator. Each uses the same symbol as the corresponding scalar operator, but with a caret (`^`) dangled in front of it. Hence to get the one-to-one addition of corresponding credits and debits, and the list of differences between pairs of sheep and goats, we can write:

        @account_balances   = @credits ^+ @debits;
        @biblical_metaphors = @sheep ^- @goats;

This works for *all* unary and binary operators, including those that are user-defined. If the two arguments are of different lengths, the operator Does What You Mean (which, depending on the operator, might involve padding with ones, zeroes or `undef`'s, or throwing an exception).

If one of the arguments is a scalar, that operand is replicated as many times as is necessary. For example:

        @interest = @account_balances ^* $interest_rate;

Which brings us back to the problem of appending those directory separators. The "pattern association" operator (`=~`) can also be vectorized by prepending a caret, so we can apply the necessary substitution to each element in the `@dirpath` array like this:
        @dirpath ^=~ s{([^/])$}{$1/};

### <span id="(pre)fixing those filenames"></span>(Pre)fixing those filenames

Having ensured everything is set up correctly, `&load_data` then processes each candidate file in turn, accumulating data as it goes:
        my %data;
        foreach my $prefix (@dirpath) {

The first step is to create the full file path, by prefixing the current directory path to the basic filename:
            my $filepath = $prefix _ $filename;

And here we see the new Perl 6 string concatenation operator: underscore. And yes, we realize it's going to take time to get used to. It may help to think of it as the old dot operator under extreme acceleration.
Underscore is still a valid identifier character, so you need to be careful about spacing it from a preceding or following identifier (just as you've always have with the `x` or `eq` operators):

        # Perl 6 code                   # Meaning

        $name = getTitle _ getName;     # getTitle() . getName()
        $name = getTitle_ getName;      # getTitle_(getName())
        $name = getTitle _getName;      # getTitle(_getName())
        $name = getTitle_getName;       # getTitle_getName()

In Perl 6, there's also a unary form of `_`. We'll get to that [a little later](/pub/2001/10/03/exegesis3.html?page=4#string%20'em%20up%20together).
*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 3](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the current design information.*

### <span id="don't break the chain"></span>Don't break the chain

Of course, we only want to load the file's data if the file exists, is readable and writable, and isn't too big or too small (say, no less than 100 bytes and no more than a million). In Perl 5 that would be:
        if (-e $filepath  &&  -r $filepath  &&  -w $filepath  and
            100 < -s $filepath  &&  -s $filepath <= 1e6) {...

which has far too many `&&`'s and `$filepath`'s for its own good.
In Perl 6, the same set of tests can be considerably abbreviated by taking advantage of two new types of operator chaining:

        if (-w -r -e $filepath  and  100 < -s $filepath <= 1e6) {...

First, the `-X` file test operators now all return a special object that evaluates true or false in a boolean context but is really an encapsulated `stat` buffer, to which subsequent file tests can be applied. So now you can put as many file tests as you like in front of a single filename or filehandle and they must all be true for the whole expression to be true. Note that because these are really nested calls to the various file tests (i.e. `-w(-r(-e($filepath)))`), the series of tests are effectively evaluated in right-to-left order.
The test of the file size uses another new form of chaining that Perl 6 supports: multiway comparisons. An expression like `100 < -s $filepath <= 1e6` isn't even legal Perl 5, but it Does The Right Thing in Perl 6. More importantly, it short-circuits if the first comparison fails and will evaluate each operand only once.

### <span id="open for business"></span>Open for business

Having verified the file's suitability, we open it for reading and writing:
        my $fh = open $filepath : mode=>'rw'
            or die "Something screwy with $filepath: $!";

The `: mode=>'rw'` is an *adverbial modifier* on the `open`. We'll see more adverbs [shortly](/pub/2001/10/03/exegesis3.html?page=7#would%20you%20like%20an%20adverb%20with%20that).
The `$!` variable is exactly what you think it is: a container for the last system error message. It's also considerably *more* than you think it is, since it's also taken over the roles of `$?` and `$@`, to become the One True Error Variable.

### <span id="applied laziness 101"></span>Applied laziness 101

Contrary to earlier rumors, the "diamond" input operator is alive and well and living in Perl 6 (yes, the Perl Ministry of Truth is even now rewriting [Apocalypse 2](/pub/2001/05/03/wall.html) to correct the ... err ... "printing error" ... that announced `<>` would be purged from the language).
So we can happily proceed to read in four lines of data:

        my ($name, $vers, $status, $costs) = <$fh>;

Now, writing something like this is a common Perl 5 mistake -- the list context imposed by the list of lvalues induces `<$fh>` to read the entire file, create a list of (possibly hundreds of thousands of) lines, assign the first four to the specified variables, and throw the rest away. That's rarely the desired effect.
In Perl 6, this statement works as it should. That is, it works out how many values the lvalue list is actually expecting and then reads only that many lines from the file.

Of course, if we'd written:

        my ($name, $vers, $status, $costs, @and_the_rest) = <$fh>;

then the entire file *would* have been read.

### <span id="and now for something completely the same (well, almost)"></span>And now for something completely the same (well, almost)

Apart from the new sigil syntax (i.e. hashes now keep their `%` signs no matter what they're doing), the remainder of `&load_data` is exactly as it would have been if we'd written it in Perl 5.
We skip to the next file if the current file's version is wrong. Otherwise, we split the costs line into an array of whitespace-delimited values, and then save everything (including the still-open filehandle) in a nested hash within `%data`:

                next if $vers < $version;
                $costs = [split /\s+/, $costs];
                %data{$filepath}{qw(fh name vers stat costs)} =
                              ($fh, $name, $vers, $status, $costs);
                }
            }

Then, once we've iterated over all the directories in `@dirpath`, we return the accumulated data:
            return %data;
        }

### <span id="the virtue of constancy"></span>The virtue of constancy

Perl 6 variables can be used as constants:
        my @StartOfFile is const = (0,0);

which is a great way to give logical names to literal values, but ensure that those named values aren't accidentally changed in some other part of the code.

### <span id="writing it back"></span>Writing it back

When the data is eventually saved, we'll be passing it to the `&save_data` subroutine in a hash. If we expected the hash to be a real hash variable (or a reference to one), we'd write:
        sub save_data (%data) {...

But since we want to allow for the possibility that the hash is created on the fly (e.g. from a hash-like list of values), we need to use the slurp-it-all-up list context asterisk again:
        sub save_data (*%data) {...

### <span id="from each according to its ability ... "></span>From each according to its ability ...

We then grab each datum for each file with the usual `foreach ... values ... ` construct:
            foreach my $data (values %data) {

and go about saving the data to file.
### <span id="your allinone input supplier"></span>Your all-in-one input supplier

Because the Perl 6 "diamond" operator can take an arbitrary expression as its argument, it's possible to set a filehandle to read an entire file *and* do the actual reading, all in a single statement:
        my $rest = <$data.{fh}.irs(undef)>

The variable `$data` stores a reference to a hash, so to dereference it and access the `'fh'` entry, we use the Perl 6 dereferencing operator (dot) and write: `$data.{fh}`. In practice, we could leave out the operator and just write `$data{fh}`, since Perl can infer from the `$` sigil that we're accessing the hash through a reference held in a scalar. In fact, in Perl 6 the only place you *must* use an explicit `.` dereferencer is in a method call. But it never hurts to say exactly what you mean, and there's certainly no difference in performance if you do choose to use the dot.
The `.irs(undef)` method call then sets the input record separator of the filehandle (i.e. the Perl 6 equivalent of `$/`) to `undef`, causing the next read operation to return the remaining contents of the file. And because the filehandle's `irs` method returns its own invocant -- i.e. the filehandle reference -- the entire expression can be used within the angle brackets of the read.

A variation on this technique allows a Perl program to do a shell-like read-from-filename just as easily:

        my $next_line = <open $filename or die>;

or, indeed, to read the whole file:
        my $all_lines = < open $filename : irs=>undef >;

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 3](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the current design information.*

### <span id="seek and ye shall flatten"></span>Seek and ye shall flatten

Having grabbed the entire file, we now rewind and truncate it, in preparation for writing it back:
        seek $data.{fh}: *@StartOfFile;
        truncate $data.{fh}: 0;

You're probably wondering what's with the asterisk ... unless you've ever tried to write:
        seek $filehandle, @where_and_whence;

in Perl 5 and gotten back the annoying `"Not enough arguments for seek"` exception. The problem is that `seek` expects three distinct scalars as arguments (as if it had a Perl 5 prototype of `seek($$$)`), and it's too fastidious to flatten the proffered array in order to get them.
It's handy to wrap the magical `0,0` arguments of the `seek` in a single array (so we no longer have to remember this particular incantation), but to use such an array in Perl 5 we would then have to write:

        seek $data->{fh}, $StartOfFile[0], $StartOfFile[1];    # Perl 5

In Perl 6 that's not a problem, because we have `*` -- the list context specifier. When used in an argument list, it takes whatever you give it (typically an array or hash) and flattens it. So:
        seek $data.{fh}: *@StartOfFile;                        # Perl 6

massages the single array into a list of two scalars, as `seek` requires.
Oh, and yes, that *is* the adverbial colon again. In Perl 6, `seek` and `truncate` are both methods of filehandle objects. So we can either call them as:

        $data.{fh}.seek(*@StartOfFile);
        $data.{fh}.truncate(0);

Or use the "indirect object" syntax:
        seek $data.{fh}: *@StartOfFile;
        truncate $data.{fh}: 0;

And that's where the colon comes in. Another of its many uses in Perl 6 is to separate "indirect object" arguments (e.g. filehandles) from the rest of the argument list. The main place you'll see colons guarding indirect objects is in `print` statements (as described in the next section).

### <span id="it is written..."></span>It is written...

Finally, `&save_data` has everything ready and can write the four fields and the rest of the file back to disk. First, it sets the output field separator for the filehandle (i.e. the equivalent of Perl 5's `$,` variable) to inject newlines between elements:

        $data.{fh}.ofs("\n");

Then it prints the fields to the filehandle:
        print $data.{fh}: $data.{qw(name vers stat)}, _@{$data.{costs}}, $rest;

Note the use of the adverbial colon after `$data.{fh}` to separate the filehandle argument from the items to be printed. The colon is required because it's how Perl 6 eliminates the nasty ambiguity inherent in the "indirect object" syntax. In Perl 5, something like:

        print foo bar;

could conceivably mean:

        print {foo} (bar);    # Perl 5: print result of bar() to filehandle foo

or

        print ( foo(bar) );   # Perl 5: print foo() of bar() to default filehandle

or even:

        print ( bar->foo );   # Perl 5: call method foo() on object returned by
                              #         bar() and print result to default filehandle

In Perl 6, there is no confusion, because each indirect object must followed by a colon. So in Perl 6:

        print foo bar;

can only mean:

        print ( foo(bar) );   # Perl 6: print foo() of bar() to default filehandle

and to get the other two meanings we'd have to write:

        print foo: bar;       # Perl 6: print result of bar() to filehandle foo()
                              #         (foo() not foo, since there are no
                              #          bareword filehandles in Perl 6)

and:

        print foo bar: ;      # Perl 6: call method foo() on object returned by
                              #         bar() and print result to default filehandle

In fact, the colon has an even wider range of use, as a general-purpose "adverb marker"; a notion we will explore more fully [below](#would%20you%20like%20an%20adverb%20with%20that).

### <span id="string 'em up together"></span>String 'em up together

The printed arguments are: a hash slice:

        $data.{qw(name vers stat)},

a stringified dereferenced nested array:
         _@{$data.{costs}},

and a scalar:
        $rest;

The new hash slice syntax was explained in the previous Apocalypse/Exegesis, and the scalar is just a scalar, but what was the middle thing again?
Well, `$data.{costs}` is just a regular Perl 6 access to the `'costs'` entry of the hash referred to by `$data`. That entry contains the array reference that was the result of splitting `$cost` [in `&load_data`](/pub/2001/10/03/exegesis3.html?page=3#and%20now%20for%20something%20completely%20the%20same%20(well,%20almost)).

So to get the actual array itself, we can prefix the array reference with a `@` sigil (though, technically, we don't *have* to: in Perl 6 arrays and array references are interchangeable in scalar context).

That gives us `@{$data.{costs}}`. The only remaining difficulty is that when we print the list of items produced by `@{$data.{costs}}`, they are subject to the output field separator. Which we just set to newline.

But what we want is for them to appear on the *same* line, with a space between each.

Well ... evaluating a list in a string context does precisely that, so we could just write:

        "@{$data.{costs}}"    # evaluate array in string context

But Perl 6 has another alternative to offer us -- the unary underscore operator. Binary underscore is [string concatenation](/pub/2001/10/03/exegesis3.html?page=2#(pre)fixing%20those%20filenames), so it shouldn't be too surprising that unary underscore is the stringification operator (think: concatenation with a null string). Prefixing any expression with an underscore forces it to be evaluated in string context:
        _@{$data{costs}}     # evaluate array in string context

Which, in this case, conveniently inserts the required spaces between the elements of the costs array.
*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 3](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the current design information.*

### <span id="a parameter by any other name"></span>A parameter by any other name

Now that the I/O is organized, we can get down to the actual processing. First, we load the data:
        my %data = load_data(filename=>'weblog', version=>1);

Note that we're using named arguments here. This attempt would blow up badly in Perl 5, because we didn't set `&load_data` up to expect a hash-like list of arguments. But it works fine in Perl 6 for two reasons:
1.  Because we *did* set up `&load_data` with named parameters; and
2.  Because the `=>` operator isn't in Kansas anymore.

In Perl 5, `=>` is just an up-market comma with a single minor talent: It stringifies its left operand if that operand is a bareword.
In Perl 6, `=>` is a fully-fledged anonymous object constructor -- like `[...]` and `{...}`. The objects it constructs are called "pairs" and they consist of a key (the left operand of the `=>`), and a value (the right operand). The key is still stringified if it's a valid identifier, but both the key and the value can be *any* kind of Perl data structure. They are accessed via the pair object's `key` and `value` methods:

        my $pair_ref = [1..9] => "digit";

        print $pair_ref.value;      # prints "digit"
        print $pair_ref.key.[3];    # prints 4

So, rather than getting four arguments:
        load_data('filename', 'weblog', 'version', 1);    # Perl 5 semantics

`&load_data` gets just two arguments, each of which is a reference to a pair:
        load_data( $pair_ref1, $pair_ref2);               # Perl 6 semantics

When the subroutine dispatch mechanism detects one or more pairs as arguments to a subroutine with named parameters, it examines the keys of the pairs and binds their values to the correspondingly named parameters -- no matter what order the paired arguments originally appeared in. Any remaining non-pair arguments are then bound to the remaining parameters in left-to-right order.
So we could call `&load_data` in any of the following ways:

        load_data(filename=>'weblog', version=>1);  # named

        load_data(version=>1, filename=>'weblog');  # named (order doesn't matter)

        load_data('weblog', 1);                     # positional (order matters)

There are numerous other uses for pairs, one of which we'll see [shortly](/pub/2001/10/03/exegesis3.html?page=6#schwartzian%20pairs).

### <span id="please queue for processing"></span>Please queue for processing

Having loaded the data, we go into a loop and iterate over each file's information. First, we announce the file and its internal name:
        foreach my $file (keys %data) {
            print "$file contains data on %data{$file}{name}\n";

### <span id="the xortwist"></span>The Xor-twist

Then we toggle the "is active" status bit (the eighth bit) for each file. To flip that single bit without changing any of the other status bits, we bitwise-xor the status bitset against the bitstring `0000000010000000`. Each bit xor'd against a zero stays as it is (0 xor 0 --&gt; 0; 1 xor 0 --&gt; 1), while xor'ing the eighth bit against 1 complements it (0 xor 1 --&gt; 1; 1 xor 1 --&gt; 0).
But because the caret has been appropriated as the Perl 6 [hyper-operator prefix](/pub/2001/10/03/exegesis3.html?page=2#substitute%20our%20vector,%20victor!), it will no longer be used as bitwise xor. Instead, binary tilde will be used:

        %data{$file}{stat} = %data{$file}{stat} ~ $is_active_bit;

This is actually an improvement in syntactic consistency since bitwise xor (now binary `~`) and bitwise complement (still unary `~`) are mathematically related: `~x` is `(-1~x)`.
Note that we *could* have used the assignment variant of binary `~`:

        %data{$file}{stat} ~= $is_active_bit;     # flip only bit 8 of status bitset

but that's probably best avoided due to its confusability with the much commoner "pattern association" operator:
        %data{$file}{stat} =~ $is_active_bit;     # match if status bitset is "128"

By the way, there is also a high precedence logical xor operator in Perl 6. You guessed it: `~~`. This finally fills the strange gap in Perl's logical operator set:
            Binary (low) | Binary (high) |    Bitwise
           ______________|_______________|_____________
                         |               |
                or       |      ||       |      |
                         |               |
                and      |      &&       |      &
                         |               |
                xor      |      ~~       |      ~
                         |               |

And it will also help to reduce programmer stress by allowing us to write:

        $make = $money ~~ $fast;

instead of (the clearly over-excited):
        $make = !$money != !$fast;

### <span id="bound for glory"></span>Bound for glory

In both Perl 5 and 6, it's possible to create an *alias* for a variable. For example, the subroutine:
        sub increment { $_[0]++ }           # Perl 5
        sub increment { @_[0]++ }           # Perl 6

works because the elements of `@_` become aliases for whatever variable is passed as their corresponding argument. Similarly, one can use a `for` to implement a Pascal-ish `with`:
        for my $age ( $person[$n]{data}{personal}{time_dependent}{age} ) {
            if    ($age < 12) { print "Child" }
            elsif ($age < 18) { print "Adolescent" }
            elsif ($age < 25) { print "Junior citizen" }
            elsif ($age < 65) { print "Citizen" }
            else              { print "Senior citizen" }
        }

Perl 6 provides a more direct mechanism for aliasing one variable to another in this way: the `:=` (or "binding") operator. For example, we could rewrite the previous example like so in Perl 6:
        my $age := $person[$n]{data}{personal}{time_dependent}{age};

        if    ($age < 12) { print "Child" }
        elsif ($age < 18) { print "Adolescent" }
        elsif ($age < 25) { print "Junior citizen" }
        elsif ($age < 65) { print "Citizen" }
        else              { print "Senior citizen" }

Bound aliases are particularly useful for temporarily giving a conveniently short identifier to a variable with a long or complex name. Scalars, arrays, hashes and even subroutines may all be given less sequipedalian names in this way:
            my   @list := @They::never::would::be::missed::No_never_would_be_missed;
            our  %plan := %{$planning.[$planner].{planned}.[$planet]};
            temp &rule := &FulfilMyGrandMegalomanicalDestinyBwahHaHaHaaaa;

In our example program, we use aliasing to avoid having to write `@%data{$file}{costs}` everywhere:
        my @costs := @%data{$file}{costs};

An important feature of the binding operator is that the lvalue (or lvalues) on the left side form a context specification for the rvalue (or rvalues) on the right side. It's as if the lvalues were the parameters of an invisible subroutine, and the rvalues were the corresponding arguments being passed to it. So, for example, we could also have written:
        my @costs := %data{$file}{costs};

(i.e. without the `@` dereferencer) because the lvalue *expects* an array as the corresponding rvalue, so Perl 6 automatically dereferences the array reference in `%data{$file}{costs}` to provide that.
More interestingly, if we have both lvalue and rvalue lists, then each of the rvalues is evaluated in the context specified by its corresponding lvalue. For example:

        (@x, @y) := (@a, @b);

aliases `@x` to `@a`, and `@y` to `@b`, because `@`'s on the left act like `@` parameters, which require -- and bind to -- an unflattened array as their corresponding argument. Likewise:
        ($x, %y, @z) := (1, {b=>2}, %c{list});

binds `$x` to the value `1` (i.e. `$x` becomes a constant), `%y` to the anonymous hash constructed by `{b=>2}`, and `@z` to the array referred to by `%c{list}`. In other words, it's the same set of bindings we'd see if we wrote:
        sub foo($x, %y, @z) {...}

        foo(1, {b=>2}, %c{list});

except that the `:=` binding takes effect in the current scope.
And because `:=` works that way, we can also use the flattening operator (unary `*`) on either side of such bindings. For example:

        (@x, *@y) := (@a, $b, @c, %d);

aliases `@x` to `@a`, and causes `@y` to bind to the remainder of the lvalues -- by flattening out `$b`, `@c`, and `%d` into a list and then slurping up all their components together.
Note that `@y` is still an *alias* for those various slurped components. So `@y[0]` is an alias for `$b`, `@y[1..@c.length]` are aliases for the elements of `@c`, and the remaining elements of `@y` are aliases for the interlaced keys and values of `%d`.

When the star is on the other side of the binding, as in:

        ($x, $y) := (*@a);

then `@a` is flattened before it is bound, so `$x` becomes an alias for `@a[0]` and `$y` becomes an alias for `@a[1]`.
The binding operator will have many uses in Perl 6 (most of which we probably haven't even thought of yet), but one of the commonest will almost certainly be as an easy way to swap two arrays efficiently:

        (@x, @y) := (@y, @x);

Yet another way to think about the binding operator is to consider it as a sanitized version of those dreaded Perl 5 typeglob assignments. That is:
        $age := $person[$n]{data}{personal}{time_dependent}{age};

is the same as Perl 5's:
        *age = \$person->[$n]{data}{personal}{time_dependent}{age};

except that it also works if `$age` is declared as a lexical.
Oh, and binding is much safer than typeglobbing was, because it explicitly requires that `$person[$n]{data}{personal}{time_dependent}{age}` evaluate to a scalar, whereas the Perl 5 typeglob version would happily (and silently!) replace `@age`, `%age`, or even `&age` if the rvalue happened to produce a reference to an array, hash, or subroutine instead of a scalar.

*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 3](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the current design information.*

### <span id="better living through sigils"></span>Better living through sigils

We should also note that the binding of the `@costs` array:
        my @costs := @%data{$file}{costs};

shows yet another case where Perl 6's sigil semantics are much DWIM-mier than those of Perl 5.
In Perl 5 we would probably have written that as:

            local *costs = \ @$data{$file}{costs};

and then spent some considerable time puzzling out why it wasn't working, before realising that we'd actually meant:
            local *costs = \ @{$data{$file}{costs}};

instead.
That's because, in Perl 5, the precedence of a hash key is relatively low, so:

        @$data{$file}{costs}    # means: @{$data}{$file}{costs}
                                # i.e. (invalid attempt to) access the 'costs'
                                # key of a one-element slice of the hash
                                # referred to by $data
                                # problem is: slices don't have hash keys

whereas:
        @{$data{$file}{costs}}  # means: @{ $data{$file}{costs} }
                                # i.e. dereference of array referred to by
                                # $data{$file}{costs}

The problem simply doesn't arise in Perl 6, where the two would be written quite distinctly, as:
        %data{@($file)}{costs}  # means: (%data{@($file)}).{costs}
                                # (still an error in Perl 6)

and:
        @%data{$file}{costs}    # means: @{ %data{$file}{costs} }
                                # i.e. dereference of array referred to by
                                # %data{$file}{costs}

respectively.

### <span id="that's not a number...now that's a number!"></span>That's not a number...now *that's* a number!

One of the perennial problems with Perl 5 is how to read in a number. Or rather, how to read in a string...and then be sure that it contains a valid number. Currently, most people read in the string and then either just assume it's a number (optimism) or use the regexes found in [perlfaq4]({{< perldoc "perlfaq4" "How_do_I_determine_whether_a_scalar_is_a_number_whole_integer_float_" >}}) or [Regexp::Common]({{<mcpan "Regexp::Common" >}}) to make sure (cynicism).

Perl 6 offers a simpler, built-in mechanism.

Just as the unary version of binary underscore (`_`) is Perl 6's explicit stringification specifier, so to the unary version of binary plus is Perl 6's explicit numerifier. That is, prefixing an expression with unary `+` evaluates that expression in a numeric context. Furthermore, if the expression has to be coerced from a string and the string does not begin with a valid number, the stringification operator returns `NaN`, the not-a-number value.

That makes it particularly easy to read in numeric data reliably:

        my $inflation;
        print "Inflation rate: " and $inflation = +<>
            until $inflation != NaN;

The unary `+` takes the string returned by `<>` and converts it to a number. Or, if the string can't be interpreted as a number, `+` returns `NaN`. Then we just go back and try again until we do get a valid number.
Note that these new semantics for unary `+` are a little different from its role in Perl 5, where it is just the identity operator. In Perl 5 it's occasionally used to disambiguate constructs like:

        print  ($x + $y) * $z;        # in Perl 5 means: ( print($x+$y) ) * $z;
        print +($x + $y) * $z;        # in Perl 5 means: print( ($x+$y) * $z );

To get the same effect in Perl 6, we'd use the [adverbial colon](/pub/2001/10/03/exegesis3.html?page=4#it%20is%20written...) instead:
        print   ($x + $y) * $z;        # in Perl 6 means: ( print($x+$y) ) * $z;
        print : ($x + $y) * $z;        # in Perl 6 means: print( ($x+$y) * $z );

### <span id="schwartzian pairs"></span>Schwartzian pairs

Another handy use for [pairs](/pub/2001/10/03/exegesis3.html?page=5#a%20parameter%20by%20any%20other%20name) is as a natural data structure for implementing the Schwartzian Transform. This caching technique is used when sorting a large list of values according to some expensive function on those values. Rather than writing:
        my @sorted = sort { expensive($a) <=> expensive($b) } @unsorted;

and recomputing the same expensive function every time each value is compared during the sort, we can precompute the function on each value once. We then pass both the original value and its computed value to `sort`, use the computed value as the key on which to sort the list, but then return the original value as the result. Like this:
        my @sorted =                        # step 4: store sorted originals
            map  { $_.[0] }                 # step 3: extract original
            sort { $a.[1] <=> $b.[1] }      # step 2: sort on computed
            map  { [$_, expensive($_) ] }   # step 1: cache original and computed
                @unsorted;                  # step 0: take originals

The use of arrays can make such transforms hard to read (and to maintain), so people sometimes use hashes instead:
        my @sorted =
            map  { $_.{original} }
            sort { $a.{computed} <=> $b.{computed} }
            map  { {original=>$_, computed=>expensive($_)} }
                @unsorted;

That improves the readability, but at the expense of performance. Pairs are an ideal way to get the readability of hashes but with (probably) even better performance than arrays:
        my @sorted =
            map  { $_.value }
            sort { $a.key <=> $b.key }
            map  { expensive($_) => $_ }
                @unsorted;

Or in the case of our example program:
        @costs = map  { $_.value }
                 sort { $a.key <=> $b.key }
                 map  { amortize($_) => $_ }
                     @costs ^* $inflation;

Note that we also used a hyper-multiplication (`^*`) to multiply each cost individually by the rate of inflation before sorting them. That's equivalent to writing:
        @costs = map  { $_.value }
                 sort { $a.key <=> $b.key }
                 map  { amortize($_) => $_ }
                 map  { $_ * $inflation }
                     @costs;

but spares us from the burden of yet another `map`.
More importantly, because `@costs` is an [alias](/pub/2001/10/03/exegesis3.html?page=5#bound%20for%20glory) for `@%data{$file}{costs}`, when we assign the sorted list back to `@costs`, we're actually assigning it back into the appropriate sub-entry of `%data`.

### <span id="the sum of all our fears"></span>The ∑ of all our fears

Perl 6 will probably have a built-in `sum` operator, but we might still prefer to build our own for a couple of reasons. Firstly `sum` is obviously far too long a name for so fundamental an operation; it really should be `∑`. Secondly, we may want to extend the basic summation functionality somehow. For instance, by allowing the user to specify a filter and only summing those arguments that the filter lets through.
Perl 6 allows us to create our own operators. Their names can be any combination of characters from the Unicode set. So it's relatively easy to build ourselves a `∑` operator:

        my sub operator:∑ is prec(\&operator:+($)) (*@list) {
            reduce {$^a+$^b} @list;
        }

We declare the `∑` operator as a lexically scoped subroutine. The lexical scoping eases the syntactic burden on the parser, the semantic burden on other unrelated parts of the code, and the cognitive burden on the programmer.
The operator subroutine's name is always `operator:whatever_symbols_we_want`. In this case, that's `operator:∑`, but it can be any sequence of Unicode characters, including alphanumerics:

            my sub operator:*#@& is prec(\&operator:\)  (STR $x) {
                    return "darn $x";
            }

            my sub operator:† is prec(\&CORE::kill)  (*@tIHoH) {
                    kill(9, @tIHoH) == @tIHoH or die "batlhHa'";
                    return "Qapla!";
            }

            my sub operator:EQ is prec(\&operator:eq)  ($a, $b) {
                    return $a eq $b                 # stringishly equal strings
                        || $a == $b != NaN;         # numerically equal numbers
            }

            # and then:

            warn *#@& "QeH!" unless E<dagger> $puq EQ "Qapla!";

Did you notice that cunning `$a == $b != NaN` test in `operator:EQ`? This lovely Perl 6 idiom solves the problem of numerical comparisons between non-numeric strings.

In Perl 5, a comparison like:

            $a = "a string";
            $b = "another string";
            print "huh?" if $a == $b;

will unexpectedly succeed (and silently too, if you run without warnings), because the non-numeric values of both the scalars are converted to zero in the numeric context of the `==`.

But in Perl 6, non-numeric strings numerify to `NaN`. So, using Perl 6's multiway comparison feature, we can add an extra `!= NaN` to the equality test to ensure that we compared genuine numbers.

Meanwhile, we also have to specify a precedence for each new operator we define. We do that with the `is prec` trait of the subroutine. The precedence is specified in terms of the precedence of some existing operator; in this case, in terms of Perl's built-in unary `+`:

        my sub operator:∑ is prec( \&operator:+($) )

To do this, we give the `is prec` trait a reference to teh existing operator. Note that, because there are two overloaded forms of `operator:+` (unary and binary) of different precedences, to get the reference to the correct one we need to specify its complete *signature* (its name and parameter types) as part of the enreferencing operation. The ability to take references to signatures is a standard feature in Perl 6, since ordinary subroutines can also be overloaded, and may need the same kind of disambiguation when enreferenced.
If the operator had been binary, we might also have had to specify its associativity (`left`, `right`, or `non`), using the `is assoc` trait.

Note too that we specified the parameter of `operator:∑` with a flattening asterisk, since we want `@list` to slurp up any series of values passed to it, rather than being restricted to accepting only actual array variables as arguments.

The implementation of `operator:∑` is very simple: we just apply the built-in `reduce` function to the list, reducing each successive pair of elements by adding them.

Note that we used a higher-order function to specify the addition operation. Larry has decided that the syntax for higher-order functions requires that implicit parameters be specified with a `$^` sigil (or `@^` or `%^`, as appropriate) and that the whole expression be enclosed in braces.

So now we have a `∑` operator:

        $result = ∑ $wins, $losses, $ties;

but it doesn't yet provide a way to filter its values. Normally, that would present a difficulty with an operator like `∑`, whose `*@list` argument will gobble up every argument we give it, leaving no way -- except convention -- to distinguish the filter from the data.
But Perl 6 allows any subroutine -- not just built-ins like `print` -- to take one or more "adverbs" in addition to its normal arguments. This provides a second channel by which to transmit information to a subroutine. Typically that information will be used to modify the behaviour of the subroutine (hence the name "adverb"). And that's exactly what we need in order to pass a filter to `∑`.

A subroutine's adverbs are specified as part of its normal parameter list, but separated from its regular parameters by a colon:

        my sub operator:∑ is prec(\&operator:+($)) ( *@list : $filter //= undef) {...

This specifies that `operator:∑` can take a single scalar adverb, which is bound to the parameter `$filter`. When there is no adverb specified in the call, `$filter` is default-assigned the value `undef`.
We then modify the body of the subroutine to pre-filter the list through a `grep`, but only if a filter is provided:

            reduce {$^a+$^b}  ($filter ?? grep &$filter, @list :: @list);
        }

The `??` and `::` are the new way we write the old `?:` ternary operator in Perl 6. Larry had to change the spelling because he needed the single colon for marking adverbs. But it's a change for the better anyway --it was rather odd that all the other short-circuiting logical operators (`&&` and `||` and `//`) used doubled symbols, but the conditional operator didn't. Well, now it does. The doubling also helps it stand out better in code, in part because it forces you to put space around the `::` so that it's not confused with a package name separator.
You might also be wondering about the ambiguity of `??`, which in Perl 5 already represents an empty regular expression with question-mark delimiters. Fortunately, Perl 6 won't be riddled with the nasty `?...?` regex construct, so there's no ambiguity at all.

Adverbial semantics can be defined for *any* Perl 6 subroutine. For example:

        sub mean (*@values : $type //= 'arithmetic') {
            given ($type) {
                when 'arithmetic': { return sum(@values) / @values; }
                when 'geometric':  { return product(@values) ** (1/@values) }
                when 'harmonic':   { return @values / sum( @values ^** -1 ) }
                when 'quadratic':  { return (sum(@values ^** 2) / @values) ** 0.5 }
            }
            croak "Unknown type of mean: '$type'";
        }

Adverbs will probably become widely used for passing this type of "out-of-band" behavioural modifier to subroutines that take an unspecified number of data arguments.
*Editor's note: this document is out of date and remains here for historic interest. See [Synopsis 3](http://dev.perl.org/perl6/doc/design/syn/S03.html) for the current design information.*

### <span id="would you like an adverb with that"></span>Would you like an adverb with that?

OK, so now our `∑` operator can take a modifying filter. How exactly do we pass that filter to it?
As described [earlier](/pub/2001/10/03/exegesis3.html?page=4#it%20is%20written...), the colon is used to introduce adverbial arguments into the argument list of a subroutine or operator. So to do a normal summation we write:

        $sum = ∑ @costs;

whilst to do a filtered summation we place the filter after a colon at the end of the regular argument list:
        $sum = ∑ @costs : sub {$_ >= 1000};

or, more elegantly, using a higher-order function:
        $sum = ∑ @costs : {$^_ >= 1000};

Any arguments after the colon are bound to the parameters specified by the subroutine's adverbial parameter list.
Note that the example also demonstrates that we can interpolate the results of the various summations directly into output strings. We do this using Perl 6's scalar interpolation mechanism (`$(...)`), like so:

        print "Total expenditure: $( ∑ @costs )\n";
        print "Major expenditure: $( ∑ @costs : {$^_ >= 1000} )\n";
        print "Minor expenditure: $( ∑ @costs : {$^_ < 1000} )\n";

### <span id="the odd lazy step"></span>The odd lazy step

Finally (and only because we *can*), we print out a list of every second element of `@costs`. There are numerous ways to do that in Perl 6, but the cutest is to use a lazy, infinite, stepped list of indices in a regular slicing operation.

In Perl 6, any list of values created with the `..` operator is created lazily. That is, the `..` operator doesn't actually build a list of all the values in the specified range, it creates an array object that knows the boundaries of the range and can interpolate (and then cache) any given value when it's actually needed. That's useful, because it greatly speeds up the creation of a list like `(1..Inf)`.

`Inf` is Perl 6's standard numerical infinity value, so a list that runs to `Inf` takes ... well ... forever to actually build. But writing `1..Inf` is OK in Perl 6, since the elements of the resulting list are only ever computed on demand. Of course, if you were to `print(1..Inf)`, you'd have plenty of time to go and get a cup of coffee. And even then (given the comparatively imminent heat death of the universe) that coffee would be *really* cold before the output was complete. So there will probably be a warning when you try to do that.

But to get an infinite list of odd indices, we don't want every number between 1 and infinity; we want every *second* number. Fortunately, Perl 6's `..` operator can take an adverb that specifies a "step-size" between the elements in the resulting list. So if we write `(1..Inf : 2)`, we get `(1,3,5,7,...)`. Using that list, we can extract the oddly indexed elements of an array of any size (e.g. `@costs`) with an ordinary array slice:

        print @costs[1..Inf:2]

You might have expected another one of those "maximal-entropy coffee" delays whilst `print` patiently outputs the infinite number of `undef`'s that theoretically exist after `@costs`' last element, but slices involving infinite lists avoid that problem by returning only those elements that actually exist in the list being sliced. That is, instead of iterating the requested indices in a manner analogous to:
        sub slice is lvalue (@array, *@wanted_indices) {
            my @slice;
            foreach $wanted_index ( @wanted_indices ) {
                @slice[+@slice] := @array[$wanted_index];
            }
            return @slice;
        }

infinite slices iterate the available indices:
        sub slice is lvalue (@array, *@wanted_indices) {
            my @slice;
            foreach $actual_index ( 0..@array.last ) {
                @slice[+@slice] := @array[$actual_index]
                    if any(@wanted_indices) == $actual_index;
            }
            return @slice;
        }

(Obviously, it's actually far more complicated -- and lazy -- than that. It has to preserve the original ordering of the wanted indexes, as well as cope with complex cases like infinite slices of infinite lists. But from the programmer's point of view, it all just DWYMs).
By the way, binding selected array elements to the elements of another array (as in: `@slice[+@slice] := @array[$actual_index]`), and then returning the bound array as an lvalue, is a neat Perl 6 idiom for recreating any kind of slice-like semantics with user-defined subroutines.

### <span id="take that! and that!"></span>Take that! And that!

And so, lastly, we save the data back to disk:
        save_data(%data, log => {name=>'metalog', vers=>1, costs=>[], stat=>0});

Note that we're passing in both a hash and a pair, but that these still get correctly folded into `&save_data`'s single hash parameter, courtesy of the flattening asterisk on the parameter definition:
        sub save_data (*%data) {...

### <span id="in a nutshell..."></span>In a nutshell...

It's okay if your head is spinning at this point.
We just crammed a huge number of syntactic and semantic changes into a comparatively small piece of example code. The changes may seem overwhelming, but that's because we've been concentrating on *only* the changes. Most of the syntax and semantics of Perl's operators don't change at all in Perl 6.

So, to conclude, here's a summary of what's new, what's different, and (most of all) what stays the same.

#### <span id="unchanged operators"></span>Unchanged operators

-   prefix and postfix `++` and `--`
-   unary `!`, `~`, `\`, and `-`
-   binary `**`
-   binary `=~` and `!~`
-   binary `*`, `/`, and `%`
-   binary `+` and `-`
-   binary `<<` and `>>`
-   binary `&` and `|`
-   binary `=`, `+=`, `-=`, `*=`, etc.
-   binary `,`
-   unary `not`
-   binary `and`, `or`, and `xor`

#### <span id="changes to existing operators"></span>Changes to existing operators

-   binary `->` (dereference) becomes `.`
-   binary `.` (concatenate) becomes `_`
-   unary `+` (identity) now enforces numeric context on its argument
-   binary `^` (bitwise xor) becomes `~`
-   binary `=>` becomes the "pair" constructor
-   ternary `? :` bbeeccoommeess `?? ::`

#### <span id="enhancements to existing operators"></span>Enhancements to existing operators

-   binary `..` becomes even lazier
-   binary `<`, `>`, `lt`, `gt`, `==`, `!=`, etc. become chainable
-   Unary `-r`, `-w`, `-x`, etc. are nestable
-   The `<>` input operator are more context-aware
-   The logical `&&` and `||` operators propagate their context to *both* their operands
-   The `x` repetition operator no longer requires listifying parentheses on its left argument in a list context.

#### <span id="new operators:"></span>New operators:

-   unary `_` is the explicit string context enforcer
-   binary `~~` is high-precedence logical xor
-   unary `*` is a list context specifier for parameters and a array flattening operator for arguments
-   unary `^` is a meta-operator for specifying vector operations
-   unary `:=` is used to create aliased variables (a.k.a. binding)
-   unary `//` is the logical 'default' operator

