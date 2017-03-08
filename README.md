# cohens_d_calculators

Cohen's d calculator for ESQREM 6641 class

## Formulae

### Cohen's _d_ family

The formulae for point estimates for the Cohen's _d_ family of effect sizes were obtained from Lakens (2013). The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the noncentral _t_ method. The confidence intervals were computed on _d_ rather than _g_ (Cumming, 2012). The formulae for the estimation of the noncentrality parameter (![equation](http://latex.codecogs.com/gif.latex?%5Clambda)) and its transformation to confidence intervals around _d_ for within-subject designs were obtained from Algina & Keselman (2003).

#### Confidence Intervals (All 95%)

_t_ is calculated by converting from _d_, except for the paired-samples test. An Open URI API call is made using _t_ as an estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda). This uses the `conf.limits.nct` function within the R `MBESS` package. It returns lower and upper limits on _t_, which are converted back to lower and upper limits _d_.

#### One-sample t-test

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7BM%20-%20%20%5Cmu%7D%7Bs%7D)

##### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?t=%5Ctextrm%7BCohen's%7D%5C%20d%5Ctimes%20%5Csqrt%7Bn%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: _n_ - 1 }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D%20=%5Cfrac%7Bt%7D%7B%20%5Csqrt%7Bn%7D%7D)

##### Notation:

_M_ : sample mean; ![equation](http://latex.codecogs.com/gif.latex?%5Cmu) : population mean; _s_ : sample standard deviation; _n_ : sample size; _t_ : estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda); ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D) : Lower and upper limits on Cohen's _d_

#### Independent-samples t-test

<!-- Cohen's d -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7B(n_%7B1%7D%20-%201)%20SD%5E%7B2%7D_%7B1%7D%20+%20(n_%7B2%7D%20-%201)%20SD%5E%7B2%7D_%7B2%7D%20%7D%7Bn_%7B1%7D%20+%20n_%7B2%7D%20-%202%7D%7D%7D)

<!-- Hedges' g -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7B1%7D%20+%20n_%7B2%7D%20-2)%20-%201%20%7D%20%5Cbig))

<!-- g to r -->

 ![equation](http://latex.codecogs.com/gif.latex?r=%20%5Cfrac%7B%5Ctextrm%7BHedges'%7D%5C%20g%7D%7B%20%5Csqrt%7B%20(%5Ctextrm%7BHedges'%7D%5C%20g)%5E%7B2%7D%20+%20%20%5Cfrac%7BN%5E%7B2%7D-2N%7D%7Bn_%7B1%7Dn_%7B2%7D%7D%20%7D%20%7D)

##### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?t=%20%5Cfrac%7B%5Ctextrm%7BCohen's%20%7Dd%7D%7B%20%5Csqrt%7B%20%5Cfrac%7B1%7D%7Bn_%7B1%7D%7D+%5Cfrac%7B1%7D%7Bn_%7B2%7D%7D%7D%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: ![equation](http://latex.codecogs.com/gif.latex?n_%7B1%7D+n_%7B2%7D-2) }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D%20=t%5Ctimes%5Csqrt%7B%20%5Cfrac%7B1%7D%7Bn_%7B1%7D%7D+%5Cfrac%7B1%7D%7Bn_%7B2%7D%7D%7D)

##### Notation:

![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B1%7D%20) : mean of group 1; ![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B2%7D%20) : mean of group 2; ![equation](http://latex.codecogs.com/gif.latex?n_%7B1%7D) : sample size of group 1; ![equation](http://latex.codecogs.com/gif.latex?n_%7B2%7D) : sample size of group 2; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B1%7D) : standard deviation of group 1; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B2%7D) : standard deviation of group 2; _N_ : sum of sample size of group 1 and sample size of group 2; _t_ : estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda); ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D) : Lower and upper limits on Cohen's _d_

#### Paired-samples t-test

##### Calculated using average of standard deviations (recommended)

<!-- Cohen's d -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7B%20SD%5E%7B2%7D_%7B1%7D%20+%20SD%5E%7B2%7D_%7B2%7D%20%7D%7B%202%7D%7D%7D)

<!-- Hedges' g -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7Bpairs%7D%20-1)%20-%201%20%7D%20%5Cbig))

##### Calculated using repeated measures

<!-- Cohen's d -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7BSD%5E%7B2%7D_%7B1%7D%20+%20SD%5E%7B2%7D_%7B2%7D%20-2%5Ctimes%20r%20%5Ctimes%20SD_%7B1%7D%20%5Ctimes%20SD_%7B2%7D%7D%7D%20%5Ctimes%20%5Csqrt%7B2(1-r)%7D)

<!-- Hedges' g -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7Bpairs%7D%20-1)%20-%201%20%7D%20%5Cbig))

##### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?S_%7B12%7D%20=%20r%20%5Ctimes%20SD_%7B1%7D%20%5Ctimes%20SD_%7B2%7D)

![equation](http://latex.codecogs.com/gif.latex?t=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7BSD%5E%7B2%7D_%7B1%7D%20+%20SD%5E%7B2%7D_%7B2%7D%20-2%20S_%7B12%7D%20%7D%7Bn_%7Bpairs%7D%7D%7D%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: ![equation](http://latex.codecogs.com/gif.latex?n_%7Bpairs%7D-1) }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D%20=t%20%5Ctimes%20%5Csqrt%7B%5Cfrac%7B2(SD%5E%7B2%7D_%7B1%7D+SD%5E%7B2%7D_%7B2%7D-2S_%7B12%7D)%7D%7Bn_%7Bpairs%7D(SD%5E%7B2%7D_%7B1%7D+SD%5E%7B2%7D_%7B2%7D)%7D%7D)

##### Notation:

![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B1%7D%20) : mean of group 1; ![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B2%7D%20) : mean of group 2; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B1%7D) : standard deviation of group 1; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B2%7D) : standard deviation of group 2; ![equation](http://latex.codecogs.com/gif.latex?n_%7Bpairs%7D) : number of pairs; _r_ : correlation between group 1 and group 2; ![equation](http://latex.codecogs.com/gif.latex?S_%7B12%7D) : covariance of group 1 and group 2; _t_ : estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda); ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D) : Lower and upper limits on Cohen's _d_

### ANOVA

The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the noncentral _F_ method. The confidence intervals are set to 90%. This is equivalent to the 95% two-sided confidence interval given that the _F_-statistic cannot be negative (Smithson, 2003).

#### Partial Eta-squared

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%7D%5E%7B2%7D%3D%5Cfrac%7B%7D%7BF*df_%7B1%7D%7D%7B%28F*df_%7B1%7D%29+df_%7B2%7D%7D)

##### Confidence Intervals

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.ncf/json>, body: { 'F.value' => _F_, 'df.1' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D), 'df.2' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D), 'conf.level' => 0.90 }

This call to Open CPU returns the limits on _F_, as noncentrality parameters (![equation](http://latex.codecogs.com/gif.latex?%5Clambda)), which need to be converted back to partial eta-squared.

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%28LL%2CUL%29%7D%5E%7B2%7D%3D%5Cfrac%7B%5Clambda%7D%7B%5Clambda%20+%20df_%7B1%7D%20+%20df_%7B2%7D%20+%201%7D)

##### Notation:

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%7D%5E%7B2%7D) : partial eta-squared; _F_ : _F_-statistic; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?%5Clambda) : noncentrality parameter

#### Partial Omega-squared

This formula for partial omega-squared applies only when all our factors are manipulated not measured, and there are no covariates (Carroll & Nordholm, 1975).

![equation](http://latex.codecogs.com/gif.latex?%5Comega_%7Bp%7D%5E%7B2%7D%3D%5Cfrac%7BF-1%7D%7BF%20+%20%5Cfrac%7Bdf_%7B2%7D%20+%201%7D%7Bdf_%7B1%7D%7D%7D)

##### Notation:

![equation](http://latex.codecogs.com/gif.latex?%5Comega_%7Bp%7D%5E%7B2%7D) : partial omega-squared; _F_ : _F_-statistic; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom

### Regression OLS

The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the `ci.R2` function. The confidence intervals are set to 90%. This is equivalent to the 95% two-sided confidence interval given that the _R_-squared cannot be negative (Smithson, 2003).

#### R-squared Confidence Intervals

> <https://public.opencpu.org/ocpu/library/MBESS/R/ci.R2/json>, body: { 'R2' => _R2_, 'df.1' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D), 'df.2' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D), 'conf.level' => 0.90 }

##### Notation:

_R2_ : _R_-squared; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom

### Hierarchical Linear Modeling

#### Intracluster/Intraclass correlation coefficient (ICC)

## References

- Algina, J., & Keselman, H. J. (2003). Approximate Confidence Intervals for Effect Sizes. _Educational and Psychological Measurement, 63_(4), 537–553\. <https://doi.org/10.1177/0013164403256358>
- Carroll, R. M., & Nordholm, L. A. (1975). Sampling Characteristics of Kelley's ![equation](http://latex.codecogs.com/gif.latex?%5Cepsilon) and Hays' ![equation](http://latex.codecogs.com/gif.latex?%5Comega). _Educational and Psychological Measurement, 35_(3), 541–554\. <https://doi.org/10.1177/001316447503500304>
- Cumming, G. (2012). _Understanding The New Statistics_. Routledge. Retrieved from <http://proquest.safaribooksonline.com/9780415879675>
- Kelley, K. (2007). Methods for the Behavioral, Educational, and Social Sciences: An R package. _Behavior Research Methods, 39_(4), 979–984\. <https://doi.org/10.3758/BF03192993>
- Lakens, D. (2013). Calculating and reporting effect sizes to facilitate cumulative science: a practical primer for t-tests and ANOVAs. _Frontiers in Psychology, 4_(863). <https://doi.org/10.3389/fpsyg.2013.00863>
- Smithson, M. (2003). Applications in ANOVA and Regression. In Confidence Intervals (pp. 42–66). Thousand Oaks California: SAGE Publications, Inc. <https://doi.org/10.4135/9781412983761.n5>
