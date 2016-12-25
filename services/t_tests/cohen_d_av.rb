# Cohen's d_av calculator for paired t-test (averaging)
class CohenDav
  # def initialize(params, _means, _sds, _ns)
  def initialize(params)
    @means = [params['mean_1'], params['mean_2']].map(&:to_f)
    @sds = [params['sd_1'], params['sd_2']].map(&:to_f)
    return unless params['n_1'] && params['n_2']
    @n1 = params['n_1'].to_f
    @n2 = params['n_2'].to_f
  end

  def call
    d_av = cohen_d
    return Oj.dump(cohen_dav: d_av) unless @n1 && @n2
    g_av = HedgesCorrection.new(d_av, @n1, @n2).call
    Oj.dump(cohen_dav: d_av, hedges_gav: g_av)
  end

  def cohen_d
    base = @sds.reduce(:+) / @sds.size
    @means.reduce(:-) / base
  end
end
