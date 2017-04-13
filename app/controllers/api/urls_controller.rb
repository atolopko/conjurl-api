module Api
  class UrlsController < ApiController
    def create
      short_url =
        ShortUrl.generate!(target_url: params[:target_url],
                           short_url_key_generator: short_url_key_generator)
      render json: { short_url: short_url.short_url }
    rescue URI::InvalidURIError => e
      render_request_error(e.to_s)
    end

    private

    def short_url_key_generator
      @short_url_key_generator ||=
        RandomShortUrlKeyGenerator.new(
          key_length: Settings.short_url_key.length,
          alphabet: Settings.short_url_key.alphabet)
    end
  end
end
