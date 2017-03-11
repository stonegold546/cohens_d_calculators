require 'virtus'
require 'active_model'

# Value object for R^2 (OLS)
class Regression
  include Virtus.model
  include ActiveModel::Validations

  attribute :r2, Float
  attribute :df_1, Float
  attribute :df_2, Float
  attribute :conf_int, Float

  validates_numericality_of :r2, greater_than: 0, less_than: 1
  validates_numericality_of :df_1, greater_than: 0
  validates_numericality_of :df_2, greater_than: 1
  validates_numericality_of :conf_int, greater_than: 0, less_than: 100

  def confidence_interval
    conf_int / 100.0
  end
end
