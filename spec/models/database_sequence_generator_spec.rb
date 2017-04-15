require "rails_helper"

RSpec.describe DatabaseSequenceGenerator do
  it "starts at 1" do
    ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 1, false)")
    expect(DatabaseSequenceGenerator.new(key_namespace_size: 16).next).to eq 1
  end

  it "returns increasing values" do
    ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 1, false)")
    dsg = DatabaseSequenceGenerator.new(key_namespace_size: 16)
    n1, n2 = [dsg.next, dsg.next]
    expect(n2).to be > n1
  end

  it "raises error when key namespace is exhausted" do
    ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 16, false)")
    dsg = DatabaseSequenceGenerator.new(key_namespace_size: 16)
    expect { dsg.next }.not_to raise_error
    expect { dsg.next }.to raise_error "key namespace exhausted: 17 > 16"
  end
end
