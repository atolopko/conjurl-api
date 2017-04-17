class ShortUrl < ActiveRecord::Base
  validates :key, presence: true
  validates :target_url, presence: true
  validate :target_url_valid

  belongs_to :account, optional: true
  has_many :short_url_requests

  def self.generate!(target_url:,
                     account:,
                     key_generator:)
    target_url = target_url.strip
    unless target_url =~ %r{^.+://}
      target_url = "http://#{target_url}"
    end
    key = key_generator.generate
    create!(key: key,
            account: account,
            target_url: target_url)
  rescue ActiveRecord::RecordNotUnique
    raise "ShortURL key collision: #{key}"
  end

  def short_url
    @uri ||= URI.join(Settings.url_redirect_service_host, key).to_s
  end

  def self.[](key)
    find_by!(key: key)
  end

  private

  def target_url_valid
    valid =
      begin
        uri = URI.parse(target_url)
        %w{ http https }.include? uri.scheme
      rescue URI::InvalidURIError
        false
      end
    unless valid
      errors[:target_url] << "is not a valid URL"
    end
  end
end
