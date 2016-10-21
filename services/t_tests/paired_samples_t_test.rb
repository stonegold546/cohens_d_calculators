# FIXME: meta-analysis vs. Lomax
# Cohen's d calculator for Paired-samples t test
class PairedSamplesT
  def initialize(mean_1, mean_2, sd_diff)
    @mean_1 = mean_1
    @mean_2 = mean_2
    @sd_diff = sd_diff
  end

  # Verify paired from meta-analysis.com & Lomax
  # Meta-analysis claims we use r in calculation
  # Lomax claims same as one-sample
  # def call
  #   (@mean_1 - @mean_2) / @sd_diff
  # end
end
