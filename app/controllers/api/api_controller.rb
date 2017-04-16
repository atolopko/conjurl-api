module Api
  class ApiController < ApplicationController

    rescue_from StandardError, with: :render_server_error

    private

    def authenticate
      match = request.headers['Authorization'].match /Bearer (?<jwt>.+)/
      account = jwt = nil
      if match
        jwt = match[:jwt]
        account = Authentication.authenticate(jwt)
        unless account
          render_request_error("authentication failed", status: 401)
          return
        end
      end
      yield account, jwt
    end

    def render_error(status, error_message)
      error_body = { status: status, params: params, error: error_message }
      Rails.logger.error(error_body)
      render status: status, json: error_body
    end

    def render_request_error(error_message, status: :bad_request)
      render_error(status, error_message)
    end

    def render_server_error(error_message)
      # TODO: also send ops alert!
      render_error(:internal_server_error, error_message)
    end

  end
end
