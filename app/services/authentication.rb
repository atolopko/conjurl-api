class Authentication
  class << self
    def register(name:)
      account = Account.create!(name: name)
      return account, generate_jwt(account)
    end

    def authenticate(jwt)
      payload, _ = JWT.decode(
        jwt,
        Settings.jwt_secret,
        true, # verify
        algorithm: 'HS256',
        iss: 'conjurl.com',
        verify_iss: true,
        aud: 'conjurl',
        verify_aud: true)
      account_pid = payload['sub']
      Account.find_by(public_identifier: account_pid)
    rescue JWT::DecodeError => e
      raise AuthenticationError.new(jwt, e.message)
    end

    private
    
    def generate_jwt(account)
      payload = {
        iss: 'conjurl.com',
        aud: 'conjurl',
        iat: Time.now.to_i,
        # TODO: exp: Time.now.to_i + 1.day,
        sub: account.public_identifier,
        name: account.name
      }
      JWT.encode payload, Settings.jwt_secret, 'HS256'
    end
  end
end
