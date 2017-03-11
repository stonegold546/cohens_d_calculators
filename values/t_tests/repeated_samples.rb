require 'virtus'
require 'active_model'

# Value object for two-samples t-tests (repeated measures)
class RepeatedSamples
  include Virtus.model
  include ActiveModel::Validations

  attribute :mean1, Float
  attribute :mean2, Float
  attribute :sd_1, Float
  attribute :sd_2, Float
  attribute :r, Float
  attribute :n_pairs, Float
  attribute :conf_int, Float

  validates_numericality_of :mean1
  validates_numericality_of :mean2
  validates_numericality_of :sd_1, greater_than: 0
  validates_numericality_of :sd_2, greater_than: 0
  validates_numericality_of :r, greater_than_or_equal_to: -1,
                                less_than_or_equal_to: 1
  validates_numericality_of :n_pairs, greater_than: 1
  validates_numericality_of :conf_int, greater_than: 0, less_than: 100

  def mean_d
    mean1.to_f - mean2.to_f
  end

  def confidence_interval
    conf_int / 100.0
  end
end
