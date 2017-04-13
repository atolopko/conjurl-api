class ShortUrl < ActiveRecord::Base
  validates :key, presence: true
  validates :target_url, presence: true

  def self.generate!(target_url:,
                     short_url_key_generator:)
    key = short_url_key_generator.generate(target_url)
    create!(key: key,
            target_url: target_url)
  end

  def short_url
    @uri ||= URI.join(Settings.url_redirect_service_host, key).to_s
  end

  def self.[](key)
    find_by(key: key)
  end
end
