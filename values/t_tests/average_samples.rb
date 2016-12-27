require 'virtus'
require 'active_model'

NUM_SDs = 2

# Value object for two-samples t-tests (paired, averages)
class AverageSamples
  include Virtus.model
  include ActiveModel::Validations

  attribute :mean1, Float
  attribute :mean2, Float
  attribute :sd_1, Float
  attribute :sd_2, Float
  attribute :n_1, Float
  attribute :n_2, Float

  validates_numericality_of :mean1
  validates_numericality_of :mean2
  validates_numericality_of :sd_1, greater_than: 0
  validates_numericality_of :sd_2, greater_than: 0
  validates_numericality_of :n_1, greater_than: 1, allow_nil: true
  validates_numericality_of :n_2, greater_than: 1, allow_nil: true

  def mean_d
    mean1 - mean2
  end

  def avg_sd
    (sd_1 + sd_2) / NUM_SDs
  end
end
