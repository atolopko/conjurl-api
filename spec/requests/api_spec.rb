require 'rails_helper'

describe "api", type: :request, aggregate_failures: true do

  describe "urls resource" do
    it "succeeds when creating and querying a short url" do
      allow(Random).to receive(:rand).with(4).and_return(0)

      now = Time.now

      expected_response =
        { self: %r{http://www.example.com/api/short_urls/\d+},
          created_at: now.utc.iso8601,
          short_url: "https://test.conjurl.com/aaaa",
          target_url: "http://my.host/path?x=1" }

      Timecop.freeze(now) do
        post "/api/short_urls", params: { target_url: 'http://my.host/path?x=1' }

        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body, symbolize_names: true)).
          to match(expected_response)

        get "/api/short_urls", params: { short_url_key: 'aaaa' }
        expect(response).to have_http_status(:success)
        expect(JSON.parse(response.body, symbolize_names: true)).
          to match(expected_response)
      end
    end
  end
  
end
