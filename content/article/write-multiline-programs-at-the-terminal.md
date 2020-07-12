
  {
    "title"  : "Write multiline programs at the terminal",
    "authors": ["david-farrell"],
    "date"   : "2016-07-05T11:18:55",
    "tags"   : ["here-doc","perl","terminal","bash","less","man","http-tiny"],
    "draft"  : false,
    "image"  : "",
    "description" : "Using the shell here-doc for throwaway programs",
    "categories": "development"
  }

Perl one liners are incredibly useful, and when I'm working I write several a day. Whether it's to test if a new module compiles, check the syntax of a function, or edit a file, one liners do the trick. Sometimes when I need to do something more involved, instead of a one liner I'll write a throwaway script. Of course I usually forget to delete the script and that's why my machine is littered with Perl files like 'tmp.pl', 'getname.pl' etc. But I've since found a better way - using a shell here-doc!

### Shell here-docs

In the terminal I can use the here-doc syntax to write an entire Perl script at the command line. Here's an example using [HTTP::Tiny]({{<mcpan "HTTP::Tiny" >}}) to print out the HTTP headers returned by this website.

    $ perl - <<'EOF'
    > use HTTP::Tiny;
    > use Data::Dumper;
    > my $res = HTTP::Tiny->new->get('http://perltricks.com/');
    > print Dumper($res->{headers});
    > EOF

What's happening here? The syntax `perl -` primes Perl to execute STDIN. The syntax for a shell here-doc is `<<'word'` where "word" is the value to terminate the here-doc with (I tend to use `EOF` or `END`). After typing the first line and pressing enter, the shell caret will move to a new line, prefixed with `> `. It would look like this:

    $ perl - <<'EOF'
    > 

At this point, you can type the lines of the Perl script, pressing enter for a new line. Or you can paste in code from an existing script. Once you type the terminating word on a new line, the terminal sends the script to `perl` via STDIN. Unlike with one-liners, you're free to use both single and double quotes in the program text. Yay!

If I want shell parameter expansion, I leave the terminator unquoted:

    $ perl - <<EOF
    > print "$HOME\n"
    > EOF
    /home/dfarrell

Now I can write throwaway scripts in the terminal, and not leave them littered all over my hard drive. Just like other successful commands, Bash will store the script in it's history, so you can search for, edit and re-execute the scripts over and over again.

This trick isn't specific to Perl. Shell here-docs can be used in the same way to execute code in Perl 6, Python, Ruby ... any binary which can execture code from STDIN.

### Editing tips

Let's say you just ran a throwaway script using a here-doc, and now you want to edit it and run it again. If you press the up arrow, Bash will display the command, but you can't press up again, else Bash will display the previous command. Instead, use the left and right arrow keys to move to the beginning and end of lines, and the caret will automatically jump to the next line.

When editing a throwaway script, I start by deleting the terminator word ("EOF" or whatever). That way when I press enter, I can add more lines to the script. If the command you're looking for is an old one, you can search your terminal history with `<Ctrl><shift>r`.

### References

* The Wikipedia [here-docs entry](https://en.wikipedia.org/wiki/Heredoc#Unix_shells) has examples of shell here-doc syntax.
* The bash manpage (`man bash`) has a concise but useful entry on shell here-docs and the different types.
* The more common way to use here-docs is inside Perl code. Read about _those_ in [perlop]({{< perldoc "perlop" >}}), the official Perl documentation.Read it in the terminal with `perldoc perlop`.
* [HTTP::Tiny]({{<mcpan "HTTP::Tiny" >}}) is a lightweight, _fast_ Perl user agent that comes bundled with Perl (since version 5.14.0). You probably have it installed already, so you can read it's documentation with `perldoc HTTP::Tiny`.

N.B. When reading documentation in the terminal, type `/search-term<enter>` to jump to the next search match. Pressing `n` will jump to the next match and `N` the previous match. Pressing `h` will display the help page. (all of this assumes your terminal reader is `less`, which is typical).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
