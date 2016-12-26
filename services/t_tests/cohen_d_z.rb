# Cohen's d calculator for One-sample t test
class CohenDz
  def initialize(one_sample)
    @inputs = one_sample.attributes
    @sample_mean = one_sample.sample_mean
    @pop_mean = one_sample.pop_mean
    @sample_sd = one_sample.sample_sd
  end

  def call
    cohen_dz = (@sample_mean - @pop_mean) / @sample_sd
    result = { cohen_dz: cohen_dz, inputs: @inputs }
    Oj.dump result
  end
end
