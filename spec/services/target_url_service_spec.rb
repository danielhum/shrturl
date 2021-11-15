require "rails_helper"

describe TargetUrlService do
  describe ".shorten" do
    let(:url) { "https://coingecko.com" }

    it "creates new TargetUrl with a ShortUrl" do
      target_url = nil
      new_short_url = nil
      expect do
        target_url, new_short_url = described_class.shorten(url)
      end.to change(TargetUrl, :count).by(1)
      expect(target_url.url).to eq url
      expect(target_url.short_urls.first).to eq new_short_url
      expect(new_short_url.url).to_not be_empty
    end

    it "returns existing TargetUrl" do
      existing = FactoryBot.create(:target_url)
      existing_short_url_count = existing.short_urls.count
      target_url = nil
      expect do
        target_url, _ = described_class.shorten(existing.url)
      end.to_not change(TargetUrl, :count)
      expect(target_url.id).to eq existing.id
      expect(target_url.short_urls.count).to eq existing_short_url_count + 1
    end

    it "returns unsaved record with errors if invalid" do
      target_url, short_url = described_class.shorten("abc")
      expect(target_url.persisted?).to be_falsey
      expect(target_url.errors.messages[:url]).to include "is invalid"
      expect(short_url).to be_nil
    end
  end
end
