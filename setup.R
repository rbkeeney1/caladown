# Caladown Set-up Script
# https://www.youtube.com/watch?v=HtQhG80MKQE


# Initial install
remotes::install_github("djnavarro/caladown")
hugodown::hugo_install("0.66.0")


# Create website (run 1x time)
caladown::create_hugodown_calade()


# After launched...
library(hugodown) # for website stuffs
library(usethis) # for githup link
library(git2r)


# To launch the site:
hugodown::hugo_start()


# Create post
use_post("post/my-new-post") # creates new index.rmd w/ folder in posts folder

# Create repo
usethis::use_git()
# save C:/Users/keene/Documents/R Projects/caladown

# push repo out (i think)
usethis::git_sitrep() # check auth key for github
usethis::use_github()
# for this to work the 1st time, I had to set the directory to this folder in bash: cd "C:/Users/keene/Documents/R Projects/caladown"
# then forced via: git push --set-upstream origin master
# if locked... use: rm -f .git/index.lock




# to create a new page, use above, then knit it, then use code below and commit + push updates out
unlink("docs", recursive = TRUE) # delete a directory -- must add recursive = TRUE
hugodown::hugo_build(dest = "docs")
