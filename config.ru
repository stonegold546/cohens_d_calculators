# \ -s puma

require 'faye'

Dir.glob('./{models,helpers,controllers,services,values}/*.rb').each do |file|
  require file
end

use Faye::RackAdapter, mount: '/faye', timeout: 120
run CohenDCalc
