URL_F = 'https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.ncf/json'.freeze
LL_F = 'Lower.Limit'.freeze
UL_F = 'Upper.Limit'.freeze
DF_F = 1

# Class for ANOVA calculators
class CohenDCalc < Sinatra::Base
  anova = lambda do
    anova = Anova.new(params)
    halt 400, anova.errors.messages.to_s unless anova.valid?
    result = PartialEtaSq.new(anova)
    result.call
  end

  get '/fixed_effects/?', &anova
end
