require 'virtus'
require 'active_model'

# Value object for between subjects d to r conversion
class ConvertDsToR
  include Virtus.model
  include ActiveModel::Validations

  attribute :d_s, Float
  attribute :n1, Float
  attribute :n2, Float

  validates_numericality_of :d_s
  validates_numericality_of :n1, greater_than: 1
  validates_numericality_of :n2, greater_than: 1
end
