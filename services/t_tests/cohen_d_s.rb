# Cohen's d_s calculator for Independent-samples t test
class CohenDs
  def initialize(independent_samples)
    @inputs = independent_samples.attributes
    @mean_d = independent_samples.mean_d
    @sd1 = independent_samples.sd_1
    @sd2 = independent_samples.sd_2
    @n1 = independent_samples.n_1
    @n2 = independent_samples.n_2
  end

  def call
    d_s = cohen_d
    se_d_s = se_d(d_s)
    g_s = d_s * j
    se_g_s = se_d_s * j
    data = convert_data(d_s)
    data = ConvertDsToR.new(data)
    Oj.dump(
      cohen_ds: d_s, se_d: se_d_s, hedges_gs: g_s, se_g: se_g_s,
      r: DsToR.new(data).internal_call, inputs: @inputs
    )
  end

  def cohen_d
    pooled_sd_num = (@n1 - 1) * (@sd1 * @sd1) + (@n2 - 1) * (@sd2 * @sd2)
    pooled_sd_denum = @n1 + @n2 - 2
    pooled_sd = Math.sqrt(pooled_sd_num / pooled_sd_denum)
    @mean_d / pooled_sd
  end

  def se_d(d_s)
    a = (@n1 + @n2) / (@n1 * @n2)
    b = (d_s * d_s) / (2 * (@n1 + @n2))
    v_d = a + b
    Math.sqrt(v_d)
  end

  define_method('j') { HedgesCorrection.new(@n1, @n2).call }

  def convert_data(d_s)
    { d_s: d_s, n1: @n1, n2: @n2 }
  end
end
