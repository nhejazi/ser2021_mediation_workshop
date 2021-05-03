# Stochastic Direct and Indirect Effects {#stochastic}

## Definition of the effects

Consider the following directed acyclic graph.

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{04-stochastic_files/figure-latex/unnamed-chunk-1-1} 

}

\caption{Directed acyclic graph under no intermediate confounders of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-1)
\end{figure}

## Motivation for stochastic interventions

- So far we have discussed controlled, natural, and interventional (in)direct effects
- These effects require that $0 < \P(A=1\mid W) < 1$
- They are defined only for binary exposures
-  _What can we do when the positivity assumption does not hold or the exposure
  is continuous?_
- Solution: we can use stochastic effects

## Definition of stochastic effects

There are two possible ways of defining stochastic effects:

- Consider the effect of an intervention where the exposure is drawn from a
  distribution
  - Example: [TO FILL IN]
- Consider the effect of an intervention where the post-intervention exposure is
  a function of the actually received exposure
  - Example: [TO FILL IN]
- In both cases $A\mid W$ is non-deterministic, thus the name _stochastic intervention_

### Example: incremental propensity score interventions (IPSI) [@kennedy2018nonparametric] {-}

#### Definition of the intervention {-}

- Assume $A$ is binary, and $\P(A=1\mid W=w) = g(1\mid w)$ is the propensity score
- Consider an intervention in which each individual receives the intervention
  with probability $g_\delta(1\mid w)$, equal to
  \begin{equation*}
    g_\delta(1\mid w)=\frac{\delta g(1\mid w)}{\delta g(1\mid w) +
    1 - g(1\mid w)}
  \end{equation*}
- e.g., draw the post-intervention exposure from a Bernoulli variable with
  probability $g_\delta(1\mid w)$
- The value $\delta$ is user given
- Let $A_\delta$ denote the post-intervention distribution
- Some algebra shows that $\delta$ is an odds ratio comparing the pre- and
  post-intervantion distributions
  \begin{equation*}
    \delta = \frac{\text{odds}(A_\delta = 1\mid W=w)}
    {\text{odds}(A = 1\mid W=w)}
  \end{equation*}
- This gives the intervention a nice interpretation as _what would happen in a
  world where the odds of receiving treatment is increased by $\delta$_
- Let $Y_{A_\delta}$ denote the outcome in this hypothetical world

### Example: modified treatment policies

#### Definition of the intervention {-}

### Mediation analysis for stochastic interventions

- The total effect of an IPSI can be computed as a contrast of the outcome under
  intervention vs no intervention:
  \begin{equation*}
    \psi = \E[Y_{A_\delta} - Y]
  \end{equation*}
- Recall the NPSEM
  \begin{align}
    W & = f_W(U_W)\\
    A & = f_A(W, U_A)\\
    M & = f_M(W, A, U_M)\\
    Y & = f_Y(W, A, M, U_Y)
  \end{align}
- From this we have $Y_{A_\delta} = f_Y(W, A_\delta, M_{A_\delta}, U_Y)$
- Thus, we have $Y_{A_\delta} = Y_{A_\delta, M_{A_\delta}}$ and $Y = Y(A,M(A))$
- Let us introduce the counterfactual $Y_{A_\delta,M}$, interpreted as the
  outcome observed in a world where the intervention on $A$ is performed but the
  mediator is fixed at the value it would have taken under no intervention
- Then we can decompose the total effect into:
  \begin{align*}
    \E[Y&_{A_\delta,M_{A_\delta}} - Y_{A,M_A}] = \\
    &\underbrace{\E[Y_{A_\delta,M_{A_\delta}} -
      Y_{A_\delta,M_A}]}_{\text{stochastic natural indirect effect}} +
      \underbrace{\E[Y_{A,M_{A_\delta}} -
      Y_{A,M_A}]}_{\text{stochastic natural direct effect}}
  \end{align*}

## Identification of the effect of a stochastic intervention
