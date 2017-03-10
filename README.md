# Effect size calculators

Calculator I built for ESQREM 6641 class, owes a lot to [Daniël Lakens'](https://twitter.com/lakens) work.

# Formulae

- [Cohen's _d_ family](#cohens-d-family)

  - [One-sample t-test](#one-sample-t-test)
  - [Independent-samples t-test](#independent-samples-t-test)
  - [Paired samples t-test](#paired-samples-t-test)

- [ANOVA](#anova)

  - [Partial eta-squared](#partial-eta-squared)
  - [Partial omega-squared](#partial-omega-squared)

- [Regression (OLS)](#regression-ols)

  - [_R_-squared confidence intervals](#r-squared-confidence-intervals)

- [Hierarchical Linear Modeling / Multilevel Modeling / Mixed Effects Modeling](#hierarchical-linear-modeling--multilevel-modeling--mixed-effects-modeling)

  - [Intracluster/Intraclass correlation coefficient (ICC)](#intraclusterintraclass-correlation-coefficient-icc)

## Cohen's _d_ family

The formulae for point estimates for the Cohen's _d_ family of effect sizes (_d_, _g_) and _r_ were obtained from Lakens (2013). The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the noncentral _t_ method. The confidence intervals were computed on _d_ rather than _g_ (Cumming, 2012). The formulae for the estimation of the noncentrality parameter (![equation](http://latex.codecogs.com/gif.latex?%5Clambda)) and its transformation to confidence intervals around _d_ for:

- the one-sample t-tests and independent-samples t-test are equivalent to equations 4.6 & 4.7 in chapter 4 of Smithson's Confidence Intervals (2003, pp. 33–41);
- the within-subject designs are equations 8 & 9 in Algina & Keselman (2003).

### Confidence Intervals (All 95%)

_t_ is calculated by converting from _d_, except for the paired-samples test. An Open URI API call is made using _t_ as an estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda). This uses the `conf.limits.nct` function within the R `MBESS` package. It returns lower and upper limits on _t_, which are converted back to lower and upper limits _d_.

### One-sample t-test

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7BM%20-%20%20%5Cmu%7D%7Bs%7D)

#### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?t=%5Ctextrm%7BCohen's%7D%5C%20d%5Ctimes%20%5Csqrt%7Bn%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: _n_ - 1 }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D%20=%5Cfrac%7Bt%7D%7B%20%5Csqrt%7Bn%7D%7D)

#### Notation:

_M_ : sample mean; ![equation](http://latex.codecogs.com/gif.latex?%5Cmu) : population mean; _s_ : sample standard deviation; _n_ : sample size; _t_ : estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda); ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D) : Lower and upper limits on Cohen's _d_

### Independent-samples t-test

<!-- Cohen's d -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7B(n_%7B1%7D%20-%201)%20SD%5E%7B2%7D_%7B1%7D%20+%20(n_%7B2%7D%20-%201)%20SD%5E%7B2%7D_%7B2%7D%20%7D%7Bn_%7B1%7D%20+%20n_%7B2%7D%20-%202%7D%7D%7D)

<!-- Hedges' g -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7B1%7D%20+%20n_%7B2%7D%20-2)%20-%201%20%7D%20%5Cbig))

<!-- g to r -->

 ![equation](http://latex.codecogs.com/gif.latex?r=%20%5Cfrac%7B%5Ctextrm%7BHedges'%7D%5C%20g%7D%7B%20%5Csqrt%7B%20(%5Ctextrm%7BHedges'%7D%5C%20g)%5E%7B2%7D%20+%20%20%5Cfrac%7BN%5E%7B2%7D-2N%7D%7Bn_%7B1%7Dn_%7B2%7D%7D%20%7D%20%7D)

#### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?t=%20%5Cfrac%7B%5Ctextrm%7BCohen's%20%7Dd%7D%7B%20%5Csqrt%7B%20%5Cfrac%7B1%7D%7Bn_%7B1%7D%7D+%5Cfrac%7B1%7D%7Bn_%7B2%7D%7D%7D%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: ![equation](http://latex.codecogs.com/gif.latex?n_%7B1%7D+n_%7B2%7D-2) }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D%20=t%5Ctimes%5Csqrt%7B%20%5Cfrac%7B1%7D%7Bn_%7B1%7D%7D+%5Cfrac%7B1%7D%7Bn_%7B2%7D%7D%7D)

#### Notation:

![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B1%7D%20) : mean of group 1; ![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B2%7D%20) : mean of group 2; ![equation](http://latex.codecogs.com/gif.latex?n_%7B1%7D) : sample size of group 1; ![equation](http://latex.codecogs.com/gif.latex?n_%7B2%7D) : sample size of group 2; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B1%7D) : standard deviation of group 1; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B2%7D) : standard deviation of group 2; _N_ : sum of sample size of group 1 and sample size of group 2; _t_ : estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda); ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D) : Lower and upper limits on Cohen's _d_

### Paired-samples t-test

#### Calculated using average of standard deviations (recommended)

<!-- Cohen's d -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7B%20SD%5E%7B2%7D_%7B1%7D%20+%20SD%5E%7B2%7D_%7B2%7D%20%7D%7B%202%7D%7D%7D)

<!-- Hedges' g -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7Bpairs%7D%20-1)%20-%201%20%7D%20%5Cbig))

#### Calculated using repeated measures

<!-- Cohen's d -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7BSD%5E%7B2%7D_%7B1%7D%20+%20SD%5E%7B2%7D_%7B2%7D%20-2%5Ctimes%20r%20%5Ctimes%20SD_%7B1%7D%20%5Ctimes%20SD_%7B2%7D%7D%7D%20%5Ctimes%20%5Csqrt%7B2(1-r)%7D)

<!-- Hedges' g -->

 ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BHedges'%7D%5C%20g%20=%20%5Ctextrm%7BCohen's%7D%5C%20d%20%5Ctimes%20%20%5Cbig(1%20-%20%20%5Cfrac%7B3%7D%7B4(%20n_%7Bpairs%7D%20-1)%20-%201%20%7D%20%5Cbig))

#### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?S_%7B12%7D%20=%20r%20%5Ctimes%20SD_%7B1%7D%20%5Ctimes%20SD_%7B2%7D)

![equation](http://latex.codecogs.com/gif.latex?t=%20%5Cfrac%7B%20%5Coverline%7Bx%7D_%7B1%7D%20-%20%5Coverline%7Bx%7D_%7B2%7D%20%7D%7B%20%5Csqrt%7B%5Cfrac%20%7BSD%5E%7B2%7D_%7B1%7D%20+%20SD%5E%7B2%7D_%7B2%7D%20-2%20S_%7B12%7D%20%7D%7Bn_%7Bpairs%7D%7D%7D%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: ![equation](http://latex.codecogs.com/gif.latex?n_%7Bpairs%7D-1) }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D%20=t%20%5Ctimes%20%5Csqrt%7B%5Cfrac%7B2(SD%5E%7B2%7D_%7B1%7D+SD%5E%7B2%7D_%7B2%7D-2S_%7B12%7D)%7D%7Bn_%7Bpairs%7D(SD%5E%7B2%7D_%7B1%7D+SD%5E%7B2%7D_%7B2%7D)%7D%7D)

#### Notation:

![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B1%7D%20) : mean of group 1; ![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B2%7D%20) : mean of group 2; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B1%7D) : standard deviation of group 1; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B2%7D) : standard deviation of group 2; ![equation](http://latex.codecogs.com/gif.latex?n_%7Bpairs%7D) : number of pairs; _r_ : correlation between group 1 and group 2; ![equation](http://latex.codecogs.com/gif.latex?S_%7B12%7D) : covariance of group 1 and group 2; _t_ : estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda); ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D) : Lower and upper limits on Cohen's _d_

## ANOVA

The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the noncentral _F_ method. The confidence intervals are set to 90%. This is equivalent to the 95% two-sided confidence interval given that the _F_-statistic cannot be negative (Smithson, 2003, pp. 42–66).

### Partial eta-squared

The formula for partial eta-squared is equation 13 from Lakens (2013), while that for its confidence intervals is equation 5.6 in chapter 5 of Smithson's Confidence Intervals (2003, pp. 42–66).

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%7D%5E%7B2%7D%3D%5Cfrac%7B%7D%7BF*df_%7B1%7D%7D%7B%28F*df_%7B1%7D%29+df_%7B2%7D%7D)

#### Confidence Intervals

This call to Open CPU returns the limits on _F_, as noncentrality parameters (![equation](http://latex.codecogs.com/gif.latex?%5Clambda)), which need to be converted back to partial eta-squared. I use the `conf.limits.ncf` function within the R `MBESS` package.

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.ncf/json>, body: { 'F.value' => _F_, 'df.1' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D), 'df.2' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D), 'conf.level' => 0.90 }

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%28LL%2CUL%29%7D%5E%7B2%7D%3D%5Cfrac%7B%5Clambda%7D%7B%5Clambda%20+%20df_%7B1%7D%20+%20df_%7B2%7D%20+%201%7D)

#### Notation:

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%7D%5E%7B2%7D) : partial eta-squared; _F_ : _F_-statistic; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?%5Clambda) : noncentrality parameter

### Partial omega-squared

This formula for partial omega-squared applies only when all our factors are manipulated not measured, and there are no covariates. It is equation 10 in Carroll and Nordholm (1975).

![equation](http://latex.codecogs.com/gif.latex?%5Comega_%7Bp%7D%5E%7B2%7D%3D%5Cfrac%7BF-1%7D%7BF%20+%20%5Cfrac%7Bdf_%7B2%7D%20+%201%7D%7Bdf_%7B1%7D%7D%7D)

#### Notation:

![equation](http://latex.codecogs.com/gif.latex?%5Comega_%7Bp%7D%5E%7B2%7D) : partial omega-squared; _F_ : _F_-statistic; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom

## Regression OLS

The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the `ci.R2` function. The confidence intervals are set to 90%. This is equivalent to the 95% two-sided confidence interval given that the _R_-squared cannot be negative (Smithson, 2003, pp. 42–66).

### _R_-squared confidence intervals

> <https://public.opencpu.org/ocpu/library/MBESS/R/ci.R2/json>, body: { 'R2' => _R2_, 'df.1' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D), 'df.2' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D), 'conf.level' => 0.90 }

#### Notation:

_R2_ : _R_-squared; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom

## Hierarchical Linear Modeling / Multilevel Modeling / Mixed Effects Modeling

All analysis related to multilevel models is performed using a [Python API](https://github.com/stonegold546/py_cohens_d_calculators) I created for the task.

### Intracluster/Intraclass correlation coefficient (ICC)

#### ANOVA Method

I used a variation of Searle's method (1971) which adjusts for unbalanced data by replacing the number of subjects per cluster with the weighted mean cluster size - equation 9 in Ukoumunne (2002) - to calculate the confidence intervals. All of this is handled by a call to the Python API listed above. The code within the Python API is near-identical to the `ICCest` function in the R [ICC](https://cran.r-project.org/web/packages/ICC/ICC.pdf) package. The call to the API returns the ICC, an estimate of variance across clusters, an estimate of variance within clusters, lower and upper limits on ICC, the number of clusters used in the analysis, and the weighted mean cluster size.

#### REML/ML

The Python API performs REML and FEML/ML using the code below from the `statsmodels` package in Python.

> model = sm.MixedLM.from_formula('values ~ 1', df, groups=df['clusters'])

> res = model.fit(reml=method)

The data is stored in a dataframe, `df`; `values` are the outcome data, with `clusters` being the cluster groupings. Method is either `TRUE` to use REML or `FALSE` to use ML.

The level-2 variance around the intercept, ![equation](http://latex.codecogs.com/gif.latex?%5Ctau_%7B00%7D), is obtained using `res.cov_re.groups[0]`, while the within group variance is obtained using `res.scale`, and the ICC is calculated using the formula, ![equation](http://latex.codecogs.com/gif.latex?%5Cfrac%7B%5Ctau_%7B00%7D%7D%7B%5Ctau_%7B00%7D+%5Csigma%5E2%7D). REML and ML return only the ICC, and the variance estimates. All other results are computed using the ANOVA method.

## References

- Algina, J., & Keselman, H. J. (2003). Approximate Confidence Intervals for Effect Sizes. _Educational and Psychological Measurement, 63_(4), 537–553\. <https://doi.org/10.1177/0013164403256358>
- Carroll, R. M., & Nordholm, L. A. (1975). Sampling Characteristics of Kelley's ![equation](http://latex.codecogs.com/gif.latex?%5Cepsilon) and Hays' ![equation](http://latex.codecogs.com/gif.latex?%5Comega). _Educational and Psychological Measurement, 35_(3), 541–554\. <https://doi.org/10.1177/001316447503500304>
- Cumming, G. (2012). _Understanding The New Statistics_. Routledge. Retrieved from <http://proquest.safaribooksonline.com/9780415879675>
- Kelley, K. (2007). Methods for the Behavioral, Educational, and Social Sciences: An R package. _Behavior Research Methods, 39_(4), 979–984\. <https://doi.org/10.3758/BF03192993>
- Lakens, D. (2013). Calculating and reporting effect sizes to facilitate cumulative science: a practical primer for t-tests and ANOVAs. _Frontiers in Psychology, 4_(863). <https://doi.org/10.3389/fpsyg.2013.00863>
- Searle, S. R. (1971). _Linear Models_. New York: Wiley.
- Smithson, M. (2003). Noncentral Confidence Intervals for Standardized Effect Sizes. In _Confidence Intervals_ (pp. 33–41). Thousand Oaks California: SAGE Publications, Inc. <https://doi.org/10.4135/9781412983761>
- Smithson, M. (2003). Applications in ANOVA and Regression. In _Confidence Intervals_ (pp. 42–66). Thousand Oaks California: SAGE Publications, Inc. <https://doi.org/10.4135/9781412983761.n5>
- Ukoumunne, O. C. (2002). A comparison of confidence interval methods for the intraclass correlation coefficient in cluster randomized trials. _Statistics in Medicine, 21_(24), 3757–3774\. <https://doi.org/10.1002/sim.1330>
