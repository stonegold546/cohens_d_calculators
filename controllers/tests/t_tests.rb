# Class for t_test calculators
class CohenDCalc < Sinatra::Base
  cohen_dz = lambda do
    one_sample = OneSample.new(params)
    halt 400 unless one_sample.valid?
    result = CohenDz.new(one_sample)
    result.call
  end

  cohen_ds = lambda do
    independent_samples = IndependentSamples.new(params)
    halt 400 unless independent_samples.valid?
    CohenDs.new(independent_samples).call
  end

  cohen_dav = lambda do
    average_samples = AverageSamples.new(params)
    halt 400 unless average_samples.valid?
    CohenDav.new(average_samples).call
  end

  cohen_drm = lambda do
    repeated_samples = RepeatedSamples.new(params)
    halt 400 unless repeated_samples.valid?
    CohenDrm.new(repeated_samples).call
  end

  d_to_r = lambda do
    data = ConvertDsToR.new(params)
    result = DsToR.new(data)
    Oj.dump result.call
  end

  get '/one_sample_t/?', &cohen_dz
  get '/independent_samples_t/?', &cohen_ds
  get '/dependent_samples_t_average/?', &cohen_dav
  get '/dependent_samples_t_repeated/?', &cohen_drm
  get '/d_to_r', &d_to_r
end
