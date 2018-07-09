{
   "description" : " Programmers have long recognized that separating code logic from presentation is good. The Perl community has produced many fine systems for doing just this. While there are many systems, they largely fall within two execution models, pipeline and callback...",
   "slug" : "/pub/2008/03/14/reverse-callback-templating.html",
   "draft" : null,
   "authors" : [
      "james-robson"
   ],
   "tags" : [
      "mvc",
      "presentation",
      "template-recall",
      "templating",
      "text-tools"
   ],
   "thumbnail" : null,
   "date" : "2008-03-14T00:00:00-08:00",
   "categories" : "tooling",
   "title" : "Reverse Callback Templating",
   "image" : null
}



Programmers have long recognized that separating code logic from presentation is good. The Perl community has produced many fine systems for doing just this. While there are many systems, they largely fall within two execution models, *pipeline* and *callback* (as noted by Perrin Harkins in [Choosing a Templating System](/pub/2001/08/21/templating.html)). [HTML::Template](https://metacpan.org/pod/HTML::Template) and [Template Toolkit](http://www.template-toolkit.org/) are in the pipeline category. Their templates consist of simple presentation logic in the form of loops and conditionals and template variables. The Perl program does its work, then loads and renders the appropriate template, as if data were flowing through a pipeline. [Mason](http://www.masonhq.com/) and [Embperl](http://perl.apache.org/embperl/) fall into the callback category. They mix code in with the template markup, and the template "calls back" to Perl when it encounters program logic.

A third execution model exists: the *reverse callback* model. Template and code files are separate, just like in the pipeline approach. Instead of using a mini-language to handle display logic, however, the template consists of named sections. Perl executes and calls a specific section of the template at the appropriate time, rendering it. Effectively, this is the opposite of the callback method, which wraps Perl logic around portions (or sections) of a template in a single file. Reverse callback uses Perl statements to load, or call, specific portions of the the template. This approach has a few distinct advantages.

### A Reverse Callback Example

Suppose that you have a simple data structure you are dying to output as pretty HTML.

    my @goods = (
        "oxfords,Brown leather,\$85,0",
        "hiking,All sizes,\$55,7",
        "tennis shoes,Women's sizes,\$35,15",
        "flip flops,Colors of the rainbow,\$7,90"
        );

First, you need an HTML template with the appropriate sections defined. Sections are of vital importance; they enable `Template::Recall` to keep the logic squarely in the code. `Template::Recall` uses the default pattern `/[\s*=+\s*\w+\s*=+\s*]/` (to match, for example, `[==== section_name ====]`) to determine sections in a single file. The start of one section denotes the end of another. This is because `Template::Recall` uses a `split()` operation based on the above regex, saving the `\w+` as the section key in an internal data structure.

    [ =================== header ===================]

    <html>
    <head>
        <title>my site - [' title ']</title>
    </head>
    <body>

    <h4>The date is [' date ']</h4>



    <table border="1">

        <tr>
            <th>Shoe</th>
            <th>Details</th>
            <th>Price</th>
            <th>Quantity</th>
        </tr>

    [ =================== product_row =================== ]
        <tr>
            <td>[' shoe ']</td>
            <td>[' details ']</td>
            <td>[' price ']</td>
            <td>[' quantity ']</td>
        </tr>


    [= footer =]
    </table>

    </body>
    </html>

This template is quite simple. It has three sections, a "header," "product\_row," and "footer." The sections essentially give away how the program logic is going to work. A driver program would call header and footer only once during program execution (start and end, respectively). product\_row will be called multiple times during iteration over an array.

Names contained within the delimeters `['` and `']` are template variables for replacement during rendering. For example, `[' date ']` will be replaced by the current date when the program executes.

The driver code must first instantiate a new Template::Recall object, `$tr`, and pass it the path of the template, which I've saved as the file *template1.html*.

    use Template::Recall;

    my $tr = Template::Recall->new( template_path => 'template1.html');

With `$tr` created, the template sections are loaded and ready for use. The obvious first step is to render the header section with the `render()` method. `render()` takes the name of the section to process, and optionally, a hash of names and values to replace in that section. There are two template variables in the header section, `[' title ']` and `[' date ']`, so the call looks like:

    print $tr->render( 'header', { title => 'MyStore', date => scalar(localtime) } );

The names used in the hash must match the names of the template variables in the section you intend to render. For example, `date => scalar(localtime)` means that `[' date ']` in the header section will be dynamically replaced by the value produced by `scalar(localtime)`.

You probably noticed from the template that the header section created the start of an HTML table. This is a fine time to render `@goods` as the table's rows.

    for my $good (@goods)
    {
        my @attr     = split(/,/, $good);
        my $quantity = $attr[3] eq '0' ? 'Out of stock' : $attr[3];

        my %row      = (
            shoe     => $attr[0],
            details  => $attr[1],
            price    => $attr[2],
            quantity => $quantity,
        );

        print $tr->render('product_row', \%row);
    }

In actual code, this array would likely come from a database. For each row, the driver makes necessary logical decisions (such as displaying "Out of stock" if the quantity equals "0"), then calls `$tr->render()` to replace the placeholders in the template section with the values from `%row`.

Finally, the driver renders the footer of the HTML output. There are no template variables to replace, so there's no need to pass in a hash.

    print $tr->render('footer');

The result is this nice little output of footwear inventory:

#### The date is Fri Aug 10 14:22:30 2007

| Shoe         | Details               | Price | Quantity     |
|--------------|-----------------------|-------|--------------|
| oxfords      | Brown leather         | $85   | Out of stock |
| hiking       | All sizes             | $55   | 7            |
| tennis shoes | Women's sizes         | $35   | 15           |
| flip flops   | Colors of the rainbow | $7    | 90           |

### The Logic Is in the Code

What happens if you extend your shoe data slightly, to add categories? For instance, what if `@goods` looks like:

    my @goods = (
        "dress,oxfords,Brown leather,\$85,0",
        "sports,hiking,All sizes,\$55,7",
        "sports,tennis shoes,Women's sizes,\$35,15",
        "recreation,flip flops,Colors of the rainbow,\$7,90"
        );

The output now needs grouping, which implies the use of nested loops. One loop can output the category header -- sports, dress, or recreation shoes -- and another will output the details of each shoe in that category.

To handle this in HTML::Template, you would generally build a nested data structure of anonymous arrays and hashes, and then process it against nested `<TMPL_LOOP>` directives in the template. Template::Recall logic remains in the code, you would build a nested loop structure in Perl that calls the appropriate sections. You can also use a hash to render the category sections as keys and detail sections as values in a single pass, and output them together using `join`.

The template needs some modification:

    [====== table_start ====]
    <table border="1">
    [====== category =======]
    <tr><td colspan="4"><b>['category']</b></td></tr>
    [====== detail ======]
    <tr><td>['shoe']</td><td>['detail']</td><td>['price']</td><td>['quantity']</td></tr>
    [======= table_end ====]
    </table>

This template now has a section called "category," a single table row that spans all columns. The "detail" section is pretty much the same as in the previous.

    my %inventory;

    for my $good (@goods) {
        my @attr = split(/,/, $good);
        my $q    = $attr[4] == 0 ? 'Out of stock' : $attr[4];

        $inventory{ $tr->render('category', { category => $attr[0] } ) } .=
            $tr->render('detail',
                {
                    shoe     => $attr[1],
                    detail   => $attr[2],
                    price    => $attr[3],
                    quantity => $q,
                } );
    }

    print $tr->render('table_start') .
        join('', %inventory) .
        $tr->render('table_end');

This loop looks surprisingly similar to the first example, doesn't it? That's because it is. Instead of printing each row, however, this code renders the first column in `@goods` against the category template section, and then storing the output as a key in `%inventory`. In the same iteration, it renders the remaining columns against the detail section and appends to the value of that key.

After storing the rendered sections in this way to `%inventory`, the code prints everything with a single statement, using `join` to print all the values in `%inventory`, including keys. The output is:

|                |
|----------------|
| **recreation** |
| flip flops     |
| **sports**     |
| hiking         |
| tennis shoes   |
| **dress**      |
| oxfords        |

The code also handles conditional output. Suppose that at your growing online shoe emporium you provide special deals to customers who have bought over a certain dollar amount. As they browse your shoe inventory, these deals appear.

    if ( $customer->is_elite ) {
        print $tr->render('special_deals', get_deals('elite') );
    }
    else {
        print $tr->render('standard_deals', get_deals() );
    }

What about producing XML output? This usually requires a separate template? You can conditionally load a *.xml* or *.html* template:

    my $tr;
    if ( $q->param('fmt') eq 'xml' ) {
        $tr = Template::Recall->new( template_path => 'inventory.xml' );
    }
    else {
        $tr = Template::Recall->new( template_path => 'inventory.html' );
    }

Perl provides everything you need to handle model, controller, *and* view logic. Template::Recall capitalizes on this and helps to make projects code driven.

### Template Model Comparison

It's important to note a few things that occurred in these examples -- or failed to occur, rather. First, there's no mixture of code and template markup. All template access occurs through the method call `$tr->render()`. This is strong separation of concerns (SOC), just like the pipeline model, and unlike the callback model, which mixes template markup and code in the same file. Not only does strong SOC provide good code organization, it also keeps designers from having to sift through code to change markup. Consider using Mason to output the rows of `@goods`.

    % for my $good (@goods) {
    %  my @attr     = split(/,/, $good);
    %  my $quantity = $attr[3] eq '0' ? 'Out of stock' : $attr[3];
    <tr>
    <td><% $attr[0] %></td>
    <td><% $attr[1] %></td>
    <td><% $attr[2] %></td>
    <td><% $quantity %></td>
    </tr>
    % }

This is an efficient approach, and easy enough for a programmer to walk through. It becomes difficult to maintain though, when designers are involved, if for no other reason than because a designer and a programmer need to access the same file to do their respective work. Design changes and code changes will not always share the same schedule because they belong to different domains. It also means that in order to switch templates, say to output XML or text (or both), you have to add more and more conditionals and templates to the code, making it increasingly difficult to read.

The other thing that did not occur in this example is the leaking of any kind of logic (presentation or otherwise) into the template. Consider that HTML::Template would have to insert the `<TMPL_LOOP>` statement in the template in order to output the rows of `@goods`.

        <TMPL_LOOP NAME="PRODUCT">
        <tr>
        <td><TMPL_VAR NAME=SHOE></td>
        <td><TMPL_VAR NAME=DETAILS></td>
        <td><TMPL_VAR NAME=PRICE></td>
        <td><TMPL_VAR NAME=QUANTITY></td>
        </tr>
        </TMPL_LOOP>

That's not a big deal, really. If you care about line count, this only requires one extra line over the Template::Recall version, and that's the the closing tag `</TMPL_LOOP>`. Nonetheless, the template now states some of the logic for the application. Sure, it's only presentation logic, but it's logic nonetheless. HTML::Template also provides `<TMPL_IF>` for displaying items conditionally, and `<TMPL_INCLUDE>` for including other templates. Again, this is logic contained in the template files.

Template::Recall keeps as much logic as possible in the code. If you need to display something conditionally, use Perl's `if` statement. If you need to include other templates, load them using a Template::Recall object. Whereas the pipeline models likely work better for projects with a fairly sophisticated design team, Template::Recall tries to be the programmer's friend and let him or her steer from the most comfortable place, the code.

There is also a subtle cost to using the pipeline model for a simple loop like that above. Consider this HTML::Template footwear data code:

    my $template = HTML::Template->new(filename => template1.tmpl');

    my @output;

    for my $good (@goods)
    {
        my @attr = split(/,/, $_);
        my %row  = (
            SHOE     => $attr[0],
            DETAILS  => $attr[1],
            PRICE    => $attr[2],
            QUANTITY => $attr[3],
        );
        push( @output, \%row );
    }

    $template->param(PRODUCT => \@output);

    print $template->output();

The code iterates over `@goods` and builds a second array, `@output`, with the rows as hash references. Then the template iterates over `@output` within `<TMPL_LOOP>`. That's walking over the same data twice. Template sections do not suffer this cost, because you can output the data immediately, as you get it:

    print $tr->render('product_row', \%row);

This is essentially what happens with Mason (or JSP/PHP/ASP for that matter). The main difference is that Template::Recall renders the section through a method call rather than mixing code and template.

Template::Recall, by using sectioned templates, combines the efficiency of the callback model with the strong, clean separation of concerns inherent in the pipeline model, and perhaps gets the best of both worlds.
