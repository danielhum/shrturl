require "rails_helper"

describe TargetUrlService do
  describe ".shorten!" do
    let(:url) { "https://coingecko.com" }

    it "creates new TargetUrl with a ShortUrl" do
      expect do
        described_class.shorten!(url)
      end.to change(TargetUrl, :count).by(1)
      target_url = TargetUrl.last
      expect(target_url.url).to eq url
      expect(target_url.short_urls.count).to eq 1
      expect(target_url.short_urls.first.url).to_not be_empty
    end

    it "returns existing TargetUrl" do
      existing = FactoryBot.create(:target_url)
      target_url = nil
      expect do
        target_url = described_class.shorten!(existing.url)
      end.to_not change(TargetUrl, :count)
      expect(target_url.id).to eq existing.id
    end

    it "raises ActiveRecord::RecordInvalid if invalid" do
      expect { described_class.shorten!("abc") }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
