require 'rails_helper'

RSpec.describe Account, type: :model do
  it "can be created and persisted" do
    account = Account.create!(name: 'Linkoln Longfellow')
    account.reload
    expect(account.name).to eq 'Linkoln Longfellow'
    expect(account.public_identifier).to_not be_nil
  end
end
