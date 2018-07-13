{
   "image" : "/images/deploy-a-static-website-with-aws-s3-and-paws/aws-logo.png",
   "description" : "Paws is a comprehensive Perl distribution for AWS services",
   "date" : "2017-02-21T10:04:00",
   "tags" : [
      "aws",
      "paws",
      "s3",
      "static-website"
   ],
   "title" : "Deploy a static website with AWS S3 and Paws",
   "draft" : false,
   "thumbnail" : "/images/deploy-a-static-website-with-aws-s3-and-paws/thumb_aws-logo.png",
   "categories" : "development",
   "authors" : [
      "david-farrell"
   ]
}

Amazon Web Services (AWS) is Amazon's cloud services platform and S3 is the AWS file storage service. S3 is commonly used to host static websites. With Perl we have many modules for using AWS, but I like [Paws]({{<mcpan "Paws" >}}), developed by [Jose Luis Martinez](https://metacpan.org/author/JLMARTIN) which supports many AWS services, including S3. In this article I'll walk you through a Perl script I developed to upload and maintain a static website using S3 and Paws.

### AWS setup

To use AWS from the command line you'll need a to generate a key id and secret key for your account which you can get from the [AWS website](https://aws.amazon.com/). Once you login with your Amazon credentials, click on your account name and go to "My Security Credentials". Once you have a key id and secret key, you need to create the credentials files as used by [awscli](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html). You can either install awscli and run `aws configure`, else create:

```
~/.aws/default:
[default]
output = JSON
region = us-east

~/.aws/config:
[default]
aws_access_key_id = XXXXXXXXXXXX
aws_secret_access_key = xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Change the region value to the [AWS region](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html) you want to use, and replace the "XXX" values with your own key id and secret key values. These files are stored in a different [location](http://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html#config-settings-and-precedence) on Windows.

### Create an S3 bucket

S3 organizes files by bucket. Every bucket has URI-like name, which is unique across AWS. So if you're going to host a website on S3, you'll need to create a bucket for the website. This can be done via the AWS [web interface](https://aws.amazon.com/), the command-line [app](http://docs.aws.amazon.com/cli/latest/reference/s3/mb.html) or with Paws:

```perl
use Paws;
my $s3 = Paws->service('S3', region => 'us-east-1');
$s3->CreateBucket(Bucket => 'mystaticwebsite.com', ACL => 'public-read');
```
The `ACL` argument specifies that the bucket can be read publicly, but not edited, which makes sense for website files. At some point, you'll need to enable the "static web hosting" [option](https://console.aws.amazon.com/s3/buckets/) for the bucket, but that's not necessary to upload files to it.

### Upload files to S3

S3 files are stored as objects in buckets. Every file has a key, which is similar to the filename. I've developed a [script](https://github.com/dnmfarrell/Paws-tools/blob/master/s3-upload) called `s3-upload` which uses Paws to upload files to S3 buckets. It uses [Getopt::Long]({{<mcpan "Getopt::Long" >}}) to parse command line options. It requires `--bucket` for the S3 bucket name, `--region` for the AWS region, and `--files` for the directory filepath:

```perl
#!/usr/bin/env perl
use Getopt::Long 'GetOptions';
use Paws;
use Path::Tiny 'path';

GetOptions(
  'bucket=s'     => \my $BUCKET,
  'files=s'      => \my $BASEPATH,
  'region=s'     => \my $REGION,
  'delete-stale' => \my $DELETE_STALE,
) or die 'unrecognized arguments';

die 'must provide --bucket --region --files'
  unless $BUCKET && $REGION && $BASEPATH;

die "directory $BASEPATH not found" unless -d $BASEPATH;

my $s3             = Paws->service('S3', region => $REGION);
my $remote_objects = get_remote_objects($s3);
my $local_objects  = upload($s3, $remote_objects);

delete_stale_objects($s3, $remote_objects, $local_objects) if $DELETE_STALE;
```

I've omitted the subroutine definitions for brevity (see the [source](https://github.com/dnmfarrell/Paws-tools/blob/master/s3-upload) for details). The script begins by validating the input options, then creates an `$s3` object. It calls `get_remote_objects` which returns a hashref of keys (files) and their last modified time currently in the bucket. It passes this to `upload` which only uploads files that have been modified since being uploaded to S3 (you don't want to upload the entire website if only one file has changed). `upload` does many things, but essentially, it uses [PutObject]({{<mcpan "Paws::S3::PutObject" >}}) to upload files:

```perl
sub upload {
  ...
  $s3->PutObject(
    Bucket  => $BUCKET,
    Key     => $key,
    ACL     => 'public-read',
    Body    => $path->slurp_raw,
  );
  ...
}
```

Here `Key` is the filename and `Body` the raw bytes of the file. The `upload` subroutine also returns a hashref of local keys and their last modified time. Optionally, the script can call `delete_stale_objects` which deletes files from S3 which do not exist in the local tree.

The script can be run like this:

```
$ ./s3-upload --bucket mystaticwebsite.com --region us-east-1 --files mywebsite/static --delete-stale
static/index.html
static/about.html
static/news.html
static/products.html
static/css/styles.css
```

The script will print any files uploaded to STDOUT and all other output to STDERR. The intention is to make it possible to pipe the filenames uploaded to other programs. A useful one might be a Cloudfront script which invalidates the cache for any files uploaded.

### More features

Whilst the above script does the job, there are some features missing that are useful for static websites. Firstly, you might want to specify the MIME type of the files being uploaded. This is so when browsers fetch the files, S3 responds with the correct content type [header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Type). Otherwise, HTML files may not be displayed as websites, images may be downloaded instead of displayed, and so on. I use [Media::Type::Simple]({{<mcpan "Media::Type::Simple" >}}) for this:

```perl
use Media::Type::Simple;
...
# setup mime types, add missing
open my $mime_types, '<', $MIME_TYPES or die "Can't find $MIME_TYPES $!";
my $media = Media::Type::Simple->new($mime_types);
$media->add_type('application/font-woff2', 'woff2');
...
my @ext  = $path =~ /\.(\w+)$/;
my $mime = eval { @ext ? $media->type_from_ext($ext[0]) : undef };
print STDERR $@ if $@;
```

I've uploaded a copy of `mime.types` to the [repo](https://github.com/dnmfarrell/Paws-tools/blob/master/mime.types), and added a `--mime-types` option for the filepath to a mime.types file (defaulting to `/etc/mime.types`). Also not all media types are defined, so the code adds a custom definition for `woff2`. The mime type is passed to `PutObject` when a file is uploaded.

Other useful options supported by the script:

* `--strip`- it seems cleaner to visit: `/home` than `/home.html`. The `--strip` option can be used to specify any extensions to strip from filenames
* `--max-age` - set a cache control header to have browsers cache files instead of downloading them on every page
* `--force` - override the default behavior and upload all files, regardless of whether they already exist in the S3 bucket

These options can be used like this:

```
$ ./s3-upload --bucket mystaticwebsite.com --region us-east-1 --files mywebsite/static --delete-stale --mime-types mime.types --strip html --max-age 31536000 --force
static/index.html
static/about.html
static/news.html
static/products.html
static/css/styles.css
```

The script [source](https://github.com/dnmfarrell/Paws-tools/blob/master/s3-upload) is on GitHub. If you need help configuring a static website for AWS, Amazon have provided a good [guide](http://docs.aws.amazon.com/gettingstarted/latest/swh/website-hosting-intro.html).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
