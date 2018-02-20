  {
    "title"       : "Setup your computer for CPAN-PRC",
    "authors"     : ["kivanc-yazan"],
    "date"        : "2018-02-20T09:00:00",
    "tags"        : ["pull-request", "git", "github", "cpan", "perl", "open-source"],
    "draft"       : true,
    "image"       : "",
    "thumbanail"  : "",
    "description" : "How to install Perl on your computer, or how to use a Docker image instead",
    "categories"  : "cpan"
  }

Earlier, I wrote about [why should you join CPAN Pull Request Challenge]({{< relref "why-should-you-join-cpan-prc.md" >}}). Now I will explain how to get your computer ready to work on your assignment. You can grab a Docker image and start hacking right away. Or, you can install everything you need to your computer.

### Option 1: The Docker Way

By using a Docker image that has everything you need, you can start working in minutes.

#### 1: Install Docker

- Ubuntu: `sudo apt-get install docker.io`
- OS X: [See Instructions](https://docs.docker.com/docker-for-mac/install/)
- Windows: [See Instructions](https://docs.docker.com/docker-for-windows/install/)

#### 2: Find your architecture

- You need to figure out which one of i686 or x86_64 is right for you.
- Ubuntu/OS X: `uname --machine`
- Windows: `wmic os get osarchitecture`

#### 3: Fork & clone the repo

- Go to GitHub, and fork the repository.
- `git clone git@github.com:kyzn/App-p.git ~/Desktop/App-p`

#### 4: Run Docker

- `docker run -v ~/Desktop/App-p:/App-p -it kyzn/perlbrew-prc:x86_64`
  - `~/Desktop/App-p` is your local path to repository
  - `/App-p` will be the path of same directory inside Docker image
  - `x86_64` at the end is architecture, which can be replaced with `i686`

This will launch an Ubuntu image as root user, mounting repository to `/App-p`. Perlbrew, latest stable perl (currently 5.26.1), cpanm, dzil and reply are all pre-installed. Git is installed, but you need to use your local terminal to pull/push. Nano, vim, and emacs are there as well, but you can also use your local editor.

#### Building Docker Image
If you tried both `x86_64` and `i686` and none worked for you, you can build the docker image by hand. Note that this will take some time.

- `git clone https://github.com/kyzn/perlbrew-prc-dockerimage`
- `cd perlbrew-prc-dockerimage`
- `docker build -t kyzn/perlbrew-prc:my_build .`
- Then use the same `docker run` command with your own `my_build` tag.

***

### Option 2: The Local Way

You can install the same tools to your computer. This usually takes about one to two hours.

#### Notes for OSX users

- Perl, during its install, will ask for permission for incoming network connections. Denying that request doesn't break anything for CPAN-PRC purposes.
- cpanm might give you a permission error. Run `sudo chown -R $USER:staff ~/.cpanm` in terminal to change owner of cpanm folder, which usually fixes the issue.
- You need to install homebrew: `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

#### 1: Install Perlbrew

Most systems come with a certain version of Perl installed. Yet, it is often recommended not to tamper system Perl, as applications do depend on its state. That's why we want to install a separate Perl for development purposes.

- `curl -L https://install.perlbrew.pl | bash`

Once it's done, it will ask you to add `source ~/perl5/perlbrew/etc/bashrc` to your `~/.bashrc`. You should do as instructed right away.

#### 2: Install Perl

Now that we have Perlbrew in place, we can go ahead and install a Perl on our own, keeping system Perl as is. I am going to suggest installing latest stable-version, which happens to be 5.26.1 at the time of this writing. You may run `perlbrew available` to see most common versions. Note that this will take a while.

- `perlbrew install -j 4 perl-stable`

There are two ways to use a Perl version with Perlbrew: `use` and `switch`. `use` is temporary, it goes away once you close terminal. That's why I'm going to recommend `switch`, which will make it permanent.

- `perlbrew switch perl-5.26.1`

Make sure switch worked. You should see your version in output of `perl -v`.

#### 3: Install cpanm

This is a script that will help you install CPAN modules. There already is a client installed, called `cpan`. But, `cpan` requires configuration and is often too verbose.

- `perlbrew install-cpanm`

Make sure it worked, by checking `which cpanm | grep perlbrew`.

#### 4: Install dzil

Most CPAN authors are using `dzil` to build and release their modules. Chances of your PRC assignment having a dist.ini file (dzil configuration) is very high.

- First, you need to install a dependency: `openssl`
  - OSX: `brew install openssl`
  - Ubuntu: `sudo apt-get install libssl-dev`
- Then install Dist::Zilla with cpanm. Note that this will take a while.
  - `cpanm Dist::Zilla`

#### 5: Install reply (optional)

- `reply` is a nice interactive shell that lets you play around.
  - Only needed in Ubuntu: `sudo apt-get install libncurses5-dev libreadline-dev`
  -  `cpanm Term::ReadLine::Gnu Reply`

***

Now you are ready to work on your assignment! Good luck!
