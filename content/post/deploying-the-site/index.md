---
output: hugodown::md_document
title: "Tutorial part 3: Deploying the site"
author: "Danielle Navarro"
date: "2020-06-07"
slug: deploying-the-site
tags: "tutorial"
summary: "The usual advice for deploying a blogdown or hugodown site is to deploy to Netlify rather than GitHub Pages, because there are a few peculiarities to GitHub Pages that can make it difficult. The third part of the tutorial walks you through both versions."
header:
  caption: "A caption"
  image: 'header/banner.png'
  profile: 'header/profile.png'
rmd_hash: f4a73aa9e03c59a4

---

The usual advice for deploying a blogdown or hugodown site is to deploy to Netlify rather than GitHub Pages, because there are a few peculiarities to GitHub Pages that can make it difficult. The third part of the tutorial walks you through both versions, or to be more precise, it will walk you through both versions once I familiarise myself with Netlify and various other things. For the moment, only the GitHub Pages version is documented here.

Deploying a hugodown site to GitHub Pages
-----------------------------------------

The way I set up all my static websites is through [GitHub Pages](https://pages.github.com/). If you have created your site using hugodown, the first thing you need to do is to have Hugo build a copy of your site in the `docs` folder. Hugodown makes this easy to do:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>hugodown</span>::<span class='nf'><a href='https://rdrr.io/pkg/hugodown/man/hugo_build.html'>hugo_build</a></span>(dest = <span class='s'>"docs"</span>)</code></pre>

</div>

Once you have done this, you are ready to deploy. If you haven't already done so, initialise a git repository in your project and then push it to GitHub. The laziest way I know of to do this is with the following R commands:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>usethis</span>::<span class='nf'><a href='https://usethis.r-lib.org/reference/use_git.html'>use_git</a></span>()
<span class='k'>usethis</span>::<span class='nf'><a href='https://usethis.r-lib.org/reference/use_github.html'>use_github</a></span>()</code></pre>

</div>

On GitHub, go to the "Settings" tab and scroll down to the section entitled "GitHub Pages". There should be a drop down menu underneath the subheading "Source". Click on it and select "master branch /docs folder". The site should now deploy.

Deploying a blogdown site to GitHub
-----------------------------------

The process of deploying a blogdown site to GitHub is very similar to the hugodown process. Assuming that you have created and built the site in the usual way, e.g.,

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>caladown</span>::<span class='nf'><a href='https://rdrr.io/pkg/caladown/man/create_blogdown_calade.html'>create_blogdown_calade</a></span>(<span class='s'>"my-caladown-site"</span>)
<span class='k'>blogdown</span>::<span class='nf'><a href='https://rdrr.io/pkg/blogdown/man/serve_site.html'>serve_site</a></span>()</code></pre>

</div>

then the site will already be built in the "docs" folder. To deploy the site, initialise a git repository, push it to GitHub, and enable GitHub pages in exactly the same way you would for the hugodown version:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>usethis</span>::<span class='nf'><a href='https://usethis.r-lib.org/reference/use_git.html'>use_git</a></span>()
<span class='k'>usethis</span>::<span class='nf'><a href='https://usethis.r-lib.org/reference/use_github.html'>use_github</a></span>() <span class='c'># then enable GH Pages with /docs folder</span></code></pre>

</div>

One thing to note here. The reason this works cleanly is that by default the `config.toml` file for contains a line that reads:

    publishDir = 'docs'

This ensures that the static site is built to the docs folder. If you want blogdown to build to the "public" folder (as is more typical for Hugo sites) you should edit this line appropriately.

Deploying a hugodown site to Netlify
------------------------------------

To deploy to Netlify you need to have a Netlify account (naturally) and it should be linked to your GitHub account. The easiest way to do this is to sign up via your GitHub credentials, and allow Netlify to have access to the relevant repository. The process for this is as follows:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>caladown</span>::<span class='nf'><a href='https://rdrr.io/pkg/caladown/man/create_hugodown_calade.html'>create_hugodown_calade</a></span>(<span class='s'>"my_calade_site"</span>)
<span class='k'>hugodown</span>::<span class='nf'><a href='https://rdrr.io/pkg/hugodown/man/use_netlify_toml.html'>use_netlify_toml</a></span>()
<span class='k'>hugodown</span>::<span class='nf'><a href='https://rdrr.io/pkg/hugodown/man/hugo_build.html'>hugo_build</a></span>()
<span class='k'>usethis</span>::<span class='nf'><a href='https://usethis.r-lib.org/reference/use_git.html'>use_git</a></span>()
<span class='k'>usethis</span>::<span class='nf'><a href='https://usethis.r-lib.org/reference/use_github.html'>use_github</a></span>()</code></pre>

</div>

Deploying a blogdown site to Netlify
------------------------------------

To be added later :-)

