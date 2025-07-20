+++
authors = ["leo-lapworth"]
canonicalUrl = ""
categories = "community"
date = "2025-07-28T22:01:46"
description = ""
draft = false
image = "/images/metacpan-traffic-crisis/amelias-sad-face.jpg"
tags = []
thumbnail = "/images/metacpan-traffic-crisis/amelias-sad-face.jpg"
title = "MetaCPAN's Traffic Crisis: An Eventual Success Story"
+++

<p class="attribution">"<a rel="noopener noreferrer" href="https://www.flickr.com/photos/11946169@N00/9436653177">Amelia&#039;s Sad Face</a>" by <a rel="noopener noreferrer" href="https://www.flickr.com/photos/11946169@N00">donnierayjones</a> is licensed under <a rel="noopener noreferrer" href="https://creativecommons.org/licenses/by/2.0/?ref=openverse">CC BY 2.0 <img src="https://mirrors.creativecommons.org/presskit/icons/cc.svg" style="height: 1em; margin-right: 0.125em; display: inline;" /><img src="https://mirrors.creativecommons.org/presskit/icons/by.svg" style="height: 1em; margin-right: 0.125em; display: inline;" /></a>.</p>

[MetaCPAN.org](https://metacpan.org), the essential search engine for Perl's
CPAN repository, has faced months of severe traffic issues that brought the
service to its knees with frequent 503 errors. Here's how the team fought back
against an army of misbehaving bots and hostile traffic.

## The Problem Emerges

MetaCPAN began experiencing multiple 503 service errors daily, disrupting access
for legitimate Perl developers worldwide. Traditional monitoring failed to
identify the root cause of traffic spikes overwhelming the infrastructure.

## Initial Investigation Phase

The team implemented basic monitoring and took preliminary defensive measures:

- Deployed uWSGI stats monitoring tools to track application performance
- Updated robots.txt to explicitly list bots and specify crawling restrictions
- Began manual IP blocking of obvious bad actors
- Attempted to deploy Anubis rate limiting (ultimately failed and was rolled
  back)

## The Datadog Breakthrough

<div style="text-align: center; margin: 20px 0; display: flex; justify-content: center; align-items: center; gap: 50px;">
  <img src="/images/metacpan-traffic-crisis/dd_logo_h_rgb.svg" alt="Datadog logo" style="width: 40%;">
  <img src="/images/metacpan-traffic-crisis/fastlyLogo-red-SVG.svg" alt="Fastly logo" style="width: 40%;">
</div>

Partnership with Datadog transformed visibility into the problem:

- Established comprehensive logging pipeline sending Fastly CDN logs for both
  web and API services to Datadog
- Deployed Kubernetes Datadog agent to cluster
- Created public dashboard showing real-time traffic metrics
- Built private dashboard specifically to identify problematic IPs and user
  agents

**Result:** Finally able to see the enemy—specific IP ranges (particularly from
Alibaba.com) and user agents generating massive request volumes. However, manual
blocking proved unsustainable, requiring constant vigilance and rapid response.

## Escalating Defences

The team implemented more sophisticated blocking:

- Deployed VCL snippets in Fastly to block based on user agents (later replaced
  with Next Gen WAF)
- Blocked extensive IP ranges using Fastly's IP Block list feature
- Implemented additional request rate limiting
- Partnered with Fastly for free enterprise services including DDoS protection

**Limitation:** Manual processes couldn't keep pace with evolving attack
patterns.

## Next-Generation WAF Implementation

Deployment of Fastly's Web Application and API Protection:

- Enabled next-gen WAF to automatically identify and block suspect bots
- Implemented categorical blocking for known bad traffic types
- Reduced manual intervention requirements significantly

**Progress:** Noticeable improvement, but sophisticated attacks still
overwhelmed the service during peak periods.

## The Dynamic Challenge Solution

Final defensive layer was activated:

- Deployed Fastly's Dynamic Challenge WAF feature
- Intelligent challenge system filtered automated bots whilst allowing
  legitimate users through
- Dramatic reduction in successful attacks reaching MetaCPAN infrastructure

## Current State: Victory Through Data

## ![Bad bots traffic visualization](/images/metacpan-traffic-crisis/badbots.png)

![Traffic challenges chart](/images/metacpan-traffic-crisis/challenges.png)

Today's
[public Datadog dashboard](https://p.datadoghq.eu/sb/c2941b7b-37bb-11f0-94e3-32bf19abf102-744ae84f98611bfd6781365a482e2155)
tells the success story in real-time metrics:

In the last week the number of requests handled broke down as follows:

- 5,190,000 bad bot requests (this includes AI scrapers) blocked
- 3,290,000 challenges issued
- 579,000 requests rate limited
- 1,720,000 legitimate requests served (much of this from Fastly's CDN cache),
  with the remainder reaching the origin servers and being successfully served
  to end users.

So about 80% of all traffic is now blocked.

The numbers demonstrate the scale of the threat MetaCPAN faced and the
effectiveness of the layered defence strategy.

We have RSS feeds and a dedicated API which can be easily accessed through
[MetaCPAN::Client](https://metacpan.org/pod/MetaCPAN::Client) for anyone who
wants to get data from us without scraping the site. We do ask that people
[register their user agent](https://github.com/metacpan/metacpan-api/wiki/fastapi-Consumers).

## Community Heroes

This infrastructure battle was won through generous community support:

**Break down of steps can be found on ticket**
<https://github.com/metacpan/metacpan-k8s/issues/154>

**[Fastly](https://www.fastly.com/) and [Datadog](https://www.datadoghq.com/)**
deserve particular recognition for donating enterprise-grade services. Without
these contributions, MetaCPAN couldn't operate at the required scale and
reliability.

**Additional sponsors** listed at <https://metacpan.org/about/sponsors> continue
supporting this vital community resource, though operational costs remain
significant.

**How to help:** The Perl community can support MetaCPAN's ongoing operations
through <https://opencollective.com/metacpan-core>, ensuring this essential
service remains available for all developers.
