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

Earlier I wrote about [why should you join CPAN Pull Request Challenge]({{< relref "why-should-you-join-cpan-prc.md" >}}). Now I will explain how to get your computer ready to work on your assignment. You can grab a Docker image and start hacking right away, or you can install everything you need on your computer.

### Option 1: The Docker Way

By using a Docker image that has everything you need, you can start working in minutes.

#### 1: Install Docker

On Ubuntu:

    $ sudo apt-get install docker.io

Alternatively, see the instructions for [macOS](https://docs.docker.com/docker-for-mac/install/) and [Windows](https://docs.docker.com/docker-for-windows/install/).

#### 2: Find out your system architecture

You need to figure out which one of i686 or x86_64 is right for you. On Ubuntu/macOS:

    $ uname --machine

On Windows:

    > wmic os get osarchitecture

#### 3: Fork & clone the repo

Now you need to fork and clone the Github repository you were assigned for the PRC. For example, I created this [fork](https://github.com/kyzn/App-p), and can clone it with:

    $ git clone https://github.com/kyzn/App-p ~/Desktop/App-p

#### 4: Run Docker

I have prepared a docker [image](https://github.com/kyzn/perlbrew-prc-dockerimage) which comes with the latest stable version of Perl (5.26.1), {{< mcpan "App::perlbrew" "perlbrew" >}}, {{< mcpan "App::cpanminus" "cpanm" >}} and {{< mcpan "Dist::Zilla" >}}, all pre-installed.

Here's how I would run docker on the repo I cloned in step 3:

    $ docker run -v ~/Desktop/App-p:/App-p -it kyzn/perlbrew-prc:x86_64

Where
  - `~/Desktop/App-p` is the local path to the repo
  - `/App-p` is the path of the directory inside the Docker image
  - `x86_64` is the system architecture from step 2

This will launch an Ubuntu image as root user, mounting the repository to `/App-p`. Git is installed, but you need to use your local (non-Docker) terminal to pull/push. The text editors Nano, vim, and emacs are installed in the image as well.

#### Building a Docker Image

If you tried both `x86_64` and `i686` and neither worked for you, you can build the docker image by hand. Note that this will take some time:

    $ git clone https://github.com/kyzn/perlbrew-prc-dockerimage
    $ cd perlbrew-prc-dockerimage
    $ docker build -t kyzn/perlbrew-prc:my_build .

Then use the same `docker run` command with your own `my_build` tag.

---

### Option 2: The Local Way

You can install the same tools to your computer; I've prepared instructions for macOS and Ubuntu. This usually takes about one to two hours.

#### Notes for macOS users

Perl, during its installation, will ask for permission for incoming network connections. Denying that request doesn't break anything for CPAN-PRC purposes.

Installing modules via `cpanm` might give you a permission error. In the terminal, run:

    $ sudo chown -R $USER:staff ~/.cpanm

This command changes the owner of the cpanm folder, which usually fixes the issue.

You need to install homebrew:

    $ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

#### 1: Install Perlbrew

Most systems come with a certain version of Perl installed. Yet it is often recommended not to tamper system Perl, as applications depend on its state. That's why we want to install a separate Perl for development purposes.

    $ curl -L https://install.perlbrew.pl | bash

Once it's done, it will ask you to add `source ~/perl5/perlbrew/etc/bashrc` to your `~/.bashrc`. You should do as instructed right away.

#### 2: Install Perl

Now that we have Perlbrew in place, we can go ahead and install a Perl on our own, keeping system Perl alone. I am going to suggest installing latest stable-version, which happens to be 5.26.1 at the time of this writing. You may run `perlbrew available` to see most common versions. Note that this will take a while.

    $ perlbrew install -j 4 perl-stable

There are two ways to use a Perl version with Perlbrew: `use` and `switch`. `use` is temporary, it goes away once you close the terminal. That's why I recommend `switch`, which will make it permanent.

    $ perlbrew switch perl-5.26.1

To make sure switch worked, check your Perl version in the terminal:

    $ perl -v

#### 3: Install cpanm

This is a {{< mcpan "App::cpanminus" "script" >}} that will help you install CPAN modules. There already is a client installed, called `cpan`. But, `cpan` requires configuration and is more verbose and slower than `cpanm`.

    $ perlbrew install-cpanm

To be sure you're using the perlbrew installed cpanm, run this command:

    $ cpanm | grep perlbrew

If the terminal displays any matching output, it worked.

#### 4: Install dzil

Many CPAN authors use {{< mcpan "Dist::Zilla" >}} to build and release their modules. The chances of your PRC assignment having a dist.ini file (dzil configuration) are high.

First you need to install a non-Perl dependency, openssl. On macOS:

    $ brew install openssl

And on Ubuntu:

    $ sudo apt-get install libssl-dev

Then install Dist::Zilla with cpanm. Note that this will take a while, as it has a lot of dependencies.

    $ cpanm Dist::Zilla

#### 5: Install reply (optional)

`reply` is a nice interactive shell that lets you play around.

Ubuntu users will need to install these missing dependencies:

    $ sudo apt-get install libncurses5-dev libreadline-dev

Now install `reply`:

    $ cpanm Term::ReadLine::Gnu Reply

---

Now you are ready to work on your assignment! Good luck!
