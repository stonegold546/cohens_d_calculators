require 'ap'

URL_ICC = 'https://public.opencpu.org/ocpu/library/ICC/R/ICCest/json?digits=7'.freeze
CSV_DATA = 1..-1

# Class for ANOVA calculators
class CohenDCalc < Sinatra::Base
  icc = lambda do
    hlm_icc = HlmIcc.new(params)
    halt 400 unless hlm_icc.valid?
    result = Icc.new(hlm_icc)
    result.call
  end

  post '/icc/?', &icc
end
