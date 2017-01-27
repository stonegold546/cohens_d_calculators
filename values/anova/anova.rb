require 'virtus'
require 'active_model'

# Value object for partial eta-squared (ANOVA)
class Anova
  include Virtus.model
  include ActiveModel::Validations

  attribute :f, Float
  attribute :df_effect, Float
  attribute :df_error, Float

  validates_numericality_of :f, greater_than: 0
  validates_numericality_of :df_effect, greater_than: 0
  validates_numericality_of :df_error, greater_than: 1
end
