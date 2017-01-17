# cohens_d_calculators

Cohen's d calculator for ESQREM 6641 class

## Formulae

The formulae for estimates for the Cohen's _d_ family of effect sizes were obtained from Lakens (2013). The R package MBESS (Kelley, 2013) is used to compute confidence intervals via the [Open CPU API](https://www.opencpu.org/api.html).

#### One-sample t-test

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7BM%20-%20%20%5Cmu%7D%7Bs%7D)

where _M_ is the sample mean, ![equation](http://latex.codecogs.com/gif.latex?%5Cmu) is the population mean, and _s_ is the sample standard deviation.

#### Independent-samples t-test

<!-- Cohen's d -->

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7B(n_%7B1%7D%20-%201)%20SD%5E%7B2%7D_%7B1%7D%20+%20(n_%7B2%7D%20-%201)%20SD%5E%7B2%7D_%7B2%7D%20%7D%7Bn_%7B1%7D%20+%20n_%7B2%7D%20-%202%7D%7D%7D)

<!-- Hedges' g -->

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7B1%7D%20+%20n_%7B2%7D%20)%20-%209%20%7D%20%5Cbig))

<!-- %20%5C%20%20%5C%20%5Cbig(2%5Cbig) -->

## References

- Kelley, K. (2007). Methods for the Behavioral, Educational, and Social Sciences: An R package. Behavior Research Methods, 39(4), 979–984. https://doi.org/10.3758/BF03192993
- Lakens, D. (2013). Calculating and reporting effect sizes to facilitate cumulative science: a practical primer for t-tests and ANOVAs. Frontiers in Psychology, 4, 863. https://doi.org/10.3389/fpsyg.2013.00863
