module Api
  class BaseController < ApplicationController

    rescue_from StandardError, with: :render_server_error
    rescue_from AuthenticationError, with: :render_authentication_error
    rescue_from AuthorizationError, with: :render_authorization_error

    private

    def authenticate(allow_guest: false)
      auth = request.headers['Authorization']
      if auth.nil?
        return nil if allow_guest
        raise AuthenticationError.new(nil, "endpoint requires Authorization header")
      end
      match = auth.match(/Bearer (?<jwt>.+)/) or
        raise AuthenticationError.new(nil, "invalid Authorization header value")
      Authentication.authenticate(match[:jwt])
    end

    def render_error(status, error_message)
      error_body = { status: status, params: params, error: error_message }
      Rails.logger.error(error_body)
      render status: status, json: error_body
    end

    def render_request_error(error_message, status: :bad_request)
      render_error(status, error_message)
    end

    def render_server_error(error)
      # TODO: also send ops alert!
      Rails.logger.error(error)
      render_error(:internal_server_error, error.message)
    end

    def render_authentication_error(error)
      render_request_error(error.message, status: 401) # 401 is less confusing than :unauthorized
    end

    def render_authorization_error(error)
      render_request_error(error.message, status: :forbidden)
    end

  end
end
