{
   "thumbnail" : null,
   "description" : " Data management is a critical and challenging aspect for any online resource. With exponentially growing data sizes and popularity of rich media, even small online resources must effectively manage and distribute a significant amount of data. Moreover, the peace...",
   "title" : "Using Amazon S3 from Perl",
   "slug" : "/pub/2008/04/08/using-amazon-s3-from-perl.html",
   "authors" : [
      "abel-lin"
   ],
   "date" : "2008-04-08T00:00:00-08:00",
   "image" : null,
   "categories" : "web",
   "tags" : [
      "amazon",
      "cloud-storage",
      "rest",
      "s3",
      "web-services"
   ],
   "draft" : null
}





Data management is a critical and challenging aspect for any online
resource. With exponentially growing data sizes and popularity of rich
media, even small online resources must effectively manage and
distribute a significant amount of data. Moreover, the peace of mind
associated with an additional offsite data storage resource is
invaluable to everyone involved.

At [SundayMorningRides.com](http://www.sundaymorningrides.com/), we
manage a growing inventory of GPS and general GIS (Geography Information
Systems) data and web content (text, images, videos, etc.) for the end
users. In addition, we must also effectively manage daily snapshots,
backups, as well as multiple development versions of our web site and
supporting software. For any small organization, this can add up to
significant costs -- not only as an initial monetary investment but also
in terms of ongoing labor costs for maintenance and administration.

Amazon Simple Storage Service (S3) was released specifically to address
the problem of data management for online resources -- with the aim to
provide "reliable, fast, inexpensive data storage infrastructure that
Amazon uses to run its own global network of web sites." Amazon S3
provides a web service interface that allows developers to store and
retrieve any amount of data. S3 is attractive to companies like
SundayMorningRides.com as it frees us from upfront costs and the ongoing
costs of purchasing, administration, maintenance, and scaling our own
storage servers.

This article covers the Perl, REST, and the Amazon S3 REST module,
walking through the development of a collection of Perl-based tools for
UNIX command-line based interaction to Amazon S3. I'll also show how to
set access permissions so that you can serve images or other data
directly to your site from Amazon S3.

#### A Bit on Web Services

Web services have become the de-facto method of exposing information
and, well, services via the Web. Intrinsically, web services provide a
means of interaction between two networked resources. Amazon S3 is
accessible via both Simple Object Access Protocol (SOAP) or
representational state transfer (REST).

The SOAP interface organizes features into custom-built operations,
similar to remote objects when using Java Remote Method Invocation (RMI)
or Common Object Resource Broker Architecture (CORBA). Unlike RMI or
CORBA, SOAP uses XML embedded in the body of HTTP requests as the
application protocol.

Like SOAP, REST also uses HTTP for transport. Unlike SOAP, REST
operations are the standard HTTP operations -- GET, POST, PUT, and
DELETE. I think of REST operations in terms of the CRUD semantics
associated with relational databases: POST is Create, GET is Retrieve,
PUT is Update, and DELETE is Delete.

#### "Storage for the Internet"

Amazon S3 represents the data space in three core concepts: *objects*,
*buckets*, and *keys*.

-   Objects are the base level entities within Amazon S3. They consist
    of both object data and metadata. This metadata is a set of
    name-attribute pairs defined in the HTTP header.
-   Buckets are collections of objects. There is no limit to the number
    of objects in a bucket, but each developer is limited to 100
    buckets.
-   Keys are unique identifiers for objects.

Without wading through the details, I tend think of buckets as folders,
objects as files, and keys as filenames. The purpose of this abstraction
is to create a unique HTTP namespace for every object.

I'll assume that you have already signed up for [Amazon
S3](http://aws.amazon.com/s3) and received your Access Key ID and Secret
Access Key. If not, please do so.

Please note that the `S3::*` modules aren't the only Perl modules
available for connecting to Amazon S3. In particular,
[Net::Amazon::S3](http://search.cpan.org/perldoc?Net::Amazon::S3) hides
a lot of the details of the S3 service for you. For now, I'm going to
use a simpler module to explain how the service works internally.

#### Connecting, Creating, and Listing Buckets

Connecting to Amazon S3 is as simple as supplying your Access Key ID and
your Secret Access Key to create a connection, called here `$conn`.
Here's how to create and list the contents of a bucket as well as list
all buckets.

    #!/usr/bin/perl

    use S3::AWSAuthConnection;
    use S3::QueryStringAuthGenerator;

    use Data::Dumper;

    my $AWS_ACCESS_KEY_ID     = 'YOUR ACCESS KEY';
    my $AWS_SECRET_ACCESS_KEY = 'YOUR SECRET KEY';

    my $conn = S3::AWSAuthConnection->new($AWS_ACCESS_KEY_ID,
                                          $AWS_SECRET_ACCESS_KEY);

    my $BUCKET = "foo";

    print "creating bucket $BUCKET \n";
    print $conn->create_bucket($BUCKET)->message, "\n";

    print "listing bucket $BUCKET \n";
    print Dumper @{$conn->list_bucket($BUCKET)->entries}, "\n";

    print "listing all my buckets \n";
    print Dumper @{$conn->list_all_my_buckets()->entries}, "\n";

Because every S3 action takes place over HTTP, it is good practice to
check for a 200 response.

    my $response = $conn->create_bucket($BUCKET);
    if ($response->http_response->code == 200) {
        # Good
    } else {
        # Not Good
    }

As you can see from the output, the results come back in a hash. I've
used [Data::Dumper](http://search.cpan.org/perldoc?Data::Dumper) as a
convenient way to view the contents. If you are running this for the
first time, you will obviously not see anything listed in the bucket.

    listing bucket foo
    $VAR1 = {
              'Owner' => {
                         'ID' => 'xxxxx',
                         'DisplayName' => 'xxxxx'
                       },
              'Size' => '66810',
              'ETag' => '"xxxxx"',
              'StorageClass' => 'STANDARD',
              'Key' => 'key',
              'LastModified' => '2007-12-18T22:08:09.000Z'
            };
    $VAR4 = '
    ';
    listing all my buckets
    $VAR1 = {
              'CreationDate' => '2007-11-28T17:31:48.000Z',
              'Name' => 'foo'
            };
    ';

#### Writing an Object

Writing an object is simply a matter of using the HTTP PUT method. Be
aware that there is nothing to prevent you from overwriting an existing
object; Amazon S3 will automatically update the object with the more
recent write request. Also, it's currently not possible to append to or
otherwise modify an object in place without replacing it.

    my %headers = (
        'Content-Type' => 'text/plain'
    );
    $response = $conn->put( $BUCKET, $KEY, S3Object->new("this is a test"),
                            \%headers);

Likewise, you can read a file from STDIN:

    my %headers;

    FILE: while(1) {
        my $n = sysread(STDIN, $data, 1024 * 1024, length($data));
        if ($n < 0) {
            print STDERR "Error reading input: $!\n";
            exit 1;
        }
        last FILE if $n == 0;
    }
    $response = $conn->put("$BUCKET", "$KEY", $data, \%headers);

To add custom metadata, simply add to the `S3Object`:

    S3Object->new("this is a test", { name => "attribute" })

By default, every object has private access control when written. This
allows only the user that stored the object to read it back. You can
change these settings. Also, note that each object can hold a maximum of
5 GB of data.

You are probably wondering if it is also possible to upload via a
standard HTTP POST. The folks at Amazon are working on it as we speak --
see [HTTP POST beta
discussion](http://developer.amazonwebservices.com/connect/thread.jspa?threadID=18616&tstart=0)
for more information. Until that's finished, you'll have to perform
web-based uploads via an intermediate server.

#### Reading an Object

Like writing objects, there are several ways to read data from Amazon
S3. One way is to generate a temporary URL to use with your favorite
client (for example, wget or Curl) or even a browser to view or retrieve
the object. All you have to do is generate the URL used to make the REST
call.

    my $generator = S3::QueryStringAuthGenerator->new($AWS_ACCESS_KEY_ID,
        $AWS_SECRET_ACCESS_KEY);

...and then perform a simple HTTP GET request. This is a great trick if
all you want to do is temporarily view or verify the data.

    $generator->expires_in(60);
    my $url = $generator->get($BUCKET, "$KEY");
    print "$url \n";

You can also programmatically read the data directly from the initial
connection. This is handy if you have to perform additional processing
of the data.

    my $response = $conn->get("$BUCKET", "$KEY");
    my $data     = $response->object->data;

Another cool feature is [the ability to use BitTorrent to download files
from Amazon S3](http://docs.amazonwebservices.com/AmazonS3/2006-03-01/)
. You can access any object that has anonymous access privileges via
BitTorrent.

#### Delete an Object

By now you probably have the hang of the process. If you're going to
create objects, you're probably going to have to delete them at some
point.

    $conn->delete("$BUCKET", "$KEY");

#### Set Access Permissions and Publish to a Website

As you may have noticed from the previous examples, all Amazon S3
objects access goes through HTTP. This makes Amazon S3 particularly
useful as a online repository. In particular, it's useful to manage and
serve website media. You could almost imagine Amazon S3 serving as mini
Content Delivery Network for media on your website. This example will
demonstrate how to build a very simple online page where the images are
served dynamically via Amazon S3.

The first thing to do us to upload some images and set the ACL
permissions to public. I've modified the previous example with one
difference. To make objects publicly readable, include the header
`x-amz-acl: public-read` with the HTTP PUT request.

    my %headers = (
        'x-amz-acl' => 'public-read',
    );

Additional ACL permissions include:

-   private (default setting if left blank)
-   public-read
-   public-read-write
-   authenticated-read

Now you know enough to put together a small script that will
automatically display all images in the bucket to a web page (you'll
probably want to spruce up the formatting).

    ...
    my $BUCKET   = "foobar";
    my $response = $conn->list_bucket("$BUCKET");

    for my $entry (@{$response->entries}) {
        my $public_url   = $generator->get($BUCKET, $entry->{Key});
        my ($url, undef) = split (/\?/, $public_url);
        $images         .= "<img src=\"$url\"><br />";
    }
    ($webpage =  <<"WEBPAGE");
    <html><body>$images</body></html>
    WEBPAGE
    print $q->header();
    print $webpage;

To add images to this web page, upload more files into the bucket and
they will automatically appear the next time you load the page.

It's also simple to link to media one at a time for a webpage. If you
examine the HTML generated by this example, you'll see that all Amazon
S3 URLs have the basic form
`http://bucketname.s3.amazon.com/objectname`. Also note that the
namespace for buckets is shared with all Amazon S3 users. You may have
already picked up on this.

### Conclusion

Amazon S3 is a great tool that can help with the data management needs
of all sized organizations by offering cheap and unlimited storage. For
personal use, it's a great tool for backups (also good for
organizations) and general file storage. It's also a great tool for
collaboration. Instead of emailing files around, just upload a file and
set the proper access controls -- no more dealing with 10 MB attachment
restrictions!

At [SundayMorningRides.com](http://www.sundaymorningrides.com/) we use
S3 as part of our web serving infrastructure to reduce the load on our
hardware when serving media content.

When combined with other Amazon Web Services such as SimpleDB (for
structured data queries) and Elastic Compute Cloud (for data processing)
it's easy to envision a low cost solution for web-scale computing and
data management.

#### More Resources and References

-   [Amazon S3 Homepage](http://aws.amazon.com/s3)
-   [Amazon Webservices Developer
    Connection](http://developer.amazonwebservices.com/)
-   [Amazon S3 Library for REST in
    Perl](http://developer.amazonwebservices.com/connect/entry.jspa?externalID=133&categoryID=47)
-   [Amazon Web Services Blog](http://aws.typepad.com/)


