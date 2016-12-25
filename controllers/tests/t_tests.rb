# TODO: USE VALUE OBJECTS TO CLEAN THINGS UP
# Class for t_test calculators
class CohenDCalc < Sinatra::Base
  cohen_dz = lambda do
    result = CohenDz.new(
      params['sample_mean'], params['pop_mean'], params['sample_sd']
    )
    result.call
  end

  cohen_ds = lambda do
    result = CohenDs.new(
      [params['mean_1'], params['mean_2']],
      [params['sd_1'], params['sd_2']],
      [params['n_1'], params['n_2']]
    )
    result.call
  end

  cohen_dav = lambda do
    CohenDav.new(params).call
  end

  cohen_drm = lambda do
    CohenDrm.new(params).call
  end

  d_to_r = lambda do
    result = DsToR.new(params['ds'], params['n1'], params['n2'])
    result.call
  end

  get '/one_sample_t/?', &cohen_dz
  get '/independent_samples_t/?', &cohen_ds
  get '/dependent_samples_t_average/?', &cohen_dav
  get '/dependent_samples_t_repeated/?', &cohen_drm
  get '/d_to_r', &d_to_r
end
