# Hedges's g correction for several Cohen's d
class HedgesCorrection
  def initialize(n1, n2)
    @n1 = n1.to_f
    @n2 = n2.to_f
  end

  def call
    base = 4 * (@n1 + @n2) - 9
    1 - (3 / base)
  end
end
