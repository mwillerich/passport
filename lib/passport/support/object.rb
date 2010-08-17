class AccessToken
  attr_accessor :token, :secret, :key
  
  def initialize(attributes)
    attributes.each do |k, v|
      self.send("#{k.to_s}=", v) if self.respond_to?("#{k.to_s}=")
    end
  end
  
  def to_hash
    {:token => token, :secret => secret, :key => key}
  end
end
