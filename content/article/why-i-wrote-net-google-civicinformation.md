
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


Before I became a computer programmer, I tried my hand at being a human programmer, in the form of a wordsmith, as I called myself then. I had various jobs as a writer, editor, translator and journalist, but I remained unsatisfied, for two main reasons. In those days you needed a publisher to find your work interesting enough to publish before anyone could read it, and that was a pretty high bar. And in the second place, it was hard to get the humans to react to the content I produced - I'm still exercised that the movie reviewer would get more letter to the editor than I did after a political exposé that took a month to produce.

I still remember the moment of awe and inspiration when in early 1994 or so, after acquiring a sparkly i286 at Circuit City, I discovered the World Wide Web and its promise of a world free of publishers and constraining editors. I jumped right in and became one of the first "webmasters," which led to a job where I needed to learn Perl. Over a short time I began to thrill more at the construction of the engine to publish the content than at the creating of it. I still had the barrier-free entry point, and as to my second gripe ... well, I found that computers respond much more predictably to my writing than humans ever did.

Fast forward almost 25 years and lots of things have changed, but I still get an itch scratched by building "websites." Of course now they are called REST APIs or webapps or microservices or whatever the newest term is, and I deliver mostly JSON data packets to other computers inside big organizations -- it's been 20 years since I used CGI.pm -- but I'm very blessed to have had a long career in the same field with fast-evolving technologies, supported throughout by Perl and its amazing community of contributors.

You'd think maybe that after spending all week building APIs at work I'd be sated, but last weekend found me hankering for a new project, something outside work, but using my expertise, and something that could have real value for other people. I also specifically wanted to see if I could provide a library to interface to a public API for the CPAN. I've contributed a handful of insignificant distributions over the years, and found it to be very satisfying and also that it forces me to up my game as far as quality. Yet I'd never found an opportunity to contribute a module in the area I know best.

Usually all the best ideas are taken, of course, especially when it comes to the CPAN. It seemed there was a client for every API you could think of, but eventually I stumbled upon one that I found to be super-cool, and unsupported in Perl! The [Google Civic Information API](https://developers.google.com/civic-information) provides extensive contact information for all elected officials from head of state down to county tax collector for any US address. Well, like many of you, I suppose, I am still somewhat shell-shocked at the sustained assault on democracy and democratic participation that has been going on lately, not to mention that so many elected "leaders" seem to be insulated from the people. But silence betokens consent, and if our elected officials don't hear from us they will just do what they do.

I also considered the COVID pandemic and how it has made us all much more isolated from each other, and how the importance of technologies that bring people together is even greater now that, for example, you can't readily show up with a neighborhood to a crowded county board meeting to make your views heard.

With all that in mind I set to creating a Perl client for the API. The first step was to obtain an auth token, which Google provides to developers for free (with a limit on daily queries). Authentication is extremely simple, so using [HTTP::Tiny](https://metacpan.org/pod/HTTP::Tiny) I quickly had a client in my module that could connect to the API and make queries. Because elected officials' contact information is only one thing the API provides, I made a parent class [Net::Google::CivicInformation](https://metacpan.org/pod/Net::Google::CivicInformation) and subclass [Net::Google::CivicInformation::Representatives](https://metacpan.org/pod/Net::Google::CivicInformation::Representatives) handling the representatives-related code. This will allow me or other authors to write sibling subclasses for other endpoints in future.

Most of the work in creating the client distribution was in deciding how to marshal and reformat the extensive JSON data structure returned by Google. After a few attempts I had it working in a way that was pleasing to me as a consumer of the module, and I documented the arrayref of hashrefs it would return, um, representing the representatives. I wrote some tests and bundled up the distribution and uploaded it to PAUSE.

The next step was to put the new client to use, and a public-facing web app seemed the obvious choice. I've learned over the years that the majority of people still think of a .com domain as most inviting, and that a readable name is key. I settled on **ContactMyReps** for the name, registered the `contactmyreps.com` domain, and pointed it at my server. At `$work` I use [Mojolicious](https://metacpan.org/pod/Mojolicious) but I far prefer [Dancer2](https://metacpan.org/pod/Dancer2) -- it feels much more light weight and flexible and Perlsih to me.

The backend side of the webapp was done in an hour, and then I set to the presentation. It took a while but I came up with a design that seemed functional and aesthetically acceptable. After testing locally I was ready to deploy, and after creating a new TLS cert and updating the `Apache` config, the site was up and running. I sent the link to a couple of friends to see what they thought and get some live testing, and was pleased when other people started using the site.

Having conceived of and implemented the idea in less than 24 hours, I was pretty exhilarated and on a roll. I decided that if a thing was worth doing, it was worth doing well, so I signed up for a few hundred dollars in Google advertising to promote the site next to relevant search results. I also set up a Buy Me a Coffee account and p[laced a button on the search results display. It costs about $1.20 to buy a click to the site, so I figure if 10% of the visitors contribute something, they'll pay for the advertising to reach new audiences and the thing will be self-sustaining.

All in all it was a fun way to spend a winter weekend. The service is online at [https://contactmyreps.com](https://contactmyreps.com) if you'd like to check it out!








