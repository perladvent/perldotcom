{
   "categories" : "security",
   "authors" : [
      "david-farrell"
   ],
   "title" : "Is your login page secure?",
   "date" : "2014-04-28T03:14:13",
   "description" : "A bumper article on secure web application logins with Catalyst",
   "image" : "/images/84/ECC1012E-FF2E-11E3-B566-5C05A68B9E16.jpeg",
   "slug" : "84/2014/4/28/Is-your-login-page-secure-",
   "tags" : [
      "catalyst",
      "mvc",
      "security",
      "authentication",
      "old_site"
   ],
   "draft" : false
}


How many criteria do you think there are for a web application to securely login its users? [The Web Application Hacker's Handbook](http://www.amazon.com/gp/product/1118026470/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1118026470&linkCode=as2&tag=perltrickscom-20) (affiliate link) lists 5:

1.  Prevent information leaks
2.  Handle credentials secretively
3.  Validate credentials properly
4.  Prevent brute-force attacks
5.  Log, monitor and notify

So there are 5 criteria, but how you do implement them? I've created a [new web application](https://github.com/dnmfarrell/SecApp_login) called "SecApp" using Perl's Catalyst web framework that attempts to satisfy these criteria - we'll step through each one and you can judge for yourself if it does.

### How to setup the app

If you'd like to download the app and follow along you can, but this step is optional. You're going to need at least Perl 5.14.4 and a git installed. To download the app from our github page, just open up the command line and enter:

``` prettyprint
$ git clone https://github.com/dnmfarrell/SecApp_login
```

There's no way around it; this app has a lot of dependencies. To ease the burden, start by installing [cpanminus](https://metacpan.org/pod/App::cpanminus) at the command line:

``` prettyprint
$ cpan App::cpanminus
```

I prefer to use cpanminus when installing lots of modules: it's less of a memory hog than cpan, outputs less line noise by default, and has the useful "--notest" option if you want to install modules without testing them (and save a lot of time). Now change into the newly cloned app directory, and use cpanminus to install the app's dependencies:

``` prettyprint
$ cd SecApp_login
$ cpanm --installdeps .
--> Working on .
Configuring SecApp-0.01 ... OK
<== Installed dependencies for .. Finishing.
```

The "--installdeps" switch instructs cpanminus to search the current directory for dependencies. All of of the app's dependencies are listed in Makefile.PL, so cpanminus finds those and begins installing all of the Perl modules that the app requires but your system does not have installed. If you're working with a fresh install of Perl, this can take up to an hour or so, so go make a cup of coffee or something else whilst the installs happen.

Once all the modules are installed, test run the application with the following command:

``` prettyprint
$ TESTING=1 script/secapp_server.pl 
HTTP::Server::PSGI: Accepting connections at http://0:3000/
```

Open your browsers and navigate to http://localhost:3000. You see this simple welcome message:

![](/images/84/secapp_welcome.png)

If you visit http://localhost/login, it should load the login page:

![](/images/84/secapp_login.png)

Using the username "test\_user\_01" and "Hfa \*-£(&&%HBbWqpV%"\_=asd" you should be able to login.

![](/images/84/secapp_login_credentials.png)

A successful login will display a simple message and logout link:

![](/images/84/secapp_landing.png)

### 1. Prevent information leaks

Information leaks give would-be attackers clues that undermine the login security. One way they do this is by giving information about the software running the web application (which may have known weaknesses).

In SecApp I've turned off the typical Catalyst information leaks. In the root application file [SecApp.pm](https://github.com/dnmfarrell/SecApp_login/blob/master/lib/SecApp.pm) the "-Debug" plugin has been removed, which prints a full stack trace in the case of an error:

``` prettyprint
use Catalyst qw/
    Static::Simple
    Authentication
    Session
    Session::Store::File
    Session::State::Cookie
/;
```

Further down the same file, the "X-Catalyst" HTTP header has been disabled by modifying the package configuration. This stops the header from being inserted to every response:

``` prettyprint
# Disable X-Catalyst header
enable_catalyst_header => 0,
```

These two changes stop the application from informing users the underlying application framework and language. Now they won't know if they're dealing with a Ruby, Python or Perl application!

The other type of information leak we need to prevent is indicating logical vulnerabilities by responding differently to similar requests. For example, by responding to login attempts with incorrect usernames with the error message "incorrect username", attackers can brute-force attack the username until they receive the message "incorrect password", at which point they know they have guessed a correct username.

In SecApp, we want to respond with a generic message every time the login attempt fails, and not indicate which field was incorrect. The login function is implemented in our [Root.pm](https://github.com/dnmfarrell/SecApp_login/blob/master/lib/SecApp/Controller/Root.pm#L42) controller - we'll look at the code later, but for now you can see that there is only one error message returned.

### 2. Handle credentials secretively

The [The Web Application Hacker's Handbook](http://www.amazon.com/gp/product/1118026470/ref=as_li_qf_sp_asin_il_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=1118026470&linkCode=as2&tag=perltrickscom-20) summarizes this as:

> All credentials should be created, stored, and transmitted in a manner that does not lead to unauthorized disclosure.

In SecApp [Root.pm](https://github.com/dnmfarrell/SecApp_login/blob/master/lib/SecApp/Controller/Root.pm#L11), we use Catalyst's auto Controller function to check that every request is over SSL:

``` prettyprint
# this method will be called everytime
sub auto :Private {
    my ($self, $c) = @_;

    # 404 unless https/testing & request method is GET/HEAD/POST
    unless( ( $c->req->secure or $c->config->{testing} == 1 )
            && grep /^(?:GET|HEAD|POST)$/, $c->req->method )
        {
            $c->detach('default');
        }
    ...
    return 1;
}
```

The method "$c-\>req-\>secure" will return true if the connection is via SSL. If it isn't we detach the request to the "default" method, which returns a 404 request error. The clause "or $c-\>config-\>{testing} == 1" is so that when testing the application we can try out the functions without needing SSL, as Catalyst's test server does not support it.

Now it could be irritating for users who try to load the login page and get a 404 error. So using Catalyst's end method, we also set the Strict-Transport-Security HTTP header which instructs browsers to load all pages via https. This is the code:

``` prettyprint
sub end : ActionClass('RenderView') {
  my ($self, $c) = @_;

  # don't require TLS for testing
  unless ($c->config->{testing} == 1) {
    $c->response->header('Strict-Transport-Security' => 'max-age=3600');
  }
  ...
}
```

SecApp sets several other security headers in the [end method](https://github.com/dnmfarrell/SecApp_login/blob/master/lib/SecApp/Controller/Root.pm#L90), you can read about what they do [here](http://perltricks.com/article/81/2014/3/31/Perl-web-application-security-HTTP-headers).

SecApp only authenticates login requests received via POST. We achieve this by using Catalyst's chained dispatching and HTTP method matching:

``` prettyprint
sub login :Chained('/') PathPart('login') CaptureArgs(0) {}

sub login_auth :Chained('login') PathPart('') Args(0) POST {
    # authentication code
    ...

    # authentication failed, load the login form
    $c->forward('login_form');
}

sub login_form :Chained('login') PathPart('') Args(0) GET {
    my ($self, $c) = @_;

    # load the login template
    $c->stash(template => 'login.tt');
    ...
}
```

The [code](https://github.com/dnmfarrell/SecApp_login/blob/master/lib/SecApp/Controller/Root.pm#L42) has been abbreviated here for clarity. But effectively the "login\_auth" subroutine will only fire if the request to "/login" was made via POST, else just load the login page with the "login\_form" sub. Cool right? Catalyst project manager John Napiorkowski mused on these features in an illustrative [blog post](http://jjnapiorkowski.typepad.com/modern-perl/2013/08/thoughts-on-catalyst-soa-and-web-services.html#.U11rEjnXvqg).

Finally, SecApp stores the passwords in an hashed format, using a relatively strong algorithm (bcrypt). The following code in [User.pm](https://github.com/dnmfarrell/SecApp_login/blob/master/lib/SecApp/Schema/Result/User.pm#L130) adds the functionality:

``` prettyprint
__PACKAGE__->add_columns(
            'password' => {
                passphrase => 'rfc2307',
                passphrase_class => 'BlowfishCrypt',
                passphrase_args => {
                    cost => 14,
                    salt_random => 20,
                },
                passphrase_check_method => 'check_password',
            });
```

So even if attackers obtained the application password file, the passwords are salted and hashed and not easily broken. SecApp comes with a sample SQLite3 test database with one test user account already created.

### 3. Validate credentials properly

The code that validates credentials can also contain weaknesses. Passwords should be validated in full, without modification or truncation and in a case-sensitive comparison. Multi-stage login processes are particularly susceptible to attacks. The login code should be peer-reviewed and substantially tested for errors.

The [Catalyst::Plugin::Authentication](https://metacpan.org/pod/Catalyst::Plugin::Authentication) module makes authentication easy. SecApp keeps the login process simple: just a username and password form, with an optional CAPTCHA. Here is the full login code:

``` prettyprint
sub login_auth :Chained('login') PathPart('') Args(0) POST {
  my ($self, $c) = @_;
  my $captcha_response 
    = $c->request->params->{recaptcha_response_field};
  my $captcha_challenge 
    = $c->request->params->{recaptcha_challenge_field};

  # proceed if config has switched off CAPTCHA, or if the submission is valid, proceed
  if ($c->config->{Captcha}->{enabled} == 0
      || Captcha::reCAPTCHA->new->check_answer(
                   $c->config->{Captcha}->{private_key},
                   $c->request->address,
                   $captcha_challenge,
                   $captcha_response)->{is_valid})
  {
    $username = $c->req->params->{username};
    my $password = $c->req->params->{password};

    # if username and passwords were supplied, authenticate
    if ($username && $password) {
      if ($c->authenticate({ username => $username,
                             password => $password } ))
      {
      # authentication success, check user active and redirect to the secure landing page
        if ($c->user->get_object->active) {
          $c->response->redirect($c->uri_for($c->controller('Admin')->action_for('landing')));
          return;
        }
      }
      else {
        $c->stash(error_msg => "Bad username or password.");
      }
    }
  }
  $c->forward('login_form');
}
```

Let's walk through the code. If the CAPTCHA functionality is enabled, the login function will attempt to validate the CAPTCHA. If successful, the code then retrieves the username and password, and if they exist, attempts to validate them using the authenticate method. The authenticate method checks both username and password in full against the database. If the username and password are validated, then the user will be re-directed to the landing page which is in the secure Admin.pm controller. Else an error message will set indicating a bad username or password. In all failing cases, the login form will be reloaded and displayed.

So the code looks good, but how do we know if it will do the right thing in all cases? Fortunately [Catalyst::Test](https://metacpan.org/pod/Catalyst::Test) can make unit testing an application's methods easy. SecApp has the test file [Root.t](https://github.com/dnmfarrell/SecApp_login/blob/master/t/Root.t) which tests the login function with many different combinations of credentials, such as null, zero-length string, correct username incorrect password etc. Running these tests makes it easy to confirm that the login function does the right thing. Want to check for yourself? At the command line run:

``` prettyprint
$ TESTING=1 perl -Ilib t/Root.t
```

### 4. Prevent brute-force attacks

Brute force attacks are attempts to crack the username and password of an account by repeatedly trying different combinations until one succeeds. SecApp uses [Captcha::reCAPTCHA](https://metacpan.org/pod/Captcha::reCAPTCHA) to prevent automated brute force attacks. You'll need a Google account and web domain to sign up for it (it's free). The difficulty of the captcha puzzles presented are very difficult to reliably pass with automation. If you do have a Google [reCAPtCHA account](https://www.google.com/recaptcha/intro/index.html), you can try it out with SecApp by updating [SecApp.pm](https://github.com/dnmfarrell/SecApp_login/blob/master/lib/SecApp.pm#L54) with your account credentials.

![](/images/84/secapp_login_catpcha.png)

Seeing as brute-force attacks can only succeed if they can try millions of attempts, why not just add a time-delay like "sleep(2)" to the login function? The problem with that defence is that it opens the web application up to another attack-vector: denial of service. If an attacker can issue several requests every 2 seconds to the login function, it may tie up all of the application's processes and stop it from responding to regular web requests. Not good!

Using CAPTCHA combined with front-end proxy web server request and connection limiting methods that can largely eliminate the brute-force risk.

### 5. Log, monitor and notify

Catalyst comes with built-in logging capabilities. If you're using Catalyst::Plugin::Authentication, any failed login attempt automatically logs a critical error. So the good news is if you're using a web server like nginx, Catalyst will write the critical error to the server error log (this is a simplification). SecApp does not implement any monitoring or notification services, but I think this is more the domain of the server and not the web application. It's trivial to configure [fail2ban](http://www.fail2ban.org/wiki/index.php/Main_Page) to monitor the error.log and jail any suspicious repeat login attempts.

### Conclusion

Is the SecApp login function secure? One thing to consider is that although it utilizes many good practices, user registration and password reset is not implemented. These features must be secure too, else they can undermine the login security altogether, for example by allowing weak passwords to be set. We'll consider these areas of authentication in a future article. In the meantime, SecApp is released under the Artistic 2.0 license, feel free to use it.

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F84%2F2014%2F4%2F28%2FIs-your-login-page-secure-&text=Is+your+login+page+secure%3F&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F84%2F2014%2F4%2F28%2FIs-your-login-page-secure-&via=perltricks) about it!

***Updated:** corrected hashing algorithm name and description 04/28/2014*

*Cover image [©](https://creativecommons.org/licenses/by/2.0/) [motograf](https://www.flickr.com/photos/motograf/1269439152/in/photolist-2Wbd2W-9VxeqP-8v6WhC-8v3ToK-8v6W4h-fcDhWQ-6boP72-LNv8s-4pkUnM-aj6wD3-4rL1UA-9Ziy7V-jP5Sc-51f4ck-4ppX9S-dWGQed-dWGuMs-dQRyD-b9SUT-9cBRYL-5UB8BE-8BFgnW-6boNpR-6bsWUQ-6bsX9C-FXJTL-8AuQei-8AuRVc-8AuSzH-6gA6Lx-8v5M9x-91rH7R-dWsFmy-ZQRR-jP6a9-4HKkvg-4HPzk1-5eWG8T-8v8Q6d-8v8Q7N-4HKmZ6-kJrvqx-fcp9cZ-4rsdJ3-aFebHa-4HPALy-7HrEuY-6Pk9RC-hX3MVF-7xoEF6)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
