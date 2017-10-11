{
   "title" : "The Philosophy of WebNano",
   "thumbnail" : null,
   "categories" : "Web",
   "description" : "Why do so many web applications have the same components, yet so few actually share those components as libraries?  Perhaps the philosophy of building web frameworks is the culprit.  Zbigniew Lukasiak's WebNano is an attempt to solve that problem.",
   "authors" : [
      "zbigniew-lukasiak"
   ],
   "image" : null,
   "draft" : null,
   "tags" : [],
   "date" : "2010-11-23T19:31:41-08:00",
   "slug" : "/pub/2010/11/the-philosophy-of-webnano"
}





Why WebNano
===========

Many web applications have common components: a login page, a comment
box, an email confirmation mechanism, a generic CRUD page. All of these
are well-defined components. It's easy to believe that it should not be
difficult to abstract them away into libraries. Yet every time you start
a web application you need to write that boring comment box again and
again.

Why are there so few such libraries? Why is writing them so hard? There
are more and less important reasons, but there are many reasons. Most
projects to make components eventually die the death of a thousand cuts.
Some of those problems can be solved and I believe that solving them
would make a difference.
[WebNano](http://search.cpan.org/perldoc?WebNano) is my attempt at doing
that.

Probably the most popular Perl web framework is
[Catalyst](http://catalystframework.org/). It is also the web framework
I know the bestâthis is why I chose it as the point of reference for my
analysis.

**Controllers in request scope**
--------------------------------

Five years ago I was staring at the first Catalyst examples and had
foggy intuition that there was something not quite optimal. The essence
of object oriented programming is that the most accessed data should be
available to all methods in a class without explicitly passing it via
parameters, but the Catalyst examples always started with
`my ( $self, $c, ... ) = @_`. That's not very
[DRY](http://c2.com/cgi/wiki?DontRepeatYourself). The `$c` parameter
gets passed everywhere as if it were a plain old parameter.

At some point I [counted how often methods from the manual use the
controller object versus how often they use the context object which
contains the request
data](http://perlalchemy.blogspot.com/2009/10/catalystcomponentinstancepercontext.html).
The result was 117 and 38 respectively. Many people commented that their
code often uses the controller object. It's hard to judge this unless
you can see that code, but as my code resembled the example code from
the manual, this seems common. This disproportion is only an
illustration. The question is not about switching `$c` with `$self`. The
question is why the request data, which undeniably is in the center of
the computation carried out in controllers, is anything other than
instance data.

My curiosity persisted until about a year ago, when I received a reply
in private communication from some members of the core team. They want
the controller object to be immutable (see [Immutable Data
Structures](http://blog.woobling.org/2009/05/immutable-data-structures.html)).
That's impossible if the values of one or more of its attributesmust
necessarily change with each incoming request. Immutable objects are a
good design choice and I accepted this answer but later I wondered what
would happen if the framework recreated the controller object anew with
each request? Then it could hold the request data and still be immutable
for the lifetime of the request.

This would be a big change for Catalyst; Catalyst controllers are
created at the starup time, together with all the other application
components (models and views) and changing that does not seem feasible.
I decided to write a new web framework.

I have tried many Perl web frameworks but I found only one more that
uses controllers in request scope. This is a fundamental distinguishing
feature of WebNano. It's not only about reducing the clutter of
repeatable parameter passing. Instead, I believe that putting object
into their natural scope will fix a lot of the widely recognized
[problems with the Catalyst stash and data passed through
it](http://jjnapiorkowski.vox.com/library/post/does-anyone-else-hate-the-stash.html).
In procedural programming it is not controversial to put your variable
declarations into the narrowest block that encompasses their uses. The
same should be true for objects. Using the same controller to serve
multiple request *is* a bit faster then recreating it each time, but
that gain is modest. [Object::Tiny on one of the tester machines could
create 714286 object per
second](http://www.cpantesters.org/cpan/report/7c61aa08-d810-11df-8503-f91d06264d1f)
and even [Moose](http://moose.perl.org/), the slowest framework tested
there, can create more then a 10000 objects per second. Eliminating a
few of such operations, in most circumstances, is not worth compromising
on the architecture.

I also tested these theoretical estimations with more down to earth
[ab](http://httpd.apache.org/docs/2.0/programs/ab.html) benchmarks for a
trivial application serving just one page. WebNano was the fasted
framework tested, by a wide margin. This is still an artificial test,
but it should be accurate enough to show that the cost introduced by
this design choice does not need to be big.

**Decoupling**
--------------

WebNano may have tested as the fastest framework because it does not do
much. WebNano is really small. Its *lib/* directory currently contains
just 233 lines of code (as reported by
[sloccount](http://www.dwheeler.com/sloccount/)) and [minimal
dependencies](http://deps.cpantesters.org/?module=WebNano;perl=latest).
CPAN libraries cover all corners of web application programming, so
WebNano can provide a basic structure and otherwise get out of the way.
Assuming simplicity allowed me to remove a lot of code required for
advanced flexibility.

For example, Catalyst started the process of decoupling the web
framework from other parts of the application. With Catalyst you can use
any persistence layer for the model and any templating library for the
view. Yet with this flexibility the `model()` and `view()` methods in
Catalyst are very simple. There is no common behaviour among the various
libraries, so all these methods do is find a model or view by its name.
For WebNano I decided that `->Something` is shorter and no less
informative then `->model('Something')`, so I removed the `model()` and
`view()` methods.

I also decided to leave out component initialization. This is a generic
task used in all kinds of programs. Any library which performs this task
needs to know nothing about the web part of the application, and CPAN
offers many such initialization libraries. In my limited experiments
[MooseX::SimpleConfig](http://search.cpan.org/dist/MooseX-SimpleConfig/)
was very convenient. For more complex needs,
[Bread::Board](http://search.cpan.org/dist/Bread-Board/) seems like a
good choice. This initialization layer needs to know how to create all
the objects used by the application, but you need no WebNano adapter to
use them.

**Localized dispatching**
-------------------------

Out of the box WebNano supports only one very simple dispatching model.
Dispatching controls which subroutine to call with which arguments and
depends directly on the behavior of the subroutines themselves. This is
why I don't believe in external dispatchers where you configure all the
dispatching for the application in one place. The dispatching might be
in one place, but any practical change you make requires updates in two
places. WebNano's default dispatching is easy to extend and override on
per-controller basis.

Writing a dispatcher is not hard; it's only complex and difficult when
you try to write a dispatching model to work for every possible
application. I prefer to write a simple dispatcher covering only the
most popular dispatching scenarios and let the users of my framework
write any specialized dispatching code for specialized controllers. With
WebNano this is possible because these specialized dispatchers don't
interfere with each other.

I also believe that this will make the controller classes more
encapsulated and facilitate building libraries of application
controllers.

**Granularity**
---------------

I like the way Catalyst structures your web related code into controller
classes. This is a step forward from the
[CGI::Application](http://search.cpan.org/~markstos/CGI-Application-4.31/lib/CGI/Application.pm)
way of packing everything into one class. I have no hard data to support
my impression, but the granularity of packing a few related pages into
one controller class feels just about right. It gives room for expansion
by adding new classes and dividing existing ones, and it does not
clutter the application code with several nearly empty classes. This is
a very important feature. I copied this design wholeheartedly in
WebNano.

**Experiments with inheritance and overriding**
-----------------------------------------------

One of the WebNano tests is an application which subclasses the main
test app. It passes all the original tests and could be completely empty
if I did not want to test the overriding of the inherited parts. I have
seen many times a need for such behaviour, from branding websites to
SaaS to reusable intranet tools. Too many applications solve the problem
of reuse by copying code. Inheritance has its problems, but it enables
ad-hoc reuse better than cut and paste programming.

Be aware that you need to override much more than just methods. My
experiment with WebNano overrides application parts: controllers,
templates, and configuration. It also overrides individual controllers
at the template and method levels.

This type of inheritance could enable a natural mechanism to publish
applications to CPAN, because they could operate with no special
installation. Users could run them directly from `@INC` and only later
override the configuration or templates as needed.

**Universality**
----------------

In the most common case a web application serving a request needs to
fetch data, perform some computations on this data, and render a
template with the computed values. Those tasks typically consume 99% of
the overall time spent serving a request. The other 1% of time spent in
the application framework processing matters little; reducing it will
produce little noticeable speed increase in the whole application.

Even so, there might be rare cases where the application needs to serve,
for example, small JSON data chunks from a memory cache. Even when this
is a small and simple part of the application, if it generates enough
volume then the speed of the framework suddenly becomes important. Would
you code that part in PHP?

I was very tempted to use Moose in WebNano. Moose generates some
significant startup overhead, though for web applications running in
persistent environments this does not matter much because that overhead
amortizes over many requests. If you run your application as CGI, this
startup time becomes important. Even if CGI is perceived as passÃ© now,
it is still the easiest way to deploy web applications and (especially
with the most widespread support from hosting companies). Fortunately,
using
[MooseX::NonMoose](http://search.cpan.org/perldoc?MooseX::NonMoose) it
is very easy to treat any hash based object classes as base classes for
Moose based code, so using WebNano does not mean that you need to stick
to the simplistic Object Oriented Framework it uses.

The plan is to make WebNano small but universal, then make extensions
that will be more powerful and more restricted. I think it is important
that the base platform can be used in all kinds of circumstances.

**Conclusions**
---------------

It is early to say if WebNano will live to the promise of facilitating
the development of web application components. There is a first
component at CPAN:
[WebNano::Controller::CRUD](http://search.cpan.org/dist/WebNano-Controller-CRUD/).
It still bears the label "experimental", but I used it in
[Nblog](https://github.com/zby/Nblog). When I compare it to my first
similar product
[Catalyst::Example::Controller::InstantCRUD](http://search.cpan.org/~wreis/Catalyst-Example-InstantCRUD-0.037/lib/Catalyst/Example/Controller/InstantCRUD.pm),
there aren't many differences. As you might predict, the methods have
one less parameter (`$c`). Inheritable templates are also nice for
deploymentâyou don't need to write your own templates to see it working,
and later you can easily override the defaults. There is a bit more
dispatching code, but thanks to that, the code retrieves the result
object in only one place. In Catalyst this is possible with chained
dispatching. In the [examples
directory](https://github.com/zby/WebNano/tree/master/examples/DvdDatabase/lib/DvdDatabase/Controller/)
there are four variations on this CRUD theme. I remain undecided about
whis is optimal.

The surprising thing when converting Nblog from Catalyst to WebNano was
how little I missed the rich Catalyst features, even though WebNano has
still so little code. I think it is a promising start.

Recently I discovered echoes of many of my design choices in the
publications by the Google testing guru [MiÅ¡ko
Hevery](http://misko.hevery.com/). My point of departure for the
considerations above were general rules such as decoupling and
encapsulation, where his concern is testability. The resulting [design
without
singletons](http://misko.hevery.com/2008/08/21/where-have-all-the-singletons-gone/)
is remarkably similar. There is a lot of good articles at his blog, some
were similar to what I already had considered ([managing object
lifetimes](http://misko.hevery.com/2009/04/15/managing-object-lifetimes/))
and others were completely new to me ([how to do everything wrong with
servlets](http://misko.hevery.com/2009/04/08/how-to-do-everything-wrong-with-servlets/)).
I recommend them all.


