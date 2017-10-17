{
   "title" : "Dynamic variable names with a dereferencing block",
   "description" : "Perl is remarkably flexible and allows you to achieve all kinds of wizardry with the language. One example of this is using a dereferencing block to use a scalar value as a variable name. This allows you to use variables with dynamic names.",
   "authors" : [
      "david-farrell"
   ],
   "categories" : "development",
   "image" : null,
   "slug" : "23/2013/5/2/Dynamic-variable-names-with-a-dereferencing-block",
   "draft" : false,
   "date" : "2013-05-02T20:16:55",
   "tags" : [
      "regex",
      "variable",
      "dereference",
      "syntax",
      "old_site"
   ]
}


Perl is remarkably flexible and allows you to achieve all kinds of wizardry with the language. One example of this is using a dereferencing block to use a scalar value as a variable name. This allows you to use variables with dynamic names.

An interesting example of this can be seen in [Nginx::ParseLog](https://metacpan.org/source/NRG/Nginx-ParseLog-1.01/lib/Nginx/ParseLog.pm), I've reproduced the relevant code:

``` prettyprint
if ( $log_string =~ m/^($ip)\s-\s (.*?)\s         \[(.*?)\]\s  "(.*?)"\s  (\d+)\s  (\d+)\s     "(.*?)"\s  "(.*?)"$/x) {
    my $deparsed = { };
    my $c = 0;
         
    my @field_list = qw/
            ip     
        remote_user
            time    
            request
            status 
            bytes_send
            referer 
            user_agent
    /;
 
    {
        no strict 'refs'; # some Perl magic
 
        for (@field_list) {
            $deparsed->{ $_  } = ${ ++$c };
            }
    }
     
    return $deparsed;
}
```

What this code does is match $log\_string against a regex - if the match is successful, it iterates through the regex capture global variables ($1-$8), using the values of @field\_list as the key values for the captures. The dynamic variable name is stored in $c.

Using dynamic variable names can provide useful shortcuts when used in the right context. Dynamic variables can also increase the risk of error (note that strict 'refs' had to be disabled for this code to work). What's nice about this example is using the regex match in the if statement provides the assurance that every capture was successful, hence in this context it should be ok to turn strict refs off briefly.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
