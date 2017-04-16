class ShortUrl < ActiveRecord::Base
  validates :key, presence: true
  validates :target_url, presence: true

  belongs_to :account, optional: true
  has_many :short_url_requests

  def self.generate!(target_url:,
                     key_generator:)
    key = key_generator.generate
    create!(key: key,
            target_url: target_url)
  rescue ActiveRecord::RecordNotUnique => e
    raise "ShortURL key collision: #{key}"
  end

  def short_url
    @uri ||= URI.join(Settings.url_redirect_service_host, key).to_s
  end

  def self.[](key)
    find_by!(key: key)
  end
end
