# Calculator for Odds Ratio
class OddsRatio
  def initialize(odds)
    @inputs = odds.attributes
    @odds_vector = odds.odds_vector
    @odds_url = odds.method_url[0]
    @risk_url = odds.method_url[1]
    @conf_int = odds.confidence_interval
    @reduction = odds.reduction
  end

  def call
    odds = odds_ratio
    risk = reduction(risk_ratio)
    arr = arr_calc
    nnt = (1 / arr).round(7)
    arr = arr.round(7)
    Oj.dump(
      odds_ratio: odds[0], risk_ratio: risk[0], lower_limit_odds: odds[1],
      upper_limit_odds: odds[2], lower_limit_risk: risk[1], nnt: nnt, arr: arr,
      upper_limit_risk: risk[2], inputs: @inputs
    )
  end

  def reduction(rr)
    if @reduction == 'yes'
      rr[1], rr[2] = rr[2], rr[1]
      rr = rr.map { |e| 1 - e }
    end
    rr
  end

  def odds_ratio
    response = HTTParty.post @odds_url, body: {
      'x' => @odds_vector, 'conf.level' => @conf_int
    }
    response = Oj.load response.body
    response = response[MEASURE_EXTRACT][1]
    response
  end

  def risk_ratio
    response = HTTParty.post @risk_url, body: {
      'x' => @odds_vector, 'rev' => '"both"', 'conf.level' => @conf_int
    }
    response = Oj.load response.body
    response = response[MEASURE_EXTRACT][1]
    response
  end

  def arr_calc
    odds_vector = Oj.load @odds_vector
    eer = odds_vector[0] / (odds_vector[0] + odds_vector[1])
    cer = odds_vector[2] / (odds_vector[2] + odds_vector[3])
    arr = eer - cer
    arr *= -1 if @reduction == 'yes'
    arr
  end
end
