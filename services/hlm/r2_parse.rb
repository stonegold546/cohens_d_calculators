require 'csv'

# Calculator for partial-eta-squared
class R2Parse
  def initialize(hlm_r2)
    data = CSV.parse hlm_r2.file_r2[:tempfile]
    @data = data[0]
  end

  def call
    Oj.dump @data
  end
end
