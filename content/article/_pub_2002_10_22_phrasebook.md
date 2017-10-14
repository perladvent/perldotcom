{
   "authors" : [
      "rani-pinchuk"
   ],
   "slug" : "/pub/2002/10/22/phrasebook.html",
   "title" : "The Phrasebook Design Pattern",
   "description" : " Have you ever written a Perl application that connects to a database? If so, then you probably faced a problem of having some code like: $statement = q(select isbn from book where title = 'Design Patterns'); $sth = $dbh-&gt;prepare($statement)...",
   "thumbnail" : "/images/_pub_2002_10_22_phrasebook/111-design_patterns.gif",
   "draft" : null,
   "tags" : [
      "phrasebook-languages"
   ],
   "categories" : "development",
   "image" : null,
   "date" : "2002-10-22T00:00:00-08:00"
}





Have you ever written a Perl application that connects to a database? If
so, then you probably faced a problem of having some code like:

     $statement = q(select isbn from book where title = 'Design Patterns');
     
     $sth = $dbh->prepare($statement) ; 
     $rc=$sth->execute();

Why is this "a problem"? It looks like nice code, doesn't it? Actually,
if you look at the code above, you will see two languages: Perl and SQL.
This makes the code not that readable. Besides, SQL statements that are
only slightly different may appear in several places, and this will make
it more difficult to maintain. In addition, suppose you have an SQL
expert who should optimize your SQL calls. How do you let him work on
the SQL; should he look through your Perl code for it? And what if that
guy is so ignorant that he doesn't even know Perl?


    We can solve these problems by writing:

     $statement = $sql->get("FIND_ISBN", { title => "Design Patterns" });
     $sth = $dbh->prepare($statement);
     $rc=$sth->execute();

We keep the actual SQL statements and their corresponding lookup keys in
a separate place that we call a phrasebook. We can use XML to wrap the
SQL and the lookup keys:

     ... 
     <phrase name="FIND_ISBN">
       select isbn from book where title = '$title' 
     </phrase> 
     ...

As we can see above, the SQL statement can hold placeholders, so we can
use one generic SQL statement that can be used in different places.

Now, our code is more readable and maintainable. As we will see later,
there are additional advantages for writing using the phrasebook design
pattern - it helps when we port the code, or when we debug.

Nevertheless, is it a design pattern at all? We saw only one problem and
one solution, right? So here are two more examples: When you need to
generate an error code from your application, you might have in your
code two languages: Perl and English. Moreover, suppose you want to have
later the error code in other languages? The phrasebook design pattern
suggests that you should separate the languages, and put the error
messages in a phrasebook. It also guides you as to how to have the error
messages in different languages.

Suppose you write a code generator that generates PostScript. In order
to have readable code, it is better to separate the PostScript code from
the rest of your code, and put it in a phrasebook.

If you are particularly interested, then you can find the original
Phrasebook Design Pattern paper in
<http://jerry.cs.uiuc.edu/~plop/plop2k/proceedings/Pinchuk/Pinchuk.pdf>.

Because our examples above were about writing applications that uses
database, I would like to add a paragraph or two about persistency. Some
readers might argue that instead of having the SQL code within our Perl
code, or even within our phrasebook, we should create objects that take
the responsibility for connecting to the database, and load or save
themselves. This way, if we use those objects, we need no SQL in the
rest of our code. There are two points to make in this context:

I would suggest the use of the phrasebook within the classes that
implement those persistence objects. This way, the code of those classes
will gain from the advantages that the phrasebook pattern offers.

Usually a persistence object represents one or more tables in the
database. The idea is that we should not access those tables without
using the object. Yet, in my experience, because of performance issues,
you may need complex SQL statements that access tables belonging to more
then one object. So the programmer might find himself writing an SQL
statement in his main application anyway, instead of using the
persistence objects.

### [Class::Phrasebook]{#class::phrasebook}

You probably guessed already that the phrasebook class implements the
phrasebook design pattern. Like the rest of the classes that are
described in this paper, it is available for downloading from CPAN. Let
us see how we use that class to generate some error codes in different
languages (English and Dutch for example).

We begin with writing the phrasebook. The phrasebook is a simple XML
file. It will look like:

     <?xml version="1.0" encoding="ISO-8859-1"?>
     <!DOCTYPE phrasebook [
     <!ELEMENT phrasebook (dictionary)*>
     <!ELEMENT dictionary (phrase)*>
     <!ATTLIST dictionary name CDATA #REQUIRED>
     <!ELEMENT phrase (#PCDATA)>
     <!ATTLIST phrase name CDATA #REQUIRED>
     ]>

     <phrasebook>
      <dictionary name="EN">
       <phrase name="MISUSE_OF_MANUAL_TEMPLATE_NAME">
         The name $name can be used only as manual template
       </phrase>
       ...
      </dictionary>
      <dictionary name="NL">
       <phrase name="MISUSE_OF_MANUAL_TEMPLATE_NAME">
        De naam $name mag enkle gebriuk worden als webboek template
       </phrase>
       ...
      </dictionary> 
     </phrasebook>

As we can see, the phrasebook file starts with the Document Type
Definition (DTD). Don't panic - just copy it as is. It is used by the
XML parser to validate the XML code. Then we open the definition of the
phrasebook, and inside it one or more definitions of dictionaries. Each
dictionary will hold the phrases. The first dictionary is taken as the
default dictionary: if a phrase is missing in other dictionary, it will
be taken from the first one. The phrases can hold placeholders. The
placeholders look exactly like Perl scalar variables.

Now let's see how we get a phrase from the phrasebook:

     ...
     $msg = new Class::Phrasebook($log, "errors.xml");
     $msg->load($language);
     ...
     # check that the name of the document is not a manual_template name
     if (is_manual_template_name($template_name)) {
        my $message = $msg->get("MISUSE_OF_MANUAL_TEMPLATE_NAME",
                                { name => "$template_name"} ); 
        $log->write($message, 5);
        return 0;
     }

First, we create the Class::Phrasebook object. We supply to the
constructor a Log::LogLite object and a name of the XML file that
contains the phrasebook we want to use. We will discuss the Log::LogLite
class later. For now, you should only know that this class provides with
the ability to have log messages - so if, for example, our new
Class::Phrasebook object fails to find the XML file, a log message will
be written to a log file.

How the XML file will be found if we do not supply any path? The class
automatically searches the following directories:

-   The current directory.
-   The directory ./lib in the current directory.
-   The directory ../lib in the current directory.
-   @INC.

This allows us to create an XML file that comes with a module in an easy
way: We should place the XML file in a lib directory below the directory
of our module. Therefore, if the module we write is *Blah*, then its XML
file will be placed in the directory *Blah/lib*. Of course, it is a good
idea to give the XML file a name that is similar to the module name -
*blah.xml*, so it will be unique on the system (because "make install"
will install the XML file next to the module file *Blah.pm*).

The next thing we do is to load a dictionary from the phrasebook file.
The \$language variable above will hold the dictionary name - in our
example, it will be "EN" or "NL".

Finally, when we need to get the text for an error message, we call the
get method of the Class::Phrasebook object with the key of the message
we want to get, and a reference to a hash that holds the name-value
pairs of the placeholders within the phrase.

Some careful readers might point out that if we use the
Class::Phrasebook inside another class, then we might end up with a
memory problem. Suppose many of the other class objects are constructed,
and all of them load the same dictionary using the Class::Phrasebook
objects. We will end up with many identical dictionaries loaded into the
memory.

For example, assume we have object User that uses an object of
Class::Phrasebook to generate error messages. When we construct the User
object, we also construct a Class::Phrasebook object and load the
dictionary for the error messages in the right language. Let's assume we
have 100 User objects that are supposed to provide the error messages in
English. It means that those 100 User objects will hold 100
Class::Phrasebook objects and each of them will hold its own copy of the
English error dictionary. Terrible loss of memory!

Well, not exactly. The Class::Phrasebook keeps the loaded dictionaries
in a cache that is actually class data. That means that all the objects
of Class::Phrasebook have one cache like that. The cache is managed by
the class, and knows to load only one dictionary of each sort. It will
know also to delete that dictionary from the memory when there are no
more objects that refer to it. Therefore, the careful readers should not
worry about this issue any more.

However, continuing the example above, sometimes we might load the 100
User objects one after the other. Each time, that object will be
destroyed. Other careful reader might point out that in this case the
dictionary will go out of scope every time, and actually we will load
the same dictionary 100 times!

Because of that, the class provides for that careful reader a class
method that configures the class to keep the loaded dictionaries in the
cache forever. This is not the default behavior, but when coding
daemons, for example, it will be desirable.

### [Class::Phrasebook::SQL]{#class::phrasebook::sql}

The class Class::Phrasebook::SQL is a daughter class of
Class::Phrasebook. It provides us with some extra features that helps us
to deal with SQL phrases more easily. One example is the way it deals
with the update SQL statement. Imagine that you have in your application
a form that the user is supposed to fill in. If the user fills in only
two fields, then you are supposed to update only those two fields in his
record. Usually this problem is solved by having a simple code that
builds our update SQL statement from its possible parts. However, this
will not be that readable. The Class::Phrasebook::SQL will let you do it
in the following way:

We will place as a phrase the update SQL statement with all the possible
fields:

     <phrase name="UPDATE_T_ACCOUNT">
       update t_account set
             login = '$login',
             description = '$description',
             dates_id = $dates_id,
             groups = $groups,
             owners = $owners
          where id = $id
     </phrase>

The Class::Phrasebook::SQL will drop the "set" lines, where there is a
placeholder that its value is undefined. As I wanted to avoid from real
parsing of the update statements, the update statements must look as the
example above - each "set" expression in different line. Now, if we call
the get method as the following:

     $statement = $sql->get("UPDATE_T_ACCOUNT",
                            { description => "administrator of manuals",
                              id => 77 });

We will get the statement:

     update t_account set
           description = 'administrator of manuals'
        where id = 77

"Set" lines that contained undefined placeholders in the original update
statement were removed.

### [Debugging With the Phrasebook Classes]{#debugging_with_the_phrasebook_classes}

Both the classes `Class::Phrasebook` and `Class::Phrasebook::SQL`
provide us with debugging services. One example is the environment
variable `PHRASEBOOK_SQL_DEBUG_PRINTS`. If this variable holds the value
"TEXT" then it will print debug message each time the method
C&lt;get&gt; is called:
     path = Oefeningen/logoklad.source
     [DBOrderedTreeUI.pm:322-->DBOrderedTreeUI::show_list > DBOrderedTreeUI.
     pm:4134-->Manual::fill_node_info_container_from_list > Manual.pm:2885--
     >Document::load > /htdocs/html/projects/webiso/code/classes/Document.pm
     :403-->Revisions::load > /htdocs/html/projects/webiso/code/classes/Revi
     sions.pm:114-->Revision::load: ][GET_LAST_REVISION]

            select path, major, minor, date, user_id,
                   state_id, md5, data_md5, is_patch, is_changed 
                from revision 
                where path = 'Oefeningen/logoklad.source'
                  and is_patch = 0

If the value of the environment is "COLOR", then the output would be
with colors. The colors come from the Term::ANSIColor module. If the
value is "HTML" then the output would be HTML code that generates a
similar colorful representation.

     path = Oefeningen/logoklad.source

     [DBOrderedTreeUI.pm:322-->DBOrderedTreeUI::show_list > DBOrderedTreeUI 
     .pm:4134-->Manual::fill_node_info_container_from_list > Manual.pm:2885
     -->Document::load > /htdocs/html/projects/webiso/code/classes/Document
     .pm:403-->Revisions::load > /htdocs/html/projects/webiso/code/classes/
     Revisions.pm:114-->Revision::load: ][GET_LAST_REVISION]
            select path, major, minor, date, user_id,
                   state_id, md5, data_md5, is_patch, is_changed 
                from revision 
                where path = 'Oefeningen/logoklad.source'
                  and is_patch = 0
      

Imagine that you need to see what are the SQL statements that are
generated from a certain piece of code. Setting the
PHRASEBOOK\_SQL\_DEBUG\_PRINTS environment variable within that code
will do the trick in no time. This feature can help not only in
debugging, but also in the optimization of SQL code.

A similar environment variable is the
PHRASEBOOK\_SQL\_SAVE\_STATEMENTS\_FILE\_PATH. When this environment is
set to a certain file path, all the SQL statements that are generated by
calling to the get method will be written to that file. That way, you
can see later which SQL statements your application issued, and even to
re-run them from that file.

Actually, this is the way I found a bug in one of the former versions of
the database PostgreSQL. I noticed that under certain conditions, some
select statements fail while they are not supposed to fail. As usual,
the "certain conditions" were totally unknown. What I did was to run my
application while having the environment
PHRASEBOOK\_SQL\_SAVE\_STATEMENTS\_FILE\_PATH set. When the bug
happened, I took the file with all the SQL statements that I got and ran
the SQL statements directly from it. Then, I started to clean it until I
had only few SQL statements left, and still the bug happened when they
were run. I sent those statements with my report of the bug and got
within two hours a solution for the problem (Well - you know, when you
use open source software, you get support - and the PostgreSQL team is
very responsive).

### [Log::LogLite and Log::NullLogLite]{#log::loglite_and_log::nullloglite}

The Log::LogLite and the Log::NullLogLite classes provide us with an
excellent opportunity to introduce a beautiful design pattern called the
Null Object Design Pattern.

The Log::LogLite is a simple class that let us create simple log files
in our application. The synopsis from the manual page of the class gives
a good overview of how to use the class:

     use Log::LogLite;
     my $LOG_DIRECTORY = "/where/ever/our/log/file/should/be";
     my $ERROR_LOG_LEVEL = 6;
     # create new Log::LogLite object
     my $log = new Log::LogLite($LOG_DIRECTORY."/error.log",
                                $ERROR_LOG_LEVEL); 
     ...
     # we had an error
     $log->write("Could not open the file ".$file_name.": $!", 4);

As we saw Class::Phrasebook demands the use of a Log::LogLite object.
This allows Class::Phrasebook to generate log messages when errors occur
- for example, when the parsing of the XML file fails. However, it might
be that we do not want to have a log file for every use of the
Class::Phrasebook. How can we avoid from having a log file without
changing the code of Class::Phrasebook?

The solution for that problem comes from the beautiful Null Object
Design Pattern by Bobby Woolf. The pattern guides us to inherit from our
class a null class - a class that does nothing, but implement the same
interface of the original class. In our example, Log::NullLogLite
overrides some of the methods of Log::LogLite to do nothing. So when we
call the method write, nothing is written. Because the class inherits
from Log::LogLite, the classes that use Log::LogLite continue to run
correctly also when we send to them Log::NullLogLite objects.

### [Conclusion]{#conclusion}

The phrasebook design pattern helps us to get more readable and
maintainable code by separating expressions in one language from the
main code that is written in other language. The Class::Phrasebook
module helps us to implement this pattern in Perl.

The classes that are presented above have been used by my colleagues and
me for few years. During that time, we could see in practice all the
advantages that the pattern promises. For example, an application of
65,000 lines had to be ported to another database. When the SQL code is
concentrated in XML files, we could achieve that kind of port very
rapidly.

In my opinion, Perl gives us a nice platform to program in
object-oriented techniques. However, I am not sure that this opinion is
well-spread. Many programmers stop learning when things they write start
running, and with Perl things start to run very soon. Nevertheless, with
good design, big and sophisticated applications can be written with
Perl, like with other OO languages.

### [Thanks]{#thanks}

Many thanks to Ockham Technology N.V. for letting me release the above
modules and others as open source on CPAN.


