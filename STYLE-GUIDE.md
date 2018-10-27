Style Guide
===========

This document is intended to guide Perl.com authors in producing articles that are consistent with the aims of the website. None of this is set in stone - **great writing should always prevail**.

Goal
----
We aim for reasoned, insightful, professional writing with a lighthearted bent.

Politics / Tone
---------------
- We are pro: Perl, Open Source and free software
- No rants or "hit pieces"
- Reasoned criticism is fine

Language
--------
- American English
- Approximately 300-1,000 words per article
- Simple English (use [hemingway](http://www.hemingwayapp.com/) to help)
- Prefer the first-person and avoid the passive voice

Conventions
-----------
- When mentioning Perl modules for the first time, provide a link to the module on [metacpan](https://metacpan.org/); thereafter refer to them in plaintext. Do not quote them (e.g. Data::Dumper).

- Code should be formatted inline as `code` or in:

    code blocks

- Use header 3 for subtitles and header 4 for sub-subtitles (this might [change](https://github.com/tpf/perldotcom/issues/143).

Tips
----
These are things I've learned along the way that have improved my writing. Older articles on our website don't necessarily follow these but would be better off if they did.

- Don't start an article with a justification: "I thought it would be interesting to take a look at ...". You can nearly always delete paragraphs like these. Assume that what you're writing about is interesting; you don't need an introductory paragraph.
- Research your claims. If you are unsure about the behavior of a module or a function, go read the docs, experiment with it yourself until you are sure. Your knowledge may be out of date.
- Emphasis is **rarely** needed.
- Delete unnecessary words. Adverbs are a good place to start: "I was very disappointed" -> "I was disappointed". This goes for code too. Only show what you need to show to communicate your point; big blocks of code are hard to follow.
- Try to avoid comments in code: that's what the article text is for!
- Use subheadings to divide an article into manageable, logical pieces.
- Tell stories: "This week at work I was struggling with x, here's how I figured it out" is a more interesting beginning than "If you run into this problem here's what to do".
- Know your audience: are you writing for experienced Perl programmers or beginners? One group needs much more explanation and simplification than the other. This applies to your code too: for beginners, several code statements are clearer than interconnected `join map split` expressions.
- Be enthusiastic, humble, honest, and acknowledge others' work.

&copy; Perl.com
