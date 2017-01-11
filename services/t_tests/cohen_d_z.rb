require 'rinruby'

DF = 1
CONFINT = 0.95

# Cohen's d calculator for One-sample t test
class CohenDz
  def initialize(one_sample)
    @inputs = one_sample.attributes
    @sample_mean = one_sample.sample_mean.to_f
    @pop_mean = one_sample.pop_mean.to_f
    @sample_sd = one_sample.sample_sd.to_f
    @t = one_sample.t.to_f
    @n = one_sample.n.to_f
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
R.eval <<EOF
  require("MBESS")
  results <- conf.limits.nct(#{@t}, #{@n} - #{DF}, conf.level = #{CONFINT})
  lower <- results$Lower.Limit
  upper <- results$Upper.Limit
EOF
lower = R.lower / Math.sqrt(@n)
upper = R.upper / Math.sqrt(@n)
{ lower: lower, upper: upper }
  end
end
