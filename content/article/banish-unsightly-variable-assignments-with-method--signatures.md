{
   "draft" : false,
   "title" : "Banish unsightly variable assignments with Method::Signatures",
   "authors" : [
      "david-farrell"
   ],
   "image" : null,
   "date" : "2013-09-08T22:59:38",
   "slug" : "39/2013/9/8/Banish-unsightly-variable-assignments-with-Method--Signatures",
   "categories" : "development",
   "description" : "Add subroutine signatures to Perl",
   "tags" : [
      "subroutine",
      "syntax",
      "method"
   ]
}


One drawback of Perl is that its subroutines and methods do not have signatures (ignoring [prototypes]({{< perldoc "perlsub" "Prototypes" >}})). This means that Perl developers have to write their own code for variable assignment and type checking which leads to repetitive and verbose code. This article shows how by using the [Method::Signatures]({{<mcpan "Method::Signatures" >}}) module developers can banish this boilerplate forever.

### The func subroutine

Method::Signatures exports a subroutine called "func" which can replace the "sub" built-in function. Let's look at a typical Perl subroutine:

```perl
use Carp qw/croak/;
sub extract_domain {
    my $url = @_;
    croak "Error missing argument URL $!" unless $url;
    # code continues ...
}
```

We can refactor this subroutines using "func" which accepts a signature (list of variables):

```perl
use Method::Signatures;
func extract_domain ($url) {
    # code continues ...
}
```

Replacing "sub" with "func" means that it will declare $url, croak if $\_[0] doesn't exist, else assign it to $url. This removes the need to include the boilerplate assignment and check code which in the example reduce the code length by 33% (2 lines of code).

### The method subroutine

Method::Signatures also exports a subroutine called "method" that can replace "sub" in object-oriented code. In addition to accepting a signature argument like "func", "method" automatically declares and assigns $self. Consider the difference between this code extract (taken from [Nginx::Log::Entry]({{<mcpan "Nginx::Log::Entry" >}})):

```perl
package Entry;
use Time::Piece;
use Nginx::ParseLog;
use HTTP::BrowserDetect;

sub new {
    my ( $class, $log_line ) = @_;
    die "Error: no log string was passed to new" unless $log_line;
    my $self = Nginx::ParseLog::parse($log_line);
    $self->{detector} = HTTP::BrowserDetect->new( $self->{user_agent} );
    return bless $self, $class;
}

sub get_ip {
    my $self = shift;
    return $self->{ip};
}

sub get_timezone {
    my $self = shift;
    return substr( $self->{time}, -5 );
}

sub was_robot {
    my $self = shift;
    return $self->{detector}->robot;
}

sub get_status {
    my $self = shift;
    return $self->{status};
}

sub get_request {
    my $self = shift;
    return $self->{request};
}

1;
```

and a refactored version using "method":

```perl
package Entry_New;
use Time::Piece;
use Nginx::ParseLog;
use HTTP::BrowserDetect;
use Method::Signatures;

func new ($class, $log_line) {
    my $self = Nginx::ParseLog::parse($log_line);
    $self->{detector} = HTTP::BrowserDetect->new( $self->{user_agent} );
    return bless $self, $class;
}

method get_ip {
    return $self->{ip};
}

method get_timezone {
    return substr( $self->{time}, -5 );
}

method was_robot {
    return $self->{detector}->robot;
}

method get_status {
    return $self->{status};
}

method get_request {
    return $self->{request};
}

1;
```

By using "method" we were able to remove all the boilerplate declarations and checks from the code, reducing the code length by almost 20% and improving its readability.

### Benchmarking Method::Signatures

Does using Method::Signatures come with a significant performance hit? We can test the performance impact by comparing the vanilla and refactored Entry classes from earlier in this article. We'll use the [Benchmark::Forking]({{<mcpan "Benchmark::Forking" >}}) module to improve the benchmark accuracy. This is the benchmark script:

```perl
use Benchmark::Forking qw/cmpthese/;
use Entry;
use Entry_New;

open (my $LOG, '<', 'access.log');
my @log = <$LOG>;

cmpthese (100, {
        Entry       => sub { foreach (@log) {
                                my $entry = Entry->new($_);
                                $entry->get_ip;
                                $entry->get_timezone;
                                $entry->was_robot;
                                $entry->get_status;
                                $entry->get_request;
                              }
                       },
        Entry_New   => sub { foreach (@log) {
                                my $entry = Entry_New->new($_);
                                $entry->get_ip;
                                $entry->get_timezone;
                                $entry->was_robot;
                                $entry->get_status;
                                $entry->get_request;
                             }
                       },
});
```

This script reads an Nginx access log of 10000 entries into @log. For both Entry and Entry\_New, it will test 100 times the performance of initializing an Entry object and calling the accessor methods of the object. It does this for every entry in @log. Running the benchmark script returned the following result:

```perl
            s/iter   Entry_New   Entry
Entry_New   1.65        --        -1%
Entry       1.63        1%        --
```

These results suggest that using Method::Signatures comes with only a 1% performance hit, which seems like excellent value given the functionality it provides.

### Additional features

There is a lot more to Method::Signatures such as named and optional parameters, type checking, default values and aliases. Check out the excellent module [documentation]({{<mcpan "Method::Signatures" >}}) for more details.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
