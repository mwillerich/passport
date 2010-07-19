this = File.expand_path(File.dirname(__FILE__)) + '/oauth'
requirements = Dir["#{this}/access_token/*"] + Dir["#{this}/protocol/*"]
requirements += ["#{this}/access_token", "#{this}/protocol"]

requirements.each do |file|
  require file
end