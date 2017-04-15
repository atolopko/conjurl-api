require "rails_helper"

describe ShortUrl, aggregate_failures: true do
  let(:key_generator) {
    d = double("TestKeyGenerator")
    allow(d).to receive(:generate).and_return('aaaaaa')
    d
  }
  let!(:short_url) {
    ShortUrl.generate!(target_url: 'http://some.url/path',
                       key_generator: key_generator)
  }

  describe ".generate!" do
    it "creates and persists a new ShortUrl" do
      expect(short_url).to be_present
      expect(ShortUrl.find_by(key: 'aaaaaa')).to be_present
    end

    it "raises error if unique key cannot be generated" do
      expect {
        ShortUrl.generate!(target_url: 'http://some.url/path',
                           key_generator: key_generator)
      }.to raise_error "ShortURL key collision: aaaaaa"
    end
  end

  describe ".[]" do
    it "finds ShortUrl by short_url_key" do
      expect(ShortUrl['aaaaaa']).to be_present
    end

    it "raises error if specified ShortUrl does not exist" do
      expect { ShortUrl['aaaaab'] }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
