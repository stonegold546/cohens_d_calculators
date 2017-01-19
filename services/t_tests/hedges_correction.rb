BASE = 1

# Hedges's g correction for several Cohen's d
class HedgesCorrection
  def initialize(total_n_or_pairs, df)
    @total_n_or_pairs = total_n_or_pairs
    @df = df.to_f
  end

  def call
    base = 4 * (@total_n_or_pairs - @df) - BASE
    1 - (3 / base)
  end
end
