
  {
    "title"       : "How to become CPAN contributor",
    "authors"     : ["mohammad-anwar"],
    "date"        : "2018-05-13T20:46:28",
    "tags"        : ["cpan","github","kwalitee"],
    "draft"       : false,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Tips and tricks to become a CPAN contributor",
    "categories"  : "community"
  }

To become a CPAN contributor, you don't need to write a new CPAN distribution, you just need to submit a change to an existing distribution that get's accepted by the author.

If you've never gotten your hands dirty editing Perl modules, the first question that may come to mind is: "Do I know enough to contribute to other people's code?". Well in my experience, you don't have to be an expert to become a contributor. There are plenty of opportunities out there suitable for beginner-level Perl programmers.


### How about an example?

Before I answer that question, I would like to point you to where to look for stuff to contribute. The easiest way is to keep an eye on the metacpan [recently uploaded](https://metacpan.org/recent) distributions page. I recommend this for beginners as new distributions usually offer plenty of opportunities to contribute.

As you're clicking through recently uploaded distributions, check the **Kwalitee** link on each distribution's page, and look to see if any issues are listed. Kwalitee issues are often minor that any beginner can help with.

In terms of example issues that contributors can help with, I've listed the most common ones below:

  * Code is missing strict/warnings pragma
  * Distribution missing META file(s)
  * Pod syntax error
  * Makefile.PL/Build.PL missing build prereqs
  * Missing license meta
  * MANIFEST incomplete/lists files not in distribution
  * Build script is not executable

If you are lucky then you might find the distribution source is hosted on GitHub. For your first few contributions, I would suggest focusing on distributions hosted on GitHub as chances are, you already have a GitHub account. To check if a distribution is on GitHub, look for the "Clone repository" link on the distribution's metacpan page ([example]({{<mcpan "Term::ProgressBar" >}})).

### Prepare the ground first

By this point you should have identified a distribution with a Kwalitee issue that is hosted on GitHub. Fork the repository on GitHub so that you have a copy of the distribution source in your own repository. The next step is to open a terminal and clone the forked repository on to your local machine.

Create a new branch for your proposed changes. Give the branch a meaningful name that describes the nature of the contributions you intend to make (e.g. "kwalitee-fixes"). Before you make any changes, try building and installing the module to make sure the code compiles and the tests are passing. Lets follow the happy path and assume the distribution is clean and all test pass.

### Action now

This is your moment now, you are about to jump into someone else's domain. So be extra **careful** and **vigilant**. Make sure you only change the parts you intend to. Watch out in case your text editor swaps tabs for spaces, or removes EOF newlines from files. If you're changing code, follow the coding style of the author so that your changes fit with their way of doing things. This will make your contributions more likely to be accepted by them.

Once you have made the necessary changes, commit and push the changes to your repository. Now go to your forked repository's GitHub web page and create a pull request. Double check your commit and make sure no other changes are included by accident. Submit the pull request describing your changes what improvements they bring.

Hopefully the author will merge your pull request and **congratulations** you are a contributor now! You helped make Open Source better and should be proud. But don't get *disheartened* if you don't see a response within a few days. You may get a response within minutes, but it might take months. One author responded to my pull request **after a year**. In the meantime whilst you're waiting to hear back, there are plenty of new distributions that could use your help!

### Need help?

If you need a helping hand then feel free to [email me](mailto:mohammad.anwar@yahoo.com) and if necessary, we can remote pair program to get you going. I'll also be speaking about this topic at [The Perl Conference in Glasgow](http://act.perlconference.org/tpc-2018-glasgow/), so come on by and say hi.

Good luck and all the very best with your CPAN contributions!
