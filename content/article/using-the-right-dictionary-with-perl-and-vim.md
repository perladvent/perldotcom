{
   "image" : "/images/using-the-right-dictionary-with-perl-and-vim/merriam-webster.png",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2019-05-30T08:45:17",
   "draft" : false,
   "thumbnail" : "/images/using-the-right-dictionary-with-perl-and-vim/thumb_merriam-webster.png",
   "tags" : ["webster", "dictionary", "vim", "vimscript"],
   "categories" : "development",
   "title" : "Using the right dictionary with Perl and Vim",
   "description" : "Parsing Webster's 1913 classic and integrating it into an editor"
}

I recently read James Summers' excellent article, [You're probably using the wrong dictionary](http://jsomers.net/blog/dictionary) and was inspired to start using Webster's 1913 edition myself. Using the instructions in the article, I was able to integrate searching the dictionary into my browser, but I spend most of my time working in the terminal, and wanted a command line solution.

I got a text version of the dictionary from [archive.org](https://archive.org/details/webstersunabridg29765gut), and set about writing a Perl script to search it.

A naive search
---------------
Every entry in the 1913 text edition begins with the capitalized term at the beginning of a line followed by a newline, and the details about the entry. Webster's definition for "llama" is typical:

    LLAMA
    Lla"ma, n. Etym: [Peruv.] (Zoöl.)

    Defn: A South American ruminant (Auchenia llama), allied to the
    camels, but much smaller and without a hump. It is supposed to be a
    domesticated variety of the guanaco. It was formerly much used as a
    beast of burden in the Andes.

In this case it tells us that "llama" is a noun, originating from Peru. The abbreviation "Zoöl." means it's a Zoölogical term. Wiktionary has a handy [list](https://en.wiktionary.org/wiki/Wiktionary:Abbreviations_in_Webster) of Webster's abbreviations.

A single term can contain uppercase letters, numbers, spaces, dashes and single quotes. When there are alternative spellings for the same term, each spelling appears on the same line separated by a semicolon and space, like this:

    WOLVERENE; WOLVERINE

To find matching entries in the dictionary, I want to search for matching terms, print their content and stop printing when I get to the next term:

```perl
#!/usr/bin/perl
my $search_term = uc join ' ', @ARGV;
my $entry_pattern = qr/^[A-Z][A-Z0-9' ;-]*$/;
my $search_pattern = qr/^$search_term/;

open my $dict, '<:encoding(latin1)', 'webster-1913.txt' or die $!;

while (<$dict>) {
  next unless /$entry_pattern/ && /$search_term/;
  my $output = $_;
  while (1) {
   my $next_line = readline $dict;
   if ($next_line =~ /$entry_pattern/) {
     seek $dict, -length($next_line), 1;
     last;
   }
   $output .= $next_line;
  }
  print $output;
}
```

This script reads a search term from its command line args, converting it to uppercase. It then opens the dictionary which is encoded in [Latin 1](https://en.wikipedia.org/wiki/ISO/IEC_8859-1), and scans for lines matching the pattern: `qr/^[A-Z][A-Z0-9' ;-]*$/`, which tries to only match lines marking the beginning of an entry ("WOLVERENE; WOLVERINE"). It then uses `readline` to slurp the dictionary definition, until it finds the next entry, at which point it sets the filehandle pointer back one line, and prints the text it matched.

One of the nice properties of Latin 1 is every character is a single byte, which means I don't need to worry about [seek]({{< perlfunc "seek" >}}) breaking on a character because [length]({{< perlfunc "length" >}}) was counting in characters, but `seek` uses bytes.

Run run the script like this:

    $ ./webster-search.pl tower

On my laptop it takes about a second to run, which isn't bad considering the dictionary is 27mb.

A faster search
---------------
One obvious improvement is to have the script exit once it finds an entry which is alphabetically higher than the search term. The entry after "LLAMA" is "LLANDEILO GROUP", which I can compare using [cmp]({{< perlfunc "cmp" >}}). If the search term sorts earlier than the comparison term, `cmp` will return 1, if they match 0, otherwise it will return -1:

```perl
"LLAMA" cmp "LLANDEILO GROUP"; # -1
```

An interesting property of Webster's 1913 dictionary as a data source is that it never changes, so I can take advantage of that by building a static index for each letter's starting point. Each letter's section begins with the capitalized letter alone on a line.

```perl
#!/usr/bin/perl
open my $dict, '<:encoding(latin1)', 'webster-1913.txt' or die $!;

my @alphabet = 'A'..'Z';

while (<$dict>) {
  next unless /^$alphabet[0]$/;
  printf "%s => %d\n", shift @alphabet, tell $dict;
  last unless @alphabet;
}
```
When this script encounters a new letter's section, it calls [tell]({{< perlfunc "tell" >}}) on the filehandle to determine the byte location, and then prints the details to stdout:

    $ ./build-index.pl
    A => 601
    B => 1796502
    C => 3293436
    D => 6039049
    E => 7681559
    ...

Curiously this index data stopped at "S" the first time I ran it. That's because the copies of Webster's 1913 dictionary on archive.org are missing the "T" entry! I found the entry [online](http://www.webster-dictionary.org/definition/T) and added it to my copy.

By incorporating this index data into my script, I'll jump to the section of the first letter of the search term, and start searching from there.

```perl
#!/usr/bin/perl
my $search_term = uc join ' ', @ARGV;
my $entry_pattern = qr/^[A-Z][A-Z0-9' ;-]*$/;
my $search_pattern = qr/^$search_term/;

my %index = (
  A => 601,
  B => 1796502,
  C => 3293436,
  D => 6039049,
  E => 7681559,
  F => 8833301,
  G => 10034091,
  H => 10926753,
  I => 11930292,
  J => 13148994,
  K => 13380269,
  L => 13586035,
  M => 14532408,
  N => 15916448,
  O => 16385339,
  P => 17042770,
  Q => 19439223,
  R => 19610041,
  S => 21015876,
  T => 24379537,
  U => 25941093,
  V => 26405366,
  W => 26925697,
  X => 27748359,
  Y => 27774096,
  Z => 27866401,
);

my $start = $index{ substr $search_term, 0, 1 };
open my $dict, '<:encoding(latin1)', 'webster-1913.txt' or die $!;
seek $dict, $start, 0;

my $found_match = undef;
while (<$dict>) {
  next unless $_ =~ $entry_pattern;

  if ($_ =~ $search_term) {
    my $output = $_;
    while (1) {
     my $next_line = readline $dict;
     if ($next_line =~ /$entry_pattern/) {
       seek $dict, -length($next_line), 1;
       last;
     }
     $output .= $next_line;
    }
    print $output;
    $found_match = 1;
  }
  last if $found_match && ($search_term cmp $_) == -1;
}
```

Searching for "tower" this script finishes in 70ms, which is a 14x improvement over the initial script. Not bad for 2 simple optimizations. I could spend time tuning this further with a more specific index, or an optimized regex, but this is fast enough for now.

Searching from Vim
------------------
It's fairly straightforward to integrate the Perl script into Vim with vimscript plugin:

```vim
" webster-search.vim
let s:parent_dir = expand('<sfile>:p:h')

function! WebsterSearch(term)
  let l:perl_script = 'webster-search.pl'
  let l:command =  s:parent_dir . '/' . l:perl_script . ' ' . a:term
  execute "let output = system('" . l:command . "')"
  vnew
  setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
  call setline(1, split(output, "\n"))
endfunction
command! -nargs=1 WebsterSearch call WebsterSearch(<args>)
```

The first line obtains the parent directory of the plugin file, to avoid hard coding a path to the Perl script. Next it adds a function called "WebsterSearch" which calls the Perl script with a search term, printing the output into a new vertical window. The last line calls the `command` function to register the user defined function, and avoid having to dispatch to it using `call`.

To use the plugin, I map a shortcut in my .vimrc:

```vim
nnoremap <leader>d :WebsterSearch(expand('<cWORD>'))<cr>
```

Now whenever my cursor is over a word I want to lookup in the dictionary, I press "\d" and I get Webster's entry right there in my terminal! One downside of `cWORD` is it will only match the first word under the cursor, but some dictionary entries contain spaces ("ad hominem"). For those rarer cases, I can highlight the words in visual mode, and then execute a dictionary search:

```vim
vnoremap <leader>d :<c-u>WebsterSearch(@*)<cr>
```

This maps the same shortcut when Vim is in visual mode; `<c-u>` clears the range automatically entered by Vim, then it calls the function passing the register variable `@*` (the last highlighted text) as the search term.

I've uploaded this code to [GitHub](https://github.com/dnmfarrell/WebsterSearch), along with Vim install instructions.

An alternative to searching the raw dictionary text is to use [GCIDE](http://gcide.gnu.org.ua/) (h/t [frew](https://blog.afoolishmanifesto.com/)) which is based on Webster's 1913 dictionary, and has machine-readable markup for easier parsing.
