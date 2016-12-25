# Cohen's d_s calculator for Independent-samples t test
class CohenDs
  def initialize(means, sds, ns)
    @means = means.map(&:to_f)
    @sd1 = sds[0].to_f
    @sd2 = sds[1].to_f
    @n1 = ns[0].to_f
    @n2 = ns[1].to_f
  end

  def call
    d_s = cohen_d
    g_s = HedgesCorrection.new(d_s, @n1, @n2).call
    Oj.dump(cohen_ds: d_s, hedges_gs: g_s)
  end

  def cohen_d
    pooled_sd_num = (@n1 - 1) * (@sd1 * @sd1) + (@n2 - 1) * (@sd2 * @sd2)
    pooled_sd_denum = @n1 + @n2 - 2
    pooled_sd = Math.sqrt(pooled_sd_num / pooled_sd_denum)
    @means.reduce(:-) / pooled_sd
  end
end
