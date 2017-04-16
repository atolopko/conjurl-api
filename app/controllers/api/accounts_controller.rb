module Api
  class AccountsController < ApiController
    
    def create
      account, jwt = Authentication.register(name: params[:name])
      render json: serialize_account(account, jwt)
    rescue ActiveRecord::RecordNotUnique
      render_request_error("account already exists")
    end

    def index
      authenticate do |account, jwt|
        if params[:public_identifier] != account.public_identifier
          render_request_error("not your account", status: 403)
        else
          render json: serialize_account(account, jwt)
        end
      end
    end

    private

    def serialize_account(account, jwt)
      {
        self_ref: api_accounts_url + "/#{account.public_identifier}",
        created_at: account.created_at,
        name: account.name,
        public_identifier: account.public_identifier,
        jwt: jwt
      }
    end
  end
end
