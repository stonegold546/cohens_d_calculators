require(lme4)
mymod <- function(x, y) {
  result <- lmer(y ~ 1 + (1 | x), REML = FALSE)
  sumy <- summary(result)
  varb <- sumy$varcor$x[1]
  varw <- sumy$sigma ^ 2
  icc <- varb / (varb + varw)
  c(icc, varb, varw)
}
mymod(x, y)
