{
   "description" : "There are a number of tools available for writing books. Many people would immediately reach for their favorite word processor, but having written one book using Microsoft Word I'm very unlikely to repeat the experience. Darren Chamberlain, Andy Wardley, and...",
   "slug" : "/pub/2004/01/30/ttbook.html",
   "draft" : null,
   "authors" : [
      "dave-cross"
   ],
   "date" : "2004-01-30T00:00:00-08:00",
   "categories" : "tooling",
   "title" : "How We Wrote the Template Toolkit Book ...",
   "image" : null,
   "tags" : [
      "documentation",
      "template-toolkit"
   ],
   "thumbnail" : "/images/_pub_2004_01_30_ttbook/111-ptt.gif"
}



There are a number of tools available for writing books. Many people would immediately reach for their favorite word processor, but having written one book using Microsoft Word I'm very unlikely to repeat the experience. Darren Chamberlain, Andy Wardley, and I are all Perl hackers, so when we got together to write [Perl Template Toolkit](http://www.oreilly.com/catalog/perltt/index.html?CMP=IL7015), it didn't take us long to agree that we wanted to write it using POD (Plain Old Documentation).

Of course, any chosen format has its pros and cons. With POD we had all the advantages of working with plain text files and all of the existing POD tools were available to convert our text into various other formats, but there were also some disadvantages. These largely stem from the way that books (especially technical books) are written. Authors rarely write the chapters in the order in which they are published in the finished book. In fact, it's very common for the chapters to rearranged a few times before the book is published.

Now this poses a problem with internal references. It's all very well saying "see chapter Six for further details", but when the book is rearranged and Chapter Six becomes Chapter Four, all of these references are broken. Most word processors will allow you to insert these references as "tags" that get expanded (correctly) as the document is printed. POD and emacs doesn't support this functionality.

Another common problem with technical books is the discrepancy between the code listings in the book and the code that actually got run to produce the output shown. It's easily done. You create an example program and cut-and-paste the code into the document. You then find a subtle bug in the code and fix it in the version that you're running but forget to fix it in the book. What would be really useful would be if you could just use tags saying "insert this program file here" and even "insert the output of running the program here". That's functionality that no word processor offers.

Of course, these shortcomings would be simple to solve if you had a powerful templating system at the ready. Luckily Andy, Darren, and I had the Template Toolkit (TT) handy.

### <span id="The_Book_Templates">The Book Templates</span>

We produced a series of templates that controlled the book's structure and a Perl program that pulled together each chapter into a single POD file. This program was very similar to the `tpage` program that comes with TT, but was specialized for our requirements.

#### <span id="Separating_code_from_code">Separating Code from Code</span>

There was one problem we had to address very early on with our book templates. This was the problem of listing TT code within a TT template. We needed a way to distinguish the template directives we were using to produce the book from the template directives we were demonstrating *in the book*.

Of course TT provides a simple way to achieve this. You can define the characters that TT uses to recognize template directives. By default it looks for `[% ... %]`, but there are a number of predefined groups of tags that you can turn on using the `TAGS` directive. All of our book templates started with the line:

      [% TAGS star %]

When it sees this directive, the TT parser starts to look for template directives that are delimited with `[* ... *]`. The default delimiters (`[% ... %]`) are treated as plain text and passed through unaltered. Therefore, by using this directive we can use `[% ... %]` in our example code and `[* ... *]` for the template directives that we wanted TT to process.

Of course, the page where we introduced the `TAGS` directive and gave examples of its usage was still a little complex.

In the rest of this article, I'll go back to using the `[% ... %]` style of tags.

#### <span id="Useful_blocks_and_macros">Useful Blocks and Macros</span>

We defined a number of useful blocks and macros that expanded to useful phrases that would be used throughout the book. For example:

      [% TT = 'Template Toolkit';

         versions = {
           stable = '2.10'
           developer = '2.10a'
         } %]

The first of these must have saved each of us many hours of typing time and the second gave us an easy way to keep the text up-to-date if Andy released a new version of TT while we were writing the book. A template using these variables might look like this:

      The current stable version of the [% TT %] is [% stable %]

#### <span id="Keeping_track_of_chapters">Keeping Track of Chapters</span>

We used a slightly more complex set of variables and macros to solve the problem of keeping chapter references consistent. First we defined an array that contained details of the chapters (in the current order):

      Chapters = [
        {  name  = 'intro'
           title = "Introduction to the Template Toolkit"
        }
        {  name  = 'web'
           title = "A Simple Web Site"
        }
        {  name  = 'language'
           title = "The Template Language"
        }
        {  name  = 'directives'
           title = "Template Directives"
        }
        {  name  = 'filters'
           title = "Filters"
        }
        {  name  = 'plugins'
           title = "Plugins"
        }
        ... etc ...
       ]

Each entry in this array is a hash with two keys. The name is the name of the directory in our source tree that contains that chapter's files and the title is the human-readable name of the chapter.

The next step is to convert this into a hash so that we can look up the details of a chapter when given its symbolic name.

        FOREACH c = Chapters;
          c.number = loop.count;
          Chapter.${c.name} = c;
        END;

Notice that we are adding a new key to the hash that describes a chapter. We use the `loop.count` variable to set the chapter number. This means that we can reorder our original `Chapters` array and the chapter numbers in the `Chapter` hash will always remain accurate.

Using this hash, it's now simple to create a macro that lets us reference chapters. It looks like this:

      MACRO chref(id) BLOCK;
        THROW chapter "invalid chapter id: $id"
          UNLESS (c = Chapter.$id);
        seen = global.chapter.$id;
        global.chapter.$id = 1;
        seen ? "Chapter $c.number"
             : "Chapter $c.number, I<$c.title>";
      END;

The macro takes one argument, which is the id of the chapter (this is the unique name from the original array). If this chapter doesn't exist in the `Chapter` hash then the macro throws an error. If the chapter exists in the hash then the macro displays a reference to the chapter. Notice that we remember when we have seen a particular chapter (using `global.chapter.$id`) -- this is because O'Reilly's style guide says that a chapter is referenced differently the first time it is mentioned in another chapter. The first time, it is referenced as "Chapter 2, *A Simple Web Site*", and on subsequent references it is simply called "Chapter 2. "

So with this mechanism in place, we can have templates that say things like this:

      Plugins are covered in more detail in [% chref(plugins) %].

And TT will convert that to:

      Plugins are covered in more detail in Chapter 6, I<Plugins>.

And if we subsequently reorder the book again, the chapter number will be replaced with the new correct number.

#### <span id="Running_example_code">Running Example Code</span>

The other problem I mentioned above is that of ensuring that sample code and its output remain in step. The solution to this problem is a great example of the power of TT.

The macro that inserts an example piece of code looks like this:

      MACRO example(file, title) BLOCK;
        global.example = global.example + 1;
        INCLUDE example
          title = title or "F<$file>"
          id    = "$chapter.id/example/$file"
          file  = "example/$file"
          n     = global.example;
        global.exref.$file = global.example;
      END;

The macro takes two arguments, the name of the file containing the example code and (optionally) a title for the example. If the title is omitted then the filename is used in its place. All of the examples in a particular chapter are numbered sequentially and the `global.example` variable holds the last used value, which we increment. The macro then works out the path of the example file (the structure of our directory tree is very strict) and `INCLUDE`s a template called `example`, passing it various information about the example file. After processing the example, we store the number that is associated with this example by storing it in the hash `global.exref.$file`.

The `example` template looks like this:

\[% IF publishing -%\] =begin example \[% title %\]

          Z<[% id %]>[% INSERT $file FILTER indent(4) +%]

      =end
      [% ELSE -%]
      B<Example [% n %]: [% title %]>

      [% INSERT $file FILTER indent(4) +%]

\[% END -%\]

This template looks at a global flag called `publishing`, which determines if we are processing this file for submission to O'Reilly or just for our own internal use. The `Z< ... >` POD escape is an O'Reilly extension used to identify the destination of a link anchor (we'll see the link itself later on). Having worked out how to label the example, the template simply inserts it and indents it by four spaces.

This template is used within our chapter template by adding code like `[% example('xpath', 'Processing XML with XPath') %]` to your document. That will be expanded to something like, "Example 2: Processing XML with Xpath," followed by the source of the example file, `xpath`.

All of that gets the example code into that document. We now have to do two other things. We need to be able to reference the code from the text of the chapter ('As example 3 demonstrates...'), and we also need to include the results of running the code.

For the first of these there is a macro called `exref`, which is shown below:

      MACRO exref(file) BLOCK;
        # may be a forward reference to next example
        SET n = global.example + 1
          UNLESS (n = global.exref.$file);
        INCLUDE exref
          id    = "$chapter.id/example/$file";
      END;

This works in conjunction with another template, also called `exref`.

      [% IF publishing -%]
      A<[% id %]>
      [%- ELSE -%]
      example [% n %]
      [%- END -%]

The clever thing about this is that you can use it *before* you have included the example code. So you can do things like:

      This is demonstrated in [% exref('xpath') %].

      [% example('xpath', 'Processing XML with XPath') %]

As long as you only look at a maximum of one example ahead, it still works. Notice that the `A< ... >` POD escape is another O'Reilly extension that marks a link anchor. So within the O'Reilly publishing system it's the `A<foo>` and the associated `Z<foo>` that make the link between the reference and the actual example code.

The final thing we need is to be able to run the example code and insert the output into the document. For this we defined a macro called `output`.

      MACRO output(file) BLOCK;
        n = global.example;
        "B<Output of example $n:>\n\n";
        INCLUDE "example/$file" FILTER indent(4);
      END;

This is pretty simple. The macro is passed the name of the example file. It assumes that this is the most recent example included in the document so it gets the example number from `global.example`. It then displays a header and `INCLUDE`s the file. Notice that the major difference between `example` and `output` is that `example` uses `INSERT` to just insert the file's contents, whereas `output` uses `INCLUDE`, which loads the file and processes it.

With all of these macros and templates, we can now have example code in our document and be sure that the output we show really reflects the output that you would get by running that code. So we can put something like this in the document:

      The use of GET and SET is demonstrated in [% exref('get_set') %].

      [% example('get_set', 'GET and SET') %]

      [% output('get_set') %]

And that will be expanded to the following.

      The use of GET and SET is demonstrated in example 1.

      B<Example 1: GET and SET>

          [% SET foo = 'bar -%]
          The variable foo is set to "[% GET foo %]".

      B<Output of example 1:

          The variable foo is set to "bar".

As another bonus, all of the example code is neatly packaged away in individual files that can easily be made into a tarball for distribution from the book's web site.

#### <span id="Other_templates,_blocks_and_macros">Other Templates, Blocks, and Macros</span>

Once we started creating these timesaving templates, we found a huge numbers of areas where we could make our lives easier. We had macros that inserted references to other books in a standard manner, macros for inserting figures and screenshots, as well as templates that ensured that all our chapters had the same standard structure and warned us if any of the necessary sections were missing. I'm convinced that the TT templates we wrote for the project saved us all a tremendous amount of time that would have otherwise been spent organizing and reorganizing the work of the three authors. I would really recommend a similar approach to other authors.

The Template Toolkit is often seen as a tool for building web sites, but we have successfully demonstrated one more non-Web area where the Template Toolkit excels.
