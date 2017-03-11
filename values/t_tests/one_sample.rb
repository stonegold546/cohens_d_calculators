require 'virtus'
require 'active_model'

# Value object for one-sample t-tests
class OneSample
  include Virtus.model
  include ActiveModel::Validations

  attribute :sample_mean, Float
  attribute :pop_mean, Float
  attribute :sample_sd, Float
  attribute :n, Float
  attribute :conf_int, Float

  validates_numericality_of :sample_mean
  validates_numericality_of :pop_mean
  validates_numericality_of :sample_sd, greater_than: 0
  validates_numericality_of :n, greater_than: 1, allow_nil: true
  validates_numericality_of :conf_int, greater_than: 0, less_than: 100,
                                       allow_nil: true
end
