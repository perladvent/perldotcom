
  {
    "title"       : "Perl 6 Grammers, Part 1",
    "authors"     : ["andrew-shitov"],
    "date"        : "2018-02-13T15:22:36",
    "tags"        : ["grammars", "parsing", "lexing"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Parsing number formats",
    "categories"  : "perl-6"
  }

The Perl 6 language has builtin support of [_grammars_](https://docs.perl6.org/language/grammars). You may consider grammars as a combination of the well known regular expressions and utilities such as `yacc` or `bison`, or more sophisticated grammar tools such as ANTLR. All that—both lexer, parser, and also semantic processing—which are often separate parts of compilers, is built-in and available out of the box with a [fresh Perl 6 installation](http://rakudo.org/how-to-get-rakudo/).

To feel the power of grammars, it is enough to say that Perl 6’s own grammar is [written in Perl 6](https://perl6.online/2018/01/01/the-start-of-the-grammar/) as a huge grammar class [Perl6::Grammar](https://github.com/rakudo/rakudo/blob/master/src/Perl6/Grammar.nqp).

In this article, I will go through a few examples to illustrate the basics of grammars. All the required language constructions will be explained as we go.

### Parsing numbers

Parsing numbers seems to be a simple task until you start thinking about different formats that the user can use, including negative numbers, floating-point numbers, numbers in scientific notation, special forms of numbers such as C‘s long long integers.

Let us start with the simplest form: a number as a sequence of digits. For example, 1, 42, 123, or 1000. A grammar in Perl 6 is a special kind of classes with its own keywords. The first rule of the grammar must (by default) be called `TOP`, and here is the complete program that parses our first set of numbers:

```perl
grammar N {
    token TOP {
        <digit>+
    }
}

for <1 42 123 1000> -> $n {
    say N.parse($n) ?? "OK $n" !! "NOT OK $n";
}
```

When the `parse` method of the `N` grammar is called, Perl tries to match the given string against the `TOP` method. In our case, this is a `token`, which means that the string cannot contain any optional spaces between the parts of the token. `TOP` is only successful when it consumes the whole string, so there is no need to use explicit anchors `^` and `$` to tie the edges of the token.

As with regexes, tokens and rules can include other tokens, rules, or regexes referred by their names. In our first example, the `TOP` token needs the `digit` built-in method that matches digits. The `+` quantifier is the same quantifier as in standard Perl 5 regular expressions: it allows one or more repetitions of the previous atom.

Our simple grammar can parse only unsigned integers so far. Any negative number cannot be parsed:

```
OK 1
OK 42
OK 123
OK 1000
NOT OK -3
```

Let us update the grammar and introduce the token for the optional sign, which can be either `+` or `-`:

```perl6
grammar N {
    token TOP {
        ['+' | '-']?
        <digit>+
    }
}
```

Here, the square brackets group together the two alternatives: `'+' | '-'` . The `?` quantifier requires that there is only one such character, or there are none. In Perl 6, square brackets only create a group but do not capture its content. Also notice, that both `+` and `-` are quoted, because Perl 6 treats any non-alphanumeric character as a special character unless it is quoted or escaped with `\`.

The next step is to add support for the floating point. An ad hoc solution can be creating a character class that includes both numbers and the `'.'`  character, but that would be completely wrong, as, for example, strings with two dots such as `3..14` pass this filter. So, do it differently:

```perl
grammar N {
    token TOP {
        ['+' | '-']?
        <digit>+
        ['.' <digit>+]?
    }
}
```

This grammar now allows an optional part consisting of the period and another sequence of digits and works well when the number is either an integer or contains an explicit fractional part, for example, `3.14`. It fails for those numbers where one of the parts is missing: `3.` or `.14`.

An attempt to make the parts optional by using quantifiers makes the grammar difficult to read and error-prone. For instance, the following token matches all the above numbers but also a single `.`:

```perl
grammar N {
    token TOP {
        ['+' | '-']?
        <digit>*
        ['.' <digit>*]?
    }
}
```

It’s time to introduce more tokens. Factor out the sequence of digits to a separate token and list all the variants explicitly:

```perl
grammar N {
    token TOP {
        <sign>?
        <value>
    }
    token sign {
        '+' | '-'
    }
    token digits {
        <digit>+
    }
    token value {
        | <digits> '.' <digits>
        | '.' <digits>
        | <digits> '.'
        | <digits>
    }
}
```

The `value` token encapsulates the variants: it contains four alternative representations of accepted numbers. Vertical bars separate them. For the sake of unification, it is allowed to add an additional bar before the first alternative, so that all of them are emphasized with a simple ASCII art.

This current grammar is already smart enough to reject a single period:

```
OK 1
OK 42
OK 123
OK 1000
OK -3
OK 3.14
OK 3.
OK .14
NOT OK .
```

The last step is to support numbers in scientific notation. Adding another alternative is an easy candidate for this task:

```perl
grammar N {
    token TOP {
        <sign>?
        [
            | <value> <exp> <sign>? <digits>
            | <value>
        ]
    }
    token sign {
        '+' | '-'
    }
    token exp {
        'e' | 'E'
    }
    token digits {
        <digit>+
    }
    token value {
        | <digits> '.' <digits>
        | '.' <digits>
        | <digits> '.'
        | <digits>
    }
}
```

Test the grammar with the following cases:

```perl
for <1 42 123 1000 -3
     3.14 3. .14 .
     -3.14 -3. -.14
     10E2 10e2 -10e2 -1.2e3 10e-3 -10e-3 -10.2e-33
    > -> $n {
    say N.parse($n) ?? "OK $n" !! "NOT OK $n";
}
```

All works fine. But wait, in Perl, underscores are also allowed in numbers! Having a proper grammar, adding support for this is easy; only the `digits` token should be modified:

```perl
token digits {
    <digit>+ ['_' <digit>+]?
}
```

Strings that do not follow the rules are still ignored:

```
OK 100_000
NOT OK _1
NOT OK 1_
NOT OK 1__0
```

### Conclusion

With a few simple steps, we made a grammar that understands numbers in different formats. As an exercise, you can add support for prefixes `0x`, `0b`, `0o` (hex, binary and octal) and suffixes (as in `1000L` in C). Grammars were only used to check the validity of the number format, and their power does not end there. In Perl 6, you can add _actions_ to the grammar; these are code blocks that are executed if the corresponding rule or token has successfully matched. But that's a story for another day.

