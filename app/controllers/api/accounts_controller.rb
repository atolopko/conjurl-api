module Api
  class AccountsController < BaseController
    
    def create
      account, jwt = Authentication.register(name: params[:name])
      render json: {
               jwt: jwt,
               account: serialize_account(account)
             }
    rescue ActiveRecord::RecordInvalid => e
      validation_errors = e.record.errors.full_messages.join(',')
      render_request_error("account already exists")
    end

    def index
      account = authenticate
      raise AuthorizationError if params[:public_identifier] != account.public_identifier
      render json: serialize_account(account)
    end

    def short_urls
      account = authenticate
      raise AuthorizationError if params[:public_identifier] != account.public_identifier
      render json: serialize_short_urls(account)
    end

    private

    def serialize_account(account)
      {
        self_ref: api_accounts_url + "/#{account.public_identifier}",
        created_at: account.created_at.utc.iso8601,
        name: account.name,
        public_identifier: account.public_identifier,
        short_urls_ref: api_accounts_url + "/#{account.public_identifier}/short_urls",
        short_urls: account.short_urls.count
      }
    end

    def serialize_short_urls(account)
      account.short_urls.map do |short_url|
        api_short_urls_url + "/#{short_url.key}"
      end
    end
  end
end
