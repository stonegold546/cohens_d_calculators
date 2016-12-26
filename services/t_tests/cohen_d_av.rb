# Cohen's d_av calculator for paired t-test (averaging)
class CohenDav
  # def initialize(params, _means, _sds, _ns)
  def initialize(average_samples)
    @inputs = average_samples.attributes
    @mean_d = average_samples.mean_d
    @avg_sd = average_samples.avg_sd
    @n1 = average_samples.n_1
    @n2 = average_samples.n_2
  end

  def call
    d_av = cohen_d
    result = { cohen_dav: d_av, inputs: @inputs }
    return Oj.dump(result) unless @n1 && @n2
    g_av = HedgesCorrection.new(d_av, @n1, @n2).call
    result = { cohen_dav: d_av, hedges_gav: g_av, inputs: @inputs }
    Oj.dump result
  end

  def cohen_d
    @mean_d / @avg_sd
  end
end
