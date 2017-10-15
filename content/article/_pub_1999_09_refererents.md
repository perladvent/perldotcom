{
   "draft" : null,
   "authors" : [
      "damian-conway"
   ],
   "description" : " Introduction Damian Conway is the author of the newly released Object Oriented Perl, the first of a new series of Perl books from Manning. Object-oriented programming in Perl is easy. Forget the heavy theory and the sesquipedalian jargon: classes...",
   "slug" : "/pub/1999/09/refererents.html",
   "title" : "Bless My Referents",
   "image" : null,
   "categories" : "development",
   "date" : "1999-09-16T00:00:00-08:00",
   "thumbnail" : null,
   "tags" : []
}



### Introduction

*Damian Conway is the author of the newly released [Object Oriented Perl](https://www.manning.com/books/object-oriented-perl), the first of a new series of Perl books from Manning.*

Object-oriented programming in Perl is easy. Forget the heavy theory and the sesquipedalian jargon: classes in Perl are just regular packages, objects are just variables, methods are just subroutines. The syntax and semantics are a little different from regular Perl, but the basic building blocks are completely familiar.

The one problem most newcomers to object-oriented Perl seem to stumble over is the notion of references and referents, and how the two combine to create objects in Perl. So let's look at how references and referents relate to Perl objects, and see who gets to be blessed and who just gets to point the finger.

Let's start with a short detour down a dark alley...

### References and referents

Sometimes it's important to be able to access a variable indirectly— to be able to use it without specifying its name. There are two obvious motivations: the variable you want may not *have* a name (it may be an anonymous array or hash), or you may only know which variable you want at run-time (so you don't have a name to offer the compiler).

To handle such cases, Perl provides a special scalar datatype called a *reference*. A reference is like the traditional Zen idea of the "finger pointing at the moon". It's something that identifies a variable, and allows us to locate it. And that's the stumbling block most people need to get over: the finger (reference) isn't the moon (variable); it's merely a means of working out where the moon is.

### Making a reference

When you prefix an existing variable or value with the unary \\ operator you get a reference to the original variable or value. That original is then known as the *referent* to which the reference refers.

For example, if $s is a scalar variable, then \\$s is a reference to that scalar variable (i.e. a finger pointing at it) and $s is that finger's referent. Likewise, if @a in an array, then \\@a is a reference to it.

In Perl, a reference to any kind of variable can be stored in another scalar variable. For example:

    $slr_ref = \$s;     # scalar $slr_ref stores a reference to scalar $s
    $arr_ref = \@a;     # scalar $arr_ref stores a reference to array @a
    $hsh_ref = \%h;     # scalar $hsh_ref stores a reference to hash %h

Figure 1 shows the relationships produced by those assignments.
Note that the references are separate entities from the referents at which they point. The only time that isn't the case is when a variable happens to contain a reference to itself:

    $self_ref = \$self_ref;     # $self_ref stores a reference to itself!

That (highly unusual) situation produces an arrangement shown in Figure 2.
Once you have a reference, you can get back to the original thing it refers to—it's referent—simply by prefixing the variable containing the reference (optionally in curly braces) with the appropriate variable symbol. Hence to access $s, you could write $$slr\_ref or ${$slr\_ref}. At first glance, that might look like one too many dollar signs, but it isn't. The $slr\_ref tells Perl which variable has the reference; the extra $ tells Perl to follow that reference and treat the referent as a scalar.

Similarly, you could access the array @a as @{$arr\_ref}, or the hash %h as %{$hsh\_ref}. In each case, the $whatever\_ref is the name of the scalar containing the reference, and the leading @ or % indicates what type of variable the referent is. That type is important: if you attempt to prefix a reference with the wrong symbol (for example, @{$slr\_ref} or ${$hsh\_ref}), Perl produces a fatal run-time error.

<img src="/images/_pub_1999_09_refererents/refs.gif" alt="[A series of scalar variables with arrows pointing to other variables]" width="450" height="267" />
**Figure 1: References and their referents**

<img src="/images/_pub_1999_09_refererents/selfref.gif" alt="[A scalar variable with an arrow pointing back to itself]" width="250" height="147" />
**Figure 2: A reference that is its own referent**

### The "arrow" operator

Accessing the elements of an array or a hash through a reference can be awkward using the syntax shown above. You end up with a confusing tangle of dollar signs and brackets:

    ${$arr_ref}[0] = ${$hsh_ref}{"first"};  # i.e. $a[0] = $h{"first"}

So Perl provides a little extra syntax to make life just a little less cluttered:
    $arr_ref->[0] = $hsh_ref->{"first"};    # i.e. $a[0] = $h{"first"}

The "arrow" operator (-&gt;) takes a reference on its left and either an array index (in square brackets) or a hash key (in curly braces) on its right. It locates the array or hash that the reference refers to, and then accesses the appropriate element of it.
### Identifying a referent

Because a scalar variable can store a reference to any kind of data, and because dereferencing a reference with the wrong prefix leads to fatal errors, it's sometimes important to be able to determine what type of referent a specific reference refers to. Perl provides a built-in function called ref that takes a scalar and returns a description of the kind of reference it contains. Table 1 summarizes the string that is returned for each type of reference.

|                                      |                                    |
|--------------------------------------|------------------------------------|
| **If $slr\_ref contains...**         | **then ref($slr\_ref) returns...** |
| a scalar value                       | undef                              |
| a reference to a scalar              | "SCALAR"                           |
| a reference to an array              | "ARRAY"                            |
| a reference to a hash                | "HASH"                             |
| a reference to a subroutine          | "CODE"                             |
| a reference to a filehandle          | "IO" or "IO::Handle"               |
| a reference to a typeglob            | "GLOB"                             |
| a reference to a precompiled pattern | "Regexp"                           |
| a reference to another reference     | "REF"                              |

**Table 1: What ref returns**
As Table 1 indicates, you can create references to many kinds of Perl constructs, apart from variables.

If a reference is used in a context where a string is expected, then the ref function is called automatically to produce the expected string, and a unique hexadecimal value (the internal memory address of the thing being referred to) is appended. That means that printing out a reference:

    print $hsh_ref, "\n";

produces something like:
    HASH(0x10027588)

since each element of print's argument list is stringified before printing.
The ref function has a vital additional role in object-oriented Perl, where it can be used to identify the class to which a particular object belongs. More on that in a moment.

### References, referents, and objects

References and referents matter because they're both required when you come to build objects in Perl. In fact, Perl objects are just referents (i.e. variables or values) that have a special relationship with a particular package. References come into the picture because Perl objects are always accessed via a reference, using an extension of the "arrow" notation.

But that doesn't mean that Perl's object-oriented features are difficult to use (even if you're still unsure of references and referents). To do real, useful, production-strength, object-oriented programming in Perl you only need to learn about one extra function, one straightforward piece of additional syntax, and three very simple rules. Let's start with the rules...

### Rule 1: To create a class, build a package

Perl packages already have a number of class-like features:

-   They collect related code together;
-   They distinguish that code from unrelated code;
-   They provide a separate namespace within the program, which keeps subroutine names from clashing with those in other packages;
-   They have a name, which can be used to identify data and subroutines defined in the package.

In Perl, those features are sufficient to allow a package to act like a class.
Suppose you wanted to build an application to track faults in a system. Here's how to declare a class named "Bug" in Perl:

    package Bug;

That's it! In Perl, classes are packages. No magic, no extra syntax, just plain, ordinary packages. Of course, a class like the one declared above isn't very interesting or useful, since its objects will have no attributes or behaviour.
That brings us to the second rule...

### Rule 2: To create a method, write a subroutine

In object-oriented theory, methods are just subroutines that are associated with a particular class and exist specifically to operate on objects that are instances of that class. In Perl, a subroutine that is declared in a particular package *is already* associated with that package. So to write a Perl method, you just write a subroutine within the package that is acting as your class.

For example, here's how to provide an object method to print Bug objects:

    package Bug;

    sub print_me
    {
           # The code needed to print the Bug goes here
    }

Again, that's it. The subroutine print\_me is now associated with the package Bug, so whenever Bug is used as a class, Perl automatically treats Bug::print\_me as a method.
Invoking the Bug::print\_me method involves that one extra piece of syntax mentioned above—an extension to the existing Perl "arrow" notation. If you have a reference to an object of class Bug, you can access any method of that object by using a -&gt; symbol, followed by the name of the method.

For example, if the variable $nextbug holds a reference to a Bug object, you could call Bug::print\_me on that object by writing:

    $nextbug->print_me();

Calling a method through an arrow should be very familiar to any C++ programmers; for the rest of us, it's at least consistent with other Perl usages:
    $hsh_ref->{"key"};           # Access the hash referred to by $hashref
    $arr_ref->[$index];          # Access the array referred to by $arrayref
    $sub_ref->(@args);           # Access the sub referred to by $subref
    $obj_ref->method(@args);     # Access the object referred to by $objref

The only difference with the last case is that the referent (i.e. the object) pointed to by $objref has many ways of being accessed (namely, its various methods). So, when you want to access that object, you have to specify which particular way—which method—should be used. Hence, the method name after the arrow.
When a method like Bug::print\_me is called, the argument list that it receives begins with the reference through which it was called, followed by any arguments that were explicitly given to the method. That means that calling Bug::print\_me("logfile") is *not* the same as calling $nextbug-&gt;print\_me("logfile"). In the first case, print\_me is treated as a regular subroutine so the argument list passed to Bug::print\_me is equivalent to:

    ( "logfile" )

In the second case, print\_me is treated as a method so the argument list is equivalent to:
    ( $objref, "logfile" )

Having a reference to the object passed as the first parameter is vital, because it means that the method then has access to the object on which it's supposed to operate. Hence you'll find that most methods in Perl start with something equivalent to this:
    package Bug;

    sub print_me
    {
        my ($self) = shift;
        # The @_ array now stores the arguments passed to &Bug::print_me
        # The rest of &print_me uses the data referred to by $self 
        # and the explicit arguments (still in @_)
    }

or, better still:
    package Bug;

    sub print_me
    {
        my ($self, @args) = @_;
        # The @args array now stores the arguments passed to &Bug::print_me
        # The rest of &print_me uses the data referred to by $self
        # and the explicit arguments (now in @args)
    }

This second version is better because it provides a lexically scoped copy of the argument list (@args). Remember that the @\_ array is "magical"—changing any element of it actually changes the *caller's* version of the corresponding argument. Copying argument values to a lexical array like @args prevents nasty surprises of this kind, as well as improving the internal documentation of the subroutine (especially if a more meaningful name than @args is chosen).
The only remaining question is: *how do you create the invoking object in the first place?*

### Rule 3: To create an object, bless a referent

Unlike other object-oriented languages, Perl doesn't require that an object be a special kind of record-like data structure. In fact, you can use *any* existing type of Perl variable—a scalar, an array, a hash, etc.—as an object in Perl.

Hence, the issue isn't how to *create* the object, because you create them exactly like any other Perl variable: declare them with a my, or generate them anonymously with a \[...\] or {...}. The real problem is how to tell Perl that such an object *belongs* to a particular class. That brings us to the one extra built-in Perl function you need to know about. It's called bless, and its only job is to mark a variable as belonging to a particular class.

The bless function takes two arguments: a reference to the variable to be marked, and a string containing the name of the class. It then sets an internal flag on the variable, indicating that it now belongs to the class.

For example, suppose that $nextbug actually stores a reference to an anonymous hash:

    $nextbug = {
                    id    => "00001",
                    type  => "fatal",
                    descr => "application does not compile",
               };

To turn that anonymous hash into an object of class Bug you write:
    bless $nextbug, "Bug";

And, once again, that's it! The anonymous array referred to by $nextbug is now marked as being an object of class Bug. Note that the variable $nextbug itself hasn't been altered in any way; only the nameless hash it refers to has been marked. In other words, bless sanctified the referent, *not* the reference. Figure 3 illustrates where the new class membership flag is set.
You can check that the blessing succeeded by applying the built-in ref function to $nextbug. As explained above, when ref is applied to a reference, it normally returns the type of that reference. Hence, before $nextbug was blessed, ref($nextbug) would have returned the string 'HASH'.

Once an object is blessed, ref returns the name of its class instead. So after the blessing, ref($nextbug) will return 'Bug'. Of course the object itself still *is* a hash, but now it's a hash that *belongs* to the Bug class. The various entries of the hash become the attributes of the newly created Bug object.

<img src="/images/_pub_1999_09_refererents/blessing.gif" alt="[A picture of an anonymous hash having a flag set within it]" width="450" height="412" />
**Figure 3: What changes when an object is blessed**

### Creating a constructor

Given that you're likely to want to create many such Bug objects, it would be convenient to have a subroutine that took care of all the messy, blessy details. You could pass it the necessary information, and it would then wrap it in an anonymous hash, bless the hash, and give you back a reference to the resulting object.

And, of course, you might as well put such a subroutine in the Bug package itself, and call it something that indicates its role. Such a subroutine is known as a *constructor,* and it generally looks like this:

    package Bug;
    sub new
    {
        my $class = $_[0];
        my $objref = {
                         id    => $_[1],
                         type  => $_[2],
                         descr => $_[3],
                     };
        bless $objref, $class;
        return $objref;
    }

Note that the middle bits of the subroutine (in bold) look just like the raw blessing that was handed out to $nextbug in the previous example.
The bless function is set up to make writing constructors like this a little easier. Specifically, it returns the reference that's passed as its first argument (i.e. the reference to whatever referent it just blessed into object-hood). And since Perl subroutines automatically return the value of their last evaluated statement, that means that you could condense the definition of Bug::new to this:

    sub Bug::new
    {
            bless { id => $_[1], type => $_[2], descr => $_[3] }, $_[0];
    }

This version has exactly the same effects: slot the data into an anonymous hash, bless the hash into the class specified first argument, and return a reference to the hash.
Regardless of which version you use, now whenever you want to create a new Bug object, you can just call:

    $nextbug = Bug::new("Bug", $id, $type, $description);

That's a little redundant, since you have to type "Bug" twice. Fortunately, there's another feature of the "arrow" method-call syntax that solves this problem. If the operand to the left of the arrow is the name of a class —rather than an object reference—then the appropriate method of that class is called. More importantly, if the arrow notation is used, the first argument passed to the method is a string containing the class name. That means that you could rewrite the previous call to Bug::new like this:
    $nextbug = Bug->new($id, $type, $description);

There are other benefits to this notation when your class uses inheritance, so you should always call constructors and other class methods this way.
### Method enacting

Apart from encapsulating the gory details of object creation within the class itself, using a class method like this to create objects has another big advantage. If you abide by the convention of only ever creating new Bug objects by calling Bug::new, you're guaranteed that all such objects will always be hashes. Of course, there's nothing to prevent us from "manually" blessing arrays, or scalars as Bug objects, but it turns out to make life *much* easier if you stick to blessing one type of object into each class.

For example, if you can be confident that any Bug object is going to be a blessed hash, you can (finally!) fill in the missing code in the Bug::print\_me method:

    package Bug;
    sub print_me
    {
        my ($self) = @_;
        print "ID: $self->{id}\n";
        print "$self->{descr}\n";
        print "(Note: problem is fatal)\n" if $self->{type} eq "fatal";
    }

Now, whenever the print\_me method is called via a reference to any hash that's been blessed into the Bug class, the $self variable extracts the reference that was passed as the first argument and then the print statements access the various entries of the blessed hash.
### Till death us do part...

Objects sometimes require special attention at the other end of their lifespan too. Most object-oriented languages provide the ability to specify a subroutine that is called automatically when an object ceases to exist. Such subroutines are usually called *destructors*, and are used to undo any side-effects caused by the previous existence of an object. That may include:

> -   deallocating related memory (although in Perl that's almost never necessary since reference counting usually takes care of it for you);
> -   closing file or directory handles stored in the object;
> -   closing pipes to other processes;
> -   closing databases used by the object;
> -   updating class-wide information;
> -   anything else that the object should do before it ceases to exist (such as logging the fact of its own demise, or storing its data away to provide persistence, etc.)

In Perl, you can set up a destructor for a class by defining a subroutine named DESTROY in the class's package. Any such subroutine is automatically called on an object of that class, just before that object's memory is reclaimed. Typically, this happens when the last variable holding a reference to the object goes out of scope, or has another value assigned to it.
For example, you could provide a destructor for the Bug class like this:

    package Bug;

    # other stuff as before

    sub DESTROY
    {
            my ($self) = @_;
            print "<< Squashed the bug: $self->{id} >>\n\n";
    }

Now, every time an object of class Bug is about to cease to exist, that object will automatically have its DESTROY method called, which will print an epitaph for the object. For example, the following code:
    package main;
    use Bug;

    open BUGDATA, "Bug.dat" or die "Couldn't find Bug data";

    while (<BUGDATA>)
    {
        my @data = split ',', $_;       # extract comma-separated Bug data
        my $bug = Bug->new(@data);      # create a new Bug object
        $bug->print_me();               # print it out
    } 

    print "(end of list)\n";

prints out something like this:
    ID: HW000761
    "Cup holder" broken
    Note: problem is fatal
    << Squashed the bug HW000761 >>

    ID: SW000214
    Word processor trashing disk after 20 saves.
    << Squashed the bug SW000214 >> 

    ID: OS000633
    Can't change background colour (blue) on blue screen of death.
    << Squashed the bug OS000633 >> 

    (end of list)

That's because, at the end of each iteration of the while loop, the lexical variable $bug goes out of scope, taking with it the only reference to the Bug object created earlier in the same loop. That object's reference count immediately becomes zero and, because it was blessed, the corresponding DESTROY method (i.e. Bug::DESTROY) is automatically called on the object.
### Where to from here?

Of course, these fundamental techniques only scratch the surface of object-oriented programming in Perl. Simple hash-based classes with methods, constructors, and destructors may be enough to let you solve real problems in Perl, but there's a vast array of powerful and labor-saving techniques you can add to those basic components: autoloaded methods, class methods and class attributes, inheritance and multiple inheritance, polymorphism, multiple dispatch, enforced encapsulation, operator overloading, tied objects, genericity, and persistence.

Perl's standard documentation includes plenty of good material—*perlref*, *perlreftut*, *perlobj*, *perltoot*, *perltootc*, and *perlbot* to get you started. But if you're looking for a comprehensive tutorial on everything you need to know, you may also like to consider my new book, *[Object Oriented Perl](http://www.manning.com/conway/)*, from which this article has been adapted.
