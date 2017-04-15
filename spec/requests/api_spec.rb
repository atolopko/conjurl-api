require 'rails_helper'

describe "api", type: :request, aggregate_failures: true do

  before do
    ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 1, false)")
  end       

  describe "urls resource" do
    it "succeeds when creating and querying a short url" do
      now = Time.now

      expected_response =
        { self: %r{http://www.example.com/api/short_urls/aaad},
          created_at: now.utc.iso8601,
          short_url: "https://test.conjurl.com/aaad",
          target_url: "http://my.host/path?x=1" }

      Timecop.freeze(now) do
        post "/api/short_urls", params: { target_url: 'http://my.host/path?x=1' }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body, symbolize_names: true)).
          to match(expected_response)

        get "/api/short_urls/aaad"
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body, symbolize_names: true)).
          to match(expected_response)
      end
    end

    it "fails when key namespace is exhausted" do
      ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 256 + 1, false)")
      post "/api/short_urls", params: { target_url: 'http://my.host/path?x=1' }
      expect(response).to have_http_status(500)
      expect(JSON.parse(response.body, symbolize_names: true)).
        to match(
             status: 'internal_server_error',
             params: { target_url: 'http://my.host/path?x=1', controller: 'api/short_urls', action: 'create' },
             error: 'key namespace exhausted: 257 > 256')
    end
  end
  
end
