require 'rails_helper'

describe "redirect behavior", type: :request, aggregate_failures: true do

  it "redirects to the target url" do
    ShortUrl.create!(key: 'aaaa',
                     target_url: 'http://some.where/else')

    get "/aaaa"
    expect(response).to have_http_status(301)
    expect(response.headers['location']).to eq 'http://some.where/else'    
  end
  
end
