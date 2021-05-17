## ---- echo=FALSE, fig.cap="", out.width = '50%'-------------------------------
knitr::include_graphics(here::here("img", "ctndag.png"))


## -----------------------------------------------------------------------------
n <- 1e6
w <- rnorm(n)
a <- rbinom(n, 1, 0.5)
z <- rbinom(n, 1, 0.2 * a + 0.3)
m <- rnorm(n, w + z)
y <- rnorm(n, m + w - a + z)


## -----------------------------------------------------------------------------
lm_y <- lm(y ~ m + a + w + z)
lm_m <- lm(m ~ a + w + z)
## product of coefficients
coef(lm_y)[2] * coef(lm_m)[2]


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

