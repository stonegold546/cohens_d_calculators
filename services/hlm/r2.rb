require 'csv'

# Calculator for partial-eta-squared
class HlmR2
  def initialize(hlm_r2)
    data = CSV.parse hlm_r2.file_r2[:tempfile]
    @data = data[CSV_DATA]
    @headers = data[0].map { |e| remove_non_ascii(e) }
    @cluster_var = remove_non_ascii(hlm_r2.clusterVar)
    @outcome_var = remove_non_ascii(hlm_r2.outcomeVar)
    @intercept_predictors = hlm_r2.interceptPredictors
    @method = hlm_r2.method
    @level_one_hash = hlm_r2.levelOneHash
    @deleted_clusters
  end

  def call
    response = HTTParty.post "#{ENV['PYTHON_URL']}/r2", body:
      send_to_server, headers: { 'Content-Type' => 'application/json' }
    return 503 if response.code == 503
    form_response(response)
  rescue Net::ReadTimeout
    503
  end

  def send_to_server
    select_data(variables)
    delete_bad_clusters
    floatify
    {
      data: @data, headers: @headers, cluster_var: @cluster_var,
      outcome_var: @outcome_var, int_preds: @intercept_predictors,
      optim: @method, null_equation: null_equation,
      l_one_preds: @level_one_hash
    }.to_json
  end

  def form_response(response)
    response = Oj.load response.body
    Oj.dump varw_b: response['varw_b'], vara_b: response['vara_b'],
            varw_f: response['varw_f'], vara_f: response['vara_f'],
            n: response['a'], k: response['k'],
            level_one_r_2: response['level_one_r_2'],
            level_two_r_2: response['level_two_r_2'],
            convergence_b: response['convergence_b'],
            convergence_f: response['convergence_f'],
            icc: response['ICC']
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

  def variables
    variables = [@cluster_var, @outcome_var]
    @intercept_predictors[0].map { |predictor| variables << predictor }
    @level_one_hash.map do |key, data|
      variables << key
      data[0][0].map { |predictor| variables << predictor }
    end
    variables = variables.map { |variable| @headers.find_index(variable) }
    variables.uniq.sort
  end

  def select_data(variables)
    @headers = @headers.map.with_index do |e, i|
      e if variables.include? i
    end.compact
    @data = @data.transpose.map.with_index do |e, i|
      e if variables.include? i
    end.compact.transpose
  end

  def clusters
    cluster_id = @headers.find_index(@cluster_var)
    @data.transpose[cluster_id].uniq
  end

  def delete_bad_clusters
    start_clusters = clusters
    @data = @data.map do |row|
      row unless row.any? { |e| e.strip.empty? || e.nil? }
    end.compact
    @deleted_clusters = start_clusters - clusters
    @data = @data
  end

  def floatify
    @data = @data.map do |row|
      row.map do |e|
        begin Float(e)
        rescue
          e
        end end end
  end

  def null_equation
    "#{@outcome_var} ~ 1"
  end
end
