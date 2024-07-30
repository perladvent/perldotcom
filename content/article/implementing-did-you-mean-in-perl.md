{
   "image" : "/images/122/530C022E-6110-11E4-91D8-E5A395E830D2.png",
   "date" : "2014-10-31T15:31:18",
   "categories" : "development",
   "authors" : [
      "david-farrell"
   ],
   "description" : "Catching and handling undefined subroutine exceptions",
   "slug" : "122/2014/10/31/Implementing-Did-You-Mean-in-Perl",
   "tags" : [
      "autoload",
      "mastering-perl",
      "symbol_table",
      "ruby",
      "did_you_mean"
   ],
   "thumbnail" : "/images/122/thumb_530C022E-6110-11E4-91D8-E5A395E830D2.png",
   "title" : "Implementing Did You Mean in Perl",
   "draft" : false
}


A couple of weeks ago Yuki Nishijima released a clever Ruby [gem](http://www.yukinishijima.net/2014/10/21/did-you-mean-experience-in-ruby.html) called "Did You Mean", that intercepts failed method calls and suggests the closest matching (correct) method in the exception message. I wanted to create an equivalent module in Perl, and so armed with a limited appreciation of `AUTOLOAD` I set about creating [Devel::DidYouMean]({{<mcpan "Devel::DidYouMean" >}}).

### Using the module

Devel::DidYouMean is available on CPAN now, you can install it at the command line:

```perl
$ cpan Devel::DidYouMean
```

To use the module, just import it with `use` like any other module:

```perl
# script.pl
use Devel::DidYouMean;

print substring('have a nice day', 0, 6);
```

This code calls a builtin function "substring", which does not exist. Running the above code we get a more *helpful* error message:

```perl
Undefined subroutine 'substring' not found in main. Did you mean substr? at script.pl line 4.
```

### How it works

As I alluded to in the introduction, DidYouMean.pm defines a subroutine using the `AUTOLOAD` function which catches missed subroutine calls. But by default this subroutine only exists within the Devel::DidYouMean namespace so it would only fire when there was a missed method call like `Devel::DidYouMean->some_method;`. This is not very useful! So I used some symbol-table black magic to load the module into every namespace at runtime:

```perl
CHECK {
    # add autoload to main
    *{ main::AUTOLOAD } = Devel::DidYouMean::AUTOLOAD;

    # add to every other module in memory
    for (keys %INC)
    {
        my $module = $_;
        $module =~ s/\//::/g;
        $module = substr($module, 0, -3);
        $module .= '::AUTOLOAD';

        # skip if the package already has an autoload
        next if defined *{ $module };

        *{ $module } = Devel::DidYouMean::AUTOLOAD;
    }
}
```

Walking through this code, you might be wondering what that strange `CHECK` block is for. This ensures that the code within the block is loaded after the program compilation phase has finished, reducing the risk of the program loading another module after DidYouMean.pm has already exported it's `AUTOLOAD` subroutine. Perl defines several named code [blocks]({{< perldoc "perlmod" "BEGIN%2c-UNITCHECK%2c-CHECK%2c-INIT-and-END" >}}) (you are probably familiar with `BEGIN`). The downside of using a check block is if the module is loaded using `require` instead of `use`, this block will not be executed at all.

The code then adds the `AUTOLOAD`subroutine to main (the namespace of the executing program) and every other namespace in the symbol table. I got the syntax for this from the "Dynamic Subroutines" chapter of [Mastering Perl](http://shop.oreilly.com/product/0636920012702.do).

The code for the autoloaded [subroutine](https://github.com/sillymoose/Devel-DidYouMean/blob/master/lib/Devel/DidYouMean.pm#L97)is long, so I won't reproduce it here. High level, it extracts the name of the failed subroutine called from `$AUTOLOAD` and using the [Text::Levenshtein]({{<mcpan "Text::Levenshtein" >}}) module, calculates the Levenshtein distance between the name of the failed subroutine call and every available subroutine in the calling namespace. It then croaks displaying the usual undefined subroutine error message with a list of matching subroutines.

### Conclusion

Although the module "works", it feels heavy-handed to export a subroutine to every namespace in memory. An alternative approach that I considered but couldn't get to work would be to define the code in an `END` block, and then check if the program is ending with an "unknown subroutine" error. This challenge with this is that in the end phase, Perl has already nullified the error variable `$!` so it's hard to know why the program is ending (tieing `$!` might get around this). If you're interested in tackling this challenge, the repo is hosted on [GitHub](https://github.com/sillymoose/Devel-DidYouMean), pull requests are welcome :) The module [documentation]({{<mcpan "Devel::DidYouMean" >}}) has more examples of Devel::DidYouMean in action.

**Update:***Devel::DidYouMean now uses a signal handling approach and avoids AUTOLOAD altogether 2014-11-09*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
