
{
  "title"       : "Consistency in TMTOWTDI Perl",
  "authors"     : ["alexandru-strajeriu"],
  "date"        : "2019-04-08T20:46:23",
  "tags"        : ["git","perlcritic","perltidy"],
  "draft"       : false,
  "image"       : "",
  "thumbnail"   : "/images/site/perl-camel.png",
  "description" : "Some tips for improving consistency in shared Perl codebases",
  "categories"  : "development"
}

As a Perl developer I have a lot of freedom. TMTOWTDI (There's More Than One Way To Do It) allows me to code how I want to code. I can solve a problem using whatever method I feel works best, whatever works for me. That's a cool thing to have, but at the same time, after working on someone else's code for a while and hating the experience, I can understand TMTOWTDIBSCINABTE (There's More Than One Way To Do It, But Sometimes Consistency Is Not A Bad Thing Either) better as a principle.

I've been coding in Perl for about 9 years. I've been around the block a few times, at Evozon we work on a few legacy projects, so I've seen my fair share of code that makes me a proponent of always coding for the maintainer.

There's a quote floating around the internet for quite some time now, that sums up things pretty well.

> Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live.

I'm not going to lie, I've been in a few situations where knowing the person who coded the monstrosity that I had to handle would have resulted in some very bad decisions on my part.

Freedom is great, consistency is better. It's better for you, when you end up working on your own code in a year, it's better for your team and it's better for whoever else will end up working on that project in the future.

When you're involved in a project that has multiple developers you will have different ideas and different ways of writing code. I work in a cross-functional team of more than 20 people and for consistent code, we use some small tricks that keeps the code easy to maintain - and us happy. Consistent code improves code quality and eliminates some potential bugs.

My recommendation is to use a git pre-commit hook that runs [Perl::Critic]({{< mcpan "Perl::Critic" >}}) and [perltidy]({{< mcpan "perltidy" >}}). The latter might be more cosmetic than anything else, but I find it helpful. I know that there are other possible tools, but I think that these three are a good combination to use, in order to have practical coding standards and consistent-looking code.

Set Up Perl::Critic and Perl::Tidy
------------------
You can install [Perl::Critic]({{< mcpan "Perl::Critic" >}}) and [Perl::Tidy](<{{ mcpan "Perl::Tidy" >}}) from CPAN or they might be available on your package manager. Once installed, you'll need to configure them.

For `.perlcriticrc` my suggestion is to start with the following configuration:
```
severity = 5
verbose = %f: [%p] %m at line %l, column %c (Severity %s).\n%d\n
```
These options are described in the Perl::Critic [documentation](https://metacpan.org/pod/Perl::Critic#CONFIGURATION).

This is a basic configuration, which you can build upon based on your project and team needs. Increasing the severity might block simple changes from being commited, but in the long run makes your codebase more readable and easier to use.

For `.perltidyrc` I would suggest to have a team discussion to determine the following items:

* brace styling
* length of lines (my suggestions is to have it at least 120 characters, but I know there are many people that still like it at 80),
* number of spaces or tabs per indentation
* whatever else you think that your team needs

Here is an example with my file:

```
-i=4
-ci=4
-bar
-ce
-nsbl
-cti=0
-sct
-sot
-pt=0
-sbt=1
-bt=1
-bbt=0
-nsfs
-nolq
-l=120
```

These are described in the Perl::Tidy [documentation](https://metacpan.org/pod/distribution/Perl-Tidy/bin/perltidy#FORMATTING-OPTIONS).

Commit both `.perlcriticrc` and `.perltidyrc` to your repo.

Set Up the Git Pre-commit Hook
------------------
For existing projects, you'll want to run perlcritic and perltidy on all existing files *before* creating this pre-commit hook, fixing any files which don't pass perlcritic or break perltidy. This is so that each subsequent commit will only be critiqued and tidied on the changes contained in the commit.

To setup the pre-commit hook, create the file `.git/hooks/pre-commit` in your root project directory. This file will be executed every time you type the `git commit` command and ru on the files included in the commit.

The file is a shell script:

```bash
#!/usr/bin/sh
files_commit=$(git diff --cached --name-only)

for file in $files_commit; do
    if [[ $file =~ pm|pl$ ]]
    then
        #run perlcritic first so that we avoid unnecessary tidying
        if ! [[ "$(perlcritic $file)" =~ 'source OK'  ]]; then
            echo >&2 "There was some error when running perlcritic on $file: $(perlcritic $file)"
            exit 1
        fi

        if [[ "$(perltidy -b -bext='/bk' $file)" -gt 0 ]]; then
         echo >&2 "There was an error when running perltidy on $file; please see the error file for more info"
           exit 1
       fi
    fi
done

git add $files_commit
```

For every file being committed, this code first runs perlcritic - if it reports a problem, then the script exits, canceling the commit. If perlcritic passes, then it runs perltidy on the same file, and if perltidy exits with an error, then it also aborts the commit. In this example, I am checking only for .pm and .pl files, you can add other type of files there too, like test files, pod files and so on.

I know that this won't solve every problem, but I think combining Perl::Critic and Perl::Tidy and running them automatically is good step towards having a consistent and readable codebase.
