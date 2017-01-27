CONFINT_R2 = 0.90
URL_R2 = 'https://public.opencpu.org/ocpu/library/MBESS/R/ci.R2/json?digits=7'.freeze
LL_R2 = 'Lower.Conf.Limit.R2'.freeze
UL_R2 = 'Upper.Conf.Limit.R2'.freeze

# Class for ANOVA calculators
class CohenDCalc < Sinatra::Base
  ols_r2 = lambda do
    regression = Regression.new(params)
    halt 400 unless regression.valid?
    result = RSquared.new(regression)
    result.call
  end

  get '/ols_r2/?', &ols_r2
end
