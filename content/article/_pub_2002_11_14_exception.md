{
   "description" : " The main goal of this article is to discuss in detail about exception handling in Perl and how to implement it using Error.pm. On our way, we'll be touching upon the advantages of using exception-handling over traditional error-handling mechanisms,...",
   "image" : null,
   "authors" : [
      "arun-udaya-shankar"
   ],
   "thumbnail" : "/images/_pub_2002_11_14_exception/111-error.gif",
   "draft" : null,
   "tags" : [],
   "title" : "Object Oriented Exception Handling in Perl",
   "slug" : "/pub/2002/11/14/exception",
   "date" : "2002-11-14T00:00:00-08:00",
   "categories" : "development"
}





The main goal of this article is to discuss in detail about exception
handling in Perl and how to implement it using Error.pm. On our way,
we'll be touching upon the advantages of using exception-handling over
traditional error-handling mechanisms, exception handling with eval {},
problems with eval {} and the functionalities available in Fatal.pm. But
by and large, our focus we'll be on using Error.pm for exception
handling.

### What Is an Exception ?

An exception can be defined as an event that occurs during the execution
of a program that deviates it from the normal execution path. Different
types of errors can cause exceptions. They can range from serious errors
such as running out of virtual memory to simple programming errors such
as trying to read from an empty stack or opening an invalid file for
reading.

An exception usually carries with it three important pieces of
information:

1.  The type of exception - determined by the class of the exception
    object
2.  Where the exception occurred - the stack trace
3.  Context information - error message and other state information

An exception handler is a piece of code used to gracefully deal with the
exception. In the rest of article, the terms exception handler and catch
block will be used interchangeably.

By choosing exceptions to manage errors, applications benefit a lot over
traditional error-handling mechanisms. All the advantages of using
exception handling are discussed in detail in the next section.

### Advantages of Using Exception Handling

Object-oriented exception handling allows you to separate error-handling
code from the normal code. As a result, the code is less complex, more
readable and, at times, more efficient. The code is more efficient
because the normal execution path doesn't have to check for errors. As a
result, valuable CPU cycles are saved.

Another important advantage of OO exception handling is the ability to
propagate errors up the call stack. This happens automatically without
you, the programmer, explicitly checking for return values and returning
them to the caller. Moreover, passing return values up the call stack is
error prone, and with every hop there is a tendency to lose vital bits
of information.

Most of the time, the point at which an error occurs is rarely the best
place to handle it. So, the error needs to be propagated up the call
stack. But by the time the error reaches the place where it can be
handled suitably, a lot of the error context is lost. This is a common
problem with traditional error-handling mechanisms (i.e. checking for
return values and propagating them to the caller). Exceptions come to
the rescue by allowing contextual information to be captured at the
point where the error occurs and propagate it to a point where it can be
effectively used/handled.

For instance, if you have a function *processFile()* that is the fourth
method in a series of method calls made by your application. And also
*func1()* is the only method interested in the errors that occur within
*processFile()*. With a traditional error-handling mechanism, you would
do the following to propagate the error code up the call stack until the
error finally reaches *func1()*.

      sub func3
      {
        my $retval = processFile($FILE);
        if (!$retval) { return $retval; }
        else {
          ....
        }
      }

      sub func2
      {
        my $retval = func3();
        if (!$retval) { return $retval; }
        else {
          ....
        }
      }

      sub func1 
      {
        my $retval = func2();
        if (!$retval) { return $retval; }
        else {
          ....
        }
      }

      sub processFile
      {
        my $file = shift;
        if (!open(FH, $file)) { return -1; }
        else {
          # Process the file
          return 1;
        }
      }

With OO exception handling, all you need to do is wrap the function call
to *func2()* within the try block and handle the exceptions thrown from
that block with an appropriate exception handler (catch block). The
equivalent code with exception handling is shown below.

       sub func1
       {
         try {
           func2();
         }
         catch IOException with {
           # Exception handling code here
         };  
       }

       sub func2 { func3(); ... }
       sub func3 { processFile($FILE); ... }

       sub processFile
       {
         my $file = shift;
         if (!open(FH, $file)) { 
           throw IOException("Error opening file <$file> - $!");
         }
         else {
           # Process the file
           return 1;
         }     
       }

Since *func1()* is the only function to possess a catch block, the
exception that was thrown in the *processFile()* function is propagated
all the way up to *func1()*, where it would be appropriately dealt with,
by the catch block. The difference in the bloat factor and code
obfuscation level between these two error handling techniques is
obvious.

Finally, exceptions can be used to group related errors. By doing this,
you will be able to handle related exceptions using a single exception
handler. The inheritance hierarchy of the exception classes can be used
to logically group exceptions. Thus, an exception handler can catch
exceptions of the class specified by its parameter, or can catch
exceptions of any of its subclass.

### Let's Do It in Perl

### Perl's Built-In Exception Handling Mechanism

Perl has a built-in exception handling mechanism, a.k.a the eval {}
block. It is implemented by wrapping the code that needs to be executed
around an eval block and the \$@ variable is checked to see if an
exception occurred. The typical syntax is:

      eval {
        ...
      };
      if ($@) {
        errorHandler($@);
      }

Within the eval block, if there is a syntax error or runtime error, or a
die statement is executed, then an undefined value is returned by eval,
and \$@ is set to the error message. If there was no error, then \$@ is
guaranteed to be a null string.

What's wrong with this? Since the error message store in \$@ is a simple
scalar, checking the type of error that has occurred is error prone.
Also, \$@ doesn't tell us where the exception occurred. To overcome
these issues, exception objects were incorporated in Perl 5.005.

From Perl 5.005 onward, you can do this:

      eval {
        open(FILE, $file) || 
          die MyFileException->new("Unable to open file - $file");
      };

      if ($@) {
        # now $@ contains the exception object of type MyFileException
        print $@->getErrorMessage();  
        # where getErrorMessage() is a method in MyFileException class
      }

The exception class (MyFileException) can be built with as much
functionality as desired. For example, you can get the calling context
by using *caller()* in constructer of the exception class (typically
*MyFileException::new()*).

It is also possible to test specific exception types as shown below:

      eval {
        ....
      };

      if ($@) {
        if ($@->isa('MyFileException')) {  # Specific exception handler
          ....
        }
        else { # Generic exception handler
          ....
        }
      }

If the exception object implements stringification, by overloading the
string operations, then the stringified version of the object would be
available whenever \$@ is used in string context. By constructing the
overloading method appropriately, the value of \$@ in string context can
be tailored as desired.

      package MyException;

      use overload ('""' => 'stringify');
      ...
      ...
      sub stringify
      {
        my ($self) = @_;
        my $class = ref($self) || $self;

        return "$class Exception: " . $self->errMsg() . " at " . 
                                      $self->lineNo() . " in " . 
                                      $self->file();
        # Assuming that errMsg(), lineNo() & file() are methods 
        # in the exception class
        # to store & return error message, line number and source 
        # file respectively.
      }

When overloading the string operator '"', the overloading method
(*stringify()* in our case) is expected to return a string representing
the stringified form of the object. The stringify() method can return
various context/state information about the exception object, as part of
the string.

### Problems with eval

The following are some of the issues in using the eval {} construct:

-   Similar looking syntactic constructs can mean different things,
    based on the context.
-   eval blocks can be used for both, building dynamic code snippets as
    well as for exception handling
-   No builtin provision for cleanup handler a.k.a finally block
-   Stack trace if required, needs to maintained by writing custom code
-   Aesthetically unappealing (Although this is very subjective)

### Error.pm to the Rescue

The Error.pm module implements OO exception handling. It mimics the
try/catch/throw syntax available in other OO languages like Java and C++
(to name a few). It is also devoid of all the problems that are inherent
when using eval. Since it's a pure perl module, it runs on almost all
platforms where Perl runs.

### Use'ing Error.pm

The module provides two interfaces:

1.  Procedural interface for exception handling (exception handling
    constructs)
2.  Base class for other exception classes

The module exports various functions to perform exception handling. They
will be exported if the :try tag is used in the use statement.

A typical invocation would look like this:

      use Error qw(:try);

      try {
        some code;
        code that might thrown an exception;
        more code;
        return;
      }
      catch Error with {
        my $ex = shift;   # Get hold of the exception object
        handle the exception;
      }
      finally {
        cleanup code;
      };  # <-- Remember the semicolon

Don't forget to include the trailing semicolon (;) after the closing
brace. For those of you who want to know why: All these functions accept
a code reference as their first parameter. For example, in the try block
the code that follows try is passed in as a code reference (anonymous
function) to the function *try(*).

### try Block

An exception handler is constructed by enclosing the statements that are
likely to throw an exception within a try block. If an exception occurs
within the try block, then it is handled by the appropriate exception
handler (catch block), associated with the try block. If no exceptions
are thrown, then try will return the result of block.

The syntax is: try BLOCK EXCEPTION\_HANDLERS

A try block should have at least one (or more) catch block(s) or one
finally block.

### Catch Block

The try block associates the scope of its associated exception handlers.
You associate exception handlers with a try block by providing one or
more catch blocks directly after the try block:

      try {
        ....
      }
      catch IOException with {
        ....
      }
      catch MathException with {
        ....
      };

The syntax is: catch CLASS with BLOCK

This enables all errors that satisfy the condition \$ex-&gt;isa(CLASS)
to be handled by evaluating BLOCK.

The BLOCK receives two parameters. The first is the exception being
thrown and the second is a scalar reference. If this scalar reference is
set on return from the catch block, then the try block continues as if
there was no exception.

If the scalar referenced by the second parameter is not set, and no
exceptions are thrown (within the catch block), then the current try
block will return with the result from the catch block.

In order to propagate an exception, the catch block can choose to
rethrow the exception by calling *\$ex-&gt;throw()*

### Order of Catch Blocks Matter

The order of exception handlers is important. It's all the more critical
if you have handlers at different levels in the inheritance hierarchy.
Exception handlers that are built to handle exception types that are
furthermost from the root of the hierarchy (Error) should be placed
first in the list of catch blocks.

An exception handler designed to handle a specific type of object may be
pre-empted by another handler whose exception type is a superclass of
that type. This happens if the exception handler for that exception type
appears earlier in the list of exception handlers.

For example:

      try {
        my $result = $self->divide($value, 0);  
        # divide() throws DivideByZeroException
        return $result;  
      }
      catch MathException with {
        my $ex = shift;
        print "Error: Caught MathException occurred\n";
        return;
      }
      catch DivideByZeroException with {
        my $ex = shift;
        print "Error: Caught DivideByZeroException\n";
        return 0;
      };

Assuming the Inheritance hierarchy:

      MathException is-a Error                 
           [ @MathException::ISA = qw(Error) ]
      DivideByZeroException is-a MathException 
           [ @DivideByZeroException::ISA = qw(MathException) ]

In the above code listing, the DivideByZeroException is caught by the
first catch block instead of the second. That is because
DivideByZeroException is a subclass of MathException. In other words,
*\$ex-&gt;isa('MathException')* returns true. Hence, the exception is
handled by the code within the first catch block. Reversing the order of
the catch blocks would ensure that the exception is caught by the
correct exception handler.

### Finally Block

The final step in setting up an exception handler is providing a
mechanism for cleaning up before control is passed to different part of
the program. This can be achieved by enclosing the cleanup logic within
the finally block. Code in the finally block is executed irrespective of
what happens within the try block. Typical use of the finally block is
to close files or in general to release any system resource.

If no exceptions are thrown, then none of the code in the catch block(s)
gets executed. But the code in the finally block is always executed.

If an exception is thrown, then code in the appropriate catch block is
executed. Once the execution of that code is complete, the finally block
is executed.

      try {
        my $file = join('.', '/tmp/tempfile', $$);

        my $fh = new FileHandle($file, 'w');
        throw IOException("Unable to open file - $!") if (!$fh);

        # some code that might throw an exception
        return;
      }
      catch Error with {
        my $ex = shift;
        # Exception handling code
      }
      finally {
        close($fh) if ($fh);    # Close the temporary file
        unlink($file);          # Delete the temporary file
      };

In the above code listing, a temporary file is created in the try block
and the block also has some code that can potentially throw an
exception. Irrespective of whether the try block succeeds, the temporary
file has to be closed and deleted from the file system. This is
accomplished by closing and deleting the file in the finally block.

Remember, only one finally block is allowed per try block.

### Throw Statement

throw() creates a new "Error" object and throws an exception. This
exception would be caught by a surrounding try block, if there is one.
Otherwise the program will exit.

throw() can also be called on an existing exception to rethrow it. The
code listing below illustrates how to rethrow an exception:

      try {
        $self->openFile();
        $self->processFile();
        $self->closeFile();
      }
      catch IOException with {
        my $ex = shift;
        if (!$self->raiseException()) {
          warn("IOException occurred - " . $ex->getMessage());
          return;
        }
        else { 
          $ex->throw(); # Re-throwing exception
        }
      };

### Building Your Own Exception Class

Setting the value of the \$Error::Debug package variable to true,
enables the capturing of stack trace for later retrieval using the
stacktrace() method. (In case you are not familiar, stacktrace is a list
of all the methods executed in sequence that lead to the exception).

The code snippet below creates the exception classes MathException,
DivideByZero and OverFlowException. Where the latter two are subclasses
of MathException and MathException by itself is derived from Error.pm

      package MathException;

      use base qw(Error);
      use overload ('""' => 'stringify');

      sub new
      {
        my $self = shift;
        my $text = "" . shift;
        my @args = ();

        local $Error::Depth = $Error::Depth + 1;
        local $Error::Debug = 1;  # Enables storing of stacktrace

        $self->SUPER::new(-text => $text, @args);
      }
      1;
          
      package DivideByZeroException;
      use base qw(MathException);
      1;

      package OverFlowException;
      use base qw(MathException);
      1;

### And More ...

The error modules has other special exception handling blocks, such as
*except* and *otherwise*. They are deliberately not covered here because
they are specific to Error.pm, and you won't find them in other OO
languages. For those who are interested, please refer the POD
documentation that is embedded within Error.pm.

### Fatal.pm

If you have some functions that return false on error and a true value
on success, then you can use Fatal.pm to convert them into functions
that throw exceptions on failure. It is possible to do this to both user
defined functions as well as built-in functions (with some exceptions).

      use Fatal qw(open close);

      eval { open(FH, "invalidfile") }; 
      if ($@) {
        warn("Error opening file: $@\n");
      }
      
      ....
      ....
      
      eval { close(FH); }; 
      warn($@) if ($@);

By default, Fatal.pm catches every use of the fatalized functions i.e.

      use Fatal qw(chdir);
      if (chdir("/tmp/tmp/")) {
        ....
      }
      else { 
        # Execution flow never reaches here
      }

If you are fortunate enough to have Perl 5.6 or later, then you can
circumvent this by adding :void in the import list. All functions named
after this in that import list will raise an exception only when they
are called in void context i.e. when their return values are being
ignored.

By changing the use statement, as shown below we can be sure that the
code in the else block is executed when chdir() fails

      use Fatal qw(:void chdir);

The code listing below illustrates the use of Fatal.pm in conjunction
with Error.pm.

      use Error qw(:try);
      use Fatal qw(:void open);

      try {
        open(FH, $file);
        ....
        openDBConnection($dsn);
        return;
      }
      catch DBConnectionException with {
        my $ex = shift;
        # Database connection failed
      }
      catch Error with {
        my $ex = shift;
        # If the open() fails, then we'll be here  
      };

### The Perl6 Connection

Since the exception handling syntax in Perl 6 is expected to be modeled
closely against Error.pm as detailed in the Perl 6 RFC 63 Exception
handling syntax - http://dev.perl.org/rfc/63.pod, also in RFC 80 and RFC
88. It would make sense for developers to make use of OO-ish exception
handling capabilities in their code and later on migrate to the
exception handling syntax in Perl 6, as and when it is available.

### Conclusion

The following are some of the key reasons to choose exception-handling
mechanism over the traditional error-handling mechanisms:

-   Error handling code can be separated from normal code
-   Less complex, more readable and more efficient code
-   Ability to propagating errors up the call stack
-   Ability to persist contextual information for the exception handler
-   Logical grouping of error types

****
So, stop returning error codes and start throwing exceptions.

Have an exceptional time !!


