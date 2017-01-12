# Convert g_s to r
class GsToR
  def initialize(data)
    @g_s = data.g_s.to_f
    @n1 = data.n1.to_f
    @n2 = data.n2.to_f
    @big_n = @n1 + @n2
  end

  def call
    result = {
      r: internal_call, inputs: {
        'Hedges\' g' => @g_s, 'n1' => @n1, 'n2' => @n2
      }
    }
    Oj.dump result
  end

  def internal_call
    second_part_denum = (@big_n * @big_n - 2 * @big_n) / (@n1 * @n2)
    denum = Math.sqrt(@g_s * @g_s + second_part_denum)
    @g_s / denum
  end
end
