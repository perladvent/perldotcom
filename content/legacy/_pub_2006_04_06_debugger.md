{
   "draft" : null,
   "authors" : [
      "daniel-allen"
   ],
   "description" : " Many people who work with Perl code never touch the debugger. My goal in this article is to provide reasoned argument for adding the Perl debugger to your set of tools, as well as pointers on how to do...",
   "slug" : "/pub/2006/04/06/debugger.html",
   "categories" : "debugging",
   "title" : "Unraveling Code with the Debugger",
   "image" : null,
   "date" : "2006-04-06T00:00:00-08:00",
   "tags" : [
      "bug-fixing",
      "debugging",
      "maintenance-coding",
      "perl-debugger",
      "perl-maintenance",
      "tracing"
   ],
   "thumbnail" : "/images/_pub_2006_04_06_debugger/111-unravelling-code.gif"
}



Many people who work with Perl code never touch the debugger. My goal in this article is to provide reasoned argument for adding the Perl debugger to your set of tools, as well as pointers on how to do so. Many people are most comfortable with adding debugging variables and print statements to their code. These are fine techniques; I use them too, when they are appropriate. At other times, the debugger has saved me from tearing my hair out.

To mangle an old saying, with apologies to Sartre, "Hell is other people's code." Other people think differently than I do; they use weird idioms, and sometimes their comments are incomprehensible. Invoking the debugger on someone's code is like having a conversation with the author. It opens the code to the questions I want answered, in real time--and there's another party in the conversation, the Perl interpreter. The debugger makes it easy to try things out, even quicker than writing a one-liner, because the environment's already set up for the running program.

This article is a case example of using the Perl debugger in a production environment. In this situation, we had problems with CGI scripts on a machine I don't maintain. I wanted to go in, solve the problem, and get out quickly, without unnecessarily changing anybody's code.

I've written the article so that you can follow along yourself, if you wish. To do so, you need a Linux/Unix system with Perl 5.8, Apache (any version), and a basic [TWiki](http://www.twiki.org/) installation. (I'm using version 20040902-3.) TWiki is quite easy to install from packages; it took me 3 minutes under Ubuntu, including answering a few installation questions. If you're installing for this walk-through, enable the sample data set, which installs into the default TWiki directories (*/var/lib/twiki/data* and */var/www/twiki/pub* on Debian and Ubuntu).

Additionally, for any use of the debugger, you should install the Perl modules [Term::ReadLine]({{<mcpan "Term::ReadLine" >}}) and [Term::ReadKey]({{<mcpan "Term::ReadKey" >}}) from [MetaCPAN](https://metacpan.org/). These will give you bash/csh-like cursor control, history browsing with up and down arrows, and tab completion on variables and functions.

### Statement of the Problem

Our production installation of TWiki had a problem with a hidden web: a section that users could reach only by using its URL, rather than through the usual list of public webs (on the left side of each page). The problem appeared when we tried to make the hidden web public; it remained hidden. We lived with this for a few weeks, convinced that TWiki had a sticky setting somewhere that we didn't know about, or perhaps TWiki had a bug. The documentation, while excellent, didn't seem to address our problem. A number of people looked at the configuration files without seeing the solution.

Above all, it was important to fix this quickly, because we couldn't spend much effort on this relatively minor annoyance. We were almost at the point of asking for help within the TWiki community, but as we didn't find evidence anybody else was having this problem, it likely wouldn't be a quick fix. (As you're reading, you may see the answer, but please keep reading; the utility of the debugger extends far beyond such an easy problem.)

### Initial Look

To create a hidden web within TWiki, set `NOSEARCHALL = yes` in the web's `WebPreferences` page. Setting `NOSEARCHALL = no` still left the web hidden.

The documentation suggested that the only configuration variable involved was `NOSEARCHALL`. My next step was grepping the data directory, and then the TWiki source code--which turned up the likely code responsible, a certain function `TWiki::getPublicWebList`. Looking at that code didn't make the answer clear. (If you're following along, go ahead and run `perldoc -m TWiki` to see if you can spot the problem by inspection.)

Back in the web browser, I noted that the URL for normal TWiki page viewing was `http://hostname/cgi-bin/twiki/view/Main/WebHome`.

From my initial look at the code, I knew the CGI that produced this was in */usr/lib/cgi-bin/twiki/view*. Could I run it from the command line? Changing to that directory, I ran `./view` and saw the expected HTML for the front page.

### Debugger

Next, I fired up the debugger on the file: `perl -d view`

... which didn't work, because the program uses taint mode. (If you try, you'll see the warning, *"-T" is on the \#! line, it must also be used on the command line at view line 1.*) That was easy to fix by running `perl -dT view`.

If you try that, you'll see the debugger interface:

    Loading DB routines from perl5db.pl version 1.28
    Editor support available.

    Enter h or `h h' for help, or `man perldebug' for more help.

    main::(view:38):        my $query = new CGI;
      DB<1>

The major elements here are: an introductory message; the package, filename, and line number; the command the debugger is about to run; and a prompt showing your command-history number.

Press `c` (for continue) and Enter. The program will run through to completion, finishing with:

    Debugged program terminated.  Use q to quit or R to restart,
      use O inhibit_exit to avoid stopping after program termination,
      h q, h R or h O to get additional info.
      DB<1>

Press `R` to restart the program ... which normally would work, but you can't restart programs with taint mode enabled. No matter. Restart the debugger with `perl -dT view` again.

Next, press `l` for a code listing with line numbers. The default is ten lines of code. You'll notice an arrow by the line prepared to execute next. Some lines have a trailing colon (`:`), which means that you can interrupt execution at that line. Pressing `l` again will show the next ten lines, and so on. `l` can also handle listing a range (such as `l 1-40`) or a function (such as `l TWiki::initialize`). You can move the current display back to the execution point with a period (`.`) or back ten lines with minus (`-`).

Start running the program, slowly. Press `n`, for next, and the display will change to show the subsequent line:

      DB<8> n
    main::(view:40):        my $thePathInfo = $query->path_info();
      DB<8>

`n` will always bring you to the next executable line. This command is used frequently enough that you can press Enter to repeat it. If you try this, on the fifth execution you'll see that multiline commands break up nicely on the screen:

      DB<1>
    main::(view:45):       my( $topic, $webName, $scriptUrlPath, $userName ) =
    main::(view:46):          TWiki::initialize( $thePathInfo, $theRemoteUser,
    main::(view:47):                             $theTopic, $theUrl, $query );
      DB<1>

Only the first of those lines is breakable, however. Another `n` would skip ahead to line 49; but don't do that yet.

The next feature is code evaluation. At the debugger prompt, you may enter any Perl code to execute in the current context. This can include modifying the running program, such as defining functions or variables.

You can also run functions or examine data using normal Perl syntax. There is a special command to evaluate and dump expressions in a list context, `x`. Try it:

      DB<1> x $query->url;
    0  'http://localhost/view'
      DB<2>

Notice that the command history number increments from 1 to 2, because this is the first nontrivial command you've executed. Reexecute any prior command with the shortcut `!number`.

The `0` signifies the array index of each element, which is useful with lists. `x` will also do the right thing for data structures. Try viewing your CGI object:

      DB<2> x $query
    0  CGI=HASH(0x8aef668)
       '.charset' => 'ISO-8859-1'
       '.fieldnames' => HASH(0x8a83034)
            empty hash
       '.parameters' => ARRAY(0x8b32aa4)
            empty array
       '.path_info' => ''
       'escape' => 1

For deep data, you might prefer restricting the depth walking to two levels: `x 2 $query` .

The next feature, which goes along with `n`, is `s`, for single-stepping *into* a function. `s` will replace the current running context with that context of the subroutine. After one `s`, you're within `TWiki::initialize`:

      DB<4> s
    TWiki::initialize(/usr/share/perl5/TWiki.pm:333):
    333:        my ( $thePathInfo, $theRemoteUser, $theTopic, 
                                   $theUrl, $theQuery ) = @_;

The description line has changed, showing that you're in a new package, function, and file. Press Enter; note that `s` also repeats with Enter. Three more repeats will get you two levels deeper:

      DB<4>
    TWiki::initialize(/usr/share/perl5/TWiki.pm:336):
    336:            basicInitialize();
      DB<4>
    TWiki::basicInitialize(/usr/share/perl5/TWiki.pm:490):
    490:        setupLocale();
      DB<4>
    TWiki::setupLocale(/usr/share/perl5/TWiki.pm:515):
    515:        $siteCharset = 'ISO-8859-1';        
                   # Default values if locale mis-configured
      DB<4>

Now you are deep inside the TWiki module. Imagine tracking this program execution by hand; it would be considerably more tedious. Instead, you have the sometimes challenging task of figuring out where the program has taken you. Fortunately, the debugger has tools for making this easier. Note that the indenting isn't any judge of the execution depth; to find that, use `T` for trace:

      DB<1> T
    . = TWiki::setupLocale() called from file 
        `/usr/share/perl5/TWiki.pm' line 490
    . = TWiki::basicInitialize() called from file 
        `/usr/share/perl5/TWiki.pm' line 336
    @ = TWiki::initialize('', undef, undef, 'http://localhost/view', 
        ref(CGI)) called from file `view' line 45

The backtrace has the following format: the first character is the calling context; `.`, `$`, and `@` signify void, scalar, and list contexts respectively. Next is function name, including the arguments passed, if any. Finally comes the calling filename and line number. These lines go from deepest to shallowest execution depth.

Perhaps you went too deep. Use `r` to return from a function.

      DB<8> r
    void context return from TWiki::setupLocale
    TWiki::basicInitialize(/usr/share/perl5/TWiki.pm:491):
    491:        setupRegexes();

Here you can see that `r` shows the return value and its context. This can be quite useful, as the calling context can occasionally surprise even experienced programmers. With inspection, you can verify that this output makes sense compared to the trace above, because it's one line beyond the caller from the first line of that trace.

Use `r` again twice, to get back to the top. Now it's clear that `initialize()` returns a list to the caller:

      DB<1> r
    list context return from TWiki::initialize:
    0  'WebHome'
    1  'Main'
    2  '/cgi-bin/twiki'
    3  'guest'
    4  '/var/lib/twiki/data'
    main::(view:49):        TWiki::UI::View::view( $webName, 
                                $topic, $userName, $query );

If you were tracking the initialization routine, you might remind yourself what the caller was doing with the command `-` to show the calling line again; but that's not necessary now, so continue!

Take a step back. You know you're looking for the function `TWiki::getPublicWebList`. You can take a shortcut to get there. The debugger command `c` can take arguments, either line numbers or subroutine names.

      DB<5> c TWiki::getPublicWebList
    TWiki::getPublicWebList(/usr/share/perl5/TWiki.pm:2559):
    2559:       if( ! @publicWebList ) {
      DB<6>

As you can see, you've switched modules again, into *TWiki.pm*. Take a look around:

      DB<3> l
    2559==>     if( ! @publicWebList ) {
    2560            # build public web list, e.g. exclude hidden 
                    # webs, but include current web
    2561:           my @list = &TWiki::Store::getAllWebs( "" );
    2562:           my $item = "";
    2563:           my $hidden = "";
    2564:           foreach $item ( @list ) {
    2565:               $hidden = 
      &TWiki::Prefs::getPreferencesValue( "NOSEARCHALL", $item );
    2566                # exclude topics that are hidden or start 
                        # with . or _ unless current web
    2567:               if( ( $item eq $TWiki::webName  ) || 
                            ( ( ! $hidden ) && ( $item =~ 
                                          /^[^\.\_]/ ) ) ) {
    2568:                   push( @publicWebList, $item );

This looks promising. `c 2562` and then `x @list` to see that there are five list items.

      DB<15> c 2562
    TWiki::getPublicWebList(/usr/share/perl5/TWiki.pm:2562):
    2562:           my $item = "";
      DB<16> x @list
    0  'Main'
    1  'Sandbox'
    2  'TWiki'
    3  'Trash'
    4  '_default'
      DB<17> n

As you can see, the `foreach()` in line 2,564 will identify which of these are public. Getting warmer! You can `n` several times to see the program flow. (Remember, after the first, you can press Enter.) If you run other commands, Enter still keeps its shortcut of `n` or `s`. If you `x $hidden` after you've passed line 2,565 in each loop, you will see that they contain the empty string because `NOSEARCHALL` is unset.

The expression in the following line tests the truth of `$hidden` as per the comment.

Here is the solution. In my team's original problem, we changed `NOSEARCHALL` from `Yes` to `No`. The string `No` certainly is still true. It took me a few runs through the code, testing values each time, to find it.

When I changed `NOSEARCHALL` to `""` from `Yes` in the config file, the hidden web immediately became unhidden. Problem solved. The entire process took no more than 45 minutes. Considering the number of lines of code in TWiki and its relative complexity, that isn't bad.

### Results

Yes, the problem was that we overlooked something "obvious." True, I didn't actually debug the code; I debugged my configuration. No matter. This is the way of a lot of debugging; the problem isn't where you expect, and it's obvious in retrospect. I hope with this simple example, I've shown how the debugger can tell you things you may not notice by code inspection or reading documentation.

This article has barely scratched the surface of the debugger's capabilities; it can also do such things as automatically insert code that runs whenever you step forward, or automatically stop execution when an expression becomes true. You can insert lines of code into the program that exist only in the debugging instance. You can record your actions and play them back in other debugging sessions; or customize the debugger with your own preferences and aliases. There are also methods to run a debugger GUI on a remote server, and modules to harness debugging mod\_perl and other programs that don't run on the command line. Please see the references for more information about these features.

### References: Introductory Debugger Information Online

[The Perl Debugger. Linux Journal. March 2005, 73-76](http://www.linuxjournal.com/article/7581/)

[perldoc perldebtut]({{<mcpan "distribution/perl/pod/perldebtut.pod" >}})

[perldoc perldebug]({{<mcpan "distribution/perl/pod/perldebug.pod" >}})

[Perl Debugger Quick Reference](/pub/2004/11/24/debugger_ref.html)
