# Cohen's d_rm calculator for repreated measures t-test
class CohenDrm
  def initialize(params)
    @means = [params['mean_1'], params['mean_2']].map(&:to_f)
    @sd1 = params['sd_1'].to_f
    @sd2 = params['sd_2'].to_f
    @r = params['r'].to_f
    return unless params['n_1'] && params['n_2']
    @n1 = params['n_1'].to_f
    @n2 = params['n_2'].to_f
  end

  def call
    d_rm = cohen_d
    return Oj.dump(cohen_drm: d_rm) unless @n1 && @n2
    g_rm = HedgesCorrection.new(d_rm, @n1, @n2).call
    Oj.dump(cohen_drm: d_rm, hedges_grm: g_rm)
  end

  def cohen_d
    base = Math.sqrt(@sd1 * @sd1 + @sd2 * @sd2 - 2 * @r * @sd1 * @sd2)
    standardization = Math.sqrt(2 * (1 - @r))
    @means.reduce(:-) * standardization / base
  end
end
