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
#> # ... with 562 more rows, and 5 more variables: cellhours <dbl>, sports <fct>,
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

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{07-estimation-stochastic_files/figure-latex/unnamed-chunk-1-1} 

}

\caption{Directed acyclic graph under *no intermediate confounders* of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-1)
\end{figure}

### Natural (in)direct effects

To start, we will consider estimation of the _natural_ direct and indirect effects,
which, we recall, are defined as follows
\begin{equation*}
  \E[Y_{1,M_1} - Y_{0,M_0}] = \underbrace{\E[Y_{\color{red}{1},\color{blue}{M_1}} -
    Y_{\color{red}{1},\color{blue}{M_0}}]}_{\text{natural indirect effect}} +
    \underbrace{\E[Y_{\color{blue}{1},\color{red}{M_0}} -
    Y_{\color{blue}{0},\color{red}{M_0}}]}_{\text{natural direct effect}}.
\end{equation*}

* Our [`medoutcon` `R` package](https://github.com/nhejazi/medoutcon), which
  accompanies @diaz2020nonparametric, implements one-step and TML estimators of
  both the natural and interventional (in)direct effects.
* Both types of estimators are capable of accommodating flexible modeling
  strategies (e.g., ensemble machine learning) for the initial estimation of
  nuisance parameters.
* The `medoutcon` `R` package uses cross-validation in initial estimation: this
  results in cross-validated (or "cross-fitted") one-step and TML estimators
  [@klaassen1987consistent; @zheng2011cross; @chernozhukov2018double], which
  exhibit greater robustness than their non-sample-splitting analogs.
* To this end, `medoutcon` integrates with the `sl3` `R` package, which is
  extensively documented in this [book
  chapter](https://tlverse.org/tlverse-handbook/sl3).

### Interlude: `sl3` for nuisance parameter estimation

* To fully take advantage of the one-step and TML estimators, we'd like to rely
  on flexible, data adaptive strategies for nuisance parameter estimation.
* Doing so minimizes opportunities for model misspecification to compromise our
  analytic conclusions.
* Choosing among the diversity of available machine learning algorithms can be
  challenging, so we recommend using the Super Learner algorithm for ensemble
  machine learning [@vdl2007super], which is implemented in the [`sl3` R
  package](https://github.com/tlverse/sl3).
* Below, we demonstrate the construction of an ensemble learner based on a
  limited library of algorithms, including n intercept model, a main terms GLM,
  Lasso ($\ell_1$-penalized) regression, and random forests (`ranger`).

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
* Now, we're ready to use the `medoutcon` function to estimate the _natural
  direct effect_:

```r
# compute one-step estimate of the natural direct effect
nde_onestep <- medoutcon(
  W = weight_behavior[, c("age", "sex", "race", "tvhours")],
  A = (as.numeric(weight_behavior$sports) - 1),
  Z = NULL,
  M = weight_behavior[, c("snack", "exercises", "overweigh")],
  Y = weight_behavior$bmi,
  g_learners = lasso_lrnr,
  h_learners = lasso_lrnr,
  b_learners = lasso_lrnr,
  effect = "direct",
  estimator = "onestep",
  estimator_args = list(cv_folds = 5)
)
summary(nde_onestep)
#> # A tibble: 1 x 7
#>   lwr_ci param_est upr_ci var_est eif_mean estimator param         
#>    <dbl>     <dbl>  <dbl>   <dbl>    <dbl> <chr>     <chr>         
#> 1 -0.490   -0.0280  0.434  0.0555 2.84e-15 onestep   direct_natural
```

* We can similarly call the `medoutcon` function to estimate the _natural
  indirect effect_:

```r
# compute one-step estimate of the natural indirect effect
nie_onestep <- medoutcon(
  W = weight_behavior[, c("age", "sex", "race", "tvhours")],
  A = (as.numeric(weight_behavior$sports) - 1),
  Z = NULL,
  M = weight_behavior[, c("snack", "exercises", "overweigh")],
  Y = weight_behavior$bmi,
  g_learners = lasso_lrnr,
  h_learners = lasso_lrnr,
  b_learners = lasso_lrnr,
  effect = "indirect",
  estimator = "onestep",
  estimator_args = list(cv_folds = 5)
)
summary(nie_onestep)
#> # A tibble: 1 x 7
#>   lwr_ci param_est upr_ci var_est eif_mean estimator param           
#>    <dbl>     <dbl>  <dbl>   <dbl>    <dbl> <chr>     <chr>           
#> 1  0.466      1.09   1.72   0.102 9.02e-16 onestep   indirect_natural
```

* From the above, we can conclude that the effect of participation on a sports
  team on BMI is primarily mediated by the variables `snack`, `exercises`, and
  `overweigh`, as the natural indirect effect is several times larger than the
  natural direct effect.
* Note that we could have instead used the TML estimators, which have improved
  finite-sample performance, instead of the one-step estimators. Doing this is
  as simple as setting the `estimator = "tmle"` in the relevant argument.

### Interventional (in)direct effects

Since our knowledge of the system under study is incomplete, we might worry that
one (or more) of the measured variables are not mediators, but, in fact,
intermediate confounders affected by treatment. While the natural (in)direct
effects are not identified in this setting, their interventional (in)direct
counterparts are, as we saw in an earlier section. Recall that both types of
effects are defined by static interventions on the treatment. The interventional
effects are distinguished by their use of a stochastic intervention on the
mediator to aid in their identification.

  \begin{figure}
  
  {\centering \includegraphics[width=0.8\linewidth]{07-estimation-stochastic_files/figure-latex/unnamed-chunk-2-1} 
  
  }
  
  \caption{Directed acyclic graph under intermediate confounders of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-2)
  \end{figure}

Recall that the interventional (in)direct effects are defined via the decomposition:
\begin{equation*}
\E[Y_{1,G_1} - Y_{0,G_0}] = \underbrace{\E[Y_{\color{red}{1},\color{blue}{G_1}} -
    Y_{\color{red}{1},\color{blue}{G_0}}]}_{\text{interventional indirect effect}} +
    \underbrace{\E[Y_{\color{blue}{1},\color{red}{G_0}} -
    Y_{\color{blue}{0},\color{red}{G_0}}]}_{\text{interventional direct effect}}
\end{equation*}

* In our data example, we'll consider the eating of snacks as a potential
  intermediate confounder, since one might reasonably hypothesize that
  participation on a sports team might subsequently affect snacking, which then
  could affect mediators like the amount of exercises and overweight status.
* The interventional direct and indirect effects may also be easily estimated
  with the [`medoutcon` `R` package](https://github.com/nhejazi/medoutcon).
* Just as for the natural (in)direct effects, `medoutcon` implements
  cross-validated one-step and TML estimators of the interventional effects.

### Efficient estimation of the interventional (in)direct effects

* Estimation of these effects is more complex, so a few additional nuisance
  parameters arise when expressing the (more general) EIF for these effects:
  * $q(z \mid a, w)$, the conditional density of the intermediate confounders,
    conditional only on treatment and baseline covariates;
  * $r(z \mid a, m, w)$, the conditional density of the intermediate
    confounders, conditional on mediators, treatment, and baseline covariates.
* Note that the implementation in `medoutcon` is currently limited to settings
  with only binary intermediate confounders, i.e., $Z \in \{0, 1\}$.
* Now, we're ready to use the `medoutcon` function to estimate the
  _interventional direct effect_:

```r
# compute one-step estimate of the interventional direct effect
interv_de_onestep <- medoutcon(
  W = weight_behavior[, c("age", "sex", "race", "tvhours")],
  A = (as.numeric(weight_behavior$sports) - 1),
  Z = (as.numeric(weight_behavior$snack) - 1),
  M = weight_behavior[, c("exercises", "overweigh")],
  Y = weight_behavior$bmi,
  g_learners = lasso_lrnr,
  h_learners = lasso_lrnr,
  b_learners = lasso_lrnr,
  effect = "direct",
  estimator = "onestep",
  estimator_args = list(cv_folds = 5)
)
summary(interv_de_onestep)
#> # A tibble: 1 x 7
#>   lwr_ci param_est upr_ci var_est  eif_mean estimator param                
#>    <dbl>     <dbl>  <dbl>   <dbl>     <dbl> <chr>     <chr>                
#> 1 -0.476   -0.0107  0.454  0.0562 -9.93e-16 onestep   direct_interventional
```

* We can similarly call the `medoutcon` function to estimate the
  _interventional indirect effect_:

```r
# compute one-step estimate of the interventional indirect effect
interv_ie_onestep <- medoutcon(
  W = weight_behavior[, c("age", "sex", "race", "tvhours")],
  A = (as.numeric(weight_behavior$sports) - 1),
  Z = (as.numeric(weight_behavior$snack) - 1),
  M = weight_behavior[, c("exercises", "overweigh")],
  Y = weight_behavior$bmi,
  g_learners = lasso_lrnr,
  h_learners = lasso_lrnr,
  b_learners = lasso_lrnr,
  effect = "indirect",
  estimator = "onestep",
  estimator_args = list(cv_folds = 5)
)
summary(interv_ie_onestep)
#> # A tibble: 1 x 7
#>   lwr_ci param_est upr_ci var_est eif_mean estimator param                  
#>    <dbl>     <dbl>  <dbl>   <dbl>    <dbl> <chr>     <chr>                  
#> 1  0.348     0.952   1.56  0.0950 3.15e-15 onestep   indirect_interventional
```

* From the above, we can conclude that the effect of participation on a sports
  team on BMI is largely through the interventional indirect effect (i.e.,
  through the pathways involving the mediating variables) rather than via its
  direct effect.
* Just as before, we could have instead used the TML estimators, instead of the
  one-step estimators. Doing this is as simple as setting the
  `estimator = "tmle"` in the relevant argument.

## `medshift`: Stochastic (in)direct effects

While the analyses using the natural and interventional effects have been
illuminating, we may also go beyond the restrictive static interventions
required to define these (in)direct effects.

We are interested in assessing the population intervention direct effect and
the population intervention indirect effect, based on the effect decomposition
of the population intervention effect introduced in @diaz2020causal.


Finally, in our analysis, we consider an incremental propensity score
intervention (IPSI), as first proposed by @kennedy2017nonparametric, wherein the
_odds of participating in a sports team_ is modulated by some fixed amount
($0 \leq \delta \leq \infty$) for each individual. Such an intervention may be
interpreted as the effect of a school program that motivates children to
participate in sports teams. To exemplify our approach, we postulate a
motivational intervention that _triples the odds_ of participating in a sports
team for each individual:


```r
delta_shift_ipsi <- 3
```

### Decomposing the population intervention effect

We may decompose the population intervention effect (PIE) in terms of a
_population intervention direct effect_ (PIDE) and a _population
intervention indirect effect_ (PIIE):
\begin{equation*}
  \overbrace{\mathbb{E}\{Y(A_\delta, Z(A_\delta)) -
    Y(A_\delta, Z)\}}^{\text{PIIE}} +
    \overbrace{\mathbb{E}\{Y(A_\delta, Z) - Y(A, Z)\}}^{\text{PIDE}}.
\end{equation*}

This decomposition of the PIE as the sum of the population intervention direct
and indirect effects has an interpretation analogous to the corresponding
standard decomposition of the average treatment effect. In the sequel, we will
compute each of the components of the direct and indirect effects above using
appropriate estimators as follows

* For $\mathbb{E}\{Y(A, Z)\}$, the sample mean $\frac{1}{n}\sum_{i=1}^n Y_i$ is
  sufficient;
* for $\mathbb{E}\{Y(A_{\delta}, Z)\}$, an efficient one-step estimator for the
  effect of a joint intervention altering the exposure mechanism but not the
  mediation mechanism, as proposed in @diaz2020causal; and,
* for $\mathbb{E}\{Y(A_{\delta}, Z_{A_{\delta}})\}$, an efficient one-step
  estimator for the effect of a joint intervention altering both the exposure
  and mediation mechanisms, as proposed in @kennedy2017nonparametric and
  implemented in the [`npcausal` R
  package](https://github.com/ehkennedy/npcausal).

### Estimating the effect decomposition term

As given in @diaz2020causal, the statistical functional identifying the
decomposition term that appears in both the PIDE and PIIE
$\mathbb{E}\{Y(A_{\delta}, Z)\}$, which corresponds to altering the exposure
mechanism while keeping the mediation mechanism fixed, is
\begin{equation*}
  \theta_0(\delta) = \int m_0(a, z, w) g_{0,\delta}(a \mid w) p_0(z, w)
    d\nu(a, z, w),
\end{equation*}
for which a one-step estimator is available. The corresponding _efficient
influence function_ (EIF) with respect to the nonparametric model $\mathcal{M}$
is $D_{\eta,\delta}(o) = D^Y_{\eta,\delta}(o)
+ D^A_{\eta,\delta}(o) + D^{Z,W}_{\eta,\delta}(o) - \theta(\delta)$. The
one-step estimator may be computed using the EIF estimating equation, making use
of cross-fitting [@zheng2011cross; @chernozhukov2018double] to circumvent any
need for entropy conditions (i.e., Donsker class restrictions). The resultant
estimator is
\begin{equation*}
  \hat{\theta}(\delta) = \frac{1}{n} \sum_{i = 1}^n D_{\hat{\eta}_{j(i)},
  \delta}(O_i) = \frac{1}{n} \sum_{i = 1}^n \left\{ D^Y_{\hat{\eta}_{j(i)},
  \delta}(O_i) + D^A_{\hat{\eta}_{j(i)}, \delta}(O_i) +
  D^{Z,W}_{\hat{\eta}_{j(i)}, \delta}(O_i) \right\},
\end{equation*}
which is implemented in the `medshift` R package. We make use of that
implementation to estimate $\mathbb{E}\{Y(A_{\delta}, Z)\}$ via its one-step
estimator $\hat{\theta}(\delta)$ below


```r
# let's compute the parameter where A (but not Z) are shifted
pide_decomp_onestep <- medshift(
  W = W, A = A, Z = Z, Y = Y,
  delta = delta_shift_ipsi,
  g_learners = lasso_lrnr,
  e_learners = lasso_lrnr,
  m_learners = lasso_lrnr,
  estimator = "onestep",
  estimator_args = list(cv_folds = 5)
)
summary(pide_decomp_onestep)
```

### Estimating the direct effect

Recall that, based on the decomposition outlined previously, the population
intervention direct effect may be denoted $\beta_{\text{PIDE}}(\delta) =
\theta_0(\delta) - \mathbb{E}Y$. Thus, an estimator of the PIDE,
$\hat{\beta}_{\text{PIDE}}(\delta)$ may be expressed as a composition of
estimators of its constituent parameters:
\begin{equation*}
  \hat{\beta}_{\text{PIDE}}({\delta}) = \hat{\theta}(\delta) -
  \frac{1}{n} \sum_{i = 1}^n Y_i.
\end{equation*}

Based on the above, we may construct an estimator of the PIDE using quantities
already computed. The convenience function below applies the simple delta method
required in the case of a linear contrast between the two constituent
parameters:

```r
# convenience function to compute inference via delta method: EY1 - EY0
linear_contrast <- function(params, eifs, ci_level = 0.95) {
  # bounds for confidence interval
  ci_norm_bounds <- c(-1, 1) * abs(stats::qnorm(p = (1 - ci_level) / 2))
  param_est <- params[[1]] - params[[2]]
  eif <- eifs[[1]] - eifs[[2]]
  se_eif <- sqrt(var(eif) / length(eif))
  param_ci <- param_est + ci_norm_bounds * se_eif
  # parameter and inference
  out <- c(param_ci[1], param_est, param_ci[2])
  names(out) <- c("lwr_ci", "param_est", "upr_ci")
  return(out)
}
```

With the above convenience function in hand, we'll construct or extract the
necessary components from existing objects and simply apply the function:

```r
# parameter estimates and EIFs for components of direct effect
EY <- mean(Y)
eif_EY <- Y - EY
params_de <- list(theta_eff$theta, EY)
eifs_de <- list(theta_eff$eif, eif_EY)

# direct effect = EY - estimated quantity
de_est <- linear_contrast(params_de, eifs_de)
de_est
```
