require "rails_helper"

RSpec.describe Sequence::UnpredictableOrdering do
  it "produces an unpredicatable ordering of the underlying sequence, at least to the naive observer" do
    usg =
      Sequence::UnpredictableOrdering.new(
        base_sequence: (1..10).to_enum,
        max_value: 100,
        step: 87)
    seq = (1..10).map { |i| usg.next }
    expect(seq).to eq [87, 74, 61, 48, 35, 22, 9, 96, 83, 70]
  end
end
