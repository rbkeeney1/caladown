---
output: hugodown::md_document
title: "TidyTuesday Penguins"
summary: "Penguins, Datapasta, and a Github Cawebsite"
author: "rbkeeney"
tags: []
date: 2020-07-28
rmd_hash: 4121a91e9c1524d8

---

Introduction
------------

In my 1st ever TidyTuesday, I felt inspired by Asmae Toumi's (@asmae\_toumi) recent twitter post about creating a caladown site through github. Here's a link to the guide she posted: [Youtube Video](https://www.youtube.com/watch?v=HtQhG80MKQE)

It took Asmae 15 minutes to deploy her site.

*It took me about 6 hours.* I've never used git or created a github repo from R before today. A summary of how it went?

-   Gownload git
-   Google how to use git
-   Learn a new cuss words
-   Crash R a feww times
-   Learn more cuss words
-   Learn how to set directories and remove ".git/index.lock" files
-   Create a SSH key
-   Create a Github token
-   Troubleshoot why R crashes when I run "commit" or "push"
-   Fix it
-   Repo is working!
-   Break post code
-   Ugh.

So. Much. Fun.

*and yes, eventually I got it figured out*

Getting Started
---------------

Finally getting to the R code (the easy portion!), my Tidytuesday entry about creating a caladown site, using rMarkdown and some datapasta, and eventually making a simple animated plot.

First, let's install the our libraries and load them, for more detail check out the post [here](https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-07-28/readme.md)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#install.packages("tidytuesdayR")</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/thebioengineer/tidytuesdayR'>tidytuesdayR</a></span>)
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>)
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://gganimate.com'>gganimate</a></span>)
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/tidyverse/glue'>glue</a></span>)</code></pre>

</div>

TidyTuesday makes is easy to get the data. BTW, ctrl+alt+i -&gt; "insert new code section" is wonderful. For more on rMarkdown: [rMarkdown Intro](https://rmarkdown.rstudio.com/articles_intro.html)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>tuesdata</span> <span class='o'>&lt;-</span> <span class='k'>tidytuesdayR</span>::<span class='nf'><a href='https://rdrr.io/pkg/tidytuesdayR/man/tt_load.html'>tt_load</a></span>(<span class='s'>'2020-07-28'</span>)
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   Downloading file 1 of 2: `penguins.csv`</span>
<span class='c'>#&gt;   Downloading file 2 of 2: `penguins_raw.csv`</span>
<span class='k'>penguins</span> <span class='o'>&lt;-</span> <span class='k'>tuesdata</span><span class='o'>$</span><span class='k'>penguins</span></code></pre>

</div>

Datapasta
---------

I also wanted to try out a neat little package out there called datapasta... you can load it like so if you don't have it. For more detail, you can visit [Datapasta](https://github.com/MilesMcBain/datapasta).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#install.packages("datapasta")</span></code></pre>

</div>

Datapasta allows you to paste data from the web directly into your code in about 2 seconds.

1.  Control+C (windows)
2.  Control+Shift+T (after setting up the new keyboard shortcuts)

Add in a little gt:gt() or knitr:kable() and you've got yourself a nice little table to play with, *additional formatting purely optional*. After the learning git + github all day, I'm going to use knitr:kable() can call it day.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>tibble</span>::<span class='nf'><a href='https://tibble.tidyverse.org/reference/tribble.html'>tribble</a></span>(
               <span class='o'>~</span><span class='k'>variable</span>,    <span class='o'>~</span><span class='k'>class</span>,                                               <span class='o'>~</span><span class='k'>description</span>,
               <span class='s'>"species"</span>, <span class='s'>"integer"</span>,              <span class='s'>"Penguin species (Adelie, Gentoo, Chinstrap)"</span>,
                <span class='s'>"island"</span>, <span class='s'>"integer"</span>,         <span class='s'>"Island where recorded (Biscoe, Dream, Torgersen)"</span>,
        <span class='s'>"bill_length_mm"</span>,  <span class='s'>"double"</span>, <span class='s'>"Bill length in millimeters (also known as culmen length)"</span>,
         <span class='s'>"bill_depth_mm"</span>,  <span class='s'>"double"</span>,   <span class='s'>"Bill depth in millimeters (also known as culmen depth)"</span>,
     <span class='s'>"flipper_length_mm"</span>, <span class='s'>"integer"</span>,                                     <span class='s'>"Flipper length in mm"</span>,
           <span class='s'>"body_mass_g"</span>, <span class='s'>"integer"</span>,                                       <span class='s'>"Body mass in grams"</span>,
                   <span class='s'>"sex"</span>, <span class='s'>"integer"</span>,                                        <span class='s'>"sex of the animal"</span>,
                  <span class='s'>"year"</span>, <span class='s'>"integer"</span>,                                            <span class='s'>"year recorded"</span>
     ) <span class='o'>%&gt;%</span> 
     <span class='k'>knitr</span>::<span class='nf'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span>()
</code></pre>

<table><colgroup><col style="width: 21%" /><col style="width: 9%" /><col style="width: 68%" /></colgroup><thead><tr class="header"><th style="text-align: left;">variable</th><th style="text-align: left;">class</th><th style="text-align: left;">description</th></tr></thead><tbody><tr class="odd"><td style="text-align: left;">species</td><td style="text-align: left;">integer</td><td style="text-align: left;">Penguin species (Adelie, Gentoo, Chinstrap)</td></tr><tr class="even"><td style="text-align: left;">island</td><td style="text-align: left;">integer</td><td style="text-align: left;">Island where recorded (Biscoe, Dream, Torgersen)</td></tr><tr class="odd"><td style="text-align: left;">bill_length_mm</td><td style="text-align: left;">double</td><td style="text-align: left;">Bill length in millimeters (also known as culmen length)</td></tr><tr class="even"><td style="text-align: left;">bill_depth_mm</td><td style="text-align: left;">double</td><td style="text-align: left;">Bill depth in millimeters (also known as culmen depth)</td></tr><tr class="odd"><td style="text-align: left;">flipper_length_mm</td><td style="text-align: left;">integer</td><td style="text-align: left;">Flipper length in mm</td></tr><tr class="even"><td style="text-align: left;">body_mass_g</td><td style="text-align: left;">integer</td><td style="text-align: left;">Body mass in grams</td></tr><tr class="odd"><td style="text-align: left;">sex</td><td style="text-align: left;">integer</td><td style="text-align: left;">sex of the animal</td></tr><tr class="even"><td style="text-align: left;">year</td><td style="text-align: left;">integer</td><td style="text-align: left;">year recorded</td></tr></tbody></table>

</div>

Animated plot
-------------

Now I'm going to make a simple plot... flipper length x bill length should do nicely.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>p1</span> <span class='o'>&lt;-</span> <span class='k'>penguins</span> <span class='o'>%&gt;%</span> 
     <span class='nf'>ggplot</span>(<span class='nf'>aes</span>(y = <span class='k'>flipper_length_mm</span>, x = <span class='k'>bill_length_mm</span>,color = <span class='k'>species</span>,group = <span class='k'>species</span>)) <span class='o'>+</span>
     <span class='nf'>geom_smooth</span>(method=<span class='k'>lm</span>) <span class='o'>+</span>
     <span class='nf'>geom_point</span>(size = <span class='m'>2</span>, alpha = <span class='m'>0.6</span>) <span class='o'>+</span>
     <span class='nf'>theme_bw</span>()  <span class='o'>+</span>
     <span class='nf'>labs</span>(title = <span class='s'>"Palmer Penguins"</span>, 
          caption = <span class='s'>"palmerpenguins data by Dr. Kristen Gorman"</span>,
          x = <span class='s'>"Bill Length (mm)"</span>, 
          y = <span class='s'>"Flipper Length (mm)"</span>)</code></pre>

</div>

Let's see what the plot looks like:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>p1</span>
</code></pre>
<img src="figs/print_it-1.png" width="700px" style="display: block; margin: auto;" />

</div>

To create an animation from the picture, the gganimate library is needed (loaded previously). I also like to use "glue" to easily paste information from the data. Here, I use the "closest\_state" command to update the subtitle with which species is being displayed.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'>
<span class='k'>p1_anim</span> <span class='o'>&lt;-</span> <span class='k'>p1</span> <span class='o'>+</span>
     <span class='nf'><a href='https://gganimate.com/reference/transition_states.html'>transition_states</a></span>(<span class='k'>species</span>) <span class='o'>+</span>
     <span class='nf'>labs</span>(subtitle = <span class='s'>"Species: {closest_state}"</span>) <span class='o'>+</span>
     <span class='nf'><a href='https://gganimate.com/reference/ease_aes.html'>ease_aes</a></span>(<span class='s'>'cubic-in-out'</span>)</code></pre>

</div>

To display the animation, just call animate(). This take forever to knit, so I'm going to exclude it from the rMarkdown.

<div class="highlight">

<img src="figs/move_it-1.gif" width="700px" style="display: block; margin: auto;" />

</div>

Finally, if you wanted to save the simple animation locally for later use (Twitter anyone?), you can save the last animated file using anim\_save()

