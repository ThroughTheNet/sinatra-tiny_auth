Dir[File.expand_path('../tasks', __FILE__)+'/*.rake'].each do |file|
  load file
end

