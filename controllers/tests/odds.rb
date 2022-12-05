require 'ap'

URL_ODDS_CI = 'http://stonegold546.ocpu.io/epitools/R/oddsratio.'.freeze
URL_RISK_CI = 'http://stonegold546.ocpu.io/epitools/R/riskratio.'.freeze
MEASURE_EXTRACT = 'measure'.freeze

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
