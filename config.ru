# \ -s puma

Dir.glob('./{models,helpers,controllers,services,values}/*.rb').each do |file|
  require file
end
run CohenDCalc
