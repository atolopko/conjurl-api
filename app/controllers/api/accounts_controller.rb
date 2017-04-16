module Api
  class AccountsController < ApiController
    
    def create
      account, jwt = Authentication.register(name: params[:name])
      render json: {
               jwt: jwt,
               account: serialize_account(account)
             }
    rescue ActiveRecord::RecordNotUnique
      render_request_error("account already exists")
    end

    def index
      account = authenticate
      raise AuthorizationError if params[:public_identifier] != account.public_identifier
      render json: serialize_account(account)
    end

    private

    def serialize_account(account)
      {
        self_ref: api_accounts_url + "/#{account.public_identifier}",
        created_at: account.created_at.utc.iso8601,
        name: account.name,
        public_identifier: account.public_identifier,
        short_urls: account.short_urls.count
      }
    end
  end
end
