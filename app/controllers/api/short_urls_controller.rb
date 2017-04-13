module Api
  class ShortUrlsController < ApiController
    def create
      short_url =
        ShortUrl.generate!(target_url: params[:target_url],
                           short_url_key_generator: short_url_key_generator)
      render json: serialize_short_url(short_url)
    rescue URI::InvalidURIError => e
      render_request_error(e.to_s)
    end

    def index
      short_url = ShortUrl[params[:short_url_key]]
      render json: serialize_short_url(short_url)
    rescue ActiveRecord::RecordNotFound => e
      render_error(:not_found, e.to_s)
    end

    private

    def serialize_short_url(short_url)
      { self: api_short_urls_url + "/#{short_url.id}",
        short_url: short_url.short_url,
        target_url: short_url.target_url,
        created_at: short_url.created_at.iso8601 }
    end

    def short_url_key_generator
      @short_url_key_generator ||=
        RandomShortUrlKeyGenerator.new(
          key_length: Settings.short_url_key.length,
          alphabet: Settings.short_url_key.alphabet)
    end
  end
end
