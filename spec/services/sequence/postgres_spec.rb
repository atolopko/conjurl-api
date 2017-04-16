require "rails_helper"

RSpec.describe Sequence::Postgres do
  it "starts at 1" do
    ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 1, false)")
    expect(Sequence::Postgres.new(sequence_name: 'short_url_key_seq',
                                  max_value: 16).next).to eq 1
  end

  it "returns increasing values" do
    ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 1, false)")
    dsg = Sequence::Postgres.new(sequence_name: 'short_url_key_seq',
                                 max_value: 16)
    n1, n2 = [dsg.next, dsg.next]
    expect(n2).to be > n1
  end

  it "raises error when key namespace is exhausted" do
    ActiveRecord::Base.connection.execute("SELECT setval('short_url_key_seq', 16, false)")
    dsg = Sequence::Postgres.new(sequence_name: 'short_url_key_seq',
                                  max_value: 16)
    expect(dsg.next).not_to be_nil
    expect(dsg.next).to be_nil
  end
end
