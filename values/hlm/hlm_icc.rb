require 'virtus'
require 'active_model'

# Value object for ICC (HLM)
class HlmIcc
  include Virtus.model
  include ActiveModel::Validations

  attribute :icc_file, Hash
  attribute :method, String

  validates :icc_file, presence: true
  validates_inclusion_of :method, in: %w(ANOVA TRUE FALSE)
end
