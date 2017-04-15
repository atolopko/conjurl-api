require 'rails_helper'

describe "redirect behavior and statistics", type: :request, aggregate_failures: true do

  it "redirects to the target url and updates statistics" do
    ShortUrl.create!(key: 'aaaa',
                     target_url: 'http://some.where/else')

    get "/aaaa"
    expect(response).to have_http_status(301)
    expect(response.headers['location']).to eq 'http://some.where/else'

    get '/api/short_urls/aaaa/statistics'
    body_hash = JSON.parse(response.body, symbolize_names: true)
      expect(body_hash[:lifetime][:clicks]).to eq 1
  end

end
