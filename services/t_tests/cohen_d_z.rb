DF = 1
CONFINT = 0.95
WARNING = { warning: 'The observed noncentrality parameter of the noncentral '\
  "t-distribution has exceeded 37.62 in magnitude (R's limitation for "\
  'accurate probabilities from the noncentral t-distribution) in the '\
  "function's iterative search for the appropriate value(s). The confidence "\
  'intervals may be fine, but might be inaccurate; use caution.' }.freeze

# Cohen's d calculator for One-sample t test
class CohenDz
  def initialize(one_sample)
    @sample_mean = one_sample.sample_mean.to_f
    @pop_mean = one_sample.pop_mean.to_f
    @sample_sd = one_sample.sample_sd.to_f
    @n = one_sample.n.to_f
    @t = calc_t
    @inputs =
      @t > 37.62 ? one_sample.attributes.merge(WARNING) : one_sample.attributes
  end

  def call
    cohen_dz = (@sample_mean - @pop_mean) / @sample_sd
    result = { cohen_dz: cohen_dz, inputs: @inputs }
    return Oj.dump result if @t.zero? || @n.zero?
    npci = non_par_conf_int
    result = { cohen_dz: cohen_dz, lower_limit: npci[:lower],
               upper_limit: npci[:upper], inputs: @inputs }
    Oj.dump result
  end

  def non_par_conf_int
    npci = RinRuby.new
    npci.eval("require('MBESS')")
    npci.eval("results <- conf.limits.nct(#{@t}, #{@n} - #{DF},\
      conf.level = #{CONFINT})")
    npci.eval('lower <- results$Lower.Limit')
    npci.eval('upper <- results$Upper.Limit')
    lower = npci.lower / Math.sqrt(@n)
    upper = npci.upper / Math.sqrt(@n)
    npci.quit
    { lower: lower, upper: upper }
  end

  def calc_t
    mean_d = @sample_mean - @pop_mean
    standard_error = @sample_sd / Math.sqrt(@n)
    mean_d / standard_error
  end
end
