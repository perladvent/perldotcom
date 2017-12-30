{
   "description" : "Some JavaScript gotchas and solutions",
   "thumbnail" : "/images/204/thumb_60B8AF26-A444-11E5-A7E3-5B35815E78B2.png",
   "categories" : "development",
   "image" : "/images/204/60B8AF26-A444-11E5-A7E3-5B35815E78B2.png",
   "draft" : false,
   "slug" : "204/2015/12/17/Kitchen-coding-nightmares--JavaScript-scope",
   "date" : "2015-12-17T14:13:13",
   "title" : "Kitchen coding nightmares: JavaScript scope",
   "tags" : [
      "perl",
      "javascript",
      "js",
      "var",
      "es6",
      "strict",
      "requirejs",
      "jshint"
   ],
   "authors" : [
      "david-farrell"
   ]
}


Lately at the [Recurse Center](https://www.recurse.com/) I've been developing a JavaScript client for my Settlers game. As a Perl developer working with JavaScript, it has been a fun experience. JavaScript feels very perly - both share a flexible syntax, first class functions and objects as hashes. And both languages have a lax interpreter which should have been put in strict mode in the first place (ha-ha!). One way in which JavaScript is very different from Perl is its scoping rules. I was burned by these more than once, and so if you're new to JavaScript, you might find the following summary and recommendations useful.

### Functional scoping

Variables are declared with the `var` keyword:

```perl
var name = "David";
```

Variables are functionally-scoped, which means that if declared within a function, the variable is private to the function block. Variables declared outside of functions are globally scoped. And there is no other type of block scoping (such as within if-else or for loops).

```perl
var name = "David";

function log_name (name) // private
{
  console.log(name);
}

var names = ["Jen", "Jim", "Jem", "Jon"];
for (var i = 0; i < names.length; i++)
{
  var name = names[i]; // overwriting the global
}
console.log(name); // Jon NOT David
```

### Functions as variables

Function names are stored as variables under the same scoping rules as ordinary variables. There are two ways to declare functions:

```perl
function log_name () { }
```

and:

```perl
var log_name = function () { }
```

Both of these are the same. Which means it's possible to inadvertently overwrite a function with another variable declaration:

```perl
function name () { return "David"; }
var name = "John";
name(); // error, name is not a function anymore
```

### Hoisting

JavaScript interpreters have a initial-runtime phase, (similar to Perl's `BEGIN`), where all variable declarations are executed before other code. This is known as "hoisting", but practically what it means is that you can use a variable before you declare it!

```perl
console.log(name); // yep, this works
var name = "David";
```

### Bind

JavaScript makes heavy use of anonymous functions and callbacks.To modify the scope of a function, JavaScript<sup>1</sup> provides [bind](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind?redirectlocale=en-US&redirectslug=JavaScript%2FReference%2FGlobal_Objects%2FFunction%2Fbind). This is easier to understand by example. If I have a point object and I want a method to draw it to the canvas, by loading an image:

```perl
Point.prototype.draw = function()
{
  var ctx = get_canvas_context(); // declared elsewhere
  var img = new Image();
  img.onload = function () {  // anonymous function
    ctx.drawImage(img, this.x, this.y);   
  }.bind(this);
  img.src = "/point.png";
}
```

Here I use `bind` to inject the point object's scope into the anonymous function. Otherwise I wouldn't be able to access the `x` and `y` properties of the point as `this` would be referencing something else.

For a more thorough explanation of JavaScript scope, I recommend Todd Motto's article, [Everything you wanted to know about JavaScript scope](https://toddmotto.com/everything-you-wanted-to-know-about-javascript-scope/).

### Coping with scoping

OK so that was the bad news; the good news is there are plenty of techniques for handling JavaScript's scoping rules. Depending on the context you may find some or all of these methods useful.

#### Naming conventions

The first thing you can do to avoid clashes is adopt a naming convention. For example, name all functions with verb-noun constructs (like "get\_address") and all value variables with plain nouns (like "addresses"). This is not a complete solution, but at a minimum it will reduce the chances of a function being replaced by a value variable.

#### One var per scope

Another technique for managing variable scope is to only allow one `var` statement per scope. So a typical program might look like this:

```perl
// declare global scope variables
var foo = "/root/assets",
    bar = 0;

function execute (foo)
{
  var i, j, bar; // functional scope

  for (i = 0; i < foo.length; i++)
  {
    for (j = 0; j < foo.length; j++)
    {
      // do something
    }
  }
}
```

#### Use strict

This is a convention all Perl programmers should be comfortable with. Enable [strict mode](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode) in JavaScript. Just like with Perl, JavaScript's strict mode can catch [several](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode#Changes_in_strict_mode) cases of variable-related bugs. Enable it globally with:

```perl
"use strict";
```

Generally JavaScript experts [recommend](http://yuiblog.com/blog/2010/12/14/strict-mode-is-coming-to-town/) using a functionally-scoped version of strict - in this case the declaration is placed inside a function block. This is useful to prevent script concatenation errors (where an imported script does not satisfy the strict rules).

```perl
(function () {
   "use strict";
   // this function is strict...
}());
```

#### Objects as namespaces

If you were thinking a simple way to solve all of the namespace clashes was with modules, allow me to be the first to tell you that JavaScript has no notion of modules (being a [prototyped language](https://en.wikipedia.org/wiki/Prototype-based_programming)). There is no `import` keyword. In HTML any code that is loaded with a `script` tag is simply concatenated to the current scope.

There are solutions to this limitation though. In [JavaScript the Definitive Guide](http://www.amazon.com/JavaScript-Definitive-Guide-Activate-Guides/dp/0596805527/ref=dp_ob_title_bk), author David Flanagan proposes using objects as namespaces (sixth edition, section 9.9.1). Each object's scope can be used to encapsulate the behavior and data specific to that domain. For example:

```perl
// everything is scoped to point.*
var point = {};
point.Point = function (_x, _y) {
  this.x = _x;
  this.y = _y
}

point.Point.prototype.coordinates = function ()
{
  return [this.x, this.y];
}

// now lets try it out ...
var p = new point.Point(1,3);
console.log(p.coordinates());
```

To package code as modules, there is the [module pattern](http://www.adequatelygood.com/JavaScript-Module-Pattern-In-Depth.html). Finally although JavaScript has no native import method, there are several external libraries that can provide that behavior, like [RequireJS](http://www.requirejs.org/).

#### Let

The next major version of JavaScript, ES6 provides [let](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/let). This keyword provides block-level scoping of variables, similar to other mainstream languages. ES6 is not supported everywhere yet, but you can use a transpiler like [Babel](https://babeljs.io/) to convert ES6 JavaScript back to ES5.

#### Use a code linter

Browsers do not throw enough exceptions when processing JavaScript. Instead they try to soldier on and do what the programmer *meant* rather than what they typed. This is good<sup>2</sup> for users as they get a uninterrupted browsing experience, but for us programmers this is definitely a bad thing™. Browser robustness makes JavaScript difficult to debug, and which is where a code linter steps in - it analyzes code and reports any errors or warnings they find. For JavaScript I like [JSHint](http://jshint.com/).

<sup>1</sup> Introduced in ES5 JavaScript - which is supported by all modern browsers. For solutions for older JavaScript versions, use `call` or `apply`.

<sup>2</sup> It's probably a bad thing for users too - the overhead in processing syntactically wrong code degrades performance and worse, encourages more incorrect code to be written.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
