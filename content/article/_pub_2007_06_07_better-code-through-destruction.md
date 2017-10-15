{
   "categories" : "CPAN",
   "authors" : [
      "igor-gariev"
   ],
   "title" : "Better Code Through Destruction",
   "image" : null,
   "thumbnail" : null,
   "date" : "2007-06-07T00:00:00-08:00",
   "draft" : null,
   "description" : " Larry Wall said that Perl makes easy things easy and hard things possible. Perl is good both for writing a two-line script that saves the world at the last minute (well, at least it saves you and your project)...",
   "tags" : [
      "object-destructor",
      "perl-memory-leaks",
      "perl-memory-management",
      "raii",
      "reference-counting"
   ],
   "slug" : "/pub/2007/06/07/better-code-through-destruction.html"
}



Larry Wall said that Perl makes easy things easy and hard things possible. Perl is good both for writing a two-line script that saves the world at the last minute (well, at least it saves you and your project) and for robust projects. However, good Perl programming techniques can be quite different between small and complex applications. Consider, for example, Perl's garbage collector. It frees a programmer from memory management issues most of the time...until the programmer creates circular references.

Perl's garbage collector counts references. When the count reaches zero (which means that no one has a reference), Perl reclaims the entity. The approach is simple and effective. However, circular references (when object A has a reference to object B, and object B has a reference to object A) present a problem. Even if nothing else in the program has a reference to either A or B, the reference count can never reach zero. Objects A and B do not get destroyed. If the code creates them again and again (perhaps in a loop), you get a memory leak. The amount of memory allocated by the program increases without a sensible reason and can never decrease. This effect may be acceptable for simple run-and-exit scripts, but it's not acceptable for programs running 24x365, such as in a mod\_perl or FastCGI environment or as standalone servers.

Circular references are sometimes too useful to avoid. A common example is a tree-like data structure. To navigate both directions--from root to leaves and vice versa--a parent node has a list of children and a child node has a reference to its parent. Here are the circular references. Many CPAN modules implement their data models this way, including [HTML::Tree](http://search.cpan.org/perldoc?HTML::Tree), [XML::DOM](http://search.cpan.org/perldoc?XML::DOM), and [Text::PDF::File](http://search.cpan.org/perldoc?Text::PDF::File). All these modules provide a method to release the memory. The client application must call the method when it no longer needs an object. However, the requirement of an explicit call is not very appealing and can result in unsafe code:

        ##
        ## Code with a memory leak
        #
        use HTML::TreeBuilder;

        foreach my $filename (@ARGV) {
            my $tree = HTML::TreeBuilder->new;
            $tree->parse_file($filename);

            next unless $tree->look_down('_tag', 'img');
            ##
            ## Do the actual work (say, extract images) here
            ## ...
            ## and release the memory
            ##
            $tree->delete;
        }

The problem in the code is the `next` statement; HTML documents with no `<img ...` tags will not be released. Actually, any call of `next`, `last`, `return` (inside a subroutine), or `die` (inside an `eval {}` block) is unsafe and will lead to a memory leak. Of course, it is possible to move the release code into a `continue` block for `last` or `next`, or to write code to delete the tree before every `return` or `die`, but the code easily becomes messy.

There is a better solution--the paradigm of "resource acquisition is initialization (and destruction is resource relinquishment)." (Ironically, the second half of its name is often omitted, even though it's probably the most important part). The idea is simple. Create a special guard object (of another class) whose sole responsibility is to release the resource. When the guard object gets destroyed, its destructor deletes the tree. The code may look like:

        ##
        ## A special sentry object is employed
        ##
        use HTML::TreeBuilder;

        foreach my $filename (@ARGV) {
            my $tree = HTML::TreeBuilder->new;
            $tree->parse_file($filename);

            my $sentry = Sentry->new($tree);

            next unless $tree->look_down('_tag', 'img');
            ##
            ## next, last or return are safe here.
            ## Tree will be deleted automatically.
            ##
        }

        package Sentry;

        sub new {
            my $class = shift;
            my $tree  = shift;
            return bless {tree => $tree}, $class;
        }

        sub DESTROY {
            my $self = shift;
            $self->{tree}->delete;
        }

Note that now there is no need to call `$tree->delete` explicitly at the end of the loop. The magic is simple. When program flow leaves the scope, `$sentry` is reclaimable because it participates in no circular references. The code of `DESTROY` method of the `Sentry` package calls, in turn, the method `delete` of the `$tree` object. This is one solution for all means; memory will be released however you leave the block.

Finally, there is no need to code your own `Sentry` class. Use [Object::Destroyer](http://search.cpan.org/perldoc?Object::Destroyer), originally written by Adam Kennedy. As you may guess by its name, it is the object to destroy other objects:

        ##
        ## An of-the-CPAN solution with Object::Destroyer
        ##
        use HTML::TreeBuilder;
        use Object::Destroyer 2.0;

        foreach my $filename (@ARGV) {
            my $tree   = HTML::TreeBuilder->new;
            my $sentry = Object::Destroyer->new($tree, 'delete');
            $tree->parse_file($filename);

            next unless $tree->look_down('_tag', 'img');
            ##
            ## You can safely return, die, next or last here.
            ##
        }

Because the name of the release method may vary between modules, it is the constructor's second argument.

Finally, you can destroy any data structure, not just objects, if you provide code to do so. Pass in a subroutine reference or an anonymous subroutine:

        ##
        ## An unblessed data structure with circular references
        ## that cannot untangle itself.
        ##
        use Object::Destroyer 2.0;
        while (1) {
            my (%a, %b);
            $a{b}      = \%b;
            $b{a}      = \%a;
            my $sentry = Object::Destroyer->new( sub { undef $a{b} } );
        }

Just for fun, comment out the line with the `$sentry` object and watch the memory consumption of the running script.

### Using Object::Destroyer As a Wrapper

`Object::Destroyer` can make life easier for module authors, too.

If you have written a library with circular references, you may ask your clients to explicitly call a disposal method or use a new feature of Perl (stable since 5.8; see [Scalar::Util](http://search.cpan.org/perldoc?Scalar::Util))--weak references. Weak references do not increment reference counts of the objects to which they refer, so the Perl garbage collector can collect the referents. In the tree example, all references from leaves to parents (but not vice versa, or the tree will be lost!) may be weak. When the final reference to the root node goes away, Perl will dispose of it, which will remove its references to all of its children recursively. They will all reach zero, and Perl will reclaim them all down the branches of the tree to every leaf.

Indeed, some CPAN modules use this approach ([XML::Twig](http://search.cpan.org/perldoc?XML::Twig)). However, this solution works only if weak refs are available; this is certainly not the case for older Perl. Secondly, this may require quite a bit of rewriting (there are nine calls to `weaken` throughout the code of `XML::Twig` 3.26).

Alternatively, you may use `Object::Destroyer` internally in your library code. It can work as an almost transparent wrapper around your object:

        ##
        ## Object::Destroyer as a wrapper
        ##
        package My::Tree;
        use Object::Destroyer 2.0;

        sub new {
            my $class = shift;
            my $self  = bless {}, $class;
            $self->populate;

            return Object::Destroyer->new( $self, 'release' );
        }

        sub release{
            ## actual memory release code
        }

        sub say_hello{
            my $self = shift;
            print "Hello, I'm object of class ", ref($self), "\n";
        }

        package main;
        {
            my $tree = My::Tree->new;
            $tree->say_hello;
            ##
            ## $tree->release will be called by Object::Destroyer;
            ##
        }

The object `$tree` in the client code is actually an `Object::Destroyer` object that dispatches all invoked methods to the underlying object of class `My::Tree`. The method `say_hello` sees no difference at all--it receives an original `$self` object. Changes to code are minimal and well localized.

The approach has a limitation, too: clients must not access attributes of the object directly (such as `$tree->{age}`). This is a bad practice in client code anyway. Additionally, there is a small time penalty for method calls by client-side code. Calls made from the library code itself are not affected.

### Exceptions and Resource Deallocation

[Resource acquisition is initialization](http://en.wikipedia.org/wiki/Resource_Acquisition_Is_Initialization) is a powerful technique to apply to the management of various critical resources, not only memory. It is most useful when using exceptions to handle errors. This combination makes code quite reliable: exceptions separate normal execution logic and error handling, and RAII sentries guarantee the correct release of every sensitive resource.

Consider alarms as an example. Assume that you have to call some potentially long-running (or even never-ending) code. You don't want your script to hang up, and prefer to break its execution. Alarms are just right for the task. However, the first attempt at good code might be awkward:

        ##
        ## Alarm example 1. Naive.
        ##
        eval{
            local $SIG{ALRM} = sub { die "Timed out\n" };
            alarm(5);
            long_running_code();
            ## Cancel the alarm if code returned within 5 sec.
            alarm(0);
        };
        if ($@ && $@ eq "Timed out\n") {
            ## Process the error here
        }

This code will work fine until `long_running_code()` dies. In this case, the `eval` block will catch the `die`, but not the alarm. If this occurred in a program that must run 24 hours a day, the program would end in 5 seconds.

This next example is much better; actually it is real-world code. It is enough for many applications. However, it's not completely bulletproof either:

        ##
        ## Alarm example 2. A standard solution.
        ##
        eval{
            local $SIG{ALRM} = sub { die "Timed out\n" };
            alarm(5);
            long_running_code();
            ## Cancel the alarm if long_running_code() returns within 5 sec.
            alarm(0);
        };
        ## Cancel the alarm if the long_running_code() died.
        alarm(0);

How many times will the alarm be cancelled in the following example?

        ##
        ## Alarm example 3. Malicious code.
        ##
        LOOP:
        foreach my $arg (1..3) {
            eval{
                local $SIG{ALRM} = sub { die "Timed out\n" };
                alarm(5);
                long_running_code($arg);
                alarm(0);
            };
            alarm(0);
        }
        sub long_running_code{ last LOOP; }

Oops, none.

The RAII solution is more reliable:

        ##
        ## Alarm example 4.
        ## Resource is under control of Object::Destroyer
        ##
        eval{
            local $SIG{ALRM} = sub { die "Timed out\n" };
            alarm(5);
            my $sentry = Object::Destroyer->new( sub {alarm(0)} );
            long_running_code();
        };

No matter how the code exits the `eval` block, Perl will destroy the `$sentry` object. That destruction will call `alarm(0)`.

You can manage many sensitive resources this way, including file locks, semaphores, and even locks of database tables.

        ##
        ## File lock.
        ##
        use Fcntl ':flock';

        open my($fh), ">$filename.lock";
        eval{
            flock($fh, LOCK_EX);
            my $sentry = Object::Destroyer->new( sub {flock($fh, LOCK_UN)} );
            ##
            ## Actual lock-sensitive code is here.
            ## It is safe to die.
            ##
        };

        ##
        ## Semaphore
        ##
        use Thread::Semaphore;
        use Object::Destroyer;

        my $s = Thread::Semaphore->new();
        eval{
            $s->down;
            my $sentry = Object::Destroyer->new( sub { $s->up } );
            ##
            ## Critical code is here, die is safe
            ##
        };

        ##
        ## MySQL database table lock.
        ##
        use DBI;

        my $dbh = DBI->connect("dbi:mysql:...", "", "");
        eval{
            $dbh->do("LOCK TABLE table1 READ");
            my $sentry = Object::Destroyer->new(
                sub { $dbh->do("UNLOCK TABLES"); }
            );
            ##
            ## Again, actual code must be here
            ##
        };

The code is clean, simple, and quite self-explanatory.

### Simple Transactions

Everyone who works with relational databases knows how useful transactions are. One of the features of transactions is atomicity: either all modifications of data are committed at once, or all of them are ignored. Your data is always consistent; it's not possible to leave it in an inconsistent state. The same effect is possible in Perl code:

        use Object::Destroyer 2.0;

        my ($account1, $account2) = (15, 15);

        printf("Account1=%d, Account2=%d, Total=%d\n",
            $account1, $account2, $account1+$account2);

        eval {
            my $coderef = create_savepoint(\$account1, \$account2);
            my $sentry  = Object::Destroyer->new($coderef);

            die "before changes" if rand > 0.7;
            $account1 += 3;
            die "after account 1 was modified" if rand > 0.7;
            $account2 -= 3;
            die "after account 2 was modified" if rand > 0.7;

            ##
            ## The transaction is considered to be committed here
            ## and $sentry can be dismissed.
            ## $coderef->() will not be called.
            ##
            $sentry->dismiss;

            die "after transaction is committed" if rand > 0.7;
        };
        print "Died $@" if $@;
        printf("Account1=%d, Account2=%d, Total=%d\n",
            $account1, $account2, $account1+$account2);

        sub create_savepoint {
            ## Save references to variables and their current values
            my @vars;
            foreach my $ref (@_) {
                die "Can remember only scalar values" unless ref($ref) eq 'SCALAR';
                push @vars, { ref => $ref, value => $$ref };
            }

            ## A closure to restore their values
            return sub {
                foreach my $var (@vars) {
                    ${ $var->{ref} } = $var->{value};
                }
            };
        }

Run the script several times. Due to `rand`, it will break on varying lines, but it is not possible to get a Total value other than 30.

### See Also

RAII is by no means a new technique. It is very popular in the world of C++ programming. If you are not afraid of C++, you may find interesting the standard container [auto\_ptr](http://en.wikipedia.org/wiki/Auto_ptr) and [effective auto\_ptr usage](http://www.gotw.ca/publications/using_auto_ptr_effectively.htm). The non-standard [ScopeGuard](http://www.ddj.com/dept/cpp/184403758) class provides lexically scoped resource management in C++.

The [Devel::Monitor](http://search.cpan.org/perldoc?Devel::Monitor) module has guidelines on how to design data structures with weak and circular references. Its primary goal, by the way, is to trace the memory consumption of a running script.

There are several modules for lexically scoped resource management on CPAN, but the [Object::Destroyer](http://search.cpan.org/perldoc?Object::Destroyer) is my favorite. You may also look at [Hook::Scope](http://search.cpan.org/perldoc?Hook::Scope), [Scope::Guard](http://search.cpan.org/perldoc?Scope::Guard) and [Sub::ScopeFinalizer](http://search.cpan.org/perldoc?Sub::ScopeFinalizer).

Finally, [Object Oriented Exception Handling in Perl](/pub/a/2002/11/14/exception.html) discusses why exceptions are invaluable for big projects.
