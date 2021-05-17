## ----setup--------------------------------------------------------------------
library(tidyverse)
library(sl3)
library(medoutcon)
library(medshift)
library(mma)
set.seed(429153)


## ----load_data----------------------------------------------------------------
# load and examine data
data(weight_behavior)
dim(weight_behavior)

# drop missing values
weight_behavior <- weight_behavior %>%
  drop_na() %>%
  as_tibble()
weight_behavior


## \dimendef\prevdepth=0

## \pgfdeclarelayer{background}

## \pgfsetlayers{background,main}

## \usetikzlibrary{arrows,positioning}

## \tikzset{

## >=stealth',

## punkt/.style={

## rectangle,

## rounded corners,

## draw=black, very thick,

## text width=6.5em,

## minimum height=2em,

## text centered},

## pil/.style={

## ->,

## thick,

## shorten <=2pt,

## shorten >=2pt,}

## }

## \newcommand{\Vertex}[2]

## {\node[minimum width=0.6cm,inner sep=0.05cm] (#2) at (#1) {$#2$};

## }

## \newcommand{\VertexR}[2]

## {\node[rectangle, draw, minimum width=0.6cm,inner sep=0.05cm] (#2) at (#1) {$#2$};

## }

## \newcommand{\ArrowR}[3]

## { \begin{pgfonlayer}{background}

## \draw[->,#3] (#1) to[bend right=30] (#2);

## \end{pgfonlayer}

## }

## \newcommand{\ArrowL}[3]

## { \begin{pgfonlayer}{background}

## \draw[->,#3] (#1) to[bend left=45] (#2);

## \end{pgfonlayer}

## }

## \newcommand{\EdgeL}[3]

## { \begin{pgfonlayer}{background}

## \draw[dashed,#3] (#1) to[bend right=-45] (#2);

## \end{pgfonlayer}

## }

## \newcommand{\Arrow}[3]

## { \begin{pgfonlayer}{background}

## \draw[->,#3] (#1) -- +(#2);

## \end{pgfonlayer}

## }

## \begin{tikzpicture}

##   \Vertex{-4, 0}{W}

##   \Vertex{0, 0}{M}

##   \Vertex{-2, 0}{A}

##   \Vertex{2, 0}{Y}

##   \Arrow{W}{A}{black}

##   \Arrow{A}{M}{black}

##   \Arrow{M}{Y}{black}

##   \ArrowL{W}{Y}{black}

##   \ArrowL{A}{Y}{black}

##   \ArrowL{W}{M}{black}

## \end{tikzpicture}


## ----setup_sl-----------------------------------------------------------------
# instantiate learners
mean_lrnr <- Lrnr_mean$new()
fglm_lrnr <- Lrnr_glm_fast$new()
lasso_lrnr <- Lrnr_glmnet$new(alpha = 1, nfolds = 3)
rf_lrnr <- Lrnr_ranger$new(num.trees = 200)

# create learner library and instantiate super learner ensemble
lrnr_lib <- Stack$new(mean_lrnr, fglm_lrnr, lasso_lrnr, rf_lrnr)
sl_lrnr <- Lrnr_sl$new(learners = lrnr_lib, metalearner = Lrnr_nnls$new())


## ----natural_de_os------------------------------------------------------------
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


## ----natural_ie_os------------------------------------------------------------
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


## \dimendef\prevdepth=0

## \pgfdeclarelayer{background}

## \pgfsetlayers{background,main}

## \usetikzlibrary{arrows,positioning}

## \tikzset{

## >=stealth',

## punkt/.style={

## rectangle,

## rounded corners,

## draw=black, very thick,

## text width=6.5em,

## minimum height=2em,

## text centered},

## pil/.style={

## ->,

## thick,

## shorten <=2pt,

## shorten >=2pt,}

## }

## \newcommand{\Vertex}[2]

## {\node[minimum width=0.6cm,inner sep=0.05cm] (#2) at (#1) {$#2$};

## }

## \newcommand{\VertexR}[2]

## {\node[rectangle, draw, minimum width=0.6cm,inner sep=0.05cm] (#2) at (#1) {$#2$};

## }

## \newcommand{\ArrowR}[3]

## { \begin{pgfonlayer}{background}

## \draw[->,#3] (#1) to[bend right=30] (#2);

## \end{pgfonlayer}

## }

## \newcommand{\ArrowL}[3]

## { \begin{pgfonlayer}{background}

## \draw[->,#3] (#1) to[bend left=45] (#2);

## \end{pgfonlayer}

## }

## \newcommand{\EdgeL}[3]

## { \begin{pgfonlayer}{background}

## \draw[dashed,#3] (#1) to[bend right=-45] (#2);

## \end{pgfonlayer}

## }

## \newcommand{\Arrow}[3]

## { \begin{pgfonlayer}{background}

## \draw[->,#3] (#1) -- +(#2);

## \end{pgfonlayer}

## }

## \begin{tikzpicture}

## \Vertex{0, -1}{Z}

## \Vertex{-4, 0}{W}

## \Vertex{0, 0}{M}

## \Vertex{-2, 0}{A}

## \Vertex{2, 0}{Y}

## \ArrowR{W}{Z}{black}

## \Arrow{Z}{M}{black}

## \Arrow{W}{A}{black}

## \Arrow{A}{M}{black}

## \Arrow{M}{Y}{black}

## \Arrow{A}{Z}{black}

## \Arrow{Z}{Y}{black}

## \ArrowL{W}{Y}{black}

## \ArrowL{A}{Y}{black}

## \ArrowL{W}{M}{black}

## \end{tikzpicture}


## ----interv_de_os-------------------------------------------------------------
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


## ----interv_ie_os-------------------------------------------------------------
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


## ----delta_ipsi---------------------------------------------------------------
delta_shift_ipsi <- 3


## ----efficient_est, eval=FALSE------------------------------------------------
## # let's compute the parameter where A (but not Z) are shifted
## pide_decomp_onestep <- medshift(
##   W = W, A = A, Z = Z, Y = Y,
##   delta = delta_shift_ipsi,
##   g_learners = lasso_lrnr,
##   e_learners = lasso_lrnr,
##   m_learners = lasso_lrnr,
##   estimator = "onestep",
##   estimator_args = list(cv_folds = 5)
## )
## summary(pide_decomp_onestep)


## ----linear_contrast_delta, eval=FALSE----------------------------------------
## # convenience function to compute inference via delta method: EY1 - EY0
## linear_contrast <- function(params, eifs, ci_level = 0.95) {
##   # bounds for confidence interval
##   ci_norm_bounds <- c(-1, 1) * abs(stats::qnorm(p = (1 - ci_level) / 2))
##   param_est <- params[[1]] - params[[2]]
##   eif <- eifs[[1]] - eifs[[2]]
##   se_eif <- sqrt(var(eif) / length(eif))
##   param_ci <- param_est + ci_norm_bounds * se_eif
##   # parameter and inference
##   out <- c(param_ci[1], param_est, param_ci[2])
##   names(out) <- c("lwr_ci", "param_est", "upr_ci")
##   return(out)
## }


## ----comp_de_binary, eval=FALSE-----------------------------------------------
## # parameter estimates and EIFs for components of direct effect
## EY <- mean(Y)
## eif_EY <- Y - EY
## params_de <- list(theta_eff$theta, EY)
## eifs_de <- list(theta_eff$eif, eif_EY)
## 
## # direct effect = EY - estimated quantity
## de_est <- linear_contrast(params_de, eifs_de)
## de_est

