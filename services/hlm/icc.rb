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
    icc_calc = calc_icc
    icc_calc[:inputs] = num_s
    Oj.dump icc_calc
  end

  def calc_icc
    response = HTTParty.post "#{ENV['PYTHON_URL']}/icc", body: {
      x: @clusters, y: @values, method: which_method
    }.to_json, headers: {
      'Content-Type' => 'application/json'
    }
    response = Oj.load response.body
    { icc_est: response['ICC'], lower: response['LowerCI'],
      upper: response['UpperCI'], n: response['N'], k: response['k'],
      varw: response['varw'], vara: response['vara'] }
  end

  def which_method
    method = {
      'ANOVA' => 'ANOVA', 'TRUE' => TRUE, 'FALSE' => FALSE
    }
    method[@method]
  end
end
