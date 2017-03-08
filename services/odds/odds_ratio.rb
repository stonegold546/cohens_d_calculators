# Calculator for Odds Ratio
class OddsRatio
  def initialize(odds)
    @inputs = odds.attributes
    @tyoy = odds.tyoy
    @tyon = odds.tyon
    @cyoy = odds.cyoy
    @cyon = odds.cyon
  end

  def call
    odds_ratio = (@tyoy * @cyon) / (@tyon * @cyoy)
    ap odds_ratio
    response = HTTParty.post URL_ODDS_CI, body: {
      'x' => 'NA', 'n1' => @tyoy + @tyon, 'n2' => @cyoy + @cyon,
      'm1' => @tyoy + @cyoy, 'psi' => odds_ratio
    }
    result = Oj.load response.body
    ap result
  end
end
