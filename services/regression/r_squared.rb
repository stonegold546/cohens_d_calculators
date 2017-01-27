# Calculator for partial-eta-squared
class RSquared
  def initialize(regression)
    @inputs = regression.attributes
    @r2 = regression.r2
    @df1 = regression.df_1
    @df2 = regression.df_2
  end

  def call
    npci = non_par_conf_int
    result = {
      lower_limit_r2: npci[:lower], upper_limit_r2: npci[:upper],
      inputs: @inputs
    }
    Oj.dump result
  end

  def non_par_conf_int
    response = HTTParty.post URL_R2, body: {
      'R2' => @r2, 'conf.level' => CONFINT_R2, 'df.1' => @df1, 'df.2' => @df2
    }
    result = Oj.load response.body
    lower = result[LL_R2][0]
    upper = result[UL_R2][0]
    { lower: lower, upper: upper }
  end
end
