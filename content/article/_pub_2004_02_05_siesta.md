{
   "title" : "Siesta Mailing List Manager",
   "slug" : "/pub/2004/02/05/siesta.html",
   "authors" : [
      "simon-wistow"
   ],
   "thumbnail" : "/images/_pub_2004_02_05_siesta/111-siesta.gif",
   "description" : " Sometime around July 2002 there was another of the seemingly inevitable and interminable threads about mailing list managers that pop up with regrettable frequency on the London Perl Mongers mailing list. It almost certainly contained references to Reply To...",
   "tags" : [
      "ezmlm",
      "mailing-list-manager",
      "mailman",
      "majordomo",
      "mlm",
      "perl-mail",
      "perl-mailing-list",
      "siesta"
   ],
   "image" : null,
   "categories" : "Email",
   "draft" : null,
   "date" : "2004-02-05T00:00:00-08:00"
}





Sometime around July 2002 there was another of the seemingly inevitable
and interminable threads about mailing list managers that pop up with
regrettable frequency on the London Perl Mongers mailing list.

It almost certainly contained references to Reply To munging, missing
features, and why we, a Perl mailing list, were running off Python
software, namely Mailman.

It was pointed out that even though Mailman has its limitations, it's
still arguably the best MLM out there. Of course, rational argument is
never something that gets in the way of a good thread and the debate
continued until Richard Clamp brought his own unique brand of pragmatism
to bear ...

     From: Richard Clamp <richardc@unixbeard.net>
     To: london.pm
     Subject: Re: for those who were looking for reason to better mailman in perl
     Date: Tue Jul 30 00:53:03 2002

     On Mon, Jul 29, 2002 at 03:06:44PM +0100, Nicholas Clark wrote:
     > Note that I have no intention of actually finding the time to 
     > actively help anyone re-write mailman (or majordomo) or anything 
     > else,

     I must say that I'm actively bored of this subject now.  I do, however,
     have a short proposal, which will hopefully lead to this recurring
     thread going the fsck away.

     To: Those that care
     From: Someone who doesn't
     
           Go form a sourceforge/savannah project, which will give you
           suboptimal mailing lists and a CVS repository.
     
           Let the world know you have done this so they can find you. 
     
           Write code and argue it out amongst yourselves.
     
           Let the world know when you get as far as being self-hosting.
     
     I'm sorry it's not a catchy 3-step plan, but try it out anyway.
     
     -- 
     Richard Clamp <richardc@unixbeard.net>

In response to which, precisely nothing happened. So it goes.

Until mid-August.

By some quirk of fate Greg McCarroll, Richard, and I were all
simultaneously 'resting' between jobs. Being fun-loving, crazy people we
decided that the most constructive use of time was to congregate at
Greg's, drink his booze, and watch Kevin Smith films.

Instead, we wrote a mailing list manager. Well, I say "instead", but we
managed to do the other stuff too, which explains the Jay-and-Bob-themed
test suite.

By the end of the day we had a whiteboard full of diagrams, a load of
code in a CVS repository, a self-hosting mailing list (with hard-coded
subscribers list, natch) and a sense of impending hangovers. Then
disaster struck. We all got jobs. And Siesta, as we'd decided to call
our nascent MLM, lay dormant.

For about 6 months she lay sleeping.

Then, for whatever reason, in about March the dev team, bolstered by a
couple of new member-cum-agitprops, began to churn out the patches
again. The project was re-housed from SourceForge to
siesta.unixbeard.net -- entailing a move to Subversion along the way.

The code was cleaned up, ported to `Class::DBI` and the `Email::*`
hierarchy of modules and various [yaks were
shaved](http://www.ai.mit.edu/lab/gsb/gsb-archive/gsb2000%2D02%2D11.html)
along the way, features were added, and a new `Template::Toolkit`-based
mail archiver (named Mariachi) was written.

The first release of Siesta went onto CPAN on July 24, just in time for
Richard to give his talk at YAPC Europe in Paris -- an event that
involved, somewhat inexplicably, several members of the audience
drinking a shot of tequila whenever the word 'Siesta' was mentioned and
then giving 50 Euros to YAS. Needless to say, much fun was had by all.

### [So Why Should I Use Siesta?]{#So_why_should_I_use_Siesta?}

Good question. Mailman, Majordomo, or a host of other MLMs usually
suffice.

On the other hand, competition is always good and Siesta was designed
from the ground up to be easily understandable and easily extensible.

In short, Siesta will almost certainly be able to do anything you want,
although you may have to write the plug-in in to do it.

Writing something to check whether an incoming email address is valid is
a matter of about 10 lines, most of which are boilerplate. A
SpamAssassin plug-in would be of similar length. Writing something that
required all mails to the list to be PGP-signed and encrypted with the
list's public key, and then which signed and encrypted all outgoing
mail, would be relatively trivial.

And with the concept of user preferences you never have to put up with
incessant whining about Reply-To munging since the list members can
configure it (or any other plug-in you deem fit) however they want.

Bliss.

As an example of how customizable Siesta is, Richard Clamp runs a
mailing list called Hates-Software for people who, err, hate software.

Running on subclassed versions of Mariachi (the mailing list archiver)
Hates-Software has archives for the whole list and also for every single
member so my rants are archived at
[http://muttley.hates-software.com/](http://muttley.hates-software.com),
but are also part of the seething maelstrom of hate that is
<http://we.hates-software.com/>.

### [Running a List]{#Running_a_list}

There are currently two ways of administering your Siesta installation
(not including fiddling around with the DB manually, of course), and
these are with the web interface and with the command line tool *nacho*.

Now, to be frank, the web interface sucks at the moment and needs an
overhaul, some prettification, and a whole lot of usability work. But
it's all open source and written in Template Toolkit, so you can fix it
up, skin it however you want, and then send us the patches. Ah, the
magic of the free software movement.

Instead, we'll concentrate on *nacho*; it's surprisingly powerful and
just a shell prompt away.

*nacho* has full documentation embedded as POD, but the version checked
into the repository will also, handily, provide a list of commands by
doing:

      % nacho help

Or the syntax of a specific command by doing:

      % nacho help <command>

Like this:

      % nacho help set-plugins

      set-plugins list_id queue [ plugin [ plugin... ] ]
      -
      Set the list plugins to be the ones specified.

Anyway ... first things first.

#### [Setting up the Database]{#Setting_up_the_database}

The first thing you need to do is create a database.

Fortunately this is easy. Running:

        % nacho create-database

should do everything for you (providing the config in your siesta.conf
is OK).

#### [Migrating a List from Mailman]{#Migrating_a_list_from_Mailman}

Use the *bandito* tool shipped with Siesta to steal the config of your
existing Mailman configuration -- given the path to a mailman list
config database, it should automatically create a new Siesta list,
subscribe any necessary users, set up configs, and generally "just
work."

It will even migrate your archives across for you.

How handy.

#### [Creating a List by Hand]{#Creating_a_list_by_hand}

Run this command:

      % nacho create-list myfirstlist admin@thegestalt.org \
                         myfirstlist@thegestalt.org \ 
                 myfirstlist-bounce@thegestalt.org

Which will print out:

      Created the new list 'myfirstlist' <myfirstlist@thegestalt.org> 

Paste this into your alias file to activate the list:

      ## myfirstlist mailing list
      ## created: 06-Sep-2002 nacho (the siesta config tool)
      myfirstlist:       "/usr/bin/tequila myfirstlist"
      myfirstlist-sub:   "/usr/bin/tequila myfirstlist sub"
      myfirstlist-unsub: "/usr/bin/tequila myfirstlist unsub"
      myfirstlist-admin:  admin@thegestalt.org 
      myfirstlist-bounce: admin@thegestalt.org

This prints out the appropriate aliases to put in your `/etc/alias` (or
equivalent) file. This can be printed out again at anytime by doing:

      % nacho show-alias myfirstlist

      ## myfirstlist mailing list
      ## created: 06-Sep-2002 nacho (the siesta config tool)
      myfirstlist:       "/usr/bin/tequila myfirstlist"
      myfirstlist-sub:   "/usr/bin/tequila myfirstlist sub"
      myfirstlist-unsub: "/usr/bin/tequila myfirstlist unsub"
      myfirstlist-admin:  admin@thegestalt.orb
      myfirstlist-bounce: admin@thegestalt.orb

At which point you probably want to add some plug-ins.

      % nacho set-plugins myfirstlist post Debounce ListHeaders Send     
      % nacho set-plugins myfirstlist sub Subscribe
      % nacho set-plugins myfirstlist unsub UnSubscribe

This means that for the `myfirstlist` list, when it sees a post, it
should first remove bounces, then add list headers, then call the `Send`
plug-in to send it out. Similarly, subscribes and unsubscribes go
through the normal `Subscribe` and `UnSubscribe` plug-ins.

If you want to find all the lists on the system you just do:

      % nacho show-lists
      myfirstlist

And then to look at the information for a list, do this:

      % nacho describe-list myfirstlist
      owner = 1
      return_path = myfirstlist-bounce@thegestalt.orb
      post_address = myfirstlist@thegestalt.orb
      name = myfirstlist
      id = 2
      post plugins : MembersOnly ListHeaders Send 
      sub plugins: Subscribe
      unsub plugins: UnSubscribe

Or to modify that information:

      % nacho modify-list myfirstlist name somenewname
      Property 'name' set to 'somenewname' for list myfirstlist

TIP: If you modify the id then what will actually happen is that a new
list will be created with that id, but with information exactly the same
as the details for the previous list.

#### [Creating Members]{#Creating_Members}

You can either subscribe members manually by creating them and inserting
them using nacho:

      % nacho create-member simon@thegestalt.orb
      Member simon@thegestalt.orb added    

      % nacho add-member myfirstlist simon@thegestalt.orb
      Member 'simon@thegestalt.orb' added to list 'myfirstlist'

Or, nacho will automatically create members if they don't exist.

      % nacho add-member myfirstlist newmember@notexists.orb

You can add multiple people at the same time. Que Conveniente!

      % nacho add-member myfirstlist richardc@unibeard.not greg@mccarroll.demon.com
      Member 'richardc@unixbeard.not' added to list 'myfirstlist'
      Member 'greg@mccarroll.demon.com' added to list 'myfirstlist'

Finally a person can subscribe by mailing to the:

        myfirstlist-sub@yourdomainhere.orb 

address, or by going through the web interface.

#### [Managing Members]{#Managing_members}

You can get a list of every member that's on the system:

      % nacho show-members
      greg@mccarroll.demon.com
      richardc@unixbeard.not
      simon@thegestalt.orb

Or just the members subbed to a particular list:

      % nacho show-members myfirstlist

To find out all about a member, use the describe command:

      % nacho describe-member simon@thegestalt.orb

        email = simon@thegestalt.orb
        lastbounce =
        bouncing =
        password = bar
        nomail =
        id = 36
        Subscribed to : myfirstlist, somerandomlist

To modify information about that information:

      % nacho modify-member simon@thegestalt.orb password foo
      Property 'password' set to 'foo' for member simon@thegestalt.org

Again, just changing the id will copy the member:

#### [Managing Plug-ins]{#Managing_Plugins}

You can list all the plug-ins installed on the system:

      % nacho show-plugins
      Archive
       -
       save messages to maildirs
      ...
      UnSubscribe
       -
       A system plugin used for unsubscribing a member to the list.

Since plug-ins are "just" normal Perl modules, you can write your own or
download plug-ins other people have written and install them like any
other module. Siesta will automatically detect them.

To set the plug-in order explicity, do this:

      % nacho set-plugins myfirstlist post Debounce SimpleSig SubjectTag Send

The "post" part is the queue you want these attached to. By default here
are three: "post," "sub," and "unsub," but there can be as many as you
want. They serve to differentiate the different modes the list might run
in. So, for example, you could have a "help" queue that responds to help
requests, or a "FAQ" queue that tries to answer questions.

To delete all the plug-ins, just pass an empty list

      % nacho set-plugins myfirstlist post
      Deleted plugins from siesta-dev

It should be noted that you probably always want to have the Send
plug-in (or a replacement plug-in) as the last plug-in.

To get more information about a plug-in, you can either:

      % perldoc Siesta::Plugin::ReplyTo

Or ...

      % nacho describe-plugin ReplyTo
      The plugin ReplyTo has the following options :
      - munge : should we munge the reply-to address of the 
        message to be the list post address

To find out what the current config for a list is, just add the list
name.

      % nacho describe-plugin ReplyTo myfirstlist
      Preferences for list myfirstlist
      - munge : 0

And to find out a member's config options, add his or her email address:

      % nacho describe-plugin ReplyTo myfirstlist simon@thegestalt.orb
      Personal preferences for member simon@thegestalt.orb on list myfirstlist
      - munge : 1

To modify configuration for any of these:

      % $ nacho modify-plugin ReplyTo box munge 0                     
      Preferences for list box
      - munge : 0

However, you can also set a preference on a per-member basis:

      % nacho modify-plugin ReplyTo box munge 1 simon@thegestalt.org
      Personal preferences for member simon@thegestalt.org on list box
      - munge : 1

#### [Removing Members]{#Removing_Members}

Occasionally a member will want to leave (or will need to be pushed) and
you'll need to do this by hand. To remove a member from a list just do
this:

      % nacho remove-member myfirstlist greg@mccarroll.demon.com
      Member 'greg@mccarroll.demon.com' removed from list 'myfirstlist'

#### [Deleting Members]{#Deleting_Members}

Deleting members from the system will remove them from all the lists
they're subscribed to, and then delete them from the system.

      % nacho delete-member richardc@unixbeard.net 
      Member 'richardc@unixbeard.not' deleted.

#### [Handling Deferred Messages]{#Handling_deferred_messages}

Deferred messages are ones being held for approval, or that contain
administrative tasks.

You can see how many deferred messages there are by doing this:

        % nacho show-deferred

        Deferred-Id: 1
        Reason: the hell of it
        Owner: test@foo

         From: simon@thegestalt.org
         To: people@somewhere.org
         Subject: some subject lin
         Date: Wed, 13 Aug 2003 15:49:30 +0100  

Or you can view an individual message by supplying the id:

        % nacho show-deferred 1
        From: simon@thegestalt.org
        To: people@somewhere.org
        Subject: some subject line
        Date: Wed, 13 Aug 2003 15:49:30 +0100  

        Hello people

        Simon

To resume a message simply do this:

        % nacho resume-deferred 1
        Successfully resumed message 1

Alternatively, to delete a deferred message do this:

        % nacho delete-deferred 1
        Message deleted from deferral queue

#### [Deleting Lists]{#Deleting_Lists}

Similarly deleting a list will unsub all members from that list and then
remove it from the system.

      % nacho delete-list myfirstlist
      List 'myfirstlist' deleted

#### [Making Backups]{#Making_backups}

Running the command:

        % nacho create-backup 

will print a shell script to STDOUT.

This shell script consists of nacho commands to restore your system to
its glorious past should anything go wrong.

        % nacho create-backup myfirstlist

will do the same, but for only one list.

#### [Upgrading]{#Upgrading}

Upgrading is easy -- simply make a backup as described above, install
the latest version from CPAN, and then run the nacho-generated script to
restore your system. Most of the time, however, unless the database has
changed format, even that won't be necessary, and simply installing from
CPAN should just be OK.

### [Writing a Plug-in]{#Writing_a_plugin}

Writing a plug-in for Siesta is easy. Say, for example, we wanted to
take any supercited mails to the list and reform them into a less
GNUSish format. First off, we start with the standard boilerplate:

        package Siesta::Plugin::DeSupercite;
        use strict;
        use Siesta::Plugin;
        use base 'Siesta::Plugin';
        use Siesta;

        sub description {
            '';
        } 


        sub process {
            my $self = shift;
            my $mail = shift;
            my $list = $self->list;

            return 0;
        };


        sub options {
            +{
             }
        };

Add in the existing DeSuperciting module:

        use Text::DeSupercite qw/desupercite/;

Fill in the description:

        sub description {
            'Strip superciting from emails';
        } 

And the options:

        sub options {
            +{
                harsh =>
                {
                   description =>
                   'should we be draconian about desuperciting?',
                   type    => 'boolean',
                   default => 0,
                },
            };
        }

And finally, fill in the body of the process method:

        sub process {
            my $self = shift;
            my $mail = shift;
            my $list = $self->list;

            # automatically works out if this is user 
            # setable or not 
            my $harsh = $self->pref( 'harsh' );

            # get the body text
            my $text = desupercite($mail->body(), $harsh);

            # set it back again
            $mail->body_set($text);

            # indicate success
            return 0;
        };

*Et voila*, one plug-in, ready to go. Now all you need to do is package
it up and install it in your @INC and it'll get picked up automagically
and will be ready to be added to any list on the system.

### [Mariachi]{#Mariachi}

Whilst completely independent of Siesta, our mailing list archiver
Mariachi is still entwined with the whole project, if only because it
gives us something to noodle around as a distraction from the mailing
list manager. As such it deserves at least a quick mention here.

Apart from being easily subclassable, Mariachi has another couple of
nice features. For a start, all the output templates are done in
Template Toolkit, making it easy to customize to fit in with the look
and feel of your site without having to delve around in the code.

It also allows you to display mail in a couple of nifty ways. The first
is the classic Jwz-style message threading as used in Netscape and Mutt,
complete with indentation, which makes following threads much easier.
The second is the so-called Lurker view, named after the [Lurker
application](http://lurker.sourceforge.net/), which appears to be the
first application to use this chronological view of mail.

These both include the option to extract either the first original
sentence or paragraph from a mail, meaning that many threads can be
easily skimmed without having to open up individual messages.

In addition, Richard has already written a module that will generate an
SVG of a mail thread in the Arc form described
[here](http://www.research.ibm.com/remail/).

Perhaps Mariachi's only problem is that because it does not split mail
up over arbitrary boundaries (although there's nothing to stop the users
from doing this themselves), generating archives from a massive mail box
(such as every London.pm mail from the last 5 years) can be slow, even
if it is done incrementally.

However, work is being done to overcome this.

### [Conclusion]{#Conclusion}

Although unfinished, we believe that Siesta is already a hugely powerful
mailing list manager with almost unrivalled extensibility.

Breathless superlatives aside, and irrespective of whether it ever gets
widely used, it will forever shut up those who whine on mailing lists
that there's no good Perl MLM or that they wish there was an MLM that
had plug-ins. Perhaps most importantly, you have somewhere to point
anybody whoever complains about Reply-To munging, since with Siesta,
each user can choose whether or not they want Reply-To munging applied.

In a more practical sense, while working on Siesta the team has written
or patched nearly 20 modules outside the ones distributed with Mariachi
and Siesta. So something for everybody.

If you're interested in getting involved with the project, just install
the programs (they should work from your favorite CPAN shell), make
notes on anything you find irritating, join the mailing list, and tell
us about it. Then start patching, writing plug-ins or, and if you're the
kind of person who likes doing web page stuff, fix the web interface.
We'll love you forever. And you'll get to drink tequila at Perl
conferences like all the cool kids.

### [References]{#References}

-   [The Siesta home page](http://siesta.unixbeard.net)
-   [Hates-Software](http://hates-software.com)
-   [\*That\*
    thread](http://london.pm.org/pipermail/london.pm/Week-of-Mon-20020701/011937.html)
-   [And
    \*again\*](http://london.pm.org/pipermail/london.pm/Week-of-Mon-20020729/012366.html)
-   [The philosophy of the Email::\*
    project](http://simon-cozens.org/draft-articles/email.html)


