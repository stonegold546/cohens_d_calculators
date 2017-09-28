require 'virtus'
require 'active_model'
require 'yaml'

# Array coercion
class StringArray < Virtus::Attribute
  def coerce(value)
    YAML.load value
  end
end

# Value object for ICC (HLM)
class HlmIcc
  include Virtus.model
  include ActiveModel::Validations

  attribute :icc_file, Hash
  attribute :method, String
  attribute :data, StringArray
  attribute :clusterVar, String
  attribute :outcomeVar, String
  attribute :channelVar, String

  validates :icc_file, presence: true
  validates_inclusion_of :method, in: %w(ANOVA TRUE FALSE)
  validates_inclusion_of :clusterVar, in: :data
  validates_inclusion_of :outcomeVar, in: :data
end
