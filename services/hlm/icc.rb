require 'csv'

# Safe transpose
class Array
  def safe_transpose
    max_size = self.map(&:size).max
    self.dup.map do |r|
      r << nil while r.size < max_size
      r
    end.transpose
  end
end

# Calculator for partial-eta-squared
class Icc
  def initialize(hlm_icc)
    @data = CSV.parse hlm_icc.icc_file[:tempfile]
    @clusters = obtain_data(hlm_icc.clusterVar)
    @values = obtain_data(hlm_icc.outcomeVar).map do |e|
      e.nil? ? 'NA' : e.to_f
    end
    @method = hlm_icc.method
    @channel = hlm_icc.channelVar
  end

  def call
    calc_icc
    "Clusters: #{@clusters.uniq.count}; "\
    "Cases: #{@values.count} (including missing) units; Method: "\
    "#{which_method} for estimate and variance components, ANOVA for CI"
  end

  def round_7(icc)
    icc.map { |k, v| icc[k] = v.is_a?(Numeric) ? v.round(7) : v }
  end

  # def design_effect(icc, k)
  #   icc * (k - 1) + 1
  # end

  def obtain_data(variable)
    headers = @data[0].map { |e| remove_non_ascii(e) }
    data = @data[CSV_DATA].safe_transpose
    i = headers.find_index(remove_non_ascii(variable))
    data[i]
  end

  def remove_non_ascii(text)
    encoding_options = {
      invalid: :replace, # Replace invalid byte sequences
      undef: :replace, # Replace anything not defined in ASCII
      replace: '', # Use a blank for those replacements
      universal_newline: true # Always break lines with \n
    }
    text.encode(Encoding.find('ASCII'), encoding_options)
  end

  def calc_icc
    # response =
    puts(@channel)
    HTTParty.post "#{ENV['PYTHON_URL']}/icc", body: {
      x: @clusters, y: @values, method: which_method,
      channel: @channel, url: ENV['FAYE_URL']
    }.to_json, headers: {
      'Content-Type' => 'application/json'
    }
    # response = Oj.load response.body
    # { icc_est: response['ICC'], lower: response['LowerCI'],
    #   upper: response['UpperCI'], n: response['N'], k: response['k'],
    #   varw: response['varw'], vara: response['vara'] }
  end

  def which_method
    method = {
      'ANOVA' => 'ANOVA', 'TRUE' => TRUE, 'FALSE' => FALSE
    }
    method[@method]
  end
end
