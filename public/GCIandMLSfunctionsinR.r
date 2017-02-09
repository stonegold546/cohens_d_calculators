get_gci_fcn <- function(mymeansqsvec, MC = 100000, B, L, R, alpha = 0.05) {

  # Precondition:  mymeansqsvec is a vector of mean squares from
  #                the ANOVA fit of a two-way crossed models.  B>2
  #                is the number of levels of the first factor and
  #                L>2 is the number of levels of the second factor and
  #                R>0 is the number of replicates per cell.  A two-way
  #                balanced layout without interaction is assumed.
  #                MC is the number of Monte Carlo used to construct the
  #                GCI, with default one-hundred thousand.
  #
  # Postcondition: The returned vector contains the upper and lower
  #                limits of a (1-alpha)*100% confidence interval.

  bioloms <- mymeansqsvec[1];
  labpms <- mymeansqsvec[2];
  errorems <- mymeansqsvec[3];

  W11 <- rchisq(MC, df = L - 1);
  W21 <- rchisq(MC, df = B - 1);
  W31 <- rchisq(MC, L * B * R - B - L + 1);

  piv_q_sosq <- rep(NA, MC);
  piv_q_gamy <- rep(NA, MC);
  for (m in 1:MC) {
  piv_q_sosq[m] <- max(c(0, (B - 1) * bioloms / (L * R * W21[m]) -
    (L * B * R - L - B + 1) * errorems / (L * R * W31[m])));
  piv_q_gamy[m] <-
    (L - 1) * labpms / (B * R * W11[m]) +
    (B - 1) * bioloms / (L * R * W21[m]) +
    (B * L * R - B - L) * (B * L * R - B - L + 1) *
    errorems / (B * L * R * W31[m]);
  }

  piv_q_icc <- piv_q_sosq / piv_q_gamy;

  lower <- quantile(piv_q_icc, alpha / 2);
  upper <- quantile(piv_q_icc, 1 - alpha / 2);

  c(lower, upper);
}





# Precondition:  mymeansqsvec is a vector of mean squares from
#                the ANOVA fit of a two-way crossed models.  B>2
#                is the number of levels of the first factor and
#                L>2 is the number of levels of the second factor and
#                R>0 is the number of replicates per cell.  A two-way
#                balanced layout without interaction is assumed.
#                type is a type of a confidence interval to be constructed.
#
# Postcondition: The returned list contains the upper and lower
#                limits of a (1-alpha)*100% confidence interval and an estimated ICC.


get_mls_ci <- function(mymeansqsvec, B, L, alpha = 0.05, type = "two.sided") {

  MS <- mymeansqsvec
  S12 <- MS[1]  # mean square subject
  S22 <- MS[2]  # mean square rater
  S32 <- MS[3]  # mean square residual error
  df1 <- B - 1  # df for subject
  df2 <- L - 1  # df for rater
  df3 <- df1 * df2  # df for residual error
  d2 <- (df2 + 1) / (df1 + 1)
  d3 <- (df2 + 1) - 1 - d2

  # calculate estimated ICC (NOTE: the answer is the same as what REML
  # => produces in lmer)
  est.icc <- (S12 - S32) / (S12 + d2 * S22 + d3 * S32)

  if (type == "two.sided"){
    alpha <- alpha / 2
  } else {
    alpha <- alpha
  }

  # calculate quantities in the Appendix of Cappelleri & Ting
  H1 <- (1 / qf(alpha, df1, Inf)) - 1
  H2 <- (1 / qf(alpha, df2, Inf)) - 1
  H3 <- (1 / qf(alpha, df3, Inf)) - 1
  G1 <- 1 - (1 / qf(1 - alpha, df1, Inf))
  G2 <- 1 - (1 / qf(1 - alpha, df2, Inf))
  G3 <- 1 - (1 / qf(1 - alpha, df3, Inf))
  H12 <- ( (1 - qf(alpha, df1, df2)) ^ 2 -
    (H1 * qf(alpha, df1, df2)) ^ 2 - G2 ^ 2) /
    (qf(alpha, df1, df2))
  H13 <- ( (1 - qf(alpha, df1, df3)) ^ 2 -
    (H1 * qf(alpha, df1, df3)) ^ 2 - G3 ^ 2) /
    (qf(alpha, df1, df3))
  G12 <- ( (qf(1 - alpha, df1, df2) - 1) ^ 2 -
    (G1 * qf(1 - alpha, df1, df2)) ^ 2 - H2 ^ 2) /
    (qf(1 - alpha, df1, df2))
  G13 <- ( (qf(1 - alpha, df1, df3) - 1) ^ 2 -
    (G1 * qf(1 - alpha, df1, df3)) ^ 2 - H3 ^ 2) /
    (qf(1 - alpha, df1, df3))

  # 100(1-alpha) per cent upper confidence limit U
  Au <- (1 - H1 ^ 2) * (S12 ^ 2) + (1 - G2 ^ 2) * (d2 ^ 2) * (S22 ^ 2) +
    (1 - G3 ^ 2) * (d3 ^ 2) * (S32 ^ 2) + (2 + H12) * d2 * S12 * S22 +
    (2 + H13) * d3 * S12 * S32 + 2 * d2 * d3 * S22 * S32
  Bu <- (-2) * (1 - H1 ^ 2) * (S12 ^ 2) + 2 * (1 - G3 ^ 2) * d3 * (S32 ^ 2) -
    (2 + H12) * d2 * S12 * S22 - (2 + H13) * (d3 - 1) * S12 * S32 +
    2 * d2 * S22 * S32
  Cu <- (1 - H1 ^ 2) * (S12 ^ 2) + (1 - G3 ^ 2) * (S32 ^ 2) -
    (2 + H13) * S12 * S32
  Q1 <- max(0, (Bu ^ 2 - 4 * Au * Cu))
  U <- (-Bu + sqrt(Q1)) / (2 * Au)

  # 100(1-alpha) per cent lower confidence limit L
  Al <- (1 - G1 ^ 2) * (S12 ^ 2) + (1 - H2 ^ 2) * (d2 ^ 2) * (S22 ^ 2) +
    (1 - H3 ^ 2) * (d3 ^ 2) * (S32 ^ 2) + (2 + G12) * d2 * S12 * S22 +
    (2 + G13) * d3 * S12 * S32 + 2 * d2 * d3 * S22 * S32
  Bl <- (-2) * (1 - G1 ^ 2) * (S12 ^ 2) + 2 * (1 - H3 ^ 2) * d3 * (S32 ^ 2) -
    (2 + G12) * d2 * S12 * S22 - (2 + G13) * (d3 - 1) * S12 * S32 +
    2 * d2 * S22 * S32
  Cl <- (1 - G1 ^ 2) * (S12 ^ 2) + (1 - H3 ^ 2) * (S32 ^ 2) -
    (2 + G13) * S12 * S32
  Q2 <- max(0, (Bl ^ 2 - 4 * Al * Cl))
  L <- (-Bl - sqrt(Q2)) / (2 * Al)

  if (type == "two.sided"){
    out <- list(ICCest = est.icc, upper = U, lower = L)
  } else if (type == "upper"){
    out <- list(ICCest = est.icc, upper = U, lower = 0)
  } else {
    out <- list(ICCest = est.icc, lower = L, upper = 1)
  }
  return(out)

} # End get_mls_ci

# Example
MS <- c(3.78083676, 2.67991697, 0.08182255)
get_mls_ci(mymeansqsvec = MS, B = 24, L = 6)
get_gci_fcn(mymeansqsvec = MS, B = 24, L = 6, R = 1)
