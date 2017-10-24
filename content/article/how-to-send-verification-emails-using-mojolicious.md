{
   "authors" : [
      "joel-berger"
   ],
   "description" : "Control access to your Mojo app with registration emails",
   "image" : "/images/193/8BAEFFB8-5E31-11E5-8EC0-4782D27BB60F.png",
   "title" : "How to send verification emails using Mojolicious",
   "slug" : "193/2015/9/18/How-to-send-verification-emails-using-Mojolicious",
   "tags" : [
      "mojo",
      "email",
      "verification",
      "automated"
   ],
   "categories" : "web",
   "date" : "2015-09-18T11:46:46",
   "draft" : false
}


Everyone has signed up for a website which confirms your email address by sending you a verification email. This is a simple process: if you can respond to this email, you must have access to the email address. Yet for its simplicity, writing such a system might not seem as easy.

Let's look at an example. I'm going to use [Mojolicious](http://mojolicio.us) since it is the web framework that I prefer (and contribute to) but also since its ecosystem is suited to this task. If you'd like to follow along as I go, check out the finished [script](https://gist.github.com/jberger/91a853ee223737c1a1d1).

### User Storage

The example application is going to need a persistent mechanism to store user information. A tool I reach for in examples and prototyping is [DBM::Deep](https://metacpan.org/pod/DBM::Deep). It is a file-backed system for storing Perl data structures. To use it, simply create an instance (or `tie` one) and use it as a hash reference (array references are possible too); any changes will be saved automagically!

``` prettyprint
my $db = DBM::Deep->new('filename.db');
```

I'll store this object in a helper, named `users`. In Mojolicious, a helper is a subroutine that can be called as a method on a controller instance or the app itself, or called as a function in a template. They are often used for linkages between application and business or model logic, though here it is providing database access. When the time comes to need access to user data, say from a controller instance `$c`, it is as simple as:

``` prettyprint
my $user = $c->users->{$username};
```

And likewise to create a user, simply assign to it:

``` prettyprint
$c->users->{$username} = {
  email     => $email,
  password  => $c->bcrypt($password),
  confirmed => 0,
};
```

More fields would be stored in a more complete app but this is all that is needed for this example.

### Password encryption

I use an encryption called `bcrypt` to store the password. [Mojolicious::Plugin::Bcrypt](https://metacpan.org/pod/Mojolicious::Plugin::Bcrypt) is a handy plugin to use Bcrypt encryption with Mojolicious; you load it by simply writing `plugin 'Bcrypt';`. This plugin provides two helpers, `bcrypt` for encryption and `bcrypt_validate` for checking that another value is valid.

Bcrypt is one of many hashing algorithms with properties that are useful for security. There is no `decrypt` function, since this is a one-way algorithm. When validating the password, the best you can know is that if some future input hashes to the same result then it must have been the original password. Storing passwords in this way is good because if a hacker gets database access, they don't get the passwords, just the hashes; they can't be leaked because you simply don't have them.

### Sending an email

CPAN is replete with modules which can send email. For this example I employ [Email::Sender](https://metacpan.org/pod/Email::Sender), which is the current recommended module (for [example](http://shadow.cat/blog/matt-s-trout/mstpan-15/)). Written by our reigning Perl Pumpking Ricardo Signes, this module makes it very easy to send email.

The app declares a helper to send an email, cleverly called `send_email` which takes a target email address, a subject, and a body.

A nice feature of Email::Sender is that you can specify [transport via the environment](https://metacpan.org/pod/Email::Sender::Manual::QuickStart#specifying-transport-in-the-environment). For prototyping purposes, by setting an environment variable, the email is "sent" to the terminal. Meanwhile, the Mojolicious [eval](http://mojolicio.us/perldoc/Mojolicious/Command/eval) command is a handy way to perform one-line scripts with your app. If I combine these features together, I can see what the resulting email would look like with a one liner:

``` prettyprint
$ EMAIL_SENDER_TRANSPORT=Print ./app.pl eval 'app->send_email(q[me@spam.org], "Care for some SPAM?", "Well how about it?")'
```

### The email body

Now that the app can send an email, what should it send? Remember that I would like to send an email with a hyperlink that the user can click to confirm their registration. The hyperlink URL needs to be able to identify the transaction, but since it is being sent in clear text it is important to know that the contents haven't been tampered with. A [JSON Web Token](http://jwt.io/), or JWT, lets you store a data structure as a url-safe string and sign it so that you can be sure that it isn't altered.

Since the user won't be logged in, I need some other way to know which username to confirm! In this example the JWT payload is only going to contain the username, sent on a round trip to the client's email.

If instead the app were sending a password reset token I would also want to include a timeout on the JWT to prevent replay attacks. For a simple confirmation though that is probably not necessary.

I create a helper which initializes an instance of [Mojo::JWT](https://metacpan.org/pod/Mojo::JWT) and uses the application's primary [secret](https://metacpan.org/pod/Mojolicious#secrets) as its secret. The JWT can also use some other secret, but this is convenient. Note that the example app uses the default set of secrets, but yours should change it to something only you know.

To create the confirmation URL, the app first sets the claims and encodes to a JWT encoded string containing the data structure.

``` prettyprint
my $jwt = $c->jwt->claims({username => $username})->encode;
```

Then it generates a URL to the "confirm" route, makes it absolute, and appends the query/value pair to the end:

``` prettyprint
my $url = $c->url_for('confirm')->to_abs->query(jwt => $jwt);
```

Later when the URL is clicked, the app can retrieve the username from the JWT encoded query parameter like this:

``` prettyprint
my $username = $c->jwt->decode($c->param('jwt'))->{username};
```

Note that if the JWT (contained in the query parameter) doesn't pass validation on decoding, an exception is thrown; this way you know that if the code succeeds the JWT hasn't been tampered with.

From there it is a simple matter to mark the user's account as confirmed.

### The job queue

Many tasks that happen as a result of a web request can be quite slow. Sending email is often a slow process and I don't want to slow down the server in order to add email functionality. Mojolicious employs a non-blocking ioloop internally for performance and one thing you never want to do is block the loop for long periods of time.

A job queue is a system by which you can push the actual work of doing slow work onto another process. Typically a job queue functions by inserting a record into a database indicating which task is to be done and parameters to be passed to it. The job worker then knows how to perform that task and watches the database until a job needs doing.

Mojolicious has a job queue spinoff project, named [Minion](https://metacpan.org/pod/Minion). It is the perfect tool for sending email from a job worker to keep the site responsive. Minion ships with a Postgres backend but for this example I will be using the SQLite backend from CPAN. *(N.B an earlier version of this article used a file backend that has since been removed).* The task is declared as a subroutine reference to `add_task` and later jobs can be created by `enqueue`.

The app declares a task, called `email_task` which is a wrapper for the `send_email` helper. It also declare a helper named `email`, a nicely Huffmanized name, which enqueues the job (and takes the same arguments). (I've called the task `email_task` to make it clear where that name is used; it could as easily simply have been called `email`, but I didn't want the name to be confused with the helper).

This helper then is all that is needed to send an email via a job worker, well that and a worker. While prototyping, it is handy to start a worker in another terminal by running:

``` prettyprint
$ EMAIL_SENDER_TRANSPORT=Print ./app.pl minion worker
```

Again by setting the transport to `Print`, the result will be output in the terminal. The progress of the job can then be tracked via the `minion` command as well.

``` prettyprint
$ ./myapp.pl minion job
$ ./myapp.pl minion job <<id>>
```

### Putting it all together

The rest of the web application is a fairly standard Mojolicious app. One thing that I employ is a helper that redirects to the landing (index) page and optionally accepts a message to be displayed after redirect. This message is called a "flash" message and is stored in the session cookie, valid only on the next request. Using this helper I can easily start the sign-in/sign-up cycle again and tell the user what happened, good or bad. Because setters in Mojolicious are chainable, the helper is simply:

``` prettyprint
helper to_index => sub { shift->flash(message => shift)->redirect_to('index') };
```

In the template, if the flash message is defined from the previous request, it is used otherwise a default is presented

``` prettyprint
<p><%= flash('message') || 'Sign in or sign up!' %></p>
```

Then if the username is already taken, for example, I can stop processing immediately by:

``` prettyprint
return $c->to_index("Username $username is taken") if $c->users->{$username};
```

Now that you know how the pieces work, check out the final [script](https://gist.github.com/jberger/91a853ee223737c1a1d1), or have a look below. Happy Perling!

``` prettyprint
use Mojolicious::Lite;

use DBM::Deep;
use Mojo::JWT;

plugin 'Bcrypt';
plugin 'Minion' => {SQLite => 'minion.db'};

helper users => sub { state $db = DBM::Deep->new('users.db') };

helper send_email => sub {
  my ($c, $address, $subject, $body) = @_;

  require Email::Simple;
  require Email::Sender::Simple;

  my $email = Email::Simple->create(
    header => [
      To      => $address,
      From    => 'me@nobody.com',
      Subject => $subject,
    ],
    body => $body,
  );
  Email::Sender::Simple->send($email);
};

helper jwt => sub { Mojo::JWT->new(secret => shift->app->secrets->[0] || die) };

app->minion->add_task(email_task => sub { shift->app->send_email(@_) });

helper email => sub { shift->minion->enqueue(email_task => [@_]) };

helper to_index => sub { shift->flash(message => shift)->redirect_to('index') };

any '/' => sub {
  my $c = shift;
  $c->render('logged_in') if $c->session('username');
} => 'index';

any '/logout' => sub { shift->session(expires => 1)->to_index };

post '/sign_in' => sub {
  my $c = shift;
  my $username = $c->param('username');
  return $c->to_index("Username $username not found")
    unless my $user = $c->users->{$username};

  return $c->to_index("Username $username has not been confirmed")
    unless $user->{confirmed};

  return $c->to_index('Password not correct')
    unless $c->bcrypt_validate($c->param('password') || '', $user->{password});

  $c->session(username => $username)->to_index;
};

post '/sign_up' => sub {
  my $c = shift;

  my $username = $c->param('username');
  return $c->to_index("Username $username is taken")
    if $c->users->{$username};

  return $c->to_index('Password cannot be blank')
    unless my $password = $c->param('password');

  return $c->to_index('Email cannot be blank')
    unless my $email = $c->param('email');

  $c->users->{$username} = {
    email     => $email,
    password  => $c->bcrypt($password),
    confirmed => 0,
  };
  my $jwt = $c->jwt->claims({username => $username})->encode;
  my $url = $c->url_for('confirm')->to_abs->query(jwt => $jwt);
  $c->email($email, 'Confirm registration', "Please visit $url to confirm");
  $c->to_index('registration complete, please confirm via email');
};

get '/confirm' => sub {
  my $c = shift;
  my $username = $c->jwt->decode($c->param('jwt'))->{username};
  $c->users->{$username}{confirmed} = 1;
  $c->to_index('registration confirmed, please log in');
};

app->start;

__DATA__

@@ index.html.ep

<p>Hello Guest!</p>
<p><%= flash('message') || 'Sign in or sign up!' %></p>

%= form_for sign_in => begin
  %= label_for username => 'Username'
  %= text_field 'username'

  %= label_for password => 'Password'
  %= password_field 'password'

  %= label_for email => 'Email'
  %= email_field 'email', placeholder => 'sign up only'

  <br>
  %= submit_button 'Sign In'
  %= submit_button 'Sign Up', formaction => url_for('sign_up')
% end

@@ logged_in.html.ep

<p>Welcome back <%= session 'username' %>!</p>
<p><%= link_to 'Log out' => 'logout' %></p>
```

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
