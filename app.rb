require 'sinatra'
require 'slim'
require 'slim/include'
require 'kramdown'
require 'rack-ssl-enforcer'

confifure :development, :test do
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

# Class for calculators
class CohenDCalc < Sinatra::Base
  enable :logging

  configure :production do
    use Rack::SslEnforcer
    set :session_secret, ENV['MSG_KEY']
  end

  get '/' do
    slim :index
  end

  get 'one_sample_t' do
    result = OnePairedSampleT.new(
      params['sample_mean'], params['pop_mean'], params['sample_sd']
    )
    result.call
  end

  get 'independent_samples_t' do
    result = IndependentSamplesT.new(
      [params['mean_1'], params['mean_2']],
      [params['sd_1'], params['sd_2']],
      [params['n_1'], params['n_2']]
    )
    result.call
  end

  # get 'paired_samples_t' do
  #   result = OnePairedSampleT.new(
  #     params['mean_1'], params['mean_2'], params['sample_sd']
  #   )
  #   result.call
  # end
end
