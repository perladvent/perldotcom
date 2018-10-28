{
   "categories" : "development",
   "image" : null,
   "title" : "Cooking with Perl, Part 2",
   "date" : "2003-09-03T00:00:00-08:00",
   "tags" : [
      "perl",
      "perl-cookbook",
      "sending-attachments-in-email",
      "using-sql-without-a-database-server"
   ],
   "thumbnail" : null,
   "draft" : null,
   "authors" : [
      "tom-christiansen",
      "nathan-torkington"
   ],
   "description" : " Editor's note: The new edition of Perl Cookbook has released, so this week we continue to highlight recipes-new to the second edition-for your sampling pleasure. This week's excerpts include recipes from Chapter 14 (\"Database Access\") and Chapter 18 (\"Internet...",
   "slug" : "/pub/2003/09/03/perlcookbook.html"
}



*Editor's note: The new edition of [Perl Cookbook](http://www.oreilly.com/catalog/perlckbk2/index.html?CMP=IL7015) has released, so this week we continue to highlight recipes--new to the second edition--for your sampling pleasure. This week's excerpts include recipes from Chapter 14 ("Database Access") and Chapter 18 ("Internet Services"). And be sure to check back here next week for more new recipes on extracting table data, making simple changes to elements or text, and templating with HTML::Mason.*

### Sample Recipe: Using SQL Without a Database Server

#### Problem

You want to make complex SQL queries but don't want to maintain a relational database server.

#### Solution

Use the DBD::SQLite module from CPAN:

    use DBI;
     
    $dbh = DBI->connect("dbi:SQLite:dbname=/Users/gnat/salaries.sqlt", "", "",
                        { RaiseError => 1, AutoCommit => 1 });
     
    $dbh->do("UPDATE salaries SET salary = 2 * salary WHERE name = 'Nat'");
     
    $sth = $dbh->prepare("SELECT id,deductions FROM salaries WHERE name = 'Nat'");
    # ...

#### Discussion

An SQLite database lives in a single file, specified with the `dbname` parameter in the DBI constructor. Unlike most relational databases, there's no database server here--DBD::SQLite interacts directly with the file. Multiple processes can read from the same database file at the same time (with SELECTs), but only one process can make changes (and other processes are prevented from reading while those changes are being made).

SQLite supports transactions. That is, you can make a number of changes to different tables, but the updates won't be written to the file until you commit them:

    use DBI;
    $dbh = DBI->connect("dbi:SQLite:dbname=/Users/gnat/salaries.sqlt", "", "",
                        { RaiseError => 1, AutoCommit => 0 });
    eval {
      $dbh->do("INSERT INTO people VALUES (29, 'Nat', 1973)");
      $dbh->do("INSERT INTO people VALUES (30, 'William', 1999)");
      $dbh->do("INSERT INTO father_of VALUES (29, 30)");
      $dbh->commit(  );
    };
    if ($@) {
          eval { $dbh->rollback(  ) };
          die "Couldn't roll back transaction" if $@;
    }

SQLite is a typeless database system. Regardless of the types specified when you created a table, you can put any type (strings, numbers, dates, blobs) into any field. Indeed, you can even create a table without specifying any types:

    CREATE TABLE people (id, name, birth_year);

The only time that data typing comes into play is when comparisons occur, either through WHERE clauses or when the database has to sort values. The database ignores the type of the column and looks only at the type of the specific value being compared. Like Perl, SQLite recognizes only strings and numbers. Two numbers are compared as floating-point values, two strings are compared as strings, and a number is always less than a string when values of two different types are compared.

There is only one case when SQLite looks at the type you declare for a column. To get an automatically incrementing column, such as unique identifiers, specify a field of type "INTEGER PRIMARY KEY":

    CREATE TABLE people (id INTEGER PRIMARY KEY, name, birth_year);

[Example 14-6](#79318) shows how this is done.

**<span id="79318">Example 14-6:</span>** **ipk**

      #!/usr/bin/perl -w
      # ipk - demonstrate integer primary keys
      use DBI;
      use strict;
      my $dbh = DBI->connect("dbi:SQLite:ipk.dat", "", "",
      {RaiseError => 1, AutoCommit => 1});
      # quietly drop the table if it already existed
      eval {
        local $dbh->{PrintError} = 0;
        $dbh->do("DROP TABLE names");
      };
      # (re)create it
      $dbh->do("CREATE TABLE names (id INTEGER PRIMARY KEY, name)");
      # insert values
      foreach my $person (qw(Nat Tom Guido Larry Damian Jon)) {
        $dbh->do("INSERT INTO names VALUES (NULL, '$person')");
      }
      # remove a middle value
      $dbh->do("DELETE FROM names WHERE name='Guido'");
      # add a new value
      $dbh->do("INSERT INTO names VALUES (NULL, 'Dan')");
      # display contents of the table
      my $all = $dbh->selectall_arrayref("SELECT id,name FROM names");
      foreach my $row (@$all) {
        my ($id, $word) = @$row;
        print "$word has id $id\n";
      }

SQLite can hold 8-bit text data, but can't hold an ASCII NUL character (`\0`). The only workaround is to do your own encoding (for example, URL encoding or Base64) before you store and after you retrieve the data. This is true even of columns declared as BLOBs.

#### See Also

"Executing an SQL Command Using DBI;" the documentation for the CPAN module DBD::SQLite; the SQLite home page at <http://www.hwaci.com/sw/sqlite/>

### Sample Recipe: Sending Attachments in Mail

#### Problem

You want to send mail that includes attachments; for example, you want to mail a PDF document.

#### Solution

Use the MIME::Lite module from CPAN. First, create a MIME::Lite object representing the multipart message:

    use MIME::Lite;
     
    $msg = MIME::Lite->new(From    => 'sender@example.com',
                           To      => 'recipient@example.com',
                           Subject => 'My photo for the brochure',
                           Type    => 'multipart/mixed');

Then, add content through the `attach` method:

    $msg->attach(Type        => 'image/jpeg',
                 Path        => '/Users/gnat/Photoshopped/nat.jpg',
                 Filename    => 'gnat-face.jpg');
     
    $msg->attach(Type        => 'TEXT',
                 Data        => 'I hope you can use this!');

Finally, send the message, optionally specifying how to send it:

    $msg->send(  );            # default is to use sendmail(1)
    # alternatively
    $msg->send('smtp', 'mailserver.example.com');

#### Discussion

The MIME::Lite module creates and sends mail with MIME-encoded attachments. MIME stands for Multimedia Internet Mail Extensions, and is the standard way of attaching files and documents. It can't, however, extract attachments from mail messages--for that you need to read Recipe "Extracting Attachments from Mail."

When creating and adding to a MIME::Lite object, pass parameters as a list of named parameter pairs. The pair conveys both mail headers (e.g., `From`, `To`, `Subject`) and those specific to MIME::Lite. In general, mail headers should be given with a trailing colon:

    $msg = MIME::Lite->new('X-Song-Playing:' => 'Natchez Trace');

However, MIME::Lite accepts the headers in [Table 18-2](#20112) without a trailing colon. `*` indicates a wildcard, so `Content-*` includes `Content-Type` and `Content-ID` but not `Dis-Content`.

|             |                |               |           |
|-------------|----------------|---------------|-----------|
| `Approved`  | `Encrypted`    | `Received`    | `Sender`  |
| `Bcc`       | `From`         | `References`  | `Subject` |
| `Cc`        | `Keywords`     | `Reply-To`    | `To`      |
| `Comments`  | `Message-ID`   | `Resent-*`    | `X-*`     |
| `Content-*` | `MIME-Version` | `Return-Path` |           |
| `Date`      | `Organization` |               |           |

The full list of MIME::Lite options is given in [Table 18-3](#21965).

|               |            |           |
|---------------|------------|-----------|
| `Data`        | `FH`       | `ReadNow` |
| `Datestamp`   | `Filename` | `Top`     |
| `Disposition` | `Id`       | `Type`    |
| `Encoding`    | `Length`   |           |
| `Filename`    | `Path`     |           |

The MIME::Lite options and their values govern what is attached (the data) and how:

`Path`
The file containing the data to attach.

`Filename`
The default filename for the reader of the message to save the file as. By default this is the filename from the `Path` option (if `Path` was specified).

`Data`
The data to attach.

`Type`
The `Content-Type` of the data to attach.

`Disposition`
Either `inline` or `attachment`. The former indicates that the reader should display the data as part of the message, not as an attachment. The latter indicates that the reader should display an option to decode and save the data. This is, at best, a hint.

`FH`
An open filehandle from which to read the attachment data.

There are several useful content types: `TEXT` means `text/plain`, which is the default; `BINARY` similarly is short for `application/octet-stream`; `multipart/mixed` is used for a message that has attachments; `application/msword` for Microsoft Word files; `application/vnd.ms-excel` for Microsoft Excel files; `application/pdf` for PDF files; `image/gif`, `image/jpeg`, and `image/png` for GIF, JPEG, and PNG files, respectively; `audio/mpeg` for MP3 files; `video/mpeg` for MPEG movies; `video/quicktime` for Quicktime (*.mov*) files.

The only two ways to send the message are using *sendmail*(1) or using Net::SMTP. Indicate Net::SMTP by calling `send` with a first argument of `"smtp"`. Remaining arguments are parameters to the Net::SMTP constructor:

    # timeout of 30 seconds
    $msg->send("smtp", "mail.example.com", Timeout => 30);

If you plan to make more than one MIME::Lite object, be aware that invoking `send` as a class method changes the default way to send messages:

    MIME::Lite->send("smtp", "mail.example.com");
    $msg = MIME::Lite->new(%opts);
    # ...
    $msg->send(  );                   # sends using SMTP

If you're going to process multiple messages, also look into the `ReadNow` parameter. This specifies that the data for the attachment should be read from the file or filehandle immediately, rather than when the message is sent, written, or converted to a string.

Sending the message isn't the only thing you can do with it. You can get the final message as a string:

    $text = $msg->as_string;

The `print` method writes the string form of the message to a filehandle:

    $msg->print($SOME_FILEHANDLE);

[Example 18-3](#85143) is a program that mails filenames given on the command line as attachments.

**<span id="85143">Example 18-3:</span>** **mail-attachment**

    #!/usr/bin/perl -w
    # mail-attachment - send files as attachments
     
    use MIME::Lite;
    use Getopt::Std;
     
    my $SMTP_SERVER = 'smtp.example.com';           # CHANGE ME
    my $DEFAULT_SENDER = 'sender@example.com';      # CHANGE ME
    my $DEFAULT_RECIPIENT = 'recipient@example.com';# CHANGE ME
     
    MIME::Lite->send('smtp', $SMTP_SERVER, Timeout=>60);
     
    my (%o, $msg);
     
    # process options
     
    getopts('hf:t:s:', \%o);
     
    $o{f} ||= $DEFAULT_SENDER;
    $o{t} ||= $DEFAULT_RECIPIENT;
    $o{s} ||= 'Your binary file, sir';
     
    if ($o{h} or !@ARGV) {
        die "usage:\n\t$0 [-h] [-f from] [-t to] [-s subject] file ...\n";
    }
     
    # construct and send email
     
    $msg = new MIME::Lite(
        From => $o{f},
        To   => $o{t},
        Subject => $o{s},
        Data => "Hi",
        Type => "multipart/mixed",
    );
     
    while (@ARGV) {
      $msg->attach('Type' => 'application/octet-stream',
                   'Encoding' => 'base64',
                   'Path' => shift @ARGV);
    }
     
    $msg->send(  );

#### See Also

The documentation for MIME::Lite

------------------------------------------------------------------------

O'Reilly & Associates recently released (August 2003) [Perl Cookbook, 2nd Edition.](http://www.oreilly.com/catalog/perlckbk2/index.html?CMP=IL7015)

-   [Sample Chapter 1, Strings](http://www.oreilly.com/catalog/perlckbk2/chapter/index.html?CMP=IL7015) is available free online.
-   You can also look at the [Table of Contents](http://www.oreilly.com/catalog/perlckbk2/toc.html?CMP=IL7015), the [Index](http://www.oreilly.com/catalog/perlckbk2/inx.html?CMP=IL7015), and the [full description](http://www.oreilly.com/catalog/perlckbk2/desc.html?CMP=IL7015) of the book.
-   For more information, or to order the book, [click here](http://www.oreilly.com/catalog/perlckbk2/index.html?CMP=IL7015).

