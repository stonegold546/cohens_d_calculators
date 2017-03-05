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
      'ANOVA' => 'ANOVA', 'TRUE' => TRUE, 'FALSE' => FALSE
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
    response = HTTParty.post "#{ENV['PYTHON_URL']}/icc", body: {
      x: @clusters, y: @values, method: which_method
    }.to_json, headers: {
      'Content-Type' => 'application/json'
    }
    variances = {}
    variances[:var_b] = response[0]
    variances[:var_w] = response[1]
    create_result_ml(icc_calc, variances)
  end

  def create_result_ml(icc_calc, variances)
    icc = variances[:var_b] / (variances[:var_b] + variances[:var_w])
    icc_calc[:icc_est] = icc
    icc_calc[:vara] = variances[:var_b]
    icc_calc[:varw] = variances[:var_w]
    icc_calc
  end
end
