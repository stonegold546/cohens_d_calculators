require 'virtus'
require 'active_model'

# Value object for partial eta-squared (ANOVA)
class HlmIcc
  include Virtus.model
  include ActiveModel::Validations

  attribute :file
  # attribute :icc, Float
  # attribute :n_level_one, Integer
  # attribute :n_level_two, Integer
  #
  # validates_numericality_of :icc, greater_than: 0, less_than: 1
  # validates_numericality_of :n_level_one, greater_than: 2
  # validates_numericality_of :n_level_two, greater_than: 2
end
