# `R` packages for estimation of the causal (in)direct effects

We'll now turn to working through a few examples of estimating the natural,
interventional, and stochastic direct and indirect effects. As our running
example, we'll a simple data set from an observational study of the relationship
between BMI and kids' behavior, freely distributed with the [`mma` `R` package
on CRAN](https://CRAN.R-project.org/package=mma). First, let's load the packages
we'll be using and set a seed; then, load this data set and take a quick look


```r
library(tidyverse)
library(sl3)
library(medoutcon)
library(medshift)
library(mma)
set.seed(429153)
```


```r
# load and examine data
data(weight_behavior)
dim(weight_behavior)
#> [1] 691  15

# drop missing values
weight_behavior <- weight_behavior %>%
  drop_na() %>%
  as_tibble()
weight_behavior
#> # A tibble: 567 x 15
#>     bmi   age sex   race  numpeople   car gotosch snack tvhours cmpthours
#>   <dbl> <dbl> <fct> <fct>     <int> <int> <fct>   <fct>   <dbl>     <dbl>
#> 1  18.2  12.2 F     OTHER         5     3 2       1           4         0
#> 2  22.8  12.8 M     OTHER         4     3 2       1           4         2
#> 3  25.6  12.1 M     OTHER         2     3 2       1           0         2
#> 4  15.1  12.3 M     OTHER         4     1 2       1           2         1
#> 5  23.0  11.8 M     OTHER         4     1 1       1           4         3
#> # … with 562 more rows, and 5 more variables: cellhours <dbl>, sports <fct>,
#> #   exercises <int>, sweat <int>, overweigh <dbl>
```

The documentation for the data set describes it as a "database obtained from the
Louisiana State University Health Sciences Center, New Orleans, by Dr. Richard
Scribner. He explored the relationship between BMI and kids' behavior through a
survey at children, teachers and parents in Grenada in 2014. This data set
includes 691 observations and 15 variables." Note that the data set contained
several observations with missing values, which we removed above to simplify the
demonstration of our analytic methods. In practice, we recommend instead using
appropriate corrections (e.g., imputation, inverse weighting) to fully take
advantage of the observed data.

Following the motivation of the original study, we focus on the causal effects
of participating in a sports team (`sports`) on the BMI of children (`bmi`),
taking into consideration several mediators (`snack`, `exercises`, `overweigh`);
all other measured covariates are taken to be potential baseline confounders.

## `medoutcon`: Natural and interventional (in)direct effects

The data on a single observational unit can be represented $O = (W, A, M, Y)$,
with the data pooled across all participants denoted $O_1, \ldots, O_n$, for a
of $n$ i.i.d. observations of $O$. Recall the DAG [from an earlier
chapter](#estimands), which represents the data-generating process:

<div class="figure" style="text-align: center">
<img src="07-estimation-stochastic_files/figure-html/unnamed-chunk-1-1.png" alt="Directed acyclic graph under *no intermediate confounders* of the mediator-outcome relation affected by treatment" width="80%" />
<p class="caption">(\#fig:unnamed-chunk-1)Directed acyclic graph under *no intermediate confounders* of the mediator-outcome relation affected by treatment</p>
</div>

### Natural (in)direct effects

To start, we will consider estimation of the _natural_ direct and indirect effects,
which, we recall, are defined as follows
\begin{equation*}
  \E[Y_{1,M_1} - Y_{0,M_0}] = \underbrace{\E[Y_{\color{red}{1},\color{blue}{M_1}} -
    Y_{\color{red}{1},\color{blue}{M_0}}]}_{\text{natural indirect effect}} +
    \underbrace{\E[Y_{\color{blue}{1},\color{red}{M_0}} -
    Y_{\color{blue}{0},\color{red}{M_0}}]}_{\text{natural direct effect}}.
\end{equation*}

* Our [`medoutcon` `R` package](https://github.com/nhejazi/medoutcon)
  [@hejazi2021medoutcon], which accompanies @diaz2020nonparametric, implements
  one-step and TML estimators of both the natural and interventional (in)direct
  effects.
* Both types of estimators are capable of accommodating flexible modeling
  strategies (e.g., ensemble machine learning) for the initial estimation of
  nuisance parameters.
* The `medoutcon` `R` package uses cross-validation in initial estimation: this
  results in cross-validated (or "cross-fitted") one-step and TML estimators
  [@klaassen1987consistent; @zheng2011cross; @chernozhukov2018double], which
  exhibit greater robustness than their non-sample-splitting analogs.
* To this end, `medoutcon` integrates with the `sl3` `R` package, which is
  extensively documented in this [book
  chapter](https://tlverse.org/tlverse-handbook/sl3) [@vdl2022targeted].

### Interlude: `sl3` for nuisance parameter estimation

* To fully take advantage of the one-step and TML estimators, we'd like to rely
  on flexible, data adaptive strategies for nuisance parameter estimation.
* Doing so minimizes opportunities for model misspecification to compromise our
  analytic conclusions.
* Choosing among the diversity of available machine learning algorithms can be
  challenging, so we recommend using the Super Learner algorithm for ensemble
  machine learning [@vdl2007super], which is implemented in the [`sl3` R
  package](https://github.com/tlverse/sl3) [@coyle2021sl3].
* Below, we demonstrate the construction of an ensemble learner based on a
  limited library of algorithms, including n intercept model, a main terms GLM,
  Lasso ($\ell_1$-penalized) regression, and random forest (`ranger`).

```r
# instantiate learners
mean_lrnr <- Lrnr_mean$new()
fglm_lrnr <- Lrnr_glm_fast$new()
lasso_lrnr <- Lrnr_glmnet$new(alpha = 1, nfolds = 3)
rf_lrnr <- Lrnr_ranger$new(num.trees = 200)

# create learner library and instantiate super learner ensemble
lrnr_lib <- Stack$new(mean_lrnr, fglm_lrnr, lasso_lrnr, rf_lrnr)
sl_lrnr <- Lrnr_sl$new(learners = lrnr_lib, metalearner = Lrnr_nnls$new())
```

* Of course, there are many alternatives for learning algorithms to be included
  in such a modeling library. Feel free to explore!

### Efficient estimation of the natural (in)direct effects

* Estimation of the natural direct and indirect effects requires estimation of a
  few nuisance parameters. Recall that these are
  - $g(a\mid w)$, which denotes $\P(A=a \mid W=w)$
  - $h(a\mid m, w)$, which denotes $\P(A=a \mid M=m, W=w)$
  - $b(a, m, w)$, which denotes $\E(Y \mid A=a, M=m, W=w)$
* While we recommend the use of Super Learning, we opt to instead estimate all
  nuisance parameters with Lasso regression below (to save computational time).
* Now, let's use the `medoutcon()` function to estimate the _natural direct
  effect_:


















