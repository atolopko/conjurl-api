module Api
  class ShortUrlsController < ApiController
    def create
      short_url =
        ShortUrl.generate!(target_url: params[:target_url],
                           key_generator: key_generator)
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

    def statistics
      short_url = ShortUrl[params[:short_url_key]]
      statistics = ShortUrlStatistics.new(short_url)
      render json: serialize_short_url_statistics(statistics)
    rescue ActiveRecord::RecordNotFound => e
      render_error(:not_found, e.to_s)
    end

    private

    def serialize_short_url(short_url)
      {
        self_ref: api_short_urls_url + "/#{short_url.key}",
        statistics_ref: api_short_urls_url + "/#{short_url.key}/statistics",
        short_url: short_url.short_url,
        target_url: short_url.target_url,
        created_at: short_url.created_at.iso8601
      }
    end

    def serialize_short_url_statistics(statistics)
      short_url = statistics.short_url
      {
        self_ref: api_short_urls_url + "/#{short_url.key}/statistics",
        short_url: serialize_short_url(short_url)
      }.merge(statistics.calculate)
    end

    def key_generator
      @key_generator ||=
        KeyGenerator.new(
          key_length: Settings.short_url_key.length,
          alphabet: Settings.short_url_key.alphabet,
          sequence: sequence_generator)
    end

    def sequence_generator
      key_namespace_size = Settings.short_url_key.alphabet.size ** Settings.short_url_key.length
      @sequence_generator ||=
        UnpredictableSequenceGenerator.new(
          base_generator: DatabaseSequenceGenerator.new(key_namespace_size: key_namespace_size),
          key_namespace_size: key_namespace_size,
          step: Settings.short_url_key.step)
    end
  end
end
