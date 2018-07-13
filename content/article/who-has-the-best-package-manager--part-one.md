{
   "title" : "Who has the best package manager? Part one",
   "tags" : [
      "cpan",
      "metacpan",
      "npm",
      "pypi",
      "rubygems",
      "package_manager"
   ],
   "authors" : [
      "david-farrell"
   ],
   "date" : "2014-08-21T13:03:03",
   "draft" : false,
   "slug" : "110/2014/8/21/Who-has-the-best-package-manager--Part-one",
   "categories" : "cpan",
   "image" : "/images/110/27B53D22-28C9-11E4-BF47-7C15C254CEE0.png",
   "description" : "Who has the best package manager and what we can we learn from all of them",
   "thumbnail" : "/images/110/thumb_27B53D22-28C9-11E4-BF47-7C15C254CEE0.png"
}


Every major language has thousands of libraries which enable programmers to reach higher, further and faster than before. Package managers (the online systems for sharing code) are key to a language's success; Perl, PHP, Python, Ruby and Node.js all have strong offerings. But which one is the best and what can we learn from each of them? This article is the first in a two-part series where I review each package manager. Part one focuses on searching and using packages and part two will look at how easy it is to upload and share packages.

### Terminology

The term "package manager" isn't strictly accurate when referring to the online code sharing systems. [RubyGems](http://rubygems.org/) and [npm](https://www.npmjs.org/) are described as package managers but for Python [PyPI](https://pypi.python.org/pypi) is a package index and `pip` is the package manager. Similarly, [metacpan](https://metacpan.org) is a search engine for [CPAN](http://www.cpan.org/%20). I use the term "package manager" to refer to the commonly-used collection of tools used for searching, reviewing, installing and sharing code.

### Inputs and Scoring Criteria

The following package managers were reviewed:

-   [Packagist](https://packagist.org) for PHP
-   [PyPi](https://pypi.python.org/pypi) for Python
-   [metacpan](https://metacpan.org) for Perl
-   [npm](https://www.npmjs.org/) for Node.js
-   [RubyGems](https://rubygems.org/) for Ruby

Every package manager was scored against 5 criteria:

-   Search - how easy is it to find what you're looking for. An ideal search function would return the most relevant packages first, and provide information to help users differentiate packages.
-   Metadata - what supporting data is provided to give context and enable the user understand the package better: name, description, number of downloads, unit test coverage, portability, dependencies, user reviews etc/
-   Documentation - accessibility and usability of the package documentation. Easy-to-use documentation is clear and consistent in layout and provides useful information for would-be package consumers.
-   Source - accessibility and usability of the source code. The source code should be easily inspect-able which means providing an easily navigable directory tree and presenting the code in a readable, helpful way.
-   Installation - how easy is it to install a package: are instructions provided and does the installation work.

I scored each criterion between 1 and 5, with 5 being best. Clearly this is a subjective approach both in the criteria chosen and strength of the rating given. Whether the results are *useful* or not I leave for you, the reader to decide.

### Method

3 search terms were used: "selenium", "sqlite3" and "web framework". The search term was unquoted when entered. Selenium should be an easy search term as it's a unique name and common library (bindings to [Selenium WebDriver](http://docs.seleniumhq.org/projects/webdriver/)). SQLite3 is slightly more difficult as it includes a version number and many packages named "sqlite" are intended for SQLite3. Web framework is the most difficult as it is a description rather than a name and yet we wanted the search to return relevant results like Sinatra, Django, and express. For each language I used a recommended list of web frameworks as my target packages. In all searches I considered the sorting of relevant results and the usefulness of information provided in the search results.

Upon locating a target result in each search, I opened the package page and scored the other criteria. Only the packages returned by the 3 search terms were considered.

### PHP: Packagist

![](/images/110/pm_packagist.png)

First up is [Packagist](https://packagist.org/statistics), the largest PHP package search engine, with over 36,000 [packages](https://packagist.org/statistics) indexed. Packagist integrates with [Composer](https://getcomposer.org/), a PHP dependency management system.

Packagist auto-focused to the text search box and provided live search results as I entered the search terms. For every search result Packagist return the package name, description, number of downloads and star count. Search results were paginated and no facility for sorting or filtering the search results was provided.

![](/images/110/pm_packagist_search_selenium.png)

The search results were mixed: the target [selenium package](https://packagist.org/packages/alexandresalome/php-selenium) was returned 3rd on the list of results. The SQLite3 search did not return any useful packages (bindings to SQLite3), but this is perhaps because PHP 5.3 ships with a built in [SQLite class](http://php.net/manual/en/book.sqlite3.php). The Web Framework [search](https://packagist.org/search/?q=web%20framework) did not return any [target packages](http://mashable.com/2014/04/04/php-frameworks-build-applications/) in the top 20 results, with [Laravel](https://packagist.org/packages/laravel/framework) being returned 21<sup>st</sup>.

#### Search: 3/5

Packagist provided a basic set of metadata including: name, description, version number, download statistics, version history and dependencies. No package had license information, unit test coverage, platform compatibility or continuous integration results. There was no facility to "star" or review a module (presumably the star count on the search results came from GitHub).

![](/images/110/pm_packagist_laravel.png)

#### Metadata: 2/5

Documentation was sparse - a link was provided to the GitHub repo, which displays the repo readme by default. There seemed to be little consistency across packages in terms of headings or content.

#### Documentation: 2/5

Packagist linked to the source repos on GitHub. The code was easy to navigate although the directory tree structures were inconsistent.

#### Source: 3/5

Installation with PHP Composer is done by marking the target package as "required" in a json file. packages can be installed directly using Composer on the command line:

```perl
$ composer.phar require "laravel/framework": "4.2.8" 
```

Helpfully, Packagist listed the required text on every package page.

#### Installation: 5/5

##### Packagist overall: 3.0

### Python: PyPI

![](/images/110/pm_pypi.png)

Next up is Python's [PyPi](https://pypi.python.org/pypi), which has over 47,500 packages.

PyPI's search results returned the package name, a match-strength indicator called "weight" and a description. The search results for [Selenium](https://pypi.python.org/pypi/selenium/2.42.1) and [SQLite3](https://pypi.python.org/pypi/db-sqlite3/0.0.1) were good with the target libraries in the top 2 results each time.

![](/images/110/pm_pypi_search_selenium.png)

The search results for "web framework" were mixed: I was looking for common Python [web frameworks](https://wiki.python.org/moin/WebFrameworks) and only one, [Watson](https://pypi.python.org/pypi/watson-framework/2.2.7) was listed in the top 20 results. Django was 280<sup>th</sup> with Flask arriving 574<sup>th</sup> in the list. PyPI was the only package manager to not paginate search results, which made it easy to traverse search results results and export them. There was no function to filter or sort the results under different criteria.

#### Search: 3/5

The metadata provided varied from package to package, but PyPI usually provided: the last upload date, number of downloads, author name, package owner and maintainers, package homepage link and a DOAP.xml record. The [Watson](https://pypi.python.org/pypi/watson-framework/2.2.7) package included a build status with unit test coverage. Only 1 of the three packages provided a license. There didn't seem to be a facility to provide user reviews or "stars" which would indicate whether a package was any good or not.

![](/images/110/pm_pypi_selenium.png)

#### Metadata: 3/5

Documentation was mixed with either no documentation or just a high level synopsis provided. In most cases an external link to another site provided more documentation, but it's not consistent (it could be Google code, GitHub or a project-specific website).

#### Documentation: 2/5

All of the packages source code was hosted externally by GitHub or Google code and a link is provided by PyPI. This is fine, but it can take several hops to find the actual source code, and the structure of the source code tree varies from package to package; it might just be a collection of \*.py files in a root folder for example.

#### Source: 2/5

PyPI provides installation guidance on it's homepage. Additionally most of the reviewed packages' documentation contained command line code instructions for installing the packages. All three packages installed without a hitch using `pip`, although it appeared that no unit tests were run on install, so whether the packages work or not is an open question.

#### Installation: 5/5

##### PyPI overall: 3.0

### Perl: metacpan

![](/images/110/pm_metacpan.png)

[metacpan](https://metacpan.org/) is described as a CPAN [search engine](https://metacpan.org/about) and provides nearly all of the features of CPAN, plus many features that CPAN doesn't offer. It has been around since 2013, and indexes over 30,000 packages.

metacpan's search page autofocused on the text input search box and provide predictive text search. The search results contained the package name, description, an average review score (if there are any reviews), a count of "++"s (which are like GitHub stars) and the author name. Helpfully, sub-packages in the same namespace were indented below higher-level packages.

![](/images/110/pm_cpan_selenium_search.png)

The Selenium search returned the target package ([WWW:Selenium]({{<mcpan "WWW::Selenium" >}})) first, however SQLite3's target package ([DBD::SQLite]({{<mcpan "DBD::SQLite" >}})) was returned 17th in the search results. The Web Framework search results were not great: the first 20 results were for old frameworks or irrelevant packages. However the target packages (e.g. Catalyst, Dancer, Mojolicious and Kelp) were found in top 40 results. metacpan paginated the search results, 20 per page, which meant the target packages were actually on [page 2](https://metacpan.org/search?p=2&q=web+framework) . No method to filter or sort the search results was provided.

#### Search: 3/5

![](/images/110/pm_cpan_sqlite.png)

metacpan provided a wealth of package metadata: the package name, description, version number, activity histogram, issues list, CPAN Testers [results](http://www.cpantesters.org/distro/D/DBD-SQLite.html?oncpan=1&distmat=1&version=1.42) (an external CI platform that runs the package against many different operating systems and Perl versions to detect portability issues), [kwalitee](http://cpants.cpanauthors.org/kwalitee) rating, reviews and "++" counts. It also provides a dependencies list, a dependent packages list and a nifty dependencies chart. This example is for [WWW::Selenium]({{<mcpan "WWW::Selenium" >}}):

Curiously metacpan did not provide download statistics for any package. This would seem like a useful quality indicator for users. metacpan may suffer a little from "information overload" - there were so many links and metrics it could be hard for a user to disseminate the important metrics from the noise. Although metacpan listed the license name, it didn't provide a link to the underlying license text which would be useful. Unit test coverage was not reported.

#### Metadata: 5/5

Documentation was extensive, except in the case of the web framework package (Dancer) which includes high-level examples and then links for documentation contained in other packages. What was especially nice was that the documentation was easily accessible and consistently styled across all three packages as it was all presented though metacpan.

#### Documentation: 5/5

A direct link to the source code was provided on every package page. The source code is also hosted on metacpan and consistently styled. Some useful measures were provided: the number of lines of code, the number of lines of documentation and the file size in kilobytes. I was also able to toggle on and off the inline documentation (called "Pod") and view the code raw. Another useful feature: every package reference in the source code is a hyperlink to the source code of that package.

However it was not clear how to navigate the package tree (the links are in the name of the package itself). One package was hosted on GitHub and a direct link to the repo was provided on the package page - so the user has the option of viewing the source on GitHub if they prefer it to metacpan.

#### Source: 5/5

No information was provided by metacpan on how to install a module.

#### Installation: 1/5

##### metacpan overall: 3.8

Node.js: npm

![](/images/110/pm_npm.png)

[npm](https://www.npmjs.org/) is the Node.js package manager. It boasts over 89,500 packages, which is the most of any package manager in this review.

The npm search results were good: although the target Selenium [package](https://www.npmjs.org/package/selenium-webdriver) was 7th in the list of results, both the SQLite3 and Web Framework searches returned the target packages ([sqlite3](https://www.npmjs.org/package/sqlite3), [](https://www.npmjs.org/package/express)express) first in the results list. npm displayed the package name, description, download statistics, a "star" count and a keyword list. The search results were paginated and no filtering or sorting function was provided.

![](/images/110/pm_npm_search_webf.png)

#### Search: 5/5

npm provided a useful set of metadata including: download statistics, license, issues link, version, dependencies and dependant packages When available it also pulled the Travis CI status from GitHub. No information was provided regarding unit test coverage or platform availability. There didn't seem to be a function for adding user reviews of packages to npm.

![](/images/110/pm_npm_express.png)

#### Metadata: 4/5

Documentation was poor - npm just displayed the package readme. Although the documentation was consistently styled, it was not consistent in layout or content. Every package used different headings and different content.

#### Documentation: 2/5

npm just provided links to the source repo. The Selenium [repo](https://code.google.com/p/selenium/) was on Google Code and npm provided the URL but did not link to it. The Selenium source code link did not even direct to the Node.js package - it went to the main Selenium source code. The other two packages (SQLite3, express) were better: they were GitHub hosted with consistent package trees (lib and test directories) and it was easy to browse the source.

#### Source: 3/5

The npm homepage explained how to install a package, and linked to a more detailed page of examples. Every package page included installation instructions. All three packages installed without issue. It wasn't clear if any unit tests were run as part of installation.

#### Installation: 5/5

##### npm overall: 3.8

### Ruby: RubyGems

![](/images/110/pm_gem.png)

[RubyGems](https://rubygems.org) is the Ruby package manager and has over 87,000 packages.

RubyGems search was mixed, for the SQLite3 and Selenium searches the target package was returned in the top 2 results. However RubyGems returned no results for the Web Framework search, which given the popularity of Ruby on Rails is astonishing. For each search result RubyGems displayed the package name, description and number of downloads. Results were paginated and no facility was provided for sorting or filtering the results returned.

![](/images/110/pm_gem_search_webf.png)

#### Search: 2/5

A basic set of metadata was provided: package name, description, author(s), version number, download statistics, license name, dependencies and a version history time line. There was no facility to "star" or review a module. No information was provided regarding cross platform support or unit test coverage.

![](/images/110/pm_gem_sqlite.png)

#### Metadata: 2/5

RubyGems' documentation consisted of a link to an external site. The SQLite3 package used [RubyDoc](http://rubydoc.info/) which is like a nicer-looking JavaDoc. Selenium-Webdriver used Google code and in the case of Sinatra, their own [website](http://www.sinatrarb.com/). The documentation was inconsistent in style, layout, content and quality.

![](/images/110/pm_gem_sqlite_doc.png)

#### Documentation: 2/5

RubyGems provided a link to the externally hosted repo for 2 packages ([Sinatra](http://rubygems.org/gems/sinatra), [Selenium-Webdriver](http://rubygems.org/gems/selenium-webdriver)). The Selenium source code [link](https://code.google.com/p/selenium/source/list) was to the base Selenium package, not the Ruby package. For the SQLite3 package no link to the source code was provided.

#### Source: 2/5

Every package page provided command line installation instructions. However on my machine (Fedora 19), 2 of the packages failed to install with the same error: `mkmf.rb can't find header files for ruby`. I was able to install the packages using the Fedora package manager instead.

#### Installation: 2/5

##### RubyGems overall: 2.0

### Conclusion

[npm](https://www.npmjs.org/) and [metacpan](https://metacpan.org/) both scored 3.8 and tied for first place. npm has a great search feature, but needs better documentation. No package manager provided a means for sorting or further filtering the search results, which seems like a missed opportunity - it would be very helpful to be able to sort search results by the date of last upload - this would help the user eliminate stale packages from the results.

metacpan's search could have been better but it's documentation was excellent. It's interesting that CPAN enforces almost zero requirements on documentation, yet overall it scored the highest. This might be because the underlying CPAN toolchain is 19 years old and has well-established conventions. metacpan also presented the source code nicely with several enhancements to make it easier, such as being able to toggle the display of inline documentation. metacpan should provide installation instructions for every package, which would be easy boilerplate using the `cpan` command line tool. The distributed network of CPAN mirrors may mean that download statistics are not easily available to metacpan, but it could be a useful addition to the rich set of package metadata that metacpan provides.

PyPI and Packagist were all-rounders, with each scoring 3.0. In both cases better documentation and more package metadata would make them more usable.

RubyGems score of just 2.0 leaves room for improvement in all areas. I'm guessing but I think the strange search results could be improved by searching the package description as well as the package name, so that searches for "web framework" returns results.

In part two I'll consider how well each of these package managers enables users to upload and share packages.

### Evaluation

The results are subjective but I hope they're approximately representative. Choosing different search terms could have changed the results significantly - perhaps different packages are better documented than others for example. Also the uniform weighting given to each of the criteria could be changed to reflect the relative importance of each criterion (is search is more important than source code accessibility?). Also don't rule out author ignorance :). The list of package managers could also be expanded. I've focused here on scripting language package managers, but there are [many](http://www.modulecounts.com/) to choose from.

### Thanks

Thanks to Neil Bowers for providing the initial idea and feedback on this article. All errors are my own.

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
