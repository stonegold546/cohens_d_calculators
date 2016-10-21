# Cohen's d calculator for One-sample t test
class OnePairedSampleT
  def initialize(sample_mean, pop_mean, sample_sd)
    @sample_mean = sample_mean
    @pop_mean = pop_mean
    @sample_sd = sample_sd
  end

  def call
    (@sample_mean - @pop_mean) / @sample_sd
  end
end
