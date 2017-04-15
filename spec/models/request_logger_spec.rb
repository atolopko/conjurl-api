require "rails_helper"

RSpec.describe RequestLogger do
  it "records the request", aggregate_failures: true do
    short_url =
      ShortUrl.create!(key: 'aaaa',
                       target_url: 'http://some.where/else')
    request = double("Request",
                     ip: '127.0.0.1',
                     headers: { 'referer' => 'http://refer.er/page' })
    now = Time.now.utc
    Timecop.freeze(now) do
      RequestLogger.emit(short_url, request)
      expect(ShortUrlRequest.count).to eq 1
      expect(ShortUrlRequest.first.short_url).to eq short_url
      expect(ShortUrlRequest.first.requested_at).to eq now
      expect(ShortUrlRequest.first.ip_address.to_s).to eq '127.0.0.1'
      expect(ShortUrlRequest.first.referrer).to eq 'http://refer.er/page'
    end
  end
end
