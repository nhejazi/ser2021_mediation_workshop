---
knit: "bookdown::render_book"
title: "[SER 2021 Workshop] Causal Mediation: Modern Methods for Path Analysis"
author: "Iván Díaz, Nima Hejazi, Kara Rudolph"
date: "updated: April 27, 2021"
documentclass: book
site: bookdown::bookdown_site
bibliography: [book.bib, packages.bib]
biblio-style: apalike
fontsize: '12pt, krantz2'
monofontoptions: "Scale=0.7"
link-citations: yes
colorlinks: yes
lot: no
lof: no
always_allow_html: yes
url: 'https\://code.nimahejazi.org/ser2021_mediation_workshop/'
github-repo: nhejazi/ser2021_mediation_workshop
graphics: yes
description: "Open source, reproducible teaching materials accompanying a
  workshop on modern methods for causal mediation analysis, given at the [SER
  2021 Meeting]() on Monday, 24 May 2021."
---

# Welcome to SER! {-}

This open source, reproducible vignette accompanies a half-day workshop on
modern methods for _causal mediation analysis_, given at the [SER 2021
Meeting]() on Monday, 24 May 2021. While we encourage use of this `bookdown`
site, for convenience, we have also made these workshop materials [available in
PDF](https://code.nimahejazi.org/ser2021_mediation_workshop/ser2021mediation.pdf).

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

* 10:00A-10:30A: introductions/mediation set up
* 10:30A-11:00A: estimands and how to choose
* 11:00A-11:30A: discussion: how to choose in real-world examples
* 11:30A-12:00P: shift parameter introduction with application in lecture part
* 12:00P-12:15P break/discussion
* 12:15P-12:45P estimation for natural direct and indirect effects,
  interventional direct and indirect effects
* 12:45P-01:15P: practice `R` code for estimation
* 01:15P-01:30P: estimation for stochastic interventional direct and indirect
  effects
* 01:30P-01:50P: practice: code for estimation
* 01:50P-02:00P wrap up

__NOTE: All times listed in Pacific Time.__

## About the instructors {#instructors}

### Iván Díaz {-}

I am an Assistant Professor at Weill Cornel Medicine. My research
focuses on the development of non-parametric statistical methods for
causal inference from observational and randomized studies with
complex datasets, using machine learning. This includes but is not
limited to mediation analysis, methods for continuous exposures,
longitudinal data including survival analysis, and efficiency
guarantees with covariate adjustment in randomized trials. I am also
interested in general semi-parametric theory, machine learning, and
high-dimensional data.

### Nima Hejazi {-}

I am a PhD candidate in biostatistics at UC Berkeley, working under the joint
direction of Mark van der Laan and Alan Hubbard. My research interests fall at
the intersection of causal inference and machine learning, drawing on ideas from
non/semi-parametric estimation in large, flexible statistical models to develop
efficient and robust statistical procedures for evaluating complex target
estimands in observational and randomized studies.  Particular areas of current
emphasis include causal mediation/path analysis, outcome-dependent sampling
designs, targeted loss-based estimation, and applications in vaccine efficacy
trials. I am also passionate about statistical computing and open source
software development for applied statistics.

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
was built with R version 4.0.2 (2020-06-22), [pandoc](https://pandoc.org/) version `r
rmarkdown::pandoc_version()`, and the following packages:



