require "rails_helper"

RSpec.describe UnpredictableSequenceGenerator do
  it "produces an unpredicatable sequence to the naive observer" do
    usg =
      UnpredictableSequenceGenerator.new(base_generator: (1..10).to_enum,
                                         key_namespace_size: 100,
                                         step: 87)
    seq = (1..10).map { |i| usg.next }
    expect(seq).to eq [87, 74, 61, 48, 35, 22, 9, 96, 83, 70]
  end
end
