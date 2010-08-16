this = File.expand_path(File.dirname(__FILE__)) + '/oauth'
requirements = Dir["#{this}/client/*"] + Dir["#{this}/protocol/*"]
requirements += ["#{this}/oauth_token", "#{this}/protocol"]
requirements += Dir["#{this}/tokens/*"]

requirements.each do |file|
  require file
end
