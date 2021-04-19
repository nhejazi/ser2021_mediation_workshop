# Estimation of natural (in)direct effects, interventional (in)direct effects

## Interventional direct and indirect effects

Recall:

\begin{figure}

{\centering \includegraphics[width=0.5\linewidth]{/home/runner/work/ser2021_mediation_workshop/ser2021_mediation_workshop/img/medDAG2} 

}

\end{figure}

We define the interventional direct effect as:
\begin{equation*}
  \psi_{\text{PIDE}} = \E(Y_{a^\prime,g_{M \mid a^\star,W}}) -
    \E(Y_{a\star,g_{M \mid a^\star,W}}),
\end{equation*}
and the interventional indirect effect as:
\begin{equation*}
  \psi_{\text{PIIE}} = \E(Y_{a^\prime,g_{M \mid a^\prime,W}}) -
    \E(Y_{a^\prime,g_{M \mid a^\star,W}}).
\end{equation*}

## Simple case for intuition

Consider a simple data structure $O=(W, A, Z, M, Y)$. This SCM is represented in
the above DAG and the following causal models:
\begin{align*}
  W &= f(U_W)\\
  A &= f(U_A)\\
  Z &= f(A, W, U_Z)\\
  M &= f(Z, A, W, U_M)\\
  Y &= f(M, Z, A, W, U_Y),
\end{align*}
where ($U_W, U_A, U_Z, U_M, U_Y$) are exogenous random errors. We assume $A$ is
a single binary treatment, $Z$ is a single binary intermediate confounder, $M$
is a single binary mediator. There are no restrictions on the distribution of
$W$ or $Y$.

$g_{M \mid a^\prime,W}$ represents a stochastic draw from the counterfactual,
conditional distribution of $M$, as described by
@vanderweele2016mediation:
\begin{equation*}
  g_{M \mid A,W}(m, a^{\star}, W) \equiv g_{M \mid a^{\star}, W}(W) =
    \sum_{z=0}^1 \P(M=1 \mid Z=z,W) \P(Z=z \mid A=a^{\star}, W).
\end{equation*}
In what follows, we are going to assume that $g_{M \mid A,W}(m, a^{\star}, W)$
is known, estimated from observed data, which we call
$\hat{g}_{M \mid a^{\star}, W}$. This is going to slightly alter the usual
identification assumptions such that we no longer need to assume exchangeability
of $A$ and the counterfactual $M$ values.  This means the remaining assumptions
are the same as those for controlled direct effects.

### Estimation using G-Computation

The estimand $E(Y_{a^\prime, \hat{g}_{M \mid a^\star,W}})$ can be identified
via sequential regression, which provides the framework for the
G-computation-based estimator. The procedure is as follows

1. Fit a regression of $Y$ on $M,Z,W$. Predict outcome values under under
   $M=m$. We'll call the result $\bar{Q}_Y(M,Z,W)$.
2. Integrate out $M$ under our stochastic intervention
   $\hat{g}_{M \mid a^{\star}, W}$. We can do this by evaluating
   $\E(Y \mid M=m,Z=z,W)$ at each $m$ and multiplying it by the probability
   that $M=m$ under $\hat{g}_{M \mid a^{\star}, W}$, summing over all $m$.
   We'll call the results $\bar{Q}^{g}_M(Z,W)$.
3. Integrate out $Z$ and set $A=a^\prime$. Again, we can do this by evaluating
   the predicted values from Step 2, setting $A=a^\prime$, and at each $z$,
   multiplying the prediction by the probability that $Z=z$ under $A=a^\prime$.
   We'll call the result $\bar{Q}^{a^\prime}_Z(W)$.
4. Taking the sample mean (marginalizing over $W$) gives the parameter
   estimate.

### Estimate with doubly robust methods based on the EIF

The EIF for the parameter $\Psi(P)(a^{\prime}, \hat{g}_{M \mid a^{\star},W})$,
where, again, $\hat{g}_{M \mid a^{\star}, W}$ is assumed known, is given by:
\begin{align*}
  D^{\star}(a^{\prime}, \hat{g}_{M \mid a^{\star}, W}) &= \sum_{k=0}^2
      D_k^{\star}(a^{\prime}, \hat{g}_{M \mid a^{\star}, W}), \text{ where }\\
  D^{\star}_0(a^{\prime}, \hat{g}_{M \mid a^{\star}, W}) &=
      \bar{Q}^{a^{\prime}}_{Z(W)} -
      \Psi(P)(a^{\prime}, \hat{g}_{M \mid a^{\star}, W})\\
  D^{\star}_1(a^{\prime}, \hat{g}_{M \mid a^{\star}, W}) &=
      \frac{I(A=a^{\prime})}{\P(A=a^{\prime} \mid W)}(\bar{Q}^{\hat{g}}_M(Z,W)
      - \bar{Q}^{a^{\prime}}_{Z(W)})\\
  D^{\star}_2(a^{\prime}, \hat{g}_{M \mid a^{\star}, W}) &=
      \frac{I(A=a^{\prime})\{I(M=1) \hat{g}_{M \mid a^{\star}, W} +
      I(M=0)(1-\hat{g}_{M \mid a^{\star}, W}) \}}{\P(A=a^{\prime}}
      &\times (Y-\bar{Q}_{Y(M,Z,W)}).
\end{align*}

### Estimate using TMLE

1. We estimate $g_{Z \mid a^{\star}, W}(W) = \P(Z=1 \mid A=a^{\star}, W)$ from
   a logistic regression of $Z$ on $A, W$ setting $A=a^{\star}$.
2. We then estimate $g_{M \mid z,W}(W) = \P(M=1 \mid Z=z, W)$ from a logistic
   regression of $M$ on $Z, W$, setting $z=\{0,1\}$.
3. We use these quantities to calculate $\hat{g}_{M \mid a^{\star}, W} =
   \hat{g}_{M \mid z=1,W}\hat{g}_{Z \mid a^{\star}, W} +
   \hat{g}_{M \mid z=0,W}(1-\hat{g}_{Z|a^{\star}, W})$.


```r
zmodel <- "z ~ a + w1 "
mmodel <- "m ~ z + w1"
ymodel <- "y ~ m + z*w1"

# make gm and get counterfactual predictions
zfit <- glm(formula = zmodel, family = "binomial", data = obsdat)
mfit <- glm(formula = mmodel, family = "binomial", data = obsdat)

za0 <- predict(zfit, newdata = data.frame(w1 = obsdat$w1, a = 0),
               type = "response")
za1 <- predict(zfit, newdata = data.frame(w1 = obsdat$w1, a = 1),
               type = "response")

mz1 <- predict(mfit, newdata = data.frame(w1 = obsdat$w1, z = 1),
               type = "response")
mz0 < -predict(mfit, newdata = data.frame(w1 = obsdat$w1, z = 0),
               type = "response")

gm0 <- (mz1 * za0) + (mz0 * (1 - za0))
gma1 <- (mz1 * za1) + (mz0 * (1 - za1))
```

4. To obtain an estimate of $\bar{Q}_{Y}(M,Z,W)$, predict values of $Y$ from a
   regression of $Y$ on $M,Z,W$, setting $m=1$ and $m=0$, giving
   $\hat{Y}(m=1, z, w)$ and $\hat{Y}(m=0, z, w)$.


```r
tmpdat$qyinit <- cbind(
  predict(glm(formula = ymodel, family = "binomial",
              data = data.frame(cbind(datw, z = z, m = m, y = y))),
          newdata = data.frame(cbind(datw, z = z, m = m)), type = "response"),
  predict(glm(formula = ymodel, family = "binomial",
              data = data.frame(cbind(datw, z = z, m = m, y = y))),
          newdata = data.frame(cbind(datw, z = z, m = 0)), type = "response"),
  predict(glm(formula = ymodel, family = "binomial",
              data = data.frame(cbind(datw, z = z, m = m, y = y))),
          newdata = data.frame(cbind(datw, z = z, m = 1)), type = "response")
)
```

5. Estimate the weights to be used for the initial targeting step:
   \begin{equation*}
      h_1(a) = \frac{I(A=a)\{I(M=1)\hat{g}_{M \mid a^{\star}, W} +
        I(M=0)(1-\hat{g}_{M \mid a^{\star}, W}) \}}{\P(A=a)\{I(M=1)
        g_{M \mid Z,W} + I(M=0)(1-g_{M \mid Z,W}) \}}
   \end{equation*}


```r
psa1 <- I(a == 1) / mean(a)
psa0 <- I(a == 0) / mean(1 - a)
mz <- predict(glm(formula = mmodel, family = "binomial",
                  data = data.frame(cbind(datw, z = z, m = m))),
              newdata = data.frame(cbind(datw, z = z)), type = "response")
psm <- (mz * m) + ((1 - mz) * (1 - m))

tmpdat$ha1gma1 <- ((m * gma1 + (1 - m) * (1 - gma1)) / psm) * psa1 * svywt
tmpdat$ha1gma0 <- ((m * gm + (1 - m) * (1 - gm)) / psm) * psa1 * svywt
tmpdat$ha0gma0 <- ((m * gm + (1 - m) * (1 - gm)) / psm) * psa0 * svywt
```

6. Estimate $\hat{\epsilon}$ by setting $\epsilon$ as the intercept of a
   weighted logistic regression model of $Y$ with
   $\text{logit}(\hat{\bar{Q}}_{Y}(M,Z,W))$ as an offset and weights
   $\hat{h}_{1}(a)$. (Note that this is just one possible TMLE.)

7. The estimate of $\bar{Q}_{Y}(M,Z,W)$ is updated by
   $\hat{\bar{Q}}^{\star}_{Y}(M,Z,W) =  \hat{\bar{Q}}_{Y}(\epsilon_n)(M,Z,W)$.


```r
# for E(Y_{1,gmastar})
epsilonma1g0 <- coef(glm(y ~ 1, weights = tmpdat$ha1gma0,
                         offset = (qlogis(qyinit[, 1])),
                         family = "quasibinomial", data = tmpdat))
tmpdat$qyupm0a1g0 <- plogis(qlogis(tmpdat$qyinit[, 2]) + epsilonma1g0)
tmpdat$qyupm1a1g0 <- plogis(qlogis(tmpdat$qyinit[, 3]) + epsilonma1g0)

# for E(Y_{1,gma})
epsilonma1g1 <- coef(glm(y ~ 1, weights = tmpdat$ha1gma1,
                         offset = (qlogis(qyinit[, 1])),
                         family = "quasibinomial", data = tmpdat))
tmpdat$qyupm0a1g1 <- plogis(qlogis(tmpdat$qyinit[, 2]) + epsilonma1g1)
tmpdat$qyupm1a1g1 <- plogis(qlogis(tmpdat$qyinit[, 3]) + epsilonma1g1)

# for E(Y_{0,gmastar})
epsilonma0g0 <- coef(glm(y ~ 1, weights = tmpdat$ha0gma0,
                         offset = (qlogis(qyinit[, 1])),
                         family = "quasibinomial", data = tmpdat))
tmpdat$qyupm0a0g0 <- plogis(qlogis(tmpdat$qyinit[, 2]) + epsilonma0g0)
tmpdat$qyupm1a0g0 <- plogis(qlogis(tmpdat$qyinit[, 3]) + epsilonma0g0)
```

8. We next integrate out $M$ from $\bar{Q}^{\star}_{Y}(M,Z,W)$. First, we
   estimate $\bar{Q}^{\star}_{Y,n}(M,Z,W)$ setting $m=1$ and $m=0$, giving
   $\bar{Q}^{\star}_Y(m=1, z, w)$ and $\bar{Q}^{\star}_Y(m=0, z, w)$. Then,
   multiply these predicted values by their probabilities under
   $\hat{g}_{M \mid a^{\star},W}(W)$ (for $a \in \{a, a^{\star}\}$), and add
   them together (i.e., $\bar{Q}^{\hat{g}}_{M,n}(Z,W) =
   \hat{Q}^{\star}_Y(m=1, z, w) \hat{g}_{M|a^{\star},W} +
   \hat{Q}^{\star}_Y(m=0, z, w)(1-\hat{g}_{M|a^{\star},W})$).


```r
tmpdat$Qma1g0 <- tmpdat$qyupm0a1g0 * (1 - gm) + tmpdat$qyupm1a1g0 * gm
tmpdat$Qma1g1 <- tmpdat$qyupm0a1g1 * (1 - gma1) + tmpdat$qyupm1a1g1 * gma1
tmpdat$Qma0g0 <- tmpdat$qyupm0a0g0 * (1 - gm) + tmpdat$qyupm1a0g0 * gm
```

9. We now fit a regression of $\bar{Q}^{\hat{g},\star}_{M,n}(Z,W)$ on $W$
   among those with $A=a^\prime$. We call the predicted values from this
   regression $\hat{\bar{Q}}^{a^\prime}_{Z}(W)$.


```r
Qzfita1g0 <- glm(formula = paste("Qma1g0", qmodel, sep = "~"),
                 data = tmpdat[tmpdat$a == 1, ], family = "quasibinomial")
Qzfita1g1 <- glm(formula = paste("Qma1g1", qmodel, sep = "~"),
                 data = tmpdat[tmpdat$a == 1, ], family = "quasibinomial")
Qzfita0g0 <- glm(formula = paste("Qma0g0", qmodel, sep = "~"),
                 data = tmpdat[tmpdat$a == 0, ], family = "quasibinomial")

Qza1g0 <- predict(Qzfita1g0, type = "response", newdata = tmpdat)
Qza1g1 <- predict(Qzfita1g1, type = "response", newdata = tmpdat)
Qza0g0 <- predict(Qzfita0g0, type = "response", newdata = tmpdat)
```

(Note that if $A$ were not randomly assigned, we would need to complete a
second targeting step.)

10. The empirical mean of these predicted values is the TML estimate of
   $\Psi(P)(a^\prime, \hat{g}_{M \mid a^{\star}, W})$.


```r
tmlea1m0 <- sum(Qzupa1g0 * svywt) / sum(svywt)
tmlea1m1 <- sum(Qzupa1g1 * svywt) / sum(svywt)
tmlea0m0 <- sum(Qzupa0g0 * svywt) / sum(svywt)
```

11. Repeat the above steps for each of the interventions. For example, for
    binary $A$, we would execute these steps a total of three times to
    estimate:
    1. $\Psi(P)(1,\hat{g}_{M \mid 1, W})$,
    2. $\Psi(P)(1,\hat{g}_{M \mid 0, W})$, and
    3. $\Psi(P)(0,\hat{g}_{M \mid 0, W})$.

12. The PIDE can then be obtained by substituting estimates of parameters
    $\Psi(P)(a,\hat{g}_{M \mid a^{\star}, W}) -
    \Psi(P)(a^{\star},\hat{g}_{M \mid a^{\star}, W})$ and the PIIE
    can be obtained by substituting estimates of parameters
    $\Psi(P)(a,\hat{g}_{M \mid a,W}) -
    \Psi(P)(a, \hat{g}_{M \mid a^{\star}, W})$.


```r
nde <- tmlea1m0 - tmlea0m0
nie <- tmlea1m1 - tmlea1m0
```

13. The variance can be estimated as the sample variance of the EIF (defined
    above, substituting in the targeted fits) divided by $n$.


```r
# first get EIF
tmpdat$qyupa1g0 <- plogis(qlogis(tmpdat$qyinit[, 1]) + epsilonma1g0)
tmpdat$qyupa1g1 <- plogis(qlogis(tmpdat$qyinit[, 1]) + epsilonma1g1)
tmpdat$qyupa0g0 <- plogis(qlogis(tmpdat$qyinit[, 1]) + epsilonma0g0)

eic1a1g0 <- tmpdat$ha1gma0 * (tmpdat$y - tmpdat$qyupa1g0)
eic2a1g0 <- psa1 * svywt * (tmpdat$Qma1g0 - Qzupa1g0)
eic3a1g0 <- Qzupa1g0 - tmlea1m0
eica1g0 <- eic1a1g0 + eic2a1g0 + eic3a1g0

eic1a1g1 <- tmpdat$ha1gma1 * (tmpdat$y - tmpdat$qyupa1g1)
eic2a1g1 <- psa1 * svywt * (tmpdat$Qma1g1 - Qzupa1g1)
eic3a1g1 <- Qzupa1g1 - tmlea1m1
eica1g1 <- eic1a1g1 + eic2a1g1 + eic3a1g1

eic1a0g0 <- tmpdat$ha0gma0 * (tmpdat$y - tmpdat$qyupa0g0)
eic2a0g0 <- psa0 * svywt * (tmpdat$Qma0g0 - Qzupa0g0)
eic3a0g0 <- Qzupa0g0 - tmlea0m0
eica0g0 <- eic1a0g0 + eic2a0g0 + eic3a0g0

# estimands
ndeeic <- eica1g0 - eica0g0
vareic <- var(ndeeic) / nrow(tmpdat)

nieeic <- eica1g1 - eica1g0
varnieeic <- var(nieeic) / nrow(tmpdat)
```

## The general case

Actually, we would want to have the fixed parameter with the true, unknown
$g_{M \mid a, W}$ and would like $M$ to be continuous/multi-dimensional.

This is a pain to do by hand, but Nima made an easy-to-use package for all of us
called [medoutcon](https://github.com/nhejazi/medoutcon)! He will go through
this next.
