class AuthenticationError < StandardError
  attr_accessor :jwt
  
  def initialize(jwt, message)
    super(message)
    @jwt = jwt
  end
end
