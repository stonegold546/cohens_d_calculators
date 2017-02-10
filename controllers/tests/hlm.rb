require 'ap'
require 'classy_hash'

URL_ICC = 'https://public.opencpu.org/ocpu/library/ICC/R/ICCest/json?digits=7'.freeze
CSV_DATA = 1..-1
SCHEMA = {
  filename: String,
  type: %r{text/csv},
  name: String,
  tempfile: Tempfile,
  head: String
}.freeze

# Class for HLM calculators
class CohenDCalc < Sinatra::Base
  icc = lambda do
    hlm_icc = HlmIcc.new(params)
    halt 400 unless hlm_icc.valid?
    begin ClassyHash.validate(hlm_icc.icc_file, SCHEMA)
    rescue
      halt 400
    end
    result = Icc.new(hlm_icc)
    result.call
  end

  post '/icc/?', &icc
end
