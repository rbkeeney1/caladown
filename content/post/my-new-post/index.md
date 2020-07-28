Introduction
------------

In my 1st ever TidyTuesday, I was inspired by Asmae Toumi's (@asmae\_toumi) recent twitter post to create a caladown site through github. Here's a link to the guide she posted: [Youtube Video](https://www.youtube.com/watch?v=HtQhG80MKQE)

It took Asmae 15 minutes to deploy her site, it took me about 4 hours because I've never used git or created a github repo from R before today. After learning a few new cuss words, crashing R multiple times, learning about how to remove ".git/index.lock" files, creating tokens and SSH keys, and troubleshooting why my R "Git" repo would link and post... but not allow me to commit and push data I sort of gave up.

Well, I mean that I downloaded Github for my desktop and dragged the new doc files into the repo.

So. Much. Fun.

*eventually I got if figured out*

Getting Started
---------------

My Tidytuesday entry is more about creating a caladown site, using rMarkdown and some datapasta, and perhaps making a animated plot. For more on rMarkdown: [rMarkdown Intro](https://rmarkdown.rstudio.com/articles_intro.html)

1st, let's see how to install the datasets, for more detail check out the post [here](https://github.com/rfordatascience/tidytuesday/blob/master/data/2020/2020-07-28/readme.md)

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#install.packages("tidytuesdayR")</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/thebioengineer/tidytuesdayR'>tidytuesdayR</a></span>)
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>)
<span class='c'>#&gt; -- <span style='font-weight: bold;'>Attaching packages</span><span> ---------------------------------------------------------------------------------------------------------------------------- tidyverse 1.3.0 --</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>&lt;U+2714&gt;</span><span> </span><span style='color: #0000BB;'>ggplot2</span><span> 3.3.2     </span><span style='color: #00BB00;'>&lt;U+2714&gt;</span><span> </span><span style='color: #0000BB;'>purrr  </span><span> 0.3.4</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>&lt;U+2714&gt;</span><span> </span><span style='color: #0000BB;'>tibble </span><span> 3.0.3     </span><span style='color: #00BB00;'>&lt;U+2714&gt;</span><span> </span><span style='color: #0000BB;'>dplyr  </span><span> 1.0.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>&lt;U+2714&gt;</span><span> </span><span style='color: #0000BB;'>tidyr  </span><span> 1.1.0     </span><span style='color: #00BB00;'>&lt;U+2714&gt;</span><span> </span><span style='color: #0000BB;'>stringr</span><span> 1.4.0</span></span>
<span class='c'>#&gt; <span style='color: #00BB00;'>&lt;U+2714&gt;</span><span> </span><span style='color: #0000BB;'>readr  </span><span> 1.3.1     </span><span style='color: #00BB00;'>&lt;U+2714&gt;</span><span> </span><span style='color: #0000BB;'>forcats</span><span> 0.5.0</span></span>
<span class='c'>#&gt; -- <span style='font-weight: bold;'>Conflicts</span><span> ------------------------------------------------------------------------------------------------------------------------------- tidyverse_conflicts() --</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>&lt;U+2716&gt;</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>filter()</span><span> masks </span><span style='color: #0000BB;'>stats</span><span>::filter()</span></span>
<span class='c'>#&gt; <span style='color: #BB0000;'>&lt;U+2716&gt;</span><span> </span><span style='color: #0000BB;'>dplyr</span><span>::</span><span style='color: #00BB00;'>lag()</span><span>    masks </span><span style='color: #0000BB;'>stats</span><span>::lag()</span></span></code></pre>

</div>

After that, it's just a simple exercise to all in the data. BTW, ctrl+alt+i -&gt; new code section

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>tuesdata</span> <span class='o'>&lt;-</span> <span class='k'>tidytuesdayR</span>::<span class='nf'><a href='https://rdrr.io/pkg/tidytuesdayR/man/tt_load.html'>tt_load</a></span>(<span class='s'>'2020-07-28'</span>)
<span class='c'>#&gt; --- Compiling #TidyTuesday Information for 2020-07-28 ----</span>
<span class='c'>#&gt; --- There are 2 files available ---</span>
<span class='c'>#&gt; --- Starting Download ---</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;   Downloading file 1 of 2: `penguins.csv`</span>
<span class='c'>#&gt;   Downloading file 2 of 2: `penguins_raw.csv`</span>
<span class='c'>#&gt; --- Download complete ---</span>
<span class='k'>penguins</span> <span class='o'>&lt;-</span> <span class='k'>tuesdata</span><span class='o'>$</span><span class='k'>penguins</span></code></pre>

</div>

Datapasta
---------

Great, so we've got the data... but we're making an rMarkdown post, and that means we want to make it pretty. There's a neat little package out there called datapasta... you can load it like so:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#install.packages("datapasta")</span></code></pre>

</div>

For more detail, you can visit [Datapasta](https://github.com/MilesMcBain/datapasta).

Datapasta allows me to paste data from the web directly into my code in about 2 seconds.

1.  Control+C (windows)
2.  Control+Shift+T (after setting up the new keyboard shortcuts)

Add in a little gt:gt() or knitr:kable() and you've got yourself a nice little table to play with, *additional formatting purely optional*.

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
     <span class='k'>gt</span>::<span class='nf'><a href='https://rdrr.io/pkg/gt/man/gt.html'>gt</a></span>()
</code></pre>

</div>

Animated plot
-------------

Alrighty, Now let's make simple plot, flipper length x bill length should do nicely.

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

Let's see what our plot looks like:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>p1</span>
<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_smooth).</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing missing values (geom_point).</span>
</code></pre>
<img src="figs/print_it-1.png" width="700px" style="display: block; margin: auto;" />

</div>

To create an animation from our picture, we need to the gganimate library... and I like to use glue to easily paste labels from data, here I use the "closest\_state" command to update the subtitle with which species is being displayed.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://gganimate.com'>gganimate</a></span>)
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/tidyverse/glue'>glue</a></span>)
<span class='c'>#&gt; </span>
<span class='c'>#&gt; Attaching package: 'glue'</span>
<span class='c'>#&gt; The following object is masked from 'package:dplyr':</span>
<span class='c'>#&gt; </span>
<span class='c'>#&gt;     collapse</span>

<span class='k'>p1_anim</span> <span class='o'>&lt;-</span> <span class='k'>p1</span> <span class='o'>+</span>
     <span class='nf'><a href='https://gganimate.com/reference/transition_states.html'>transition_states</a></span>(<span class='k'>species</span>, transition_length = <span class='m'>2</span>, state_length = <span class='m'>3</span>) <span class='o'>+</span>
     <span class='nf'>labs</span>(subtitle = <span class='s'>"Species: {closest_state}"</span>) <span class='o'>+</span>
     <span class='nf'><a href='https://gganimate.com/reference/ease_aes.html'>ease_aes</a></span>(<span class='s'>'cubic-in-out'</span>)</code></pre>

</div>

To display our animation, we just call animate()

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://gganimate.com/reference/animate.html'>animate</a></span>(<span class='k'>p1_anim</span>)
<span class='c'>#&gt; `geom_smooth()` using formula 'y ~ x'</span>
<span class='c'>#&gt; Warning: Removed 2 rows containing non-finite values (stat_smooth).</span>
<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>

<span class='c'>#&gt; Warning: Removed 1 rows containing missing values (geom_point).</span>
<span class='c'>#&gt; Warning in (if (out_format(c("latex", "sweave", "listings"))) sanitize_fn else paste0)(path, : replaced special characters in figure filename "figs/move it" -&gt; "figs/move_it"</span>
</code></pre>
<img src="figs/move_it-1.gif" width="700px" style="display: block; margin: auto;" />

</div>

And finally, we can save our simple animation locally to use later (Twitter anyone?).

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'>#anim_save(filename = 'Rplot_animation.gif', animation = last_animation(),path = "C:\\Users\\&lt;your user name&gt;\\Desktop")</span></code></pre>

</div>
