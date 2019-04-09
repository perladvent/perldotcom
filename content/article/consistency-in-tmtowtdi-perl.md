
{
  "title"       : "Consistency in TMTOWTDI Perl",
  "authors"     : ["alexandru-strajeriu"],
  "date"        : "2019-03-29T13:46:23",
  "tags"        : ["git","perlcritic","perltidy"],
  "draft"       : true,
  "image"       : "",
  "thumbnail"   : "",
  "description" : "Some tips on aiming for consistency in TMTOWTDI Perl",
  "categories"  : "development"
}

As a Perl developer I have a lot of freedom. TMTOWTDI (There's more than one way to do it) allows me to code how I want to code. I can solve a problem using whatever method I feel works best, whatever works for me. That’s a very cool thing to have, but at the same time, after working on someone else's code for a while, and dreading the whole experience, I can really understand TIMTOWTDIBSCINABTE (there’s more than one way to do it, but sometimes consistency is not a bad thing either)  better as a principle. 

I’ve been doing Perl for about 9 years. I’ve been around the block a few times, at Evozon we work on a few legacy projects, so I’ve seen my fair share of code that makes me a proponent of always code for the maintainer.

There’s a quote floating around the internet for quite some time now, that sums up things pretty well. 

“Always code as if the guy who ends up maintaining your code will be a violent psychopath who knows where you live.”

I’m not going to lie, I’ve been in a few situations where knowing the person who coded the monstrosity that I had to handle would have resulted in some very bad decisions on my part. 

Freedom is great, consistency is better. It’s better for you, when you end up working on your own code in a year, it’s better for your team and it’s better for whoever else will end up working on that project in the future. 

When you’re involved in a project that has more than 2 developers you will have different ideas and different ways of writing code. I work in a cross-functional team of more than 20 people and for a consistent looking code, we are using some small tricks that makes us happy on the long run, when it comes to maintainability. It improves code quality with the added benefit, hopefully, that some of the potential lurking bugs are eliminated.

We’re actually quite fortunate to have already made tools for this, all we need to do is actually use them, without impeding our normal workflow too much. 

My recommendation is a combination of git hooks, with [Perl::Critic]({{< mcpan "Perl::Critic" >}}) and [perltidy]({{< mcpan "perltidy" >}}). The latter might be more cosmetic than anything else, but I find it helpful. I know that there are other possible tools, but I think that these three are a good combination to use, in order to have practical coding standards and good looking code. 

I mentioned git hooks, instead of running the tidy and critic on a server, because using this method the other members of the team won’t be blocked out when working on larger features that usually need multiple developers. 

The first step is to create a new file in `.git/hooks/` and name it `pre-commit`. This way, when you type the commit command, this hook will execute on the files that are being committed.

In this file I will add our bash code:

```bash
#!/usr/bin/sh
files_commit=$(git diff --cached --name-only)

for file in $files_commit; do
    if [[ $file =~ pm|pl$ ]]
    then
        #run perlcritic first so that we avoid unnecessary tidying
        if ! [[ "$(perlcritic $file)" =~ 'source OK'  ]]; then
            echo >&2 "there was some error when running perlcritic on $file: $(perlcritic $file)"
            exit 1
        fi

        if [[ "$(perltidy -b -bext='/bk' $file)" -gt 0 ]]; then
         echo >&2 "There was an errror when running perltidy on $file; please see the error file for more info"
           exit 1
       fi
    fi
done

git add $files_commit


``` 

In this example, I am checking only for .pm and .pl files, you can add other type of files there too, like test files, pod files and so on.

The next step is to install perlcritic and perltidy on your system and add the configuration files to the root of the project.

For `.perlcriticrc` my suggestion is to start with the following configuration:
```
severity = 5
verbose = %f: [%p] %m at line %l, column %c (Severity %s).\n%d\n
```
This is the basic configuration version, you can add to it, based on your project and team needs. while also increasing the severity, based on your codebase and project needs; 

Increasing the severity might block simple changes from being commited, but it can also, on the long run, make your whole codebase more readable and easier to use. 

For `.perltidyrc` I would suggest to have a team discussion to determine the following items:

brace styling
length of lines (my suggestions is to have it at least 120 characters, but I know there are many people that still like it at 80 characters),
number of spaces or tabs per indentation 
whatever else you think that your team needs


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

For existing projects, which I’m sure, are most projects, an initial commit is needed. This will tidy all the files in the project so that each subsequent commit will only show the actual changes. 

To finish the setup, commit both `.perlcriticrc` and `.perltidyrc` to your repo and find an agreed upon way to share the hook file between the team members, so that it won’t overwrite personal changes/preferences. 

I know that this won’t solve every problem, but I think it’s a good step towards having a consistent and readable codebase.


