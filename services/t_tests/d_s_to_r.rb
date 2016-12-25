# Convert d_s to r
class DsToR
  def initialize(ds, n1, n2)
    @ds = ds.to_f
    @n1 = n1.to_f
    @n2 = n2.to_f
    @big_n = @n1 + @n2
  end

  def call
    second_part_denum = (@big_n * @big_n - 2 * @big_n) / (@n1 * @n2)
    denum = Math.sqrt(@ds * @ds + second_part_denum)
    r = @ds / denum
    Oj.dump(r: r, inputs: { 'Cohen\'s d' => @ds, 'n1' => @n1, 'n2' => @n2 })
  end
end
