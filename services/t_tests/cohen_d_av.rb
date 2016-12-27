# Cohen's d_av calculator for paired t-test (averaging)
class CohenDav
  def initialize(average_samples)
    @inputs = average_samples.attributes
    @mean_d = average_samples.mean_d.to_f
    @avg_sd = average_samples.avg_sd.to_f
    @n1 = average_samples.n_1.to_f
    @n2 = average_samples.n_2.to_f
  end

  def call
    d_av = cohen_d
    result = { cohen_dav: d_av, inputs: @inputs }
    return Oj.dump(result) if @n1.zero? || @n2.zero?
    g_av = d_av * HedgesCorrection.new(@n1, @n2).call
    result = { cohen_dav: d_av, hedges_gav: g_av, inputs: @inputs }
    Oj.dump result
  end

  def cohen_d
    @mean_d / @avg_sd
  end
end
