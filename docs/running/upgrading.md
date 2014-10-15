---
layout: page
title: Upgrading
---
Upgrading Alaveteli
====================

<p class="lead">
  Alaveteli is under active development &mdash; don't let the
  version you're running get too far behind our latest
  <a href="{{site.baseurl}}docs/glossary/#release" class="glossary__link">release</a>.
  This page describes how to keep your site up-to-date
</p>

## Alaveteli Version Numbers

Alaveteli uses a shifted version of [semver](http://semver.org).

- Series `W`
- Major `X`
- Minor `Y`
- Patch `Z`

At the time of writing the current release is `0.19.0.6`:

- Series `0`
- Major `19`
- Minor `0`
- Patch `6`

Alaveteli will transition to the [semver](http://semver.org) specification when it reaches `1.0.0`.

## Master branch contains the latest stable release

The developer team policy is that the `master` branch in git should always
contain the latest stable release -- so you'll be up to date if you pull from
the `master` branch. However, on your
<a href="{{site.baseurl}}docs/glossary/#production" class="glossary__link">production
site</a>, you should know precisely what version you're running, and deploy
Alaveteli from a [*specific* release
tag](https://github.com/mysociety/alaveteli/releases).

Upgrading may just require pulling in the latest code -- but it may also require
other changes ("further action"). For this reason, for anything other than a
*patch* (see below), always read the 
[`CHANGES.md`](https://github.com/mysociety/alaveteli/blob/master/doc/CHANGES.md)
document **before** doing an upgrade. This way you'll be able to prepare for any
other changes that might be needed to make the new code work.

## How to upgrade the code

* If you're using Capistrano for deployment,
  simply [deploy the code]({{site.baseurl}}docs/installing/deploy/#usage):
  set the repo and branch in `deploy.yml` to be the version you want. 
  We recommend you set this to the explicit tag name (for example, 
  `0.18`, and not `master`) so there's no risk of you accidentally deploying
  a new version before you're aware it's been released.
* otherwise, you can simply upgrade by running `git pull`

## Patches

Patch version increases (e.g. 0.1.2.3 &rarr; 0.1.2.**4**) should not require any further action on your part. They will be backwards compatible with the current minor release version.

## Minor version increases

Minor version increases (e.g. 0.1.2.4 &rarr; 0.1.**3**.0) will usually require further action. You should read the [`CHANGES.md`](https://github.com/mysociety/alaveteli/blob/master/doc/CHANGES.md) document to see what's changed since your last deployment, paying special attention to anything in the "Upgrade notes" sections.

Any upgrade may include new translations strings, that is, new or altered messages
to the user that need translating to your locale. You should visit Transifex
and try to get your translation up to 100% on each new release. Failure to do
so means that any new words added to the Alaveteli source code will appear in
your website in English by default. If your translations didn't make it to the
latest release, you will need to download the updated `app.po` for your locale
from Transifex and save it in the `locale/` folder.

Minor releases will be backwards compatible with the current major release version.

## Major releases

Major version increases (e.g. 0.1.2.4 &rarr; 0.2.0.0) will usually require further action. You should read the [`CHANGES.md`](https://github.com/mysociety/alaveteli/blob/master/doc/CHANGES.md) document to see what's changed since your last deployment, paying special attention to anything in the "Upgrade notes" sections.

Only major releases may remove existing functionality. You will be warned about the removal of functionality with a deprecation notice in a minor release prior to the major release that removes the functionality.

## Series releases

Special instructions will accompany series releases.

## Run the post-deploy script

Unless you're [using Capistrano for deployment]({{site.baseurl}}docs/installing/deploy/),
you should always run the script `scripts/rails-post-deploy` after each
deployment. This runs any database migrations for you, plus various other
things that can be automated for deployment.
