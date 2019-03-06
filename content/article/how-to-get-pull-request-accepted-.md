
  {
    "title"       : "How to get Pull Request accepted?",
    "authors"     : ["mohammad-anwar"],
    "date"        : "2018-12-04T13:17:31",
    "tags"        : [],
    "draft"       : true,
    "image"       : "",
    "thumbnail"   : "",
    "description" : "Share the secrets to get PR approved",
    "categories"  : "cpan"
  }

Recently, someone I met online and respected name in Perl community, asked me if I can share how to get Pull Request accepted. I have been submitting PR for over 4 years and have seen different various patterns in the acceptance of PR.

### Keep it simple and short
The golden rule is `"Keep the change simple and minimal"`. Why? Always remember the distribution owner doesn't have time to go through big changes in a single sitting. So it is better to split the big changes into smaller units. Ideally one change per PR. If you fancy then you may want to have one change per commit in a PR. But the downside is, if a PR has more than 2 commits then you are back to square one, expecting the owner to spend too much time to review. So keep it simple, one PR one commit. 

### Pick the right distribution
The second most important thing to keep in mind, pick the distribution whose owner is active i.e. doing regular releases. This way you have more chance of PR being reviewed and accepted. The [MetaCPAN](https://metacpan.org/) helped me in picking the right distribution. How? Well, if you view the distribution homepage on [MetaCPAN](https://metacpan.org/recent?size=500), you should see a link to `"Kwalitee"` in the left handside. I follow this link every time I see something new pushed. I owe a big `THANK YOU` to the creator and team behind the [CPANTS](https://cpants.cpanauthors.org/) site. Thanks to `MetaCPAN` team for providing the link. However, not every recently uploaded distribution would have `"Kwalitee"` data available straight away. In my experience, it is only available about an hour after the upload. So if the MetaCPAN [recent uploads](https://metacpan.org/recent?size=500) page, you see the `"distribution"` says `"an hour ago"` or more, then it is likely the `"Kwalitee"` data is available. If you look through the `"Kwalitee"` data, you will get the instant insights what can be improved, if any. The most common points, I come across are `"pod errors"`, `"missing entry in MANIFEST"`, `"missing PREREQS"` etc. Sometimes you would notice `"missing license meta name"` in the left hand side of homepage of the distribution. I am only talking here the quick wins. I like reading codes, so if you have time, read the documentation, you may find broken links in the pod. Sometimes pod doesn't tell you the truth as per the code.

### Take the rejection positively
I remember, initial couple of years, I would submit just a few PR every month. Those days, I would never get any response from the owner, not even acknowledgment. This can put you off from submitting any PR. I know it for real, one of my work colleague, who submitted a PR to a distribution owned by someone I know personally. The PR had significantly important changes. Unfortunately till date, he hasn't received any response whatsoever. You guessed it right, he has never submitted any PR since then. I can understand the owner is busy doing various other things but it doesn't take much time to just the acknowledge the PR. Nobody expects instant approval. Just acknowledge saying `"Thanks for your contribution and I will get back to you soon."`. This can make a big difference. For me, acceptance of PR is the ultimate goal. I don't exect new release just because my PR is accepted. If it does get released eventually then even better. I have been lucky in some way that sometimes owner put my name in the contributors list. It gives me immense pleasure when I see my name alongwith the big guns. I have, sometimes, come across owner accepts the PR and don't bother saying `"Thank you"`. In my humble opinion, this is rude. What is even worst, sometimes the owner close the PR and apply changes manually without any acknowledgment. A better approach, in my humble opinion, if the owner wants to apply the changes manually, would be to acknowledge and convey he would prefer applying the changes manually.

### Get in the good book of distribution owner
With time, you will build up a rapport with the owner and they will take your PR more seriously. This can also help you to get the PR accepted quickly. Don't forget, not every proposed changes are according the taste of distribution owner. So be prepared to take the rejection. Don't go into hiding after rejection. Learn from the rejection. I know it can be hard. Don't let the rejection stop you from submitting PR. I would also urge the distribution owner to be kind in rejecting PR. We are all grown ups and not school going kids. If we can maintain little bit of humour then it can make a big difference.

### Final thoughts
Many people have asked me, where do I get the motivation to submit PR non-stop for so many years. The real motivation when owner acknowleding my PR and saying `"Thank you"`. It means a lot to me and make me do more. If you need any help getting started, feel free to [email me](mailto:mohammad.anwar@yahoo.com) and if necessary, we can remote pair program to get you going.

