{
   "date" : "2015-04-30T13:14:23",
   "authors" : [
      "david-farrell"
   ],
   "tags" : [
      "pod",
      "perl-6",
      "grammar",
      "pegex",
      "parser"
   ],
   "title" : "Parsing Perl 5 pod with Perl 6",
   "thumbnail" : "/images/170/thumb_AA60EE46-EF3A-11E4-98F4-3C044E9B8265.png",
   "description" : "Grammars, action classes, code!",
   "image" : "/images/170/AA60EE46-EF3A-11E4-98F4-3C044E9B8265.png",
   "categories" : "perl-6",
   "draft" : false,
   "slug" : "170/2015/4/30/Parsing-Perl-5-pod-with-Perl-6"
}


I've just finished developing a Perl 5 pod [parser](https://github.com/dnmfarrell/Pod-Perl5) written in Perl 6. Developing the grammar was surprisingly easy, which is a testament to Perl 6 as I'm no genius coder. With help from the folks at \#perl6, I did learn some interesting things along the way, and wanted to share them. Plus, code!

By the way, if you haven't read my [introduction](http://perltricks.com/article/144/2015/1/13/How-to-create-a-grammar-in-Perl-6) to Perl 6 grammars, check it out first, and the rest of this article should make more sense.

### Developing the grammar

In Perl 6 a grammar is a special type of class for parsing text. The idea is to declare a series of regexes using the `token` method, which are then used to parse input. For [Pod::Perl5::Grammar](https://github.com/dnmfarrell/Pod-Perl5/blob/master/lib/Pod/Perl5/Grammar.pm) I literally worked my way through [perlpod]({{< perldoc "perlpod" >}}), the Perl 5 pod specification, writing tokens as I went.

There were a few challenges. First, consider how would you define a regex for lists? In pod, lists can contain lists, so can a definition include itself? The answer is yes, a recursive definition is fine, as long as it doesn't match a zero length string, which leads to an infinite loop. Here's the definition:

```perl
token over_back { <over>
                    [
                      <_item> | <paragraph> | <verbatim_paragraph> | <blank_line> |
                      <_for> | <begin_end> | <pod> | <encoding> | <over_back>
                    ]*
                    <back>
                  }

token over      { ^^\=over [\h+ <[0..9]>+ ]? \n }
token _item     { ^^\=item \h+ <name>
                    [
                        [ \h+ <paragraph>  ]
                      | [ \h* \n <blank_line> <paragraph>? ]
                    ]
                  }
token back      { ^^\=back \h* \n }
```

The token `over_back` describes an entire list from start to finish. It basically says that a list must begin with an `=over` and end with `=back`, and can have a whole bunch of things in between, including another `over_back`!

For simplicity's sake, I tried to name the tokens the same as how they're written in pod. In some cases this wasn't possible, for instance `item` causes a namespace clash with another method that the Grammar class inherits. So watch out for those cases, you'll get weird errors (this is a [bug](https://rt.perl.org/rt3//Public/Bug/Display.html?id=77350)).

This is one pattern I really love and used over and over in the grammar:

```perl
[ <pod_section> | <?!before <pod_section> > .]*
```

The pattern is useful when you have a pattern to capture, but if there's no matching pattern ignore everything else. In this case, `pod_section` is a token that defines a section of pod, but pod is often written inline with Perl code, which the grammar should ignore. So the second half of the definition uses a negative lookahead `?!before` to check the next character is not a `pod_section`, and uses a period `.` to match everything else (including newlines). Both conditions are grouped in square brackets with an asterisk placed **outside** the group in order to check one character at a time.

The grammar can be used to parse standalone and inline pod. It will extract every pod section it finds into match object (basically a Perl data structure), ready for processing. It's easy to use:

```perl
use Pod::Perl5::Grammar;

my $match = Pod::Perl5::Grammar.parse($pod);

# or

my $match = Pod::Perl5::Grammar.parsefile("/path/to/some.pod");
```

### Action classes

So far so cool, but we can do more. Action classes are regular Perl 6 classes that can be given to the grammar at parse time. They provide behavior (actions) for token matching events. Just name the methods in the action class the same as the token they should be executed on. I wrote a pod-to-HTML action [class](https://github.com/dnmfarrell/Pod-Perl5/blob/master/lib/Pod/Perl5/ToHTML.pm). Here is the method for converting `=head1` to HTML:

```perl
method head1 ($/)
{
  self.add_to_html('body', "<h1>{$/<singleline_text>.Str}</h1>\n");
}
```

Every time the grammar matches a head1 token, this method executes. It's passed the regex capture variable `$/`, which contains the head1 regex capture, from which it extracts the text string.

Here's a cool fact: action classes are even easier to write than grammars. It would be trivial to write a pod to markdown converter using Pod::Perl5::Grammar, unless someone beats me to it (hint, hint). That said, I did encounter a few challenges along the way.

Essentially for HTML conversion, each action class method can just extract the text from it's matching token, reformat it as required, and print it out. This approach worked great until I encountered nested tokens like formatting codes, which sit within a paragraph of text. You don't want to go from this:

    There are different ways to emphasize text, I<this is in italics> and  B<this is in bold>

To this:

    <i>this is in italics</i>
    <b>this is in bold</b>
    <p>There are different ways to emphasize text, I<this is in italics> and  B<this is in bold></p>

This can happen because the italics and bold token regexes match first. So to get around this issue, I used a buffer to store the HTML from the transformed sub-tokens, and then when a paragraph token is matched, it substitutes its own text with the contents of the buffer. The action class code for this looks like this:

```perl
method paragraph ($/ is copy)
{
  my $original_text = $/<text>.Str.chomp;
  my $para_text = $/<text>.Str.chomp;

  for self.get_buffer('paragraph').reverse -> $pair # reverse as we're working outside in
  {
    $para_text = $para_text.subst($pair.key, {$pair.value});
  }
  self.add_to_html('body', "<p>{$para_text}</p>\n");
  self.clear_buffer('paragraph');
  }

method italic ($/)
{
  self.add_to_buffer('paragraph', $/.Str => "<i>{$/<multiline_text>.Str}</i>");
}

method bold ($/)
{
  self.add_to_buffer('paragraph', $/.Str => "<b>{$/<multiline_text>.Str}</b>");
}
```

One thing to watch out for with action classes is regex handling. **Every** action class example I've seen uses `$/` in the method signature. This is a mistake, as guess what this does:

```perl
method head1 ($/)
{
  if $/.Str ~~ m/foobar/ # silly example
  {
    self.add_to_html('body', "<h1>{$/<singleline_text>.Str}\n");
  }
}
```

    Cannot assign to a readonly variable or a value

Mushroom cloud-style boom. When `$/` is passed to `head1` it is read only. Executing **any** regex in the same lexical scope will attempt to overwrite `$/`. This bit me a few times and with help from \#perl6, I ended up using this pattern:

```perl
method head1 ($/ is copy)
{
  my $match = $/;
  if $match.Str ~~ m/foobar/
  {
    self.add_to_html('body', "<h1>{$match<singleline_text>.Str}</h1>\n");
  }
}
```

Adding `is copy` to the signature creates a copy instead of a reference for `$/`. I then copy the match variable into `$match`, so that the following regex can clobber `$/`. I \*think\* a better solution is this:

```perl
method head1 ($match)
{
  if $match.Str ~~ m/foobar/
  {
    self.add_to_html('body', "<h1>{$match<singleline_text>.Str}</h1>\n");
  }
}
```

I think it's that simple, just don't name the signature parameter `$/` and all the headaches disappear. I haven't tested this extensively...

To use an action class, just pass it to the grammar:

```perl
use Pod::Perl5::Grammar;
use Pod::Perl5::ToHTML;

my $actions = Pod::Perl5::ToHTML.new;
my $match = Pod::Perl5::Grammar.parse($pod, :$actions);

# or
my $match = Pod::Perl5::Grammar.parse($pod, :actions($actions));
```

In the first example I used a named positional argument `:$actions`. This **must** be called actions to work. In the second example I named the argument like this: `:actions($actions)`, in which case the action class object can be called whatever you want.

### Improving pod

PerlTricks.com articles are written in HTML. Special snowflake style HTML with class names and `span` tags. This is a pain for writers to use and a pain to edit. I'd love to use pod as the source - it would be easier for writers to use and faster for me to edit. That said, I'd like to extend pod with some useful features for blogging. For instance, you may be familiar with formatting codes like `B<...>` for bold and the like. Well, what about `@< ... >` for a Twitter references, or `M< ... >` for [MetaCPAN](https://metacpan.org/) links?

As Perl 6 grammars are classes, they can be inherited and overridden. So I can add my Twitter and Metacpan formatting codes to the grammar like this:

```perl
grammar Pod::Perl5::Grammar::PerlTricks is Pod::Perl5::Grammar
{
  token twitter  { @\< <name> \> }
  token metacpan { M\< <name> \> }
}
```

I'll also need to override the `format_codes` token to include the new tokens:

```perl
token format_codes  {
  [
    <italic>|<bold>|<code>|<link>
    |<escape>|<filename>|<singleline>
    |<index>|<zeroeffect>|<twitter|<metacpan>
  ]
}
```

It's that easy. The new grammar will parse all pod, plus my two new formatting codes. Of course the action class Pod::Perl5::Pod can be extended and overridden too, and would look something like this:

```perl
Pod::Perl5::ToHTML::PerlTricks is Pod::Perl5::ToHTML
{
  method twitter ($match)
  {
    self.add_to_buffer('paragraph',
      $match.Str =>
"<a href="http://twitter.com/{$match<name>.Str}">{$match<name>.Str}</a>");
  }
  method metacpan ($match)
  {
    self.add_to_buffer('paragraph',
      $match.Str =>
"<a href="{$match<name>.Str}">{$match<name>.Str}</a>"" >);
  }
}
```

### Wait, there's more

There's a cleaner way to manage groups of tokens, it's called [multi-dispatch](http://design.perl6.org/S06.html#Routine_modifiers). Instead of defining `format_codes` as a list of alternative tokens it can match against, we declare a prototype method, and declare each formatting method as a `multi` of the prototype. Check this out:

```perl
proto token format_codes  { * }
multi token format_codes:italic { I\< <multiline_text>  \>  }
multi token format_codes:bold   { B\< <multiline_text>  \>  }
multi token format_codes:code   { C\< <multiline_text>  \>  }
...
```

Now when this grammar is inherited, there is no need to override `format_codes`. Instead I can declare the new tokens as multis:

```perl
grammar Pod::Perl5::Grammar::PerlTricks is Pod::Perl5::Grammar
{
  token format_codes:twitter  { @\< <name> \> }
  token format_codes:metacpan { M\< <name> \> }
}
```

Using multi-dispatch also has the modest benefit of simplifying the data extraction path when working with a match object. For instance, these code extracts the link section from the 3rd paragraph of a pod block:

```perl
is $match<pod_section>[0]<paragraph>[2]<text><format_codes>[0]<link><section>.Str # regular version
is $match<pod_section>[0]<paragraph>[2]<text><format_codes>[0]<section>.Str # multi dispatch equivalent
```

In the first example, the format token name `link` is required. But with multi-dispatch, we can remove that, as shown in the second example.

### Conclusion

So that's what I learned; overall writing a pod parser in Perl 6 was straightforward. If you're programming in Perl 6 and have questions, I'd highly recommend the [\#perl6](http://perl6.org/community/irc) irc channel on freenode, the people there were friendly and responsive.

**Update:** *Multi-dispatch example added. Thanks to Jonathan Scott Duff for providing the multi-dispatch explanation and code. 2015-05-01*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
