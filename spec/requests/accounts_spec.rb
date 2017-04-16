require "rails_helper"

RSpec.describe "Accounts" do
  include ApiResponseHelper
  
  it "supports new account creation and retrieval" do
    now = Time.now.round

    Timecop.freeze(now) do
      post '/api/accounts/', name: 'Linkoln Longfellow'
    end
    expect(response).to have_http_status(:success)
    expect(response_data).
      to match(
           {
             jwt: /.+/,
             account: {
               self_ref: %r{http://www.example.com/api/accounts/.+},
               created_at: now.utc.iso8601,
               public_identifier: /.+/,
               name: 'Linkoln Longfellow',
               short_urls_ref: %r{http://www.example.com/api/accounts/.+/short_urls},
               short_urls: 0 
             }
           })
    
    get "/api/accounts/#{response_data[:account][:public_identifier]}",
        headers: { 'Authorization' => "Bearer #{response_data[:jwt]}" }
    expect(response).to have_http_status(:success)
    expect(response_data).
      to match(
           {
             self_ref: %r{http://www.example.com/api/accounts/.+},
             created_at: now.utc.iso8601,
             public_identifier: /.+/,
             name: 'Linkoln Longfellow',
             short_urls_ref: %r{http://www.example.com/api/accounts/.+/short_urls},
             short_urls: 0
           })
  end

  it "protects against unauthenticated access" do
    post '/api/accounts/', name: 'Linkoln Longfellow'
    public_identifier = response_data[:account][:public_identifier]
    get "/api/accounts/#{public_identifier}"
    expect(response).to have_http_status(401)
  end

  it "protects against unauthorized access" do
    post '/api/accounts/', name: 'Linkoln Longfellow'
    victim_public_identifier = response_data[:account][:public_identifier]
    post '/api/accounts/', name: 'Attacker'
    attacker_jwt = response_data[:jwt]
    get "/api/accounts/#{victim_public_identifier}",
        headers: { 'Authorization' => "Bearer #{attacker_jwt}" }
    expect(response).to have_http_status(403)
  end

end
