{
   "authors" : [
      "dave-cross"
   ],
   "draft" : null,
   "slug" : "/pub/2001/09/04/tiedhash.html",
   "description" : " Introduction In my experience, hashes are just about the most useful built-in datatype that Perl has. They are useful for so many things - from simple lookup tables to complex data structures. And, of course, most Perl Objects have...",
   "categories" : "data",
   "title" : "Changing Hash Behaviour with tie",
   "image" : null,
   "date" : "2001-09-04T00:00:00-08:00",
   "tags" : [
      "tied-hash-behaviour"
   ],
   "thumbnail" : "/images/_pub_2001_09_04_tiedhash/111-hashtie.jpg"
}



### <span id="introduction">Introduction</span>

In my experience, hashes are just about the most useful built-in datatype that Perl has. They are useful for so many things - from simple lookup tables to complex data structures. And, of course, most Perl Objects have a blessed hash as their underlying implementation.

The fact that they have so many uses must mean the Larry and the Perl5 Porters must have got the functionality of hashes pretty much right when designing them - it's simple, instinctive and effective. But have you ever come across a situation where you wanted to change the way that hashes worked? Perhaps you wanted hashes that only had a fixed set of keys. Faced with this requirement, it's tempting to move away from the hash interface completely and use an object. The downside to this decision is that you lose the easy-to-understand hash interface. But using *tied variables* it is possible to create an object and still use it like a hash.

### <span id="tied objects">Tied Objects</span>

Tied objects are, in my opinion, an underused feature of Perl. The details (together with some very good examples) are in *perltie* and there are some extended examples in the \`\`Tied variables'' chapter of *Programming Perl*. Despite all of this great documentation, most people seem to believe that `tie`ing is only used to `tie` a hash to a DBM file. The truth is that any type of Perl data structure can be `tie`d to just about anything. It's simply a case of writing an object that includes certain pre-defined methods. If you want to create a `tie`d object that emulates a standard Perl object most of the time, then it's even easier, as the Perl distribution contains modules that define objects that mimic the behavior of that standard data types. For example, there is a class called `Tie::StdHash` (in the file Tie::Hash) that mimics the behavior of a real hash. To alter that behavior we simply have to subclass `Tie::StdHash` and override the methods that we're interested in.

### <span id="using tied objects">Using Tied Objects</span>

In your Perl program, you make use of a `tie`d object by calling the `tie` function. `tie` takes two mandatory parameters: the variable that you are `tie`ing and the name of the class to `tie` it to, followed by any number of optional paramters. For example, if we had written the hash with fixed keys discussed earlier (which we will do soon), we could use the class in our program like this:


      use Tie::Hash::FixedKey;

      my %person;

      my @keys = qw(forename surname date_of_birth gender);

      tie %person, 'Tie::Hash::FixedWidth', @keys;

After running this code, `%person` can still be used like a hash, but its behavior will have been changed. Any attempt to assign a value to a key outside the list that we used in the call to `tie` will fail in some way that we get to specify when we write the module.

If for some reason we wanted to get to the underlying object that is tied to the hash, then we can use the `tied` function. For example,


      my $obj = tied(%person);

will give us back the Tie::Hash::FixedKeys object that is tied to our `%person` hash. This is sometimes used to extend the functionality in ways that aren't available through the standard hash interface. In our fixed keys example, we might want the user to be able to extend or reduce the list of valid keys. There is no way to do this in the standard hash interface so we would need to add new methods called, say, `add_keys` and `del_keys`, which can be called like this:


      tied(%person)->add_keys('weight', 'height');

When you have finished with the tied object and want to return it to being an ordinary hash, you can use the `untie` function. For example,


      untie %person;

returns `%person` to being an ordinary hash.

To tie an object to a Perl hash, your object needs to define the following set of methods. Notice that they are all named in upper case. This is the standard for function names that Perl is going to call for you.

**<span id="item_TIEHASH">TIEHASH</span>**
  
This is the constructor function. It is called when the user calls the `tie` function. It is passed the name of the class and the list of parameters that were passed to `tie`. It should return a reference to the new tied object.

**<span id="item_FETCH">FETCH</span>**
  
This is the method that is called when the user accesses a value from the hash. The method is passed a reference to the tied object and the key that the user is trying to access. It should return the value associated with the given key (or `undef` if the key isn't found).

**<span id="item_STORE">STORE</span>**
  
This method is called when the user tries to store a value against a key in the tied hash. It is passed a reference to the object, together with the key and value pair.

**<span id="item_DELETE">DELETE</span>**
  
This method is called when the user calls the `delete` function to remove one of the key/value pairs in the tied hash. It is passed a reference to the tied object and the key that the user wishes to remove. The return value becomes the return value from the `delete` call. To emulate the 'real' `delete` function, this should be the value that was stored in the hash before it was deleted.

**<span id="item_CLEAR">CLEAR</span>**
  
This method is called when the user clears the whole hash (usually by asigning an empty list to the hash). It is passed a reference to the tied object.

**<span id="item_EXISTS">EXISTS</span>**
  
This method is called when the user calls the `exists` function to see whether a given key exists in the hash. It is passed a reference to the tied object and the key to search for. It should return a true value if the key is found and false otherwise.

**<span id="item_FIRSTKEY">FIRSTKEY</span>**
  
This method is called when one of the hash iterator functions (`each` or `keys`) is called for the first time. It is passed a reference to the tied object and should return the first key in the hash.

**<span id="item_NEXTKEY">NEXTKEY</span>**
  
This method is called when one of the iterator functions is called. It is passed a reference to the tied object and the name of the last key that was processed. It should return the name of the next key or `undef` if there are no more keys.

**<span id="item_UNTIE">UNTIE</span>**
  
This method is called when the `untie` function is called. It is passed a reference to the tied object.

**<span id="item_DESTROY">DESTROY</span>**
  
This method is called when the tied variable goes out of scope. It is passed a reference to the tied object.

As you can see, there are a large number of methods to implement, but in the next section we'll see how you can get away with only implementing some of them.

### <span id="a first example: tie::hash::fixedkeys">A First Example: Tie::Hash::FixedKeys</span>

Let's take a look at the implementation of Tie::Hash::FixedKeys. This module is available on CPAN if you want to take a closer look.

Writing the module is made far easier for use by the existence of a package called Tie::StdHash. This is a tied hash that mirrors the behavior of a standard Perl hash. This package is stored in the module Tie::Hash. This means that if you wrote code like the following example, then you would have a tied hash that acts the same way as a 'real' hash.


        use Tie::Hash;

        my %hash;

        tie %hash, 'Tie::StdHash';

So far, so good. But it hasn't really achieved much. The hash `%hash` is now a tied object, but we haven't changed any of its functionalities. Tie::StdHash works much better if it is used as a base class from which you inherit behavior. For example, the start of the Tie::Hash::FixedKeys class looks like this:


        package Tie::Hash::FixedKeys;

        use strict;

        use Tie::Hash;

        use Carp;

        use vars qw(@ISA);

        @ISA = qw(Tie::StdHash);

This is standard for a Perl object, but notice that we've loaded the Tie::Hash module (with `use Tie::Hash`) and have told our package to inherit behavior from Tie::StdHash by putting Tie::StdHash in the `@ISA` package variable.

If we stopped there, our Tie::Hash::FixedKeys package would have the same behavior as a standard Perl hash. This is because each time Perl tried to find one of the tie interface methods (like [`FETCH`](/pub/2001/09/04/tiedhash.html#item_FETCH) or [`STORE`](/pub/2001/09/04/tiedhash.html#item_STORE)) in our package it would fail and would call the version found in our parent class, Tie::StdHash.

At this point we can start to change the standard hash behavior by simply overriding the methods that we want to change. We'll start by implementing the [`TIEHASH`](/pub/2001/09/04/tiedhash.html#item_TIEHASH) method differently.


        sub TIEHASH {

          my $class = shift;

          my %hash;

          @hash{@_} = (undef) x @_;

          

          bless \%hash, $class;

        }

The [`TIEHASH`](/pub/2001/09/04/tiedhash.html#item_TIEHASH) function is passed the name of the class as its first parameter, so we `shift` that into `$class` in the first line. The rest of the parameters in `@_` are whatever extra parameters have been passed into the `tie` call. In the example of how to use our proposed class at the start of this article, we passed it the list of valid keys. Therefore, we take this list of keys and (using a hash slice) we initialize a hash so that it has `undef` as the value for each of these keys. Finally, we take a reference to this hash, bless it into the required class and return the reference.

It's worth pointing out here, the one caveat about using Tie::StdHash. In order to use the default behavior, your new class *must* be based on a hash reference and this hash must contain *only* real hash data. We couldn't, for example, invent a key called `_keys` that would contain a list of valid key names as, for example, this key would be shown if the user called the `keys` method.

At this point we have a hash that has values (of `undef`) for each of the allowed keys. This doesn't yet prevent us from adding new keys. For that we need to override the STORE method.


        sub STORE {

          my ($self, $key, $val) = @_;



          unless (exists $self->{$key}) {

            croak "invalid key [$key] in hash\n";

            return;

          }

          $self->{$key} = $val;

        }

The three parameters passed to the [`STORE`](/pub/2001/09/04/tiedhash.html#item_STORE) method are a reference to the tied object, and a new key/value pair. We need the [`STORE`](/pub/2001/09/04/tiedhash.html#item_STORE) method to prevent new keys being added to the underlying hash, and we achieve that by checking that the given key exists before setting the value. Note that as our underlying object is a real hash, we can check this simply by using the `exists` function. If the key doesn't exist we give the user a friendly warning and return from the method without changing the hash.

We have now prevented the hash from growing by adding keys, but it is still possible to remove keys from the hash (and our [`STORE`](/pub/2001/09/04/tiedhash.html#item_STORE) implementation would prevent them from being set once they had been removed), so we also need to override the implementation of [`DELETE`](/pub/2001/09/04/tiedhash.html#item_DELETE).


        sub DELETE {

          my ($self, $key) = @_;

          return unless exists $self->{$key};

          

          my $ret = $self->{$key};



          $self->{$key} = undef;

          return $ret;

        }

Once again, we don't actually want to change the existing set of keys in the hash, so we check to see whether the key already exists and return immediately if it doesn't. If the key *does* exist, then we don't want to actually delete it, so we simply set the value back to `undef`. Notice that we note the value before deleting it so that we can return it from the method, thus mimicking the behavior of the real `delete` function.

There's one other way to affect the keys in our hash. Code like this:


        %hash = ();

will cause the [`CLEAR`](/pub/2001/09/04/tiedhash.html#item_CLEAR) method to be called. The default behavior for this method is to remove all of the data from the hash. We need to replace this with a method that will reset all of the values to `undef` without changing the keys in any way.


        sub CLEAR {

          my $self = shift;



          $self->{$_} = undef foreach keys %$self;

        }

And that's all that we need to do. All of the other functionality of a standard hash is inherited from Tie::StdHash. You can fetch values from our hash as normal without us writing any more lines of code. Built-in Perl functions like `each` and `keys` also work as expected.

### <span id="another example: tie::hash::regex">Another Example: Tie::Hash::Regex</span>

Let's look at another example. This module came about from a discussion on Perlmonks a couple of months ago. Someone asked whether it was possible to match hash keys approximately. I suggested that a hash that matched keys as regular expressions might solve their problem and wrote the first draft of this module. I'm grateful to Jeff Pinyan, who made some suggestions for improvements to the module.

In order to make this change to the behavior of the hash, we need to override the behavior of the [`FETCH`](/pub/2001/09/04/tiedhash.html#item_FETCH), [`EXISTS`](/pub/2001/09/04/tiedhash.html#item_EXISTS) and [`DELETE`](/pub/2001/09/04/tiedhash.html#item_DELETE) methods. Here's the [`FETCH`](/pub/2001/09/04/tiedhash.html#item_FETCH) method.


      sub FETCH {

        my $self = shift;

        my $key = shift;    

        my $is_re = (ref $key eq 'Regexp');

        

        return $self->{$key} if !$is_re && exists $self->{$key};

        

        $key = qr/$key/ unless $is_re;



        /$key/ and return $self->{$_} for keys %$self;

        

        return;



      }

Knowing what we know about tied objects, this is pretty simple to follow. We start by getting the reference to the tied object (which will be a hash reference) and the required key. We then check to see whether the key is a reference to a precompiled regular expression (which would have been compiled with `qr//`. If the key *isn't* a regex, then we start by checking whether the key exists in the hash. If it does, we return the associated value. If the key isn't found, then we assume that it is a regex to search for. At this point we compile the regex as if it isn't already precompiled (this gives us a preforamnce boost as we could potentially need to match the regex against all of the keys in the hash). Finally, we check each key in the hash in turn against the regex and if it matches, then we return the associated value. If there are no matches we simply `return`.

At this point you may realize that it's possible for more than one key to match a regex and you may suggest that it would be nice for [`FETCH`](/pub/2001/09/04/tiedhash.html#item_FETCH) to return *all* matches as if it was called in scalar context. This is a nice idea, but in current versions of Perl the syntax `$hash{$key}` *always* calls [`FETCH`](/pub/2001/09/04/tiedhash.html#item_FETCH) in scalar context (and the syntax `@hash{@keys}` calls [`FETCH`](/pub/2001/09/04/tiedhash.html#item_FETCH) once in scalar context for each element of `@keys`) so this won't work. To get round this, you can use the slightly kludgey syntax `@vals = tied(%hash)-`FETCH($pattern)&gt; and the version of the module on CPAN supports this.

The [`EXISTS`](/pub/2001/09/04/tiedhash.html#item_EXISTS) method uses similar processing, but in this case we return 1 if the key is found instead of the associated value.


      sub EXISTS {

        my $self = shift;

        my $key = shift;

        my $is_re = (ref $key eq 'Regexp');



        return 1 if !$is_re && exists $self->{$key};



        $key = qr/$key/ unless $is_re;



        /$key/ && return 1 for keys %$key;



        return;

      }

The [`DELETE`](/pub/2001/09/04/tiedhash.html#item_DELETE) method is somewhat different. In this case, we can delete *all* matching key/value pairs, which we do with the following code:




      sub DELETE {

        my $self = shift;

        my $key = shift;

        my $is_re = (ref $key eq 'Regexp');



        return delete $self->{$key} if !$is_re && exists $self->{$key};



        $key = qr/$key/ unless $is_re;



        for (keys %$self) {

          if (/$key/) {

            delete $self->{$_};

          }

        }

      }

I should point out that there is another similar module on CPAN called Tie::RegexpHash written by robert Rothenberg. Tie::RegexpHash actually does the opposite to Tie::Hash::Regex. When you store a value in it, the key is a regular expression and any time you look up a value with a key, you will get the value associated with the first regex key that matches your string. It's interesting to note that Tie::RegexpHash *isn't* based on Tie::StdHash and, as a result, contains a lot more code than Tie::Hash::Regex.

Another recent addition to CPAN is Tie::Hash::Approx, which was written by Briac Pilpr�. This addresses a similar problem, but instead of using regex matching, it uses Jarkko Hietaniemi's String::Approx module.

### <span id="conclusion: tie::hash::cannabinol">Conclusion: Tie::Hash::Cannabinol</span>

As a final example, here's something that isn't quite so useful. This is a hash that forgets just about everything that you tell it. Its `exists` function isn't exactly to be trusted either.


        package Tie::Hash::Cannabinol;

        use strict;

        use vars qw(@ISA);

        use Tie::Hash;

        

        $VERSION = '0.01';

        @ISA = qw(Tie::StdHash);



        sub STORE {

          my ($self, $key, $val) = @_;

          

          return if rand > .75;



          $self->{$key} = $val;

        }



        sub FETCH {

          my ($self, $key) = @_;



          return if rand > .75;



          return $self->{rand keys %$self};

        }



        sub EXISTS {

          return rand > .5;

        }

As you can see, it's simple to make some radical alterations to the behavior of Perl hashes using `tie` and the Tie::StdHash base class. As I said at the start of the article, this often enables you to create new \`\`objects'' without having to make the leap to full object orientation in you programs.

And it isn't just hashes that you can do it for. The standard Perl distribution also comes with packages called Tie::StdArray, Tie::StdHandle and Tie::StdScalar.

Have fun with them.
