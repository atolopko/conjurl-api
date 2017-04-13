require 'rails_helper.rb'

describe UrlShortener do
  it "returns a URL with the specified URL base with a random key of the specified length and composed of the specified alphabet " do
    shortened_url =
      UrlShortener.shorten(short_url_base: "http://conjurl.fun",
                           key_length: 8,
                           alphabet: ('a'..'z').to_a)
    expect(shortened_url.to_s).to match %r{http://conjurl.fun/[a-z]{8}}
  end
end
