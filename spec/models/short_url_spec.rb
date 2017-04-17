require "rails_helper"

describe ShortUrl, aggregate_failures: true do
  let(:key_generator) {
    d = double("TestKeyGenerator")
    allow(d).to receive(:generate).and_return('aaaaaa')
    d
  }
  let!(:short_url) {
    ShortUrl.generate!(target_url: 'http://some.url/path',
                       account: nil,
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
                           account: nil,
                           key_generator: key_generator)
      }.to raise_error "ShortURL key collision: aaaaaa"
    end

    it "adds HTTP schema to target_url if missing" do
      allow(key_generator).to receive(:generate).and_return('aaaaab')
      short_url =
        ShortUrl.generate!(target_url: 'some.url/path',
                           account: nil,
                           key_generator: key_generator)
      expect(short_url.target_url).to eq 'http://some.url/path'
    end

    it "is invalid if target_url is not a valid URL" do
      allow(key_generator).to receive(:generate).and_return('aaaaab')
      expect {
        ShortUrl.generate!(target_url: 'xyz://notauri',
                           account: nil,
                           key_generator: key_generator)
      }.to raise_error ActiveRecord::RecordInvalid
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
