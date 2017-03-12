# Calculator for Odds Ratio
class OddsRatio
  def initialize(odds)
    @inputs = odds.attributes
    @odds_vector = odds.odds_vector
    @method_url = odds.method_url
    @conf_int = odds.confidence_interval
  end

  def call
    response = HTTParty.post @method_url, body: {
      'x' => @odds_vector, 'conf.level' => @conf_int
    }
    response = HTTParty.post URL_WITH, body: {
      data: response.headers['x-ocpu-session'], expr: 'measure[2,]'
    }
    {
      odds_ratio: response[0], lower_limit_odds: response[1],
      upper_limit_odds: response[2], inputs: @inputs
    }
  end
end
