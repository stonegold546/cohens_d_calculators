# cohens_d_calculators

Cohen's d calculator for ESQREM 6641 class

## Formulae

### Cohen's _d_ family

The formulae for point estimates for the Cohen's _d_ family of effect sizes were obtained from Lakens (2013). The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the noncentral _t_ method. The confidence intervals were computed on _d_ rather than _g_ (Cumming, 2012). The formulae for the estimation of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda) and its transformation to confidence intervals around _d_ for within-subject designs were obtained from Algina & Keselman (2003).

#### One-sample t-test

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7BM%20-%20%20%5Cmu%7D%7Bs%7D)

where _M_ is the sample mean, ![equation](http://latex.codecogs.com/gif.latex?%5Cmu) is the population mean, and _s_ is the sample standard deviation.

##### Confidence Intervals

_d_ is converted to _t_ using the formula:

![equation](http://latex.codecogs.com/gif.latex?t=%5Ctextrm%7BCohen's%7D%5C%20d%5Ctimes%20%5Csqrt%7Bn%7D)

The following Open URI API call is made to get the confidence intervals around _t_ using the noncentral method:

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: _n_ - 1 }

It uses the `conf.limits.nct` function within R `MBESS` package

The lower and upper limits of _t_ obtained from the `conf.limits.nct` function are converted back to _d_ using the formula:

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%5Cfrac%7Bt%7D%7B%20%5Csqrt%7Bn%7D%7D)

#### Independent-samples t-test

<!-- Cohen's d -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7B(n_%7B1%7D%20-%201)%20SD%5E%7B2%7D_%7B1%7D%20+%20(n_%7B2%7D%20-%201)%20SD%5E%7B2%7D_%7B2%7D%20%7D%7Bn_%7B1%7D%20+%20n_%7B2%7D%20-%202%7D%7D%7D)

<!-- Hedges' g -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7B1%7D%20+%20n_%7B2%7D%20)%20-%209%20%7D%20%5Cbig))

<!-- g to r -->

 ![equation](http://latex.codecogs.com/gif.latex?r=%20%5Cfrac%7Bg%7D%7B%20%5Csqrt%7B%20g%5E%7B2%7D%20+%20%20%5Cfrac%7BN%5E%7B2%7D-2N%7D%7Bn_%7B1%7Dn_%7B2%7D%7D%20%7D%20%7D)

## References

- Algina, J., & Keselman, H. J. (2003). Approximate Confidence Intervals for Effect Sizes. _Educational and Psychological Measurement, 63_(4), 537–553\. <https://doi.org/10.1177/0013164403256358>
- Cumming, G. (2012). _Understanding The New Statistics_. Routledge. Retrieved from <http://proquest.safaribooksonline.com/9780415879675>
- Kelley, K. (2007). Methods for the Behavioral, Educational, and Social Sciences: An R package. _Behavior Research Methods, 39_(4), 979–984\. <https://doi.org/10.3758/BF03192993>
- Lakens, D. (2013). Calculating and reporting effect sizes to facilitate cumulative science: a practical primer for t-tests and ANOVAs. _Frontiers in Psychology, 4_(863). <https://doi.org/10.3389/fpsyg.2013.00863>

<!-- %20%5C%20%20%5C%20%5Cbig(2%5Cbig) -->
