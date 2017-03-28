require 'virtus'
require 'active_model'

# Value object for R-squared (HLM)
class HlmRsquaredParse
  include Virtus.model
  include ActiveModel::Validations

  attribute :file_r2, Hash

  validates :file_r2, presence: true
end
