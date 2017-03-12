DIGITS = '/?digits=7'.freeze

require 'virtus'
require 'active_model'

# Value object for odds
class Odds
  include Virtus.model
  include ActiveModel::Validations

  attribute :treat_1, Float
  attribute :treat_0, Float
  attribute :control_1, Float
  attribute :control_0, Float
  attribute :conf_int, Float
  attribute :method, String

  validates_numericality_of :treat_1, greater_than: 0
  validates_numericality_of :treat_0, greater_than: 0
  validates_numericality_of :control_1, greater_than: 0
  validates_numericality_of :control_0, greater_than: 0
  validates_inclusion_of :method, in: %w(midp fisher wald small)
  validates_numericality_of :conf_int, greater_than: 0, less_than: 100

  def confidence_interval
    conf_int / 100.0
  end

  def odds_vector
    [treat_1, treat_0, control_1, control_0].to_s
  end

  def method_url
    "#{URL_ODDS_CI}#{method}#{DIGITS}"
  end
end
