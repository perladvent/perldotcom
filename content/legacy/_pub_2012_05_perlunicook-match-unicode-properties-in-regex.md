{
   "date" : "2012-05-16T06:00:01-08:00",
   "categories" : "unicode",
   "title" : "Perl Unicode Cookbook: Match Unicode Properties in Regex",
   "image" : null,
   "tags" : [],
   "thumbnail" : "/images/_pub_2012_04_perlunicook-standard-preamble/unicode.jpg",
   "slug" : "/pub/2012/05/perlunicook-match-unicode-properties-in-regex.html",
   "description" : "℞ 25: Match Unicode properties in regex with \\p, \\P Every Unicode codepoint has one or more properties, indicating the rules which apply to that codepoint. Perl's regex engine is aware of these properties; use the \\p{} metacharacter sequence to...",
   "draft" : null,
   "authors" : [
      "tom-christiansen"
   ]
}



℞ 25: Match Unicode properties in regex with `\p`, `\P`
-------------------------------------------------------

Every Unicode codepoint has one or more properties, indicating the rules which apply to that codepoint. Perl's regex engine is aware of these properties; use the `\p{}` metacharacter sequence to match a codepoint possessing that property and its inverse, `\P{}` to match a codepoint lacking that property.

Each property has a short name and a long name. For example, to match any codepoint which has the `Letter` property, you may use `\p{Letter}` or `\p{L}`. Similarly, you may use `\P{Uppercase}` or `\P{Upper}`. [perldoc perlunicode's "Unicode Character Properties" section]({{< perldoc "perlunicode" "Unicode-Character-Properties" >}}) describes these properties in greater detail.

Examples of these properties useful in regex include:

     \pL, \pN, \pS, \pP, \pM, \pZ, \pC
     \p{Sk}, \p{Ps}, \p{Lt}
     \p{alpha}, \p{upper}, \p{lower}
     \p{Latin}, \p{Greek}
     \p{script=Latin}, \p{script=Greek}
     \p{East_Asian_Width=Wide}, \p{EA=W}
     \p{Line_Break=Hyphen}, \p{LB=HY}
     \p{Numeric_Value=4}, \p{NV=4}

Previous: [℞ 24: Disable Unicode-awareness in Builtin Character Classes](/pub/2012/05/perlunicook-disable-unicode-awareness-in-builtin-character-classes.html)

Series Index: [The Standard Preamble](/pub/2012/04/perlunicook-standard-preamble.html)

Next: [℞ 26: Custom Character Properties](/pub/2012/05/perlunicookbook-custom-character-properties.html)
