{
   "description" : " Why Gates? In a perfect world we wouldn't do things we should not. However the world is not like this; people do forbidden things sometimes. This also applies to computer systems used by more than one person. Almost everyone...",
   "draft" : null,
   "tags" : [
      "access-control",
      "privacy",
      "security",
      "software-development"
   ],
   "slug" : "/pub/2008/02/13/elements-of-access-control.html",
   "categories" : "Security",
   "title" : "Elements of Access Control",
   "authors" : [
      "vladi-belperchinov-shabanski"
   ],
   "image" : null,
   "thumbnail" : null,
   "date" : "2008-02-13T00:00:00-08:00"
}



### Why Gates?

In a perfect world we wouldn't do things we should not. However the world is not like this; people do forbidden things sometimes. This also applies to computer systems used by more than one person. Almost everyone has tried to read someone else's email, view accounting department salary reports, or something else, or access otherwise hidden data.

I know *you* have never done this, but many people have.

### In Construction

The simplest way to allow or forbid a user account to do something is to check if the account is in a list of permitted accounts somewhere. If you assume that everything is forbidden unless explicitly allowed, the access function can be as simple as:

      # access_check() return 1 or undef
      sub access_check
      {
        my $user_id     = shift;
        my @allow_users = @_;

        my %quick_allow = map { $_ => 1 } @allow_users;

        return $quick_allow{ $user_id };
      }

      my @allowed = ( 11, 12, 23, 45 );

      print "User 23 allowed\n" if access_check( 23, @allowed );
      print "User 13 allowed\n" if access_check( 13, @allowed );
      print "User 99 allowed\n" if access_check( 99, @allowed );

      # only "User 23 allowed" will be printed

Usually access control can be almost as simple as this function. Using user IDs for access control is simple, but tends to be hard to maintain. The problem appears with systems with many users or with public systems where new users may be created at any point. Access lists may become very large for each operation, which needs access controls.

One solution to this problem is *access groups*. Each user may be a member of several groups. The access check will pass if the user is a member of a group with permission for the required operation. This middle level in the access check isolates users from the access check directly. It also helps the system's design--you can associate preset access groups with all controlled operations at their point of creation. Subsequently created users only need to be attached to one or more of those groups:

      # mimic real system environment:
      # %ALL_USER_GROUPS represents "storage" that contains all
      # groups that each user is attached to
      my %ALL_USER_GROUPS = (
                        23 => [ qw( g1  g4 ) ],
                        13 => [ qw( g3  g5 ) ],
                        );
      # user 23 is in groups g1 and g4
      # user 13 -- in g3 and g5

      # return list of user's groups. read data from storage or
      # from %ALL_USER_GROUPS in this example
      sub get_user_groups
      {
        my $user_id     = shift;

        return @{ $ALL_USER_GROUPS{ $user_id } || [] };
      }

      # access_check_grp() return 1 or 0
      sub access_check_grp
      {
        my $user_id     = shift;
        my @allow_users = @_;

        my %quick_allow = map { $_ => 1 } @allow_users;

        my @user_groups = get_user_groups( $user_id );

        for my $group ( @user_groups )
        {
          # user groups is listed, allow
          return 1 if $quick_allow{ $group };
        }

        # user group not found, deny
        return 0;
      }

      # this groups list is static and will not be altered
      # when users are added or removed from the system
      my @allowed = qw( g1  g2  g7  g9 );

      print "User 23 allowed\n" if access_check_grp( 23, @allowed );
      print "User 13 allowed\n" if access_check_grp( 13, @allowed );
      print "User 99 allowed\n" if access_check_grp( 99, @allowed );

      # only "User 23 allowed" will be printed

### Storage

Probably the most popular storage for system data nowadays is the SQL database. Here is a simple example of how to store users, groups, and mapping between them. Three tables are required:

      SQL CREATE statements:

      create table user  ( id integer primary key, name char(64), pass char(64) );
      create table group ( id integer primary key, name char(64) );
      create table map   ( user integer, group integer );

      TABLE USER:

       Column |     Type      | Modifiers
      --------+---------------+-----------
       id     | integer       | not null
       name   | character(64) |
       pass   | character(64) |

      TABLE GROUP:

       Column |     Type      | Modifiers
      --------+---------------+-----------
       id     | integer       | not null
       name   | character(64) |

      TABLE MAP:

       Column |  Type   | Modifiers
      --------+---------+-----------
       user   | integer |
       group  | integer |

Let's fill those tables with some data:

      letme=# select id, name from user;
       id |       name
      ----+------------------
        1 | Damian
        2 | Clive
        3 | Lana
      (3 rows)

      letme=# select * from group;
       id |       name
      ----+------------------
        1 | Admin
        2 | Users
        3 | Moderators
      (3 rows)

      letme=# select * from map;
       user | group
      -----+-----
         1 |   1
         1 |   2
         3 |   2
         3 |   3
         2 |   2
      (4 rows)

Users in this example are attached to those groups:

      Damian: Users, Admin
      Clive:  Users
      Lana:   Users, Moderators

### Run-Time

Applications apply access control after user login. You can combine it with the login procedure--for example to allow only specific group of users to connect on weekends. Even so, the access check occurs only after the login succeeds, that is, when the username and password are correct.

A simple approach for loading required access info is:

-   Login, check username and password
-   For unsuccessful login, deny access, print message, etc.
-   For successful login, load group list for the user from database
-   Check for required group(s) for login

    This may deny login, print a message, or continue.

-   User logged in, continue

    All access checks for operations happen after this point.

The run-time storage for a user's groups can be simple hash. It can be either global or inside the user session object, depending on your system design. I've used a global hash here for simplicity of the examples, but if you copy and paste this code, remember that it is *mandatory* for you to clear and recreate this global hash for every request right after the login or user session changes! You can also use some kind of session object to drop all user data at the end of the session, but this is just an option, not the only correct or possible way.

(Also, a truly robust system would store a well-hashed version of the password, not the literal password, but that's a story for a different article.)

      #!/usr/bin/perl
      use strict;
      use DBI;
      use Data::Dumper;

      our $USER_NAME;
      our $USER_ID;
      our %USER_GROUPS;

      my $DBH = DBI->connect( "dbi:Pg:dbname=letme", "postgres", "",
          { AutoCommit => 0 } );

      # this is just an example!
      # username and password acquiring depends on the specific application
      user_login( 'Damian', 'secret4' );

      print "User logged in: $USER_NAME\n";
      print "User id:        $USER_ID\n";
      print "User groups:    " . join( ', ', keys %USER_GROUPS ) . "\n";

      sub user_login
      {
        my $user_name = shift;
        my $user_pass = shift;

        $USER_NAME   = undef;
        $USER_ID     = undef;
        %USER_GROUPS = ();

        # both name and password are required
        die "Empty user name"     if $user_name eq '';
        die "Empty user password" if $user_pass eq '';

        eval
        {
          my $ar = $DBH->selectcol_arrayref(
              'SELECT ID FROM USER WHERE NAME = ? AND PASS = ?',
                                            {},
                                            $user_name, $user_pass );

          $USER_ID   = shift @$ar;

          die "Wrong user name or password" unless $USER_ID > 0;

          $USER_NAME = $user_name;

          # loading groups
          my $ar = $DBH->selectcol_arrayref( 'SELECT GROUP FROM MAP WHERE USER = ?',
                                            {},
                                            $USER_ID );

          %USER_GROUPS = map { $_ => 1 } @$ar;
        };
        if( $@ )
        {
          # something failed, it is important to clear user data here
          $USER_NAME   = undef;
          $USER_ID     = undef;
          %USER_GROUPS = ();

          # propagate error
          die $@;
        }
      }

If Damian's password is correct, this code will print:

      User logged in: Damian
      User id:        1
      User groups:    1, 2

The group access check function now is even simpler:

      sub check_access
      {
        my $group = shift;
        return 0 unless $group > 0;
        return $USER_GROUPS{ $group };
      }

Sample code for an access check after login will be something like:

      sub edit_data
      {
        # require user to be in group 1 (admin) to edit data...
        die "Access denied" unless check_access( 1 );

        # user allowed, group 1 check successful
        ...
      }

or

      if( check_access( 1 ) )
      {
        # user ok
      }
      else
      {
        # access denied
      }

### Access Instructions

The next problem is how to define which groups can perform specific operations. Where this information is static (most cases), you can store group lists in configuration (text) files:

      LOGIN: 2
      EDIT:  1

That is, the EDIT operation needs group 1 (admin) and LOGIN needs group 2 (all users).

Another example is to allow only administrators to log in during weekends:

      # all users for mon-fri
      LOGIN_WEEKDAYS: 2

      # only admin for sat-sun
      LOGIN_WEEKENDS: 1

Administrators will be in both groups (1, 2), so they will be able to log in anytime. All regular users cannot login on weekends.

This group list includes a moderators group. It could be useful to allow moderators do their job on weekends as well, implying an `OR` operation:

      # only admin or moderators for sat-sun
      LOGIN_WEEKENDS: 1, 3

This named set of groups is a *policy*.

For now, there's only one level in the policy and an `OR` operation between groups in a list. Real-world policies may be more complex. However there is no need to overdesign this. Even large systems may work with just one more level. Here's an `AND` operation:

      LOGIN_WEEKENDS: 1+3, 4, 1+5+9

This policy will match (allowing login on weekend days) only for users in the following groups:

         1 AND 3
      OR 4
      OR 1 AND 5 AND 9

The login procedure must match the `LOGIN_WEEKENDS` policy before allowing user to continue with other operations. Thus, you need a procedure for reading policy configuration files:

      our %ACCESS_POLICY;

      sub read_access_config
      {
        my $fn = shift; # config file name

        open( my $f, $fn );
        while( <$f> )
        {
          chomp;
          next unless /\S/; # skip whitespace
          next if  /^[;#]/; # skip comments

          die "Syntax error: $_\n" unless /^\s*(\S+?):\s*(.+)$/;
          my $n = uc $1; # policy name: LOGIN_WEEKENDS
          my $v =    $2; # groups lsit: 1+3, 4, 1+5+9

          # return list of lists:
          # outer list uses comma separator, inner lists use plus sign separator
          $ACCESS_POLICY{ $n } = access_policy_parse( $v );
        }
        close( $f );
      }

      sub access_policy_parse
      {
        my $policy = shift;
        return [ map { [ split /[\s\+]+/ ] } split /[\s,]+/, $policy ];
      }

For the `LOGIN_WEEKENDS` policy, the resulting value in `%ACCESS_POLICY` will be:

      $ACCESS_POLICY{ 'LOGIN_WEEKENDS' } =>

                    [
                      [ '1', '3' ],
                      [ '4' ],
                      [ '1', '5', '9' ]
                    ];

To match this policy, a user must be in every groups listed in any of the inner lists:

      sub check_policy
      {
        my $policy = shift;

        my $out_arr = $ACCESS_POLICY{ $policy };
        die "Invalid policy name; $policy\n" unless $out_arr;

        return check_policy_tree( $out_arr );
      }

      sub check_policy_tree
      {
        my $out_arr = shift;

        for my $in_arr ( @$out_arr )
        {

          my $c = 0; # matching groups count
          for my $group ( @$in_arr )
          {
            $c++ if $USER_GROUPS{ $group };
          }

          # matching groups is equal to all groups count in this list
          # policy match!
          return 1 if $c == @$in_arr;
        }

        # if this code is reached then policy didn't match
        return 0;
      }

The example cases will become:

      sub user_login
      {
          # login checks here
          ...

          # login ok, check weekday policy
          my $wday = (localtime())[6];

          my $policy;
          if( $wday == 0 or $wday == 6 )
          {
            $policy = 'LOGIN_WEEKEND';
          }
          else
          {
            $policy = 'LOGIN_WEEKDAY';
          }

          die "Login denied" unless check_policy( $policy );
      }

      sub edit_data
      {
        # require user to be in group 1 (admin) to edit data...
        die "Access denied" unless check_policy( 'EDIT' );

        # user allowed, 'EDIT' policy match
        ...
      }

Now you have all the parts of a working access control scheme:

-   Policy configuration syntax
-   Policy parser
-   User group storage and mapping
-   User group loading
-   Policy match function

This scheme may seem complete, but it lacks one thing.

### Data Fences

In a multiuser system there is always some kind of ownership on the data stored in the database. This means that each user must see only those parts of the data that his user groups own.

This ownership problem solution is separate from the policy scheme. Each row must have one or more fields filled with groups that have access to the data. Any SQL statements for reading data must also check for this field:

      my $rg  = join ',', grep { $USER_GROUPS{ $_ } } keys %USER_GROUPS;
      my $ug  = join ',', grep { $USER_GROUPS{ $_ } } keys %USER_GROUPS;
      my $sql = "SELECT * FROM TABLE_NAME
                 WHERE READ_GROUP IN ( $rg ) AND UPDATE_GROUP IN ( $ug )";

The result set will contain only rows with read and update groups inside the current user's group set. Sometimes you may need all of rows with the same read group for display, even though some of those rows have update restrictions the user does not meet. This case will use only the `READ_GROUP` field for select and will cut off users when they try to update the record without permission:

      my $rg  = join ',', grep { $USER_GROUPS{ $_ } } keys %USER_GROUPS;
      my $sql = "SELECT * FROM TABLE_NAME WHERE READ_GROUP IN ( $rg )";

      $sth = $dbh->prepare( $sql );
      $sth->execute();
      $hr = $sth->fetchrow_hashref();

      die "Edit access denied" unless check_access( $hr->{ 'UPDATE_GROUP' } );

When access checks are explicitly after `SELECT` statements it is possible to store full policy strings inside `CHAR` fields:

      $hr = $sth->fetchrow_hashref();

      die "Edit access denied" unless check_policy_record( $hr, 'UPDATE_GROUP' );

      sub check_policy_record
      {
          my $hr     = shift; # hash with record data
          my $field  = shift; # field containing policy string

          my $policy = $hr->{ $field };
          my $tree   = access_policy_parse( $policy );

          return check_policy_tree( $tree );
      }

### In the Middle of Nowhere

This access control scheme is simple and usable as described. It does not cover all possible cases of access control, but every application has its own unique needs. In certain cases, you can push some of these access controls to lower levels -- your database, for example -- depending on your needs. Good luck with building your own great wall!
