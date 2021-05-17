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


## ----pressure, echo=FALSE, fig.cap="", fig.ext=if (knitr:::is_latex_output()) "pdf" else "png", out.width = "50%", results="asis"----
knitr::include_graphics(here::here("img", "graphic4a3.png"))


## -----------------------------------------------------------------------------
n <- 1e6
w <- rnorm(n)
a <- rbinom(n, 1, 0.5)
m <- rnorm(n, w + a)
y <- rnorm(n, w + a + m)


## -----------------------------------------------------------------------------
lm_y <- lm(y ~ m + a + w)


## -----------------------------------------------------------------------------
pred_y1 <- predict(lm_y, newdata = data.frame(a = 1, m = 0, w = w))
pred_y0 <- predict(lm_y, newdata = data.frame(a = 0, m = 0, w = w))


## -----------------------------------------------------------------------------
## CDE at m = 0
mean(pred_y1 - pred_y0)


## ---- echo=FALSE, fig.cap="", fig.ext=if (knitr:::is_latex_output()) "pdf" else "png", out.width = "50%", results="asis"----
knitr::include_graphics(here::here("img", "graphic4a.png"))


## -----------------------------------------------------------------------------
n <- 1e6
w <- rnorm(n)
a <- rbinom(n, 1, 0.5)
m <- rnorm(n, w + a)
y <- rnorm(n, w + a + m)


## -----------------------------------------------------------------------------
lm_y <- lm(y ~ m + a + w)


## -----------------------------------------------------------------------------
pred_y1 <- predict(lm_y, newdata = data.frame(a = 1, m = m, w = w))
pred_y0 <- predict(lm_y, newdata = data.frame(a = 0, m = m, w = w))


## -----------------------------------------------------------------------------
pseudo <- pred_y1 - pred_y0
lm_pseudo <- lm(pseudo ~ a + w)


## -----------------------------------------------------------------------------
pred_pseudo <- predict(lm_pseudo, newdata = data.frame(a = 0, w = w))
## NDE:
mean(pred_pseudo)


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

##   \Vertex{0, -1}{Z}

##   \Vertex{-4, 0}{W}

##   \Vertex{0, 0}{M}

##   \Vertex{-2, 0}{A}

##   \Vertex{2, 0}{Y}

##   \ArrowR{W}{Z}{black}

##   \Arrow{Z}{M}{black}

##   \Arrow{W}{A}{black}

##   \Arrow{A}{M}{black}

##   \Arrow{M}{Y}{black}

##   \Arrow{A}{Z}{black}

##   \Arrow{Z}{Y}{black}

##   \ArrowL{W}{Y}{black}

##   \ArrowL{A}{Y}{black}

##   \ArrowL{W}{M}{black}

## \end{tikzpicture}


## ---- echo=FALSE, fig.cap="", fig.ext=if (knitr:::is_latex_output()) "pdf" else "png", out.width = "100%", results="asis"----
knitr::include_graphics(here::here("img", "ctndag.png"))


## ---- echo=FALSE, fig.cap="", fig.ext=if (knitr:::is_latex_output()) "pdf" else "png", out.width = "50%", results="asis"----
knitr::include_graphics(here::here("img", "graphic4b.png"))


## -----------------------------------------------------------------------------
n <- 1e6
w <- rnorm(n)
a <- rbinom(n, 1, 0.5)
z <- rbinom(n, 1, 0.5 + 0.2 * a)
m <- rnorm(n, w + a - z)
y <- rnorm(n, w + a + z + m)


## -----------------------------------------------------------------------------
lm_y <- lm(y ~ m + a + z + w)
pred_a1z0 <- predict(lm_y, newdata = data.frame(m = m, a = 1, z = 0, w = w))
pred_a1z1 <- predict(lm_y, newdata = data.frame(m = m, a = 1, z = 1, w = w))


## -----------------------------------------------------------------------------
prob_z <- lm(z ~ a)
pred_z <- predict(prob_z, newdata = data.frame(a = 1))


## -----------------------------------------------------------------------------
pseudo_out <- pred_a1z0 * (1 - pred_z) + pred_a1z1 * pred_z


## -----------------------------------------------------------------------------
fit_pseudo <- lm(pseudo_out ~ a + w)
pred_pseudo <- predict(fit_pseudo, data.frame(a = 0, w = w))


## -----------------------------------------------------------------------------
## Mean(Y(1, G(0)))
mean(pred_pseudo)


## ---- echo=FALSE, fig.cap="", fig.ext=if (knitr:::is_latex_output()) "pdf" else "png", out.width = "125%", results="asis"----
knitr::include_graphics(here::here("img", "table1.png"))

