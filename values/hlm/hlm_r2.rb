require 'virtus'
require 'active_model'

# Value object for R-squared (HLM)
class HlmRsquared
  include Virtus.model
  include ActiveModel::Validations

  attribute :file_r2, Hash
  # attribute :method, String

  validates :file_r2, presence: true
  # validates_inclusion_of :method, in: %w(TRUE FALSE)
end
