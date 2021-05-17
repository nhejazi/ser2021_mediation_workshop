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
n <- 1e6
w <- rnorm(n)
a <- rbinom(n, 1, plogis(1 + w))
m <- rnorm(n, w + a)
y <- rnorm(n, w + a + m)


## -----------------------------------------------------------------------------
fit_y1 <- lm(y ~ m + a + w)
fit_y2 <- lm(y ~ a + w)


## -----------------------------------------------------------------------------
pred_y1_a1 <- predict(fit_y1, newdata = data.frame(a = 1, m, w))
pred_y1_a0 <- predict(fit_y1, newdata = data.frame(a = 0, m, w))
pred_y2_a1 <- predict(fit_y2, newdata = data.frame(a = 1, w))
pred_y2_a0 <- predict(fit_y2, newdata = data.frame(a = 0, w))


## -----------------------------------------------------------------------------
pseudo_a1 <- pred_y2_a1 - pred_y1_a1
pseudo_a0 <- pred_y2_a0 - pred_y1_a0


## -----------------------------------------------------------------------------
pscore_fit <- glm(a ~ w, family = binomial())
pscore <- predict(pscore_fit, type = 'response')
## How do the intervention vs observed propensity score compare
pscore_delta <- 2 * pscore / (2 * pscore + 1 - pscore)


## -----------------------------------------------------------------------------
plot(pscore, pscore_delta, xlab = 'Observed prop. score',
     ylab = 'Prop. score under intervention')
abline(0, 1)


## -----------------------------------------------------------------------------
odds <- (pscore_delta / (1 - pscore_delta)) / (pscore / (1 - pscore))
summary(odds)


## -----------------------------------------------------------------------------
indirect <- pseudo_a1 * pscore_delta + pseudo_a0 * (1 - pscore_delta)


## -----------------------------------------------------------------------------
## E[Y(Adelta) - Y(Adelta, M)]
mean(indirect)


## -----------------------------------------------------------------------------
direct <- (pred_y1_a1 - y) * pscore_delta +
       (pred_y1_a0 - y) * (1 - pscore_delta)
mean(direct)

