# Cohen's d_rm calculator for repreated measures t-test
class CohenDrm
  def initialize(repeated_samples)
    @inputs = repeated_samples.attributes
    @mean_d = repeated_samples.mean_d
    @sd1 = repeated_samples.sd_1.to_f
    @sd2 = repeated_samples.sd_2.to_f
    @r = repeated_samples.r.to_f
    @n_pairs = repeated_samples.n_pairs.to_f
  end

  def call
    d_rm = cohen_d
    result = { cohen_drm: d_rm, inputs: @inputs }
    return Oj.dump(result) if @n_pairs.zero?
    g_rm = d_rm * HedgesCorrection.new(@n_pairs, DF).call
    result = { cohen_drm: d_rm, hedges_grm: g_rm, inputs: @inputs }
    Oj.dump result
  end

  def cohen_d
    base = Math.sqrt(@sd1 * @sd1 + @sd2 * @sd2 - 2 * @r * @sd1 * @sd2)
    standardization = Math.sqrt(2 * (1 - @r))
    @mean_d * standardization / base
  end
end
