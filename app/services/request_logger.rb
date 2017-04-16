class RequestLogger < ActiveRecord::Base
  # TODO: Ideally, this would get sent to a distributed log or queue
  # that is processed in the background, and aggregated into
  # reportable tracking metrics
  def self.emit(short_url, request)
    ShortUrlRequest.create!(short_url: short_url,
                           requested_at: Time.now.utc, # TODO: request time available?
                           ip_address: request.remote_ip,
                           referrer: request.headers['Referer'])
  end
end
