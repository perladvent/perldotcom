+++
canonicalUrl=""
categories="community"
date=2025-09-18T09:30:00
description="The Perl and Raku Foundation announces a generous USD 10,000 donation from Geizhals Preisvergleich in support of the Perl 5 Core Maintenance Fund. This funding enables critical bug fixes and security improvements that keep Perl stable and reliable for organisations worldwide."
draft=false
image="/images/geizhals-donates-to-tprf/geizhals_logo_official.svg"
thumbnail="/images/geizhals-donates-to-tprf/geizhals_logo_official.svg"
title="Geizhals Preisvergleich Donates USD 10,000 to The Perl and Raku Foundation"
authors=[
  "olaf-alders",
]
tags=[]
+++

Today The Perl and Raku Foundation is thrilled to announce a donation of USD
10,000 from [Geizhals Preisvergleich](https://geizhals.at). This gift helps to
secure the future of The Perl 5 Core Maintenance Fund.

> Perl has been an integral part of our product price comparison platform
> from the start of the company 25 years ago. Supporting the Perl 5 Core
> Maintenance Fund means supporting both present and future of a
> substantial pillar of Modern Open Source Computing, for us and other
> current or prospective users.

-- Michael Kröll of Geizhals Preisvergleich

> “Geizhals is not only providing core funding for the Perl ecosystem, but also
> supporting developers, actively contributing to European conferences, and
> employing Perl coders. Their interest in the strategic maintenance and
> development of Perl and CPAN is of great value to us all, and their
> investment is very much appreciated.”

-- Stuart J Mackintosh, President of The Perl and Raku Foundation

But who exactly is Geizhals, and why does their support matter so much to the
Perl community?

Geizhals Preisvergleich began in July of 1997 as a hobby project—and yes,
"Geizhals" literally translates to "skinflint" in English (they even operate
[skinflint.co.uk](https://skinflint.co.uk/) for UK users!). From those humble
beginnings, they've leveraged the power of Perl to scale up to serving [4.3
million monthly users](https://unternehmen.geizhals.at/). With Perl being a key
part of their infrastructure, they have generously decided to support the Perl
5 Core Maintenance Fund.

While many of us know about the Core Maintenance Fund, the specific problems it
addresses often remain invisible to users. I reached out to the maintainers
whose work is supported by this fund. This is what core maintainer Tony Cook
had to say:

> My work tends to be little things, I review other people's work which I think
> improves quality and velocity, and fix more minor issues, some examples would
> be:
>
> - a fix to signal handling where perl could crash where an external library
>   created threads ([#22487](https://github.com/perl/perl5/issues/22487))
>
> - fix a segmentation fault in smartmatch against a sub if the sub exited via a
>   loop exit op (such as last)
>   ([#16608](https://github.com/perl/perl5/issues/16608))
>
> - fixed a bug where a regexp warning could leak memory.
>
> - prevent a confusing undefined warning message when accessing a sub
>   parameter that was placeholder for a hash element indexed by an
>   undef key ([#22423](https://github.com/perl/perl5/issues/22423))

What Tony has highlighted are the kinds of bug fixes which collectively help to
ensure that Perl remains stable, secure and reliable for the many organisations
and individuals who depend on it.

With organizations like Geizhals Preisvergleich funding the work which Tony and
others put into maintaining the Perl 5 core, we can work together to ensure that
the Perl core continues to receive the maintenance which it deserves, for many
years to come. Whether you're a startup using Perl for rapid prototyping or an
enterprise running mission-critical systems, your support helps ensure Perl
remains reliable for everyone. Please join us on this journey.

For more information on how to become a sponsor, please contact:
<olaf@perlfoundation.org>
