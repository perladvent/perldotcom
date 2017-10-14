{
   "date" : "2003-03-26T00:00:00-08:00",
   "image" : null,
   "categories" : "Windows",
   "tags" : [
      "net",
      "net",
      "perl",
      "perl-soap-applications",
      "soap-lite"
   ],
   "draft" : null,
   "thumbnail" : "/images/_pub_2003_03_26_perlanddotnet/111-dotnet_and_perl.gif",
   "description" : " Randy Ray is coauthor of Programming Web Services with Perl Abstract: One of the most common categories of questions on the SOAP::Lite mailing list is how to get Perl SOAP applications to work with .NET services. It's not that...",
   "slug" : "/pub/2003/03/26/perlanddotnet.html",
   "title" : "Five Tips for .NET Programming in Perl",
   "authors" : [
      "randy-ray"
   ]
}





*Randy Ray is coauthor of [Programming Web Services with
Perl](http://www.oreilly.com/catalog/pwebserperl/)*

*Abstract: One of the most common categories of questions on the
`SOAP::Lite` mailing list is how to get Perl SOAP applications to work
with .NET services. It's not that Perl and `SOAP::Lite` are not suited
to the job, but rather that there are easy traps to fall into. Add to
that the fact that .NET has its own distinct philosophy toward
applications, and the confusion is understandable. This article will
cover some of the most common traps and considerations that trip up Perl
developers.*

### The .NET Attraction

When Microsoft first announced its .NET initiative and the variety of
technologies that would be created to support it, it was met with some
skepticism. Reactions ranged from "they're at it again" to "this could
potentially be really powerful." Right now, the reality is sitting
somewhere in between, but it is gradually moving from the realm of "just
another Microsoft gimmick" to widespread acceptance. Whatever else the
.NET concept accomplishes, it is already bringing Web services to the
general desktop arena.

One of the limiting factors to the larger acceptance of .NET has been
the limited set of fully supported languages. Microsoft promotes its C\#
language, while also providing .NET-enabled development tools and
environments for the other languages that its Visual Studio product
supports--Java, C++, and Visual Basic. Because .NET is based on several
published standards, other tools that are not generally .NET-centric are
still useful, and provide alternatives to the Microsoft tools for some
languages, primarily Java.

The main XML concepts to keep in mind when dealing with a .NET service
are XML Schema and WSDL, the Web Services Definition Language. A .NET
service automatically generates a WSDL description of itself as a part
of the tool environment that Microsoft provides. This is a powerful
feature, and the key to interoperability with other languages. WSDL
itself defers the definition of complex datatypes to the XML Schema
application, which describes both document structure and the nature of
the content itself.

Unfortunately, Perl has been largely overlooked in the tools arena where
.NET is concerned. Even though the purpose of basing .NET on open
standards was to enable wider integration with other tools, systems, and
languages, the only .NET product for Perl currently available is a
Visual Studio plug-in for Perl that runs on only Microsoft-based
platforms. As the number of .NET services grows, so will the desire to
access these services from Perl clients, often on platforms that don't
support Visual Studio. The key to doing this lies in the fact that .NET
services natively support SOAP as an interface, through the WSDL
descriptions.

### The Tips & Tricks

The rest of this article offers five hints and help on writing these
clients in Perl, using the `SOAP::Lite` toolkit.

1.  **Identify and Qualify**

    The first, and most common, mistake that Perl clients make is to
    forget that .NET interfaces are strongly typed and use named
    arguments. Perl does neither of these things by default. In fact,
    when dealing with a SOAP service that is written in Perl, most of
    the time a client doesn't have to worry about things such as
    parameter name or type. A .NET service is strict about the names and
    types (and namespace URIs) of the arguments.

    For example, imagine a service that provides the current time,
    possibly adjusted for time zone. The call, `getCurrentTime`, may be
    called with no arguments for the time in UTC (Universal Coordinated
    Time), or it may be passed a single argument, `zone`, the specified
    time zone for which the time should be adjusted. It expects this
    argument to be of type `string` (using the definition of that basic
    type from the XML Schema specification). But simply passing the
    argument to a call won't get the name right. Instead, `SOAP::Lite`
    will create a generic name for the parameter when it creates the
    actual XML, and .NET will reject it.

    To get around this, use the `SOAP::Data` class that is a part of
    `SOAP::Lite` (it is in the same module, so you don't have to load a
    second library):

         $arg = SOAP::Data->new(name => 'zone', value => 'PST');
            

    `SOAP::Lite` will properly identify values like "PST" (Pacific
    Standard Time) or "CDT" (Central Daylight Time) as being strings.
    But what if the interface also accepts numerical offsets like
    "-0800" or "+1100"? Without explicit casting as strings, those
    values would be encoded as `int` values. And the service would
    reject them.

    The `SOAP::Data` class covers this as well:

         $arg = SOAP::Data->new(name => 'zone', value => 'PST', type => 'xsi:string');
            

    (The *xsi:* prefix on the type refers to the XML Schema Instance
    namespace, which `SOAP::Lite` always defines and associates with
    that specific identifier.)

    The `SOAP::Data` class provides methods for all aspects of the data
    item: `name`, `value`, `type`, and so on. It also provides `uri` to
    specify the namespace URI (when needed), and `encodingStyle` to
    specify the URI that identifies an alternative encoding from that
    being used in the rest of the request.

2.  **Be Careful About Namespaces**

    The XML namespaces used on elements are just as important in a .NET
    service as the name and type are. SOAP relies on namespaces to
    distinguish parts from each other, but again the relaxed nature of
    Perl can mean that Perl-based services lure you into a false sense
    of ease that .NET doesn't share.

    Unfortunately, `SOAP::Lite` makes this harder for .NET applications
    by defaulting to no namespace for elements when none is explicitly
    given. Luckily, the `SOAP::Data` class includes a method for
    defining the namespace as well:

         $arg->url('http://use.perl.org/Slash/Journal/SOAP');
            

    Explicitly providing the namespace gets even more important when
    encoding complex types such as hashes and arrays.

3.  **Use Classes and Objects to Control Encoding**

    The default methods that `SOAP::Lite` uses to encode arrays and hash
    tables will not produce the style of XML that a .NET service is
    expecting. `SOAP::Lite` will base things on the plainest, most
    vanilla-type descriptions in the SOAP specification itself, while
    .NET uses complex types as defined in XML Schema for elements that
    are not basic data.

    Suppose a .NET interface defines a complex type it called
    **CodeModuleDef**. This type has (for now) three simple elements:
    the *name* of the module, the *language* it is in, and the *lines*
    of code. Now imagine the remote method **registerModule** expects
    one such object as an argument. This *won't* work:

         $soap->registerModule(SOAP::Data->name('module')->uri->('http://...')->
                               value({ name => 'SOAP::Lite', language => 'perl',
                                       lines => 4973 }));
            

    The receiving server will get an element typed as "SOAPStruct" in
    the default namespace for unknown types
    (http://xml.apache.org/xml-soap). While setting the name and URI
    were OK, the type will still stop things dead in their tracks.
    Instead, do this:

         $soap->registerModule(SOAP::Data->name('module')->uri->('http://...')->
                               value(bless { name => 'SOAP::Lite',
                                             language => 'perl',
                                             lines => 4973 }, 'CodeModuleDef'));
            

    The resulting structure will have the correct type attribute set.
    The same approach can be used for array references and scalars that
    are types other than the basic types.

4.  **Oops ... Watch Out for Element Order and Namespaces**

    This actually won't quite bridge the gap all the way. There are two
    problems with it. One is a general Perl feature, the other may be a
    bug with `SOAP::Lite`.

    The first problem is that XML Schema generally requires the elements
    of a complex type to be in a well-defined order (there's one type of
    compound structure that doesn't require this, but it isn't a
    commonly used). Perl, by nature, doesn't preserve a specific order
    to hash keys. You can use the **Tie::IxHash** module, if you know
    you will always insert the keys in the correct order. Or, you can
    provide your own serialization code for `SOAP::Lite` to use. As it
    happens, this will allow you to fix the second problem, too. The
    second problem stems from the fact that `SOAP::Lite` assigns the
    correct namespace to the outer element of the structure, but not to
    the inner elements. In a schema-based type, all the elements must be
    in the same namespace. This may be a bug in `SOAP::Lite`, but that
    hasn't been determined for certain (it seems like an unusual
    feature). The inner elements are in fact given no namespace at all.

    What is needed is a function that can be given to the serializer to
    use when it encounters an object of any of the special classes. This
    routine won't have to actually produce XML, `SOAP::Lite` will still
    take care of that. This routine will only have to produce a
    structure that the serializer will understand from the object it is
    given. A filter, in other words. To do that, two things are needed:
    an explicit declaration of the field-order, and an understanding of
    how the serializer expects to call this filter, and what it expects
    to be returned by it.

    The explicit ordering is simple; it can be an array declared in the
    class namespace, or a "private" key on the hash itself. Unlocking
    the second piece took some digging around into the internals of the
    `SOAP::Lite` source code. Connecting the two took even more digging.

    For the example approach below, assume that any class that will use
    this generic serialization filter defines an array called `@FIELDS`
    as a package-global value. Warning: This approach may be a little
    hard to wrap one's brain around at first. We'll explain it after the
    code:

         sub serialize_complex_type {
           my ($soap, $obj, $name, $type, $attr) = @_;

           my @fields = do { no strict 'refs'; @{ref($obj) . '::FIELDS'} };
           if ($name =~ /^(\w+):(\w+)$/) {
             $name = $2;
             $attr->{xmlns} = $attr->{"xmlns:$1"};
             delete $attr->{"xmlns:$1"};
           } else {
             $attr->{xmlns} = $attr->{uri};
           }

           [ $name, $attr,
           [ map { defined($obj->{$_}) ?
                   $soap->encode_object($obj->{$_}, $_) : () }
             @fields ] ];
         }
            

    Additionally, every package that plans to use it to serialize their
    objects will have to make it visible to the `SOAP::Serializer`
    package:

         *SOAP::Serializer::as_Some__Class = \&main::serialize_complex_type;
            

    Here, we assumed a class name of `Some::Class`, and that the earlier
    code was declared in the main namespace. So what does it all do?

    The serializing routine is called by an object derived from
    `SOAP::Serializer` (or a subclass of it), as a method with the
    object to serialize, its name, its type, and the hash table of
    attributes as arguments. It expects to get back an array reference
    with three or four values. The first is the tag name to use. The
    second is the hash reference of attributes to add to the opening
    tag, and the third is either an array reference of nested content,
    or a simple scalar value to be put inside the opening and closing
    tag pair. The fourth element, should you include it, is a value for
    an "ID" attribute. This is used to uniquely identify an element, for
    the sake of multiple references and such. We don't worry about it
    here.

    So we take the arguments as they are given, and the first thing the
    routine does is check for a name that includes a namespace. Since
    the style of `SOAP::Lite` will leave any child elements unqualified,
    the namespace label is stripped and the URI itself is assigned to
    the simple `xmlns` attribute. This will make it apply to any child
    elements of this object. If the object contains other objects as
    children, then they too will be run through this serializer, so they
    will have the chance to declare a namespace in the same way. If
    there was no label, then we take the value of the `uri` attribute,
    which would have been set by calling the `SOAP::Data` method of the
    same name. Finally, we build the array reference using the (possibly
    modified) `$name`, the modified attribute hash reference and an
    array reference of the object's elements, in field order.

    We got the field order by using a symbolic reference to the
    `@FIELDS` array for the object's class. Much the same sort of trick
    is needed to get the `SOAP::Serializer` class to use this code. When
    handed a blessed object, the serializer takes the class name,
    changes all "::" to "\_\_", and prepends "as\_" to the result. It
    then looks for a method by that name. It searches using the
    serialization object itself, so the method has to be visible to that
    class. Right now, there isn't a way in `SOAP::Lite` to do this more
    directly. To hook this serialization into place, we directly alias
    "as\_Some\_\_Class" into the needed package, as shown above.

    Note that the recursive encoding of the object's contents (which may
    be objects themselves) is handled by a `SOAP::Serializer` method
    called "`encode_object`." This is an undocumented part of the
    serializer that was the source of much of the logic for the code
    snippet above. It was by examining this routine that the above code
    (in a slightly different form) was used in writing a complex client
    to use the MapPoint.NET service, one of Microsoft's commercial .NET
    services.

5.  **Play with `stubmaker.pl` and `SOAPsh.pl`**

    For the last tip, a more simple piece of advice. The `SOAP::Lite`
    package comes with a number of utility scripts. Among these are a
    "shell" for testing SOAP services, called `SOAPsh.pl`, and a
    code-generation tool for generating classes from WSDL description
    files, called `stubmaker.pl`.

    As was mentioned earlier, WSDL plays a major role in the definition
    and the documentation of .NET services. The `stubmaker.pl` tool
    tries to create Perl classes based on a WSDL document. It does a
    fairly good job, but it lacks in support for XML Schema. If a
    service uses any nonbasic types, then the template that
    `stubmaker.pl` generates would not handle it as well.

    This should not prevent you from using the tool. It does a lot of
    the heavy lifting by extracting the proper namespace URLs, actual
    server URLs, and remote method names. Even if the code template
    itself cannot be used directly, then it could still save you work.

### Summary

There is much more to properly dealing with .NET services than can be
addressed in a single article. The goal here is to head off some of the
more frequently encoutered problems, and let you as the developer focus
on more important issues.

One of the biggest drawbacks to using Perl for .NET is that there is
only limited support at present for WSDL and XML Schema. Some new CPAN
modules are working to fill these gaps, but they are in early stages of
functionality. For now, it is still necessary to do some of the core
steps manually. This situation should improve over time.

As a last "bonus" tip, remember this: Much of the advice here is just as
important for writing .NET services, as it is for writing .NET clients.
For the next Web service you write, consider the additional client base
you would have access to if you wrote it to be compatible with .NET.

------------------------------------------------------------------------

O'Reilly & Associates recently released (December 2002) [Programming Web
Services with Perl](http://www.oreilly.com/catalog/pwebserperl/).

-   [Sample Chapter 6, Programming
    SOAP](http://www.oreilly.com/catalog/pwebserperl/chapter/index.html),
    is available free online.

-   You can also look at the [Table of
    Contents](http://www.oreilly.com/catalog/pwebserperl/toc.html), the
    [Index](http://www.oreilly.com/catalog/pwebserperl/inx.html), and
    the [Full
    Description](http://www.oreilly.com/catalog/pwebserperl/desc.html)
    of the book.

-   For more information, or to order the book, [click
    here](http://www.oreilly.com/catalog/pwebserperl/).


