require 'ap'
require 'classy_hash'

# URL_ICC_ANOVA = 'https://public.opencpu.org/ocpu/library/ICC/R/ICCest/json?digits=7'.freeze
# URL_ICC_LMER = 'https://public.opencpu.org/ocpu/library/lme4/R/lmer/?digits=7'.freeze
# URL_ICC_DATA_FRAME = 'https://public.opencpu.org/ocpu/library/base/R/data.frame/?digits=7'.freeze
# URL_SUMMARY = 'https://public.opencpu.org/ocpu/library/base/R/summary/?digits=7'.freeze
# URL_WITH = 'https://public.opencpu.org/ocpu/library/base/R/with/json?digits=11'.freeze

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
    begin File.readlines(hlm_icc.icc_file[:tempfile]).grep(/monitor/)
    rescue
      halt 400, 'Your file is probably not a CSV file.'
    end
    begin ClassyHash.validate(hlm_icc.icc_file, SCHEMA)
    rescue => e
      halt 400, e.message
    end
    result = Icc.new(hlm_icc)
    result.call
  end

  hlm_r2_parser = lambda do
    hlm_r2_parse = HlmRsquaredParse.new(params)
    halt 400, hlm_r2_parse.errors.messages.to_s unless hlm_r2_parse.valid?
    begin File.readlines(hlm_r2_parse.file_r2[:tempfile]).grep(/monitor/)
    rescue
      halt 400, 'Your file is probably not a CSV file.'
    end
    begin ClassyHash.validate(hlm_r2_parse.file_r2, SCHEMA)
    rescue => e
      halt 400, e.message
    end
    result = R2Parse.new(hlm_r2_parse)
    result.call
  end

  hlm_r2_lambda = lambda do
    hlm_r2 = HlmRsquared.new(params)
    halt 400, hlm_r2.errors.messages.to_s unless hlm_r2.valid?
    begin File.readlines(hlm_r2.file_r2[:tempfile]).grep(/monitor/)
    rescue
      halt 400, 'Your file is probably not a CSV file.'
    end
    begin ClassyHash.validate(hlm_r2.file_r2, SCHEMA)
    rescue => e
      halt 400, e.message
    end
    result = HlmR2.new(hlm_r2)
    result = result.call
    halt 503 if result == 503
    result
  end

  post '/icc/?', &icc
  post '/hlm_r2_parse/?', &hlm_r2_parser
  post '/hlm_r2/?', &hlm_r2_lambda
end
