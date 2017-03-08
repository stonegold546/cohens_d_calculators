require 'ap'

URL_ODDS_CI = 'https://public.opencpu.org/ocpu/library/MCMCpack/R/dnoncenhypergeom/json?digits=7'.freeze

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
