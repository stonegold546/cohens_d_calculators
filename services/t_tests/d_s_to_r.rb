# Convert d_s to r
class DsToR
  def initialize(data)
    @d_s = data.d_s
    @n1 = data.n1
    @n2 = data.n2
    @big_n = @n1 + @n2
  end

  def call
    result = {
      r: internal_call, inputs: {
        'Cohen\'s d' => @d_s, 'n1' => @n1, 'n2' => @n2
      }
    }
    Oj.dump result
  end

  def internal_call
    second_part_denum = (@big_n * @big_n - 2 * @big_n) / (@n1 * @n2)
    denum = Math.sqrt(@d_s * @d_s + second_part_denum)
    @d_s / denum
  end
end
