require 'virtus'
require 'active_model'

# Value object for partial eta-squared (ANOVA)
class Regression
  include Virtus.model
  include ActiveModel::Validations

  attribute :r2, Float
  attribute :df_1, Float
  attribute :df_2, Float

  validates_numericality_of :r2, greater_than: 0
  validates_numericality_of :df_1, greater_than: 0
  validates_numericality_of :df_2, greater_than: 1
end
