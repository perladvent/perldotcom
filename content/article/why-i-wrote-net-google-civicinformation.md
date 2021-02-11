
  {
    "title"       : "Why I wrote Net::Google::CivicInformation",
    "authors"     : ["Nick Tonkin"],
    "date"        : "2021-02-09T19:35:09",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "",
    "categories"  : "apps"
  }

## ... and why I created [https://contactmyreps.com](https://contactmyreps.com)

Before I became a computer programmer, I tried my hand at being a human programmer, in the form of a wordsmith, as I called myself then. I had various jobs as a writer, editor, translator and journalist, but I met with little success, for two main reasons. In those days you needed a publisher to find your work interesting enough to publish before anyone could read it, and that was a pretty high bar. And in the second place, it was difficult to get the humans to react to the content I wrote (I'm still exercised that the movie reviewer would get more letters to the editor than I did after a political exposé that took a month to produce).

I still remember the moment of awe and inspiration in early 1994 or so, when after acquiring a sparkly new i286 PC at Circuit City, I discovered the World Wide Web and its promise of a world free of publishers and constraining editors. I jumped right in and became one of the first "webmasters," which led to a job where I needed to learn Perl. Over a short time I began to thrill more at the construction of the engine to publish the content than at the creating of it. I still had the barrier-free entry point, and as to my second gripe ... well, I found that computers respond much more predictably to my writing than humans ever did.

Fast forward almost 25 years and lots of things have changed, but I still get an itch scratched by building "websites." Of course now they are called REST APIs or webapps or microservices or whatever the newest term is, and I deliver mostly JSON data packets to other computers inside big organizations -- it's been 20 years since I used CGI.pm -- but I'm very blessed to have had a long career in the same field with fast-evolving technologies, supported throughout by Perl and its amazing community of contributors.

You'd think maybe that after spending all week building APIs at work I'd be sated, but last weekend found me hankering for a new project, something outside work, but using my expertise, and something that could have real value for other people. I also specifically wanted to see if I could provide for the CPAN a library to interface to a useful public API. I've contributed a handful of insignificant distributions over the years, and found it to be very satisfying and also that it forces me to up my game as far as quality control and attention to detail. Yet I'd never found an opportunity to contribute a module in the area I know best.

Usually all the best ideas are taken, of course, especially when it comes to the CPAN. It seemed there was a client for every API you could think of, but eventually I stumbled upon one that I found to be super-cool, and unsupported in Perl! The [Google Civic Information API](https://developers.google.com/civic-information) provides extensive contact information for all elected officials from head of state down to county tax collector for any US address.

## Silence betokens consent

Like many of you, I suppose, I am still somewhat shell-shocked at the sustained assault on democracy and democratic participation that has been going on lately, not to mention that so many elected "leaders" seem to be insulated from the people. I also considered the COVID pandemic -- not just its awful toll and the crass incompetence of the government response, but also how it has made us all much more isolated from each other, and how technologies that bring people together are even more important now that, for example, you can't readily show up with a neighborhood community group to a crowded county board meeting to make your views heard. But silence betokens consent, and if our elected officials don't hear from us they will just continue to do what they do.

With all that in mind I set to creating a Perl client for the API. The first step was to obtain an auth token, which Google provides to developers for free (with a limit on daily queries). Authentication is extremely simple, so using [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny) I quickly had a client in my module that could connect to the API and make queries. Because elected officials' contact information is only one thing the API provides, I made a parent class [Net::Google::CivicInformation](https://metacpan.org/pod/Net::Google::CivicInformation) and subclass [Net::Google::CivicInformation::Representatives](https://metacpan.org/pod/Net::Google::CivicInformation::Representatives) handling the representatives-related code. This will allow me or other authors to write sibling subclasses for other endpoints in future.

Here's a portion of the subclass for fetching Representatives data:
```
package Net::Google::CivicInformation::Representatives;

our $VERSION = '1.02';

use strict;
use warnings;
use v5.10;

use Carp 'croak';
use Function::Parameters;
use JSON::MaybeXS;
use Try::Tiny;
use Types::Common::String 'NonEmptyStr';
use URI;
use Moo;
use namespace::clean;

extends 'Net::Google::CivicInformation';

##
sub _build__api_url {'representatives'}

##
method representatives_for_address (NonEmptyStr $address) {
    my $uri = URI->new( $self->_api_url );
    $uri->query_form( address => $address, key => $self->api_key );

    my $call = $self->_client->get( $uri );
    my $response;
    
    ...

```

The parent class has the `api_url` attribute whose coercion prepends the root URL to the value returned by the subclasses' builder override. Note the use of [Function::Parameters](https://metacpan.org/pod/Function::Parameters) for signatures and [Type::Tiny](https://metacpan.org/pod/Type::Tiny) for type validation, which reduce the subroutine boilerplate nicely.

Most of the work in creating the client distribution was in deciding how to marshal and reformat the extensive JSON data structure returned by Google. The results are organized into [Open Civic Data Divisions](http://docs.opencivicdata.org/en/latest/proposals/0002.html), an international standard adopted by Google for its service. An OCD Division ID can be as generic as `ocd-division/country:us` or as specific as `ocd-division/country:us/state:ny/place:new_york/council_district:36`. Google provides filtering on the data sets but I chose to use a high-level endpoint that returns all levels of officials for a single specific address (although a zip code alone works most of the time as well).

After a few attempts I had it working in a simple way that was pleasing to me as a consumer of the module, and I documented the arrayref of hashrefs it would return representing the, um, representatives. I wrote some tests and bundled up the distribution and uploaded it to PAUSE.

## Setting up the webservice

The next step was to put the new client to use, and a public-facing web app seemed the obvious choice. I've learned over the years that the majority of people still think of a .com domain as most inviting, and that a readable name is key. I settled on **ContactMyReps** for the name, registered the [contactmyreps.com](https://contactmyreps.com) domain, and pointed it at my server. At work I use [Mojolicious](https://metacpan.org/pod/Mojolicious) but I far prefer [Dancer2](https://metacpan.org/pod/Dancer2) -- it feels much more light weight and flexible and Perlish to me.

The POST route handler for the lookup query:
```
post '/find-by-address' => sub {
    my $params = params;

    if ( not $params->{address} ) {
        send_error('Error: address is required.', 400 );
    }

    my $client = Net::Google::CivicInformation::Representatives->new;

    my %result = ( address => $params->{address} );

    my $response = $client->representatives_for_address($params->{address});

    if ( $response->{error} ) {
        $result{error} = $response->{error};
    }
    else {
        $result{officials} = decode_utf8(encode_json($response->{officials}));
    }

    return template 'find-by-address', \%result;
};
```

The backend side of the webapp was done in an hour, and then I set to the presentation. It took a while but I came up with a design that seemed functional and aesthetically acceptable. After testing locally I was ready to deploy, and after creating a new TLS cert and updating the `Apache` config, the site was up and running. (The source code is available [on Github](https://github.com/1nickt/ContactMyReps)).

I sent the link to the to a couple of friends to see what they thought, and posted to [blogs.perl.org](http://blogs.perl.org/users/1nickt/2021/02/who-you-gonna-call-perl-client-and-website-for-google-civic-information-api.html) to get some live testing, and was pleased when other people started using the site.

## Wrapping up

Having conceived of and implemented the idea in less than 24 hours, I was pretty exhilarated and on a roll. I decided that if a thing was worth doing, it was worth doing well, so I signed up for a few hundred dollars in Google advertising to promote the site next to relevant search results. I also set up a Buy Me a Coffee account and placed a button on the search results display. It costs about $1.20 to buy a click to the site, so I figure if 10% of the visitors contribute something, they'll pay for the advertising to reach new audiences and the thing will be self-sustaining.

All in all it was a fun way to spend a winter weekend. The service is online at [https://contactmyreps.com](https://contactmyreps.com) if you'd like to check it out!








