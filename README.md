# Effect size calculators

My name is James Uanhoro, and I am a PhD student in the [Quantitative Research, Evaluation & Measurement](http://ehe.osu.edu/educational-studies/qrem/) (QREM) program within the Educational Studies department at The Ohio State University. My advisor is [Professor Ann O'Connell](https://ehe.osu.edu/directory/?id=oconnell.87).

This is a calculator I originally built as a spreadsheet for the Introduction to Educational Statistics class I serve(d) as Teaching Assistant for. I initially intended that it focus only on the Cohen's _d_ family of effect sizes. My work on the Cohen's _d_ family of effect sizes owes a lot to [Daniël Lakens'](https://twitter.com/lakens) [writings](https://daniellakens.blogspot.nl/).

I want to thank [Professor Cristian Gugiu](https://ehe.osu.edu/directory/?id=gugiu.2) for originally introducing me to noncentral distributions for calculating confidence intervals in his course on univariate statistics.

And I thank [Professor O'Connell](https://ehe.osu.edu/directory/?id=oconnell.87) for her guidance through her multilevel modeling class and in person with my work here on multilevel models, and for her continued support of my graduate career and this project.

You can contact me at [uanhoro.1@osu.edu](mailto:uanhoro.1@osu.edu).

# Formulae

- [Cohen's _d_ family](#cohens-d-family)

  - [One-sample t-test](#one-sample-t-test)
  - [Independent-samples t-test](#independent-samples-t-test)
  - [Paired samples t-test](#paired-samples-t-test)

- [Odds-ratio](#odds-ratio)

- [ANOVA](#anova)

  - [Partial eta-squared](#partial-eta-squared)
  - [Partial omega-squared](#partial-omega-squared)

- [Regression (OLS)](#regression-ols)

  - [_R_-squared confidence intervals](#r-squared-confidence-intervals)

- [Hierarchical Linear Modeling / Multilevel Modeling / Mixed Effects Modeling](#hierarchical-linear-modeling--multilevel-modeling--mixed-effects-modeling)

  - [Intracluster/Intraclass correlation coefficient (ICC)](#intraclusterintraclass-correlation-coefficient-icc)
  - [Pseudo R-squared](#pseudo-r-squared)

## Cohen's _d_ family

The formulae for point estimates for the Cohen's _d_ family of effect sizes (_d_, _g_) and _r_ were obtained from Lakens (2013). The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the noncentral _t_ method. The confidence intervals were computed on _d_ rather than _g_ (Cumming, 2012). The formulae for the estimation of the noncentrality parameter (![equation](http://latex.codecogs.com/gif.latex?%5Clambda)) and its transformation to confidence intervals around _d_ for:

- the one-sample t-tests and independent-samples t-test are equivalent to equations 4.6 & 4.7 in chapter 4 of Smithson's Confidence Intervals (2003, pp. 33–41);
- the within-subject designs are equations 8 & 9 in Algina & Keselman (2003).

### Confidence Intervals

_t_ is calculated by converting from _d_, except for the paired-samples test. An Open URI API call is made using _t_ as an estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda). This uses the `conf.limits.nct` function within the R `MBESS` package. It returns lower and upper limits on _t_, which are converted back to lower and upper limits _d_.

### One-sample t-test

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d%20=%20%5Cfrac%7BM%20-%20%20%5Cmu%7D%7Bs%7D)

#### Confidence Intervals

![equation](http://latex.codecogs.com/gif.latex?t=%5Ctextrm%7BCohen's%7D%5C%20d%5Ctimes%20%5Csqrt%7Bn%7D)

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: _n_ - 1, 'conf.level' => confidence_interval }

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

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: ![equation](http://latex.codecogs.com/gif.latex?n_%7B1%7D+n_%7B2%7D-2), 'conf.level' => confidence_interval }

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

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json>, body: { ncp: _t_, df: ![equation](http://latex.codecogs.com/gif.latex?n_%7Bpairs%7D-1), 'conf.level' => confidence_interval }

![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D%20=t%20%5Ctimes%20%5Csqrt%7B%5Cfrac%7B2(SD%5E%7B2%7D_%7B1%7D+SD%5E%7B2%7D_%7B2%7D-2S_%7B12%7D)%7D%7Bn_%7Bpairs%7D(SD%5E%7B2%7D_%7B1%7D+SD%5E%7B2%7D_%7B2%7D)%7D%7D)

#### Notation:

![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B1%7D%20) : mean of group 1; ![equation](http://latex.codecogs.com/gif.latex?%5Coverline%7Bx%7D_%7B2%7D%20) : mean of group 2; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B1%7D) : standard deviation of group 1; ![equation](http://latex.codecogs.com/gif.latex?SD_%7B2%7D) : standard deviation of group 2; ![equation](http://latex.codecogs.com/gif.latex?n_%7Bpairs%7D) : number of pairs; _r_ : correlation between group 1 and group 2; ![equation](http://latex.codecogs.com/gif.latex?S_%7B12%7D) : covariance of group 1 and group 2; _t_ : estimate of ![equation](http://latex.codecogs.com/gif.latex?%5Clambda); ![equation](http://latex.codecogs.com/gif.latex?%5Ctextrm%7BCohen's%7D%5C%20d_%7BLL,%20UL%7D) : Lower and upper limits on Cohen's _d_

## Odds-ratio

The R package `epitools` (Aragon, 2012) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute the odds-ratio and confidence intervals using the `oddsratio` set of functions. The function called depends on the method the user selects: { `midp`: `oddsratio.midp`, `fisher`: `oddsratio.fisher`, `wald`: `oddsratio.wald`, `small`: `oddsratio.small` }. The 2x2 table is transformed into a vector (`[00, 01, 10, 11]`), which is passed to the selected oddsratio function, alongside the preferred confidence interval. It returns the odds ratio, and its confidence interval.

The sample call below is for the default method, `midp`.

> <https://public.opencpu.org/ocpu/library/epitools/R/oddsratio.midp>, body: { 'x' => {Matrix transformed into vector}, 'conf.level' => confidence_interval }

## ANOVA

These formulae apply only when all your factors are manipulated not measured, and when there are no covariates. The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the noncentral _F_ method. The default confidence interval is set to 90%. This is equivalent to the 95% two-sided confidence interval given that the _F_-statistic cannot be negative (Smithson, 2003, pp. 42–66).

### Partial eta-squared

The formula for partial eta-squared is equation 13 from Lakens (2013), while that for its confidence intervals is equation 5.6 in chapter 5 of Smithson's Confidence Intervals (2003, pp. 42–66).

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%7D%5E%7B2%7D%3D%5Cfrac%7B%7D%7BF*df_%7B1%7D%7D%7B%28F*df_%7B1%7D%29+df_%7B2%7D%7D)

#### Confidence Intervals

This call to Open CPU returns the limits on _F_, as noncentrality parameters (![equation](http://latex.codecogs.com/gif.latex?%5Clambda)), which need to be converted back to partial eta-squared. I use the `conf.limits.ncf` function within the R `MBESS` package.

> <https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.ncf/json>, body: { 'F.value' => _F_, 'df.1' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D), 'df.2' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D), 'conf.level' => confidence_interval }

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%28LL%2CUL%29%7D%5E%7B2%7D%3D%5Cfrac%7B%5Clambda%7D%7B%5Clambda%20+%20df_%7B1%7D%20+%20df_%7B2%7D%20+%201%7D)

#### Notation:

![equation](http://latex.codecogs.com/gif.latex?n_%7Bp%7D%5E%7B2%7D) : partial eta-squared; _F_ : _F_-statistic; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?%5Clambda) : noncentrality parameter

### Partial omega-squared

This formula for partial omega-squared is equation 10 in Carroll and Nordholm (1975).

![equation](http://latex.codecogs.com/gif.latex?%5Comega_%7Bp%7D%5E%7B2%7D%3D%5Cfrac%7BF-1%7D%7BF%20+%20%5Cfrac%7Bdf_%7B2%7D%20+%201%7D%7Bdf_%7B1%7D%7D%7D)

#### Notation:

![equation](http://latex.codecogs.com/gif.latex?%5Comega_%7Bp%7D%5E%7B2%7D) : partial omega-squared; _F_ : _F_-statistic; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom

## Regression OLS

The R package `MBESS` (Kelley, 2007) - via the [Open CPU API](https://www.opencpu.org/api.html) - is used to compute confidence intervals using the `ci.R2` function. The default confidence interval is set to 90%. This is equivalent to the 95% two-sided confidence interval given that the _R_-squared cannot be negative (Smithson, 2003, pp. 42–66).

### _R_-squared confidence intervals

> <https://public.opencpu.org/ocpu/library/MBESS/R/ci.R2/json>, body: { 'R2' => _R2_, 'df.1' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D), 'df.2' => ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D), 'conf.level' => confidence_interval }

#### Notation:

_R2_ : _R_-squared; ![equation](http://latex.codecogs.com/gif.latex?df_%7B1%7D) : effect degrees of freedom; ![equation](http://latex.codecogs.com/gif.latex?df_%7B2%7D) : error degrees of freedom

## Hierarchical Linear Modeling / Multilevel Modeling / Mixed Effects Modeling

All analysis related to multilevel models is performed using a [Python API](https://github.com/stonegold546/py_cohens_d_calculators) I created for the task. The API largely depends on the `MixedLM` function within the `StatsModels` package.

### Intracluster/Intraclass correlation coefficient (ICC)

#### ANOVA Method

To calculate the confidence intervals, I used a variation of Searle's method (1971, p. 414 - third equation in Table 9.14) which adjusts for unbalanced data by replacing the number of subjects per cluster in Searle's formula with the weighted mean cluster size - equation 9 in Ukoumunne (2002). All of this is handled by a call to the Python API listed above. The code within the Python API is near-identical to the `ICCest` function in the R [ICC](https://cran.r-project.org/web/packages/ICC/ICC.pdf) package. The call to the API returns the ICC, an estimate of variance across clusters, an estimate of variance within clusters, lower and upper limits on ICC, the number of clusters used in the analysis, and the weighted mean cluster size.

#### REML/ML & Optimization method

The Python API performs REML and FEML/ML using the code below from the `StatsModels` package in Python. The Nelder-Mead optimization method (Nelder & Mead, 1965) is applied by default.

> model = sm.MixedLM.from_formula('values ~ 1', df, groups=df['clusters'])

> res = model.fit(reml=method, method='nm')

The data are stored in a `Pandas` dataframe, `df`; `values` are the outcome data, with `clusters` being the cluster groupings. Method is either `True` to use REML or `False` to use ML.

The level-2 variance around the intercept, ![equation](http://latex.codecogs.com/gif.latex?%5Ctau_%7B00%7D), is obtained using `res.cov_re.groups[0]`, the within group variance is obtained using `res.scale`, and the ICC is calculated using the formula, ![equation](http://latex.codecogs.com/gif.latex?%5Cfrac%7B%5Ctau_%7B00%7D%7D%7B%5Ctau_%7B00%7D+%5Csigma%5E2%7D). REML and ML return only the ICC, and the variance estimates. All other results are computed using the ANOVA method.

### Pseudo R-Squared

The models are run using Maximum Likelihood.

#### Optimization method

The default optimization method is Nelder-Mead (Nelder & Mead, 1965). With the very limited test data I had, it produced models that converged unlike the default `bfgs` optimization method in `StatsModels`, which I listed as the last option.

#### Model equations

The Python API constructs the null and the fitted model equations. It also centers the variables based on user-specifications.

For example, consider a model with outcome `math_achievement`; the level-1 predictors are `student_ses` and `gender`, and level-2 predictor is `school_type` as a predictor of the `intercept` and `student_ses`.

The null model equation is: `math_achievement ~ 1`.

The fitted model equation is: `math_achievement ~ student_ses + gender + school_type + student_ses:school_type`. Without specifying additional options, this is a random-intercepts model.

Assuming the cluster variable is represented by `school`, the model (null or fitted) is saved into a variable called `model_equation`, and the data are stored in a `Pandas` dataframe called `data`, the StatsModels code is:

> model = sm.MixedLM.from_formula(model_equation, data, groups=data['school'])

> res = model.fit(reml=False, method='nm') # The method changes depending on the optimization method selected.

#### Level-1 and Level-2 R-squared

The level-2 variance around the intercept, ![equation](http://latex.codecogs.com/gif.latex?%5Ctau_%7B00%7D), is obtained using `res.cov_re.groups[0]`, the within group variance is obtained using `res.scale`.

The level-1 R-squared is based on equation 11 in Snijders & Bosker (1994):

![equation](http://latex.codecogs.com/gif.latex?R%5E2_1=1-%5Cfrac%7B%5Ctau_%7B00f%7D+%5Csigma_%7Bf%7D%5E%7B2%7D%7D%7B%5Ctau_%7B00b%7D+%5Csigma_%7Bb%7D%5E%7B2%7D%7D).

The level-2 R-squared is based on equation 13 in Snijders & Bosker (1994):

![equation](http://latex.codecogs.com/gif.latex?R%5E2_2=1-%5Cfrac%7B%5Ctau_%7B00f%7D+%5Cfrac%7B%5Csigma_%7Bf%7D%5E%7B2%7D%7D%7Bk%7D%7D%7B%5Ctau_%7B00b%7D+%5Cfrac%7B%5Csigma_%7Bb%7D%5E%7B2%7D%7D%7Bk%7D%7D).

Subscripts ending in `b` signify values from the null/base model, while those ending in `f` are values from the fitted model. `k` is the harmonic mean of cluster size, as recommended by Snijders & Bosker (1994, p. 13) for unbalanced data.

#### ICC

The `ICC` (calculated from the null model) is also returned. This value may differ from the value in the ICC segment. If the variables used in this model contain any missing values, cases with missing values are deleted prior to running the null and fitted model. At times, this may remove entire clusters from the model.

#### Model convergence

At times, the (fitted) models may fail to converge, and other times, the results time out. When either happens, try a different optimization method. It is possible your data are too large for the servers I am currently using if the results repeatedly timeout.

## References

- Aragon, T. J. (2012). epitools: Epidemiology Tools. Retrieved from <https://cran.r-project.org/package=epitools>
- Algina, J., & Keselman, H. J. (2003). Approximate Confidence Intervals for Effect Sizes. _Educational and Psychological Measurement, 63_(4), 537–553\. <https://doi.org/10.1177/0013164403256358>
- Carroll, R. M., & Nordholm, L. A. (1975). Sampling Characteristics of Kelley's ![equation](http://latex.codecogs.com/gif.latex?%5Cepsilon) and Hays' ![equation](http://latex.codecogs.com/gif.latex?%5Comega). _Educational and Psychological Measurement, 35_(3), 541–554\. <https://doi.org/10.1177/001316447503500304>
- Cumming, G. (2012). _Understanding The New Statistics_. Routledge. Retrieved from <http://proquest.safaribooksonline.com/9780415879675>
- Kelley, K. (2007). Methods for the Behavioral, Educational, and Social Sciences: An R package. _Behavior Research Methods, 39_(4), 979–984\. <https://doi.org/10.3758/BF03192993>
- Lakens, D. (2013). Calculating and reporting effect sizes to facilitate cumulative science: a practical primer for t-tests and ANOVAs. _Frontiers in Psychology, 4_(863). <https://doi.org/10.3389/fpsyg.2013.00863>
- Nelder, J. A., & Mead, R. (1965). A Simplex Method for Function Minimization. _The Computer Journal, 7_(4), 308–313\. <https://doi.org/10.1093/comjnl/7.4.308>
- Searle, S. R. (1971). _Linear Models_. New York: Wiley.
- Smithson, M. (2003). Noncentral Confidence Intervals for Standardized Effect Sizes. In _Confidence Intervals_ (pp. 33–41). Thousand Oaks California: SAGE Publications, Inc. <https://doi.org/10.4135/9781412983761>
- Smithson, M. (2003). Applications in ANOVA and Regression. In _Confidence Intervals_ (pp. 42–66). Thousand Oaks California: SAGE Publications, Inc. <https://doi.org/10.4135/9781412983761.n5>
- Snijders, T. A., & Bosker, R. J. (1994). Modeled Variance in Two-Level Models. _Sociological Methods & Research, 22_(3), 342–363\. <https://doi.org/10.1177/0049124194022003004>
- Ukoumunne, O. C. (2002). A comparison of confidence interval methods for the intraclass correlation coefficient in cluster randomized trials. _Statistics in Medicine, 21_(24), 3757–3774\. <https://doi.org/10.1002/sim.1330>
