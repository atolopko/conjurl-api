class ShortUrlRequest < ActiveRecord::Base
  belongs_to :short_url

  validates :short_url, presence: true
  validates :requested_at, presence: true
  validates :ip_address, presence: true
end
