# Calculator for partial-eta-squared
class PartialEtaSq
  def initialize(anova)
    @inputs = anova.attributes
    @f = anova.f
    @df_error = anova.df_error
    @df_effect = anova.df_effect
  end

  def call
    partial_eta_sq = calc_eta(@f)
    npci = non_par_conf_int
    result = {
      partial_eta_sq: partial_eta_sq, lower_limit_eta: npci[:lower],
      upper_limit_eta: npci[:upper], inputs: @inputs
    }
    Oj.dump result
  end

  def non_par_conf_int
    response = HTTParty.post URL_F, body: {
      'F.value' => @f, 'conf.level' => CONFINT_F,
      'df.1' => @df_effect, 'df.2' => @df_error
    }
    result = Oj.load response.body
    lower = calc_non_cent_eta(result[LL_F][0])
    upper = calc_non_cent_eta(result[UL_F][0])
    { lower: lower, upper: upper }
  end

  def calc_non_cent_eta(lambda)
    denum = lambda + @df_effect + @df_error + DF_F
    lambda / denum
  end

  def calc_eta(f)
    f_df = f * @df_effect
    f_df / (f_df + @df_error)
  end
end
