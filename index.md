---
knit: "bookdown::render_book"
title: "Causal Mediation: Modern Methods for Path Analysis"
subtitle: "A Workshop at SER 2021"
author: "Iván Díaz, Nima Hejazi, Kara Rudolph"
date: "updated: May 20, 2021"
documentclass: book
site: bookdown::bookdown_site
bibliography: [book.bib, packages.bib]
biblio-style: apalike
fontsize: '12pt'
monofontoptions: "Scale=0.7"
link-citations: no
colorlinks: yes
lot: false
lof: false
always_allow_html: yes
url: 'https\://code.nimahejazi.org/ser2021_mediation_workshop/'
github-repo: nhejazi/ser2021_mediation_workshop
graphics: yes
description: "Open source, reproducible teaching materials accompanying a
  workshop on modern methods for causal mediation analysis, given at the [SER
  2021 Meeting](https://epiresearch.org/annual-meeting/2021-meeting/workshop/)
  on Monday, 24 May 2021."
---

# Welcome to SER! {-}

This open source, reproducible vignette accompanies a half-day workshop on
modern methods for _causal mediation analysis_, given at the [SER 2021
Meeting](https://epiresearch.org/annual-meeting/2021-meeting/workshop/) on
Monday, 24 May 2021. While we encourage use of this `bookdown` site, for
convenience, we have also made these workshop materials [available in
PDF](https://code.nimahejazi.org/ser2021_mediation_workshop/ser2021mediation.pdf).
Discussion will take place _on Slack_ -- first join the workspace
[here](https://join.slack.com/t/moderncausalmediation/shared_invite/zt-qd2ocx45-XlKvMA9FXlsixnwI7VnbHQ),
then the "#ser2021" channel.

## About this workshop {#about}

Causal mediation analysis can provide a mechanistic understanding of how an
exposure impacts an outcome, a central goal in epidemiology and health sciences.
However, rapid methodologic developments coupled with few formal courses
presents challenges to implementation. Beginning with an overview of classical
direct and indirect effects, this workshop will present recent advances that
overcome limitations of previous methods, allowing for: (i) continuous
exposures, (ii) multiple, non-independent mediators, and (iii) effects
identifiable in the presence of intermediate confounders affected by exposure.
Emphasis will be placed on flexible, stochastic and interventional direct and
indirect effects, highlighting how these may be applied to answer substantive
epidemiological questions from real-world studies. Multiply robust,
nonparametric estimators of these causal effects, and free and open source `R`
packages ([`medshift`](https://github.com/nhejazi/medshift) and
[`medoutcon`](https://github.com/nhejazi/medoutcon)) for their application, will
be introduced.

To ensure translation to real-world data analysis, this workshop will
incorporate hands-on `R` programming exercises to allow participants practice in
implementing the statistical tools presented. It is recommended that
participants have working knowledge of the basic notions of causal inference,
including counterfactuals and identification (linking the causal effect to a
parameter estimable from the observed data distribution). Familiarity with the
`R` programming language is also recommended.

## Workshop schedule {#schedule}

* 09:00A-09:30A: Introductions + mediation set-up
  <!-- Ivan-->
* 09:30A-10:15A: Controlled direct effects, natural direct/indirect effects,
  interventional direct/indirect effects
  <!-- Kara-->
* 10:15A-10:45A: Stochastic mediation estimands
  <!-- Nima-->
* 10:45A-11:00A: Choosing an estimand in real-world examples
  <!-- Kara-->
* 11:00A-11:15A: Break + discussion
* 11:15A-11:45A: What is the EIF?!
  <!-- Ivan-->
* 11:45A-12:00P: Using the EIF for estimating the natural direct effect
  <!-- Ivan-->
* 12:00P-12:45P: Example walkthrough with `R` packages for effect estimation
  <!-- Nima-->
* 12:45P-01:00P: Wrap-up

__NOTE: All times listed in Pacific Time.__

## About the instructors {#instructors}

### Iván Díaz {-}

I am an Assistant Professor at Weill Cornel Medicine. My research focuses on the
development of non-parametric statistical methods for causal inference from
observational and randomized studies with complex datasets, using machine
learning. This includes but is not limited to mediation analysis, methods for
continuous exposures, longitudinal data including survival analysis, and
efficiency guarantees with covariate adjustment in randomized trials. I am also
interested in general semi-parametric theory, machine learning, and
high-dimensional data.

### Nima Hejazi {-}

I am a PhD candidate in biostatistics at UC Berkeley, working under the joint
direction of Mark van der Laan and Alan Hubbard. My research interests fall at
the intersection of causal inference and machine learning, drawing on ideas from
non/semi-parametric estimation in large, flexible statistical models. Particular
areas of current emphasis include causal mediation analysis, corrections for
outcome-dependent sampling designs, targeted loss-based estimation, and
applications in vaccine efficacy trials. I am also passionate about statistical
computing and open source software development for applied statistics.

### Kara Rudolph {-}

I am an Assistant Professor of Epidemiology at Columbia University. My research
interests are in developing and applying causal inference methods to understand
social and contextual influences on mental health, substance use, and violence
in disadvantaged, urban areas of the United States. My current work focuses on
developing methods for transportability and mediation, and subsequently applying
those methods to understand how aspects of the school and peer environments
mediate relationships between neighborhood factors and adolescent drug use
across populations.  More generally, my work on generalizing/ transporting
findings from study samples to target populations and identifying subpopulations
most likely to benefit from interventions contributes to efforts to optimally
target available policy and program resources.

## Reproduciblity {#repro}

These workshop materials were written using [bookdown](http://bookdown.org/),
and the complete source is available on
[GitHub](https://github.com/tlverse/tlverse-handbook).  This version of the book
was built with R version 4.0.5 (2021-03-31), [pandoc](https://pandoc.org/) version `r
rmarkdown::pandoc_version()`, and the following packages:


|package    |version    |source                              |
|:----------|:----------|:-----------------------------------|
|bookdown   |0.21.11    |Github (rstudio/bookdown\@33c4f70)  |
|bslib      |0.2.4.9003 |Github (rstudio/bslib\@e09af88)     |
|data.table |1.14.0     |CRAN (R 4.0.5)                      |
|downlit    |0.2.1      |CRAN (R 4.0.5)                      |
|dplyr      |1.0.6      |CRAN (R 4.0.5)                      |
|ggfortify  |0.4.11     |CRAN (R 4.0.5)                      |
|ggplot2    |3.3.3      |CRAN (R 4.0.5)                      |
|kableExtra |1.3.4      |CRAN (R 4.0.5)                      |
|knitr      |1.32       |CRAN (R 4.0.5)                      |
|magick     |2.7.1      |CRAN (R 4.0.5)                      |
|medoutcon  |0.1.5      |Github (nhejazi/medoutcon\@39820e2) |
|medshift   |0.1.4      |Github (nhejazi/medshift\@f9e11a9)  |
|mvtnorm    |1.1-1      |CRAN (R 4.0.5)                      |
|origami    |1.0.3      |CRAN (R 4.0.5)                      |
|pdftools   |2.3.1      |CRAN (R 4.0.5)                      |
|readr      |1.4.0      |CRAN (R 4.0.5)                      |
|rmarkdown  |2.7.11     |Github (rstudio/rmarkdown\@e340d75) |
|skimr      |2.1.3      |CRAN (R 4.0.5)                      |
|sl3        |1.4.3      |Github (tlverse/sl3\@5cddc6c)       |
|stringr    |1.4.0      |CRAN (R 4.0.5)                      |
|tibble     |3.1.1      |CRAN (R 4.0.5)                      |
|tidyr      |1.1.3      |CRAN (R 4.0.5)                      |

## Setup instructions {#setup}

### R and RStudio

**R** and **RStudio** are separate downloads and installations. R is the
underlying statistical computing environment. RStudio is a graphical integrated
development environment (IDE) that makes using R much easier and more
interactive. You need to install R before you install RStudio.

#### Windows

##### If you already have R and RStudio installed

* Open RStudio, and click on "Help" > "Check for updates". If a new version is
  available, quit RStudio, and download the latest version for RStudio.
* To check which version of R you are using, start RStudio and the first thing
  that appears in the console indicates the version of R you are
  running. Alternatively, you can type `sessionInfo()`, which will also display
  which version of R you are running. Go on the [CRAN
  website](https://cran.r-project.org/bin/windows/base/) and check whether a
  more recent version is available. If so, please download and install it. You
  can [check here](https://cran.r-project.org/bin/windows/base/rw-FAQ.html#How-do-I-UNinstall-R_003f)
  for more information on how to remove old versions from your system if you
  wish to do so.

##### If you don't have R and RStudio installed

* Download R from
  the [CRAN website](http://cran.r-project.org/bin/windows/base/release.htm).
* Run the `.exe` file that was just downloaded
* Go to the [RStudio download
  page](https://www.rstudio.com/products/rstudio/download/#download)
* Under *Installers* select **RStudio x.yy.zzz - Windows
  XP/Vista/7/8** (where x, y, and z represent version numbers)
* Double click the file to install it
* Once it's installed, open RStudio to make sure it works and you don't get any
  error messages.

#### Mac OSX

##### If you already have R and RStudio installed

* Open RStudio, and click on "Help" > "Check for updates". If a new version is
  available, quit RStudio, and download the latest version for RStudio.
* To check the version of R you are using, start RStudio and the first thing
  that appears on the terminal indicates the version of R you are running.
  Alternatively, you can type `sessionInfo()`, which will also display which
  version of R you are running. Go on the [CRAN
  website](https://cran.r-project.org/bin/macosx/) and check whether a more
  recent version is available. If so, please download and install it.

##### If you don't have R and RStudio installed

* Download R from the [CRAN website](http://cran.r-project.org/bin/macosx).
* Select the `.pkg` file for the latest R version
* Double click on the downloaded file to install R
* It is also a good idea to install [XQuartz](https://www.xquartz.org/) (needed
  by some packages)
* Go to the [RStudio download
  page](https://www.rstudio.com/products/rstudio/download/#download)
* Under *Installers* select **RStudio x.yy.zzz - Mac OS X 10.6+ (64-bit)**
  (where x, y, and z represent version numbers)
* Double click the file to install RStudio
* Once it's installed, open RStudio to make sure it works and you don't get any
  error messages.

#### Linux

* Follow the instructions for your distribution from
  [CRAN](https://cloud.r-project.org/bin/linux), they provide information to get
  the most recent version of R for common distributions. For most distributions,
  you could use your package manager (e.g., for Debian/Ubuntu run `sudo apt-get
  install r-base`, and for Fedora `sudo yum install R`), but we don't recommend
  this approach as the versions provided by this are usually out of date. In any
  case, make sure you have at least R 3.3.1.
* Go to the [RStudio download
  page](https://www.rstudio.com/products/rstudio/download/#download)
* Under *Installers* select the version that matches your distribution, and
  install it with your preferred method (e.g., with Debian/Ubuntu `sudo dpkg -i
  rstudio-x.yy.zzz-amd64.deb` at the terminal).
* Once it's installed, open RStudio to make sure it works and you don't get any
  error messages.

These setup instructions are adapted from those written for [Data Carpentry: R
for Data Analysis and Visualization of Ecological
Data](http://www.datacarpentry.org/R-ecology-lesson/).

### Virtual Enironment setup with `renv` {#renv}

These instructions are intended to help with setting up the included [`renv`
virtual environment](https://rstudio.github.io/renv/index.html), which ensures
all participants are using the same exact set of `R` packages (and package
versions). A few important notes to keep in mind:

* When `R` is started from the top level of this repository, `renv` is
  activated automatically. There is no further action required on your part. If
  `renv` is not installed, it will be installed automatically, assuming that you
  have an active internet connection.
* While `renv` is active, the `R` session will only have access to the packages
  (and their dependencies) that are listed in the `renv.lock` file -- that is,
  you should not expect to have access to any other `R` packages that may be
  installed elsewhere on the computing system in use.
* Upon an initial attempt, `renv` will prompt you to install packages listed in
  the `renv.lock` file, by printing a message like the following:

```r
# * Project 'PATH/TO/ser2021_mediation_workshop' loaded. [renv 0.13.2]
# * The project may be out of sync -- use `renv::status()` for more details.
> renv::status()
# The following package(s) are recorded in the lockfile, but not installed:
# Use `renv::restore()` to install these packages.
```
In any such case, please call `renv::restore()` to install any missing packages.
Note that you do _not_ need to manually install the packages via
`install.packages()`, `remotes::install_github()`, or similar.

For details on how the `renv` system works, the following references may be
helpful:

1. [Collaborating with
    `renv`](https://rstudio.github.io/renv/articles/collaborating.html)
2. [Introduction to `renv`](https://rstudio.github.io/renv/articles/renv.html)

In some rare cases, `R` packages that `renv` automatically tries to install as
part of the `renv::restore()` process may fail due to missing systems-level
dependencies. In such cases, a reference to the missing dependencies and
system-specific instructions their installation involving, e.g., [Ubuntu
Linux's `apt`](http://manpages.ubuntu.com/manpages/bionic/man8/apt.8.html) or
[`homebrew` for macOS](https://brew.sh/), will usually be displayed.
