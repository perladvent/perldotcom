{
   "authors" : [
      "matt-sergeant"
   ],
   "draft" : null,
   "description" : " In your time as a Perl programmer, it becomes almost inevitable that at some point you will have to manage in-memory tree structures of some sort. When you do this, it becomes important to be aware of how Perl...",
   "slug" : "/pub/2002/08/07/proxyobject.html",
   "image" : null,
   "title" : "Proxy Objects",
   "categories" : "development",
   "date" : "2002-08-07T00:00:00-08:00",
   "thumbnail" : "/images/_pub_2002_08_07_proxyobject/111-proxy_objects.gif",
   "tags" : [
      "proxy-objects-pattern-circular-references"
   ]
}



In your time as a Perl programmer, it becomes almost inevitable that at some point you will have to manage in-memory tree structures of some sort. When you do this, it becomes important to be aware of how Perl manages memory, and when you might come up against a situation where Perl will not free its memory -- a situation that can happen easily ... as we'll see below.

In writing the [`XML::XPath`]({{<mcpan "XML::XPath" >}}) module, (a library that implements some of the XML Document Object Model, or DOM) I came across a particular problem with Perl's memory-management mechanism. In this article, I will detail the problem and demonstrate a technique for building data structures that do not exhibit this problem.

The problem is circular references.

#### <span id="What is a circular reference?">What Is a Circular Reference?</span>

Circular references are simply self-referential data structures -- a complex data structure that at some point contains a reference to a part of itself further up in the hierarchy. They are a useful idiom when you need two parts of a structure to be able to refer to each other -- often we see them used in parent/child relationships, where a child object might need access to the methods in the parent:

![figure 1](/images/_pub_2002_08_07_proxyobject/circular_ref.png)
The case we're concerned with here is an XML tree, where we have a root node, and each node can have one or more children. In an XML DOM, the child nodes need the ability to refer back to their parents:

    my $parent_name = $node->getParentNode()->getNodeName();

While it is often extremely useful to encode this type of relationship in your code, it is rather problematic for Perl.

#### <span id="Reference Counting">Reference Counting</span>

Before we see why circular references are problematic, first we need to understand how Perl's memory management works. In order to return memory for use by other parts of your program when it becomes available, Perl uses a technique called "reference counted garbage collection".

By using a count on each variable within Perl of the number of references to that variable (the number of other things in your program that refer to it), Perl's garbage collector can ensure timely destruction of lexical variables (those created with `my`). Each time the Perl interpreter sees something referencing that variable, it increments the variable's internal reference count. When the reference count goes down to zero, that variable's memory is freed, and its destructor is called.

You can see the reference count of a variable using the `Devel::Peek` module:

    use Devel::Peek;
    my $x = "Hello";
    my $y = \$x;
    Dump($x);

Which outputs:

    SV = PV(0x804b85c) at 0x8057620
      REFCNT = 2
      FLAGS = (PADBUSY,PADMY,POK,pPOK)
      PV = 0x805d800 "Hello"\0
      CUR = 5
      LEN = 6

The important field for these purposes is the REFCNT field, which shows us there are two references to our variable - one for the *main* copy of the variable (the one we see as `$x`) and one for the *reference* that `$y` holds.

#### <span id="Reference Counting with Circular References">Reference Counting with Circular References</span>

Reference counting works well until you need to build self-referencing data structures. Let's look again at the design of our XML DOM library, where children need access to their parent nodes. The DOM specification requires you to maintain a two-way relationship between the parent and the child nodes. This leads to our *circular reference* -- the parent holds a reference to the child, and the child holds a reference to the parent.

##### <span id="Circular References in Detail">Circular References in Detail</span>

Circular references occur when a variable either directly or indirectly refers to itself somehow. We can easily show this using hash references and Devel::Peek again:

    use Devel::Peek;
    for (1..1) { # enter scope here
      my %x = ();
      my %y = ();
      $x{child} = \%y;
      $y{parent} = \%x;
      Dump(\%x);
    } # leave scope here

Now we can see that both variables have a refcount of 2 (the 3 for %x is because we have to take an extra reference in order to `Dump()` it):

    ...
    SV = PVHV(0x8060b40) at 0x805702c
      REFCNT = 3               ### This is %x
      ...
      Elt "child" HASH = 0x77420b6
      SV = RV(0x8063008) at 0x804b494
        REFCNT = 1
        FLAGS = (ROK)
        RV = 0x8056fe4
        SV = PVHV(0x8060ba0) at 0x8056fe4
          REFCNT = 2           ### This is %y
          ...
          Elt "parent" HASH = 0xcc03940
          SV = RV(0x806300c) at 0x8056f84
            REFCNT = 1
            FLAGS = (ROK)
            RV = 0x805702c

Now problems arise. When `%y` goes out of scope, it cannot be completely garbage collected, because its reference count was 2, not 1. `%x` also cannot be garbage collected (if it could, then it would free the extra reference to `%y`) for the same reason. So we end up with two zombie variables, which can neither be garbage collected nor freed back to the system. This is why we get what appears to be memory leaks when we use circular references. Had we modified our `for ()` loop to repeat more than once, we would see our memory usage steadily growing.

Rather than proving this by watching our memory grow though, we can demonstrate what his happening with *objects*. We can create a simple object and output something in its `DESTROY` method:

    package CircObj;
    sub new { bless {}, shift }
    sub parent { my $self = shift; @_ ? $self->{parent} =
        shift : $self->{parent} }
    sub child { my $self = shift; @_ ? $self->{child} =
        shift : $self->{child} }
    sub DESTROY { warn("CircObj::DESTROY\n") }

Now a normal instance of this will output the destroy method as soon as its scope exits:

    {
      my $x = CircObj->new();
      warn("Leaving scope\n");
    }
    warn("Scope left\n");

Results in the following output:

    Leaving scope
    CircObj::DESTROY
    Scope left

However, if we fill in our circular references, then we get a different result:

    for (1..1) {
      my $parent = CircObj->new;
      my $child = CircObj->new;
      $parent->child($child);
      $child->parent($parent);
      warn("Leaving scope\n");
    }
    warn("Scope left\n");

And we see the output:

    Leaving scope
    Scope left
    CircObj::DESTROY
    CircObj::DESTROY

What this means is our variables are only getting `DESTROY`ed when the Perl interpreter does its global cleanup -- at the time our program exits, not in the timely manner we are used to with normal objects. This may not be too problematic for some scripts, but if you're running any sort of large program, or a long-running persistent interpreter like `mod_perl`, then you will see your memory steadily grow as you do this repeatedly.

A common way to "fix" this problem is to use a manual destructor -- a method or function call that breaks the circle somehow. In our original hashes example, this is as simple as adding `delete $x{child}` to our code (deleting `$y{parent}` is optional then, as the circle is already broken), and in the object example we can supply a `destroy()` method that the user can call before exiting the scope. But neither of those options is terribly user friendly, and I believe in letting people who use my modules to expect it to "just work".

### <span id="Fixing Circular References - with Perl 5.6+">Fixing Circular References - with Perl 5.6+</span>

Perl 5.6.0 introduced a new feature to "fix" all of the problems with circular references. This feature is called *weakrefs*. The basic idea is to flag a reference as *weakened*, so as to not include it in the reference counting. In order to use weakrefs, you need to install the [Scalar::Util]({{<mcpan "Scalar::Util" >}}) module (which is included with Perl 5.8.0). It is simple to use. Let's see what happens with our example above:

    package CircObj;
      use Scalar::Util qw(weaken);
      sub new { bless {}, shift }
      sub parent { my $self = shift; @_ ? weaken($self->{parent} =
           shift) : $self->{parent} }
      sub child { my $self = shift; @_ ? $self->{child} =
           shift : $self->{child}
      }
      sub DESTROY { warn("CircObj::DESTROY\n") }

      for (1..1) {
        my $parent = CircObj->new;
         my $child = CircObj->new;
         $parent->child($child);
         $child->parent($parent);
         warn("Leaving scope\n");
      }
    warn("Scope left\n");

It's important to note that we only need to weaken our parent reference -- since one reference is OK. But this time, it outputs the expected:

    Leaving scope
    CircObj::DESTROY
    CircObj::DESTROY
    Scope left

The `weaken` method is well-proven, and is a stable way to ensure that circular references don't mess up the operation of Perl's garbage collector. You should definitely use them if you can -- for example in your in-house code.

However, that still leaves CPAN module authors and those stuck with Perl 5.005 with a problem: what do we do with older versions of Perl?

### <span id="Fixing Circular References - with Perl 5.00503 and lower">Fixing Circular References - with Perl 5.00503 and Lower</span>

Anyone who works for a large company, or who puts out open-source Perl modules, will know that there are still an awful lot of people using Perl 5.00503 -- upgrading takes time, and many people are running older OS's that only come with Perl 5.00503.

So we have to get inventive -- we need some proxy objects.

Proxy objects are a way to access objects indirectly via another object. The term proxy object is from the Design Patterns book (<http://hillside.net/patterns/DPBook/DPBook.html>). A proxy object works by being an intermediary between an object and its methods -- passing all communication on to the real object, perhaps after doing something based on the method called. We can implement a basic proxy object in Perl using AUTOLOAD:

    package ProxyObject;

    sub new {
      my $class = shift;
      my $real_obj = shift;
      my $self = { real_obj => $real_obj };
      return bless $self, $class;
    }

    sub AUTOLOAD {
      my $self = shift;
      my $method = $AUTOLOAD;
      $method =~ s/.*:://;
      warn("Proxying: $method\n");
      $self->{real_obj}->$method(@_);
    }

    1;

And we can use that as follows:

    use ProxyObject;
    use Time::localtime;
    my $time = localtime();
    ### Create a localtime object
    my $proxy = ProxyObject->new($time);
    ### Create a proxy to that object
    print $time->hour, " is the same as ", $proxy->hour, "\n";

Which gives us the output:

    Proxying: hour
    14 is the same as 14
    Proxying: DESTROY

So, this all looks very interesting, but you're probably wondering how that helps with circular references. Well, let's look at a circular-reference example that uses ProxyObject:

    package CircObj;
    sub new { bless {}, shift }
    sub parent { my $self = shift; @_ ? $self->{parent} =
         shift : $self->{parent} }
    sub child { my $self = shift; @_ ? $self->{child} =
         shift : $self->{child} }
    sub DESTROY { warn("CircObj::DESTROY\n") }

    use ProxyObject;
    for (1..1) {
      my $parent = CircObj->new;
      my $child = CircObj->new;
      my $proxy = ProxyObject->new($parent);
      $parent->child($child);
      $child->parent($parent);
      warn("Leaving scope\n");
    }
    warn("Scope left\n");

Now what we see from our output is:

    Leaving scope
    Proxying: DESTROY
    CircObj::DESTROY
    Scope left
    CircObj::DESTROY
    CircObj::DESTROY

So we have made some progress; the DESTROY method on our `$parent` variable is now called, albeit twice. But what we can do now is use that call to DESTROY to break our reference loop. To do this, we implement a small DESTROY method in our class that clears out the circular reference:

    package CircObj;
    ...
    sub DESTROY {
      my $self = shift;
      warn("CircObj::DESTROY\n");
      if ($self->{child}) {
        $self->{child}->parent(undef);
        # set child's parent to undef, breaking the loop
      }
    }

Which finally leads to the desired output:

    Leaving scope
    Proxying: DESTROY
    CircObj::DESTROY
    CircObj::DESTROY
    CircObj::DESTROY
    Scope left

Of course, this being Perl, it is possible to wrap all of this up into a fairly simple class, which I'll demonstrate in the next section.

#### <span id="Problems With This Technique">Problems With This Technique</span>

There is one major problem with this technique: It's possible to confuse the garbage collector with it. The easiest way to see this happen is if you build a tree using the above technique, and then hold onto a sub-tree while letting the root of the tree go out of scope. All of a sudden you'll find your data structure has become untangled, like so much wool from a snagged jumper. Unfortunately, there's little you can do about this, except perhaps for allowing the use of a proxy object as an option, and providing a method for freeing the tree that manually breaks the links. This is what XML::XPath does: By specifying `$XML::XPath::SafeMode = 1` at runtime, you can switch this behavior on and off.

Another problem is that every property access now needs to go through method calls. If you have the proxy object (which is just a simple hash ref in this example, but could be a scalar ref), then you can't try and access the hash entries directly and expect to get those in the object we are proxying to. You may be able to get this working via the TIE mechanism, but it doesn't come for free. So we potentially lose some speed this way, though you should be using methods anyway for the sake of encapsulation.

### <span id="Doing The Right Thing">Doing the Right Thing</span>

What we can now do (in true Blue Peter fashion) is create a module that has totally transparent weak-references support on Perl 5.6, while still allowing garbage collection on lower Perl versions. This is a little more complex than the scenario above, but here's how it works. First, we create a base class that our complex data-structure classes can subclass:

    # base class for all circular reffing classes
    # rename this before use
    package BaseClass;
    use strict;

In that class we do some compile-time checking for Scalar::Util:

    BEGIN {
      eval "use Scalar::Util qw(weaken);";
      if ($@) {
        $BaseClass::WeakRefs = 0;
      }
      else {
        $BaseClass::WeakRefs = 1;
      }
    }

Next, we create a clever constructor. This constructor turns our class name (e.g. "XML::MyDOM::Node") into an implementation class name ("XML::MyDOM::NodeImpl"), and constructs an object of that type. Then if weak refs are available, then it returns that object, otherwise it constructs a proxy object that proxies to that object, and returns the proxy object instead:

    sub new {
      my $class = shift;
      no strict 'refs';
      my $impl = $class . "Impl";
      my $this = $impl->new(@_);
      if ($BaseClass::WeakRefs) {
        return $this;
      }
      my $self = \$this;
      return bless $self, $class;
    }

Finally, we have a more advanced version of our proxy object's AUTOLOAD method. This does some error checking to ensure that unknown methods are detected correctly, and that methods on this class are executed in the correct way. But otherwise it's doing exactly the same job as our original:

    sub AUTOLOAD {
      my $method = $AUTOLOAD;
      $method =~ s/.*:://; # strip the package name
      no strict 'refs';
      *{$AUTOLOAD} = sub {
        my $self = shift;
        my $olderror = $@; # store previous exceptions
        my $obj = eval { $$self };
        if ($@) {
          if ($@ =~ /Not a SCALAR reference/) {
            croak("No such method $method in " . ref($self));
          }
          croak $@;
        }
        if ($obj) {
          # make sure $@ propogates if this method call was the result
          # of losing scope because of a die().
          if ($method =~ /^(DESTROY|del_parent_link)$/) {
            $obj->$method(@_);
            $@ = $olderror if $olderror;
            return;
          }
          return $obj->$method(@_);
        }
      };
      goto &$AUTOLOAD;
    }

    package BaseClassImpl; # Implementation class

    sub new { die "Virtual base class" }

    # All base class methods go below here

    1;

Now, all classes derived from that need to look like this:

    package CircRefClass;
    @ISA = ('BaseClass');

    package CircRefClassImpl;
    @ISA = ('BaseClassImpl', 'CircRefClass');

    sub new {
      my $class = shift;
      # ordinary constructor here
      my $self = bless {}, $class;
      # ... yada yada yada
      return $self;
    }

    sub DESTROY {
      my $self = shift;
      # Break child's link to me here
      $self->child->del_parent_link();
    }

    sub set_parent {
      my $self = shift;
      if ($BaseClass::WeakRefs) {
        Scalar::Util::weaken($self->{parent} = shift);
      }
      else {
        $self->{parent} = shift;
      }
    }

    sub del_parent_link {
      my $self = shift;
      $self->{parent} = undef;
    }

    # All class methods here

    1;

And that's about all you need to change. The rest of your methods can remain the same, as long as they are moved to the `PackageImpl` class, rather than the `Package` class. And this will auto-detect the presence of Scalar::Util's `weakref()` method and use it accordingly if it's available.

The complicated work is in the `AUTOLOAD` class in the `BaseClass` package. The reason it looks so complex is because it implements a method cache for autoloaded methods, ensuring that this implementation won't slow down your program.

Also note that you can rename the `del_parent_link` and `set_parent` methods if those names aren't appropriate for your application. They just happen to work for a tree structure.

### <span id="Conclusions">Conclusions</span>

Circular references are a useful tool, and sometimes a neccessary evil. By using methods available to Perl 5.6 and up, combined with a custom proxying technique, we can create classes that implement circular references while still managing to be garbage collected on all versions of Perl. This is a powerful design to add to your Perl programmer's toolbox.
