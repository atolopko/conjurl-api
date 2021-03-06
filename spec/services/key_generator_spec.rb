require "rails_helper"

RSpec.describe KeyGenerator, aggregate_failures: true do
  let(:key_generator) {
    generator =
      KeyGenerator.new(key_length: 4,
                       alphabet: ('a'..'d').to_a,
                       sequence: (100..101).to_enum)
  }

  it "converts string to a short key" do
    expect(key_generator.generate).to eq 'bcba'
    expect(key_generator.generate).to eq 'bcbb'
  end

  it "always produces full-length key" do
    key_generator =
      KeyGenerator.new(key_length: 4,
                       alphabet: ('a'..'d').to_a,
                       sequence: [0].cycle)
    expect(key_generator.generate).to eq 'aaaa'
  end
  
end
