{
   "authors" : [
      "kelvin-param"
   ],
   "image" : null,
   "title" : "Building a Bridge to the Active Directory",
   "description" : " Introduction Active Directory of Windows 2000's directory service, allowing organizations to keep and share information about networked resources and users. One significant feature of the Active Directory is that it is LDAP-compliant. Unfortunately, it is still very difficult to...",
   "categories" : "data",
   "thumbnail" : "/images/_pub_2001_12_19_xmlrpc/111-active_dir.gif",
   "tags" : [
      "active-directory-xml-rpc"
   ],
   "date" : "2001-12-19T00:00:00-08:00",
   "slug" : "/pub/2001/12/19/xmlrpc",
   "draft" : null
}





### [Introduction]{#introduction}

Active Directory of Windows 2000's directory service, allowing
organizations to keep and share information about networked resources
and users. One significant feature of the Active Directory is that it is
LDAP-compliant. Unfortunately, it is still very difficult to access the
Active Directory without using the Active Directory Services Interface
(ADSI). As a COM component, ADSI is very partial to the Windows
operating system.

What if you want to access information in your organization's Active
Directory from a host that is not running Windows? One option is to
build a piece of middleware (a daemon) to bridge a non-Windows host to
the Active Directory. This article describes how to build such a daemon,
and how to build a simple client would communicate with that daemon.

### [XML-RPC and Active Perl to the Rescue]{#xmlrpc and active perl to the rescue}

XML-RPC is a mechanism that enables platform-independent and
language-independent distributed computing. It serializes function calls
and their associated arguments into an XML stream, and transports the
stream via the ubiquitous HTTP protocol. Although it might be an
over-simplification, XML-RPC provides some of the power of CORBA without
the associated pain.

The aim of this article is to walk you through the construction of a
daemon that accesses data from the Active Directory using ADSI and
passes on this data to other non-Windows clients via XML-RPC. This
daemon must, of necessity, run on a Windows host.

A daemon isn't much good unless there is a client with which to
communicate. As such, I will also walk you through the construction of a
simple client application.

Since Visual Basic is the de facto standard for writing Windows
applications, it would seem natural to build the daemon in Visual Basic.
However, I'm just not comfortable with Visual Basic, even though I had
used it on several projects. Fortunately, ActivePerl from ActiveState
has a very well developed COM interface that can be used to interact
with ADSI.

Before we get into the details of our Active Directory Daemon and Active
Directory Client, here are the links to the source code, so that you can
refer to it as we discuss the code and the logic behind it.

Active Directory Daemon:
[activedirectory\_daemon.pl](/media/_pub_2001_12_19_xmlrpc/activedirectory_daemon.pl)\
Active Directory Client:
[activedirectory\_client.pl](/media/_pub_2001_12_19_xmlrpc/activedirectory_client.pl)

### [The Active Directory Daemon]{#the active directory daemon}

Our daemon will be able to do the following:

a\. Authenticate a user against the Active Directory using the user ID
and password. A successful login will result in the salient data (e.g.
surname, given name and email address) associated with the user ID being
returned.

b\. Return the chain of command (the user's immediate boss, the immediate
boss's immediate boss, etc).

First, we need to load the modules below, and we also invoke the strict
pragma.

      use strict;
      use Win32::OLE;
      use Win32::OLE::Const 'Microsoft ActiveX Data Objects';
      use Frontier::Daemon;

The first two are part of Active Perl, while the third module is
available from CPAN.

The `AuthenticateUser` subroutine authenticates the user against the
active directory.

      sub AuthenticateUser {
            my $strUserID       = shift || "someuserid"; 
            my $strUserPassword = shift || "Somepassword1";
            my $strADsPath      = shift || 
               'LDAP://OU=somedivision,OU=somedepartment,DC=someuniversity,DC=edu';
            my $strDomain       = shift || "\@someuniversity.edu";
            my $strAttributeName = "userPrincipalName";
            my $strAttributeValue = $strUserID;

We've assigned default values to some of the scalars above to provide an
example of how arguments will be used at various points in the process
of querying the Active Directory. There are several ways of interacting
with ADSI. In this bit of code, we bind directly to ADSI. Later on, we
will show how we can use ADO to bind to ADSI. It is important to note
that each method of interacting with ADSI has its own peculiarities.

             my $objNameSpace = Win32::OLE->GetObject ('LDAP:') 
                    or die ("Cannot create LDAP object");.
             my $objObjSec = $objNameSpace->OpenDSObject($strADsPath, $strUserID,
       $strUserPassword, 1);
             my %hashAdRecord;

We use `Win32::OLE->GetObject('LDAP:')` to utilize the LDAP services of
ADSI. ADSI supports several directory services such as Novell NDS, and
Windows NT4 amongst others. Next we try to access the Active Directory
record associated with our user ID and password. The \$strADsPath
variable specifies what is roughly the domain name of the Windows 2000
forest, and how far down the forest one wants to begin searching. The
DC=someuniversity,DC=edu is the LDAP analog of a DNS style domain name
i.e. someuniversity.edu. In this example, we want to access the Active
Directory starting at the organizational unit somedepartment that is a
child of the organization unit somedivision.

We use
`$objNameSpace->OpenDSObject($strADsPath, $strUserID, $strUserPassword, 1)`
to access the Active Directory and retrieve the relevant record. The
last argument in this subroutine is set to 1. It indicates that we are
using an unencryted password.

        if (Win32::OLE->LastError()==0) {
            $refAdRecord =
                GetUserData($strAttributeName,$strAttributeValue,$strADsPath,$strDomain);
        } else {
            %hashAdRecord =('result' => 'failed');
            $refAdRecord = \%hashAdRecord;
        }

We use `Win32::OLE->LastError()` to ascertain if we have a valid user.
`Win32::OLE->LastError()` is ActivePerl's implementation of Visual
Basic's `Err.Number`. Up to now, everything is pretty straightforward.
Deciphering the error codes is a little tricky. Here's how the error
logic works. `Win32::OLE->LastError()` returns a non-zero only if the
password is invalid. However, supplying a non-existent user ID will
result in zero being returned. As such this bit of code is only good for
detecting an invalid password. So, how do we detect a non-existent user
ID? Our `GetUserData` subroutine serves a dual purpose. It not only
detects a non-existent user ID, but also returns data from the Active
Directory object that is associated with a valid user ID.

We can only return references to the XML-RPC client, so we need to
define a scalar variable to which we can assign a reference of the
return value. Furthermore, the scalar variable has to be global to the
XML-RPC daemon program. In our case, the scalar variable is
`$refAdRecord`. If the user id and password are valid, the reference to
the hash returned by the subroutine `GetUserData` is assigned to the
scalar `$refAdRecord`. On the other hand, if the user id and password
are not valid, we insert the `'result' => 'failed'` key-value pair to
the `%hashAdRecord` hash variable, and subsequently assign the reference
of that hash variable to `$refAdRecord`.

        $objObjSec->Close;
        $objNameSpace->Close;
        return $refAdRecord;
        }

And, it's time to destroy the ADSI objects that we created earlier.

Now, we move on to the XML-RPC specific bits of the daemon program.

        my $methods = {
        'activedirectory_daemon1.GetUserData' => \&GetUserData,
        'activedirectory_daemon1.GetCommandChain' => \&GetCommandChain,
        'activedirectory_daemon1.AuthenticateUser' => \&AuthenticateUser

        };

We declare a hash of subroutines that are accessible to the XML-RPC
client. The key of each entry is the name of the method prefixed by an
identifier using the dot convention. In our case, we arbitrarily use the
name of the daemon file as the identifier. The value part of each hash
entry is the de-referenced pointer to the corresponding method. This
hash serves as a sort of look up table for requests to methods made at
the XML-RPC client. The subroutines besides `AuthenticateUser` will be
discussed later in this article.

        Frontier::Daemon->new(LocalPort => 8080, methods => $methods) 
               or die ("Cannot start HTTP daemon: $!");

At this juncture, we insert the code that fires up the XML-RPC daemon.
We do so creating a new `Frontier::Daemon` instance. The constructor
subroutine takes two arguments, each as a key-value pair. The first
argument is the port used by the daemon. Since the host may already be
running a web server, we'll use port 8080. The second argument is the
set of subroutines to be published for use by the XML-RPC client (see
above).

Besides the `AuthenticateUser` subroutine, we've also included a couple
of subroutines that retrieve useful information about a user.
`GetUserData` retrieves data like the user's email address, telephone
number, etc. Although we call `GetUserData` from other subroutines
(`AuthenticateUser` and `GetCommandChain`) within the daemon program,
`GetUserData` may also be called from an XML-RPC client to retrieve data
in the Active Directory about any user whose record is accessible.
Instead of binding directly with ADSI, in this case, we use ADO to bind
with the Active Directory, just so that the retreived data is presented
as a record like if the data was retrieved from a relational database.

        sub GetUserData {
            my $strAttributeName  = shift; #could be userPrincipalName, cn etc
            my $strAttributeValue = shift; #could be user ID, cn value etc
            my $strADsPath        = shift; #could be
            # "LDAP://OU=somedivision,OU=somedepartment,DC=someuniversity,DC=edu"
            
            my $strDomain         = shift; #could be "someuniversity.edu"

            if ($strAttributeName eq "userPrincipalName") { 
                $strAttributeValue = $strAttributeValue . $strDomain; s
            }

            my $strProvider = "Active Directory Provider";

            my $strConnectionString = $strProvider;

            my $strFilter = "(" . $strAttributeName . "=" . $strAttributeValue . ")";

            my $strAttribs =
                 "userPrincipalName,sn,givenName,cn,department,telephoneNumber,mail,title,manager";

            my $strScope = "subtree";

            my $strCommandText = "<" . $strADsPath . "E>;" . $strFilter . "
            ;" . $strAttribs . ";" . $strScope;

            my $objConnection = Win32::OLE->new ("ADODB.Connection") 
                 or die ("Cannot create ADODB object!");

            my $objRecordset = Win32::OLE->new ("ADODB.Recordset")
                 or die ("Cannot create ADODB recordset!");

            my $objCommand = Win32::OLE-E<gt>new ("ADODB.Command") 
                 or die ("Cannot create ADODB command!");

            my %hashAdRecord;

The above code snippet from the `GetUserData` subroutine shows what
values are assigned to varaibles. This subroutine has four arguments:

a\. \$strAttributeName

b\. \$strAttributeValue

c\. \$strADsPath

d\. \$strDomain

At this juncture, I'll try to explain how the above variables are used.
In our case, we will search the Active Directory for the record that
contains a given value for the userPrincipalName. As such,
`$strAttributeName = "userPrincipalName"`. If the user ID is *jsmith12*,
then `$strAttributeValue = "jsmith12"`. Alternatively, if we call the
`GetUserData` subroutine from inside the AuthenticateUser subroutine, we
declare `$strAttributeValue = $strUserID` in the AuthenticateUser
subroutine.

Since we have used the user ID instead of the full `userPrincipalName`,
we need to append *@somedomain* to the user ID. Hence we get,

        if ($strAttributeName eq "userPrincipalName") { 
            $strAttributeValue = $strAttributeValue . $strDomain; 
        }

The remainder of the above variable declarations with the exception of
`%hashAdRecord` are required to enable ADO to bind with ADSI. I'll try
to explain what's happening there. First we create the following
objects:

a\. ADODB connection object

b\. ADODB Recordset object

c\. ADODB Command object

Once these objects have been created, we assign values to selected
properties of the ADODB Connection object.

        $objConnection->{Provider} = ("ADsDSOObject");
        $objConnection->{ConnectionString} = ($strConnectionString);

        $objConnection->Open();
        $objCommand->{ActiveConnection} = ($objConnection);

We open the ADODB connection, and assign the ADODB Connection object to
the ActiveConnection property of the ADODB Command object.

        $objCommand->{CommandText} = ($strCommandText);

        $objRecordset = $objCommand->Execute($strCommandText) 
            or die ("Cannot execute!");

We assign \$strCommandText to the CommandText property of the ADODB
Command object, and next, we run the Execute method of the ADODB Command
object.The \$strCommandText variable is the argument of the Execute
method. The value of the \$strCommandText is the Active Directory analog
of an SQL statement use to query an relational database.
\$strCommandText comprises four elements:

a\. \$strADsPath

b\. \$strFilter

c\. \$strAttribs

d\. \$strScope

\$strADsPath contains the address of the Active Directory server, and
the subset of the total set of records one wishes to search through. The
address of the Active Directory server is specified by splitting the
domain name up. And the result is `DC=someuniversity,DC=edu`. The subset
of the records in the Active Directory is defined by listing the
hierarchy of OUs (Organizational Units) e.g.
`OU=somedivision,OU=somedepartment`. The syntax of the entire
\$strADsPath string complies with the LDAP RFC 2307 syntax. However,
many programming or scripting languages do not seem to support this
syntax as yet. Instead, the LDAP RFC 2251 syntax is widely supported.

\$strFilter specificies the Active Directory records that we are
interested in. In this instance, we are interested in the record where
`userPrincipalName` is equal to `someuserid@someuniversity.edu`. Hence,
this relationship is expressed as

        $strFilter="(" . $strAttributeName . "=" . $strAttributeValue . ")".

\$strAttribs contains the list of fields that we want to retrieve from
the query. If the query is successful, the result will be returned in
ADODB Recordset object, and we can use the methods in the ADODB
Recordset objects to retrieve the data.

`$strScope="subtree"` indicates that the scope of the search is limited
to the subtree that has been specified in `$strADsPath`.

Finally, we turn our attention to getting a list of a user's superiors.
This is possible because each user's record in the Active Directory has
a `manager` field that contains the canonical name or `CN` (amongst
other bits of data) of the user's immediate superior. The
`GetCommandChain` subroutine returns an array of a user's superiors.
This subroutine takes two arguments:

a\. \$refAdRecord

b\. \$strApexTitle

        sub GetManagerString {
            my %hashAdRecord = %$refAdRecord;
            my $strManagerString=$hashAdRecord{"manager"};
            return $strManagerString;
        }

\$refAdRecord is the reference of the user's data returned by
`GetUserData`. \$strApexTitle is the highest office (e.g. \`\`Division
Manager'') relevant to the search. The logic within this subroutine is
quite simple. We make use of the `GetManagerString` subroutine to
retrieve the data that was obtained from the `Manager` field in the
Active Directory.

        sub GetManagerCN {
            my $strManagerString=shift;
            $strManagerString =~ /\bCN=([-_#@%\&\$\*\.a-zA-Z0-9\s]+)/;
            return $1;
        }

Next we use the `GetManagerCN` subroutine to extract the canonical name
from the string returned by the `GetManagerString` subroutine.

        do {
            $refAdRecord =
            <GetUserData>("cn",$strManagerCN,"LDAP://OU=somedivision,
            OU=somedepartment,DC=someuniversity,DC=edu",
            "\@someuniversity.edu");
            %hashAdRecord=%$refAdRecord;

            $strTitle = $hashAdRecord{"title"};

            push @arrCommandChain, {%hashAdRecord};
            $strManagerString = GetManagerString($refAdRecord);
            $strManagerCN = GetManagerCN($strManagerString); 
        } until ($strTitle eq $strApexTitle);
        $refCommandChain = \@arrCommandChain;
        return $refCommandChain;

A `do` loop is used to traverse up the management hierarchy till we
reach the user record that has a title value which matches the value in
`$strApexTitle`. Over each iteration, we store the hash of the data
retreived from the Active Directory into the array `@arrCommandChain`.
Finally, we return the reference to this array as `$refCommandChain`.

In the next section we will examine how the client uses the XML-RPC
mechanism to make requests of the daemon.

### [The Client in Perl]{#the client in perl}

Since most of the work is done by the active directory daemon, the
active directory client in Perl is relatively simple. Because we've used
the XML-RPC protocol, the client can be written in various languages,
e.g. PHP 4, Python, Java, etc. However we shall continue with Perl to be
consistent with the theme of this web site.

As with the daemon, we invoke the strict pragma, and load the
Frontier::Client module.

        $strDaemon_url = "http://www.someuniversity.edu:8080/RPC2";

To make use of the subroutines in the Active Directory daemon, we need
to provide a url to the daemon. In our case we've assigned the url to
the `$strDaemon_url` variable. As discussed in the Daemon section of
this article, we've assigned port 8080 for our daemon's use. The
`Frontier::Daemon` package has also assigned a default virtual
directory, RPC2.

Next, we create a new instance of the XML RPC client by passing
\$strDaemon\_url as the value part of the key-value pair of a hash
entry.

        $objServer = Frontier::Client->new(url => $strDaemon_url);

Now we can utilize the published subroutines in the Active Directory
daemon.

    $refAdRecord=$objServer->call('activedirectory_daemon.AuthenticateUser','someuserid',
    'Somepassword1','LDAP://OU=somedivision,OU=somedepartment,DC=someuniversity,DC=edu',
    "\@someuniversity.edu");

The first argument in the `$objServer->call` subroutine is the qualified
daemon subroutine name. The rest of the arguments are the arguments of
the daemon subroutine.

As mentioned earlier, the XML-RPC daemon, can only return references. As
such, we need to convert references to hashes, or arrays as appropriate.
For example, `%hashAdRecord = %$refAdRecord`.

### [Conclusion]{#conclusion}

XML-RPC is a much more than an effective mechanism to enable distributed
computing. We can use it to provide access to platform specific
services. In our case, we used XML-RPC to enable a non-Windows host to
access data and services in the Active Directory. Furthermore, XML-RPC
is simple to implement. I've made forays into distributed computing
several years ago by way of Java's RMI and Microsoft's DCOM. In my
experience, XML-RPC is by far the cleanest and most fuss-free mechanism
of the three.

So, if you're a Perl programmer, and are looking to leveraging off a
service that only runs on the Windows platform, give Active Perl and
XML-RPC a go. You'll be pleasantly surprised.

### [Resources]{#resources}

<http://www.cpan.org>

<http://www.activestate.com>

<http://xmlrpc-c.sourceforge.net/xmlrpc-howto/xmlrpc-howto.html>


