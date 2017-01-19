# Cohen's d_rm calculator for repreated measures t-test
class CohenDrm
  def initialize(repeated_samples)
    @inputs = repeated_samples.attributes
    @mean_d = repeated_samples.mean_d
    @sd1 = repeated_samples.sd_1.to_f
    @sd2 = repeated_samples.sd_2.to_f
    @r = repeated_samples.r.to_f
    @n_pairs = repeated_samples.n_pairs.to_f
    @cov = cov
    @t = calc_t
  end

  def call
    d_rm = cohen_d
    # result = { cohen_drm: d_rm, inputs: @inputs }
    # return Oj.dump(result) if @n_pairs.zero?
    g_rm = d_rm * HedgesCorrection.new(@n_pairs, DF).call
    npci = non_par_conf_int
    result = warning(
      lower_limit_d: npci[:lower], upper_limit_d: npci[:upper],
      hedges_grm: g_rm, inputs: @inputs
    )
    Oj.dump result
  end

  def non_par_conf_int
    response = HTTParty.post URL, body: { ncp: @t, df: @n_pairs - DF }
    result = Oj.load response.body
    lower = calc_d(result[LL][0])
    upper = calc_d(result[UL][0])
    { lower: lower, upper: upper }
  end

  def cohen_d
    base = Math.sqrt(@sd1 * @sd1 + @sd2 * @sd2 - 2 * @r * @sd1 * @sd2)
    standardization = Math.sqrt(2 * (1 - @r))
    @mean_d * standardization / base
  end

  def calc_t
    t_denum = (@sd1 * @sd1 + @sd2 * @sd2 - 2 * @cov) / @n_pairs
    t_denum = Math.sqrt t_denum
    @mean_d / t_denum
  end

  def calc_d(t)
    num = 2 * (@sd1 * @sd1 + @sd2 * @sd2 - 2 * @cov)
    denum = @n_pairs * (@sd1 * @sd1 + @sd2 * @sd2)
    t * Math.sqrt(num / denum)
  end

  def cov
    @r * @sd1 * @sd2
  end

  def warning(result)
    warning_message = @t > TNCP_MAX ? WARNING : EMPTY_MESSAGE
    result.merge(warning: warning_message)
  end
end
