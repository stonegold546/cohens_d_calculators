NUM_SDS = 2

# Cohen's d_av calculator for paired t-test (averaging)
class CohenDav
  def initialize(average_samples)
    @inputs = average_samples.attributes
    @mean_d = average_samples.mean_d.to_f
    @sd1 = average_samples.sd_1.to_f
    @sd2 = average_samples.sd_2.to_f
    @n_pairs = average_samples.n_pairs.to_f
  end

  def call
    d_av = cohen_d
    result = { cohen_dav: d_av, inputs: @inputs }
    return Oj.dump(result) if @n_pairs.zero?
    g_av = d_av * HedgesCorrection.new(@n_pairs, DF).call
    result = { cohen_dav: d_av, hedges_gav: g_av, inputs: @inputs }
    Oj.dump result
  end

  def cohen_d
    @mean_d / avg_sd
  end

  def avg_sd
    numerator = (@sd1 * @sd1 + @sd2 * @sd2)
    Math.sqrt(numerator / NUM_SDS)
  end
end
