module Api
  class ApiController < ApplicationController

    private

    def error_response(status, error_message)
      error_response = { status: status, params: params, error: error_message }
      Rails.logger.error(error_response)
      render status: status, json: error_response
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
