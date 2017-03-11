# Cohen's d_s calculator for Independent-samples t test
class CohenDs
  def initialize(independent_samples)
    @inputs = independent_samples.attributes
    # @mean_d = independent_samples.mean_d
    @mean1 = independent_samples.mean1
    @mean2 = independent_samples.mean2
    @sd1 = independent_samples.sd_1.to_f
    @sd2 = independent_samples.sd_2.to_f
    @n1 = independent_samples.n_1.to_f
    @n2 = independent_samples.n_2.to_f
    @conf_int = independent_samples.confidence_interval
  end

  def call
    d_s = cohen_d
    g_s = d_s * j
    @t = calc_t(d_s) # Calculate interval on d not g
    data = ConvertGsToR.new convert_data(g_s)
    npci = non_par_conf_int
    result = warning(
      hedges_gs: g_s, lower_limit_d: npci[:lower], upper_limit_d: npci[:upper],
      r: GsToR.new(data).internal_call, inputs: @inputs
    )
    Oj.dump result
  end

  def non_par_conf_int
    response = HTTParty.post URL, body: {
      ncp: @t, df: @n1 + @n2 - DF - DF, 'conf.level' => @conf_int
    }
    result = Oj.load response.body
    lower = calc_d(result[LL][0])
    upper = calc_d(result[UL][0])
    { lower: lower, upper: upper }
  end

  def cohen_d
    pooled_sd_num = (@n1 - DF) * (@sd1 * @sd1) + (@n2 - DF) * (@sd2 * @sd2)
    pooled_sd_denum = @n1 + @n2 - DF - DF
    pooled_sd = Math.sqrt(pooled_sd_num / pooled_sd_denum)
    (@mean1 - @mean2) / pooled_sd
  end

  def calc_t(d)
    denum = (1 / @n1) + (1 / @n2)
    d / Math.sqrt(denum)
  end

  def calc_d(t)
    denum = (1 / @n1) + (1 / @n2)
    t * Math.sqrt(denum)
  end

  define_method('j') { HedgesCorrection.new(@n1 + @n2, DF + DF).call }

  def convert_data(g_s)
    { g_s: g_s, n1: @n1, n2: @n2 }
  end

  def warning(result)
    warning_message = @t > TNCP_MAX ? WARNING : EMPTY_MESSAGE
    result.merge(warning: warning_message)
  end

  # def se_d(d_s)
  #   a = (@n1 + @n2) / (@n1 * @n2)
  #   b = (d_s * d_s) / (2 * (@n1 + @n2))
  #   v_d = a + b
  #   Math.sqrt(v_d)
  # end
end
