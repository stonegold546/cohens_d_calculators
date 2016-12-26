require 'virtus'
require 'active_model'

# Value object for one-sample t-tests
class OneSample
  include Virtus.model
  include ActiveModel::Validations

  attribute :sample_mean, Float
  attribute :pop_mean, Float
  attribute :sample_sd, Float

  validates_numericality_of :sample_mean
  validates_numericality_of :pop_mean
  validates_numericality_of :sample_sd, greater_than: 0
end
