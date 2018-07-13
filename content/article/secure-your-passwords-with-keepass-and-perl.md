{
   "authors" : [
      "david-farrell"
   ],
   "description" : "File::KeePass makes it easy to work with KeePass database files",
   "slug" : "79/2014/3/24/Secure-your-passwords-with-KeePass-and-Perl",
   "image" : "/images/79/ECA2D780-FF2E-11E3-9F75-5C05A68B9E16.jpeg",
   "categories" : "apps",
   "date" : "2014-03-24T13:00:38",
   "draft" : false,
   "tags" : [
      "database",
      "module",
      "password_manager"
   ],
   "thumbnail" : "/images/79/thumb_ECA2D780-FF2E-11E3-9F75-5C05A68B9E16.jpeg",
   "title" : "Secure your passwords with KeePass and Perl"
}


*These days password managers are an [essential](http://arstechnica.com/information-technology/2013/06/the-secret-to-online-safety-lies-random-characters-and-a-password-manager/) part of online security. The module File::KeePass provides an easy-to-use Perl API for the KeePass password manager and opens up a world-of-possibilities for programmatically creating, reading and updating passwords securely.*

### Requirements

You'll need to install [File::KeePass]({{<mcpan "File::KeePass" >}}). The CPAN testers [results](http://matrix.cpantesters.org/?dist=File-KeePass+2.03) show that it runs on all modern Perls and many platforms including Windows. To install the module with CPAN, fire up the terminal and enter:

```perl
$ cpan File::KeePass
```

You may want to install [KeePassX](https://www.keepassx.org/), an open source implementation of KeePass to get a GUI. I've used it on both Windows and Linux and it works great.

### Creating KeePass Databases

The KeePass password manager stores all passwords in an encrypted database file. All username/password entries are stored in collections of entries called "groups". File::KeePass provides for methods creating all of these items:

```perl
use File::KeePass;

my $kp_db = File::KeePass->new;

my $app_group = $kp_db->add_group({ title => 'Apps' });

$kp_db->add_entry({ title     => 'email',
                    username  => 'system',
                    password  => 'mumstheword',
                    group     => $app_group->{gid},
                  });

$kp_db->save_db('MyAppDetails.kdb', 'itsasecret');
```

In the code above we start by instantiating a new File::KeePass object. The "add\_group" method adds a new group called "Apps" to the object. We then add an entry to the "Apps" group. The entry contains the username/password credentials that we want to store securely. Finally the "save\_db" method saves the KeePass database to "MyAppDetails.kdb" (the extension is important) with a master password of "itsasecret" - in reality you would want to use a stronger password than this.

Save the code as "create\_keepass\_db.pl" and run it on the command line with this command:

```perl
$ perl create_keepass_db.pl
```

If you have KeePassX or KeePass installed, you can open the newly-created "MyAppDetails.kdb" file. When you do, you'll be asked for the master password that we set:"

![keepassx login](/images/79/keepassx_login.png)

Once you've entered the master password, KeePassX will show the main window, which lists the groups and entries in the database file. You can see the "Apps" group on the left and the "email" entry that was created listed in the main window.

![keepassx main screen](/images/79/keepassx_group_entry_added.png)

### Reading KeePass databases

Instead of using a GUI like KeePass or KeePassX, you can read the contents of the database file using File::KeePass:

```perl
use File::KeePass;

my $kp_db = File::KeePass->new;
$kp_db->load_db('MyAppDetails.kdb', 'itsasecret');
my $groups = $kp_db->groups;
```

Here we opened our newly-created KeePass database file using the "load\_db" method. The "groups" method returns an arrayref of groups. Each group is a hashref that also contains an arrayref of entries. Printing $groups with Data::Dumper, we can see this more clearly:"

```perl
$VAR1 = [
          {
            'icon' => 0,
            'created' => '2014-03-24 08:28:44',
            'level' => 0,
            'entries' => [
                           {
                             'icon' => 0,
                             'modified' => '2014-03-24 08:28:44',
                             'username' => 'system',
                             'created' => '2014-03-24 08:28:44',
                             'comment' => '',
                             'url' => '',
                             'id' => 'E31rvRS5mqK37mak',
                             'title' => 'email',
                             'accessed' => '2014-03-24 08:28:44',
                             'expires' => '2999-12-31 23:23:59'
                           }
                         ],
            'title' => 'Apps',
            'id' => 2450784255,
            'accessed' => '2014-03-24 08:28:44',
            'expires' => '2999-12-31 23:23:59',
            'modified' => '2014-03-24 08:28:44'
          }
        ];
```

### Searching and updating a KeePass database

File::KeePass provides methods for searching for entries. In order to update an entry, we have to retrieve it, update it, and then save the database file. Because entries are just hashrefs, this is easy:

```perl
use File::KeePass;

my $kp_db = File::KeePass->new;
$kp_db->load_db('MyAppDetails.kdb', 'itsasecret');
$kp_db->unlock; # enable changes

my $entry = $kp_db->find_entry({ title => 'email' }); 
$entry->{password} = 'mumsnottheword';

$kp_db->save_db('MyAppDetails.kdb', 'itsasecret');
```

In the code above we opened the database file, and used the "find\_entry" method to search for our email entry. We then updated the password for the entry, and re-saved the database file. File::KeePass provides many additional methods for searching and updating groups and entries.

### Conclusion

File::KeePass has a simple API that works great and comes with comprehensive [documentation]({{<mcpan "File::KeePass" >}}). I would recommend using the ".kdb" format as File::KeePass has [open issues](https://rt.cpan.org/Public/Dist/Display.html?Name=File-KeePass) for the ".kdbx" format.

Enjoyed this article? Help us out and [retweet](https://twitter.com/intent/tweet?original_referer=http%3A%2F%2Fperltricks.com%2Farticle%2F79%2F2014%2F3%2F24%2FSecure-your-passwords-with-KeePass-and-Perl&text=Secure+your+passwords+with+KeePass+and+Perl&tw_p=tweetbutton&url=http%3A%2F%2Fperltricks.com%2Farticle%2F79%2F2014%2F3%2F24%2FSecure-your-passwords-with-KeePass-and-Perl&via=perltricks) it!

Cover image © [DanielSTL](http://www.flickr.com/photos/danielsphotography/466435567/sizes/o/)

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
