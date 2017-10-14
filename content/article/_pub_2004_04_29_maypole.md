{
   "draft" : null,
   "slug" : "/pub/2004/04/29/maypole.html",
   "date" : "2004-04-29T00:00:00-08:00",
   "title" : "Rapid Web Application Deployment with Maypole : Part 2",
   "categories" : "web",
   "tags" : [
      "maypole",
      "mvc"
   ],
   "image" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " When we last left our intrepid web developer, he had successfully set up an online sales catalogue in 11 lines of code. Now, however, he has to move on to turning this into a sales site with a shopping...",
   "thumbnail" : "/images/_pub_2004_04_29_maypole/111-test_libs.gif"
}





When we [last](/pub/a/2004/04/15/maypole.html) left our intrepid web
developer, he had successfully set up an online sales catalogue in 11
lines of code. Now, however, he has to move on to turning this into a
sales site with a shopping cart and all the usual trimmings. It's time
to see some of that flexibility we talked about last week; unfortunately
this means we're going to have to write some more code, but we can't
have everything.

### [Who Am I?]{#Who_Am_I?}

In order to add the shopping cart to the site, we need to introduce the
concept of a current user. This will allow viewers of the site to log in
and have their own cart. We will be adding two new tables to the
database, a table to store details about the user, and one to represent
the cart. Our tables will look like so:

      CREATE TABLE user (
        id int not null auto_increment primary key,
        first_name varchar(64),
        last_name varchar(64),
        email varchar(255),
        password varchar(64),
        address1 varchar(255),
        address2 varchar(255),
        state varchar(255),
        postal_code varchar(64),
        country varchar(64)
      );
      
      CREATE TABLE cart_item (
        id int not null auto_increment primary key,
        user int,
        item int
      );

As before, Maypole automatically creates classes for the tables. We use
`Class::DBI` relationships to tell Maypole what's going on with these
tables:

      ISellIt::User->has_many( "cart_items" => "ISellIt::BasketItem");
      ISellIt::BasketItem->has_a( "user" => "ISellit::User" );
      ISellIt::BasketItem->has_a( "item" => "ISellit::Product" );

We now need a way to tell our application about the current user.
There's a long explanation of Maypole's authentication system in the
[Maypole
documentation](http://maypole.simon-cozens.org/doc/authentication.html),
but one of the easiest ways to do add the concept of the current user is
with the `Maypole::Authentication::UserSessionCookie` module.

As its name implies, this module takes care of associating a user with a
session, and issuing a cookie to the user's browser. It also manages
validating the user's login credentials, by default by looking up the
user name and password in a database table; precisely what we need!

Maypole provides an authentication method for us to override, and it's
here that we're going to intercept any request that requires a user --
viewing the shopping cart, adding items to an order, and so on:

      sub authenticate {
        my ($self, $r) = @_;
        unless ($r->{table} eq "cart" or $r->{action} eq "buy") {
          return OK;
        }

        # Else we need a user
        $r->get_user;
        if (!$r->{user}) {
          $r->template("login");
        }
        return OK;
       }

The `get_user` method, which does all the work of setting the cookie and
setting the credentials, is provided by the `UserSessionCookie` module.
The only thing we need to tell it is that we're going to use the user's
email address and password as login credentials, rather than some
arbitrary user name. We can do this in the configuration for our
application, as described in the `UserSessionCookie` documentation:

      ISellIt->{config}->{auth}->{user_field} = "email";

Next, we set up a login template, which will present the users with a
form to enter their credentials; there's one in the Maypole manual, in
the [Request chapter](http://maypole.simon-cozens.org/doc/Request.html),
which we can modify to suit our needs:

      [% INCLUDE header %]

        <h2> You need to log in before buying anything </h2>

      <DIV class="login">
      [% IF login_error %]
         <FONT COLOR="#FF0000"> [% login_error %] </FONT>
      [% END %]
        <FORM ACTION="/[% request.path%]" METHOD="post">
      Email Address:
        <INPUT TYPE="text" NAME="email"> <BR>
      Password: <INPUT TYPE="password" NAME="password"> <BR>
      <INPUT TYPE="submit">
      </FORM>
      </DIV>

And now logging in is sorted out; if a user presents the correct
credentials, `get_user` will put the user's `ISellIt::User` object in
the Maypole request object as `$r->{user}`, and the user's request will
continue to where it was going.

Now, of course, since we have a user object we can play with, we can use
the user's information in other contexts:

      [% IF request.user %]
        <DIV class="messages">
        Welcome back, [% request.user.first_name %]!
        </DIV>
      [% END %]

Since we're going to be referring to the user a lot, we pass it to the
template as an additional argument, `my`. Maypole has an open-ended
"hook" method, `additional_data`, which is perfect for doing just this.

      sub additional_data {
        my $r = shift;
        $r->{template_args}{my} = $r->{user};
      }

We call it `my` so that we can say, for instance:

        <DIV class="messages">
        Welcome back, [% my.first_name %]!
        </DIV>

So now we have a user. We can add a new action, `order`, to add an item
to the user's shopping cart:

      package ISellIt::Product;

      sub order :Exported {
        my ($self, $r, $product) = @_;
        $r->{user}->add_to_cart_items({ item => $product });
        $r->{template} = "view";
      }

This adds an entry in the `cart_item` table associating the item with
the user, and then sends us back to viewing the item.

We've sent our user back shopping without an indication that we actually
did add an item to his shopping cart; we can give such an indication by
passing information into the template:

      sub order :Exported {
        my ($self, $r, $product) = @_;
        $r->{user}->add_to_cart_items({ item => $product });
        $r->{template} = "view";
        $r->{template_args}{bought} = 1;
      }

And then displaying it:

      [% IF bought %]
      <DIV class="messages">
        We've just added this item to your shopping cart. To complete
        your transaction, please <A HREF="/user/view_cart">view your
        cart</A> and check out.
      </DIV>
      [% END %]

So now we need to allow the user to view a cart.

### [Displaying the Cart]{#Displaying_the_Cart}

This also turns out to be relatively easy -- most things in Maypole are
-- involving an action on the user class. We need to fill our Maypole
request object with the items in the user's cart:

      package ISellIt::User;

      sub view_cart :Exported {
        my ($self, $r) = @_;
        $r->{objects} = [ $r->{user}->cart_items ];
      }

And then we need to produce a *user/view\_cart* template that displays
them:

      [% PROCESS header %]

      <h2> Your Shopping Cart </h2>

      <TABLE>
      <TR> <TH> Product </TH> <TH> Price </TH> </TR>
      [% SET count = 0;
      FOR item = objects;
        SET count = count + 1;
        "<tr";
        ' class="alternate"' IF count % 2;
        ">";
      %]
        <TD> [% item.product.name %] </TD>
        <TD> [% item.product.price %] </TD>
        <TD> 
          <FORM ACTION="/cart_item/delete/[% item.id %]">
          <INPUT TYPE="submit" VALUE="Remove from cart">
          </FORM>
        </TD>
      </tr>
      [% END %]
      </TABLE>

      <A HREF="/user/checkout"> Check out! </A>

Once again, the HTML isn't great, but it gives us something we can pass
to the design people to style up nicely. Now on to checking out the
cart...

### [Check Out]{#Check_out}

The hardest part about building an e-commerce application is interacting
with the payment and credit-card fulfillment service. We'll use the
[`Business::OnlinePayment`](http://search.cpan.org/perldoc?Business::OnlinePayment)
module to handle that side of things, and handle the order fulfillment
by simply sending an email.

The actual check-out page needs to collect credit card and delivery
information, and so it doesn't actually need any objects; the only
object we actually need is the `ISellIt::User`, and that was stashed
away in the request object by the authentication routine. However, we do
want to display the total cost. So to make things easier we'll add an
action and compute this in Perl. We make the total cost a method on the
user, so we can use this later:

      package ISellIt::User;
      use List::Util qw(sum);
      sub basket_cost {
        my $self = shift;
        sum map { $_->item->price }
        $self->basket_items
      }

And define `checkout` to add this total to our template:

      sub checkout :Exported {
        my ($self, $r) = @_;
        $r->{template_args}{total_cost} = $r->{user}->basket_cost;
      }

Now we write our *user/checkout* template:

      [% PROCESS header %]
      <h2> Check out </h2>

      <p> Please enter your credit card and delivery details. </p>

      <form method="post" action="https://www.isellit.com/user/do_checkout">
        <P>
        First name: <input name="first_name" value="[% my.first_name %]"><BR>
        Last name: <input name="last_name" value="[% my.last_name %]"></P>
        <P>
        Street address: <input name="address" value="[% my.address1 %]"><BR>
        City: <input name="city" value="[% my.address2 %]"><BR>
        State: <input name="state" value="[% my.state %]">
        Zip: <input name="zip" value="[% my.postal_code %]">
        </P>

        <P>
        Card type: <select name="type">
          <option>Visa</option>
          <option>Mastercard</option>
          ...
        </select>

        Card number: <input name="card_number"> 
        Expiration: <input name="expiration"> <BR>
        Total: $ [% total_price %]
        </P>
        <P>
        Please click <B>once</B> and wait for the payment to be
        authorised.... <input type="submit" value="order">
      </form>

What happens when this data is sent to the `do_checkout` action? (Over
SSL, you'll notice.) First of all, we'll check if the user has entered
address details for the first time, and if so, store them in the
database. Perhaps unnecessary in this day of browsers that auto-fill
forms, but it's still a convenience. Maypole stores the POST'ed in
parameters in `params`:

      sub do_checkout :Exported {
        my ($self, $r) = @_;
        my %params = %{$r->{params}};
        my $user = $r->{user};

        $user->address1($params{address}) unless $user->address1;
        $user->address2($params{city})  unless $user->address2;
        $user->state($params{state})    unless $user->state;
        $user->postal_code($params{zip})  unless $user->postal_code;

We need to construct a request to go out via `Business::OnlinePayment`;
thankfully, the form parameters we've received are going to be precisely
in the format that `OnlinePayment` wants, thanks to careful form design.
All we need to do is to insert our account details and the total:

        my $tx = new Business::OnlinePayment("TCLink");
        $tx->content(%params,
          type   => "cc",
          login  => VENDOR_LOGIN,
          password => VENDOR_PASSWORD,
          action   => 'Normal Authorization'
          amount   => $r->{user}->basket_total
        );

Now we can submit the payment and see what happens. If there's a
problem, we add a message to the template and send the user back again:

        $tx->submit;
        if (!$tx->is_success) {
          $r->{template_args}{message} = 
            "There was a problem authorizing your transaction: ".
            $tx->error_message;
          $r->{template} = "checkout";
          return;
        }

Otherwise, we have our money; we probably want to tell the box-shifters
about it, or we lose customers fast:

        fulfill_order(
          address_details => $r->{params},
          order_details   => [ map { $_->item } $r->{user}->cart_items ],
          cc_auth     => $tx->authorization
        );

And now we empty the shopping cart, and send the user on his way:

        $_->delete for $r->{user}->cart_items;
        $r->{template} = "frontpage";
      }

Done! We've taken a user from logging in, adding goods to the cart,
credit card validation, and checkout. But... wait. How did we get our
user in the first place?

### [Registering a User]{#Registering_a_User}

We have to find a way to sign a user up. This is actually not that hard,
particularly since we can use the example of
[Flox](http://search.cpan.org/~simon/Maypole/doc/Flox.pod) in the
Maypole manual. First, we'll add a "register" link to our login
template:

      <P>New user? <A HREF="/user/register">Sign up!</A></P>

This page doesn't require any objects to be loaded up, since it's just
going to display a registration form; we can just add our template in
*/user/register*:

      [% INCLUDE header %]
      <P>Welcome to buying with iSellIt!</P>

      <P>To set up your account, we only need a few details from you:
      </P>

      <FORM METHOD="POST" ACTION="/user/do_register">
        <P>Your name:
        <input name="first_name"> 
        <input name="last_name"> </P>
        <P>Your email address: <input name="email"> </P>
        <P>Please choose a password: <input name="password"> </P>
        <input type="submit" name="Register" value="Register">
      </FORM>

As before, we need to explain to
[`Class::DBI::FromCGI`](http://search.cpan.org/perldoc?Class::DBI::FromCGI)
how these fields are to be edited:

      ISellIt::User->untaint_columns(
        printable => [qw/first_name last_name password/],
        email   => [qw/email/],
      );

And now we can write our `do_register` event, using the `FromCGI` style:

      sub do_register :Exported {
        my ($self, $r) = @_;
        my $h = CGI::Untaint->new(%{$r->{params}});
        my $user = $self->create_from_cgi($h);

If there were any problems, we send them back to the register form
again:

        if (my %errors = $obj->cgi_update_errors) {
          $r->{template_args}{cgi_params} = $r->{params};
          $r->{template_args}{errors} = \%errors;
          $r->{template} = "register";
          return;
        }

Otherwise, we now have a user; we need to issue the cookie as if the
user had logged in normally. Again, this is something that
`UserSessionCookie` looks after for us:

        $r->{user} = $user;
        $r->login_user($user->id);

And finally we send the user on his or her way again:

        $r->{template} = "frontpage";
      }

There we go: now we can create new users; provision of a password
reminder function is an exercise for the interested reader.

### [Maypole Summary]{#Maypole_Summary}

We've done it -- we've created an e-commerce store in a very short space
of time and with a minimal amount of code. One of the things that I like
about Maypole is the extent to which you only need to code your business
logic; all of the display templates can be mocked up and then shipped
off to professionals, and the rest of the work is just handled magically
behind the scenes by Maypole.

Thanks to the TPF funding of Maypole, we now have an extensive user
manual with several case studies (this one included), and a lively user
and developer community. I hope you too will be joining it soon!


