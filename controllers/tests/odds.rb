require 'ap'

URL_ODDS_CI = 'https://stonegold546.ocpu.io/epitools/R/oddsratio.'.freeze
URL_RISK_CI = 'https://stonegold546.ocpu.io/epitools/R/riskratio.'.freeze
URL_WITH = 'https://public.opencpu.org/ocpu/library/base/R/with/json?digits=7'.freeze

# Class for Odds-Ratio calculators
class CohenDCalc < Sinatra::Base
  odds_lamb = lambda do
    odds = Odds.new(params)
    halt 400, odds.errors.messages.to_s unless odds.valid?
    result = OddsRatio.new(odds)
    result.call
  end

  get '/odds/?', &odds_lamb
end
