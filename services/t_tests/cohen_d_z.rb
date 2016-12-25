# Cohen's d calculator for One-sample t test
class CohenDz
  def initialize(sample_mean, pop_mean, sample_sd)
    @sample_mean = sample_mean.to_f
    @pop_mean = pop_mean.to_f
    @sample_sd = sample_sd.to_f
  end

  def call
    cohen_dz = (@sample_mean - @pop_mean) / @sample_sd
    Oj.dump(cohen_dz: cohen_dz)
  end
end
