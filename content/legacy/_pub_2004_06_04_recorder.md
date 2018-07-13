{
   "description" : " HTTP::Recorder is a browser-independent recorder that records interactions with web sites and produces scripts for automated playback. Recorder produces WWW::Mechanize scripts by default (see WWW::Mechanize by Andy Lester), but provides functionality to use your own custom logger. Why Use...",
   "slug" : "/pub/2004/06/04/recorder.html",
   "draft" : null,
   "authors" : [
      "linda-julien"
   ],
   "tags" : [
      "proxy",
      "recorder",
      "testing",
      "web"
   ],
   "thumbnail" : "/images/_pub_2004_06_04_recorder/111-httprec.gif",
   "date" : "2004-06-04T00:00:00-08:00",
   "categories" : "web",
   "title" : "Web Testing with HTTP::Recorder",
   "image" : null
}



`HTTP::Recorder` is a browser-independent recorder that records interactions with web sites and produces scripts for automated playback. Recorder produces `WWW::Mechanize` scripts by default (see [`WWW::Mechanize`]({{<mcpan "WWW::Mechanize" >}}) by Andy Lester), but provides functionality to use your own custom logger.

### Why Use `HTTP::Recorder`?

Simply speaking, `HTTP::Recorder` removes a great deal of the tedium from writing scripts for web automation. If you're like me, you'd rather spend your time writing code that's interesting and challenging, rather than digging through HTML files, looking for the names of forms an fields, so that you can write your automation scripts. `HTTP::Recorder` records what you do as you do it, so that you can focus on the things you care about.

#### Automated Testing

We all know that testing our code is good, and that writing automated tests that can be run again and again to check for regressions is even better. However, writing test scripts by hand can be tedious and prone to errors. You're more likely to write tests if it's easy to do so. The biggest obstacle to testing shouldn't be the mechanics of getting the tests written — it should be figuring out what needs to be tested, and how best to test it.

Part of your test suite should be devoted to testing things the way the user uses them, and `HTTP::Recorder` makes it easy to produce automation to do that, which allows you to put your energy into the parts of your code that need your attention and your expertise.

#### Automate Repetitive Tasks

When you think about web automation, the first thing you think of may be automated testing, but there are other uses for automation as well:

-   Check your bank balance.
-   Check airline fares.
-   Check movie times.

### How to Set It Up

#### Use It with a Web Proxy

One way to use `HTTP::Recorder` (as recommended in the POD) is to set it as the user agent of a web proxy (see [`HTTP::Proxy`]({{<mcpan "HTTP::Proxy" >}}) by Phillipe "BooK" Bruhat). Start the proxy running like this:

        #!/usr/bin/perl

        use HTTP::Proxy;
        use HTTP::Recorder;

        my $proxy = HTTP::Proxy->new();

        # create a new HTTP::Recorder object
        my $agent = new HTTP::Recorder;

        # set the log file (optional)
        $agent->file("/tmp/myfile");

        # set HTTP::Recorder as the agent for the proxy
        $proxy->agent( $agent );

        # start the proxy
        $proxy->start();

        1;

Then, instruct your favorite web browser to use your new proxy for HTTP traffic.

#### Other Ways to Use It

Since `HTTP::Recorder` is a subclass of LWP::UserAgent, so you can use it in any way that you can use its parent class.

### How to Use It

Once you've set up `HTTP::Recorder`, just navigate to web pages, follow links, and fill in forms the way you normally do, with the web browser of your choice. `HTTP::Recorder` will record your actions and produce a `WWW::Mechanize` script that you can use to replay those actions.

The script is written to a logfile. By default, this file is `/tmp/scriptfile`, but you can specify another pathname when you set things up. See [Configuration Options](#config) for information about configuring the logfile.

#### <span id="control_panel">`HTTP::Recorder` Control Panel</span>

The `HTTP::Recorder` control panel allows you to use to view and edit scripts as you create them. By default, you can access the control panel by using the `HTTP::Recorder` UserAgent to access the control URL. By default, the control URL is `http://http-recorder/`, but this address is configurable. See [Configuration Options](#config) for more information about setting the control URL.

The control panel won't automatically refresh , but if you create `HTTP::Recorder` with `showwindow => 1`, a JavaScript popup window will be opened and refreshed every time something is recorded.

<img src="/images/_pub_2004_06_04_recorder/control.jpg" width="400" height="425" />

**Goto Page.** You can enter a URL in the control panel to begin a recording session. For SSL sessions, the initial URL must be entered into this field rather than into the browser.

**Current Script.** The current script is displayed in a textfield, which you can edit as you create it. Changes you make in the control panel won't be saved until you click the Update button.

**Update.** Saves changes made the script via the control panel. If you prefer to edit your script as you create it, you can save your changes as you make them.

**Clear.** Deletes the current script and clears the text field.

**Reset.** Reverts the text field to the currently saved version of the script. Any changes you've made to the script won't be applied if you haven't clicked Update.

**Download.** Displays a plain text version of the script, suitable for saving.

**Close.** Closes the window (using JavaScript).

#### Updating Scripts as They're Recorded

You can record many things, and then turn the recordings into scripts later, or you can make changes and additions as you go by editing the script in the [Control Panel](/pub/2004/06/04/recorder.html?page=1#control_panel).

For example, if you record filling in this form and clicking the Submit button:

<img src="/images/_pub_2004_06_04_recorder/form1.jpg" width="271" height="36" />

`HTTP::Recorder` produces the following lines of code:

        $agent->form_name("form1");
        $agent->field("name", "Linda Julien");
        $agent->submit_form(form_name => "form1");

However, if you're writing automated tests, you probably don't want to enter hard-coded values into the form. You may want to re-write these lines of code so that they'll accept a variable for the value of the `name` field.

You can change the code to look like this:

        my $name = "Linda Julien";

        $agent->form_name("form1");
        $agent->field("name", $name);
        $agent->submit_form(form_name => "form1");

Or even this:

        sub fill_in_name {
          my $name = shift;

          $agent->form_name("form1");
          $agent->field("name", $name);
          $agent->submit_form(form_name => "form1");
        }

        fill_in_name("Linda Julien");

Then click the Update button. `HTTP::Recorder` will save your changes, and you can continue recording as before.

You may also want to add tests as you go, making sure that the results of submitting the form were what you expected:

<img src="/images/_pub_2004_06_04_recorder/form2.jpg" width="242" height="69" />

You can add tests to the script like this:

        sub fill_in_name {
          my $name = shift;

          $agent->form_name("form1");
          $agent->field("name", $name);
          $agent->submit_form(form_name => "form1");
        }

        my $entry = "Linda Julien";
        fill_in_name($entry);

        $agent->content =~ /You entered this name: (.*)/;
        is ($1, $entry);

#### Using `HTTP::Recorder` with SSL

In order to do what it does, `HTTP::Recorder` relies on the ability to see and modify the contents of requests and their resulting responses...and the whole point of SSL is to make sure you can't easily do that. `HTTP::Recorder` works around this, however, by handling the SSL connection to the server itself, and and communicating with your browser via plain HTTP.

***Caution:** Keep in mind that communication between your browser and `HTTP::Recorder` isn't encrypted, so take care when recording sensitive information, like passwords or credit card numbers. If you're running the Recorder as a proxy on your local machine, you have less to worry about than if you're running it as a proxy on a remote machine. The resulting script for playback will be encrypted as usual.*

If you want to record SSL sessions, here's how you do it:

Start at the control panel, and enter the initial URL there rather than in your browser. Then interact with the web site as you normally would. `HTTP::Recorder` will record form submissions, following links, etc.

#### Replaying your Scripts

`HTTP::Recorder` getting pages, following links, filling in fields and submitting forms, etc., but it doesn't (at this point) generate a complete perl script. Remember that you'll need to add standard script headers and initialize the `WWW::Mechanize` agent, with something like this:

    #!/usr/bin/perl

        use strict;
        use warnings;
        use WWW::Mechanize;
        use Test::More qw(no_plan);

        my $agent = WWW::Mechanize->new();

#### <span id="config">Configuration Options</span>

**Output file.** You can change the filename for the scripts that `HTTP::Recorder` generates with the `$recorder->file([$value])` method. The default output file is '/tmp/scriptfile'.

**Prefix.** `HTTP::Recorder` adds parameters to link URLs and adds fields to forms. By default, its parameters begin with "rec-", but you can change this prefix with the `$recorder->prefix([$value])` method.

**Logger.** The `HTTP::Recorder` distribution includes a default logging module, which outputs `WWW::Mechanize` scripts. You can change the logger with the `$recorder->logger([$value])` method, replacing it with a logger that:

-   subclasses the standard logger to provice special functionality unique to your site
-   outputs an entirely different type of script

RT (Request Tracker) 3.1 by [Best Practical Solutions](http://www.bestpractical.com/) has a Query Builder that's a good example of a page that benefits from a custom logger:

<img src="/images/_pub_2004_06_04_recorder/BuildQuery.jpg" width="400" height="312" />

This page has several Field/Operator/Value groupings. Left to its own devices, the default `HTTP::Recorder::Logger` will record every field for which a value has been set:

        $agent->form_name("BuildQuery");
        $agent->field("ActorOp", "=");
        $agent->field("AndOr", "AND");
        $agent->field("TimeOp", "<");
        $agent->field("WatcherOp", "LIKE");
        $agent->field("QueueOp", "=");
        $agent->field("PriorityOp", "<");
        $agent->field("LinksOp", "=");
        $agent->field("idOp", "<");
        $agent->field("AttachmentField", "Subject");
        $agent->field("ActorField", "Owner");
        $agent->field("PriorityField", "Priority");
        $agent->field("StatusOp", "=");
        $agent->field("DateField", "Created");
        $agent->field("TimeField", "TimeWorked");
        $agent->field("LinksField", "HasMember");
        $agent->field("WatcherField", "Requestor.EmailAddress");
        $agent->field("AttachmentOp", "LIKE");
        $agent->field("ValueOfAttachment", "foo");
        $agent->field("DateOp", "<");
        $agent->submit_form(form_name => "BuildQuery");

But on this page, there's no need to record setting the values of fields (XField) and operators (XOp) unless a value (ValueOfX) has actually been set. We can do this with a custom logger that checks for the presence of a value, and only records the value of the field and operator fields if the value field has been set:

        package HTTP::Recorder::RTLogger;

        use strict;
        use warnings;
        use HTTP::Recorder::Logger;
        our @ISA = qw( HTTP::Recorder::Logger );

        sub SetFieldsAndSubmit {
            my $self = shift;
            my %args = (
                name => "",
                number => undef,
                fields => {},
                button_name => {},
                button_value => {},
                button_number => {},
                @_
                );

        $self->SetForm(name => $args{name}, number => $args{number});
        my %fields = %{$args{fields}};
        foreach my $field (sort keys %fields) {
            if ( $args{name} eq 'BuildQuery' &&
             ($field =~ /(.*)Op$/ || $field =~ /(.*)Field$/) &&
             !exists ($fields{'ValueOf' . $1})) {
            next;
            }
            $self->SetField(name => $field,
                    value => $args{fields}->{$field});
        }
        $self->Submit(name => $args{name},
                  number => $args{number},
                  button_name => $args{button_name},
                  button_value => $args{button_value},
                  button_number => $args{button_number},
                  );
        }

        1;

Tell `HTTP::Recorder` to use the custom logger like this:

        my $logger = new HTTP::Recorder::RTLogger;
        $agent->logger($logger);

And it will record a much more reasonable number of things:

        $agent->form_name("BuildQuery");
        $agent->field("AndOr", "AND");
        $agent->field("AttachmentField", "Subject");
        $agent->field("AttachmentOp", "LIKE");
        $agent->field("ValueOfAttachment", "foo");
        $agent->submit_form(form_name => "BuildQuery");

**Control panel.** By default, you can access the `HTTP::Recorder` control panel by using the Recorder to get `http://http-recorder`. You can change this URL with the `$recorder->control([$value])` method.

##### Logger Options

**Agent name.** By default, `HTTP::Recorder::Logger` outputs scripts with the agent name `$agent`:

         $agent->follow_link(text => "Foo", n => 1);

However, if you prefer a different agent name (in order to drop recorded lines into existing scripts, conform to company conventions, etc.), you can change that with the `$logger->agentname([value])` method:

         $recorder->agentname("mech");

will produce the following:

         $mech->follow_link(text => "Foo", n => 1);

### How `HTTP::Recorder` Works

The biggest challenge to writing a web recorder is knowing what the user is doing, so that it can be recorded. A proxy can watch requests and responses go by, the only thing you'll learn is the URL that was requested and its parameters. `HTTP::Recorder` solves this problem by rewriting HTTP responses as they come through, and adding additional information to the page's links and forms, so that it can extract that information again when the next request comes through.

As an example, a page might contain a link like this:

        <a href="http://www.cpan.org/">CPAN</a>

If the user follows the link, and we want to record it, we need to know all of the relevant information about the action, so that we can produce a line of code that will replay the action. This includes:

-   the fact that a link was followed.
-   the text of the link.
-   the URL of the link.
-   the index (in case there are multiple links on the page of the same name).

`HTTP::Recorder` overloads LWP::UserAgent's `send_request` method, so that it can see requests and responses as they come through, and modify them as needed.

`HTTP::Recorder` rewrites the link so that it looks like this:

`<a href="http://www.cpan.org/?rec-url=http%3A%2F%2Fwww.cpan.org%2F&rec-action=follow&rec-text=CPAN&rec-index=1">CPAN</a>`

So, with the rewritten page, if the user follows this link, the request will contain all of the information needed to record the action.

Forms are handled likewise, with additional fields being added to the form so that the information can be extracted later. `HTTP::Recorder` then removes the added parameters from the resulting request, and forwards the request along in something close to its originally intended state.

### Looking Ahead

`HTTP::Recorder` won't record 100% of every script you need to write, and while future versions will undoubtedly have more features, they still won't write your scripts for you. However, it will record the simple things, and it will give you example code that you can cut, paste, and modify to write the scripts that you need.

Some ideas for the future include:

-   Choosing from a list of simple tests based on the fields on the page and their current values.
-   "Threaded" recording, so that multiple sessions won't be recorded in the same file, overlapped with each other.
-   "Add script header" feature.
-   Supporting more configuration options from the control panel.
-   Other loggers.
-   JavaScript support.

### Where to Get `HTTP::Recorder`

The latest released version of `HTTP::Recorder` is available at [CPAN]({{<mcpan "HTTP::Recorder" >}}).

### Contributions, Requests, and Bugs

Patches, feature requests, and problem reports are welcomed at <http://rt.cpan.org>.

You can subscribe to the mailing list for users and developers of HTTP::Recorder at <http://lists.fsck.com/mailman/listinfo/http-recorder>, or by sending email to http-recorder-request@lists.fsck.com with the subject "subscribe".

The mailing list archives can be found at <http://lists.fsck.com/piper-mail/http-recorder>.

### See Also

[`WWW::Mechanize`]({{<mcpan "WWW::Mechanize" >}}) by Andy Lester.

[`HTTP::Proxy`]({{<mcpan "HTTP::Proxy" >}}) by Phillipe "BooK" Bruhat.
