module Api
  class ApiController < ApplicationController

    rescue_from StandardError, with: :render_server_error

    private

    def render_error(status, error_message)
      error_body = { status: status, params: params, error: error_message }
      Rails.logger.error(error_body)
      render status: status, json: error_body
    end

    def render_request_error(error_message)
      render_error(:bad_request, error_message)
    end

    def render_server_error(error_message)
      # TODO: also send ops alert!
      render_error(:internal_server_error, error_message)
    end

  end
end
