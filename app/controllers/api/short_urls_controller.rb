module Api
  class ShortUrlsController < BaseController
    def create
      account = authenticate(allow_guest: true)
      short_url =
        ShortUrl.generate!(target_url: params[:target_url],
                           account: account,
                           key_generator: key_generator)
      render json: serialize_short_url(short_url)
    rescue ActiveRecord::RecordInvalid => e
      validation_errors = e.record.errors.full_messages.join(',')
      render_request_error(validation_errors)
    end

    def index
      account = authenticate
      short_url = ShortUrl[params[:short_url_key]]
      raise AuthorizationError if short_url.account != account
      render json: serialize_short_url(short_url)
    rescue ActiveRecord::RecordNotFound => e
      render_error(:not_found, e.to_s)
    end

    def statistics
      account = authenticate
      short_url = ShortUrl[params[:short_url_key]]
      raise AuthorizationError if short_url.account != account
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
#        account_ref: api_accounts_url + "/#{short_url.account.public_identifier}",
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
          sequence: sequence)
    end

    def sequence
      key_namespace_size = Settings.short_url_key.alphabet.size ** Settings.short_url_key.length
      @sequence_generator ||=
        Sequence::UnpredictableOrdering.new(
          base_sequence: Sequence::Postgres.new(sequence_name: 'short_url_key_seq',
                                                max_value: key_namespace_size),
          max_value: key_namespace_size,
          step: Settings.short_url_key.step)
    end
  end
end
