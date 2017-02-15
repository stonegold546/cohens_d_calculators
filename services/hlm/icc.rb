require 'csv'

# Calculator for partial-eta-squared
class Icc
  def initialize(hlm_icc)
    data = CSV.parse hlm_icc.icc_file[:tempfile]
    data = data[CSV_DATA].transpose
    @clusters = data[0]
    @values = data[1].map { |e| e.nil? ? 'NA' : e.to_f }
    @method = hlm_icc.method
  end

  def call
    num_s = "Clusters: #{@clusters.uniq.count}; "\
      "Cases: #{@values.count} (including missing) units; Method: "\
      "#{which_method} for estimate and variance components, ANOVA for CI"
    icc_calc = calc_icc_aov
    icc_calc = calc_icc_ml(icc_calc) unless @method == 'ANOVA'
    icc_calc[:inputs] = num_s
    Oj.dump icc_calc
  end

  def which_method
    method = {
      'ANOVA' => 'ANOVA', 'TRUE' => 'REML', 'FALSE' => 'FEML'
    }
    method[@method]
  end

  def calc_icc_aov
    response = HTTParty.post URL_ICC_ANOVA, body: {
      'x' => @clusters.to_s, 'y' => @values.to_s
    }
    result = Oj.load response.body
    create_result_aov(result)
  end

  def create_result_aov(data)
    {
      icc_est: data['ICC'][0], lower: data['LowerCI'][0],
      upper: data['UpperCI'][0], n: data['N'][0], k: data['k'][0],
      varw: data['varw'][0], vara: data['vara'][0]
    }
  end

  def calc_icc_ml(icc_calc)
    data_frame = create_data_frame
    lmer = perform_lmer(data_frame)
    variances = obtain_variances(lmer)
    create_result_ml(icc_calc, variances)
  end

  def create_result_ml(icc_calc, variances)
    icc = variances[:var_b] / (variances[:var_b] + variances[:var_w])
    icc_calc[:icc_est] = icc
    icc_calc[:vara] = variances[:var_b]
    icc_calc[:varw] = variances[:var_w]
    icc_calc
  end

  def create_data_frame
    response = HTTParty.post URL_ICC_DATA_FRAME, body: {
      'X1' => @clusters.to_s, 'X2' => @values.to_s
    }
    response.headers['x-ocpu-session']
  end

  def perform_lmer(data_frame)
    response = HTTParty.post URL_ICC_LMER, body: {
      'formula' => 'X2 ~ 1 + (1 | X1)', 'REML' => @method,
      'data' => data_frame
    }
    response.headers['x-ocpu-session']
  end

  def obtain_variances(lmer)
    summary = obtain_summary(lmer)
    var_b = var_b_w(summary, 'varcor$X1')
    var_w = var_b_w(summary, 'sigma^2')
    { var_b: var_b, var_w: var_w }
  end

  def obtain_summary(lmer)
    response = HTTParty.post URL_SUMMARY, body: {
      'object' => lmer
    }
    response.headers['x-ocpu-session']
  end

  def var_b_w(summary, expr)
    var = HTTParty.post URL_WITH, body: {
      'data' => summary, 'expr' => expr
    }
    var.body.delete('[').delete(']').to_f
  end
end
