{
   "categories" : "linux",
   "title" : "Perl and Mandrakelinux",
   "image" : null,
   "date" : "2005-02-24T00:00:00-08:00",
   "tags" : [
      "mandrakelinux",
      "apps",
      "graphics",
      "pumpking"
   ],
   "thumbnail" : "/images/_pub_2005_02_24_mandrakelinux/111-mandrakes_gui.gif",
   "authors" : [
      "mark-stosberg"
   ],
   "draft" : null,
   "slug" : "/pub/2005/02/24/mandrakelinux.html",
   "description" : " Perl programmers have a special reason for choosing Mandrakelinux as their desktop operating system. Mandrakelinux uses Perl for dozens of the graphical \"value added\" utilities included with the distribution, including much of the Mandrakelinux Control Center. I asked Mandrakelinux..."
}



*Perl programmers have a special reason for choosing [Mandrakelinux](http://www.mandrakelinux.com/) as their desktop operating system. Mandrakelinux uses Perl for dozens of the graphical "value added" utilities included with the distribution, including much of the Mandrakelinux Control Center. I asked Mandrakelinux for an interview with a top Perl contributor and they sent [Rafael Garcia-Suarez](http://rgarciasuarez.free.fr/) my way. Besides being heavily involved with Perl at Mandrakesoft, Rafael is also the pumpking for the Perl 5.10 release. Rafael answered my questions about using Perl for GUI programming and how he balances his day job with being pumpking.*

**O'Reilly Network:** Briefly tell us about the Perl work you do for Mandrakelinux.

**Rafael:** My main responsibility is to maintain and enhance the command-line tool urpmi (and its GUI counterpart rpmdrake), which are the Mandrakelinux equivalent of Debian's apt or Fedora's yum; that is, fetching RPMs and their dependencies and installing or upgrading them.

This job extends to whatever pertains to installing RPMs; that means that I also participate in enhancing Mandrakelinux's installer. All those tools are written in Perl.

Besides this, I also maintain the RPM of perl itself and of a load of CPAN modules for Mandrakelinux.

**ORN:** Perl is uncommon choice for graphical programming, yet Mandrakelinux has used Perl for over 50 graphical applications. Many of these tools are specific to Mandrakelinux, adding value to the distribution. What can you tell us about why Mandrakelinux uses Perl for this important role?

**Rafael:** Not all tools were always written in Perl. However using consistently a same language allows to share and reuse libraries across all tools, be it the perl/rpmlib bindings or custom graphical toolboxes. Thus, for example, the OS installer shares code with urpmi and rpmdrake. A scripting language was preferred because of rapidity of development and ease of debug -- attempts at writing rpmdrake in C were painful, although that was before I was hired by Mandrakesoft. Perl was a natural choice since there were already very good in-house skills for it.

*Editors note: Recently, the [Linspire](http://www.linspire.com/) distributionexemplified the use of dynamic languages to bring a graphical application to market quickly. Their [Lsongs](http://info.linspire.com/lsongs/) nd [Lphoto](http://info.linspire.com/lphoto/) programs use Python.*

**ORN:** Could you give a specific example of where Perl has made a noticeable difference in shortening development time?

**Rafael:** I think that using a scripting language in general shortens the development time, notably due to the shorter write code / compile / test / debug cycle. However perl is particularly useful due to the high number of development modules available on CPAN. For example running the OS installer under [Devel::Trace]({{<mcpan "Devel::Trace" >}}) produces lots of logs, but is tremendously helpful to trace obscure bugs. You can't do this in C without adding `printf`s everywhere and recompiling the whole stuff.

**ORN:** What tools does Mandrakelinux use for automated testing of graphical Perl applications?

**Rafael:** Er, interns ?

More seriously, there is no automated testing for GUIs. Automated testing of such applications raises several difficult problems, since they often modify a system's configuration or necessitate some specific hardware (and I'm not even speaking of the OS installer GUI).

Writing more unit tests is definitively something I want to do in the future, however; it would be very useful to have complete sets of regression tests for the urpmi dependency solver, for example.

**ORN:** What has been the response of the Perl community to Mandrakelinux Perl-based tools, especially in terms of contributing patches back to your organization?

**Rafael:** The people who send patches for the tools are mostly interested in improving the distribution they use; even if they might belong to the Perl community as well, their point of view is the one of a Mandrakelinux user. That's one of the reasons why the tools have little visibility outside the MDK community.

Another reason is that there never was a strong motivation in Mandrakesoft for splitting the libraries in what is and is not MDK-specific, and to write clear and comprehensive documentation: both need efforts, don't pay immediately and are likely to be postponed when you have deadlines.

However, the CVS repository in which the tools' source code is kept is openly accessible; some contributors (i.e. non Mandrakesoft employees) have been granted commit access to it. We now need to make the learning curve softer.

**ORN:**What advice do have for Perl programmers interested in contributing to the Perl-based Mandrakelinux utilities? Any helpful hints for getting started?

**Rafael:** As with any open-source project, if you want to learn how it's done and to contribute, use the latest version available. In the case of Mandrakelinux, that would be "cooker", the development distribution. Subscribe to the mailing list, become familiar with the tools, have a checkout from the CVS repository, get yourself a Bugzilla account and don't be afraid to ask questions. Learning to build RPMs, at least to be able to rebuild the RPMs of the tools, would be helpful too. Those questions are covered in the wiki; a good page to begin with is:

> <http://qa.mandrakesoft.com/twiki/bin/view/Main/HowTo>

**ORN:** What challenges have you faced maintaining Perl as a core part of the operating system, with so many key utilities depending on it?

**Rafael:** There are two kinds of challenges: spatial and temporal, would I say.

First, spatially, you have to devise how to split the standard Perl distribution on smaller packages ("perl-base" for the essentials, "perl" for the rest of modules, "perl-devel" for Perl development tools and "perl-doc" for, well, perldoc itself and the standard documentation.) This split is not arbitrary. When you maintain a core tool like urpmi, which is essential to system administration, you don't want it to require too many Perl modules, or even too many core modules. (The same goes for the installer, that must not take all the space on the installation CDs). So perl-base contains the modules used by urpmi, and urpmi doesn't use modules that are in perl but not in perl-base.

**ORN:** Perl has a reputation for being "slow" when used for graphical programming. How is that addressed in Mandrakelinux applications?

**Rafael:** I think that Perl doesn't deserve this reputation, only some Perl programs do ! The MDK tools use the perl-Gtk2 bindings (mostly for historical reasons, the Qt bindings weren't mature enough when the development of those tools started); and since they're pretty close to the C lib, performance is very acceptable.

Did you know that the game [Frozen Bubble](http://www.frozen-bubble.org/), written by a former Mandrakesoft employee, is implemented in Perl ? It's not anywhere near slow. Actually people are often surprised to learn that Frozen Bubble or the MDK tools are written in Perl, since they don't give the impression of slowness generally associated to scripted GUIs.

In fact, it appears that the speed bottlenecks of the MDK tools are, like in other programs, data processing, not display.

**ORN:** You've recently become the pumpking for Perl 5.10. How does your this interact with your day job and how do you balance the two positions?

**Rafael:** I was deeply involved in the development of Perl 5 before that, taking time to review and apply patches and so on. So I was mostly working on it on evenings and week-ends. I can now work on Perl 5 during my dayjob, since Mandrakesoft allows its developers to work on free projects they like part time. However, I'd point out that my day job is a bit special, since, contrary to proprietary projects, I'm always in contact with its community of users, via mail, IRC or other internet-based media (and even sometimes in real life.) Thus I'm sometimes led to work during my free time as well... In other words the frontier between day job and other open source development is blurred. In both cases things have to be done. The only difference is that for the day job thing, I have deadlines, and they pay me for it.

**ORN:** Do you have a favorite Perl module that more people should know about?

**Rafael:** I don't really know, I learn new modules mostly by hanging around in places where the cool kids discover them before me -- mailing lists, mongers, [use.perl](http://use.perl.org/). I use [B::Concise]({{<mcpan "B::Concise" >}}) all the time, but I suspect it's not useful for people who are not familiar with the internals of perl. Also, recently, I found [encoding::warnings]({{<mcpan "encoding::warnings" >}}) useful for debugging Unicode-related bugs.
