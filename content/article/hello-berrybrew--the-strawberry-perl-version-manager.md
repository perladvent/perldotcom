{
   "tags" : [
      "windows",
      "perlbrew",
      "config",
      "berrybrew",
      "strawberry_perl"
   ],
   "title" : "Hello berrybrew, the Strawberry Perl version manager",
   "thumbnail" : "/images/119/thumb_64514578-501F-11E4-99D5-54C0636C7830.png",
   "draft" : false,
   "image" : "/images/119/64514578-501F-11E4-99D5-54C0636C7830.png",
   "categories" : "apps",
   "date" : "2014-10-10T12:39:52",
   "description" : "A fruitier perlbrew for Windows",
   "authors" : [
      "david-farrell"
   ],
   "slug" : "119/2014/10/10/Hello-berrybrew--the-Strawberry-Perl-version-manager"
}


[Perlbrew](http://perlbrew.pl/) and [plenv]() are tools for managing local Perl installations. They're useful as they let you install and use multiple versions of Perl without administrator privileges. I have a special appreciation for them as I once tried to upgrade my mac system Perl and instead wrecked it and had to reinstall OSX.

When I'm on Windows I use Strawberry Perl, so I wrote [berrybrew](https://github.com/sillymoose/berrybrew) to help manage Perl on Windows. It's similar to Perlbrew and plenv; it will download, install and manage multiple versions of Strawberry Perl for you, no administrator privileges required.

### Installation

berrybrew is written in C\#. If you have git you can install berrybrew by cloning the GitHub [repo](https://github.com/sillymoose/berrybrew) and either using the pre-compiled binary, or minting your own with Mono. The pre-compiled binary is `bin/berrybrew.exe` and should work out of the box on Windows 7 and 8 (it might work on Windows XP if you have .Net framework 2 or higher installed).

To download the project with git and compile it with [Mono](http://www.mono-project.com/) type the following commands at the terminal:

```perl
> git clone https://github.com/sillymoose/berrybrew
> mcs src/berrybrew.cs -lib:lib -r:ICSharpCode.SharpZipLib.dll -out:bin/berrybrew.exe
```

This will output a fresh binary in the `bin` directory.

### Features

The `available` command lists available Strawberry Perls and whether they're installed:

```perl
> berrybrew available

The following Strawberry Perls are available:

            5.20.1_64 [installed]
            5.20.1_32 [installed]
            5.18.4_64
            5.18.4_32
            5.16.3_64
            5.16.3_32
            5.14.4_64
            5.14.4_32
            5.12.3_32
            5.10.1_32
```

The output shows that I have both versions of Perl 5.20.1 installed. I can install another version using the `install` command:

```perl
> berrybrew install 5.10.1_32
Downloading http://strawberryperl.com/download/5.10.1.2/strawberry-perl-5.10.1.2-portable.zip to C:\Users\dfarrell\AppData\Local\Temp\gp5d33yg.qjo/strawberry-pe
rl-5.10.1.2-portable.zip
Confirming checksum ...
Extracting C:\Users\dfarrell\AppData\Local\Temp\gp5d33yg.qjo/strawberry-perl-5.10.1.2-portable.zip

The following Strawberry Perls are available:

            5.20.1_64 [installed]
            5.20.1_32 [installed]
            5.18.4_64
            5.18.4_32
            5.16.3_64
            5.16.3_32
            5.14.4_64
            5.14.4_32
            5.12.3_32
            5.10.1_32 [installed]
```

berrybrew will download a temporary zip archive, confirm the checksums match, and extract the files to `C:\berrybrew`. Finally I can use the newly installed Perl with the `switch` command:

```perl
> berrybrew switch 5.10.1_32
Switched to 5.10.1_32, start a new terminal to use it.
```

This updates my user `%PATH%` environment variable to point at the new Perl binary. berrybrew will also warn if it finds another Perl binary in the system or user path (such as an ActiveState or vanilla Strawberry Perl). The system path can be problematic as Windows appends the user path to the system path which means it will search the system path first for any matching Perl binary and if it finds one, it will ignore the berrybrew binary. The system path also requires administrator privileges to update, which kind of goes against the spirit of berrybrew. One way to handle these would be to ask the user if they want to remove the other path, if they say yes, then berrybrew could prompt for administrator credentials, fire up another berrybrew process and remove them. For now it just warns the user and leaves the path variables untouched.

### Conclusion

I plan to add a few more commands to berrybrew: `exec` to run a Perl program against every installed Perl, `uninstall` to remove a Perl and `config` to manage berrybrew's settings. Under the hood a feature I'd love to add but am not sure how, is to refresh the current shell's environment variable block, so the user doesn't have to start a new cmd.exe when switching to a new Perl version.

It's early days but if you have any suggestions for new features or feedback drop me an email or fork the project on [GitHub](https://github.com/sillymoose/berrybrew).

\
*This article was originally posted on [PerlTricks.com](http://perltricks.com).*
