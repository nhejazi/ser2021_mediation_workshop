---
knit: "bookdown::render_book"
title: "Causal Mediation Analysis: Modern Methods for Path Analysis"
author: "Iván Díaz, Nima Hejazi, Kara Rudolph"
date: "March 23, 2021"
documentclass: book
site: bookdown::bookdown_site
bibliography: [book.bib, packages.bib]
biblio-style: apalike
suppress-bibliography: true
link-citations: yes
colorlinks: yes
graphics: yes
lot: yes
lof: yes
always_allow_html: yes
---

# About this workshop {-}

Causal mediation analysis can provide a mechanistic understanding of how an exposure impacts 
an outcome, a central goal in epidemiology and health sciences. However, rapid methodologic 
developments coupled with few formal courses presents challenges to implementation. Beginning 
with an overview of classical direct and indirect effects, this workshop will present recent 
advances that overcome limitations of previous methods, allowing for: (i) continuous exposures, 
(ii) multiple, non-independent mediators, and (iii) effects identifiable in the presence of 
intermediate confounders affected by exposure. Emphasis will be placed on flexible, stochastic 
and interventional direct and indirect effects, highlighting how these may be applied to answer 
substantive epidemiological questions from real-world studies. Multiply robust, nonparametric 
estimators of these causal effects, and free and open source `R` packages (`medshift` and 
`medoutcon`) for their application, will be introduced.

To ensure translation to real-world data analysis, this workshop will incorporate hands-on `R` 
programming exercises to allow participants practice in implementing the statistical tools 
presented. It is recommended that participants have working knowledge of the basic notions of 
causal inference, including counterfactuals and identification (linking the causal effect to a 
parameter estimable from the observed data distribution). Familiarity with the `R` programming 
language is also recommended.


## Workshop schedule {#schedule}

* 10-10:30 introductions/mediation set up
* 10:30-11 estimands and how to choose

* 11-11:30 discussion: how to choose in real-world examples

* 11:30-noon shift parameter introduction with application in the lecture part

* Noon-12:15 break/discussion

* 12:15-12:45 estimation for natural direct and indirect effects, interventional direct and indirect effects
* 12:45-1:15 practice: code for estimation

* 1:15 -1:30 estimation for stochastic interventional direct and indirect effects
* 1:30-1:50 practice: code for estimation

* 1:50-2 wrap up

## About the authors {-}

### Iván Díaz {-}

My research focuses on the development of non-parametric statistical methods for 
causal inference from observational and randomized studies with complex datasets, 
using machine learning. This includes but is not limited to mediation analysis, 
methods for continuous exposures, longitudinal data including survival analysis, 
and efficiency guarantees with covariate adjustment in randomized trials. I am 
also interested in general semi-parametric theory, machine learning, and 
high-dimensional data.

### Nima Hejazi {-}

Nima Hejazi is a PhD candidate in biostatistics, working under the collaborative
direction of Mark van der Laan and Alan Hubbard. Nima is affiliated with UC
Berkeley's Center for Computational Biology and NIH Biomedical Big Data training
program, as well as with the Fred Hutchinson Cancer Research Center. Previously,
he earned an MA in Biostatistics and a BA (with majors in Molecular and Cell
Biology, Psychology, and Public Health), both at UC Berkeley.  His research
interests fall at the intersection of causal inference and machine learning,
drawing on ideas from non/semi-parametric estimation in large, flexible
statistical models to develop efficient and robust statistical procedures for
evaluating complex target estimands in observational and randomized studies.
Particular areas of current emphasis include mediation/path analysis,
outcome-dependent sampling designs, targeted loss-based estimation, and vaccine
efficacy trials.  Nima is also passionate about statistical computing and open
source software development for applied statistics.

### Kara Rudolph {-}

I am an Assistant Professor of Epidemiology at Columbia University. My research 
interests are in developing and applying causal inference methods to understand 
social and contextual influences on mental health, substance use, and violence 
in disadvantaged, urban areas of the United States. My current work focuses on 
developing methods for transportability and mediation, and subsequently applying 
those methods to understand how aspects of the school and peer environments mediate 
relationships between neighborhood factors and adolescent drug use across populations. 
More generally, my work on generalizing/ transporting findings from study samples 
to target populations and identifying subpopulations most likely to benefit from 
interventions contributes to efforts to optimally target available policy and program 
resources.

<!--
# Acknowledgements {-}
-->

## Reproduciblity {#repro}

These workshop materials were written using [bookdown](http://bookdown.org/),
and the complete source is available on
[GitHub](https://github.com/tlverse/tlverse-handbook).  This version of the book
was built with R version 4.0.4 (2021-02-15), [pandoc](https://pandoc.org/) version `r
rmarkdown::pandoc_version()`, and the following packages:


|package      |version    |source                              |
|:------------|:----------|:-----------------------------------|
|bookdown     |0.21.7     |Github (rstudio/bookdown\@b66380e)  |
|bslib        |0.2.4.9002 |Github (rstudio/bslib\@b2b4e55)     |
|dagitty      |0.3-1      |CRAN (R 4.0.4)                      |
|data.table   |1.14.0     |CRAN (R 4.0.4)                      |
|downlit      |0.2.1      |CRAN (R 4.0.4)                      |
|dplyr        |1.0.5      |CRAN (R 4.0.4)                      |
|forecast     |8.13       |CRAN (R 4.0.4)                      |
|ggdag        |0.2.3      |CRAN (R 4.0.4)                      |
|ggfortify    |0.4.11     |CRAN (R 4.0.4)                      |
|ggplot2      |3.3.3      |CRAN (R 4.0.4)                      |
|hal9001      |0.2.8      |Github (tlverse/hal9001\@3f0503f)   |
|kableExtra   |1.3.1      |CRAN (R 4.0.4)                      |
|knitr        |1.31       |CRAN (R 4.0.4)                      |
|medoutcon    |0.1.0      |Github (nhejazi/medoutcon\@f8f14c4) |
|medshift     |0.1.4      |Github (nhejazi/medshift\@f9e11a9)  |
|mvtnorm      |1.1-1      |CRAN (R 4.0.4)                      |
|origami      |1.0.3      |CRAN (R 4.0.4)                      |
|randomForest |4.6-14     |CRAN (R 4.0.4)                      |
|readr        |1.4.0      |CRAN (R 4.0.4)                      |
|rmarkdown    |2.7.4      |Github (rstudio/rmarkdown\@1450461) |
|skimr        |2.1.2      |CRAN (R 4.0.4)                      |
|sl3          |1.4.3      |Github (tlverse/sl3\@3950846)       |
|stringr      |1.4.0      |CRAN (R 4.0.4)                      |
|tibble       |3.1.0      |CRAN (R 4.0.4)                      |
|tidyr        |1.1.3      |CRAN (R 4.0.4)                      |

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

#### macOS / Mac OS X

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

* Download R from
  the [CRAN website](http://cran.r-project.org/bin/macosx).
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

* Follow the instructions for your distribution
  from [CRAN](https://cloud.r-project.org/bin/linux), they provide information
  to get the most recent version of R for common distributions. For most
  distributions, you could use your package manager (e.g., for Debian/Ubuntu run
  `sudo apt-get install r-base`, and for Fedora `sudo yum install R`), but we
  don't recommend this approach as the versions provided by this are
  usually out of date. In any case, make sure you have at least R 3.3.1.
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