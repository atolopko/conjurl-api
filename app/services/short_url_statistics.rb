class ShortUrlStatistics

  attr_accessor :short_url
  
  def initialize(short_url, top_n: 5)
    @short_url = short_url
    @requests = short_url.short_url_requests
    @top_n = top_n
  end

  def calculate
    now = Time.now
    {
      lifetime: for_interval(from: short_url.created_at, to: now),
      last_24_hours: for_interval(from: now - 24.hours, to: now)
    }
  end

  def for_interval(from:, to:)
    query =
      @requests.
        where("requested_at >= ? and requested_at < ?", from, to)
    {
      clicks: count(query),
      unique_referrers: unique_count(query, :referrer),
      unique_ip_addresses: unique_count(query, :ip_address),
      top_referrers: top_n(query, :referrer),
      top_ip_addresses: top_n(query, :ip_address)
    }
  end

  private

  def count(query)
    query.count
  end

  def unique_count(query, attribute)
    query.count("DISTINCT #{attribute.to_s}")
  end

  def top_n(query, attribute)
    result =
      query.
        select("#{attribute.to_s}, count(*)").
        group(attribute).
        order("count(*) DESC").
        limit(@top_n)
    Hash[result.map { |r| [r[attribute], r.count] }]
  end

end
