Dir.glob('services/**/*.rb').each do |file|
  require_relative "../#{file}" unless "#{file}" == 'services/init.rb'
end
