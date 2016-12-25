Dir.glob('services/**/*.rb').each do |file|
  require_relative "../#{file}" unless file.to_s == 'services/init.rb'
end
