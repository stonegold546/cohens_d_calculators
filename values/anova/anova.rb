require 'virtus'
require 'active_model'

# Value object for partial eta-squared (ANOVA)
class Anova
  include Virtus.model
  include ActiveModel::Validations

  attribute :f, Float
  attribute :df_effect, Float
  attribute :df_error, Float
  attribute :conf_int, Float

  validates_numericality_of :f, greater_than: 0
  validates_numericality_of :df_effect, greater_than: 0
  validates_numericality_of :df_error, greater_than: 1
  validates_numericality_of :conf_int, greater_than: 0, less_than: 100

  def confidence_interval
    conf_int / 100.0
  end
end
