# Cohen's d calculator for Independent-samples t test
class IndependentSamplesT
  def initialize(means, sds, ns)
    @mean_1 = means[0]
    @mean_2 = means[1]
    @sd_1 = sds[0]
    @sd_2 = sds[1]
    @n_1 = ns[0]
    @n_2 = ns[1]
  end

  def call
    mean_d = @mean_1 - @mean_2
    pooled_sd_num = (@n_1 - 1) * (@sd_1 ^ 2) + (@n_2 - 1) * (@sd_2 ^ 2)
    pooled_sd_denum = @n_1 + @n_2 - 2
    pooled_sd = Math.sqrt(pooled_sd_num / pooled_sd_denum)
    mean_d / pooled_sd
  end
end
