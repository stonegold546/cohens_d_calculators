URL_R2 = 'https://stonegold546.ocpu.io/MBESS_ES_CALC/R/ci.R2/json?digits=7'.freeze
LL_R2 = 'Lower.Conf.Limit.R2'.freeze
UL_R2 = 'Upper.Conf.Limit.R2'.freeze

# Class for ANOVA calculators
class CohenDCalc < Sinatra::Base
  ols_r2 = lambda do
    regression = Regression.new(params)
    halt 400, regression.errors.messages.to_s unless regression.valid?
    result = RSquared.new(regression)
    result.call
  end

  get '/ols_r2/?', &ols_r2
end
