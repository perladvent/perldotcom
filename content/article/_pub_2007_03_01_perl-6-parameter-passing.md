{
   "categories" : "perl-6",
   "authors" : [
      "phil-crow"
   ],
   "title" : "The Beauty of Perl 6 Parameter Passing",
   "thumbnail" : null,
   "image" : null,
   "date" : "2007-03-01T00:00:00-08:00",
   "draft" : null,
   "description" : " Perl 6 is not finished, but you can already play with it. I hope this article will encourage you to try it. Begin by installing Pugs, a Perl 6 compiler implemented in Haskell. Note that you will also need...",
   "tags" : [
      "exegeses",
      "parameter-passing",
      "parrot",
      "perl",
      "perl-6",
      "pugs",
      "subroutines",
      "synopses"
   ],
   "slug" : "/pub/2007/03/01/perl-6-parameter-passing.html"
}



Perl 6 is not finished, but you can already play with it. I hope this article will encourage you to try it. Begin by installing [Pugs](http://search.cpan.org/perldoc?pugs), a Perl 6 compiler implemented in Haskell. Note that you will also need Haskell (see directions in the Pugs *INSTALL* file for how to get it).

Of course, Pugs is not finished. It couldn't be. The Perl 6 design is still in progress. However, Pugs still has many key features that are going to turn our favorite language into something even greater.

### A Simple Script

I'm about to take a big risk. I'm going to show you a script that performs Newton's method. Please don't give up before you get started.

Sir Isaac Newton was a noted computer scientist and sometime astronomer, physicist, and mathematician, as the communications of the ACM once described him. He and others developed a fairly simple way of finding square roots. It goes like this:

        #!/usr/bin/pugs
        use v6;

        my Num  $target = 9;
        my Num  $guess  = $target;

        while (abs( $guess**2 - $target ) > 0.005) {
            $guess += ( $target - $guess**2 ) / ( 2 * $guess );

            say $guess;
        }

This version always finds the square root of 9, which conveniently is 3. This aids testing because I don't have to remember a more interesting square root, for example, the square root of 2. When I run this, the output is:

        5
        3.4
        3.0235294117647058823529411764705882352941
        3.0000915541313801785305561913481345845731

The last number is the square root of 9 accurate to three decimal places.

Here's what's going on.

Once Pugs is installed, you can use it in a shebang line (on Unix or Cygwin, at least). Otherwise, invoke the script through `pugs` as you would for `perl`:

    $ pugs newton

To let Perl 6 know that I want Perl 6 and not Perl 5, I type `use v6;`.

In Perl 6, the basic primitive types are still scalar, array, and hash. There are also more types of scalars. In this case, I'm using the floating-point type Num for both the target (the number whose square root I want) and the guess (which I hope will improve until it is the square root of the target). I can use this syntax in Perl 5. In Perl 6 it will be the norm (or so I hope). I've used `my` to limit the scope of the variables just as in Perl 5.

Newton's method always needs a guess. Without explaining, I'll say that for square roots the guess makes little difference. To make it easy, I guessed the number itself. Obviously, that's not a good guess, but it works eventually.

The while loop goes until the square of the guess is close to the target. How close is up to me. I chose .005 to give about three places of accuracy.

Inside the loop, the code improves the guess at each step using Newton's formula. I won't explain it at all. (I've resisted the strong temptation from my math-teacher days to explain a lot more. Be glad I resisted. But if you are curious, consult a calculus textbook. Or better yet, send me email. I'd love to say more!) I'll present a more general form of the method soon, which may jog the memories of the calculus lovers in the audience, or not.

Finally, at the end of each iteration, I used `say` to print the answer. This beats writing: `print "$guess\n";`.

Except for using `say` and declaring the type of the numbers to be `Num`, there's not much to separate the above script from one I might have written in Perl 5. That's okay. It's about to get more Perl 6ish.

### An Exporting Module

While it's fine to have a script that finds square roots, it would be better to generalize this in a couple of ways. One good change is to make it a module so that others can share it. Another is to turn loose the power of Newton and look for other kinds of roots, like cube roots and other even more exotic ones.

First, I'll turn the script above into a module that exports a `newton` sub. Then, I'll tackle generalizing the method.

When I'm finished, I want to be able to use the module like this:

        #!/usr/bin/pugs

        use Newton;

        my $answer = newton(4);

        say $answer;

Because `say` is so helpful, I could combine the last two statements:

            say "{ newton(4) }";

That's right, strings will run code if you put it in braces.

The module, *Newton.pm*, looks like this:

        package Newton;
        use v6;

        sub newton(Num $target) is export {
            my Num  $guess  = $target;

            while (abs( $guess**2 - $target ) > 0.005) {
                $guess += ( $target - $guess**2 ) / ( 2 * $guess );
            }

            return $guess;
        }

Here begins the familiar package declaration borrowed from Perl 5. (In Perl 6 itself, `package` identifies Perl 5 source code. The [v6](http://search.cpan.org/v6?v6) module lets you run some Perl 6 code in Perl 5 programs.) Immediately following is `use v6;`, just as in the original script.

Declaring subs in Perl 6 doesn't have to be any different than in Perl 5, but it should be. This one says it takes a numeric variable called `target`. Such genuine prototypes allow for Perl 6 to report compilation errors when you call a sub with the wrong arguments. That single step will move Perl 6 onto the list of possible languages for a lot of large-scale application development shops.

At the end of the declaration, just before the opening brace for the body, I included `is export`. This puts `newton` into the namespace of whoever uses the module (at least, if they use the module in the normal way; they could explicitly decline to take imports). There is no need to explicitly use `Exporter` and set up `@EXPORT` or its friends.

The rest of the code is the same, except that it returns the answer and no longer proclaims its guess at each iteration.

### Assigning Defaults

Adding genuine, compiler-enforced parameters to sub declarations is a giant leap forward for Perl. For many people, that particular looseness in Perl 5 keeps it out of any discussions about what language to use for a project. I experienced this unfortunate reality firsthand in my last job. There's a lot more to declarations in Perl 6, though.

Suppose I want to give the caller control over the accuracy of the method, yet I want to provide a sensible default if that caller doesn't want to think of a good one. I might write:

        package Newton;
        use v6;

        sub newton(
            Num  $target,
            Num  :$epsilon = 0.005,  # note the colon
            Bool :$verbose = 0,
        ) is export {
            my Num  $guess  = $target;

            while (abs( $guess**2 - $target ) > $epsilon ) {
                $guess += ( $target - $guess**2 ) / ( 2 * $guess );
                        say $guess if $verbose;
            }

            return $guess;
        }

Here I've introduced two new optional parameters: `$verbose`, for whether to print at each step (the default is to keep quiet) and `$epsilon`, the Greek letter we math types often use for tolerances.

While the caller might use this exactly as before, she now has options. She might say:

        my $answer = newton(165, verbose => 1, epsilon => .00005);

This gives extra accuracy and prints the values at each iteration (which prints the value of the last iteration twice: once in the loop and again in the driving script). Note that the named parameters may appear in any order.

### Making Assumptions

Finally, Newton's method can find roots for more things than just squares. To make this general requires a bit more work and some extra math (which I'll again brush under the rug).

It is easy enough to supply the function for which you want roots. For example, the squaring function could be:

            sub f(Num $x) { $x**2 }

Then, in the update line of the loop, write:

        $guess += ( $target - f($guess) ) / ( 2 * $guess );

Changing `f` would change the roots you seek.

The problem is on the far side of the division symbol. `2 * $guess` depends on the function (it's the first derivative, for those who care). I could require the caller to provide this, as in:

            sub fprime(Num $x) { 2 * $x }

Then the update would be:

        $guess += ( $target - f($guess) ) / fprime($guess);

There are two problems with this approach. First, you need a way for the caller to pass those functions into the sub. That's actually pretty easy; just add parameters of type Code to the list:

        sub newton(
            Num  $target,
            Code $f,
            Code $fprime,
            Num  :$epsilon = 0.005,
            Bool :$verbose = 0,
        ) is export {

The second problem is that the caller may not know how to calculate `$fprime`. Perhaps I should make calculus a prerequisite for using the module, but that just might scare away a few potential users. I want to provide a default, but the default depends on what the function is. If I knew what `$f` was, I could estimate `$fprime` for users.

Perl 6 provides precisely this ability. Here's the final module, a bit at a time:

        package Newton;

        use v6;

That's nothing new.

        sub approxfprime(Code $f, Num $x) {
            my Num $delta = 0.1;
            return ($f($x + $delta) - $f($x - $delta))/(2 * $delta);
        }

For those who care (surely at least one person does), this is a second-order centered difference. For those who don't, its an approximation suitable for use in the `newton` sub. It takes a function and a number and returns an estimate of the value needed for division.

        sub newton(
            Num  $target,
            Code $f,
            Code :$fprime         = &approxfprime.assuming( f => $f ),
            Num  :$epsilon        = 0.0005,
            Bool :$verbose        = 0,
        ) returns Num is export {
            my Num $guess  = $target / 2;

            while (abs($f($guess) - $target) > $epsilon) {

                $guess += ($target - $f($guess)) / $fprime($guess);

                say $guess if $verbose;
            }
            return $guess;
        }

A script using this program could be as simple as:

        #!/usr/bin/pugs

        use Newton;

        sub f(Num $x) { return $x**3 }

        say "{ newton(8, \&f, verbose => 1, epsilon => .00005) }";

Note that the caller must supply the function `f`. The one in the example is for cube roots.

If the caller provides the derivative as `fprime`, I use it. Otherwise, as in the example, I use `approxfprime`. Whereas a caller-supplied `fprime` would take one number and return another, `approxfprime` needs a number and a function. The function needed is the one the caller passed to `newton`. How do you pass it on? Currying—that is, supplying one or more of the parameters of a function once, then using the simplified version after that.

In Perl 6, you can obtain a reference to a sub by placing the sub sigil `&` in front of the function's name (providing it is in scope). To curry, add `.assuming` to the end of that and supply values for one or more arguments in parentheses. All of this is harder to talk about than to do:

        Code :$fprime         = &approxfprime.assuming( f => $f ),

This code means that the caller might supply a value. If this is the case, use it. Otherwise, use `approxfprime` with the caller's function in place of `f`.

### Conclusion

Perl 6 calling conventions are extremely well designed. Not only do they allow compile-time parameter checking, they also allow named parameters with or without complex defaults, even including curried default functions. This is going to be very powerful. In fact, with Pugs, it already is.

There is a slightly more detailed version of the example from this article in the *examples/algorithms/* directory of the Pugs distribution. It's called *Newton.pm*.

### Disclaimer

As much as it pains me to say it, if you need heavy duty numerics, don't code in pure Perl. Rather, use FORTRAN, C, or Perl with PDL. And be careful. Numerics is full of unexpected gotchas, which lead to poor performance or outright incorrect results. Unfortunately, Newton's method, in the general case, is notoriously risky. When in doubt about numerics, do as I do and consult a professional in the field.
