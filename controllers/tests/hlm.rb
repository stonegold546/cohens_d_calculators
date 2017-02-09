FILE_STRING = 0
CSV_TEXT = 3
URL_ICC = 'https://public.opencpu.org/ocpu/library/ICC/R/ICCest/json'.freeze
CSV_DATA = 1..-1

# Class for ANOVA calculators
class CohenDCalc < Sinatra::Base
  icc = lambda do
    result = Icc.new(params)
    result.call
  end

  post '/icc/?', &icc
end
