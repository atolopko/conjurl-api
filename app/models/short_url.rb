class ShortUrl < ActiveRecord::Base
  validates :key, presence: true
  validates :target_url, presence: true

  def self.generate!(target_url:,
                     key_generator:)
    key = key_generator.generate
    create!(key: key,
            target_url: target_url)
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.error("ShortUrl key collision: #{key}")
    raise "ShortURL key collision. Increase key length or alphabet size."
  end

  def short_url
    @uri ||= URI.join(Settings.url_redirect_service_host, key).to_s
  end

  def self.[](key)
    find_by!(key: key)
  end
end
