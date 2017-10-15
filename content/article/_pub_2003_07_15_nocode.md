{
   "date" : "2003-07-15T00:00:00-08:00",
   "thumbnail" : "/images/_pub_2003_07_15_nocode/111-nocode.gif",
   "image" : null,
   "title" : "How to Avoid Writing Code",
   "authors" : [
      "kake-pugh"
   ],
   "categories" : "web",
   "slug" : "/pub/2003/07/15/nocode.html",
   "tags" : [
      "template-database-sql-dbi"
   ],
   "description" : " One of the most boring programming tasks in the world has to be pulling data out of a database and displaying it on a web site. Yet it's also one of the most ubiquitous. Perl programmers being lazy, there...",
   "draft" : null
}



One of the most boring programming tasks in the world has to be pulling data out of a database and displaying it on a web site. Yet it's also one of the most ubiquitous. Perl programmers being lazy, there are tools to help make boring programming tasks less painful, and two of these tools, `Class::DBI` and the `Template` Toolkit, create a whole which is far more drudgery-destroying than its parts.

Both these tools can do more complicated stuff than that described in this article, but my aim is to motivate people who may not have tried them out to give them a go and see how much work they can save you for even simple tasks.

I've assumed that you know the basics of designing a database--why you have several tables and `JOIN` them rather than putting everything in the same table. I've also assumed that you're not allergic to reading documentation, so I'm going to spend more space on saying *why* I use particular features of the modules rather than explaining exactly *how* they work.

### Synergy

The reason that `Class::DBI` and the `Template` Toolkit work so well together is simple. `Template` Toolkit templates can call methods on objects passed to them--so there's no need to explicitly pull every column out of the database before you process the template--and `Class::DBI` saves you the bother of writing methods to retrieve database columns. You're essentially going straight from the database to HTML with only a very small amount of Perl in the middle.

Suppose you're writing a web application to store details of books and their authors, and reviews of the books by users of the site. You'd like to have a page that displays all the books in your database and, for each book, offers links to all the reviews already written. With suitably set-up classes you can write a couple of lines of Perl:

      #!/usr/bin/perl -w
      use strict;

      use Bookworms::Book;
      use Bookworms::Template;

      my @books = Bookworms::Book->retrieve_all;
      @books = sort { $a->title cmp $b->title } @books;
      print Bookworms::Template->output( template => "book_list.tt",
                                         vars     => { books => \@books } );

hand your designer a simple template to pretty up:

      [% page_title = "List all books" %]
      [% INCLUDE header.tt %]

        <ul>
          [% FOREACH book = books %]
            <li>[% book.title %] ([% book.author.name %])
                [% FOREACH review = book.reviews %]
                  (<a href="review.cgi?review=[% review.uid %]">Read review 
                  by [% review.reviewer.name %]</a>)
                [% END %]
            </li>
          [% END %]
        </ul>

      [% INCLUDE footer.tt %]

and your task is done. You don't have to explicitly select the reviews; you don't have to then cross-reference to another table to find out the reviewer's name; you don't have to mess with HERE-documents or fill your program with print statements. You hardly have to do anything.

Except of course, write the `Bookworm::*` classes in the first place, but that's easy.

### Simple, Small Classes

For convenience, we write a class containing all the SQL needed to set up our database schema. This is very useful for running tests as well as for deploying a new install of the application.

      package Bookworm::Setup;
      use strict;
      use DBI;

      # Hash for table creation SQL - keys are the names of the tables,
      # values are SQL statements to create the corresponding tables.
      my %sql = (
          author => qq {
              CREATE TABLE author (
                  uid   int(10) unsigned NOT NULL auto_increment,
                  name  varchar(200),
                  PRIMARY KEY (uid)
              )
          },
          book => qq{
              CREATE TABLE book (
                  uid           int(10) unsigned NOT NULL auto_increment,
                  title         varchar(200),
                  first_name    varchar(200),
                  author        int(10) unsigned, # references author.uid
                  PRIMARY KEY (uid)
              )
          },
          review => qq{
              CREATE TABLE review (
                  uid       int(10) unsigned NOT NULL auto_increment,
                  book      int(10) unsigned, # references book.uid
                  reviewer  int(10) unsigned, # references reviewer.uid
                  PRIMARY KEY (uid)
              )
          },
          reviewer => qq{
              CREATE TABLE review (
                  uid   int(10) unsigned NOT NULL auto_increment,
                  name  varchar(200),
                  PRIMARY KEY (uid)
              )
          }
      );

This class has a single method that sets up a database conforming to the schema above. Here's the rendered POD for it; the implementation is pretty simple. The "force\_clear" option is very useful for testing.
        setup_db( dbname      => 'bookworms',
                  dbuser      => 'username',
                  dbpass      => 'password',
                  force_clear => 0            # optional, defaults to 0
                );

      Sets up the tables. Unless "force_clear" is supplied and set to a
      true value, any existing tables with the same names as we want to
      create will be left alone, whether or not they have the right
      columns etc. If "force_clear" is true, then any tables that are "in
      the way" will be removed. _Note that this option will nuke all your
      existing data._

      The database user "dbuser" must be able to create and drop tables in
      the database "dbname".

      Croaks on error, returns true if all OK.

Now, another class to wrap around the `Template` Toolkit; we want to grab global variables like the name of the site, and so on, from a config class. (There are plenty of config modules on CPAN; you're bound to find one you like. I quite like `Config::Tiny`; other people swear by `AppConfig`--and since the latter is a prerequisite of the `Template` Toolkit, you'll have it installed already.) `Bookworms::Config` is just a little wrapper class around `Config::Tiny`, so if I change to a different config method later I don't have to rewrite lots of code.

      package Bookworms::Template;
      use strict;
      use Bookworms::Config;
      use CGI;
      use Template;

      # We have one method, which returns everything you need to send to
      # STDOUT, including the Content-Type: header.

      sub output {
          my ($class, %args) = @_;

          my $config = Bookworms::Config->new;
          my $template_path = $config->get_var( "template_path" );
          my $tt = Template->new( { INCLUDE_PATH => $template_path } );

          my $tt_vars = $args{vars} || {};
          $tt_vars->{site_name} = $config->get_var( "site_name" );

          my $header = CGI::header;

          my $output;
          $tt->process( $args{template}, $tt_vars, \$output)
              or croak $tt->error;
          return $header . $output;
      }

Now we can start writing the classes to manage our database tables. Here's the class to handle book objects:

      package Bookworms::Book;
      use base 'Bookworms::DBI';
      use strict;

      __PACKAGE__->set_up_table( "book" );
      __PACKAGE__->has_a( author => "Bookworms::Author" );
      __PACKAGE__->has_many( "reviews",
                             "Bookworms::Review" => "book" );

      1;

Yes, that's all you need. This simple class, by its ultimate inheritance from `Class::DBI`, has auto-created constructors and accessors for every aspect of a book as defined in our database schema. And moreover, because we've told it (using `has_a`) that the `author` column in the `book` table is actually a foreign key for the primary key of the table modeled by `Bookworms::Author`, when we use the `->author` accessor we actually get a `Bookworms::Author` object, which we can then call methods on:

      my $hobbit = Bookworms::Book->search( title => "The Hobbit" );
      print "The Hobbit was written by " . $hobbit->author->name;

There are a couple of supporting classes that we need to write, but they're not complicated either.

First a base class, as with all `Class::DBI` applications, to set the database details:

      package Bookworms::DBI;
      use base "Class::DBI::mysql";

      __PACKAGE__->set_db( "Main", "dbi:mysql:bookworms", 
        "username", "password" );

      1;

Our base class inherits from `Class::DBI::mysql` instead of plain `Class::DBI`, so we can save ourselves the trouble of directly specifying the table columns for each of our database tables--the database-specific base classes will auto-create a `set_up_table` method to handle all this for you.

At the time of writing, base classes for MySQL, PostgreSQL, Oracle, and SQLite are available on CPAN. There's also `Class::DBI::BaseDSN`, which allows you to specify the database type at runtime.

We'll also want a class for each of the author, review, and reviewer tables, but these are even simpler than the `Book` class. For example, the author class could be as trivial as:

      package Bookworms::Author;
      use base 'Bookworms::DBI';
      use strict;

      __PACKAGE__->set_up_table( "author" );

      1;

If we wanted to be able to access all the books by a given author, we could add the single line

      __PACKAGE__->has_many( "books",
                             "Bookworms::Book" => "author" );

and an accessor to return an array of `Bookworms::Book` objects would be automatically created, to be used like so:

      my $author = Bookworms::Author->search( name => "J K Rowling" );
      my @books = $author->books;

Or indeed:

      <h1>[% author.name %]</h1>

      <ul>
        [% FOREACH book = author.books %]
          <li>[% book.title %]</li>
        [% END %]
      </ul>

Simple, small, almost trivial classes, taking a minute or two each to write.

### What Does This Get Me?

The immediate benefits of all this are obvious:

-   You don't have to mess about with HTML, since the very simplistic use of the `Template` Toolkit means that templates are comprehensible to competent web designers.
-   You don't have to maintain classes full of copy-and-paste code, since the repetitive programming tasks like creating constructors and simple accessors are done for you.

A large hidden benefit is testing. Since the actual CGI scripts--which can be a pain to test--are so simple, you can concentrate most of your energy on testing the underlying modules.

It's probably worth writing a couple of simple tests to make sure that you've set up your classes the way you intended to, particularly in your first couple of forays into `Class::DBI`.

      use Test::More tests => 5;
      use strict;

      use_ok( "Bookworms::Author" );
      use_ok( "Bookworms::Book" );
      my $author = Bookworms::Author->create({ name => "Isaac Asimov" });
      isa_ok( $author, "Bookworms::Author" );
      my $book = Bookworms::Book->create({ title  => "Foundation",
                                           author => $author });
      isa_ok( $book, "Bookworms::Book" );
      is( $book->author->name, "Isaac Asimov", "right author" );

However, the big testing win with this technique of separating out the heavy lifting from the CGI scripts into modules is when you'd like to add something more complicated. Say, for example, fuzzy matching. It's well known that people can't spell, and you'd like someone typing in "Isaac Assimov" to find the author they're looking for. So, let's process the author names as we create the author objects, and store some kind of canonicalized form in the database.

`Class::DBI` allows you to define "triggers"--methods that are called at given points during the lifetime of an object. We'll want to use an `after_create` trigger, which is called after an object has been created and stored in the database. We use this in preference to a `before_create` trigger, since we want to know the uid of the object, and this is only created (via the auto\_increment primary key) once the object has been written to the database.

We use `Search::InvertedIndex` to store the canonicalized names, for quick access. We start with a very simple canonicalization--stripping out vowels and collapsing repeated letters. (I've found that this can pick up about half of name misspellings found in the wild, which is pretty impressive.)

We'll write a couple of tests before we move on to code. Here are some that check that our class is doing what we told it to--removing vowels and collapsing repeated consonants.

      use Test::More tests => 2;
      use strict;

      use Bookworms::Author;

      my $author = Bookworms::Author->create({ name => "Isaac Asimov" });
      my @matches = Bookworms::Author->fuzzy_match( name => "asemov" );
      is_deeply( \@matches, [ $author ], 
        "fuzzy matching catches wrong vowels" );
      @matches = Bookworms::Author->fuzzy_match( 
        name => "assimov" );
      is_deeply( \@matches, [ $author ], 
        "fuzzy matching catches repeated letters" );

We should also write some other tests to run our algorithms over various misspellings that we've captured from actual users, to give an idea of whether "what we told our class to do" is the right thing.

Here's the first addition to the `Bookworms::Author` class, to store the indexed data:

      use Search::InvertedIndex;

      my $database = Search::InvertedIndex::DB::Mysql->new(
                         -db_name    => "bookworms",
                         -username   => "username",
                         -password   => "password",
                         -hostname   => "",
                         -table_name => "sii_author",
                         -lock_mode  => "EX"
        ) or die "Couldn't set up db";

      my $map = Search::InvertedIndex->new( -database => $database )
        or die "Couldn't set up map";
      $map->add_group( -group => "author_name" );

      __PACKAGE__->add_trigger( after_create => sub {
          my $self = shift;
          my $update = Search::InvertedIndex::Update->new(
              -group => "author_name",
              -index => $self->uid,
              -data  => $self->name,
               -keys  => { map { $self->_canonicalise($_) => 1 }
                           split(/\s+/, $self->name)
                         }
              );
              $map->update( -update => $update );
          }
      } );

      sub _canonicalise {
          my ($class, $word) = @_;
          return "" unless $word;
          $word = lc($word);
          $word =~ s/[aeiou]//g;    # remove vowels
          $word =~ s/(\w)\1+/$1/eg; # collapse doubled 
                                    # (or tripled, etc) letters
          return $word;
      }

(We'll also want similar triggers for `after_update` and `after_delete`, in order that our indexing is kept up to date with our data.)

Then we can write the fuzzy\_matching method:

      sub fuzzy_match {
          my ($class, %args) = @_;
          return () unless $args{name};
          my @terms = map { $class->_canonicalise($_) => 1 }
                            split(/\s+/, $args{name});
          my @leaves;
          foreach my $term (@terms) {
              push @leaves, Search::InvertedIndex::Query::Leaf->new(
                  -key   => $term,
                  -group => "author_name" );
          }

          my $query = Search::InvertedIndex::Query->new( -logic => 'and',
                                                         -leafs => \@leaves );
          my $result = $map->search( -query => $query );

          my @matches;
          my $num_results = $result->number_of_index_entries || 0;
          if ( $num_results ) {
              for my $i ( 1 .. $num_results ) {
                  my ($index, $data) = $result->entry( -number => $i - 1 );
                  push @matches, $data;
              }
          }

          return @matches;
      }

(The matching method can be improved. I've found that neither `Text::Soundex` nor `Text::Metaphone` are much of an improvement over the simple approach already detailed, but `Text::DoubleMetaphone` is definitely worth plugging in, to catch misspellings such as Nicolas/Nicholas and Asimov/Azimof.)

There are plenty of other features that our little web application would benefit from, but I shall leave those as an exercise for the reader. I hope I've given you some insight into my current preferred web development techniques--and I'd love to see a finished `Bookworms` application if it does scratch anyone's itch.

### See Also

-   [`Class::DBI`](http://search.cpan.org/author/TMTM/Class-DBI/)
-   [The `Template` Toolkit](http://search.cpan.org/author/ABW/Template-Toolkit/)
-   [`Search::InvertedIndex`](http://search.cpan.org/author/SNOWHARE/Search-InvertedIndex/)
-   [`Text::DoubleMetaphone`](http://search.cpan.org/author/MAURICE/Text-DoubleMetaphone/)

