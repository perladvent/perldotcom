{
   "date" : "2010-08-20T10:30:56-08:00",
   "image" : null,
   "title" : "Rethinking Everything: Perl and the Web in 201x",
   "categories" : "web",
   "thumbnail" : null,
   "tags" : [
      "cpan",
      "design",
      "web"
   ],
   "description" : "Modern Perl developments provide better capabilities for abstraction and reusable code.  Rethinking a project more than a decade old with modern techniques demonstrates how much Perl has improved-and how far it could go.",
   "slug" : "/pub/2010/08/rethinking-perl-web.html",
   "draft" : null,
   "authors" : [
      "chromatic"
   ]
}



In 1999 and 2000 I worked on the Everything Engine, a website management system written in Perl 5 which runs sites like [Everything 2](http://everything2.org/) and [PerlMonks](http://perlmonks.org/). The system has its flaws--many of them due to our inexperience building and maintaining large systems with the Perl of the time.

We could build it much better today, with modern libraries and techniques in Perl. In truth, building such a system today would solve a lot of uses for MVC applications.

### **How Everything Works**

The fundamental concept of Everything is that everything is a node. A node is an individual entity containing attributes, including a unique identifier and one or more addressing mechanisms expressible through a URI. Each node also has a nodetype (itself a node) which contains information about the node's characteristics, such as the attributes it contains, the types of operations it supports, and any mechanisms to view node information.

In other words, a node is an object, a nodetype is a class, and there's a metaobject protocol governing the relationships of nodes and nodetypes.

The Everything Engine provides a sort of routing system which might remind you of routes in one of the new heavy-model MVC systems. In one sense, Everything provided its own implementation of MVC, where URIs and URI components helped the controller find the appropriate model (node) and model operation (nodemethod), which eventually caused the rendering of a series of templates, or the view.

The system provides node inheritance for attributes and behaviors such as creating, reading, updating, and deleting nodes. Because every node inherited from node, every node has at least general behavior through any interface into the system. If you create a new nodetype, you can do useful things with nodes of that type without having to write any specific views or mess with routing or the like. You have the option of making prettier or more featureful or better or at least different views, but the default inherited views and behaviors are sufficient for the basic CRUD operations.

### **What Everything Didn't and Did Well**

Not everything went right. Remember, this system came about in 1998 and 1999, just as mod\_perl was the shiny new technology in the world of Perl web development. Object-relational mapping was still difficult (if even understood much), CGI.pm was still the king, and Template Toolkit hadn't taken over as the obvious first place to look for your templating needs.

Our hand-written ORM has its flaws, as dealing with node inheritance and lookup of node types and (yes) serializing code to the database to `eval` into a running instance of the system at initialization time. The XML serialization scheme for bundling core nodes and custom nodes was even worse, not only due to our use of the DOM.

Without a well-understood mechanism and framework and example of doing MVC well in Perl 5, Everything's custom interpretation of MVC was odd. Where MVC helps separate application responsibilities into loosely-coupled layers, passing around a CGI object to models and templates violates that encapsulation. (The less said about the custom method dispatch strategy the better.)

Most of the problems with the system are obvious in retrospect, over a decade later (especially with a decade of experience creating new systems, maintaining existing systems, and stealing ideas from other projects which have made different mistakes).

Even with all of those mistakes, the system worked reasonably well in many cases. Adding new features was easy (even if deploying them is less so). Creating new behaviors by reusing existing primitives makes building simple systems easy. The usability provided by inherited defaults made it easy to iterate and experiment and refine new behaviors.

We also eventually produced a system to bind UI widgets--HTML, in our case--to node attributes. That made displaying and editing mechanisms much, much easier.

I wouldn't start a new site with Everything as it exists today, but I've wanted a modern version of it for a long, long time. Modern Perl has almost all of the pieces needed to rebuild it.

### **Doing Everything Better**

The [Moose](http://moose.perl.org/) object system provides an obvious way to define nodes. A node is merely a Moose object, and a nodetype is its class. This provides a well-understood and robust mechanism for dealing with attributes and methods and roles and the like, and the metaobject protocol provided by [Class::MOP](https://metacpan.org/pod/Class::MOP) allows introspective capabilities which will become obviously important soon.

[Plack](https://metacpan.org/pod/Plack) support is obviously the current best way to deploy a web application in Perl 5, as it allows reusable middleware and offers many deployment strategies.

[DBIx::Class](https://metacpan.org/pod/DBIx::Class) is the first ORM to consider in Perl 5 right now. I'm partial to [KiokuDB](https://metacpan.org/pod/KiokuDB) for applications where I need persistent objects but don't need to provide a relational interface to interact with the data. The ability to use either one as a serialization backend is important.

Any of the modern frameworks or libraries or toolkits for providing the controller part of the MVC application will do. In particular, all this layer of the application needs to do is to map requests to nodes, manage concerns of user authentication and logging, invoke the fat model objects to perform their business actions, then dispatch to the view to render the appropriate information in the user interface. I like the simplicity of Dancer, but anything compatible with Plack will work for web applications.

### **A New Architecture for Perl Apps**

Here's my vision.

I run a publishing company. I want to manage a web site with information about existing and upcoming books.

I start by defining some models: a Book has a title, an ISBN, a price, one or more Authors, a short blurb, a full description, and publication date, and a cover image. An Author has a name, a biography, and an image.

For each attribute of each model, I choose two types: the type for the object attribute itself (an ISBN is a ten- or thirteen-digit number, an author is an Author object, et cetera) as well as the type for the UI (Authors display as a list of authors and they require a multiple selection UI widget to display). That author selection widget is interesting because it can be a parametric role: a role which knows how to display multiple *something*s, where that *something* is a parameter in this case constrained only to Authors.

Obviously I need some mechanism to define new UI and attribute types, but assume that the system comes with a rich set of types (password, phone number, long input, short input, et cetera) from which I can build more.

My serialization layer already knows how to serialize these models. That's part of the magic of using KiokuDB, and there are mechanisms available for DBIx::Class to perform the same mapping.

Given these models, the controller layer can create default URI mapping routes for basic CRUD operations. The HTTP verbs `PUT`, `GET`, `POST`, and `DELETE` map nicely. As well, the first URI component beneath the application itself can map to the type of model required, such that *http://example.com/awesomebooksaboutperl/authors/chromatic* obviously returns my author page. Without a unique identifier, *http://example.com/awesomebooksaboutperl/authors/* could list all authors.

With the UI information associated with models, I don't even have to write any templates to get a bare-bones UI. The system can use Moose's introspection mechanism to read all of the object attributes then bind them to HTML widgets for the appropriate display type (reading, creating, and updating). This is particularly easy with a system like Moose where another parametric role can customize the appropriate elements to render based on access controls. That is, users can update their own passwords and administrators can update anyone's passwords, but users cannot even see the password entry fields for other users. The model object decorated with this UI role can decline to make inappropriate information available to the template rendering system at all.

Even better, the UI decoration role can provide different destination output types as well, such as JSON or XML or even serialized objects themselves suitable for transportation between similar systems.

I care most about HTML for this web application, but it's nice to have a JSON or Atom view of my data, especially because I can define another route (or perhaps you get this by adding an attribute to your models) which generates syndication information automatically; if I add a new book, it's part of the *http://example.com/awesomeperlbooks/comingsoon.xml* Atom feed. Internally, the controller might map that URI to *http://example.com/awesomeperlbooks/books/?view=atom;sort\_by=desc;limit=10*.

Whatever the other output options, I want my HTML to make generous use of CSS selectors, such that I have the option of customizing the result purely in CSS, where possible. (I don't mind writing custom HTML, but the less of that I have to do the better.) This is because it's possible to build a big page out of several models rendered together: each model should be able to render as a fragment, which makes Ajax applications easier to write.

Perhaps the real benefit of this system is that it can host itself, in that it's very easy to write an administrative console which allows people to define their own models and types and widgets using the system as its own interface. I'm still likely to write my own models by hand in Vim, but I don't mind customizing an HTML template fragment in a web browser window on a development server, at least if I can deploy the entire system as if I'd written it by hand to files in the filesystem.

I've discussed this system with a few people and various projects exist to make much of it work. Consider modeling, serialization, and deployment solved thanks to Moose, DBIx::Class and KiokuDB, and Plack. What's left is some middleware, some conventions for routing and mapping, and a little bit of magic UI widget binding and default templates. I wish we'd had this great technology a decade ago, but now with modern Perl we may be able to create a postmodern fat-model MVC web framework that makes the easy things trivial, the hard things easy, and the annoying things wonderful.
