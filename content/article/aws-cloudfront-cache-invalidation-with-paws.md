{
   "image" : "/images/deploy-a-static-website-with-aws-s3-and-paws/aws-logo.png",
   "title" : "AWS Cloudfront cache invalidation with Paws",
   "tags" : [
      "aws",
      "cloudfront",
      "s3",
      "paws"
   ],
   "description" : "Another useful AWS script built with Paws",
   "date" : "2017-04-03T08:12:14",
   "categories" : "development",
   "draft" : false,
   "thumbnail" : "/images/deploy-a-static-website-with-aws-s3-and-paws/thumb_aws-logo.png",
   "authors" : [
      "david-farrell"
   ]
}

In [Deploy a static website with Paws]({{< relref "deploy-a-static-website-with-aws-s3-and-paws.md" >}}), I developed a simple script to upload files to AWS S3, using [Paws]({{<mcpan "Paws" >}}). In this article I'll describe a script to invalidate CloudFront caches: this can be used to force CloudFront to re-cache files which have changed on S3.

### AWS CloudFront

CloudFront is Amazon's Content Delivery Network service. It's used to cache local versions of files so that they can be delivered to requests faster; for example if you used S3 to host your website in Amazon's US East region, files on the website might load faster for East Coast customers than those on the West Coast. With a CDN like CloudFront however, copies of the website files can be saved all over the World, so that visitor's browsers fetch the website files from closer geographic locations, improving the website speed.

When cached website files are updated on S3, they need to be invalidated from the CloudFront cache. This forces CloudFront to fetch fresh copies of invalidated files.

### The code

Using CloudFront with Paws is pretty easy. For cache invalidation all you really need is a CloudFront distribution id, and a list of files to be invalidated. This is the script:

```perl
#!/usr/bin/env perl
use strict;
use warnings;
use Paws;
use Getopt::Long 'GetOptions';
use Time::HiRes 'gettimeofday';

GetOptions(
  'distribution-id=s' => \my $DISTRIBUTION_ID,
  'keys=s'            => \my @KEYS,
  'region=s'          => \my $REGION,
) or die 'unrecognized arguments';

die '--distribution-id and --region are required'
  unless $DISTRIBUTION_ID && $REGION;

# don't block on empty STDIN
STDIN->blocking(0);
@KEYS = map { chomp;"/$_" } @KEYS, <STDIN>;
die 'no objects to invalidate!' unless @KEYS;
printf "Invalidating cached keys: %s\n", join ', ', @KEYS;

my $cfront = Paws->service('CloudFront', region => $REGION);
my $uid    = join '-', gettimeofday();

$cfront->CreateInvalidation(
  DistributionId    => $DISTRIBUTION_ID,
  InvalidationBatch => {
      CallerReference => $uid,
      Paths           => {
        Quantity => scalar @KEYS,
        Items    => \@KEYS,
      }
  }
);
```

As before, I use [Getopt::Long]({{<mcpan "Getopt::Long" >}}) to process the command line options. The script requires a CloudFront distribution id and an AWS region string. The `--keys` switch is optional as the script also reads keys from `STDIN`. This snippet is curious:

```perl
# don't block on empty STDIN
STDIN->blocking(0);
@KEYS = map { chomp;"/$_" } @KEYS, <STDIN>;
```

It sets the `STDIN` filehandle to non-blocking mode. That way, if STDIN is empty when the script tries to read from it, it won't block. On the next line, `map` is used to prepend a slash to every key. This is required by CloudFront.

The script then creates a Paws CloudFront object, and the [Time::HiRes]({{<mcpan "Time::HiRes" >}}) `gettimeofday` function is used to calculate a cheap unique id (it returns the current epoch seconds and microseconds).

```perl
my $cfront = Paws->service('CloudFront', region => $REGION);
my $uid    = join '-', gettimeofday();
```

Finally, the script calls the `CreateInvalidation` method to send the data to AWS CloudFront:

```perl
$cfront->CreateInvalidation(
  DistributionId    => $DISTRIBUTION_ID,
  InvalidationBatch => {
      CallerReference => $uid,
      Paths           => {
        Quantity => scalar @KEYS,
        Items    => \@KEYS,
      }
  }
);
```

### Combining tools

The `s3-upload` script prints the keys it updated on STDOUT, and `cf-invalid` can read keys from STDIN. This makes for convenient chaining:

```
./s3-upload --files static --bucket example.com --region us-east-1 \
| ./cf-invalid --distribution-id e9d4922bd9120 --region us-east-1
```

And because the scripts use [Getopt::Long]({{< mcpan "Getopt::Long" >}}), the option names can be shortened:

```
./s3-upload -f static -b example.com -r us-east-1 | ./cf-invalid -d e9d4922bd9120 -r us-east-1
```

Alternatively, keys (filenames) can be specified as arguments:

```
./cf-invalid -d e9d4922bd9120 -r us-east-1 -k index.html -k about.html -k contact.html
```

Both scripts are available on [Github](https://github.com/dnmfarrell/Paws-tools).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
