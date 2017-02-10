require 'virtus'
require 'active_model'

# Value object for ICC (HLM)
class HlmIcc
  include Virtus.model
  include ActiveModel::Validations

  attribute :icc_file, Hash

  validates :icc_file, presence: true
end
