require 'ap'
require 'csv'

# Calculator for partial-eta-squared
class Icc
  def initialize(params)
    file = params.values[FILE_STRING].split("\r\n")[CSV_TEXT]
    data = CSV.parse file
    @data = data[CSV_DATA].transpose
    @data[1] = @data[1].map(&:to_f)
  end

  def call
    num_s = "#{@data[0].uniq.count} clusters, #{@data[1].count} units"
    icc_calc = calc_icc
    result = create_result(icc_calc)
    result[:inputs] = num_s
    Oj.dump result
  end

  def calc_icc
    response = HTTParty.post URL_ICC, body: {
      'x' => @data[0].to_s, 'y' => @data[1].to_s
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
