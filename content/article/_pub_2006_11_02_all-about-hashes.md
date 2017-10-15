{
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ],
   "description" : " When I teach about hashes, I do what most Perl tutors and tutorials do: I introduce the hash as a \"dictionary\": a mapping between one thing and another. The classic example, for instance, is to have a set of...",
   "slug" : "/pub/2006/11/02/all-about-hashes.html",
   "tags" : [
      "hash-tables",
      "hashes",
      "perl-data-structures",
      "perl-patterns",
      "perl-syntax",
      "perl-variables"
   ],
   "thumbnail" : "/images/_pub_2006_11_02_all-about-hashes/111-hashes.gif",
   "categories" : "development",
   "image" : null,
   "title" : "Hash Crash Course",
   "date" : "2006-11-02T00:00:00-08:00"
}



When I teach about hashes, I do what most Perl tutors and tutorials do: I introduce the hash as a "dictionary": a mapping between one thing and another. The classic example, for instance, is to have a set of English words mapped to French words:

        %french = (
            apple  => "pomme",
            pear   => "poivre",
            orange => "Leon Brocard"
        );

Yet the more I look at my code--and more often, the more I look at how to tidy up other people's code--I realize that this is perhaps the least common use of a hash. Much more often, I use hashes in particular idioms which have very little in common with this concept of a mapping. It's interesting to consider the ways that programmers *actually* use hashes in Perl code.

### Counting

Many of the uses of hashes are to "answer questions about lists." When you have an array or list of values and you need to ask about its properties, you will often find yourself using a hash. Start simply by counting the number of particular elements in a list. Here's the naïve approach:

        my $count = 0;
        for (@list) {
            $count++ if $_ eq "apple";
        }

You can smarten this up with the use of the `grep` function:

        $count = grep $_ eq "apple", @list;

... but when you need the number of pears in the list, then you have to do the same again:

        $count_apples = grep $_ eq "apple", @list;
        $count_pears  = grep $_ eq "pear",  @list;

Now there are two passes over the list, and the situation isn't going to get any prettier from here. What you want is basically a histogram of the data, and you can get that with a hash:

        my %histogram;
        $histogram{$_}++ for @list;

This hash associates each individual item with its count, and it only traverses the list once.

In a recent case, I was looking at a list of tags associated with various photographs. To lay out the data for display, it was useful to know how many different tags there are in the list. I could get that simply from the number of keys in the histogram:

        $unique = keys %histogram;

I could also delete the duplicates and end up with a list of the unique tags:

        @unique = keys %histogram;

Finally, I could show the five most popular tags from the list:

        @popular = 
            (sort { $histogram{$b} <=> $histogram{$b} } @unique)[0..4];

This sorts the list of unique tags based on their popularity in the original list, and pulls out the top five.

### Uniqueness

Another idiom to get the unique elements from a list is a variation on the "counting things" idiom; but this time you don't care how many of each item there is, just that there's at least one. This allows you to say:

        for (@list) { $unique{$_} = 1 }
        @unique = keys %unique;

which reduces to:

        %unique = map { $_ => 1 } @list;
        @unique = keys %unique;

You can take this a stage further with a slightly non-standard idiom to do the whole thing in one operation:

        @unique = keys %{{ map { $_ => 1 } @list }};

`keys` requires a hash, so this funny-looking line creates an anonymous hash (`{ map ... @list }`) and then turns it into a real hash (`%{ $hash_ref }`) to feed it to `keys`.

The advantage of this trick is that you can use a variation of it to work with lists which include objects as well as ordinary scalars. Here's an example of the problem:

        my @tags;
        push @tags, Memories::Tag->retrieve_random for 1..10;

This should get ten random `Memories::Tag` objects. However, some of them might be the same, and, assuming that you want to see the unique ones:

        %unique = map { $_ => 1 } @tags;
        @unique = keys %unique;

Unfortunately, if you then try to do anything with the tags, it all goes horribly wrong:

        print $unique[0]->name;

        # Can't locate object method "test" via package "Memories::Tag(0x1801380)"

What's happened is that hash keys can only be strings; once you put the object into a hash as the key, then it's not an object any more. Perl turns it into a string. There's no (easy) way to get the strings back into an object. What you need is some kind of data structure to map these broken strings into the original objects. Thankfully, there is one in the form of the hash itself! So the code becomes:

        %unique = map { $_ => $_ } @tags;
        @unique = values %unique;

First, map the object--which Perl will smash into a string--with another copy of the object, which will retain its object-ness. Then instead of getting the strings out of the hash, which are useless to us, you get the objects.

Of course, this doesn't quite work, because even if `retrieve_random` retrieves the same tag name twice, it will return two different objects with the same data. (That's true unless the underlying database abstraction layer uses caching, which is another good use for a hash.)

The solution is to make the list unique based on a property of the tag, such as its name. This time, the code is:

        %unique = map { $_->name => $_ } @tags;
        @unique = values %unique;

Okay, now you have a list of objects which you've retrieved randomly, but which have unique names. The only problem is that you retrieved ten of them to start with, and then whittled the list down to get rid of duplicates. What if you actually wanted 10?

The solution is to keep track of ones that you've already seen, so that you don't create any duplicates in the first place. The question "Have I seen this before?" is easy to answer using another hash-based idiom:

        my @tags;
        my %seen;
        while (@tags < 10) {
            my $candidate = Memories::Tag->retrieve_random;
            next if $seen{$candidate->name}++;
            push @tags, $candidate;
        }

Once again you're collecting unique values by putting them into a hash. Suppose that the first candidate tag that comes along is `japan`. At this point the hash is empty, and so `$seen{japan}` is zero. Because it's zero, the code continues through the loop with `next`, but still increments the hash value. Now `$seen{japan}` stands at 1, and the tag goes into the list. If `japan` comes past again, `$seen{japan}` will be positive so the `next` code will activate, and the tag will not go into the list again. (Don't try this if you have fewer than 10 distinct tags, of course!)

### Caching

A special case of "have I seen this before?" comes when you want to create a cache: if I have seen this before, what was the answer I saw last time? Here's how to do that.

I mentioned that the underlying database abstraction layer in the tags example might cache look-ups and return the same object if you requested the same tag multiple times:

        my %cache;

        sub retrieve {
            my ($self, $id) = @_;
            return $cache{$id} if exists $cache{$id};
            return $cache{$id} = $self->_hard_retrieve($id);
        }

This checks to see if it has seen the `$id` before; if so have, return the value from the hash. If not, work out what the value should be, then store it in the hash for next time, then return the whole lot.

Of course, for heavy-duty applications like a database abstraction layer, you need to do a little more work, such as pruning the cache to make sure it doesn't get out of date or get so full of data that it eats all your memory. The [Cache::Cache](http://search.cpan.org/perldoc?Cache::Cache) suite of modules from CPAN takes care of all of this for you, and the core [Memoize](http://search.cpan.org/perldoc?Memoize) module adds this kind of caching to a function without you specifically having to write the cache-getting and -setting code.

### Searching

Finally, you can use hashes for searching.

If you've done any computer science, you'll probably know about a couple of common searching algorithms. (Even if you haven't, they're so common that you've probably reinvented them without knowing it.) One is linear search, where you start at the beginning of a list and work your way toward the end, looking for the target item:

        my $index;
        for $index (0..@chambers) {
            last if $chambers[$index] == $bullet;
        }
        print "Found at index $index" if $index < @chambers;

Another is binary search, where you start in the middle of a sorted list, and work out whether you should go higher or lower than the current element, like players in some demented version of *Card Sharks*. This is basically the way to look up names in a phone book--it's faster, but a bit more complicated to implement:

        my @names = qw(Able Baker Charlie Dog ...);
        my $index;

        my $target = "Roger";

        sub search {
            my ($lower, $upper) = (0, $#names);
            while ($lower <= $upper) {
                my $index = ($lower + $upper) / 2;
                if ($names[$index] lt $target) {
                    $lower = $index + 1;
                } elsif ($names[$index] gt $target) {
                    $upper = $index--1;
                } else { return $index }
            }
            # Not found!
        }

This starts in the middle, at "Mike". "Go higher!" shouts the crowd, so it goes half-way between there and the end, to "Tare". Then it needs to go lower, so looks half-way between "Mike" and "Tare" and gets to "Peter". Now it needs to go higher again, between "Peter" and "Tare", and finds "Roger".

That takes four comparisons, which is not bad. Can you do it any better? How about... oh, none?

        my %search = map { $names[$_] => $_ } 0..$#names;
        print $names{"Roger"};

Now I'm cheating somewhat here because setting up the hash requires iterating over the whole array, but once you've done that, the searches are basically free.

Of course, if you need to look up an array index by its contents, then maybe you're doing something wrong in the first place, and should have used a hash to start with. Consider, for instance, in a configuration file:

        force-v3-sigs
        escape-from-lines
        lock-once
        load-extension rndlinux
        keyserver wwwkeys.eu.pgp.net
        keyserver the.earth.li

(Yes, that's from GnuPG.) Each line has a key and optionally a value, but you can have multiple values for each key. At the end of the day, you might want to look through and say "tell me all the keyservers"--but not just the keyservers, you want to read the whole config in and be able to say that about any key. That's a search problem, and a tricky one. Here's one solution:

        while (<>) {
            chomp;
            my ($key, $value) = split /\s+/, $_, 2;
            push @config, [$key, $value];
        }

Now you have to say:

        @keyservers = map { $_->[1] } grep { $_->[0] eq "keyserver" } @config;

This is actually a linear search in disguise. (`grep` does a linear search for you.)

With hashes, the issue is much simpler:

        while (<>) {
            chomp;
            my ($key, $value) = split /\s+/, $_, 2;
            push @{$config{$key}}, $value;
        }

This treats every key as a separate array reference, and pushes values into that array. Now to retrieve the list of keyservers, just look up the array inside the hash:

        @keyservers = @{$config{"keyservers"}};

This process is very remniscient of the final pattern--using a hash as a portable symbol table.

### Dispatch Tables

Instead of having the configuration reader create a bunch of arrays--`@keyservers`, `@load_extension` and so on--I created a hash which held the arrays so as to look them up indirectly but more efficiently. In effect, instead of using the Perl symbol table, you can use a hash as a portable symbol table.

Suppose you have a script that does several related things: it manages your to-do list by adding, editing, listing, and deleting to-do items:

        % todo add "Email Samuel about photos"
        Todo item 129 created
        % todo done 129
        Item 129 marked as done

You might expect the script to look like:

        my $command = shift @ARGV;
        if    ($command eq "add")  { add(@ARGV)  }
        elsif ($command eq "list") { list(@ARGV) }
        elsif ($command eq "done") { done(@ARGV) }
        elsif ($command eq "edit") { edit(@ARGV) }
        ...
        else { die "Unknown command: $command" }

That is quite tedious; you need to edit the program in several places every time you add a new command. You *could* use symbolic references--that is, tell Perl to call a function named `$command`:

        my $command = shift @ARGV;
        sub AUTOLOAD { die "Unknown command: $AUTOLOAD" }
        no strict 'refs';
        &{$command}(@ARGV);

But that's somewhat crazy. It allows the user to get at any subroutine in the main package, which you may not want, and to keep any error checking you have to assume that *any* undefined subroutine call comes from the command line.

The middle way is to copy the commands into a hash, mapped to a function reference:

        %commands = (
            add  => \&add,
            list => \&list,
            edit => \&edit,
            done => \&done,
        );
        my $command = shift @ARGV;
        if (!exists $commands{$command}) { die "Unknown command: $command" }
        $commands{$command}->(@ARGV);

This keeps `strict` happy, it's safe in the way it restricts what subroutines users can call, and it allows for error checking that doesn't mess everything else up. Mark Jason Dominus' *Higher Order Perl* shows how you can define commands at runtime if you use dispatch tables, something you can't do if you hard-code your dispatch.

### Conclusion

I've explored some of the most common hash-based patterns: using hashes for counting, uniqueness, searching, and dispatch--rather a lot more than just mapping from one thing to another. Of course, that is what a hash does at one level, but the uses of such a data structure are a lot more diverse than just that.

That's how you improve your Perl programming--you take elements of the language which ostensibly do one thing, and you find that they're great for more complicated uses as well. Maybe after these ideas you'll be able to find a few more hash idioms of your own!
