require 'rails_helper'

describe "api", type: :request, aggregate_failures: true do
  include ApiResponseHelper
  include ApiAuthenticationHelper

  let(:account_response_data) do
    post '/api/accounts/', name: 'Linkoln Longfellow'
    response_data
  end
  let!(:jwt) { account_response_data[:jwt] }
  let!(:public_identifier) { account_response_data[:account][:public_identifier] }

  describe "short_urls resource" do
    it "succeeds when creating and querying a short url" do
      now = Time.now

      expected_response =
        {
          self_ref: 'http://www.example.com/api/short_urls/aaad',
          statistics_ref: 'http://www.example.com/api/short_urls/aaad/statistics',
          created_at: now.utc.iso8601,
          short_url: 'https://test.conjurl.com/aaad',
          target_url: 'http://my.host/path?x=1'
        }

      Timecop.freeze(now) do
        post '/api/short_urls',
             params: { target_url: 'http://my.host/path?x=1' },
             headers: authorization_header
      end

      expect(response).to have_http_status(:success)
      expect(response_data).to match(expected_response)
      
      get '/api/short_urls/aaad',
          headers: authorization_header
      expect(response).to have_http_status(:success)
      expect(response_data).to match(expected_response)
    end

    it "associates short url with account" do
      post '/api/short_urls',
           params: { target_url: 'http://my.host/path?x=1' },
           headers: authorization_header
           
      get "/api/accounts/#{public_identifier}",
          headers: authorization_header
      expect(response_data[:short_urls]).to eq 1
    end

    it "fails to create a new short url when key namespace is exhausted" do
      ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 256 + 1, false)")
      post '/api/short_urls',
           params: { target_url: 'http://my.host/path?x=1' },
           headers: authorization_header
      expect(response).to have_http_status(500)
      expect(response_data).
        to match(
             status: 'internal_server_error',
             params: { target_url: 'http://my.host/path?x=1', controller: 'api/short_urls', action: 'create' },
             error: 'key namespace exhausted (size=256)')
    end

    describe "unauthenticated access" do
      before do
        post '/api/short_urls',
             params: { target_url: 'http://my.host/path?x=1' }
      end

      it "allows guests to create short urls" do
        expect(response).to have_http_status(200)
      end

      it "does not allow guests to access querying endpoints" do
        get '/api/short_urls/aaad'
        expect(response).to have_http_status(401)

        get '/api/short_urls/aaad/statistics'
        expect(response).to have_http_status(401)
      end
    end  
  end

  describe "statistics endpoint" do
    it "returns correct statistics" do
      now = Time.now
      Timecop.freeze(now) do
        post '/api/short_urls',
             params: { target_url: 'http://my.host/path?x=1' },
             headers: authorization_header
      end

      expected_response =
        {
          self_ref: 'http://www.example.com/api/short_urls/aaad/statistics',
          short_url:
            {
              self_ref: 'http://www.example.com/api/short_urls/aaad',
              statistics_ref: 'http://www.example.com/api/short_urls/aaad/statistics',
              created_at: now.utc.iso8601,
              short_url: 'https://test.conjurl.com/aaad',
              target_url: 'http://my.host/path?x=1'
            },
          lifetime:
            {
              clicks: 0,
              unique_referrers: 0,
              unique_ip_addresses: 0,
              top_referrers: {},
              top_ip_addresses: {}
            },
          last_24_hours:
            {
              clicks: 0,
              unique_referrers: 0,
              unique_ip_addresses: 0,
              top_referrers: {},
              top_ip_addresses: {}
            }
        }

      get '/api/short_urls/aaad/statistics',
          headers: authorization_header
      expect(response).to have_http_status(:success)
      expect(response_data).to match(expected_response)
    end
  end
 
end
