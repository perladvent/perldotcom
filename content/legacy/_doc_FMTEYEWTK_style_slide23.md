{
   "title" : "Perl Style: Avoid Byte Processing",
   "draft" : null,
   "tags" : [],
   "image" : null,
   "description" : null,
   "authors" : [
      "tom-christiansen"
   ],
   "categories" : "programming-languages",
   "thumbnail" : null,
   "slug" : "/doc/FMTEYEWTK/style/slide23.html",
   "date" : "1998-01-01T00:00:00-08:00"
}


-   C programmers often try to process strings a byte at a time. Don't do that! Perl makes it easy to take data in big bites.
-   Don't use `getc`. Grab the whole line and operate on it all at once.
-   Even operations traditionally done a char at a time in C, like lexing, should be done differently. For example:

            @chars = split //, $input;
            while (@chars) {
              $c = shift @chars;
              # State machine;
            }

    Is far too low level. Try something more like:

            sub parse_expr {
            local $_ = shift;
            my @tokens = ();
            my $paren = 0;
            my $want_term = 1;

            while (length) {
                s/^\s*//;

                if (s/^\(//) {
                return unless $want_term;
                push @tokens, '(';
                $paren++;
                $want_term = 1;
                next;
                } 

                if (s/^\)//) {
                return if $want_term;
                push @tokens, ')';
                if ($paren < 1) {
                    return;
                } 
                --$paren;
                $want_term = 0;
                next;
                } 

                if (s/^and\b//i || s/^&&?//) {
                return if $want_term;
                push @tokens, '&';
                $want_term = 1;
                next;
                } 

                if (s/^or\b//i || s/^\|\|?//) {
                return if $want_term;
                push @tokens, '|';
                $want_term = 1;
                next;
                } 

                if (s/^not\b//i || s/^~// || s/^!//) {
                return unless $want_term;
                push @tokens, '~';
                $want_term = 1;
                next;
                } 

                if (s/^(\w+)//) {
                push @tokens, '&' unless $want_term;
                push @tokens, $1 . '()';
                $want_term = 0;
                next;
                } 

                return;

            }
            return "@tokens";
            }

------------------------------------------------------------------------

Forward to [Avoid Symbolic References](/doc/FMTEYEWTK/style/slide24.html)
Back to [Use foreach() Loops](/doc/FMTEYEWTK/style/slide22.html)
Up to [index](/doc/FMTEYEWTK/style/slide-index.html)

Copyright © 1998, Tom Christiansen
All rights reserved.
