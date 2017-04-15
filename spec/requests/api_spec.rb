require 'rails_helper'

describe "api", type: :request, aggregate_failures: true do

  before do
    ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 4)")
  end       

  describe "urls resource" do
    it "succeeds when creating and querying a short url" do
      now = Time.now

      expected_response =
        { self: %r{http://www.example.com/api/short_urls/bbbc},
          created_at: now.utc.iso8601,
          short_url: "https://test.conjurl.com/bbbc",
          target_url: "http://my.host/path?x=1" }

      Timecop.freeze(now) do
        post "/api/short_urls", params: { target_url: 'http://my.host/path?x=1' }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body, symbolize_names: true)).
          to match(expected_response)

        get "/api/short_urls/bbbc"
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body, symbolize_names: true)).
          to match(expected_response)
      end
    end

    it "fails when key namespace is exhausted" do
      ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 255)")
      post "/api/short_urls", params: { target_url: 'http://my.host/path?x=1' }
      expect(response).to have_http_status(500)
      expect(JSON.parse(response.body, symbolize_names: true)).
        to match(
             status: 'internal_server_error',
             params: { target_url: 'http://my.host/path?x=1', controller: 'api/short_urls', action: 'create' },
             error: 'key namespace exhausted: 256 > 255')
    end
  end
  
end
