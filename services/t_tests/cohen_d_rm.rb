# Cohen's d_rm calculator for repreated measures t-test
class CohenDrm
  def initialize(repeated_samples)
    @inputs = repeated_samples.attributes
    @mean_d = repeated_samples.mean_d
    @sd1 = repeated_samples.sd_1.to_f
    @sd2 = repeated_samples.sd_2.to_f
    @r = repeated_samples.r.to_f
    @n1 = repeated_samples.n_1.to_f
    @n2 = repeated_samples.n_2.to_f
  end

  def call
    d_rm = cohen_d
    result = { cohen_drm: d_rm, inputs: @inputs }
    return Oj.dump(result) if @n1.zero? || @n2.zero?
    g_rm = d_rm * HedgesCorrection.new(min(@n1, @n2), DF).call
    result = { cohen_drm: d_rm, hedges_grm: g_rm, inputs: @inputs }
    Oj.dump result
  end

  def cohen_d
    base = Math.sqrt(@sd1 * @sd1 + @sd2 * @sd2 - 2 * @r * @sd1 * @sd2)
    standardization = Math.sqrt(2 * (1 - @r))
    @mean_d * standardization / base
  end

  def min(a, b)
    [a, b].minmax[MIN]
  end
end
