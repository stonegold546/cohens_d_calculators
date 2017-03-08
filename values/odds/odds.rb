require 'virtus'
require 'active_model'

# Value object for odds
class Odds
  include Virtus.model
  include ActiveModel::Validations

  attribute :tyoy, Float
  attribute :tyon, Float
  attribute :cyoy, Float
  attribute :cyon, Float

  validates_numericality_of :tyoy, greater_than: 0
  validates_numericality_of :tyon, greater_than: 0
  validates_numericality_of :cyoy, greater_than: 0
  validates_numericality_of :cyon, greater_than: 0
end
