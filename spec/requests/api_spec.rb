require 'rails_helper'

describe "api", type: :request, aggregate_failures: true do

  describe "create URL" do
    it "succeeds" do
      allow(Random).to receive(:rand).with(4).and_return(0)

      post "/api/urls", params: { target_url: 'http://my.host/path?x=1' }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body, symbolize_names: true)).
        to match({ short_url: 'https://test.conjurl.com/aaaa' })
    end
  end
  
end
