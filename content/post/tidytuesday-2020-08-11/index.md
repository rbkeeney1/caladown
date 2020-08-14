---
output: hugodown::md_document
title: "TidyTuesday - Avitar"
summary: "Analyzing The Setiment of Avatar's Primary Characters With Compound VADER Scores."
author: "rbkeeney"
tags: [nlp,TidyTuesday]
date: 2020-08-12
rmd_hash: 2596c5d72e4203ce

---

TidyTuesday - Avitar and Vader Sentiment Scores
===============================================

The August 12, 2020 [TidyTuesday](https://github.com/rfordatascience/tidytuesday/tree/master/data/2020/2020-08-11) dataset has a lot of text. It's a perfect opportunity to try out the {vader} package (now available on CRAN!) which can be used for native language processing... or text analytics for beginners like me.

My goal was to analyze character sentiment by breaking down each character's lines and running them through vader. Here are a few questions that I hoped to answer along the way:

1.  Who are the most positive characters?
2.  Who are the most negative characters?
3.  Does character sentiment change over the duration of the series?

I also wanted to explore a few new concepts such as the unique piping operators in {magrittr}, {tvthemes}, fonts, customizing themes, and improving my annotations. And while I wanted to make a word cloud in the shape of appa - that's going to have to wait until next time.

Initial Libraries
-----------------

The first set of libraries to load are as follows. I do load a few font and theme libraries later. But, if you want to use vader this will get you started.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/thebioengineer/tidytuesdayR'>tidytuesdayR</a></span>) <span class='c'># to get data quickly</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://tidyverse.tidyverse.org'>tidyverse</a></span>) <span class='c'># no matter how dark, there is always hope</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'>magrittr</span>) <span class='c'># for some more unique piping options</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='http://github.com/trinker/sentimentr'>sentimentr</a></span>) <span class='c'># for getting sentences</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'>vader</span>) <span class='c'># for vader sentiment scores</span></code></pre>

</div>

As always, TidyTuesday makes it easy to get the data.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>tuesdata</span> <span class='o'>&lt;-</span> <span class='k'>tidytuesdayR</span>::<span class='nf'><a href='https://rdrr.io/pkg/tidytuesdayR/man/tt_load.html'>tt_load</a></span>(<span class='s'>'2020-08-11'</span>)
<span class='k'>avatar</span> <span class='o'>&lt;-</span> <span class='k'>tuesdata</span><span class='o'>$</span><span class='k'>avatar</span></code></pre>

</div>

Data Inspection
---------------

Here I take a quick look at the data available this week:

<div class="highlight">

| variable         | class     | description                                   |
|:-----------------|:----------|:----------------------------------------------|
| id               | integer   | Unique Row identifier                         |
| book             | character | Book name                                     |
| book\_num        | integer   | Book number                                   |
| chapter          | character | Chapter name                                  |
| chapter\_num     | integer   | Chapter Name                                  |
| character        | character | Character speaking                            |
| full\_text       | character | Full text (scene description, character text) |
| character\_words | character | Text coming from characters                   |
| writer           | character | Writer of book                                |
| director         | character | Director of episode                           |
| imdb\_rating     | double    | IMDB rating for episode                       |

</div>

Who speaks the most often?
--------------------------

First, I ran a quick line of code to see who talked the most often and if I need to clean it up a bit. Looks like I'm going to have to remove the "Scene Description". Additionally, I plan on picking a subset of the characters to plot later and I want to see who speaks enough to be included.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>avatar</span> <span class='o'>%&gt;%</span> <span class='nf'>group_by</span>(<span class='k'>character</span>) <span class='o'>%&gt;%</span> <span class='nf'>summarize</span>(n=<span class='nf'>n</span>())<span class='o'>%&gt;%</span> <span class='nf'>arrange</span>(<span class='o'>-</span><span class='k'>n</span>) <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span>(<span class='m'>20</span>) <span class='o'>%&gt;%</span> <span class='k'>knitr</span>::<span class='nf'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span>()
<span class='c'>#&gt; `summarise()` ungrouping output (override with `.groups` argument)</span>
</code></pre>

| character         |     n|
|:------------------|-----:|
| Scene Description |  3393|
| Aang              |  1796|
| Sokka             |  1639|
| Katara            |  1437|
| Zuko              |   776|
| Toph              |   507|
| Iroh              |   337|
| Azula             |   211|
| Jet               |   134|
| Suki              |   114|
| Zhao              |   107|
| Mai               |    82|
| Hakoda            |    77|
| Roku              |    67|
| Ty Lee            |    64|
| Ozai              |    59|
| Bumi              |    55|
| Yue               |    53|
| Hama              |    49|
| Warden            |    49|

</div>

Data prep
---------

Thanks to Avery Robbins for dataset {appa}, and there isn't much cleaning do be done, I only removed the "Scene Description". Since I'm also trying to get used to using the magrittr %&lt;&gt;% assignment-piping operator, this was a is was a good opportunity to start.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>avatar_clean</span> <span class='o'>&lt;-</span> <span class='k'>avatar</span> 
<span class='k'>avatar_clean</span> <span class='o'>%&lt;&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>character</span> != <span class='s'>"Scene Description"</span>) <span class='o'>%&gt;%</span> <span class='nf'>select</span>(<span class='k'>id</span><span class='o'>:</span><span class='k'>character</span>,<span class='k'>character_words</span>)
     
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span>(<span class='k'>avatar</span>)
<span class='c'>#&gt; [1] 13385    11</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span>(<span class='k'>avatar_clean</span>)
<span class='c'>#&gt; [1] 9992    7</span></code></pre>

</div>

VADER compound scores
---------------------

Luke, I am your Father. You can read more about it vader here: [PDF](https://cran.r-project.org/web/packages/vader/vader.pdf). While it is designed for social media, it also aligns pretty well with my priors about the characters.

### Step 1: Sentences. Yip yip!

I'm going to include my code I used to check my process along the way. Here, I check to make sure get\_sentences() is working.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># split out each sentences</span>
<span class='k'>avatar_clean</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span>(<span class='m'>5</span>) <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/pkg/sentimentr/man/get_sentences.html'>get_sentences</a></span>() <span class='o'>%&gt;%</span> <span class='k'>knitr</span>::<span class='nf'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span>()
</code></pre>

<table><colgroup><col style="width: 1%" /><col style="width: 2%" /><col style="width: 3%" /><col style="width: 8%" /><col style="width: 4%" /><col style="width: 3%" /><col style="width: 66%" /><col style="width: 4%" /><col style="width: 4%" /></colgroup><thead><tr class="header"><th style="text-align: right;">id</th><th style="text-align: left;">book</th><th style="text-align: right;">book_num</th><th style="text-align: left;">chapter</th><th style="text-align: right;">chapter_num</th><th style="text-align: left;">character</th><th style="text-align: left;">character_words</th><th style="text-align: right;">element_id</th><th style="text-align: right;">sentence_id</th></tr></thead><tbody><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Water.</td><td style="text-align: right;">1</td><td style="text-align: right;">1</td></tr><tr class="even"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Earth.</td><td style="text-align: right;">1</td><td style="text-align: right;">2</td></tr><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Fire.</td><td style="text-align: right;">1</td><td style="text-align: right;">3</td></tr><tr class="even"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Air.</td><td style="text-align: right;">1</td><td style="text-align: right;">4</td></tr><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">My grandmother used to tell me stories about the old days: a time of peace when the Avatar kept balance between the Water Tribes, Earth Kingdom, Fire Nation and Air Nomads.</td><td style="text-align: right;">1</td><td style="text-align: right;">5</td></tr><tr class="even"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">But that all changed when the Fire Nation attacked.</td><td style="text-align: right;">1</td><td style="text-align: right;">6</td></tr><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Only the Avatar mastered all four elements; only he could stop the ruthless firebenders.</td><td style="text-align: right;">1</td><td style="text-align: right;">7</td></tr><tr class="even"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">But when the world needed him most, he vanished.</td><td style="text-align: right;">1</td><td style="text-align: right;">8</td></tr><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">A hundred years have passed, and the Fire Nation is nearing victory in the war.</td><td style="text-align: right;">1</td><td style="text-align: right;">9</td></tr><tr class="even"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Two years ago, my father and the men of my tribe journeyed to the Earth Kingdom to help fight against the Fire Nation, leaving me and my brother to look after our tribe.</td><td style="text-align: right;">1</td><td style="text-align: right;">10</td></tr><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Some people believe that the Avatar was never reborn into the Air Nomads and that the cycle is broken, but I haven’t lost hope.</td><td style="text-align: right;">1</td><td style="text-align: right;">11</td></tr><tr class="even"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">I still believe that, somehow, the Avatar will return to save the world.</td><td style="text-align: right;">1</td><td style="text-align: right;">12</td></tr><tr class="odd"><td style="text-align: right;">3</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Sokka</td><td style="text-align: left;">It’s not getting away from me this time.</td><td style="text-align: right;">2</td><td style="text-align: right;">1</td></tr><tr class="even"><td style="text-align: right;">3</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Sokka</td><td style="text-align: left;">Watch and learn, Katara.</td><td style="text-align: right;">2</td><td style="text-align: right;">2</td></tr><tr class="odd"><td style="text-align: right;">3</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Sokka</td><td style="text-align: left;">This is how you catch a fish.</td><td style="text-align: right;">2</td><td style="text-align: right;">3</td></tr><tr class="even"><td style="text-align: right;">5</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Sokka, look!</td><td style="text-align: right;">3</td><td style="text-align: right;">1</td></tr><tr class="odd"><td style="text-align: right;">6</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Sokka</td><td style="text-align: left;">Sshh!</td><td style="text-align: right;">4</td><td style="text-align: right;">1</td></tr><tr class="even"><td style="text-align: right;">6</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Sokka</td><td style="text-align: left;">Katara, you’re going to scare it away.</td><td style="text-align: right;">4</td><td style="text-align: right;">2</td></tr><tr class="odd"><td style="text-align: right;">6</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Sokka</td><td style="text-align: left;">Mmmm …</td><td style="text-align: right;">4</td><td style="text-align: right;">3</td></tr><tr class="even"><td style="text-align: right;">6</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Sokka</td><td style="text-align: left;">I can already smell it cookin’.</td><td style="text-align: right;">4</td><td style="text-align: right;">4</td></tr><tr class="odd"><td style="text-align: right;">8</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">But, Sokka!</td><td style="text-align: right;">5</td><td style="text-align: right;">1</td></tr><tr class="even"><td style="text-align: right;">8</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">I caught one!</td><td style="text-align: right;">5</td><td style="text-align: right;">2</td></tr></tbody></table>

</div>

Okay, it works. Run it.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># run get_sentences() on the complete dataset</span>
<span class='k'>avatar_sentences</span> <span class='o'>&lt;-</span> <span class='k'>avatar_clean</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/pkg/sentimentr/man/get_sentences.html'>get_sentences</a></span>()</code></pre>

</div>

### Step 2: Check structure and test vader

Check the structure of avatar\_sentences to setup vader properly

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'>glimpse</span>(<span class='k'>avatar_sentences</span>)
<span class='c'>#&gt; Rows: 18,440</span>
<span class='c'>#&gt; Columns: 9</span>
<span class='c'>#&gt; $ id              <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 3, 3, 5, 6, 6,㠼㸵</span></span>…
<span class='c'>#&gt; $ book            <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Water", "Water", "Water", "Water", "Water", "Water",㠼㸵</span></span>…
<span class='c'>#&gt; $ book_num        <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,㠼㸵</span></span>…
<span class='c'>#&gt; $ chapter         <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "The Boy in the Iceberg", "The Boy in the Iceberg", "㠼㸵</span></span>…
<span class='c'>#&gt; $ chapter_num     <span style='color: #555555;font-style: italic;'>&lt;dbl&gt;</span><span> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,㠼㸵</span></span>…
<span class='c'>#&gt; $ character       <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Katara", "Katara", "Katara", "Katara", "Katara", "Ka㠼㸵</span></span>…
<span class='c'>#&gt; $ character_words <span style='color: #555555;font-style: italic;'>&lt;chr&gt;</span><span> "Water.", "Earth.", "Fire.", "Air.", "My grandmother 㠼㸵</span></span>…
<span class='c'>#&gt; $ element_id      <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 3, 4, 4,㠼㸵</span></span>…
<span class='c'>#&gt; $ sentence_id     <span style='color: #555555;font-style: italic;'>&lt;int&gt;</span><span> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1, 2, 3, 1, 1,㠼㸵</span></span>…</code></pre>

</div>

Now for a trial run of vader\_df()... notice we can pull out the the \$compound column, I'll use that when I bind the data back into the avatar\_sentences dataset.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>avatar_sentences</span><span class='o'>$</span><span class='k'>character_words</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span>(<span class='m'>5</span>) <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/pkg/vader/man/vader_df.html'>vader_df</a></span>() <span class='o'>%&gt;%</span> <span class='k'>knitr</span>::<span class='nf'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span>()
</code></pre>

<table><colgroup><col style="width: 56%" /><col style="width: 32%" /><col style="width: 2%" /><col style="width: 1%" /><col style="width: 1%" /><col style="width: 1%" /><col style="width: 3%" /></colgroup><thead><tr class="header"><th style="text-align: left;">text</th><th style="text-align: left;">word_scores</th><th style="text-align: right;">compound</th><th style="text-align: right;">pos</th><th style="text-align: right;">neu</th><th style="text-align: right;">neg</th><th style="text-align: right;">but_count</th></tr></thead><tbody><tr class="odd"><td style="text-align: left;">Water.</td><td style="text-align: left;">{0}</td><td style="text-align: right;">0.000</td><td style="text-align: right;">0.0</td><td style="text-align: right;">1.000</td><td style="text-align: right;">0.000</td><td style="text-align: right;">0</td></tr><tr class="even"><td style="text-align: left;">Earth.</td><td style="text-align: left;">{0}</td><td style="text-align: right;">0.000</td><td style="text-align: right;">0.0</td><td style="text-align: right;">1.000</td><td style="text-align: right;">0.000</td><td style="text-align: right;">0</td></tr><tr class="odd"><td style="text-align: left;">Fire.</td><td style="text-align: left;">{-1.4}</td><td style="text-align: right;">-0.340</td><td style="text-align: right;">0.0</td><td style="text-align: right;">0.000</td><td style="text-align: right;">1.000</td><td style="text-align: right;">0</td></tr><tr class="even"><td style="text-align: left;">Air.</td><td style="text-align: left;">{0}</td><td style="text-align: right;">0.000</td><td style="text-align: right;">0.0</td><td style="text-align: right;">1.000</td><td style="text-align: right;">0.000</td><td style="text-align: right;">0</td></tr><tr class="odd"><td style="text-align: left;">My grandmother used to tell me stories about the old days: a time of peace when the Avatar kept balance between the Water Tribes, Earth Kingdom, Fire Nation and Air Nomads.</td><td style="text-align: left;">{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2.5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1.4, 0, 0, 0, 0}</td><td style="text-align: right;">0.273</td><td style="text-align: right;">0.1</td><td style="text-align: right;">0.831</td><td style="text-align: right;">0.069</td><td style="text-align: right;">0</td></tr></tbody></table>

</div>

### Step 3: Cross fingers, Run Vader, Make Coffee

Running it on all the sentences takes a bit of time. Go make coffee. Check Twitter. Pet the dog.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>ptm</span> <span class='o'>&lt;-</span> <span class='nf'><a href='https://rdrr.io/r/base/proc.time.html'>proc.time</a></span>() <span class='c'># Start the clock!</span>
<span class='k'>vader_comp</span> <span class='o'>&lt;-</span> <span class='k'>avatar_sentences</span><span class='o'>$</span><span class='k'>character_words</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/pkg/vader/man/vader_df.html'>vader_df</a></span>() <span class='o'>%&gt;%</span> <span class='nf'>select</span>(<span class='k'>compound</span>)
<span class='c'>#&gt; Warning in sentiments[i] &lt;- senti_valence(wpe, i, item): number of items to replace is not a multiple of replacement length</span>
<span class='nf'><a href='https://rdrr.io/r/base/proc.time.html'>proc.time</a></span>() <span class='o'>-</span> <span class='k'>ptm</span> <span class='c'># Calc time</span>
<span class='c'>#&gt;    user  system elapsed </span>
<span class='c'>#&gt;  202.23   50.67  261.14</span>

<span class='c'>#note, set "cache=TRUE" and save some time!</span></code></pre>

</div>

Make sure that it ran properly:

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># check it visually</span>
<span class='k'>vader_comp</span> <span class='o'>%&gt;%</span> <span class='nf'>arrange</span>(<span class='o'>-</span><span class='k'>compound</span>) <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span>(<span class='m'>5</span>)
<span class='c'>#&gt;   compound</span>
<span class='c'>#&gt; 1    0.965</span>
<span class='c'>#&gt; 2    0.944</span>
<span class='c'>#&gt; 3    0.939</span>
<span class='c'>#&gt; 4    0.931</span>
<span class='c'>#&gt; 5    0.927</span>
<span class='k'>vader_comp</span> <span class='o'>%&gt;%</span> <span class='nf'>arrange</span>(<span class='o'>-</span><span class='k'>compound</span>) <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>tail</a></span>(<span class='m'>5</span>)
<span class='c'>#&gt;       compound</span>
<span class='c'>#&gt; 18436   -0.916</span>
<span class='c'>#&gt; 18437   -0.926</span>
<span class='c'>#&gt; 18438   -0.927</span>
<span class='c'>#&gt; 18439   -0.947</span>
<span class='c'>#&gt; 18440   -0.951</span>

<span class='c'># Any failures?</span>
<span class='k'>vader_comp</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='nf'><a href='https://rdrr.io/r/base/NA.html'>is.na</a></span>(<span class='k'>compound</span>)) <span class='c'># no NAs</span>
<span class='c'>#&gt; [1] compound</span>
<span class='c'>#&gt; &lt;0 rows&gt; (or 0-length row.names)</span>
<span class='k'>vader_comp</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='nf'><a href='https://rdrr.io/r/base/is.finite.html'>is.nan</a></span>(<span class='k'>compound</span>)) <span class='c'># no NaNs</span>
<span class='c'>#&gt; [1] compound</span>
<span class='c'>#&gt; &lt;0 rows&gt; (or 0-length row.names)</span>

<span class='c'># check dims before binding</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span>(<span class='k'>vader_comp</span>)
<span class='c'>#&gt; [1] 18440     1</span>
<span class='nf'><a href='https://rdrr.io/r/base/dim.html'>dim</a></span>(<span class='k'>avatar_sentences</span>)
<span class='c'>#&gt; [1] 18440     9</span></code></pre>

</div>

### Step 4: Bind

Time to add the compound vader score back into our dataset and look at the top 10 instances (again). I could have done this code much more condensed; but, I kept it separated so you follow the process.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>avatar_sentences</span> <span class='o'>%&lt;&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/base/cbind.html'>cbind</a></span>(<span class='k'>vader_comp</span>)
<span class='k'>avatar_sentences</span> <span class='o'>%&gt;%</span> <span class='nf'><a href='https://rdrr.io/r/utils/head.html'>head</a></span>(<span class='m'>5</span>) <span class='o'>%&gt;%</span> <span class='k'>knitr</span>::<span class='nf'><a href='https://rdrr.io/pkg/knitr/man/kable.html'>kable</a></span>()
</code></pre>

<table><colgroup><col style="width: 1%" /><col style="width: 2%" /><col style="width: 3%" /><col style="width: 8%" /><col style="width: 4%" /><col style="width: 3%" /><col style="width: 64%" /><col style="width: 4%" /><col style="width: 4%" /><col style="width: 3%" /></colgroup><thead><tr class="header"><th style="text-align: right;">id</th><th style="text-align: left;">book</th><th style="text-align: right;">book_num</th><th style="text-align: left;">chapter</th><th style="text-align: right;">chapter_num</th><th style="text-align: left;">character</th><th style="text-align: left;">character_words</th><th style="text-align: right;">element_id</th><th style="text-align: right;">sentence_id</th><th style="text-align: right;">compound</th></tr></thead><tbody><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Water.</td><td style="text-align: right;">1</td><td style="text-align: right;">1</td><td style="text-align: right;">0.000</td></tr><tr class="even"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Earth.</td><td style="text-align: right;">1</td><td style="text-align: right;">2</td><td style="text-align: right;">0.000</td></tr><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Fire.</td><td style="text-align: right;">1</td><td style="text-align: right;">3</td><td style="text-align: right;">-0.340</td></tr><tr class="even"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">Air.</td><td style="text-align: right;">1</td><td style="text-align: right;">4</td><td style="text-align: right;">0.000</td></tr><tr class="odd"><td style="text-align: right;">1</td><td style="text-align: left;">Water</td><td style="text-align: right;">1</td><td style="text-align: left;">The Boy in the Iceberg</td><td style="text-align: right;">1</td><td style="text-align: left;">Katara</td><td style="text-align: left;">My grandmother used to tell me stories about the old days: a time of peace when the Avatar kept balance between the Water Tribes, Earth Kingdom, Fire Nation and Air Nomads.</td><td style="text-align: right;">1</td><td style="text-align: right;">5</td><td style="text-align: right;">0.273</td></tr></tbody></table>

</div>

Looks good!

Plot Prep
---------

As I prepare to make some plots there are few things I'd like to have available:

1.  An "episode" number so I can sort and chart books 1-3 because chapter numbers are repeated within each book
2.  Reordered characters - based on their median vader score so that the plots look nice.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='c'># create new sequence number for each chapter, because chapter number is repeated within each book</span>
<span class='nf'><a href='https://rdrr.io/r/base/unique.html'>unique</a></span>(<span class='k'>avatar_sentences</span><span class='o'>$</span><span class='k'>chapter_num</span>)
<span class='c'>#&gt;  [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21</span>

<span class='c'># add episode_num</span>
<span class='k'>avatar_sentences</span> <span class='o'>%&lt;&gt;%</span> 
     <span class='nf'>mutate</span>(episode_num = <span class='nf'>case_when</span>(
          <span class='k'>book_num</span> <span class='o'>==</span> <span class='m'>1</span> <span class='o'>~</span> <span class='k'>chapter_num</span>,
          <span class='k'>book_num</span> <span class='o'>==</span> <span class='m'>2</span> <span class='o'>~</span> <span class='k'>chapter_num</span> <span class='o'>+</span> <span class='m'>21</span>,
          <span class='k'>book_num</span> <span class='o'>==</span> <span class='m'>3</span> <span class='o'>~</span> <span class='k'>chapter_num</span> <span class='o'>+</span> <span class='m'>42</span>
     ))

<span class='c'># add in character vader compound median to sort</span>
<span class='k'>avatar_sentences</span> <span class='o'>%&lt;&gt;%</span> 
     <span class='nf'>group_by</span>(<span class='k'>character</span>) <span class='o'>%&gt;%</span> 
     <span class='nf'>mutate</span>(char_vader_mean = <span class='nf'><a href='https://rdrr.io/r/stats/median.html'>median</a></span>(<span class='k'>compound</span>[<span class='k'>compound</span> != <span class='m'>0</span>])) <span class='o'>%&gt;%</span> 
     <span class='nf'>ungroup</span>() <span class='o'>%&gt;%</span> 
     <span class='nf'>mutate</span>(character = <span class='nf'>fct_reorder</span>(<span class='k'>character</span>, <span class='o'>-</span><span class='k'>char_vader_mean</span>))</code></pre>

</div>

Fonts and Themes
----------------

I'm very new to themes and fonts, so not everything worked as well as I'd like. I ended up using some fonts from [Google Fonts](https://fonts.google.com/) referenced this excellent [blog post](https://cedricscherer.netlify.app/2019/05/17/the-evolution-of-a-ggplot-ep.-1/) by Cédric Scherer.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/Ryo-N7/tvthemes'>tvthemes</a></span>) <span class='c'># great ggplot themes and color palettes</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/yixuan/showtext'>showtext</a></span>) <span class='c'># use fonts from google</span>
<span class='nf'><a href='https://rdrr.io/r/base/library.html'>library</a></span>(<span class='k'><a href='https://github.com/wch/extrafont'>extrafont</a></span>) <span class='c'># use computer fonts</span>

<span class='c'>#font_import()</span>
<span class='nf'><a href='https://rdrr.io/pkg/tvthemes/man/import_avatar.html'>import_avatar</a></span>() <span class='c'># import "Slayer" font, will need to loadfonts() to access</span>
<span class='nf'><a href='https://rdrr.io/pkg/extrafont/man/loadfonts.html'>loadfonts</a></span>(device = <span class='s'>"win"</span>) <span class='c'># Load fonts, can take a minute</span>

<span class='c'># with {showtext}, you can load directly from google fonts</span>
<span class='nf'>font_add_google</span>(<span class='s'>"Indie Flower"</span>, <span class='s'>"Indie Flower"</span>)

<span class='c'># Check the current search path for fonts</span>
<span class='c'>#font_paths() </span>

<span class='c'># List available font files in the search path</span>
<span class='c'>#font_files() </span>

<span class='c'># syntax: font_add(family = "&lt;family_name&gt;", regular = "/path/to/font/file")</span>
<span class='c'>#font_add("Palatino", "pala.ttf")</span>

<span class='c'>#font_families()</span>

<span class='nf'><a href='https://rdrr.io/pkg/showtext/man/showtext_auto.html'>showtext_auto</a></span>()</code></pre>

</div>

ggplot Bending
--------------

Code for my primary plot, with comments.

I should also note that I'm still working on developing my plot scaling abilities for rMarkdown, so this code might output the plots with small text for you if you scale up a too high. I often develop and save the plot (the code below), then load the image into the markdown.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>p1</span> <span class='o'>&lt;-</span> <span class='k'>avatar_sentences</span> <span class='o'>%&gt;%</span> 
     <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>character</span> <span class='o'>%in%</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='s'>"Aang"</span>,<span class='s'>"Sokka"</span>,<span class='s'>"Katara"</span>,<span class='s'>"Zuko"</span>,<span class='s'>"Toph"</span>,<span class='s'>"Iroh"</span>,<span class='s'>"Azula"</span>,<span class='s'>"Jet"</span>,<span class='s'>"Suki"</span>,<span class='s'>"Mai"</span>,<span class='s'>"Ty Lee"</span>)) <span class='o'>%&gt;%</span> <span class='c'># only wanted primary characters</span>
     <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>compound</span> != <span class='m'>0</span>) <span class='o'>%&gt;%</span> <span class='c'># pulled out 0 scores, not sure if this is good process or not, but it helps with the viz and tell the story better.</span>
     <span class='nf'>ggplot</span>(<span class='nf'>aes</span>(x = <span class='k'>character</span>, y = <span class='k'>compound</span>, color = <span class='k'>character</span>)) <span class='o'>+</span>
     <span class='nf'>geom_hline</span>(<span class='nf'>aes</span>(yintercept = <span class='m'>0</span>), color = <span class='s'>"black"</span>, size = <span class='m'>0.6</span>) <span class='o'>+</span> <span class='c'># add line at zero (bc I pull all other lines out in the theme)</span>
     <span class='nf'>geom_jitter</span>(position = <span class='nf'>position_jitter</span>(seed = <span class='m'>2020</span>,width = <span class='m'>0.25</span>), size = <span class='m'>1</span>, alpha = <span class='m'>0.15</span>) <span class='o'>+</span> <span class='c'># add a jitter</span>
     <span class='c'>#geom_boxplot(color = "black",stat = "boxplot",outlier.alpha = 0,fill=NA) + #pulled this out, decided to use the lollipops</span>
     <span class='nf'>geom_segment</span>(<span class='nf'>aes</span>(x = <span class='k'>character</span>, xend = <span class='k'>character</span>, y = <span class='m'>0</span>, yend = <span class='k'>char_vader_mean</span>), size = <span class='m'>1.0</span>,color = <span class='s'>"black"</span>) <span class='o'>+</span> <span class='c'># line to zero from median</span>
     <span class='nf'>stat_summary</span>(fun = <span class='k'>stats</span>::<span class='k'><a href='https://rdrr.io/r/stats/median.html'>median</a></span>, geom = <span class='s'>"point"</span>, size = <span class='m'>5</span>, color = <span class='s'>"black"</span>) <span class='o'>+</span> <span class='c'># make a slightly bigger dot</span>
     <span class='nf'>stat_summary</span>(fun = <span class='k'>stats</span>::<span class='k'><a href='https://rdrr.io/r/stats/median.html'>median</a></span>, geom = <span class='s'>"point"</span>, size = <span class='m'>4</span>) <span class='o'>+</span> <span class='c'># fill it in, I think i could have done this in 1x line with fill/color, but I couldn't figure it out quickly.</span>
     <span class='nf'>labs</span>(
          title = <span class='s'>"Water. Earth. Fire. Air. Vader."</span>,
          subtitle = <span class='s'>"Analyzing The Setiment of Avatar's Primary Characters With Compound VADER Scores"</span>,
          y = <span class='s'>"Compound Vader Scores"</span>,
          x = <span class='kr'>NULL</span>,
          caption = <span class='s'>"Data {appa} by Avery Robbins \nTidyTuesday 2020-08-11\n@rbkeeney"</span>
          ) <span class='o'>+</span>
     <span class='nf'>annotate</span>(<span class='s'>"text"</span>, x = <span class='m'>8</span>, y = <span class='m'>1</span>, family = <span class='s'>"Indie Flower"</span>, color = <span class='s'>"gray20"</span>,lineheight = <span class='m'>0.5</span>, size = <span class='m'>6</span>,
              label = <span class='s'>"Every circle represents a sentence spoken by the character.\nA higher score correlates to positive sentiment, zero is neutral"</span>
              ) <span class='o'>+</span>
     <span class='nf'>annotate</span>(<span class='s'>"text"</span>, x = <span class='m'>1</span>, y = <span class='m'>0.8</span>, family = <span class='s'>"Indie Flower"</span>, color = <span class='s'>"gray20"</span>, lineheight = <span class='m'>0.5</span>, size = <span class='m'>6</span>,
              label = <span class='s'>"Ty Lee and Iroh\nwere the most\npostive characters"</span>
              ) <span class='o'>+</span>
     <span class='nf'>annotate</span>(<span class='s'>"text"</span>, x = <span class='m'>1</span>, y = <span class='o'>-</span><span class='m'>0.4</span>, family = <span class='s'>"Indie Flower"</span>, color = <span class='s'>"gray20"</span>,lineheight = <span class='m'>0.5</span>, size = <span class='m'>6</span>,
              label = <span class='s'>"All sentences \nwith a compound \nscore of 0 have \nbeen removed"</span>
              ) <span class='o'>+</span>
     <span class='nf'>annotate</span>(<span class='s'>"text"</span>, x = <span class='m'>11</span>, y = <span class='o'>-</span><span class='m'>0.8</span>, family = <span class='s'>"Indie Flower"</span>, color = <span class='s'>"gray20"</span>,lineheight = <span class='m'>0.5</span>, size = <span class='m'>6</span>,
              label = <span class='s'>"Mai was the only\ncharacter with a \nnegataive median \nsentiment"</span>
              ) <span class='o'>+</span> 
     <span class='nf'><a href='https://rdrr.io/pkg/tvthemes/man/theme_avatar.html'>theme_avatar</a></span>(
          title.font = <span class='s'>"Indie Flower"</span>, <span class='c'># wanted to use slayer, but issues getting loaded.</span>
          text.font = <span class='s'>"Indie Flower"</span>,
          title.size = <span class='m'>36</span>,
          subtitle.size = <span class='m'>24</span>
     ) <span class='o'>+</span>
     <span class='nf'>theme</span>(
          axis.title = <span class='nf'>element_text</span>(size=<span class='m'>24</span>),
          axis.text = <span class='nf'>element_text</span>(size=<span class='m'>24</span>),
          legend.position = <span class='s'>"none"</span>, <span class='c'># remove legend</span>
          plot.caption = <span class='nf'>element_text</span>(size = <span class='m'>16</span>, color = <span class='s'>"grey20"</span>,lineheight = <span class='m'>0.5</span>), <span class='c'>#update caption</span>
          panel.grid.major = <span class='nf'>element_blank</span>(), <span class='c'># remove plot grids</span>
          panel.grid.minor = <span class='nf'>element_blank</span>(), <span class='c'># remove plot grids</span>
          panel.border = <span class='nf'>element_rect</span>(colour = <span class='s'>"black"</span>,fill = <span class='m'>NA</span>), <span class='c'># box the plot. I like it. Fill = NA ~ no fill.</span>
          axis.line = <span class='nf'>element_line</span>(colour = <span class='s'>"black"</span>),
          )

<span class='c'># match arrows to annotations... takes time, go arrow by arrow.</span>
<span class='k'>p1_arrows</span> <span class='o'>&lt;-</span> <span class='nf'>tibble</span>(
     x1 = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>1.0</span>, <span class='m'>1.0</span>, <span class='m'>8.5</span>,<span class='m'>1</span>,<span class='m'>10.6</span>),
     x2 = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>1.0</span>, <span class='m'>2.0</span>, <span class='m'>8.3</span>,<span class='m'>1</span>,<span class='m'>10.9</span>),
     y1 = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>0.67</span>, <span class='m'>0.67</span>, <span class='m'>0.9</span>,<span class='o'>-</span><span class='m'>.25</span>,<span class='o'>-</span><span class='m'>.65</span>), 
     y2 = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>0.45</span>, <span class='m'>0.38</span>, <span class='m'>0.76</span>,<span class='o'>-</span><span class='m'>.05</span>,<span class='o'>-</span><span class='m'>.1</span>)
     )

<span class='c'># combine into final plot</span>
<span class='k'>p1_final</span> <span class='o'>&lt;-</span> <span class='k'>p1</span> <span class='o'>+</span> <span class='nf'>geom_curve</span>(
     data = <span class='k'>p1_arrows</span>, <span class='nf'>aes</span>(x = <span class='k'>x1</span>, y = <span class='k'>y1</span>, xend = <span class='k'>x2</span>, yend = <span class='k'>y2</span>),
     arrow = <span class='nf'>arrow</span>(length = <span class='nf'>unit</span>(<span class='m'>0.07</span>, <span class='s'>"inch"</span>)), size = <span class='m'>0.4</span>,
     color = <span class='s'>"gray40"</span>, curvature = <span class='o'>-</span><span class='m'>0.2</span>
     )

<span class='c'># To create better pictures for the markdown (1) save it, and (2) then call it in markdown text with: ![alt text here](path-to-image-here)</span>
<span class='c'># for referecne, this is what roughly outputs on the screen, moving up dpi will shrink the text...</span>
<span class='c'># ggsave(p1_final, filename = "figs/Rplot1.png", dpi = 96, type = "cairo", width = 7, height = 5, units = "in")</span>
<span class='c'># dpi: 72-96 for web... 300-400 for high res stuff</span>

<span class='c'># save high res</span>
<span class='nf'>ggsave</span>(<span class='k'>p1_final</span>, filename = <span class='s'>"figs/Rplot1.png"</span>, dpi = <span class='m'>300</span>, type = <span class='s'>"cairo"</span>, width = <span class='m'>7</span>, height = <span class='m'>5</span>, units = <span class='s'>"in"</span>)

<span class='c'># open high res, for iteration (comment out once done)</span>
<span class='c'># img_1 &lt;- magick::image_read('figs/Rplot1.png')</span>
<span class='c'># print(img_1)</span></code></pre>

</div>

<!-- ![alt text here](path-to-image-here) -->

![TidyTuesday rbkeeney plot 1, Analyzing the setiment of avatars primary characters](figs/Rplot1.png)

Code for my secondary plot. Playing around with facet\_wrap() this time.

<div class="highlight">

<pre class='chroma'><code class='language-r' data-lang='r'><span class='k'>p2</span> <span class='o'>&lt;-</span> <span class='k'>avatar_sentences</span> <span class='o'>%&gt;%</span> 
     <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>character</span> <span class='o'>%in%</span> <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='s'>"Aang"</span>,<span class='s'>"Sokka"</span>,<span class='s'>"Katara"</span>,<span class='s'>"Zuko"</span>,<span class='s'>"Toph"</span>,<span class='s'>"Iroh"</span>)) <span class='o'>%&gt;%</span> 
     <span class='nf'><a href='https://rdrr.io/r/stats/filter.html'>filter</a></span>(<span class='k'>compound</span> != <span class='m'>0</span>) <span class='o'>%&gt;%</span> 
     <span class='c'>#filter(book == "Water") %&gt;% </span>
     <span class='nf'>ggplot</span>(<span class='nf'>aes</span>(x = <span class='k'>episode_num</span>, y = <span class='k'>compound</span>, color = <span class='k'>character</span>)) <span class='o'>+</span>
     <span class='c'>#geom_point(alpha = 0.6) +</span>
     <span class='c'>#geom_jitter() +</span>
     <span class='nf'>geom_smooth</span>(method = <span class='k'>loess</span>, se = <span class='k'>F</span>, formula = <span class='k'>y</span> <span class='o'>~</span> <span class='k'>x</span>) <span class='o'>+</span>
     <span class='nf'>facet_wrap</span>(<span class='o'>~</span> <span class='k'>character</span>) <span class='o'>+</span> 
     <span class='nf'>coord_cartesian</span>(ylim = <span class='nf'><a href='https://rdrr.io/r/base/c.html'>c</a></span>(<span class='m'>0</span>,<span class='m'>0.3</span>)) <span class='o'>+</span>
     <span class='nf'>labs</span>(
          title = <span class='s'>"Water. Earth. Fire. Air. Vader."</span>,
          subtitle = <span class='s'>"Analyzing The Change in Setiment Avatar's Primary Characters With Compound VADER Scores Over The Duration Of The Series"</span>,
          y = <span class='s'>"Compound VADER Scores"</span>,
          x = <span class='s'>"Nth Episode"</span>,
          caption = <span class='s'>"Data {appa} by Avery Robbins \nTidyTuesday 2020-08-11\n@rbkeeney"</span>
          ) <span class='o'>+</span>
     <span class='nf'><a href='https://rdrr.io/pkg/tvthemes/man/theme_avatar.html'>theme_avatar</a></span>(
          title.font = <span class='s'>"Indie Flower"</span>,
          title.size = <span class='m'>36</span>,
          text.font = <span class='s'>"Indie Flower"</span>,
          subtitle.size = <span class='m'>24</span>,
     ) <span class='o'>+</span>
     <span class='nf'>theme</span>(
          text = <span class='nf'>element_text</span>(size = <span class='m'>28</span>, lineheight = <span class='m'>0.5</span>),
          axis.title = <span class='nf'>element_text</span>(size=<span class='m'>24</span>),
          axis.text = <span class='nf'>element_text</span>(size=<span class='m'>24</span>),
          legend.position = <span class='s'>"none"</span>,
          plot.caption = <span class='nf'>element_text</span>(color = <span class='s'>"grey20"</span>, size = <span class='m'>16</span>),
          panel.grid.major = <span class='nf'>element_blank</span>(), 
          panel.grid.minor = <span class='nf'>element_blank</span>(),
          panel.border = <span class='nf'>element_rect</span>(colour = <span class='s'>"black"</span>,fill = <span class='m'>NA</span>),
          axis.line = <span class='nf'>element_line</span>(colour = <span class='s'>"black"</span>)
          )

<span class='nf'>ggsave</span>(<span class='k'>p2</span>, filename = <span class='s'>"figs/Rplot2.png"</span>, dpi = <span class='m'>300</span>, type = <span class='s'>"cairo"</span>, width = <span class='m'>7</span>, height = <span class='m'>5</span>, units = <span class='s'>"in"</span>)
<span class='c'># open high res, for iteration (comment out once done)</span>
<span class='c'>#img_2 &lt;- magick::image_read('figs/Rplot2.png')</span>
<span class='c'>#print(img_2)</span></code></pre>

</div>

<!-- ![alt text here](path-to-image-here) -->

![TidyTuesday rbkeeney plot 2, Analyzing the setiment of avatars primary characters](figs/Rplot2.png)

That wraps it up! Cheers, Ryan

