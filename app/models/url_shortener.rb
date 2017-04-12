# Option for generating shortened URL:
# - Generator function.
#   - Map an int to a value.
#   - Requires int to be persisted and atomically incremented.
#   - Requires 2 DB I/O ops
#   - Could pre-generate and store available list in db
# - Random. Retry on collision.
# - Hash the source URL. Requires URL as param. But then how to conform to an alphabet?
class UrlShortener
  class << self
    def shorten(short_url_base:,
                key_length:,
                alphabet:)
      URI.join(short_url_base,
               random_key(key_length, alphabet))
    end

    private

    def random_key(length, alphabet)
      n = alphabet.size
      Array.new(length) { alphabet[Random.rand(n)] }.join
    end
  end
end
