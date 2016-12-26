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
    g_s = HedgesCorrection.new(d_s, @n1, @n2).call
    data = convert_data(d_s)
    data = ConvertDsToR.new(data)
    r = DsToR.new(data).internal_call
    result = { cohen_ds: d_s, hedges_gs: g_s, r: r, inputs: @inputs }
    Oj.dump result
  end

  def cohen_d
    pooled_sd_num = (@n1 - 1) * (@sd1 * @sd1) + (@n2 - 1) * (@sd2 * @sd2)
    pooled_sd_denum = @n1 + @n2 - 2
    pooled_sd = Math.sqrt(pooled_sd_num / pooled_sd_denum)
    @mean_d / pooled_sd
  end

  def convert_data(d_s)
    { d_s: d_s, n1: @n1, n2: @n2 }
  end
end
