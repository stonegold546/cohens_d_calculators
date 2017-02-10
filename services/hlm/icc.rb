require 'csv'

# Calculator for partial-eta-squared
class Icc
  def initialize(hlm_icc)
    data = CSV.parse hlm_icc.icc_file[:tempfile]
    data = data[CSV_DATA].transpose
    @clusters = data[0]
    @values = data[1].map(&:to_f)
  end

  def call
    num_s = "#{@clusters.uniq.count} clusters, #{@values.count} units"
    icc_calc = calc_icc
    result = create_result(icc_calc)
    result[:inputs] = num_s
    Oj.dump result
  end

  def calc_icc
    response = HTTParty.post URL_ICC, body: {
      'x' => @clusters.to_s, 'y' => @values.to_s
    }
    Oj.load response.body
  end

  def create_result(data)
    {
      icc_est: data['ICC'][0], lower: data['LowerCI'][0],
      upper: data['UpperCI'][0], n: data['N'][0], k: data['k'][0],
      varw: data['varw'][0], vara: data['vara'][0]
    }
  end
end
