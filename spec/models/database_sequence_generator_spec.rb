require "rails_helper"

RSpec.describe DatabaseSequenceGenerator do
  it "returns increasing values" do
    dsg = DatabaseSequenceGenerator.new
    n1, n2 = [dsg.next, dsg.next]
    expect(n2).to be > n1
  end
end
