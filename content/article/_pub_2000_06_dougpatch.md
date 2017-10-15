{
   "date" : "2000-06-27T00:00:00-08:00",
   "title" : "Notes on Doug's Method Lookup Patch",
   "image" : null,
   "categories" : "community",
   "thumbnail" : null,
   "tags" : [],
   "description" : null,
   "slug" : "/pub/2000/06/dougpatch.html",
   "draft" : null,
   "authors" : [
      "simon-cozens"
   ]
}



<span id="__index__"></span>

[Speeding up method lookups](#speeding%20up%20method%20lookups)

-   [Methods and subroutines](#methods%20and%20subroutines)
-   [What entersub knows about methods](#what%20entersub%20knows%20about%20methods)
-   [When to convert methods](#when%20to%20convert%20methods)
-   [How to convert methods](#how%20to%20convert%20methods)
-   [Finding the stash](#finding%20the%20stash)
-   [Extract the GV entry](#extract%20the%20gv%20entry)
-   [Rewrite entersub](#rewrite%20entersub)
-   [Conclusion](#conclusion)
-   [Exercises](#exercises)

------------------------------------------------------------------------

<span id="speeding up method lookups">Speeding up method lookups</span>
=======================================================================

Last week, Doug MacEachern provided an interesting and extremely clever patch to speed up method calls. His benchmarks showed that it completely reduced the overhead of using methods, and appeared to suggest that method calls could actually be faster than subroutine calls. Let's have a look at the patch in detail, to see how it's done.

Here's the original musing from Sarathy, which started it all off:

        If @ISA isn't modified at run time, Foo::->bar() could be resolved
        at compile time to a subroutine call, as can this:

        my Foo $obj = shift;
        $obj->bar();

As all the tutorials on Perl's object-oriented programming rightly state, when you call a method, you're calling a subroutine. The difference, however, is that a method call has to perform a lookup to find out which package its subroutine lives in.

In the normal case without inheritance, `Foo->bar()` will be subroutine `bar` in package `Foo`. However, because of inheritance, you can't tell just by looking at `Foo->bar()` where `bar` is going to be - `Foo` may inherit `bar` from `Frob`, from example.

To resolve this, when you call a method, Perl checks for a subroutine `bar` in package `Foo`. If it doesn't find one, it checks `Foo`'s parents: all the packages listed in `Foo`'s `@ISA` array. It then checks the grandparents, and so on. This lookup has to be done at run-time, instead of compile time, because `@ISA` is an ordinary variable - someone may change the inheritance tree from under your feet.

Sarathy's thought was that if you know for sure what's going to be in `@ISA` at the time you perform the compilation, you change an expensive method call into a slightly less expensive subroutine call. And that's what Doug's patch does.

We can divide the patch up into two parts: the function `method_to_entersub` performs the conversion and tells us **how** it's done, and the part of the code which calls `method_to_entersub`, telling us **when** it's done. We'll look first at the when.

Before we do that, though, a little detour about how subroutine calling works internally.

Perl constructs the `entersub` op in a similar way for a method call and an ordinary subroutine call. The difference is that for a subroutine call, the `entersub` op is preceded by an op that fetches the GV that holds the subroutine code, and for a method call, the `entersub` op is preceded by an op that looks up the method name in the inheritance tree. You can see this in the following `B::Terse` output.

            % perl -MO=Terse,exec -e 'bar()'
            ...
            SVOP (0xa043b00) gv  GV (0xa04ecf8) *bar              <- cvop
            UNOP (0xa0b6a60) entersub [1]
            ...

For a method call, though, Perl also attaches an op representing the class (let's call it `o2`, since that's as good a name as any) and `svop`, instead of being a GV, becomes a special op to signify that a method should be called in that class:

        % perl -MO=Terse,exec -e 'Foo->bar()'
        ...
        SVOP (0xa043b00) const  PV (0xa0411f0) "Foo"          <- o2
        SVOP (0xa043b40) method_named  PVIV (0xa04ecf8) "bar" <- cvop
        UNOP (0xa0d0500) entersub [1]
        ...

For class methods, `o` is a constant, while for object methods, `o2` fetches the object, allowing us to work out the class at run time:

        % perl -MO=Terse,exec -e '$foo->bar()'
        ...
        SVOP (0xa043b00) gvsv  GV (0xa04ecf8) *foo            <- o2
        SVOP (0xa0d5720) method_named  PVIV (0xa0411f0) "bar" <- cvop
        UNOP (0xa0d04d0) entersub [1]
        ...

`method_named` is the op representing, unsurprisingly, a named method. You can also call methods on the fly, like this:

                    Foo->$methname()

and in this case, the `method` op is preceded by an op that fetches the method name from `$methname`. In this example, it's a simple variable lookup:

        % perl -MO=Terse,exec -e 'Foo->$x()'
        ...
        SVOP (0xa043b00) const  PV (0xa0411f0) "Foo"          <- o2
        SVOP (0xa043b60) gvsv  GV (0xa04ed70) *x              <- child of cvop
        UNOP (0xa043b40) method                               <- cvop
        UNOP (0xa0d04d0) entersub [1]
        ...

What we want to do is trap both these method-style `cvop`s, `method_named` and `method`, and see if we can perform the method lookup at compile time. Once we know what subroutine will actually be called, we can change the op tree so that it calls the subroutine directly, so that at run time when the method is actually called, Perl won't have to search the inheritance tree any more.

     --- ./op.c.orig Fri Jun  2 15:49:32 2000
     +++ ./op.c  Thu Jun 15 22:45:33 2000
     @@ -6243,6 +6309,12 @@
              } 
          }
          else if (   cvop->op_type == OP_METHOD 
                   || cvop->op_type == OP_METHOD_NAMED) {
     +        if (o2->op_type == OP_CONST || o2->op_type == OP_PADSV) {
     +            OP *nop;
     +            if ((nop = method_to_entersub(aTHX_ o2, cvop))) {
     +                return nop;
     +            }
     +        }
              if (o2->op_type == OP_CONST) {
                  o2->op_private &= ~OPpCONST_STRICT;
              }

If you're not used to reading patches, the first three lines tell you where we are: the seven lines from 6243 of *op.c*, which become thirteen lines from 6309 when the patch is applied. The lines starting with a plus are to be added.

Line 6243 is in the middle of the function `Perl_ck_subr`, which is the check routine called when an `entersub` op is filed. Check routines are fed an op and produce a \`cleaned up' version, performing any optimization or elimination of redundancies. Perl replaces each op in the op tree built during the compile phase with these optimized versions.

As we learnt above, we're going to be in one of three situations at this point: ordinary subroutine, which will have a GV op attached to our `entersub` op; named method, which has `method_named` attached; or unnamed method, which has `method` attached. We care about cases when `cvop` is a `method` or `method_named` op:

     else if (   cvop->op_type == OP_METHOD 
              || cvop->op_type == OP_METHOD_NAMED) {

We're fixing class methods, which means we try the conversion when `o2` is a constant. We also want to fix up `my Dog $sam; $sam->bark;`, in which case `o2`, the object, is a lexical variable: (In internal-speak, a pad sv.)

     if (o2->op_type == OP_CONST || o2->op_type == OP_PADSV) {

In these cases, we try to convert the method to a subroutine, and return the new method if we manage it:

         OP *nop;
         if ((nop = method_to_entersub(aTHX_ o2, cvop))) {
             return nop;
         }

The final touch is a portion of the original source: in `Foo->bar`, `Foo` is obviously a class name, and shouldn't fire off a warning if `strict` is checking against barewords. Hence, we remove the strict test from constants which are class names.

     if (o2->op_type == OP_CONST) {
         o2->op_private &= ~OPpCONST_STRICT;
     }

That's 'when'. Now let's see 'how'.

<span id="how to convert methods">How to convert methods</span>
---------------------------------------------------------------

Inside the check routine, the variable `svop` holds the `method` or `method_named` node that specifies how Perl should locate the subroutine that is actually called; `o` is the node that is executed just before this, that fetches the GV for the class name or the value of the variable that contains the object on whose behalf the method will be called. For example:

        Foo->bar():

        SVOP (0xa043b00) const  PV (0xa0411f0) "Foo"          <- o
        SVOP (0xa043b40) method_named  PVIV (0xa04ecf8) "bar" <- svop
        UNOP (0xa0d0500) entersub [1]
        ...

        $foo->bar():

        SVOP (0xa043b00) gvsv  GV (0xa04ecf8) *foo            <- o
        SVOP (0xa0d5720) method_named  PVIV (0xa0411f0) "bar" <- svop
        UNOP (0xa0d04d0) entersub [1]

There is also a `method` variable that holds the SV that is contained in `o`. Our function opens by getting the method name out of there:

     if (svop->op_type == OP_METHOD_NAMED) {
         methname = SvPV(method, methlen);
     }
     else {
         return Nullop;
     }

If it isn't a named method, (that is, if we've got something like `$foo->$bar()`) we can't do anything with it. We return the false value `Nullop`, which is a null pointer cast into an op, signalling to the calling routine that we couldn't modify the program.

     if (cvop->op_type == OP_METHOD_NAMED &&
         o2->op_type == OP_CONST || o2->op_type == OP_PADSV) {

Now, we're fixing up two things: class method calls where `o` is constant, and `my Dog $sam` situations where `o` is a pad SV.

Inside this function, we have three tasks:

**<span id="item_Find_the_stash">Find the stash</span>**
  
A stash is a package symbol table, such as `%Foo::` in Perl space. We need to find the class to which our method belongs, and bring out the symbol table from it.

**<span id="item_Extract_the_GV_entry">Extract the GV entry</span>**
  
We're trying to create an `entersub` op which calls, for example `&Foo::bar`. We've got `%Foo::` from the above: the next task is to find `*Foo::bar`. At this point, we want to take care of inheritance.

**<span id="item_Rewrite_entersub">Rewrite entersub</span>**
  
Finally, we fiddle with the op tree to convert the method form of `entersub` to a subroutine call which merely calls the GV we've just found.

Along the way, we also need to take care of the fact that Perl caches method lookups.

<span id="finding the stash">Finding the stash</span>
-----------------------------------------------------

We're trying to find the GV `*Class::Method` so we can feed it to `entersub`. The first thing we need to do, then, is to find the package symbol table, or \`stash', for the class. There are two possible situations we're in now, and the situation determines how we find the stash: either we've got a constant class, or the object is a lexical.

If we've got a constant class, finding the stash is simple: the PV of the SV hidden in the SvOP `o` tells us the name of the package, and `gv_stashpvn` returns the stash given a PV.

     if (o->op_type == OP_CONST) {
         STRLEN len;
         char *package = SvPV(((SVOP*)o)->op_sv, len);
         stash = gv_stashpvn(package, len, FALSE);
     }

Don't be frightened of the scary casting in line 3: we're just getting the string value from the `const` op.

If we've got a lexical (pad sv) object, `my Dog $sam`, life is slightly more interesting.

     else if (o->op_type == OP_PADSV) {

We fetch the actually SV itself from the current pad - the pad is where Perl keeps the lexical variables belonging to the current block, and it's just an ordinary array:

         SV *sv = *av_fetch(PL_comppad_name, o->op_targ, FALSE);

We hope this SV exists, and is an object. If it is an object, `SvSTASH` will give us the stash, since Perl stored a pointer to the stash when we used `bless` to create the object.

         if (sv && SvOBJECT(sv)) {
             stash = SvSTASH(sv);
         }

Otherwise, we can't do much.

         else {
             return Nullop;
         }
     }

Those are the only two cases - lexicals and constants - that can possibly happen, but computer programming sometimes makes the impossible possible. Doug stands firm against the demons of illogic:

     else {
         return Nullop;
     }

<span id="extract the gv entry">Extract the GV entry</span>
-----------------------------------------------------------

If we've got a stash, we can now try and find the GV. Thankfully, there's a function in *gv.c* which does this, and even takes care of inheritance for us as well.

     if (!(stash && (gv = gv_fetchmeth(stash, methname, methlen, 0)) 
                 &&  isGV(gv))) {
         return Nullop;
     }

If `gv_fetchmeth` fails, or if what it returns is not a gv for some reason, then we couldn't find the package that actually contains the method, so we give up and return `Nullop`. Otherwise, `gv` points to the GV that contains the subroutine we want `entersub` to call. Or it will do the first time the method is looked up. If, however, our method is inherited and provided by another stash, `gv_fetchmeth` provides an alias to the real GV in the object's stash.

In order to get at the code for the real subroutine, we have to get the original GV from this alias; we use the `GvCV` macro to do this. If the GV we get from `GvCV` is in a different class to our method, then we have an alias. We need `entersub` to point to the original GV, and not this alias:

     if (GvSTASH(CvGV(GvCV(gv))) != stash) {
         gv = CvGV(GvCV(gv)); /* point to the real gv */
     }

In his comments, which I've snipped, Doug notes that this cached lookup will only be valid if inheritance doesn't change at run time. There's currently no way to freeze `@ISA` at run time yet, (hey, there's a job for someone!) so Doug suggests as an alternative a simple `return Nullop` to abort if we have a cached lookup.

<span id="rewrite entersub">Rewrite entersub</span>
---------------------------------------------------

Finally, we have enough information to rewrite the `entersub` op: We have a GV, which contains a CV, which we can now call directly. Let's arrange things to do that.

First, remove the `strict` test from the method name as before.

     o->op_private &= ~(OPpCONST_BARE|OPpCONST_STRICT);

Now find the `op_method_named` op, and change it into the GV to create a subroutine call.

     for (mop = o; mop->op_sibling->op_sibling; mop = mop->op_sibling) ;
     op_free(mop->op_sibling); /* loose OP_METHOD{,_NAMED} */
     mop->op_sibling = scalar(newUNOP(OP_RV2CV, 0,
                                 newGVOP(OP_GV, 0, gv)));

Triumphantly, we return the converted op:

     nop = convert(OP_ENTERSUB, OPf_STACKED, o);
     return nop;

<span id="conclusion">Conclusion</span>
---------------------------------------

We got a lot of mileage out of that patch; we've seen how Perl finds and calls methods and subroutines, and shown how Doug's patch can turn methods into subroutines. This should almost totally remove the overhead in using object-oriented Perl, but for the following two points.

<span id="exercises">Exercises</span>
-------------------------------------

1.  Doug's patch needs a way of validating the inheritance tree at compile time; the obvious way to do this is to freeze `@ISA`. Write a pragma which does this.

    For bonus points **and** god-of-the-week status, find a way of validating the method cache at compile time while keeping `@ISA` variable.

2.  This only works for named methods; find a way to make it work for methods that are fetched from variables or via other means. That is, make `Class->$thing()` convertible to a sub.


