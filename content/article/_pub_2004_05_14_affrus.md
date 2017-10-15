{
   "categories" : "Tooling",
   "title" : "Affrus: An OS X Perl IDE",
   "authors" : [
      "simon-cozens"
   ],
   "image" : null,
   "thumbnail" : "/images/_pub_2004_05_14_affrus/111-affrus.gif",
   "date" : "2004-05-14T00:00:00-08:00",
   "description" : " When I last reviewed a Perl IDE, ActiveState's Komodo, I was nearly convinced; the only problem was that I use Mac OS X. Now, Late Night Software, more commonly known for their AppleScript tools, have taken their Mac programming...",
   "draft" : null,
   "tags" : [
      "affrus",
      "ide",
      "komodo",
      "os-x-ide",
      "unix-editors"
   ],
   "slug" : "/pub/2004/05/14/affrus.html"
}



When I [last reviewed](/pub/a/2002/10/09/komodo.html) a Perl IDE, ActiveState's Komodo, I was nearly convinced; the only problem was that I use Mac OS X. Now, [Late Night Software](http://www.latenightsw.com/), more commonly known for their AppleScript tools, have taken their Mac programming experience and applied it to create [Affrus](http://www.latenightsw.com/affrus/index.html), a Perl IDE for the Mac. And I'm a little closer to being convinced.

Affrus differs from Komodo in some substantial ways. Where Komodo couples its editor tightly with a Perl interpreter to allow background syntax checking and on-the-fly warnings highlighting, Affrus takes a more traditional, detached approach: syntax checks are performed on demand, with errors and warnings placed in a separate panel. Fans of `emacs`'s debugging modes will be happier to see this:

<img src="/images/_pub_2004_05_14_affrus/affrus-stricterror.jpg" width="500" height="280" />
It took me quite awhile to discover the control-click contextual menu -- since the downside of "intuitive" applications is that we don't get a nice manual to read any more -- but when I did I was amazingly impressed. Right-clicking on a package name does just what you want; it allows you to edit that package's file, or to view its documentation with perldoc. Similarly, right-clicking on a built-in offers to bring up perldoc for that function.

Right-clicking on the name of a subroutine lets you navigate to the definition of that routine -- even doing a remarkably good job at working out what class a method will come from. And right-clicking on a variable name takes you to where that variable was declared. Right-clicking on the navigation bar at the bottom of the window brings up a "table of contents" for the program, allowing you to navigate to any of the modules it uses and any of the subroutines it defines. If you right-click on empty space, however, you get a listing of variables and subroutine names that can be inserted at that location. Full marks for this, and the more time I spend with the Affrus editor, the more neat things like this I find.

On the whole, though, the Affrus editor is relatively basic. While its syntax highlighting is more sophisticated than most, distinguishing between package, lexical, and special variables, for instance, it does not handle code folding, nor does it have "smart" auto-indenting. It's quite comparable to the original `emacs` `perl-mode`. However, this isn't necessarily a problem, due to Affrus' integration with other editors such as BBEdit and TextWrangler; additionally, Late Night's AppleScript experience has enabled them to design Affrus to be extensible and scriptable. Script plugins provided with Affrus allow it to reformat code with `perltidy`, as well as to insert control structures and other snippets into the current file.

As well as its scriptability, the real boon in Affrus is in its debugging console; on top of the usual debugging actions of stepping over a script, jumping in and out of subroutines, setting breakpoints, and so on, it presents at every step a detailed listing of all the variables in play, allowing you to look inside complex data structures with OS X's familiar disclosure triangles:

<img src="/images/_pub_2004_05_14_affrus/affrus-debug.jpg" width="500" height="337" />
As one would expect, it automatically loads up modules and other external Perl code while debugging, allowing you to step over their code, too. You can also change the value of variables during debugging, as well as enter arbitrary Perl expressions in the "Expressions" pane.

Affrus offers a few other interesting little features, such as the debugger's ability to detect and highlight circular references, and the bundled command line tool. This utility enables you to debug a Perl program in Affrus while having complete control over the environment and standard IO redirections -- a major bridge between GUI-based debugging and the "real world" of complex Perl program deployments.

There are a few things Affrus doesn't do which I'd like, but to be honest they're a part of the way I use Perl -- an IDE with integrated debugger and Perl-aware editor is a great environment for creating standalone Perl scripts where you're running through a process, breaking at significant moments, inspecting the control flow and the state of the variables. However, when you work primarily at the level of Perl modules and Apache handlers, there is no real top-level "process" to step through, and a traditional debugging environment becomes much less useful.

That said, in such a debugging environment, I'd love to see Affrus have a Perl debugger pane at which one could execute Perl code during a debugger run; inspecting the variables is great, but there ought to be a way to change them, too! There are other changes I'd like to see in the future, ranging from something as trivial as a color scheme palette -- the first thing I did on running Affrus was to spend 10 minutes configuring it with a set of colors that look nice on a black background instead of a white one! -- to full-blown integration with either CVS or even Apple's Xcode IDE.

On the whole, however, I'm very impressed by Affrus, and I'm convinced that, even if it's not to your taste yet, it is certain to grow into a mature and powerful Perl IDE for OS X.
