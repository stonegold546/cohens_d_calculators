# Calculator for partial-eta-squared
class PartialEtaSq
  def initialize(anova)
    @inputs = anova.attributes
    @f = anova.f
    @df_error = anova.df_error
    @df_effect = anova.df_effect
    @conf_int = anova.confidence_interval
  end

  def call
    partial_eta_sq = calc_eta(@f)
    npci = non_par_conf_int
    result = {
      partial_eta_sq: partial_eta_sq, partial_ome_sq: partial_ome_sq,
      lower_limit_eta: npci[:lower], upper_limit_eta: npci[:upper],
      inputs: @inputs
    }
    result.merge! cohens_f(result[:partial_ome_sq], result[:lower_limit_eta],
                           result[:upper_limit_eta])
    result.map { |k, v| result[k] = v.is_a?(Numeric) ? v.round(7) : v }
    Oj.dump result
  end

  def partial_ome_sq
    # Left censor partial omega-sq at zero
    num = @f >= 1 ? @f - 1 : 0
    denum = @f + ((@df_error + 1) / @df_effect)
    num / denum
  end

  def non_par_conf_int
    response = HTTParty.post URL_F, body: {
      'F.value' => @f, 'conf.level' => @conf_int,
      'df.1' => @df_effect, 'df.2' => @df_error
    }
    result = Oj.load response.body
    lower = calc_non_cent_eta(result[LL_F][0])
    upper = calc_non_cent_eta(result[UL_F][0])
    { lower: lower, upper: upper }
  end

  def calc_non_cent_eta(non_cent_par)
    non_cent_par = 0 if non_cent_par == 'NA' || non_cent_par.nil?
    denum = non_cent_par + @df_effect + @df_error + DF_F
    non_cent_par / denum
  end

  def calc_eta(f)
    f_df = f * @df_effect
    f_df / (f_df + @df_error)
  end

  def cohens_f(p_ome_sq, p_eta_ll, p_eta_ul)
    { cohens_f: Math.sqrt(p_ome_sq / (1 - p_ome_sq)),
      lower_limit_cohens_f: Math.sqrt(p_eta_ll / (1 - p_eta_ll)),
      upper_limit_cohens_f: Math.sqrt(p_eta_ul / (1 - p_eta_ul)) }
  end
end
