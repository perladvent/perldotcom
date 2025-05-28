{
   "image" : "/images/slapbirdapm-a-free-and-open-source-observability-tool-for-perl/logo.png",
   "thumbnail" : "/images/whats-new-on-cpan/green.svg",
   "description" : "A curated look at May's new CPAN uploads",
   "title" : "SlapbirdAPM, a Free and Open-Source Observability Tool for Perl Web Applications",
   "tags" : [
      "observability",
      "performance",
      "monitoring"
   ],
   "categories" : "tooling",
   "authors" : [
      "rawley-fowler"
   ],
   "date" : "2025-05-28T08:00:00",
   "draft" : false
}

[SlapbirdAPM](https://slapbirdapm.com) is a free-software observability platform tailor made for Perl web-applications. [ It is also a Perl web-application :^) ]
It has first class support for [Plack](https://metacpan.org/pod/Plack), [Mojo](https://metacpan.org/pod/Mojolicious), [Dancer2](https://metacpan.org/pod/Dancer2), and [CGI](https://metacpan.org/pod/CGI). Slapbird provides developers with comprehensive
observability tools to monitor and optimize their applications' performance.

In this article I will explain how to setup a Plack application with Slapbird. If you want to use another supported framework,
please read our [Getting Started](https://www.slapbirdapm.com/getting-started) documentation, or reach out to me on the Perl Foundations Slack channel!

[SlapbirdAPM](https://www.slapbirdapm.com) is easily installed on your Plack application, here is a minimal example, using a Dancer2 application that runs under Plack:

Install with
```
cpan -I SlapbirdAPM::Agent::Plack
```

```perl
#!/usr/bin/env perl

use Dancer2;
use Plack::Builder;

get '/' => sub {
    'Hello World!';
};

builder {
    enable 'SlapbirdAPM';
    app;
};
```

Now, you can create an account on [SlapbirdAPM](https://www.slapbirdapm.com), and create your application.

![New Application](/images/slapbirdapm-a-free-and-open-source-observability-tool-for-perl/new-application.webp)

Then, simply copy the API key output and, add it to your application via the `SLAPBIRDAPM_API_KEY` environment variable. For example:

```shell
SLAPBIRDAPM_API_KEY=<API-KEY> plackup app.pl
```

or, you can pass your key in to the middleware:

```perl
builder {
    enable 'SlapbirdAPM', key => <YOUR API KEY>;
    ...
};
```

Now when you navigate to `/`, you will see it logged in your [SlapbirdAPM](https://www.slapbirdapm.com) dashboard!

![Dashboard](/images/slapbirdapm-a-free-and-open-source-observability-tool-for-perl/dashboard.webp)

Then, clicking into one of the transactions, you'll get some more information:

![Individual transaction](/images/slapbirdapm-a-free-and-open-source-observability-tool-for-perl/individual-transaction.webp)

[SlapbirdAPM](https://www.slapbirdapm.com) also supports DBI, meaning you can trace your queries, let's edit our application to include a few DBI queries:

```perl
#!/usr/bin/env perl

use Dancer2;
use DBI;
use Plack::Builder;

my $dbh = DBI->connect( 'dbi:SQLite:dbname=database.db', '', '' );

$dbh->do('create table if not exists users (id integer primary key, name varchar)');

get '/' => sub {
    send_as html => 'Hello World!';
};

get '/users/:id' => sub {
    my $user_id = route_parameters->get('id');
    my ($user) = 
        $dbh->selectall_array(
          'select * from users where id = ?',
          { Slice => {} }, $user_id );
    send_as JSON => $user;
};

post '/users' => sub {
    my $user_name = body_parameters->get('name');
    my ($user) =
      $dbh->selectall_array(
        'insert into users(name) values ( ? ) returning id, name',
        { Slice => {} }, $user_name );
    send_as JSON => $user;
};

builder {
    enable 'SlapbirdAPM';
    app;
};
```

Now we can use cURL to add data to our database:

```shell
curl -X POST -d 'name=bob' http://127.0.0.1:5000/users
```

Then, if we go back into Slapbird, we can view our timings for our queries:

![Query timings](/images/slapbirdapm-a-free-and-open-source-observability-tool-for-perl/queries.webp)

This just breaks the surface of what is possible using [SlapbirdAPM](https://www.slapbirdapm.com). You can also, generate reports,
perform health-checks, and get notified if your application is creating too many 5XX responses.

Thanks for reading!
