{
   "authors" : [
      "philipp-janert"
   ],
   "draft" : null,
   "slug" : "/pub/2006/11/30/html-template-filters.html",
   "description" : " The CPAN module HTML::Template is a very simple, yet extremely useful module to achieve true separation of presentation and logic when programming CGI scripts. The basic idea is that, rather than having print statements scattered all through your code...",
   "categories" : "web",
   "title" : "Advanced HTML::Template: Filters",
   "image" : null,
   "date" : "2006-11-30T00:00:00-08:00",
   "tags" : [
      "filters",
      "html-templating",
      "html-template",
      "perl-templating"
   ],
   "thumbnail" : "/images/_pub_2006_11_30_html-template-filters/111-html_filter.jpg"
}



The CPAN module [`HTML::Template`](https://metacpan.org/pod/HTML::Template) is a very simple, yet extremely useful module to achieve true separation of presentation and logic when programming CGI scripts. The basic idea is that, rather than having `print` statements scattered all through your code (the "classic" CGI approach), or mixing logic in with HTML (as in JSP, ASP, and Perl Mason), you maintain *two* files. One is the actual Perl script containing the business logic and the other one is a *template* file, containing exclusively presentation layer statements.

The template is straight-up HTML, augmented by a small set of special tags. The templating system replaces these tags by dynamic content. The dynamic content comes from a Perl data structure that you have built in your code.

Here is a minimal template and the corresponding script:

    <html>
      <head></head>
      <body>
        <h1><TMPL_VAR NAME=title></h1>

        <ul>
          <TMPL_LOOP NAME=rows>
            <li><TMPL_VAR NAME=item>
          </TMPL_LOOP>
        </ul>
      </body>
    </html>

    #!/usr/bin/perl -w
    use HTML::Template;

    # Create the template object
    my $tpl = HTML::Template->new( filename => 'tmpl1.tpl' );

    # Set the parameter values
    $tpl->param( title => "Useful Books" );
    $tpl->param( rows => [ { item => "Learning Perl" },
                           { item => "Programming Perl" },
                           { item => "Perl Cookbook" } ] );

    # Print
    print "Content-Type: text/html\n\n", $tpl->output;

That's really all there is to it.

### As Simple as Possible, but Not Simpler?

One of the nice things about `HTML::Template` is that doesn't try to do too much. It is a templating system for HTML, period. That keeps it simple and avoids complementary features, which could get in the way.

In this spirit, the module only offers a very, very limited set of tags, and no obvious way to extend this selection. Here is the complete list:

-   `<TMPL_VAR>`
-   `<TMPL_LOOP>`
-   `<TMPL_IF>`
-   `<TMPL_ELSE>`
-   `<TMPL_UNLESS>`
-   `<TMPL_INLCUDE>`

All of these tags do pretty much what you might expect: `<TMPL_VAR>` expands to dynamic text; `<TMPL_LOOP>` loops over an array; `<TMPL_IF>`, `<TMPL_ELSE>`, and `<TMPL_UNLESS>` provide a mechanism for conditional display; and `<TMPL_INLCUDE>` allows you to include pieces of other documents (such as a shared page header).

Most of the time, this is precisely what you want. All the facilities are there to control the *display*, but there is no danger in mixing general-purpose code in with the HTML template.

Yet, sometimes things can become unnecessarily clumsy--in particular, concerning the conditional display of information. A typical example concerns *optional information*. Suppose that you want to display a list of library books with their due dates, but should display the due date *only* if the book is currently checked out. (This is a surprisingly common pattern. Think of items with an optional sales price, accounts with an optional bad account status, a flight schedule with optional delay information, etc.)

Sometimes you can simply leave the corresponding variable blank:

    <ul>
      <TMPL_LOOP NAME=books>
        <li><TMPL_VAR NAME=title>   <TMPL_VAR NAME=duedate>
      </TMPL_LOOP>
    </ul>

and use the code:

    $tpl->param( books => [ { title => 'Learning Perl', duedate => '' },
                            { title => 'Programming Perl', duedate => '29. Feb. 2008' } ] );

This will work. There will be no output for the due date if there is no due date. However, what if you want to have some additional text, in addition to the actual due date? That template might resemble:

    <ul>
      <TMPL_LOOP NAME=books>
        <li><TMPL_VAR NAME=title>
            <TMPL_IF NAME=duedate>
              Date due: <TMPL_VAR NAME=duedate>
            </TMPL_IF>
      </TMPL_LOOP>
    </ul>

Do this a lot, and you will start looking for a better solution! (The main problem here is not actually the additional typing, but the fact that the template itself is becoming increasingly unwieldy and its structure harder to follow.)

One solution is to put the additional text in code:

    $tpl->param( books => [ { title => 'Learning Perl', duedate => '' },
                            { title => 'Programming Perl', duedate => 'Date due: 29. Feb. 2008' } ] );

However, this is clumsy: it breaks the separation of presentation and behavior, as there is now strictly presentational material such as "Date due: " in the Perl code, and it makes the parameter less generally useful. If you want the plain date somewhere else in the template, it now comes bundled with a string that you may not want.

Wouldn't it be nice if you could bundle the entire optional part of each list entry ("encapsulate it," if you will) and simply call it by name? To put it in other words, what if you had the ability to define a custom tag?

### Enabling Custom Tags Using Filters

This is where *filters* come in. A filter is a subroutine called on the template text before tag substitution takes place. A filter can do anything. In particular, it can modify the template programmatically.

A filter is precisely the hook into the template processing that is necessary to enable custom tags. Write your template in terms of standard template tags and your own custom tags. Then provide a filter (or filters) to replace these custom tags with the appropriate combinations of standard tags. The `HTML::Template` "engine" then does the final substitutions and renders the ultimate output.

For the library example, suppose that you have chosen to use a custom tag `<CSTM_DUEDATE>` to display the optional due date. This makes the template look very clean and simple:

    <ul>
      <TMPL_LOOP NAME=books>
        <li><TMPL_VAR NAME=title>   <CSTM_DUEDATE>
      </TMPL_LOOP>
    </ul>

The code to set the template parameter values does not change, but you now need to define the filter (and note that you need to escape the slash in the `</TMPL_IF>`):

    sub duedate_filter {
      my $text_ref = shift;
      $$text_ref =~ s/<CSTM_DUEDATE>/<TMPL_IF NAME=duedate>Date due: <TMPL_VAR NAME=duedate><\/TMPL_IF>/g;
    }

Finally, you need to register this filter, so that the module will call it before tag substitution takes place. Filters are options to the template object, so registration takes place when you construct the template:

    $tpl = HTML::Template->new( filename => 'books.tpl',
                                filter => \&duedate_filter );

That's the basic idea. If you wanted to, you could register a sequential collection of filters (one filter per custom tag?) or you can put all required substitutions into a single routine. I can certainly perceive of the possibility of developing reusable "tag libraries" as Perl modules with filter definitions. Interestingly (and in contrast to JSP), the template files themselves do not need to know about the definitions and behavior of the "custom tags." I think this is exactly right: the templates are plain ("dumb") text files, which define the presentation layer. All the *behavior* is in the Perl code, where it belongs.

### Data-Sensitive Displays and Data Filters

Consider another example application. Rather than dealing with optional information, this one uses *conditional formatting*.

Assume that you have a list of accounts, and each account has a various state: "Good," "Bad," and "Canceled." You would like to display the account number in a different color, depending on the state: green for "Good," yellow for "Bad," and red for "Canceled."

If you tried to do this using `<TMPL_IF>` tags, this would be a real mess, for two reasons: You have more than two choices, so that we can't use a `<TMPL_IF>...<TMPL_ELSE>...</TMPL_IF>` construct; instead you would have to use a sequence of individual conditionals: `<TMPL_IF>...</TMPL_IF><TMPL_IF>...</TMPL_IF><TMPL_IF>...</TMPL_IF>`. Moreover, `<TMPL_IF>` does not allow for arbitrary conditional expressions (such as `$status eq 'good'`). All it does is test a Boolean variable. The classic approach is to introduce three Boolean dummy variables: `$isGood`, `$isBad`, and `$isCancelled` to use in these tests. There's certainly a better way!

Instead, introduce a custom tag that allows for configurable formatting:

    <CSTM_SPAN NAME=...>

Here is the associated filter:

    sub span_filter {
      my $text_ref = shift;
      $$text_ref =~ s/<CSTM_SPAN\s+NAME=(.*?)\s*>
                     /<span class='<TMPL_VAR NAME=$1_class>'>
                        <TMPL_VAR NAME=$1>
                      <\/span>
                     /gx;
    }

If you use this custom tag in your template as `<CSTM_SPAN NAME=account>`, then the template in the intermediate state, *after* filter application, but *before* template parameter substitution, will look like:

    <span class='<TMPL_VAR NAME=account_class>'>
      <TMPL_VAR NAME=account>
    </span>

The original single custom tag has expanded into an HTML `<span>` tag wrapping the actual dynamic content. The `<span>` defines a CSS class to provide formatting to the dynamic content. The *name* of the CSS class itself is dynamic, too--so that you can select the classes `.bad` or `.good` depending on the value of the account status. The name of the CSS class comes from the name of the displayed parameter. If this class is defined in a stylesheet or within the HTML document itself, a CSS-capable client will apply it to the dynamic text as expected.

In other words, the innocuous `<CSTM_SPAN>` tag actually requires *two* parameters: one containing the text to display and the other specifying the CSS class to apply. All you need to do is to set the `account_class` parameter to the appropriate value in Perl code (and, of course, define the CSS classes somewhere in the stylesheet.)

Here is a slick way to stay in control doing this. You can call the `param()` function either with individual name/value-pairs (as I have shown before), or with a hash-ref: `$tpl->param( { key1 => value1, key2 => value2 } )`. In other words, rather than calling `param()` repeatedly throughout your code, setting individual parameters, you can build up one large hash, containing *all* parameters, and then pass it to the template in a single call.

Now you can apply the filter trick that worked so well for the template itself, on the *parameters* as well! In other words, before calling `$tpl->param( \%parameter_hash)`, pass the hash to a subroutine, which performs data filtering operations on the parameters. In this case, it adds the CSS class appropriate for the account status for each account in the data structure.

This approach centralizes all data-dependent display decisions in a single subroutine. If you add further status codes, or if you want to change the display class, there is only a single location to edit.

Here is a Perl program demonstrating these concepts:

    #!/usr/bin/perl -w
    use HTML::Template;

    # Create the template object
    my $tpl = HTML::Template->new( filename => 'tmpl4.tpl',
                                   filter => \&span_filter );

    # Build a data structure containing all the parameters
    my %params = ( title => "Accounts",
                   accounts => [ { account => 'Good' }, { account => 'Bad' } ] );

    apply_display_logic( \%params );

    # Set all parameters for the template at once
    $tpl->param( \%params );

    # Print
    print "Content-Type: text/html\n\n", $tpl->output;

    # ---

    sub span_filter {
      my $text_ref = shift;
      $$text_ref =~ s/<CSTM_SPAN\s+NAME=(.*?)\s*>
                     /<span class='<TMPL_VAR NAME=$1_class>'>
                        <TMPL_VAR NAME=$1>
                      <\/span>
                     /gx;
    }

    sub apply_display_logic {
      my $hash_ref = shift;

      my %account_classes = ( Good => 'good', Bad => 'bad' );

      foreach my $acc ( @{ $hash_ref->{ accounts } } ) {
        $acc->{account_class} = $account_classes{ $acc->{account} };
      }
    }

### \#%@$! Happens

When I first explained this idea to a colleague, his reaction was: "Great. You go down that path and you are going to end up with JSP. Is that what you want?" To which my response was: "Well, *fertilizer* happens."

GUI development is a pain. Always. You cannot avoid all issues regarding the separation of presentation and logic in GUI development. The challenge in my opinion is therefore not to find the *ideal* web development framework, but the *optimal* one for the task at hand.

`HTML::Template` is very, very good for rather simple, minimum fuss, straightforward websites (of which there are significantly more than anyone might want to admit). It is particularly well-suited for reports and stats. In this application domain, the ability to the define custom tags to take care of formatting and special presentation issues is a distinct advantage.

### Conclusion

In the second part of this series, I will take these ideas a step further and explore how to use `HTML::Template` to create GUI-like *widgets* in a web/CGI situation.
