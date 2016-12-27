require 'virtus'
require 'active_model'

# Value object for independent-samples t-tests
class IndependentSamples
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
  validates_numericality_of :n_1, greater_than: 1
  validates_numericality_of :n_2, greater_than: 1

  def mean_d
    mean1 - mean2
  end
end
