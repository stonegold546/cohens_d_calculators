# cohens_d_calculators

Cohen's d calculator for ESQREM 6641 class

## Formulae

### Cohen's _d_ family

The formulae for point estimates for the Cohen's _d_ family of effect sizes were obtained from Lakens (2013). The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the noncentral _t_ method. The confidence intervals were computed on _d_ rather than _g_ (Cumming, 2012). The formulae for the estimation of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda) and its transformation to confidence intervals around _d_ for within-subject designs were obtained from Algina & Keselman (2003).

#### Confidence Intervals (All 95%)

_d_ is converted to _t_. An Open URI API call is made using _t_ as an estimate of the noncentrality parameter. This uses the `conf.limits.nct` function within the R `MBESS` package. It returns lower and upper limits on _t_, which are converted back to lower and upper limits _d_.

#### One-sample t-test

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7BM%20-%20%20%5Cmu%7D%7Bs%7D)

##### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?t=%5Ctextrm%7BCohen's%7D%5C%20d%5Ctimes%20%5Csqrt%7Bn%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: _n_ - 1 }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%5Cfrac%7Bt%7D%7B%20%5Csqrt%7Bn%7D%7D)

--------------------------------------------------------------------------------

Notation:

- _M_ : sample mean
- ![equation](http://latex.codecogs.com/gif.latex?%5Cmu) : population mean
- _s_ : sample standard deviation
- _n_ : sample size
- _t_ : estimate of noncentrality parameter

#### Independent-samples t-test

<!-- Cohen's d -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7B(n_%7B1%7D%20-%201)%20SD%5E%7B2%7D_%7B1%7D%20+%20(n_%7B2%7D%20-%201)%20SD%5E%7B2%7D_%7B2%7D%20%7D%7Bn_%7B1%7D%20+%20n_%7B2%7D%20-%202%7D%7D%7D)

<!-- Hedges' g %5Ctextrm%7BHedges'%7D%5C%20 -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7B1%7D%20+%20n_%7B2%7D%20)%20-%209%20%7D%20%5Cbig))

<!-- g to r -->

 ![equation](http://latex.codecogs.com/gif.latex?r=%20%5Cfrac%7B%5Ctextrm%7BHedges'%7D%5C%20g%7D%7B%20%5Csqrt%7B%20(%5Ctextrm%7BHedges'%7D%5C%20g)%5E%7B2%7D%20+%20%20%5Cfrac%7BN%5E%7B2%7D-2N%7D%7Bn_%7B1%7Dn_%7B2%7D%7D%20%7D%20%7D)

##### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?t=%20%5Cfrac%7B%5Ctextrm%7BCohen's%20%7Dd%7D%7B%20%5Csqrt%7B%20%5Cfrac%7B1%7D%7Bn_%7B1%7D%7D+%5Cfrac%7B1%7D%7Bn_%7B2%7D%7D%7D%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: ![equation](http://latex.codecogs.com/gif.latex?n_%7B1%7D+n_%7B2%7D-2) }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=t%5Ctimes%5Csqrt%7B%20%5Cfrac%7B1%7D%7Bn_%7B1%7D%7D+%5Cfrac%7B1%7D%7Bn_%7B2%7D%7D%7D)

--------------------------------------------------------------------------------

Notation:

- ![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B1%7D%20) : mean of group 1; ![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B2%7D%20) : mean of group 2
- ![equation](http://latex.codecogs.com/gif.latex?n_%7B1%7D) : sample size of group 1; ![equation](http://latex.codecogs.com/gif.latex?n_%7B2%7D) : sample size of group 2
- ![equation](http://latex.codecogs.com/gif.latex?SD_%7B1%7D) : standard deviation of group 1; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B2%7D) : standard deviation of group 2
- _N_ : sum of sample size of group 1 and sample size of group 2
- _t_ : estimate of noncentrality parameter

#### Paired-samples t-test

## References

- Algina, J., & Keselman, H. J. (2003). Approximate Confidence Intervals for Effect Sizes. _Educational and Psychological Measurement, 63_(4), 537–553\. <https://doi.org/10.1177/0013164403256358>
- Cumming, G. (2012). _Understanding The New Statistics_. Routledge. Retrieved from <http://proquest.safaribooksonline.com/9780415879675>
- Kelley, K. (2007). Methods for the Behavioral, Educational, and Social Sciences: An R package. _Behavior Research Methods, 39_(4), 979–984\. <https://doi.org/10.3758/BF03192993>
- Lakens, D. (2013). Calculating and reporting effect sizes to facilitate cumulative science: a practical primer for t-tests and ANOVAs. _Frontiers in Psychology, 4_(863). <https://doi.org/10.3389/fpsyg.2013.00863>

<!-- %20%5C%20%20%5C%20%5Cbig(2%5Cbig) -->
