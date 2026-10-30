  {
    "title"       : "Who Keeps the Lights On? Building Resilience in the Perl Ecosystem",
    "authors"     : ["ruth-holloway"],
    "date"        : "2026-10-30T06:00:00",
    "tags"        : ["perl-toolchain-summit", "pts"],
    "draft"       : true,
    "image"       : "/images/perl-toolchain-summit-key-results/pts-2026-group-photo.jpg",
    "thumbnail"   : "/images/perl-toolchain-summit-key-results/pts-2026-group-photo.jpg",
    "description" : "Exploring the resilience of Perl's critical infrastructure, the people who maintain it, and how the 2027 Perl Toolchain Summit can help secure its future.",
    "categories"  : "community"
  }
  
# Who Keeps the Lights On? Building Resilience in the Perl Ecosystem

Perl has been around for nearly four decades. During that time, an extraordinary collection of tools, services, libraries, and infrastructure has grown up around it. Much of that work is so reliable that most of us rarely give it a second thought.

We install modules from CPAN. We search MetaCPAN. We run tests, build distributions, and release software. The machinery works, and we get on with our day.

But behind that machinery are people. Some of them have been maintaining critical pieces of the ecosystem for years, even decades. Much of their work is volunteer labor, carried out alongside their jobs and families.

What happens when one of those people needs to step away?

That's a question I've been thinking about quite a lot lately.

## Resilience Is About More Than Servers

In my work with The Perl and Raku Foundation, I've begun exploring what we're calling an *ecosystem resilience audit*.

The idea is straightforward: identify the important services and infrastructure on which the Perl community depends, understand the risks to their continued operation, and look for practical ways to reduce those risks.

Some of those risks are purely technical: 
  - Are there backups? 
  - Is the infrastructure documented? 
  - Can a failed system be rebuilt? 
  - Are credentials and administrative access managed in ways that don't depend on a single person?

Others are human: 
  - Does anyone else understand how the system works? 
  - Is there a clear path for bringing new maintainers aboard? 
  - Can responsibility be shared without placing an unreasonable burden on the people already doing the work?

And perhaps most importantly, are we asking those questions *before* something goes wrong? A system can have excellent uptime and still be fragile. If one person holds all the knowledge needed to maintain it, that system has a vulnerability no monitoring dashboard can detect.

## Learning From the People Who Do the Work

An audit like this can't be conducted entirely by examining source code or infrastructure diagrams.

 - We need to talk with the maintainers.

 - We need to understand how systems are operated in practice, where responsibilities overlap, what documentation already exists, and what kinds of assistance would actually be useful.

 - We also need to approach those conversations with respect. The goal isn't to find fault with volunteers who have already given an extraordinary amount of their time. It's to understand how we can support them and make their work easier to sustain.

That is one reason I'm attending the 2027 Perl Toolchain Summit in Lyon, France.

The Summit brings together many of the people responsible for the tools and infrastructure that keep Perl working. For four days, participants collaborate on difficult problems, exchange knowledge, and make progress that can be hard to achieve through scattered conversations throughout the year.

For the resilience effort, that concentration of experience is a big opportunity. I hope to use the Summit to listen, learn, identify areas that deserve closer examination, and begin building a practical picture of the ecosystem's long-term sustainability.

This is exploratory work, not a promise that every problem can be solved in four days. But it is an opportunity to establish relationships and gather the understanding needed to make meaningful progress afterward.

## What Comes Next

My intention is to turn what we learn into useful recommendations.

That might mean identifying services that need better documentation, opportunities to distribute maintenance responsibilities, or places where modest investments of time or money could substantially reduce risk.

It may also mean recognizing work that is already being done well and finding ways to apply those practices elsewhere.

I intend to publish a report on the effort, describing the findings and recommended next steps that can appropriately be shared publicly. Some operational and security details will necessarily remain private.

Ultimately, I'd like this work to help us answer a simple question:

**What can we do today to make sure the Perl ecosystem remains healthy tomorrow?**

## Why the Toolchain Summit Matters

The Perl Toolchain Summit has a long history of producing tangible results.

Its participants work on the systems that developers use every day: testing infrastructure, distribution tools, security processes, metadata, and the services that connect them.

The Summit is not a conventional conference. It's a working event, where the most important outcomes are often improvements to software, agreements on technical direction, and the transfer of knowledge between maintainers.

That last outcome is particularly important for resilience.

When experienced contributors work alongside newer ones, knowledge spreads. When maintainers discuss their systems face-to-face, assumptions can be challenged and problems that have lingered for months can finally move forward.

Those benefits don't end when everyone goes home.

## Help Make the 2027 Summit Possible

The Perl Toolchain Summit is supported by sponsors and donors who recognize the importance of this work.

The organizers try to cover participants' travel and accommodation expenses so that the cost of attending doesn't prevent important contributors from taking part.

But those costs add up, and the Summit's financial resources are limited.

**If your company relies on Perl, CPAN, or the tools that support them, please consider sponsoring the 2027 Perl Toolchain Summit.**

Individual contributions are welcome, too.

Your support brings maintainers together, gives them uninterrupted time to collaborate, and creates opportunities to share the knowledge that keeps Perl's infrastructure running. Those connections are essential to building a more resilient ecosystem for the future.

The software we rely on doesn't maintain itself. People maintain it. Let's make sure they have the support they need to keep doing so.

**To sponsor the 2027 Perl Toolchain Summit**, visit the [official sponsorship page](https://perltoolchainsummit.org/pts2027/sponsors.html) or contact the organizing team at **pts2027@perltoolchainsummit.org**.

---

*Ruth Holloway is Co-Treasurer of The Perl and Raku Foundation and a longtime member of the Perl community. She is pursuing an initiative to examine the resilience and long-term sustainability of Perl's critical infrastructure.*

*The views and proposed work described here are the author's; specific audit activities and deliverables remain subject to coordination with the relevant maintainers and organizations.*

