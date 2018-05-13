
  {
    "title"       : "How to become CPAN contributor?",
    "authors"     : ["mohammad-anwar"],
    "date"        : "2018-05-12T14:43:28",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Tips and tricks to become CPAN contributor",
    "categories"  : "community"
  }

I have submitted a talk on the same subject for **The Perl Conference 2018** at *Glasgow*. This would help me to collect my thoughts on the matter.  I have given similar talk at London Perl Workshop 2016 and German Perl Workshop 2018. The topic keeps evolving with time as I experience new things every day.

The target audidence would be some one who have never got their hand dirty. Based on my personal experience, the very first question that comes to your mind "Do I know enough to contribute to other's code?"

Well, in my experience, you don't have to be an expert to become a contributor. There are plenty of stuff out there just suitable for beginners level Perl programmer.


### How about an example?

Before I answer that question, I would like to point you where to look for stuff to contribute. The best place is to keep an eye on the [Recently uploaded](https://metacpan.org/recent) distributions page on metacpan.org. Once you have done few then you can explore other avenues. I have a suggestion to all beginners to look for relative new distributions. The chances you will find plenty of opportunities to contribute.

The metacpan.org can even help you in your quest once you have picked the distribution. Check the **Kwalitee** link of the selected distribution, you will find minor issues that any beginners can give it a go.

Going back to my earlier question **How about an example?**.

The most common *issues* are listed below:

  * Missing strict/warning pragma
  * Missing META file(s)
  * Pod error
  * Missing prereqs
  * Missing build prereqs
  * Missing license meta
  * Mismatch entry in MANIFEST
  * Build script is executable

... and many more.

If you are lucky then you might find the distribution source is hosted on GitHub. For first few contributions, I would suggest only pick distributions with GitHub repository.

So, now we have a distribution with scope to contribute. At this point I assume you have setup an account with GitHub. If not then please do that first. It would help you immensely.

Lets get to the repository on GitHub of the selected distribution and fork it. This should give the copy of the distribution source in your own repository. Next step is open a terminal and clone the distribution repository on your local machine.

We are nearly there...

### Prepare the ground first

First thing, create new branch for your proposed changes. Give branch a meaningful name. Before you make any changes, make sure the distribution is clean and installable i.e. no test failing. Lets follow the happy path and assume the distribution is clean and all test pass.

### Action now

This is your moment now, you are about to jump on somebody else's domain. So be extra **carefull** and **vigilant**. Please make sure you only touch the bits you intended to. Because sometimes your editor would play with **tab/spaces**. Don't try to change the coding *style* and *format*. This would more likely annoy the distribution's author.

Once you have made the necessary changes, commit and push the changes to your repository. Now go to GitHub web interface, it would help you to submit your first **Pull Request**. Double check your *commit* and make sure no other changes gone without your knowledge. Once you are happy then submit the Pull Request and give your reasons why you think your Pull Request is important.

**Congratulations**, you are now proud *contributor*. But don't stop here and move on to some other distributions while you wait for the response to your first Pull Request. Don't be *disheartened* if you don't get any response in the next few days. In my personal experience, I have received reply at times after 1 year. Sometimes, you get response within **minutes**.

### Need help?

If you need helping hand then feel free to contact me and we can arrange **Remote Pair Programming** to get you going. *Good luck* and all the very best.

I will go through more in details in the next article.