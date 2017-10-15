{
   "draft" : null,
   "description" : " Editor's note: this venerable series is undergoing updates. You might be interested in the newer versions, available at: A Beginner's Introduction to Perl 5.10 A Beginner's Introduction to Files and Strings with Perl 5.10 A Beginner's Introduction to Regular...",
   "slug" : "/pub/2000/12/begperl4.html",
   "tags" : [
      "cgi",
      "scriptingg",
      "security",
      "web"
   ],
   "authors" : [
      "doug-sheppard"
   ],
   "title" : "Beginners Intro to Perl - Part 4",
   "categories" : "development",
   "date" : "2000-12-06T00:00:00-08:00",
   "image" : null,
   "thumbnail" : null
}



*Editor's note: this venerable series is undergoing updates. You might be interested in the newer versions, available at:*

-   [A Beginner's Introduction to Perl 5.10](/pub/a/2008/04/23/a-beginners-introduction-to-perl-510.html)
-   [A Beginner's Introduction to Files and Strings with Perl 5.10](/pub/a/2008/05/07/beginners-introduction-to-perl-510-part-2.html)
-   [A Beginner's Introduction to Regular Expressions with Perl 5.10](http://news.oreilly.com/2008/06/a-beginners-introduction-to-pe.html)
-   [A Beginner's Introduction to Perl Web Programming](http://broadcast.oreilly.com/2008/09/a-beginners-introduction-to-pe.html)

### It's CGI time

<table>
<colgroup>
<col width="100%" />
</colgroup>
<tbody>
<tr class="odd">
<td><strong>Beginners Intro to Perl</strong></td>
</tr>
<tr class="even">
<td><p>•<strong><a href="/pub/2000/10/begperl1.html">Part 1 of this series</a></strong><br />
•<strong><a href="/pub/2000/11/begperl2.html">Part 2 of this series</a></strong><br />
•<strong><a href="/pub/2000/11/begperl3.html">Part 3 of this series</a></strong><br />
•<strong><a href="/pub/2000/12/begperl5.html">Part 5 of this series</a></strong><br />
•<strong><a href="/pub/a/2001/01/begperl6.html">Part 6 of this series</a></strong><br />
<br />
•<a href="#cgi">What is CGI?</a><br />
•<a href="#cgi_program">A Real CGI Program</a><br />
•<a href="#uhoh">Uh-Oh!</a><br />
•<a href="#second_script">Our Second Script</a><br />
•<a href="#sorting">Sorting</a><br />
•<a href="#trust">Trust No One</a><br />
•<a href="#play_around">Play Around!</a></p></td>
</tr>
</tbody>
</table>

So far, we've talked about Perl as a language for mangling numbers, strings, and files - the original purpose of the language. Now it's time to talk about what Perl does on the Web. In this installment, we're going to talk about CGI programming.

### <span id="cgi">What is CGI?</span>

The Web is based on a client-server model: your browser (the client) making requests to a Web server. Most of these are simple requests for documents or images, which the server delivers to the browser for display.

Of course, sometimes you want the server to do more than just dump the contents of a file. You'd like to do something with a server-side program - whether that "something" is using Web-based e-mail, looking up a phone number in a database or ordering a copy of *Evil Geniuses in a Nutshell* for your favorite techie. This means the browser must be able to send information (an e-mail address, a name to look up, shipping information for a book) to the server, and the server must be able to use that information and return the results to the user.

The standard for communication between a user's Web browser and a server-side program running on the Web server is called **CGI**, or Common Gateway Interface. It is supported by all popular Web server software. To get the most out of this article, you will need to have a server that supports CGI. This may be a server running on your desktop machine or an account with your ISP (though probably not a free Web-page service). If you don't know whether you have CGI capabilities, ask your ISP or a local sysadmin how to set things up.

Notice that I haven't described how CGI works; that's because you don't *need* to know. There's a standard Perl module called `CGI.pm` that will handle the CGI protocol for you. CGI.pm is part of the core Perl distribution, and any properly installed Perl should have it available.

Telling your CGI program that you want to use the CGI module is as simple as this:

    use CGI ':standard';

The `use CGI ':standard';` statement tells Perl that you want to use the CGI.pm module in your program. This will load the module and make a set of CGI functions available for your code.

### <span id="cgi_program">A Real CGI Program</span>

Let's write our first real CGI program. Instead of doing something complex, we'll write something that will simply throw back whatever we throw at it. We'll call this script `backatcha.cgi`:

    #!/usr/local/bin/perl

    use CGI ':standard';

    print header();
    print start_html();

    for $i (param()) {
        print "<b>", $i, "</b>: ", param($i), "<br>\n";
    }

    print end_html();

If you've never used HTML, the pair of &lt;b&gt; and &lt;/b&gt; tags mean "begin bold" and "end bold", respectively, and the &lt;br&gt; tag means "line break." (A good paper reference to HTML is O'Reilly's *HTML & XHTML: The Definitive Guide*, and online, I like [the Web Design Group](http://www.htmlhelp.com/).)

Install this program on your server and do a test run. (If you don't have a Web server of your own, we've put a copy online for you [here](/cgi-bin/backatcha.pl).) Here's a short list of what you do to install a CGI program:

1.  Make sure the program is placed where your Web server will recognize it as a CGI script. This may be a special `cgi-bin` directory or making sure the program's filename ends in `.pl` or `.cgi`. If you don't know where to place the program, your ISP or sysadmin should.
2.  Make sure the program can be run by the server. If you are using a Unix system, you may have to give the Web-server user read and execute permission for the program. It's easiest to give these permissions to everybody by using `chmod filename 755`.
3.  Make a note of the program's URL, which will probably be something like http://*server name*/cgi-bin/backatcha.cgi) and go to that URL in your browser. (Take a guess what you should do if you don't know what the URL of the program is. Hint: It involves the words "ask," "your" and "ISP.")

If this works, you will see in your browser ... a blank page! Don't worry, this is what is *supposed* to happen. The `backatcha.cgi` script throws back what you throw at it, and we haven't thrown anything at it yet. We'll give it something to show us in a moment.

If it *didn't* work, you probably saw either an error message or the source code of the script. We'll try to diagnose these problems in the next section.

### <span id="uhoh">Uh-Oh!</span>

If you saw an error message, your Web server had a problem running the CGI program. This may be a problem with the program or the file permissions.

First, are you *sure* the program has the correct file permissions? Did you set the file permissions on your program to 755? If not, do it now. (Windows Web servers will have a different way of doing this.) Try it again; if you see a blank page now, you're good.

Second, are you *sure* the program actually works? (Don't worry, it happens to the best of us.) Change the `use CGI` line in the program to read:

    use CGI ':standard', '-debug';

Now run the program from the command line. You should see the following:

    (offline mode: enter name=value pairs on standard input)

This message indicates that you're *testing* the script. You can now press Ctrl-D to tell the script to continue running without telling it any form items.

If Perl reports any errors in the script, you can fix them now.

(The `-debug` option is incredibly useful. Use it whenever you have problems with a CGI program, and ignore it at your peril.)

The other common problem is that you're seeing the source code of your program, not the result of running your program. There are two simple problems that can cause this.

First, are you *sure* you're going through your Web server? If you use your browser's "load local file" option (to look at something like `/etc/httpd/cgi-bin/backatcha.cgi` instead of something like `http://localhost/cgi-bin/backatcha.cgi`), you aren't even touching the Web server! Your browser is doing what you "wanted" to do: loading the contents of a local file and displaying them.

Second, are you *sure* the Web server knows it's a CGI program? Most Web server software will have a special way of designating a file as a CGI program, whether it's a special `cgi-bin` directory, the `.cgi` or `.pl` extension on a file, or something else. Unless you live up to these expectations, the Web server will think the program is a text file, and serve up your program's source code in plain-text form. Ask your ISP for help.

CGI programs are unruly beasts at the best of times; don't worry if it takes a bit of work to make them run properly.

### Making the Form Talk Back

At this point, you should have a working copy of `backatcha.cgi` spitting out blank pages from a Web server. Let's make it actually tell us something. Take the following HTML code and put it in a file:

    <FORM ACTION="putyourURLhere" METHOD=GET>
        <P>What is your favorite color? <INPUT NAME="favcolor"></P>
    <INPUT TYPE=submit VALUE="Send form">
    lt;/FORM>

Be sure to replace `putyourURLhere` with the actual URL of your copy of `backatcha.cgi`! If you want, you can use the [copy installed here](/cgi-bin/backatcha.pl) at Perl.com.

This is a simple form. It will show a text box where you can enter your favorite color and a "submit" button that sends your information to the server. Load this form in your browser and submit a favorite color. You should see this returned from the server:

    favcolor: green

### CGI functions

The CGI.pm module loads several special CGI functions for you. What are these functions?

The first one, `header()`, is used to output any necessary HTTP headers before the script can display HTML output. Try taking this line out; you'll get an error from the Web server when you try to run it. This is *another* common source of bugs!

The `start_html()` function is there for convenience. It returns a simple HTML header for you. You can pass parameters to it by using a hash, like this:

    print $cgi->start_html( -title => "My document" );

(The `end_html()` method is similar, but outputs the footers for your page.)

Finally, the most important CGI function is `param()`. Call it with the name of a form item, and a list of all the values of that form item will be returned. (If you ask for a scalar, you'll only get the first value, no matter how many there are in the list.)

    $yourname = param("firstname");
    print "<P>Hi, $yourname!</P>\n";

If you call `param()` without giving it the name of a form item, it will return a list of *all* the form items that are available. This form of `param()` is the core of our backatcha script:

    for $i (param()) {
        print "<b>$i</b>: ", param($i), "<br>\n";
    }

Remember, a single form item can have more than one value. You might encounter code like this on the Web site of a pizza place that takes orders over the Web:

        <P>Pick your toppings!<BR>
           <INPUT TYPE=checkbox NAME=top VALUE=pepperoni> Pepperoni <BR>
           <INPUT TYPE=checkbox NAME=top VALUE=mushrooms> Mushrooms <BR>
           <INPUT TYPE=checkbox NAME=top VALUE=ham> Ham <BR>
        </P>

Someone who wants all three toppings would submit a form where the form item `top` has three values: "pepperoni," "mushrooms" and "ham." The server-side code might include this:

        print "<P>You asked for the following pizza toppings: ";
        @top = param("top");
        for $i (@top) {
            print $i, ". ";
        }
        print "</P>";

Now, here's something to watch out for. Take another look at the pizza-topping HTML code. Try pasting that little fragment into the backatcha form, just above the `<INPUT TYPE=submit...>` tag. Enter a favorite color, and check all three toppings. You'll see this:

        favcolor: burnt sienna
        top: pepperonimushroomsham

Why did this happens? When you call `param('name')`, you get back a *list* of all of the values for that form item. This could be considered a bug in the `backatcha.cgi` script, but it's easily fixed - use `join()` to separate the item values:

        print "<b>$i</b>: ", join(', ', param($i)), "<br>\n";

or call C&lt;param()&gt; in a scalar context first to get only the first value:

        $j = param($i);
        print "<b>$i</b>: $j
    \n";

Always keep in mind that form items can have more than one value!

### <span id="second_script">Our Second Script</span>

So now we know how to build a CGI program, and we've seen a simple example. Let's write something useful. In the last article, we wrote a pretty good HTTP log analyzer. Why not Web-enable it? This will allow you to look at your usage figures from anywhere you can get to a browser.

[Download the source code for the HTTP log analyzer](/media/_pub_2000_12_begperl4/httpreport.pl)

First, let's decide what we want to do with our analyzer. Instead of showing all of the reports we generate at once, we'll show only those the user selects. Second, we'll let the user choose whether each report shows the entire list of items, or the top 10, 20 or 50 sorted by access count.

We'll use a form such as this for our user interface:

        <FORM ACTION="/cgi-bin/http-report.pl" METHOD=POST>
            <P>Select the reports you want to see:</P>

     <P><INPUT TYPE=checkbox NAME=report VALUE=url>URLs requested<BR>
        <INPUT TYPE=checkbox NAME=report VALUE=status>Status codes<BR>
        <INPUT TYPE=checkbox NAME=report VALUE=hour>Requests by hour<BR>
        <INPUT TYPE=checkbox NAME=report VALUE=type>File types
     </P>

     <P><SELECT NAME="number">
         <OPTION VALUE="ALL">Show all
         <OPTION VALUE="10">Show top 10
         <OPTION VALUE="20">Show top 20
         <OPTION VALUE="50">Show top 50
     </SELECT></P>

     <INPUT TYPE=submit VALUE="Show report">
        </FORM>

(Remember that you may need to change the URL!)

We're sending two different types of form item in this HTML page. One is a series of checkbox widgets, which set values for the form item `report`. The other is a single drop-down list which will assign a single value to `number`: either ALL, 10, 20 or 50.

Take a look at the original HTTP log analyzer. We'll start with two simple changes. First, the original program gets the filename of the usage log from a command-line argument:

          # We will use a command line argument to determine the log filename.
          $logfile = $ARGV[0];

We obviously can't do that now, since the Web server won't allow us to enter a command line for our CGI program! Instead, we'll hard-code the value of `$logfile`. I'll use "/var/log/httpd/access\_log" as a sample value.

          $logfile = "/var/log/httpd/access_log";

Second, we must make sure that we output all the necessary headers to our Web server before we print anything else:

          print header();
          print start_html( -title => "HTTP Log report" );

Now look at the `report()` sub from our original program. It has one problem, relative to our new goals: It outputs all the reports instead of only the ones we've selected. We'll rewrite `report()` so that it will cycle through all the values of the `report` form item and show the appropriate report for each.

     sub report {
        for $i (param('report')) {
     if ($i eq 'url') {
         report_section("URL requests", %url_requests);
     } elsif ($i eq 'status') {
         report_section("Status code requests", %status_requests);
     } elsif ($i eq 'hour') {
         report_section("Requests by hour", %hour_requests);
     } elsif ($i eq 'type') {
         report_section("Requests by file type", %type_requests);
     }
        }
     }

Finally, we rewrite the `report_section()` sub to output HTML instead of plain text. (We'll discuss the new way we're using `sort` in a moment.)

        sub report_section {
     my ($header, %type) = @_;
     my (@type_keys);

     # Are we sorting by the KEY, or by the NUMBER of accesses?
     if (param('number') ne 'ALL') {
         @type_keys = sort { $type{$b} <=> $type{$a}; } keys %type;

         # Chop the list if we have too many results
         if ($#type_keys > param('number') - 1) {
             $#type_keys = param('number') - 1;
         }
     } else {
         @type_keys = sort keys %type;
     }

     # Begin a HTML table
     print "<TABLE>\n";

     # Print a table row containing a header for the table
     print "<TR><TH COLSPAN=2>", $header, "</TH></TR>\n";

     # Print a table row containing each item and its value
     for $i (@type_keys) {
         print "<TR><TD>", $i, "</TD><TD>", $type{$i}, "</TD></TR>\n";
     }

     # Finish the table
     print "</TABLE>\n";
        }

### <span id="sorting">Sorting</span>

Perl allows you to sort lists with the `sort` keyword. By default, the sort will happen alphanumerically: numbers before letters, uppercase before lowercase. This is sufficient 99 percent of the time. The other 1 percent of the time, you can write a custom sorting routine for Perl to use.

This sorting routine is just like a small sub. In it, you compare two special variables, `$a` and `$b`, and return one of three values depending on how you want them to show up in the list. Returning -1 means "`$a` should come before `$b` in the sorted list," 1 means "`$b` should come before `$a` in the sorted list" and 0 means "they're equal, so I don't care which comes first." Perl will run this routine to compare each pair of items in your list and produce the sorted result.

For example, if you have a hash called `%type`, here's how you might sort its keys in descending order of their *values* in the hash.

        sort {
            if ($type{$b} > $type{$a}) { return 1; }
     if ($type{$b} < $type{$a}) { return -1; }
     return 0;
        } keys %type;

In fact, numeric sorting happens so often, Perl gives you a convenient shorthand for it: the &lt;=&gt; operator. This operator will perform the above comparison between two values for you and return the appropriate value. That means we can rewrite that test as:

        sort { $type{$b} <=> $type{$a}; } keys %type

(And this, in fact, is what we use in our log analyzer.)

You can also compare strings with `sort`. The `lt` and `gt` operators are the string equivalents of `<` and `>`, and `cmp` will perform the same test as `<=>`. (Remember, string comparisons will sort numbers before letters and uppercase before lowercase.)

For example, you have a list of names and phone numbers in the format "John Doe 555-1212." You want to sort this list by the person's last name, and sort by first name when the last names are the same. This is a job made for `cmp`!

         @sorted = sort {
             ($c) = ($a =~ / (\w+)/);
      ($d) = ($b =~ / (\w+)/);
      if ($c eq $d) {   # Last names are the same, sort on first name
          ($c) = ($a =~ /^(\w+)/);
          ($d) = ($b =~ /^(\w+)/);
          return $c cmp $d;
      } else {
          return $c cmp $d;
      }
         } @phone_numbers;
         for $i (@sorted) { print $i, "\n"; }

### <span id="trust">Trust No One</span>

Now that we know how CGI programs can do what you want, let's make sure they won't do what you *don't* want. This is harder than it looks, because you can't trust anyone to do what you expect.

Here's a simple example: You want to make sure the HTTP log analyzer will never show more than 50 items per report, because it takes too long to send larger reports to the user. The easy thing to do would be to eliminate the "ALL" line from our HTML form, so that the only remaining options are 10, 20 and 50. It would be very easy - and wrong.

[Download the source code for the HTTP analyzer with security enhancements](/media/_pub_2000_12_begperl4/httpsecured.pl).

We saw that you can modify HTML forms when we pasted the pizza-topping sample code into our backatcha page. You can also use the URL to pass form items to a script - try going to `http://www.perl.com/2000/12/backatcha.cgi?itemsource=URL&typedby=you` in your browser. Obviously, if someone can do this with the backatcha script, they can also do it with your log analyzer and stick any value for `number` in that they want: "ALL" or "25000", or "four score and seven years ago."

Your form doesn't allow this, you say. Who cares? People will write custom HTML forms to exploit weaknesses in your programs, or will just pass bad form items to your script directly. You cannot trust anything users or their browsers tell you.

You eliminate these problems by knowing what you expect from the user, and *disallowing* everything else. Whatever you do not expressly permit is totally forbidden. Secure CGI programs consider everything guilty until it is *made* innocent.

For example, we want to limit the size of reports from our HTTP log analyzer. We decide that means the `number` form item must have a value that is between 10 and 50. We'll verify it like this:

        # Make sure that the "number" form item has a reasonable value
        ($number) = (param('number') =~ /(\d+)/);
        if ($number < 10) {
            $number = 10;
        } elsif ($number > 50) {
            $number = 50;
        }

Of course, we also have to change the `report_section()` sub so it uses the `$number` variable. Now, whether your user tries to tell your log analyzer that the value of `number` is "10," "200," "432023," "ALL" or "redrum," your program will restrict it to a reasonable value.

We don't need to do anything with `report`, because we only act when one of its values is something we expected. If the user tries to enter something other than our expressly permitted values ("url," "status," "hour" or "type"), we just ignore it.

Use this sort of logic everywhere you know what the user *should* enter. You might use `s/\D//g` to remove non-numeric characters from items that should be numbers (and then test to make sure what's left is within your range of allowable numbers!), or `/^\w+$/` to make sure that the user entered a single word.

All of this has two significant benefits. First, you simplify your error-handling code, because you make sure as early in your program as possible that you're working with valid data. Second, you increase security by reducing the number of "impossible" values that might help an attacker compromise your system or mess with other users of your Web server.

Don't just take my word for it, though. The [CGI Security FAQ](http://www.w3.org/Security/Faq/) has more information about safe CGI programming in Perl than you ever thought could possibly exist, including a section listing some [security holes](http://www.w3.org/Security/Faq/wwwsf4.html#Q35) in real CGI programs.

### <span id="play_around">Play Around!</span>

You should now know enough about CGI programming to write a useful Web application. (Oh, and you learned a little bit more about sorting and comparison.)

1.  Write the quintessential CGI program: a guestbook. Users enter their name, e-mail address and a short message, which is appended to an HTML file for all to see.

    Be careful! Never trust the user! A good beginning precaution is to *disallow all HTML* by either removing &lt; and &gt; characters from all of the user's information or replacing them with the `<` and `>` character entities.

    Use `substr()`, too, to cut anything the user enters down to a reasonable size. Asking for a "short" message will do nothing to prevent the user dumping a 500k file into the message field!

2.  Write a program that plays tic-tac-toe against the user. Be sure that the computer AI is in a sub so it can be easily upgraded. (You'll probably need to study HTML a bit to see how to output the tic-tac-toe board.)

