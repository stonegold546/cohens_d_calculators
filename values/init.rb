Dir.glob('values/**/*.rb').each do |file|
  require_relative "../#{file}" unless file.to_s == 'values/init.rb'
end
