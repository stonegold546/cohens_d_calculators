# DF = 1
# CONFINT = 0.95
# TNCP_MAX = 37.62
# EMPTY_MESSAGE = ''.freeze
# URL = 'https://public.opencpu.org/ocpu/library/MBESS/R/conf.limits.nct/json'.freeze
# LL = 'Lower.Limit'.freeze
# UL = 'Upper.Limit'.freeze
# WARNING = 'The observed noncentrality parameter of the '\
#   'noncentral t-distribution (t-statistic) has exceeded 37.62 in '\
#   "magnitude (R's limitation foraccurate probabilities from the "\
#   "noncentral t-distribution) in the function's iterative search "\
#   'for the appropriate value(s). The confidence intervals may '\
#   'be fine, but might be inaccurate; use caution.'.freeze

# Cohen's d calculator for One-sample t test
class CohenDz
  def initialize(one_sample)
    @inputs = one_sample.attributes
    @sample_mean = one_sample.sample_mean.to_f
    @pop_mean = one_sample.pop_mean.to_f
    @sample_sd = one_sample.sample_sd.to_f
    @n = one_sample.n.to_f
    @t = calc_t
  end

  def call
    cohen_dz = (@sample_mean - @pop_mean) / @sample_sd
    result = { cohen_dz: cohen_dz, inputs: @inputs }
    return Oj.dump result if @t.zero? || @n.zero?
    npci = non_par_conf_int
    result = { cohen_dz: cohen_dz, lower_limit: npci[:lower],
               upper_limit: npci[:upper], inputs: @inputs }
    result = warning(result)
    Oj.dump result
  end

  def non_par_conf_int
    response = HTTParty.post URL, body: { ncp: @t, df: @n - DF }
    result = Oj.load response.body
    lower = result[LL][0] / Math.sqrt(@n)
    upper = result[UL][0] / Math.sqrt(@n)
    { lower: lower, upper: upper }
  end

  def calc_t
    mean_d = @sample_mean - @pop_mean
    standard_error = @sample_sd / Math.sqrt(@n)
    mean_d / standard_error
  end

  def warning(result)
    warning_message = @t > TNCP_MAX ? WARNING : EMPTY_MESSAGE
    result.merge(warning: warning_message)
  end
end
