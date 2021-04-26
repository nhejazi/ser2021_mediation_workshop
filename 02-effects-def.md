# Path-specific casual mediation effect types {#estimands}

- Controlled direct effects
- Natural direct and indirect effects
- Interventional direct and indirect effects

## Controlled direct effects

$$  \psi_{\text{CDE}} = \E(Y_{1,m}) - \E(Y_{0,m}) $$

- Set $M=m$ uniformly for everyone in the population
- Compare $A=1$ vs $A=0$ with $M=m$ fixed
- Confounder assumptions:
  + $A \indep Y_{a,m} \mid W$
  + $M \indep Y_{a,m} \mid W, A, Z$
- Positivity assumptions:
  + $\P(M = m \mid Z, A=a, W) > 0 \text{  } a.e.$
  + $\P(A=a \mid W) > 0 \text{  } a.e.$

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/graphic4a3} 

}

\end{figure}

### Is this the estimand I want? {-}

+ Makes the most sense if can intervene directly on $M$
  + And can think of a policy that would set everyone to a single constant
    level $m \in \mathcal{M}$.
  + J. Pearl calls this _prescriptive_.
  + Can you think of an example?
  + Air pollution, rescue inhaler dosage, hospital visits
  + Does not provide a decomposition of the average treatment effect into direct and indirect effects

_What if our research question doesn't involve intervening directly on the
mediator?_

_What if we want to decompose the average treatment effect into its direct and indirect counterparts?_

## Natural direct and indirect effects {-}

Natural direct effect (NDE):
$$  \psi_{\text{NDE}} = \E(Y_{1,M_0}) - \E(Y_{0,M_0}) $$

Natural indirect effect (NIE):
$$
  \psi_{\text{NIE}} = \E(Y_{1,M_1}) - \E(Y_{1,M_0})
$$

<!--
ID: The below is only true if the cross-world assumption holds
-->
The NDE can also be written as: $\E_W \sum_m \{\E(Y_{1,m} \mid W) -
\E(Y_{0,m} \mid W)\} \P(M_{0}=m \mid W)$

- Weighted average of controlled direct effects at each level of $m$.
- If no interaction between $A$ and $M$ on $Y$, then CDE = NDE.

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/graphic4a} 

}

\end{figure}

### Identification assumptions:

- $A \indep Y_{a,m} \mid W$
- $M \indep Y_{a,m} \mid W, A$
- $A \indep M_a \mid W$
- $M_{a^{\star}} \indep Y_{a,m} \mid W$
- and positivity assumptions

What does $M_0 \indep Y_{1,m} \mid W$ mean?

- Conditional on $W$, knowledge of $M$ in the absence of treatment $A$
  provides no information of the effect of $A$ on $Y$.
- Can you think of a data-generating mechanism that would violate this
  assumption?
- Whenever we believe that treatment assignment works through adherence (i.e.,
  almost always), we are violating this assumption.

### Is this the estimand I want?

- Makes sense to intervene on $A$ but not directly on $M$.
- Want to understand a natural mechanism underlying an association/ total
  effect. J. Pearl calls this _descriptive_.
- NDE + NIE = total effect (ATE).
- Okay with the assumptions.
<!--
NH: Should we mention cross-world indep and indentifiability issues in RCTs?
-->

_What if our data structure involves a post-treatment confounder of the
mediator-outcome relationship (e.g., adherence)?_

\begin{figure}

{\centering \includegraphics[width=0.2\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/medDAG2} 

}

\end{figure}

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/ctndag} 

}

\end{figure}

## Interventional direct/ indirect effects {-}

- Fully conditional on past
 + Conditional SDE: $\E(Y_{a, g_{M \mid Z, a^{\star}, W}}) -
   \E(Y_{a^{\star}, g_{M \mid Z, a^{\star}, W}})$
 + Conditional SIE: $\E(Y_{a, g_{M \mid Z, a, W}}) -
   \E(Y_{a, g_{M \mid Z, a^{\star}, W}})$
 + Marginal SDE: $\E(Y_{a, g_{M \mid a^{\star}, W}}) -
   \E(Y_{a^{\star}, g_{M \mid a^{\star}, W}})$
 + Marginal SIE: $\E(Y_{a, g_{M \mid a, W}}) -
   \E(Y_{a, g_{M \mid a^{\star}, W}})$
 + Note that $g_{M \mid Z, a^{\star}, W}$, $g_{M \mid a^{\star}, W}$ represents
   stochastic intervention on the mediator, where value $m$ is drawn with
   probability $\P(M = m \mid Z, A = a^{\star}, W = w)$,
   $\P(M = m \mid A = a^{\star}, W = w)$, respectively
 + Can you think of an example when you would want the conditional versions?
   Marginal versions?

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/graphic4b} 

}

\end{figure}

### Identification assumptions:

- $A \indep Y_{a,m} \mid W$
- $M \indep Y_{a,m} \mid W, A$
- $A \indep M_a \mid W$
- and positivity assumptions.

Is this the estimand I want?

- Makes sense to intervene on $A$ but not directly on $M$.
- Goal is to understand a natural mechanism underlying an association or total
  effect.
- Okay with the assumptions!

## Estimand Summary {-}

\begin{figure}

{\centering \includegraphics[width=1\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/table1} 

}

\end{figure}





<!--
ID: Kara, I copied what I had written below, feel free to reuse
-->


# The Interventional Direct and Indirect Effects {#interventional}

## Definition of the effects

Consider the following directed acyclic graph.

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{02-effects-def_files/figure-latex/unnamed-chunk-6-1} 

}

\caption{Directed acylcic graph under intermediate confounders of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-6)
\end{figure}

Here, $A$ is the treatment of interest, $M$ is the mediator of
interest, $W$ is a pre-treatment variable containing confounders of
$A$ on $M$ and $Y$,and $Z$ is a post-treatment variable contaning
confounders of the mediator and the exposure which are affected by
treatment.

### Example
[TO FILL IN]



### Unidentifiability of the NDE and NIE in this setting

In this example, natural direct and indirect effects are
unidentifiable from observed data on $(W,A,Z,M,Y)$. The technical
reason for this is that the cross-world counterfactual assumption

\[Y(1,m)\indep M(0)\mid W\]

does not hold in the aboce directed acyiclic graph. Intuitively, the
reason for this is that an intervention setting $A=1$ (necessary for
the definition of $Y(1,m)$) induces a counterfactual variable
$Z(1)$. Likewise, an intervention setting $A=0$ (necessary for the
definition of $M(0)$) induces a counterfactual $Z(0)$. The variables
$Z(1)$ and $Z(0)$ are correlated because they share unmeasured common
causes. The variable $Z(1)$ is correlated with $Y(1,m)$, and the
variable $Z(0)$ is correlated with $M(0)$, because they are
counterfactual outcomes in the same hypothetical worlds. Thus, to
achieve $Y(1,m)$ independent of $M(0)$, it would be necessary to
adjust for either $Z(1)$ or $Z(0)$. This is impossible to do since
these variables are unmeasured.

### Recovering direct and indirect effects

Even though estimation of the NDE and NIE is not possible in the
presence of confounders of the mediation-outcome relation affected by
treatment, it is possible to redefine the effects in a way such that
they are identifiable. Specifically:

- Let $G(a)$ denote a random draw from the distribution of $M(a) \mid W$
- Define the counterfactual $Y(1,G(0))$ as the counterfactual
  variable in a hypothetical world where $A$ is set $A=1$ and $M$ is
  set to $M=G(0)$ with porbability one.
- Define $Y(0,G(0))$ and $Y(1,G(1))$ similarly
- Then we can define:
\[\E[Y(1,G(1)) - Y(0,G(0))]=\underbrace{\E[Y(1,G(1))-Y(1,G(0))]}_{\text{interventional indirect effect}}+\underbrace{\E[Y(1,G(0))-Y(0,G(0))]}_{\text{interventional direct effect}}\]
