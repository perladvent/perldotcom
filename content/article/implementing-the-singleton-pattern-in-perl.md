{
   "tags" : [
      "object_oriented",
      "object",
      "pattern",
      "gof"
   ],
   "description" : "Learn when and how to use this classic \"gang of four\" code pattern",
   "date" : "2013-12-11T04:33:35",
   "slug" : "52/2013/12/11/Implementing-the-singleton-pattern-in-Perl",
   "authors" : [
      "david-farrell"
   ],
   "title" : "Implementing the singleton pattern in Perl",
   "image" : null,
   "draft" : false,
   "categories" : "development"
}


*The Singleton is a well-known object oriented design pattern that allows only one object of a class to be created. It's often cited as the most popular design pattern from the original "gang of four" book. But when should you use it in Perl and how?*

### When to use it

The Singleton is such a popular pattern it is sometimes called an anti-pattern as the legitimate cases to use it are relatively rare. Consider using the Singleton when one of the following needs arises:

-   You have a single resource that needs to be reused across several different parts of a system. A logger is a good example of this ([Log::log4perl](https://metacpan.org/pod/Log::Log4perl) implements the Singleton pattern).
-   You need to ensure only one instance exists as the class cannot perform correctly if there is more than one instance of it (e.g. a file system, a game loop).
-   You need a singleton as a component of another design pattern (Abstract Factory, Builder, Prototype)

If you do not have one of the above needs, you may not need to use the Singleton pattern. Using Singletons encourages the coupling of code, which can make unit testing, sub-classing and debugging harder.

### Implementation of a Singleton Class

Instead of implementing a "new" constructor, the Singleton class implements an "get\_instance" method which will return a new object if it doesn't already exist, else it returns the existing instance. The Singleton class is shown below:

``` prettyprint
package Singleton;

my $instance = undef;

sub get_instance {
    $instance = bless {}, shift unless $instance;
    return $instance;
}

1;
```

To test the Singleton get\_instance method we can run the following script:

``` prettyprint
use strict;
use warnings;
use Singleton; 

my $singleton_1 = Singleton->get_instance;
$singleton_1->{favourite_animal} = 'llama'; # of course!

my $singleton_2 = Singleton->get_instance;

print $singleton_2->{favourite_animal} . "\n";
```

This script constructs a new object using "get\_instance" and assigns it to a variable called "$singleton\_1". It adds an attribute to the object ("favourite\_animal"). The script then calls the "get\_instance" method again and assigns the resulting object to a new variable called "$singleton\_2". Printing the "favourite\_animal" key-value attribute of the object returns the same value that was set using "$singleton\_1", proving that we have one underlying instance and both variables ("$singleton\_1" and "$singleton\_2") point to it.

### Further reading

-   brian d foy's [Perl Review article](http://www.theperlreview.com/Articles/v0i1/singletons.pdf) on the Singleton pattern is a more in-depth consideration of the Singleton pattern in Perl.
-   [Wikpedia's Singleton entry](https://en.wikipedia.org/wiki/Singleton_pattern) has useful background and discussion on the pattern.
-   [Design Patterns: Elements of Reusable Object-Oriented Software](http://www.amazon.com/gp/product/B000SEIBB8/ref=as_li_qf_sp_asin_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B000SEIBB8&linkCode=as2&tag=perltrickscom-20) - The classic "gang of four" book that popularized the concept of Design Patterns, including the Singleton (affiliate link).
-   The Perl Design Patterns site has a [Singleton entry](http://perldesignpatterns.com/?SingletonPattern), with alternative implementations.


\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
