require 'sinatra'
require 'slim'
require 'slim/include'
require 'kramdown'
require 'rack-ssl-enforcer'
require 'config_env'
require 'oj'
require 'httparty'

configure :development, :test do
  ConfigEnv.path_to_config('config/config_env.rb')
end

# Base app
class CohenDCalc < Sinatra::Base
  enable :logging

  set :views, File.expand_path('../../../views', __FILE__)
  set :public_folder, File.expand_path('../../../public', __FILE__)

  configure :production do
    use Rack::SslEnforcer
    set :session_secret, ENV['MSG_KEY']
  end

  root = lambda do
    slim :index
  end

  get '/', &root
end
