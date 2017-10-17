{
   "categories" : "data",
   "draft" : false,
   "image" : "/images/98/ED2BDE36-FF2E-11E3-B3B4-5C05A68B9E16.jpeg",
   "tags" : [
      "file",
      "dbix_class",
      "path_class_file",
      "upload",
      "orm",
      "application",
      "web",
      "old_site"
   ],
   "date" : "2014-06-30T12:17:25",
   "title" : "Managing files is a breeze with this DBIx::Class plugin",
   "slug" : "98/2014/6/30/Managing-files-is-a-breeze-with-this-DBIx--Class-plugin",
   "description" : "Read about how DBIx::Class::InflateColumn::FS can simplify file management in your application",
   "authors" : [
      "david-farrell"
   ]
}


*Managing application file uploads is challenging: storage, de-duplication, retrieval and permissions all need to be handled. DBIx::Class::InflateColumn::FS simplifies the challenge by handling the backend storage of files so the programmer can focus on application development. Let's take a closer look at how it works.*

### Requirements

To use this example, you'll need to install [DBIx::Class::InflateColumn::FS](https://metacpan.org/pod/DBIx::Class::InflateColumn::FS) from CPAN. The CPAN Testers [results](http://matrix.cpantesters.org/?dist=DBIx-Class-InflateColumn-FS+0.01007) show that it should run on all platforms, including Windows. You'll also need [DBIx::Class::Schema::Loader](https://metacpan.org/pod/DBIx::Class::Schema::Loader) and [File::MimeInfo](https://metacpan.org/pod/File::MimeInfo) if you don't already have them and [SQLite3](https://sqlite.org/). To install the Perl modules, open the terminal and enter:

``` prettyprint
$ cpan DBIx::Class::InflateColumn::FS DBIx::Class::Schema::Loader File::MimeInfo
```

### Setup the result class

Let's create an example class for handling file uploads. DBIx::Class maps objects to database tables, so we need to create a database table that represents our file upload object. This is the SQL code for creating the upload table:

``` prettyprint
create table upload (
    id          integer     primary key,
    file        text        not null,
    mime        text        not null
);
```

Save the code into a script called create\_upload.sql and run it at the command line:

``` prettyprint
$ sqlite3 MyApp.db < create_upload.sql
```

This will create the upload table. Next we can use the "dbicdump" app that comes with DBIx::Class::Schema::Loader to create the basic result class for us:

``` prettyprint
$ dbicdump MyApp::Schema dbi:SQLite:MyApp.db
```

Open up the newly-created MyApp/Schema/Result/Upload.pm in a text editor and add the following code, below the line beginning "\# DO NOT MODIFY ...":

``` prettyprint
use File::MimeInfo 'extensions';

__PACKAGE__->load_components("InflateColumn::FS");
__PACKAGE__->add_columns(
    "file",
    {   
        data_type      => 'TEXT',
        is_fs_column   => 1,
        fs_column_path => 'uploads',
    }   
);

sub extension { 
    my ($self) = @_;
    [ extensions($self->mime) ]->[0];
}
```

This code enables the DBIx::Class::InflateColumn::FS plugin on the "file" attribute of our Upload class. Additionally we've added a subroutine called "extension" that will return the file extension for the file.

### Create an upload

This script will create an upload object:

``` prettyprint
#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Schema;
use MIME::Types;
use lib '.';

open(my $file, '<', $ARGV[0]) or die $!; 

my $schema = MyApp::Schema->connect('dbi:SQLite:MyApp.db');

# Add the file to the database and file system
my $upload = $schema->resultset('Upload')->
        create({ file => $file,
                 mime => (MIME::Types->new->mimeTypeOf($ARGV[0])) });
```

Saving the script as "create\_upload.pl" we can call it at the terminal, passing the filepath to the file we want to save:

``` prettyprint
$ perl create_upload.pl perltricks_logo.png
```

Just by creating the object, DBIx::Class::InflateColumn::FS will save the file in our uploads directory. No need to write extra code that explicitly copies the file.

### Retrieve an upload

This script will retrieve the upload object. DBIx::Class::InflateColumn::FS automatically inflates the "file" column to be a [Path::Class::File](https://metacpan.org/pod/Path::Class::File) object, which gives us many convenience methods:

``` prettyprint
#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Schema;
use lib '.';

my $schema = MyApp::Schema->connect('dbi:SQLite:MyApp.db');

# retrieve the upload
my $upload = $schema->resultset('Upload')->find(1);

# get the relative path
$upload->file->relative;

# get the absolute path
$upload->file->absolute;

# get the base filename
$upload->file->basename;

# get the mime type (image/png)
$upload->mime;

# get the file extension
$upload->extension;

# get a read filehandle
$upload->file->openr;

# get a write filehandle
$upload->file->openw;

# get an append filehandle
$upload->file->opena;
```

### Delete an upload

DBIx::Class::InflateColumn::FS makes it super-simple to delete files. Simply call delete on the result object to delete it from the table and the file system:

``` prettyprint
#!/usr/bin/env perl
use strict;
use warnings;
use MyApp::Schema;
use lib '.';

my $schema = MyApp::Schema->connect('dbi:SQLite:MyApp.db');

# retrieve the upload
my $upload = $schema->resultset('Upload')->find(1);

# delete the file from the database and file system
$upload->delete;
```

### Conclusion

DBIx::Class::InflateColumn::FS is useful as-is, but it shines in certain situations. For example if you're managing image files, it really pays to store the original high-quality image, and dynamically re-size the image when requested. This way you minimize disk use and retain the flexibility in the application logic to adjust the images as required.

Thanks to Devin Austin whose Catalyst advent calendar [article](http://www.catalystframework.org/calendar/2008/5) was a useful source for this article.

Enjoyed this article? Help us out and [tweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F98%2F2014%2F6%2F30%2FManaging-files-is-a-breeze-with-this-DBIx--Class-plugin&text=Managing+files+is+a+breeze+with+this+DBIx%3A%3AClass+plugin&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F98%2F2014%2F6%2F30%2FManaging-files-is-a-breeze-with-this-DBIx--Class-plugin&via=perltricks) about it!

*Cover image [©](https://creativecommons.org/licenses/by/2.0/) [Cas](https://www.flickr.com/photos/brightmeadow/3748310435/in/photolist-6He56Z-bDdcmL-5Jp3Z-aZWgk-aaGbZM-aZWfK-5uGDfb-63MA6m-88qSJK-6B33mX-76En59-6N6eHG-5UFiwj-3rXHK-aZWiH-4CmaD2-6vWgnX-3bai1p-c3CSTq-3PChVM-7hdnBS-2iYPPt-8Vx4Eo-4Cmav8-6P8qMy-jfddWn-4RoQjt-5ZrohQ-eQikQL-dGWiLV-4C7epr-dH2HeL-4C7eve-bnpqbW-4CmavB-8Nvnmc-8SfZR6-3ppzd-7PEzCG-FLPq-9gXmeE-dGWi5t-8Sg3sF-7h9qon-8EWHyq-dGWhC6-buGn9s-c1AukG-7VSc8B-dRCTcZ)*

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
