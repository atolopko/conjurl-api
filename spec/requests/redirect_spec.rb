require 'rails_helper'

describe "redirect behavior and statistics", type: :request, aggregate_failures: true do
  include ApiResponseHelper
  include ApiAuthenticationHelper

  let!(:jwt) do
    post '/api/accounts/', name: 'Linkoln Longfellow'
    response_data[:jwt]
  end

  it "redirects to the target url and updates statistics" do
    post "/api/short_urls",
         params: { target_url: 'http://some.where/else' },
         headers: authorization_header
    expect(response).to have_http_status(200)
    short_url = response_data[:short_url]
    statistics_ref = response_data[:statistics_ref]

    get short_url
    expect(response).to have_http_status(301)
    expect(response.headers['location']).to eq 'http://some.where/else'

    get statistics_ref,
        headers: authorization_header
    expect(response_data[:lifetime][:clicks]).to eq 1
  end

end
