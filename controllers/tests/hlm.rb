require 'ap'
require 'classy_hash'

URL_ICC_ANOVA = 'https://public.opencpu.org/ocpu/library/ICC/R/ICCest/json?digits=7'.freeze
URL_ICC_LMER = 'https://public.opencpu.org/ocpu/library/lme4/R/lmer/?digits=7'.freeze
URL_ICC_DATA_FRAME = 'https://public.opencpu.org/ocpu/library/base/R/data.frame/?digits=7'.freeze
URL_SUMMARY = 'https://public.opencpu.org/ocpu/library/base/R/summary/?digits=7'.freeze
URL_WITH = 'https://public.opencpu.org/ocpu/library/base/R/with/json?digits=11'.freeze

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
    halt 400, hlm_icc.errors.messages.to_s unless hlm_icc.valid?
    begin ClassyHash.validate(hlm_icc.icc_file, SCHEMA)
    rescue => e
      halt 400, e.message
    end
    result = Icc.new(hlm_icc)
    result.call
  end

  post '/icc/?', &icc
end
