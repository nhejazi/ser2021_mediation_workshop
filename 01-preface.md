# Preliminaries on causal mediation analysis {#mediation}

## Motivating study

Do differences in the effects of treatment (comparing two medications for opioid use disorder, naltrexone vs buprenorphine) on risk of relapse operate through  mediators of adherence, opioid use, pain, and depressive symptoms? [@rudolph2020explaining]
<!--
ID: Need to fix format of the following figure
-->

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/ctndag} 

}

\end{figure}

## What is causal mediation analysis?

- Like all causal analyses, _causal mediation analysis_ is different from
  standard statistical mediation analyses
- Statistical mediation analyses merely assess associations between the variables
- Causal mediation analyses assess how the system behaves under interventions
- Causal mediation analysis is thus useful to understand mechanisms

### An example of a non-causal mediation analysis (product of coefficients)

- Assume you are interested in the effect of a treatment $A$ (naltrexone vs. buprenorphine) on an outcome $Y$ (risk of relapse) through mediators $M$
  (adherence, opioid use, pain, depressive symptoms)
- We could fit the following models:
    \begin{align}
      \E(Y\mid A=a) & = \alpha_0 + \alpha_1 a\\
      \E(M\mid A=a) & = \gamma_0 + \gamma_1 a\\
      \E(Y\mid M=m, A=a) & = \beta_0 + \beta_1 m + \beta_2 a
    \end{align}
- The product $(\gamma_1\beta_1)$ has been proposed as a measure of the effect
  of $A$ on $Y$ through $M$
- Causal interpretation problems with this method:
  - What happens if there are confounders of the relation between treatment and outcome?
  - What happens if there are confounders of the relation between mediator and outcome?
  - What happens if there are confounders of the relation between treatment and mediator?
  - What happens if the confounders of mediator and outcome are affected by treatment?
### Example:
- Assume we have a pre-treamtment confounder of $Y$ and $M$, denote it with $W$
- For simplicity, assume $A$ is randomized
- We'll generate a really large sample from a data generating mechanism so that we are not concerned with sampling errors

```r
n <- 1e7
w <- rnorm(n)
a <- rbinom(n, 1, 0.5)
m <- rnorm(n, w + a)
y <- rnorm(n, w - a)
```
- Note that the indirect effect (i.e., the effect through $M$) in this example is zero
- Let's see what the product of coefficients method would say:

```r
lm_y <- lm(y ~ m + a)
lm_m <- lm(m ~ a)
## product of coefficients
coef(lm_y)[2] * coef(lm_m)[2]
#>       m 
#> 0.50107
```


### Statistical issues with this method:
  - Assume the above confounding is not an issue
  - Can I then interpret $(\gamma_1\beta_1)$ as the indirect effect?
  - No: the regression models may be misspecified

## Causal mediation models

In this workshopp we will use directed acyclic graphs to conceptualize the above
confounding issues. We will focus on the two types of graph:

### No intermediate confounders

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{01-preface_files/figure-latex/unnamed-chunk-4-1} 

}

\caption{Directed acyclic graph under *no intermediate confounders* of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-4)
\end{figure}

### Intermediate confounders

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{01-preface_files/figure-latex/unnamed-chunk-5-1} 

}

\caption{Directed acyclic graph under intermediate confounders of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-5)
\end{figure}

The above graphs can be interpreted as a _non-parametric structural equation model_
(NPSEM), also known as _structural causal model_ (SCM):

\begin{align}
  W & = f_W(U_W)\\
  A & = f_A(W, U_A)\\
  Z & = f_Z(W, A, U_Z)\\
  M & = f_M(W, A, Z, U_M)\\
  Y & = f_Y(W, A, Z, M, U_Y)
\end{align}

- Here $U=(U_W, U_A, U_Z, U_M, U_Y)$ is a vector of all unmeasured exogenous
  factors affecting the system
- The functions $f$ are assumed fixed but unknown
- We posit this model as a system of equation that nature uses to geenrate the
  data at hand
- Therefore we leave the functions $f$ unspecified (i.e., we do not know the
  true nature mechanisms)
- Sometimes we know something: e.g., if $A$ is randomized we know $A=f_A(U_A)$
  where $U_A$ is the flip of a coin (i.e., independent of everything).

## Counterfactuals

- We define all the effects of interest using _counterfactuals_
- Counterfactuals are hypothetical random variables that would have been
  observed in a world where we would be able to perform interventions on the
  random variables of interest
- $Y_a$ is a counterfactual variable in a hypothetical world where $\P(A=a)=1$
  with probability one
- $Y_{a,m}$ is the counterfactual outcome in a world where $\P(A=a,M=m)=1$
- $M_a$ is the counterfactual variable representing the mediator in a world
  where $\P(A=a)=1$.

### How are counterfactuals defined?

- You can use counterfactual variables as _primitives_
- In the NPSEM framework, counterfactuals are quantities _derived_ from the
  model.
- Take as example the DAG in Figure 1.2:
  \begin{align}
    Y_a  &= f_Y(W, a, Z_a, M_a, U_Y)\\
    Y_{a,m}  &= f_Y(W, a, Z_a, m, U_Y)\\
    M_a  &= f_M(W, a, Z_a, U_M)
  \end{align}
- You can also define _nested counterfactuals_
- For example, if $A$ is binary, you can think of the following counterfactual
  \begin{equation*}
    Y_{1, M_0} = f_Y(W, 1, Z_1, M_0, U_Y)
  \end{equation*}
- Interpreted as _the outcome for an individual in a hypothetical world where
  treatment was given but the mediator was held at the value it would have
  taken under no treatment_
- Causal effects are defined in terms of the distribution of these counterfactuals
- I.e., causal effects give you information about what would happen _under intervention_

