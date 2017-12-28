{
   "slug" : "198/2015/10/14/Understanding-Haskell-types",
   "draft" : false,
   "description" : "The basics",
   "image" : "/images/198/2812558A-6F58-11E5-9A38-7E733498AD2D.png",
   "authors" : [
      "david-farrell"
   ],
   "date" : "2015-10-14T12:47:18",
   "title" : "Understanding Haskell types",
   "categories" : "development",
   "tags" : [
      "types",
      "oreilly",
      "cis194",
      "lyas",
      "ghci"
   ]
}


I recently took a break from Perl work to study at the [Recurse Center](http://recurse.com). I'm learning Haskell, and it's been an interesting adventure so far. I'd heard good things about Haskell's type system and started with an introductory book [Learn You a Haskell for Great Good!](http://learnyouahaskell.com/). The book is filled with cartoonish humor - "how hard can this be?" I asked myself. The answer was "hard". I found Haskell's type system to be counter-intuitive, so this article lays out my understanding of Haskell types. If you're a programmer with an imperative programming background, you might find this useful.

### Your intuition is wrong

For imperative-language programmers, Haskell keywords are likely to mislead. Take the `type` keyword for instance. It's not for creating new types per se, but *type synonyms*, which are like aliases for existing types. I might use it like this:

```perl
type FirstName = String
type LastName = String
type Age = Int
```

One way to declare new types is with the `data` keyword (naturally!). If I wanted to create a person type, I could use `data` :

```perl
data Person = Person String String Int
```

This declares a new type called `Person` with 2 strings and 1 integer as attributes. But I could also use our type synonyms from the earlier example, and clarify my intentions:

```perl
data Person = Person FirstName LastName Age
```

### Functions and types

In Haskell function signatures can be restricted by types. I can create a function to tell which of two people is older:

```perl
eldest :: Person -> Person -> String
eldest (Person x1 y1 z1) (Person x2 y2 z2)
  | z1 > z2   = x1 ++ " " ++ y1 ++ " is older"
  | z1 < z2   = x2 ++ " " ++ y2 ++ " is older"
  | otherwise = "They're the same age!"
```

This is a lot of new syntax, so bear with me. The first line declares a function called `eldest` which takes two persons and returns a string. The second line assigns the attributes of each person to variables. The rest of the function tests which person is older and returns an appropriate message. I'll save all of this code into a file called "person.hs", so I can test the function in the Haskell REPL, `ghci`

```perl
ghci> :l person.hs
[1 of 1] Compiling Main             ( person.hs, interpreted )
Ok, modules loaded: Main.
ghci> let a = Person "Bart" "Simpson" 10
ghci> let b = Person "Lisa" "Simpson" 7
ghci> eldest a b
"Bart Simpson is older"
```

Sometimes we don't need to access all of the attributes of a type in a function. In these cases Haskell let's you use `_` as a placeholder, that won't be assigned to a variable. For example to print the initials of a person, I only need to know their first and last names:

```perl
initials :: Person -> String
initials (Person x y _) = [head x,'.',head y, '.']
```

The second line of code assigns a person's firstname to `x` and lastname to `y`. It then takes the first char of each using `head` and returns a new list of chars with a dot after each char. I can test the function by reloading "person.hs":

```perl
ghci> :l person.hs
[1 of 1] Compiling Main             ( person.hs, interpreted )
Ok, modules loaded: Main.
ghci> let a = Person "Maggie" "Simpson" 1
ghci> initials a
"M.S."
```

### Typeclasses

Typeclasses are similar to traits (roles in Perl-speak) for types. For example, integers are instances of typeclasses like `Ord` as they are orderable, `Num` as they are numbers, and so on. Each typeclass defines functions for handling types in specific contexts. The `Eq` typeclass adds the ability to compare types for equality using operators like `==`.

By generalizing the properties of types with typeclasses, Haskell can support generic functions which operate on typeclasses, instead of being restricted to one type. The signature of the `quicksort` function from [Learn You a Haskell](http://learnyouahaskell.com/recursion) is a great example of this:

```perl
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =·
    let smallerSorted = quicksort [a | a <- xs, a <= x]
        biggerSorted = quicksort [a | a <- xs, a > x]
    in  smallerSorted ++ [x] ++ biggerSorted
```

This declares a new function called quicksort which is restricted to lists of orderable types. Ignore the body and just focus on the first line of code, the function signature. The code `(Ord a)` defines the typeclass constraint for the function. This function can be used to sort anything orderable, like lists of numbers. Aren't strings just lists of chars? I guess we can sort them with `quicksort` too then.

### Instance and Class

If you saw the `instance` keyword in some Haskell code, you might think "aha, a singleton constructor!" but actually `instance` is used to make types instances of typeclasses. This makes sense when you consider that every type is an **instance** of a typeclass. Revisiting my `Person` type from earlier, what if I wanted to make it orderable? Typically in the English-speaking parts of the world, people are sorted by their last name, so I'm going to implement it that way:

```perl
data Person = Person FirstName LastName Age deriving (Eq, Show)

instance Ord Person where
  compare (Person _ a _) (Person _ b _) = compare a b
```

I start by updating the type declaration of Person with `deriving (Eq, Show)`. These operate on the whole type (all of its attributes together). `Eq` will let Haskell compare Persons for equality and `Show` just let's Haskell serialize the type as a string. The second line of code uses `instance` to make persons orderable. The final line implements a comparison function using the lastname attribute of the Person. I can test the code using the `quicksort` function declared above.

```perl
ghci> :l person.hs
[1 of 1] Compiling Main             ( person.hs, interpreted )
Ok, modules loaded: Main.
ghci> let a = Person "Jason" "Bourne" 37
ghci> let b = Person "James" "Bond" 42
ghci> quicksort [a,b]
[Person "James" "Bond" 43,Person "Jason" "Bourne" 37]
```

This sorted our list of people by their lastname, and because `Person` is an instance of `Show`, Haskell was able to print out the detail to the command line. Not bad!

The final keyword to be aware of is `class`. By now it shouldn't surprise you to find out that `class` is not for declaring classes like in imperative programming, but for creating new typeclasses. You probably won't use this much when starting out with Haskell, but it's useful to keep in mind for reducing repetitive code. If you have multiple sets of code doing very similar things for different types, consider creating a new typeclass and merging the functions to operate on the new type class, to keep things [DRY](https://en.wikipedia.org/wiki/Don't_repeat_yourself).

### Code complete

This is the finished code:

```perl
--person.hs
type FirstName = String
type LastName  = String
type Age = Int 

data Person = Person FirstName LastName Age deriving (Eq, Show)

eldest :: Person -> Person -> String
eldest (Person x1 y1 z1) (Person x2 y2 z2)
  | z1 > z2   = x1 ++ " " ++ y1 ++ " is older"
  | z1 < z2   = x2 ++ " " ++ y2 ++ " is older"
  | otherwise = "They're the same age!"

initials :: Person -> String
initials (Person x y _) = [head x,'.',head y, '.']

quicksort [] = []
quicksort (x:xs) =·
    let smallerSorted = quicksort [a | a <- xs, a <= x]
        biggerSorted = quicksort [a | a <- xs, a > x]
    in  smallerSorted ++ [x] ++ biggerSorted

instance Ord Person where
  compare (Person _ a _) (Person _ b _) = compare a b
```

### Learn Haskell the Hard Way

Despite its childish demeanor, [Learn You a Haskell](http://learnyouahaskell.com/) goes deep into the Haskell type system and can be a bit long-winded at times. My current learning method involves reading the book, and typing out every code example, and studying Penn State's [cis194 course](https://www.cis.upenn.edu/~cis194/spring13/lectures.html). Both are free. O'Reilly's [Real World Haskell](http://book.realworldhaskell.org/read/) is also available for free online, and emphasizes more immediate practical uses of Haskell. It's good for when you're tired of coding binary search trees and sorting algorithms. If you find yourself needing to lookup a Haskell term, DuckDuckGo has the `!h` bang, which searches [Hoogle](https://www.haskell.org/hoogle/) automatically.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
