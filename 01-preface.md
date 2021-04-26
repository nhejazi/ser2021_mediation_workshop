# Causal Mediation Analysis {#mediation}

## Mediation models

In this workshopp we will use directed acyclic graphs to conceptualize
the effects of interest. We will focus on the two types of graph:

### No intermediate confounders

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{01-preface_files/figure-latex/unnamed-chunk-1-1} 

}

\caption{Directed acylcic graph under *no intermediate confounders* of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-1)
\end{figure}
### Intermediate confounders

\begin{figure}

{\centering \includegraphics[width=0.8\linewidth]{01-preface_files/figure-latex/unnamed-chunk-2-1} 

}

\caption{Directed acylcic graph under intermediate confounders of the mediator-outcome relation affected by treatment}(\#fig:unnamed-chunk-2)
\end{figure}

## Counterfactuals

In what follows, we will define all the effects of interest using
_counterfactuals_. Counterfactuals are hypothetical random variables
that would have been observed in a world where we would be able to
perform interventions on the random variables of interest. For
example, $Y_a$ is a counterfactual variable in a hypothetical world
where $\P(A=a)=1$ with probability one. $Y_{a,m}$ is the
counterfactual outcome in a world where $\P(A=a,M=m)=1$, and $M_a$ is
the counterfactual variable representing the mediator in a world where
$\P(A=a)=1$.

In this workshop we use counterfactual variables as _primitives_, but
we note that in other causal inference frameworks, such as structural
equation models, counterfactuals are quantities _derived_ from the
model.
