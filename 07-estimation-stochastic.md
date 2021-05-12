# Estimating (in)direct effects with `R` packages

## `medshift`: Stochastic (in)direct effects

We are interested in assessing the population intervention direct effect and
the population intervention indirect effect, based on the effect decomposition
of the population intervention effect introduced in @diaz2020causal.

To proceed, we'll use as our running example a simple data set from an
observational study of the relationship between BMI and kids behavior,
distributed as part of the [`mma` R package on
CRAN](https://CRAN.R-project.org/package=mma). First, let's load the packages
we'll be using and set a seed; then, load this data set and take a quick look
at it


```r
# preliminaries
library(data.table)
library(dplyr)
library(sl3)
library(medshift)
library(mma)
set.seed(429153)

# load and examine data
data(weight_behavior)
dim(weight_behavior)
head(weight_behavior)
```

The documentation for the data set describes it as a "database obtained from the
Louisiana State University Health Sciences Center, New Orleans, by  Dr. Richard
Scribner. He  explored the relationship  between BMI and kids behavior through a
survey at children, teachers and parents in Grenada in 2014. This data set
includes 691 observations and 15 variables."

Unfortunately, the data set contains a few observations with missing values. As
these are unrelated to the object of our analysis, we'll simply remove these for
the time being. Note that in a real data analysis, we might consider strategies
to fully make of the observed data, perhaps by imputing missing values. For now,
we simply remove the incomplete observations, resulting in a data set with fewer
observations but much the same structure as the original:



For the analysis of this observational data set, we focus on the effect of
participating in a sports team (`sports`) on the BMI of children (`bmi`), taking
several related covariates as mediators (`snack`, `exercises`, `overweigh`) and
all other collected covariates as potential confounders. Considering an NPSEM,
we separate the observed variables from the data set into their corresponding
nodes as follows


```r
Y <- weight_behavior_complete$bmi
A <- weight_behavior_complete$sports
Z <- weight_behavior_complete %>%
  select(snack, exercises, overweigh)
W <- weight_behavior_complete %>%
  select(
    age, sex, race, numpeople, car, gotosch, tvhours, cmpthours,
    cellhours, sweat
  )
```

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

To easily incorporate ensemble machine learning into the estimation procedure,
we rely on the facilities provided in the [`sl3` R
package](https://tlverse.org/sl3) [@coyle2020sl3]. For a complete guide on using
the `sl3` R package, consider consulting https://tlverse.org/sl3, or
https://tlverse.org (and https://github.com/tlverse) for the `tlverse`
ecosystem, of which `sl3` is a major part. We construct an ensemble learner
using a handful of popular machine learning algorithms below


```r
# SL learners used for continuous data (the nuisance parameter M)
xgb_contin_lrnr <- Lrnr_xgboost$new(nrounds = 50, objective = "reg:linear")
enet_contin_lrnr <- Lrnr_glmnet$new(
  alpha = 0.5, family = "gaussian",
  nfolds = 3
)
lasso_contin_lrnr <- Lrnr_glmnet$new(
  alpha = 1, family = "gaussian",
  nfolds = 3
)
fglm_contin_lrnr <- Lrnr_glm_fast$new(family = gaussian())
contin_lrnr_lib <- Stack$new(
  enet_contin_lrnr, lasso_contin_lrnr,
  fglm_contin_lrnr, xgb_contin_lrnr
)
sl_contin_lrnr <- Lrnr_sl$new(
  learners = contin_lrnr_lib,
  metalearner = Lrnr_nnls$new()
)

# SL learners used for binary data (nuisance parameters G and E in this case)
xgb_binary_lrnr <- Lrnr_xgboost$new(nrounds = 50, objective = "reg:logistic")
enet_binary_lrnr <- Lrnr_glmnet$new(
  alpha = 0.5, family = "binomial",
  nfolds = 3
)
lasso_binary_lrnr <- Lrnr_glmnet$new(
  alpha = 1, family = "binomial",
  nfolds = 3
)
fglm_binary_lrnr <- Lrnr_glm_fast$new(family = binomial())
binary_lrnr_lib <- Stack$new(
  enet_binary_lrnr, lasso_binary_lrnr,
  fglm_binary_lrnr, xgb_binary_lrnr
)
logistic_metalearner <- make_learner(
  Lrnr_solnp,
  metalearner_logistic_binomial,
  loss_loglik_binomial
)
sl_binary_lrnr <- Lrnr_sl$new(
  learners = binary_lrnr_lib,
  metalearner = logistic_metalearner
)
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
theta_eff <- medshift(
  W = W, A = A, Z = Z, Y = Y,
  delta = delta_shift_ipsi,
  g_learners = sl_binary_lrnr,
  e_learners = sl_binary_lrnr,
  m_learners = sl_contin_lrnr,
  phi_learners = Lrnr_hal9001$new(),
  estimator = "onestep",
  estimator_args = list(cv_folds = 3)
)
summary(theta_eff)
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

## `medoutcon`: Natural/Interventional Effects

An exposure of interest often affects an outcome directly, or indirectly by the
mediation of some intermediate variables. Identifying and quantifying the
mechanisms underlying causal effects is an increasingly popular endeavor in
public health, medicine, and the social sciences, as knowledge of such
mechanisms can improve understanding of both _why and how_ treatments can be
effective. Such mechanistic knowledge may be arguably even more important in
cases where treatments result in unanticipated ineffective or even harmful
effects.

Traditional techniques for mediation analysis fare poorly in the face of
intermediate confounding. Classical parameters like the natural (in)direct
effects face a lack of identifiability in cases where mediator-outcome (i.e.,
intermediate) confounders affected by exposure complicate the relationship
between the exposure, mediators, and outcome. @diaz2020nonparametric provide a
theoretical and computational study of the properties of newly developed
interventional (in)direct effect estimands within the non-parametric statistical
model. Among their contributions, @diaz2020nonparametric

- derive the efficient influence function (EIF), an key object in
  semiparametric efficiency theory;
- use the EIF to develop two asymptotically optimal, non-parametric estimators,
  each of which is capable of leveraging machine learning for the estimation of
  nuisance parameters; and
- present theoretical conditions under which their proposed estimators are
  consistent, multiply robust, and efficient.

### Problem Setup and Notation

The problem addressed by the work of @diaz2020nonparametric may be represented
by the following nonparametric structural equation model (NPSEM):
\begin{align*}
  W &= f_W(U_W); A = f_A(W, U_A); Z=f_Z(W, A, U_Z);\\ \nonumber
  M &= f_M(W, A, Z, U_M); Y = f_Y(W, A, Z, M, U_Y).
\end{align*}
In the NPSEM, $W$ denotes a vector of observed pre-treatment covariates, $A$
denotes a categorical treatment variable, $Z$ denotes an intermediate confounder
affected by treatment, $M$ denotes a (possibly multivariate) mediator, and $Y$
denotes a continuous or binary outcome.  The vector of exogenous factors
$U=(U_W,U_A,U_Z,U_M,U_Y)$, and the functions $f$, are assumed deterministic but
unknown.  Importantly, the NPSEM encodes a time-ordering between these variables
and allows the evaluation of counterfactual quantities defined by intervening on
a set of nodes of the NPSEM.  The observed data unit can be represented by the
random variable $O = (W, A, Z, M, Y)$; we consider access to $O_1, \ldots, O_n$,
a sample of $n$ i.i.d. observations of $O$.

@diaz2020nonparametric additionally define the following parameterizations,
familiarity with which will be useful for using the [`medoutcon` `R`
package](https://github.com/nhejazi/medoutcon). In particular, these authors
define $g(a \mid w)$ as the probability mass function of $A = a$ conditional on
$W = w$ and use $h(a \mid m, w)$ to denote the probability mass function of $A
= a$ conditional on $(M, W) = (m, w)$. Further, @diaz2020nonparametric use
$b(a, z, m, w)$ to denote the outcome regression function $\mathbb{E}(Y \mid A
= a, Z = z, M = m, W = w)$, as well as $q(z \mid a,w)$ and $r(z \mid a, m, w)$
to denote the corresponding conditional densities of $Z$.

### Interventional (In)Direct Effects

@diaz2020nonparametric define the _total effect_ of $A$ on $Y$ in terms of a
contrast between two user-supplied values $a', a^{\star} \in \mathcal{A}$.
Examination of the NPSEM reveals that there are four paths involved in this
effect, namely $A \rightarrow Y$, $A \rightarrow M \rightarrow Y$, $A
\rightarrow Z \rightarrow Y$, and $A \rightarrow Z \rightarrow M \rightarrow Y$.
Mediation analysis has classically considered the _natural direct effect_ (NDE)
and the _natural indirect effect_ (NIE), which are defined as
$\mathbb{E}_c(Y_{a', M_{a^{\star}}} - Y_{a^{\star}, M_{a^{\star}}})$ and
$\mathbb{E}_c(Y_{a',M_{a'}} - Y_{a',M_{a^{\star}}})$, respectively. The natural
direct effect measures the effect through paths _not_ involving the mediator
($A \rightarrow Y$ and $A \rightarrow Z \rightarrow Y$), whereas the natural
indirect effect measures the effect through paths involving the mediator
($A \rightarrow M \rightarrow Y$ and $A \rightarrow Z \rightarrow M \rightarrow
Y$). As the sum of the natural direct and indirect effects equals the average
treatment effect $\mathbb{E}_c(Y_1-Y_0)$, this effect decomposition is
appealing. Unfortunately, the natural direct and indirect effects are
not generally identified in the presence of an intermediate confounder affected
by treatment.

To circumvent this issue, @diaz2020nonparametric define the direct and indirect
effects using stochastic interventions on the mediator, following a strategy
previously outlined by @vanderweele2014effect and @rudolph2017robust, among
others. Let $G_a$ denote a random draw from the conditional distribution of
$M_a$ conditional on $W$. Consider the effect of $A$ on $Y$ defined as the
difference in expected outcome in hypothetical worlds in which $(A,M) = (a',
G_{a'})$ versus $(A,M) = (a^{\star}, G_{a^{\star}})$ with probability one, which
may be decomposed into direct and indirect effects as follows
\begin{equation*}
\mathbb{E}_c(Y_{a', G_{a'}} - Y_{a^{\star}, G_{a^{\star}}}) =
  \underbrace{\mathbb{E}_c(Y_{a', G_{a'}} - Y_{a',
    G_{a^{\star}}})}_{\text{Indirect effect (through $M$)}} +
  \underbrace{\mathbb{E}_c(Y_{a', G_{a^{\star}}} - Y_{a^{\star},
      G_{a^{\star}}})}_{\text{Direct effect (not through $M$)}}.
\end{equation*}
Like the natural direct effect, this interventional direct effect measures the
effects through paths not involving the mediator. Likewise, the interventional
indirect effect measures the effect through paths involving the mediator. Note,
however, that natural and interventional mediation effects have different
interpretations. That is, the interventional indirect effect measures the effect
of fixing the exposure at $a'$ while setting the mediator to a random draw
$G_{a^{\star}}$ from those with exposure $a'$ versus a random draw $G_{a'}$ from
those with exposure $a^{\star}$, given covariates $W$. As is clear from the
effect decomposition, the term $\theta_c = \mathbb{E}_c(Y_{a', G_{a^{\star}}})$
is required for estimation of both the interventional direct and indirect
effects; thus, @diaz2020nonparametric focus on estimation of this quantity.
Importantly, it has been shown that $\theta_c$ is identified by the statistical
functional
\begin{equation*}
  \theta = \int b(a', z, m, w) q(z \mid a', w) p(m \mid a^{\star}, w)
    p(w) d\nu(w,z,m)
\end{equation*}
under a set of standard identifiability conditions [@vanderweele2014effect],
which are further reviewed in @diaz2020nonparametric.

### Efficient Estimation

@diaz2020nonparametric define two efficient estimators of their interventional
(in)direct effects. These are based on the one-step estimation and targeted
minimum loss (TML) estimation frameworks, respectively. Briefly, both estimation
strategies proceed in two stages, starting by first constructing initial
estimates of the nuisance parameters present in the EIF, then proceeding to
apply distinct bias-correction strategies in their second stages. Both
estimation strategies require an assumption about the behavior of initial
estimators of the nuisance parameters (specifically, that these lie in a Donsker
class); however, the need for such an assumption may be avoided by making use of
cross-validation in the fitting fo initial estimators. The `medoutcon` `R`
package requires the use of cross-validation in the construction of these
initial estimates, resulting in cross-fitted one-step and and cross-validated
TML estimators [@klaassen1987consistent; @zheng2011cross;
@chernozhukov2018double].

The one-step estimator $\hat{\theta}_{\text{os}}$ is constructed by adding the
empirical mean of the EIF (evaluated at initial estimates of the nuisance
parameters) to the substitution estimator. By constrast, the TML estimator
$\hat{\theta}_{\text{tmle}}$ updates the components of the substitution
estimator via logistic tilting models formulated to ensure that relevant score
equations appearing in the EIF are (approximately) solved.  While the estimators
are asymptotically equivalent, TML estimators have been shown to exhibit
superior finite-sample performance, making them potentially more reliable than
one-step estimators. For the exact form of the EIF as well as those of the
one-step and TML estimators, consult @diaz2020nonparametric.

### Data Analysis Example

#### Setting up the data example

Now, we'll take a look at how to estimate the interventional direct and indirect
effects using a simulated data example. @diaz2020nonparametric illustrate the
use of their estimators of these effects in an application in which they seek to
elucidate the mechanisms behind the unintended harmful effects that a housing
intervention had on adolescent girls' risk behavior.

First, let's load a few required packages and set a seed for our simulation.


```r
library(data.table)
library(medoutcon)
library(sl3)
set.seed(75681)
n_obs <- 500
```

Next, we'll generate a very simple simulated dataset. The function
`make_example_data`, defined below, generates three binary baseline covariates
$W = (W_1, W_2, W_3)$, a binary exposure variable $A$, a single binary mediateor
$M$ an intermediate confounder $Z$ that affects the mediator $M$ and is itself
affected by the exposure $A$, and, finally, a binary outcome $Y$ that is a
function of $(W, A, Z, M)$.


```r
# produces a simple data set based on ca causal model with mediation
make_example_data <- function(n_obs = 1000) {
  ## baseline covariates
  w_1 <- rbinom(n_obs, 1, prob = 0.6)
  w_2 <- rbinom(n_obs, 1, prob = 0.3)
  w_3 <- rbinom(n_obs, 1, prob = pmin(0.2 + (w_1 + w_2) / 3, 1))
  w <- cbind(w_1, w_2, w_3)
  w_names <- paste("W", seq_len(ncol(w)), sep = "_")

  ## exposure
  a <- as.numeric(rbinom(n_obs, 1, plogis(rowSums(w) - 2)))

  ## mediator-outcome confounder affected by treatment
  z <- rbinom(n_obs, 1, plogis(rowMeans(-log(2) + w - a) + 0.2))

  ## mediator -- could be multivariate
  m <- rbinom(n_obs, 1, plogis(rowSums(log(3) * w[, -3] + a - z)))
  m_names <- "M"

  ## outcome
  y <- rbinom(n_obs, 1, plogis(1 / (rowSums(w) - z + a + m)))

  ## construct output
  dat <- as.data.table(cbind(w = w, a = a, z = z, m = m, y = y))
  setnames(dat, c(w_names, "A", "Z", m_names, "Y"))
  return(dat)
}

# set seed and simulate example data
example_data <- make_example_data(n_obs)
w_names <- stringr::str_subset(colnames(example_data), "W")
m_names <- stringr::str_subset(colnames(example_data), "M")
```

Now, let's take a quick look at our simulated data:


```r
# quick look at the data
head(example_data)
```

As noted above, all covariates in our dataset are binary; however, note that
this need not be the case for using our methodology --- in particular, the only
current limitation is that the intermediate confounder $Z$ must be binary when
using our implemented TML estimator of the (in)direct effects.

Using this dataset, we'll proceed to estimate the interventional (in)direct
effects. In order to do so, we'll need to estimate several nuisance parameters,
including the exposure mechanism $g(A \mid W)$, a re-parameterized exposure
mechanism that conditions on the mediators $h(A \mid M, W)$, the outcome
mechanism $b(Y \mid M, Z, A, W)$, and two variants of the intermediate
confounding mechanism $q(Z \mid A, W)$ and $r(Z \mid M, A, W)$. In order to
estimate each of these nuisance parameters flexibly, we'll rely on data adaptive
regression strategies in order to avoid the potential for (parametric) model
misspecification.

#### Ensemble learning of nuisance functions

As we'd like to rely on flexible, data adaptive regression strategies for
estimating each of the nuisance parameters $(g, h, b, q, r)$, we require a
method for choosing among or combining the wide variety of available regression
strategies. For this, we recommend the use of the Super Learner algorithm for
ensemble machine learning [@vdl2007super].  The recently developed [`sl3` R
package](https://tlverse.org/sl3) [@coyle2020sl3] provides a unified interface
for deploying a wide variety of machine learning algorithms (simply called
_learners_ in the `sl3` nomenclature) as well as for constructing Super Learner
ensemble models of such learners. For a complete guide on using the `sl3` R
package, consider consulting https://tlverse.org/sl3, or https://tlverse.org
(and https://github.com/tlverse) for the `tlverse` ecosystem, of which `sl3` is
an integral part.

To construct an ensemble learner using a handful of popular machine learning
algorithms, we'll first instantiate variants of learners from the appropriate
classes for each algorithm, and then create a Super Learner ensemble via the
`Lrnr_sl` class. Below, we demonstrate the construction of an ensemble learner
based on a modeling library including an intercept model, a main-terms GLM,
$\ell_1$-penalized Lasso regression, an elastic net regression that equally
weights the $\ell_1$ and $\ell_2$ penalties, random forests (`ranger`), and the
highly adaptive lasso (HAL):


```r
# instantiate learners
mean_lrnr <- Lrnr_mean$new()
fglm_lrnr <- Lrnr_glm_fast$new(family = binomial())
lasso_lrnr <- Lrnr_glmnet$new(alpha = 1, family = "binomial", nfolds = 3)
enet_lrnr <- Lrnr_glmnet$new(alpha = 0.5, family = "binomial", nfolds = 3)
rf_lrnr <- Lrnr_ranger$new(num.trees = 200)

# for HAL, use linear probability formulation, with bounding in unit interval
hal_gaussian_lrnr <- Lrnr_hal9001$new(
  family = "gaussian",
  fit_control = list(
    max_degree = 3,
    n_folds = 3,
    use_min = TRUE,
    type.measure = "mse"
  )
)
bound_lrnr <- Lrnr_bound$new(bound = 1e-6)
hal_bounded_lrnr <- Pipeline$new(hal_gaussian_lrnr, bound_lrnr)

# create learner library and instantiate super learner ensemble
lrnr_lib <- Stack$new(
  mean_lrnr, fglm_lrnr, enet_lrnr, lasso_lrnr,
  rf_lrnr, hal_bounded_lrnr
)
sl_lrnr <- Lrnr_sl$new(learners = lrnr_lib, metalearner = Lrnr_nnls$new())
```

While we recommend the use of a Super Learner ensemble model like the one
constructed above in practice, such a library will be too computationally
intensive for our examples. To reduce computation time, we construct a simpler
library, using only a subset of the above learning algorithms:


```r
# create simpler learner library and instantiate super learner ensemble
lrnr_lib <- Stack$new(mean_lrnr, fglm_lrnr, lasso_lrnr, rf_lrnr)
sl_lrnr <- Lrnr_sl$new(learners = lrnr_lib, metalearner = Lrnr_nnls$new())
```

Having set up our ensemble learner, we're now ready to estimate each of the
interventional effects using the efficient estimators exposed in the `medoutcon`
package.

#### Estimating the direct effect

We're now ready to estimate the interventional direct effect. This direct effect
is computed as a contrast between the interventions $(a' = 1, a^{\star} = 0)$
and $(a' = 0, a^{\star} = 0)$. In particular, our efficient estimators of the
interventional direct effect proceed by constructing estimators
$\hat{\theta}(a' = 1, a^{\star} = 0)$ and $\hat{\theta}(a' = 0, a^{\star} = 0)$.
Then, an efficient estimator of the direct effect is available by application
of the delta method, that is, $\hat{\theta}^{\text{DE}} =
\hat{\theta}(a' = 1, a^{\star} = 0) - \hat{\theta}(a' = 0, a^{\star} = 0)$.
Applying the same principle to the EIF estimates, one can derive variance
estimates and construct asymptotically correct Wald-style confidence intervals
for $\hat{\theta}^{\text{DE}}$.

The `medoutcon` package makes the estimation task quite simple, as only a single
call to the eponymous `medoutcon` function is required. As demonstrated below,
we need only feed in each component of the observed data $O = (W, A, Z, M, Y)$
(of which $W$ and $M$ can be multivariate), specify the effect type, and the
estimator. Additionally, for each nuisance parameter we may specify a separate
regression function --- in the examples below, we use the simpler Super Learner
ensemble constructed above for fitting each nuisance function, but this need not
be the case (i.e., different estimators may be used for each nuisance function).

First, we examine the one-step estimator of the interventional direct effect.
Recall that the one-step estimator is constructed by adding the mean of the EIF
(evaluated at initial estimates of the nuisance parameters) to the substitution
estimator. As noted above, this is done separately for each of the two contrasts
$(a' = 0, a^{\star} = 0)$ and $(a' = 1, a^{\star} = 0)$. Thus, the one-step
estimator of this direct effect is constructed by application of the delta
method to each of the one-step estimators (and EIFs) for these contrasts.


```r
# compute one-step estimate of the interventional direct effect
os_de <- medoutcon(
  W = example_data[, ..w_names],
  A = example_data$A,
  Z = example_data$Z,
  M = example_data[, ..m_names],
  Y = example_data$Y,
  g_learners = sl_lrnr,
  h_learners = sl_lrnr,
  b_learners = sl_lrnr,
  q_learners = sl_lrnr,
  r_learners = sl_lrnr,
  effect = "direct",
  estimator = "onestep",
  estimator_args = list(cv_folds = 2)
)
summary(os_de)
```

Next, let's compare the one-step estimate to the TML estimate. Analogous to the
case of the one-step estimator, the TML estimator can be evaluated via a single
call to the `medoutcon` function:


```r
# compute targeted minimum loss estimate of the interventional direct effect
tmle_de <- medoutcon(
  W = example_data[, ..w_names],
  A = example_data$A,
  Z = example_data$Z,
  M = example_data[, ..m_names],
  Y = example_data$Y,
  g_learners = sl_lrnr,
  h_learners = sl_lrnr,
  b_learners = sl_lrnr,
  q_learners = sl_lrnr,
  r_learners = sl_lrnr,
  effect = "direct",
  estimator = "tmle",
  estimator_args = list(cv_folds = 2, max_iter = 5)
)
summary(tmle_de)
```

Here, we recall that the TML
estimator generally exhibits better finite-sample performance than the one-step
estimator [@vdl2011targeted; @vdl2018targeted], so the TML estimate is likely to
be more reliable in modest (realistic) sample sizes.

#### Estimating the indirect effect

Estimation of the interventional indirect effect proceeds similarly to the
strategy discussed above for the corresponding direct effect. An efficient
estimator can be computed as a contrast between the interventions $(a' = 1,
a^{\star} = 0)$ and $(a' = 1, a^{\star} = 1)$. Specifically, our efficient
estimators of the interventional indirect effect proceed by constructing
estimators $\hat{\theta}(a' = 1, a^{\star} = 0)$ and $\hat{\theta}(a' = 1,
a^{\star} = 1)$.  Then, application of the delta method yields an efficient
estimator of the indirect effect, that is, $\hat{\theta}^{\text{IE}} =
\hat{\theta}(a' = 1, a^{\star} = 0) - \hat{\theta}(a' = 1, a^{\star} = 1)$. The
same principle may be applied to the EIF estimates to derive variance estimates
and construct asymptotically correct Wald-style confidence intervals for
$\hat{\theta}^{\text{IE}}$.

Now, we examine the one-step estimator of the interventional indirect effect.
The one-step estimator is constructed by adding the mean of the EIF
(evaluated at initial estimates of the nuisance parameters) to the substitution
estimator. As noted above, this is done separately for each of the two contrasts
$(a' = 1, a^{\star} = 1)$ and $(a' = 1, a^{\star} = 0)$. Thus, the one-step
estimator of this indirect effect is constructed by application of the delta
method to each of the one-step estimators (and EIFs) for the contrasts.


```r
# compute one-step estimate of the interventional indirect effect
os_ie <- medoutcon(
  W = example_data[, ..w_names],
  A = example_data$A,
  Z = example_data$Z,
  M = example_data[, ..m_names],
  Y = example_data$Y,
  g_learners = sl_lrnr,
  h_learners = sl_lrnr,
  b_learners = sl_lrnr,
  q_learners = sl_lrnr,
  r_learners = sl_lrnr,
  effect = "indirect",
  estimator = "onestep"
)
summary(os_ie)
```

As before, let's compare the one-step estimate to the TML estimate. Analogous
to the case of the one-step estimator, the TML estimator can be evaluated via a
single call to the `medoutcon` function, as demonstrated below


```r
# compute targeted minimum loss estimate of the interventional indirect effect
tmle_ie <- medoutcon(
  W = example_data[, ..w_names],
  A = example_data$A,
  Z = example_data$Z,
  M = example_data[, ..m_names],
  Y = example_data$Y,
  g_learners = sl_lrnr,
  h_learners = sl_lrnr,
  b_learners = sl_lrnr,
  q_learners = sl_lrnr,
  r_learners = sl_lrnr,
  effect = "indirect",
  estimator = "tmle"
)
summary(tmle_ie)
```

As before, the TML estimator provides better finite-sample performance than the
one-step estimator, so it may be preferred in this example.
