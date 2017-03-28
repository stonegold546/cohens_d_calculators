require 'oj'
require 'virtus'
require 'active_model'
require 'yaml'

# JSON coercion
class StringHash < Virtus::Attribute
  def coerce(value)
    Oj.load value
  end
end

# Array coercion
class StringArray < Virtus::Attribute
  def coerce(value)
    YAML.load value
  end
end

# Value object for R-squared (HLM)
class HlmRsquared
  include Virtus.model
  include ActiveModel::Validations

  attribute :file_r2, Hash
  attribute :method, Integer
  attribute :clusterVar, String
  attribute :outcomeVar, String
  attribute :interceptPredictors, StringArray
  attribute :levelOneHash, StringHash
  attribute :data, StringArray

  validates :file_r2, presence: true
  validates_inclusion_of :method, in: (0..3).to_a
  validates_inclusion_of :clusterVar, in: :data
  validates_inclusion_of :outcomeVar, in: :data
end
