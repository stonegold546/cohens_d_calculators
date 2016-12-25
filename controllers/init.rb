require 'sinatra'

Dir.glob('controllers/**/*.rb').each do |file|
  require_relative "../#{file}" unless file.to_s == 'controllers/init.rb'
end
