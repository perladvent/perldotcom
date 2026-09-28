# Deployment

This document is aimed at any Perl.com editor who wants to update the [live
site](https://www.perl.com).

## How it works

Perl.com uses a **two-repository** model:

- **Public repo** —
  [`perladvent/perldotcom`](https://github.com/perladvent/perldotcom) (this
  repo). All the work happens here: articles, layouts, and the build scripts.
- **Private staging repo** —
  [`tpf/perl.com-staging`](https://github.com/tpf/perl.com-staging), managed by
  [The Perl Foundation](https://www.perlfoundation.org). This holds the
  generated static site.

Deploying means building the static site from the public repo with
[Hugo](https://gohugo.io) and pushing the result into the staging repo. **Perl
NOC pulls the staging repo on a schedule**, so once your push lands, the live
site updates on its own within a few minutes. There is no webhook — you wait for
the next pull.

The **domain name, hosting, and DNS are controlled by [Perl
NOC](https://noc.perl.org/), not by this organization.** Editors here control
only the content and the build that gets pushed to the staging repo; anything to
do with the `perl.com` domain, the servers, or DNS is a Perl NOC matter.

Deployment is **manual**. There is no CI/automated deploy: an editor runs `make
deploy` from their own machine. (The only GitHub Action in this repo,
`test.yml`, runs the test suite; it does not deploy.)

## What you need

- **Write access to
  [`tpf/perl.com-staging`](https://github.com/tpf/perl.com-staging).** This is a
  private repo, and the deploy pushes to it, so you cannot deploy without it. If
  you need access, ask TPF.
- **Docker.** The Hugo build runs in a pinned Docker image
  (`hugomods/hugo:debian-reg-non-root-<version>`) so every deploy is
  reproducible, regardless of the Hugo version you may have installed locally.
  The version is set in exactly one place — the `HUGO_VERSION` variable in the
  `Makefile` — and everything that needs it reads it from there: `make deploy`
  passes it to `bin/deploy`, the CI workflow (`.github/workflows/test.yml`) reads
  it via `make hugo-version`, and the Render build script
  (`bin/render-dot-com.sh`) does the same. Bump it in the `Makefile` and nowhere
  else. To see the current value, run `make hugo-version`.
- **The Perl dependencies** for the metadata scripts:

  ```
  % cpm install -g --cpanfile cpanfile
  ```

You do **not** need to clone the staging repo yourself. `bin/deploy` looks for
it as a sibling of this repo (`../perl.com-staging`) and offers to clone it for
you the first time if it is missing.

## Deploying

From the top level of this repo:

```
% make deploy
```

You must be on the `master` branch, and your clone must be neither ahead of nor
behind `origin/master` — deploy refuses to run otherwise, so that GitHub always
has everything needed to reproduce the live site. Commit and push your work
first.

`make deploy` does the following:

1. Confirms you are on `master`.
2. Regenerates the git-ignored JSON metadata (`static/json/`) and the
   contributors list — see the `json` and `contributors` targets in the
   `Makefile`.
3. Runs `bin/deploy`, which:
   - clones or `git pull --rebase`es the staging repo at `../perl.com-staging`;
   - checks this clone is up to date with GitHub;
   - runs the pinned Docker Hugo build, writing the site into
     `../perl.com-staging/perl.com/`;
   - moves `404.html` into `error/404.html` (Hugo can't place it there itself);
   - commits and pushes the staging repo.
4. Moves the `deployed` git tag to the just-deployed commit and pushes the tag,
   so the repo records what is live.

> **Run it through `make deploy`, not `bin/deploy` directly.** `bin/deploy` is
> only the build-and-push step and refuses to run on its own (it checks for the
> `PERLDOTCOM_DEPLOY_VIA_MAKE` environment variable that the Makefile sets).
> Running it directly would skip the metadata regeneration and ship stale JSON.

## Verifying the deploy

The build writes a `build.json` file (commit, branch, timestamp) that ends up
live at <https://www.perl.com/json/build.json>. Because the live site updates on
a delay, you can check whether the current `deployed` tag has actually gone
live:

```
% make show_live_build
```

This runs `bin/site-is-fresh`, which compares your local `deployed` tag against
the commit in the live `build.json` and reports `Site is fresh` or `Site is
stale`. Right after a deploy it will read as stale until Perl NOC's next pull.

Every page also carries the build time in its HTML `<head>`:

```html
<meta name="build-timestamp" content="2020-11-18 13:00:00">
```

Hugo stamps this with the build time (`now`) on each page (see
`layouts/partials/header.html`). It's a quick spot-check — view source on any
live page — for when the site was last built and pulled, without hitting
`build.json`.

If your local tags are out of sync, `make refresh_tags` re-fetches them from
GitHub.
