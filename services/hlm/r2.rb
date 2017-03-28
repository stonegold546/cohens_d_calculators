# TODO: Create equations here, null and alternative.
# TODO: Also pull out correct variables and variable data

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
    select_data(variables)
    delete_bad_clusters
    floatify
    response = HTTParty.post "#{ENV['PYTHON_URL']}/r2", body: {
      headers: @headers, data: @data, cluster_var: @cluster_var,
      outcome_var: @outcome_var, null_equation: null_equation,
      l_one_preds: @level_one_hash, int_preds: @intercept_predictors,
      optim: @method
    }.to_json, headers: { 'Content-Type' => 'application/json' }
    form_response(response)
  end

  def form_response(response)
    response = Oj.load response.body
    Oj.dump varw_b: response['varw_b'], vara_b: response['vara_b'],
            varw_f: response['varw_f'], vara_f: response['vara_f'],
            n: response['a'], k: response['k'],
            level_one_r_2: response['level_one_r_2'],
            level_two_r_2: response['level_two_r_2'],
            convergence_b: response['convergence_b'],
            convergence_f: response['convergence_f']
  end

  def remove_non_ascii(text)
    text = text.gsub(/[\u0080-\u00ff]/, '') unless
      text.force_encoding('UTF-8').ascii_only?
    text
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

  # def fit_equation
  #   int_preds = @intercept_predictors[0].join(' + ')
  #   level_one_predictors = @level_one_hash.keys.join(' + ')
  #   predictors = array_join([int_preds, level_one_predictors, create_cross])
  #   real_preds = array_join(
  #     [int_preds_new, level_one_predictors_new, create_cross_new]
  #   )
  #   ["#{@outcome_var} ~ #{predictors}", "#{@outcome_var} ~ #{real_preds}"]
  # end
  #
  # def int_preds_new
  #   @intercept_predictors.transpose.map do |pred|
  #     pred[1] == '0' ? pred[0] : pred.join(CENT)
  #   end.join(' + ')
  # end
  #
  # def level_one_predictors_new
  #   @level_one_hash.map do |pred, data|
  #     data[1].zero? ? pred : "#{pred}#{CENT}#{data[1]}"
  #   end.join(' + ')
  # end
  #
  # def create_cross_new
  #   level_one_preds = level_one_predictors_new
  #   level_one_preds = level_one_preds.split(' + ')
  #   @level_one_hash.map do |key, data|
  #     level_one_preds.map do |l_one_pred|
  #       key = l_one_pred if l_one_pred == "#{key}#{CENT}#{data[1]}"
  #     end
  #     pred = data[0][0]
  #     unless pred.empty?
  #       pred.map do |e|
  #         "#{e} : #{key}"
  #       end.join(' + ')
  #     end
  #   end.compact.join(' + ')
  # end
  #
  # def create_cross
  #   @level_one_hash.map do |key, data|
  #     pred = data[0][0]
  #     pred.map { |e| "#{e} : #{key}" }.join(' + ') unless pred.empty?
  #   end.compact.join(' + ')
  # end
  #
  # def array_join(predictors)
  #   predictors = predictors.map { |e| e.empty? ? nil : e }.compact
  #   predictors.compact.join(' + ')
  # end

  def null_equation
    "#{@outcome_var} ~ 1"
  end
end
