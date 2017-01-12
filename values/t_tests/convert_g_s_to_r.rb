require 'virtus'
require 'active_model'

# Value object for between subjects g to r conversion
class ConvertGsToR
  include Virtus.model
  include ActiveModel::Validations

  attribute :g_s, Float
  attribute :n1, Float
  attribute :n2, Float

  validates_numericality_of :g_s
  validates_numericality_of :n1, greater_than: 1
  validates_numericality_of :n2, greater_than: 1
end
