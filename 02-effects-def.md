# Types of path-specific causal mediation effects {#estimands}

- Controlled direct effects
- Natural direct and indirect effects
- Interventional direct and indirect effects

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{02-effects-def_files/figure-latex/unnamed-chunk-1-1} 

}

\caption{Directed acyclic graph under *no intermediate confounders* of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-1)
\end{figure}

## Controlled direct effects

$$\psi_{\text{CDE}} = \E(Y_{1,m} - Y_{0,m}) $$

<!--
ID: Reminder to ask Kara about the purpose of these cartoons
KER: !!
-->

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/graphic4a3} 

}

\end{figure}

- Set the mediator to a reference value $M=m$ uniformly for everyone in the
  population
- Compare $A=1$ vs $A=0$ with $M=m$ fixed

### Identification assumptions:
- Confounder assumptions:
  + $A \indep Y_{a,m} \mid W$
  + $M \indep Y_{a,m} \mid W, A$
- Positivity assumptions:
  + $\P(M = m \mid A=a, W) > 0 \text{  } a.e.$
  + $\P(A=a \mid W) > 0 \text{  } a.e.$

Under the above identification assumptions, the controlled direct effect can be
identified:
$$ \E(Y_{1,m} - Y_{0,m}) = \E\{\color{ForestGreen}{\E(Y \mid A=1, M=m, W) - \E(Y \mid A=0, M=m, W)}\}$$

- For intuition about this formula in R, let's continue with a toy example:

```r
n <- 1e6
w <- rnorm(n)
a <- rbinom(n, 1, 0.5)
m <- rnorm(n, w + a)
y <- rnorm(n, w + a + m)
```
- First we fit a correct model for the outcome

```r
lm_y <- lm(y ~ m + a + w)
```
- Assume we would like the CDE at $m=0$
- Then we generate predictions \[\color{ForestGreen}{\E(Y \mid A=1, M=m, W)}
  \text{ and }\color{ForestGreen}{\E(Y \mid A=0, M=m, W)}:\]

```r
pred_y1 <- predict(lm_y, newdata = data.frame(a = 1, m = 0, w = w))
pred_y0 <- predict(lm_y, newdata = data.frame(a = 0, m = 0, w = w))
```
- Then we compute the difference between the predicted values
  $\color{ForestGreen}{\E(Y \mid A=1, M=m, W) - \E(Y \mid A=0, M=m, W)}$, and
  average across values of $W$

```r
## CDE at m = 0
mean(pred_y1 - pred_y0)
#> [1] 1.0009
```

### Is this the estimand I want?

+ Makes the most sense if can intervene directly on $M$
  + And can think of a policy that would set everyone to a single constant
    level $m \in \mathcal{M}$.
  + J. Pearl calls this _prescriptive_.
  + Can you think of an example?
  + Air pollution, rescue inhaler dosage, hospital visits
  + Does not provide a decomposition of the average treatment effect into
    direct and indirect effects

_What if our research question doesn't involve intervening directly on the
mediator?_

_What if we want to decompose the average treatment effect into its direct and
indirect counterparts?_

## Natural direct and indirect effects

Still using the same DAG as above,

- Recall the definition of the nested counterfactual

\begin{equation*}
    Y_{1, M_0} = f_Y(W, 1, M_0, U_Y)
\end{equation*}

- Interpreted as _the outcome for an individual in a hypothetical world where
  treatment was given but the mediator was held at the value it would have
  taken under no treatment_

  \begin{figure}
  
  {\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/graphic4a} 
  
  }
  
  \end{figure}

- Recall that, because of the definition of counterfactuals
\begin{equation*}
  Y_{1, M_1} = Y_1
\end{equation*}

Then we can decompose the _average treatment effect_ $E(Y_1-Y_0)$ as follows

\begin{equation*}
\E[Y_{1,M_1} - Y_{0,M_0}] = \underbrace{\E[Y_{\color{red}{1},\color{blue}{M_1}} -
    Y_{\color{red}{1},\color{blue}{M_0}}]}_{\text{natural indirect effect}} +
    \underbrace{\E[Y_{\color{blue}{1},\color{red}{M_0}} -
    Y_{\color{blue}{0},\color{red}{M_0}}]}_{\text{natural direct effect}}
\end{equation*}

- Natural direct effect (NDE): Varying treatment while keeping the mediator
  fixed at the value it would have taken under no treatment
- Natural indirect effect (NIE): Varying the mediator from the value it would
  have taken under treatment to the value it would have taken under control,
  while keeping treatment fixed

### Identification assumptions:

<!--
ID: For all the effects, we should add a discussion of identification
assumptions: what they mean and try to teach people to identify when they are
violated. We can do this in the context of our motivating examples.
-->

- $A \indep Y_{a,m} \mid W$
- $M \indep Y_{a,m} \mid W, A$
- $A \indep M_a \mid W$
- $M_0 \indep Y_{1,m} \mid W$
- and positivity assumptions

### Cross-world independence assumption

What does $M_0 \indep Y_{1,m} \mid W$ mean?

- Conditional on $W$, knowledge of the mediator value in the absence of
  treatment, $M_0$,
  provides no information about the outcome under treatment, $Y_{1,m}$.
- Can you think of a data-generating mechanism that would violate this
  assumption?
- Example: in a randomized study, whenever we believe that treatment assignment
  works through adherence (i.e., almost
  always), we are violating this assumption (more on this later).
- Cross-world assumptions are problematic for other reasons, including:
  - You can never design a randomized study where the assumption holds by
    design.

__If the cross-world assumption holds, can write the NDE as a weighted average
of controlled direct effects at each level of $M=m$.__

\[\E \sum_m \{\E(Y_{1,m} \mid W) - \E(Y_{0,m} \mid W)\} \P(M_{0}=m
\mid W)\]

- If CDE($m$) is constant across $m$, then CDE = NDE.


### Identification formula:

- Under the above identification assumptions, the natural direct effect can be
  identified:
\begin{equation*}
  \E(Y_{1,M_0} - Y_{0,M_0}) =
  \E[\color{Goldenrod}{\E\{}\color{ForestGreen}{\E(Y \mid A=1, M, W) -
  \E(Y \mid A=0, M, W)}\color{Goldenrod}{\mid A=0,W\}}]
\end{equation*}

- The natural indirect effect can be identified similarly.
- Let's dissect this formula in `R`:

```r
n <- 1e6
w <- rnorm(n)
a <- rbinom(n, 1, 0.5)
m <- rnorm(n, w + a)
y <- rnorm(n, w + a + m)
```
- First we fit a correct model for the outcome

```r
lm_y <- lm(y ~ m + a + w)
```

- Then we generate predictions \[\color{ForestGreen}{\E(Y \mid A=1, M, W)}
  \text{ and }\color{ForestGreen}{\E(Y \mid A=0, M, W)}\] with $A$ fixed but
  letting $M$ and $W$ take their observed
values

```r
pred_y1 <- predict(lm_y, newdata = data.frame(a = 1, m = m, w = w))
pred_y0 <- predict(lm_y, newdata = data.frame(a = 0, m = m, w = w))
```
- Then we compute the difference between the predicted values
  \[\color{ForestGreen}{\E(Y \mid A=1, M, W) - \E(Y \mid A=0, M, W)},\]
- and use this difference as a pseudo-outcome in a regression on $A$ and $W$:
  \[\color{Goldenrod}{\E\{}\color{ForestGreen}{\E(Y \mid A=1, M, W) - \E(Y \mid
  A=0, M, W)}\color{Goldenrod}{\mid A=0,W\}}\]



```r
pseudo <- pred_y1 - pred_y0
lm_pseudo <- lm(pseudo ~ a + w)
```

- Now we predict the value of this pseudo-outcome under $A=0$, and average the
  result

```r
pred_pseudo <- predict(lm_pseudo, newdata = data.frame(a = 0, w = w))
## NDE:
mean(pred_pseudo)
#> [1] 0.99655
```

### Is this the estimand I want?

- Makes sense to intervene on $A$ but not directly on $M$.
- Want to understand a natural mechanism underlying an association/ total
  effect. J. Pearl calls this _descriptive_.
- NDE + NIE = total effect (ATE).
- Okay with the assumptions.

_What if our data structure involves a post-treatment confounder of the
mediator-outcome relationship (e.g., adherence)?_

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{02-effects-def_files/figure-latex/unnamed-chunk-12-1} 

}

\caption{Directed acyclic graph under intermediate confounders of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-12)
\end{figure}

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/ctndag} 

}

\end{figure}

### Unidentifiability of the NDE and NIE in this setting

- In this example, natural direct and indirect effects are unidentifiable from observed data $O=(W,A,Z,M,Y)$.
- The reason for this is that the cross-world counterfactual
  assumption
\begin{equation*}
  Y_{1,m}\indep M_0\mid W
\end{equation*}
does not hold in the above directed acyclic graph.
- Technically, the reason for this is that an intervention setting $A=1$
  (necessary for the definition of $Y_{1,m}$) induces a counterfactual variable
  $Z_1$.
- Likewise, an intervention setting $A=0$ (necessary for the definition of
  $M_0$) induces a counterfactual $Z_0$.
- The variables $Z_1$ and $Z_0$ are correlated because they share unmeasured
  common causes, $U_Z$.
- The variable $Z_1$ is correlated with $Y_{1,m}$, and the variable $Z_0$ is
  correlated with $M_0$, because they are counterfactual outcomes in the same
  hypothetical worlds.
- To see this in the definition of counterfactual from a causal structural
  model:
\begin{align*}
  Y_{1,m} &= f_Y(W, 1, Z_1, m, U_Y), \text{ and }\\
  M_0 &= f_M(W, 0, Z_0, U_M)\\
\end{align*}
are correlated even after adjusting for $W$ by virtue of $Z_1$ and $Z_0$ being
correlated.

<!--
Ivan, this is such a great explanation!!  After that explanation, I'm not sure
what you have below adds anything, but I'm happy to keep it if you guys think
it's useful. Espeically because i think we do essentially adjust for z in our
sequential regressions if we are estimating controlled direct effects in this
environment, right?
-->
<!--
Intuitively:

- $Z$ is a confounder of the relation $M \rightarrow Y$, which requires
  adjustment
- But $Z$ is on the pathway $A\rightarrow Y$, which precludes adjustment
-->

Note: CDEs are still identified in this setting. They can be identified and
estimated similarly to a longitudinal data sructure with a two-time-point
intervention.

## Interventional (in)direct effects

<!--
I think the distinction between fully conditional and not will be completely
lost on people
-->
- Let $G_a$ denote a random draw from the distribution of $M_a \mid W$
- Define the counterfactual $Y_{1,G_0}$ as the counterfactual
  variable in a hypothetical world where $A$ is set $A=1$ and $M$ is
  set to $M=G_0$ with probability one.
  
\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/graphic4b} 

}

\end{figure}

- Define $Y_{0,G_0}$ and $Y_{1,G_1}$ similarly
- Then we can define:
\begin{equation*}
\E[Y_{1,G_1} - Y_{0,G_0}] = \underbrace{\E[Y_{\color{red}{1},\color{blue}{G_1}} -
    Y_{\color{red}{1},\color{blue}{G_0}}]}_{\text{interventional indirect effect}} +
    \underbrace{\E[Y_{\color{blue}{1},\color{red}{G_0}} -
    Y_{\color{blue}{0},\color{red}{G_0}}]}_{\text{interventional direct effect}}
\end{equation*}
- Note that $\E[Y_{1,G_1} - Y_{0,G_0}]$ is still a _total effect_ of treatment,
  even if it is different from the ATE $\E[Y_{1} - Y_{0}]$
- We gain in the ability to solve a problem, but lose in terms of interpretation
  of the causal effect (cannot decompose the ATE)

### An alternative definition of the effects:
- Above  we defined $G_a$ as a random draw from the distribution of $M_a \mid W$
- What if instead we define $G_a$ as a random draw from the distribution of $M_a
  \mid (Z_a,W)$
- It turns out the indirect effect defined in this way only measures the path
  $A\rightarrow M \rightarrow Y$, and not the path $A\rightarrow Z\rightarrow M
  \rightarrow Y$
- There may be important reasons to choose one over another (e.g., survival
  analyses where we want the distribution conditional on $Z$, instrumental
  variable designs where it doesn't make sense to condition on $Z$)

<!--
KER: I see that you commented all of this out and I don't feel that strongly
about it, but i think it is interesting and it is relevant and it is important
for folks to think about.
-->
<!--
 + Marginal PIDE: $\E(Y_{a, g_{M \mid a^{\star}, W}}) -
   \E(Y_{a^{\star}, g_{M \mid a^{\star}, W}})$
 + Marginal PIIE: $\E(Y_{a, g_{M \mid a, W}}) -
   \E(Y_{a, g_{M \mid a^{\star}, W}})$
 + Conditional PIDE: $\E(Y_{a, g_{M \mid Z, a^{\star}, W}}) -
   \E(Y_{a^{\star}, g_{M \mid Z, a^{\star}, W}})$
 + Conditional PIIE: $\E(Y_{a, g_{M \mid Z, a, W}}) -
   \E(Y_{a, g_{M \mid Z, a^{\star}, W}})$
 + Can you think of an example when you would want the conditional versions?
   Marginal versions?
-->

### Identification assumptions:

- $A \indep Y_{a,m} \mid W$
- $M \indep Y_{a,m} \mid W, A, Z$
- $A \indep M_a \mid W$
- and positivity assumptions.

Under these assumptions, the population interventional direct and indirect effect is identified:
\begin{align*}
  \E&(Y_{a, G_{a'}}) = \\
    &\E\left[\color{Purple}{\E\left\{\color{Goldenrod}{\sum_z}
    \color{ForestGreen}{\E(Y \mid A=a, Z=z, M, W)}
    \color{Goldenrod}{\P(Z=z \mid A=a, W)}\mid A=a', W\right\}}\right]
\end{align*}

- Let's dissect this formula in `R`:

```r
n <- 1e6
w <- rnorm(n)
a <- rbinom(n, 1, 0.5)
z <- rbinom(n, 1, 0.5 + 0.2 * a)
m <- rnorm(n, w + a - z)
y <- rnorm(n, w + a + z + m)
```

- Let us compute $\E(Y_{1, G_0})$ (so that $a = 1$, and $a'=0$).
- First, fit a regression model for the outcome, and compute
  \[\color{ForestGreen}{\E(Y \mid A=a, Z=z, M, W)}\] for all values of $z$

```r
lm_y <- lm(y ~ m + a + z + w)
pred_a1z0 <- predict(lm_y, newdata = data.frame(m = m, a = 1, z = 0, w = w))
pred_a1z1 <- predict(lm_y, newdata = data.frame(m = m, a = 1, z = 1, w = w))
```

- Now we fit the true model for $Z \mid A, W$ and get the conditional
  probability that $Z=1$ fixing $A=1$

```r
prob_z <- lm(z ~ a)
pred_z <- predict(prob_z, newdata = data.frame(a = 1))
```

- Now we compute the following pseudo-outcome:
  \[\color{Goldenrod}{\sum_z}\color{ForestGreen}{\E(Y \mid A=a, Z=z, M, W)}
  \color{Goldenrod}{\P(Z=z \mid A=a, w)}\]

```r
pseudo_out <- pred_a1z0 * (1 - pred_z) + pred_a1z1 * pred_z
```
- Now we regress this pseudo-outcome on $A,W$, and compute the predictions
  setting $A=0$, that is, \[\color{Purple}{\E\left\{\color{Goldenrod}{\sum_z}
  \color{ForestGreen}{\E(Y \mid A=a, Z=z, M, W)}
  \color{Goldenrod}{\P(Z=z \mid A=a, w)}\mid A=a', W\right\}}\]

```r
fit_pseudo <- lm(pseudo_out ~ a + w)
pred_pseudo <- predict(fit_pseudo, data.frame(a = 0, w = w))
```
- And finally, just average those predictions!

```r
## Mean(Y(1, G(0)))
mean(pred_pseudo)
#> [1] 1.1979
```
- This was for $(a,a')=(1,0)$. Can do the same with $(a,a')=(1,1)$, and
  $(a,a')=(0,0)$ to obtain an effect decomposition

\begin{equation*}
  \E[Y_{1,G_1} - Y_{0,G_0}] = \underbrace{\E[Y_{\color{red}{1},
    \color{blue}{G_1}} -
    Y_{\color{red}{1},
    \color{blue}{G_0}}]}_{\text{interventional indirect effect}} +
    \underbrace{\E[Y_{\color{blue}{1},\color{red}{G_0}} -
    Y_{\color{blue}{0},
    \color{red}{G_0}}]}_{\text{interventional direct effect}}
\end{equation*}

### Is this the estimand I want?

- Makes sense to intervene on $A$ but not directly on $M$.
- Goal is to understand a natural mechanism underlying an association or total
  effect.
- Okay with the assumptions!


## Estimand Summary
<!--
ID: Can we redo the below table fixing the G notation? Also, is it possible to
fix the formatting? (currently not very amenable to a presentation I think)
-->
\begin{figure}

{\centering \includegraphics[width=1.25\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/table1} 

}

\caption{Excerpted from @rudolph2019causal}(\#fig:unnamed-chunk-21)
\end{figure}
