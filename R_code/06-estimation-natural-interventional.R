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


## -----------------------------------------------------------------------------
mean_y <- function(m, a, w) abs(w) + a * m
mean_m <- function(a, w)plogis(w^2 - a)
pscore <- function(w) plogis(1 - abs(w))

w_big <- runif(1e6, -1, 1)
trueval <- mean((mean_y(1, 1, w_big) - mean_y(1, 0, w_big)) * mean_m(0, w_big)
                + (mean_y(0, 1, w_big) - mean_y(0, 0, w_big)) *
                  (1 - mean_m(0, w_big)))

n <- 1000
w <- runif(n, -1, 1)
a <- rbinom(n, 1, pscore(w))
m <- rbinom(n, 1, mean_m(a, w))
y <- rnorm(n, mean_y(m, a, w))


## -----------------------------------------------------------------------------
library(mgcv)
## fit model for E(Y | A, W)
b_fit <- gam(y ~ m:a + s(w, by = a))
## fit model for P(A = 1 | M, W)
e_fit <- gam(a ~ m + w + s(w, by = m), family = binomial)
## fit model for P(A = 1 | W)
g_fit <- gam(a ~ w, family = binomial)


## -----------------------------------------------------------------------------
## Compute P(A = 1 | W)
g1_pred <- predict(g_fit, type = 'response')
## Compute P(A = 0 | W)
g0_pred <- 1 - g1_pred
## Compute P(A = 1 | M, W)
e1_pred <- predict(e_fit, type = 'response')
## Compute P(A = 0 | M, W)
e0_pred <- 1 - e1_pred
## Compute E(Y | A = 1, M, W)
b1_pred <- predict(b_fit, newdata = data.frame(a = 1, m, w))
## Compute E(Y | A = 0, M, W)
b0_pred <- predict(b_fit, newdata = data.frame(a = 0, m, w))
## Compute E(Y | A, M, W)
b_pred  <- predict(b_fit)


## -----------------------------------------------------------------------------
## Compute Q(M, W)
pseudo <- b1_pred - b0_pred
## Fit model for E[Q(M, W) | A, W]
q_fit <- gam(pseudo ~ a + w + s(w, by = a))
## Compute E[Q(M, W) | A = 0, W]
q_pred <- predict(q_fit, newdata = data.frame(a = 0, w = w))


## -----------------------------------------------------------------------------
ip_weights <- a / g0_pred * e0_pred / e1_pred - (1 - a) / g0_pred


## -----------------------------------------------------------------------------
eif <- ip_weights * (y - b_pred) + (1 - a) / g0_pred * (pseudo - q_pred) +
  q_pred


## -----------------------------------------------------------------------------
## One-step estimator
mean(eif)


## -----------------------------------------------------------------------------
one_step <- function(y, m, a, w) {
  b_fit <- gam(y ~ m:a + s(w, by = a))
  e_fit <- gam(a ~ m + w + s(w, by = m), family = binomial)
  g_fit <- gam(a ~ w, family = binomial)
  g1_pred <- predict(g_fit, type = 'response')
  g0_pred <- 1 - g1_pred
  e1_pred <- predict(e_fit, type = 'response')
  e0_pred <- 1 - e1_pred
  b1_pred <- predict(b_fit, newdata = data.frame(a = 1, m, w),
	             type = 'response')
  b0_pred <- predict(b_fit, newdata = data.frame(a = 0, m, w),
                     type = 'response')
  b_pred  <- predict(b_fit, type = 'response')
  pseudo <- b1_pred - b0_pred
  q_fit <- gam(pseudo ~ a + w + s(w, by = a))
  q_pred <- predict(q_fit, newdata = data.frame(a = 0, w = w))
  ip_weights <- a / g0_pred * e0_pred / e1_pred - (1 - a) / g0_pred
  eif <- ip_weights * (y - b_pred) + (1 - a) / g0_pred *
    (pseudo - q_pred) + q_pred
  return(mean(eif))
}


## -----------------------------------------------------------------------------
w_big <- runif(1e6, -1, 1)
trueval <- mean((mean_y(1, 1, w_big) - mean_y(1, 0, w_big)) * mean_m(0, w_big) +
  (mean_y(0, 1, w_big) - mean_y(0, 0, w_big)) * (1 - mean_m(0, w_big)))
print(trueval)


## -----------------------------------------------------------------------------
estimate <- lapply(seq_len(1000), function(iter) {
  n <- 1000
  w <- runif(n, -1, 1)
  a <- rbinom(n, 1, pscore(w))
  m <- rbinom(n, 1, mean_m(a, w))
  y <- rnorm(n, mean_y(m, a, w))
  estimate <- one_step(y, m, a, w)
  return(estimate)
})
estimate <- do.call(c, estimate)

hist(estimate)
abline(v = trueval, col = "red", lwd = 4)


## ---- fig.height = 8, fig.width = 8-------------------------------------------
cis <- cbind(
  estimate - qnorm(0.975) * sd(estimate),
  estimate + qnorm(0.975) * sd(estimate)
)

ord <- order(rowSums(cis))
lower <- cis[ord, 1]
upper <- cis[ord, 2]
curve(trueval + 0 * x,
  ylim = c(0, 1), xlim = c(0, 1001), lwd = 2, lty = 3, xaxt = "n",
  xlab = "", ylab = "Confidence interval", cex.axis = 1.2, cex.lab = 1.2
)
for (i in 1:1000) {
  clr <- rgb(0.5, 0, 0.75, 0.5)
  if (upper[i] < trueval || lower[i] > trueval) clr <- rgb(1, 0, 0, 1)
  points(rep(i, 2), c(lower[i], upper[i]), type = "l", lty = 1, col = clr)
}
text(450, 0.10, "n=1000 repetitions = 1000 ", cex = 1.2)
text(450, 0.01, paste0(
  "Coverage probability = ",
  mean(lower < trueval & trueval < upper), "%"
), cex = 1.2)

