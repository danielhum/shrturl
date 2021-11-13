require "rails_helper"

RSpec.describe TargetUrl, type: :model do
  it "url should be valid" do
    target_url = FactoryBot.build(:target_url, url: nil)
    target_url.validate
    expect(target_url.errors.messages[:url].to_a)
      .to contain_exactly("can't be blank", "is invalid")

    target_url.url = "abc123"
    target_url.validate
    expect(target_url.errors.messages[:url].to_a)
      .to contain_exactly("is invalid")

    target_url.url = "https://coingecko.com"
    target_url.validate
    expect(target_url.valid?).to be_truthy
  end
end
