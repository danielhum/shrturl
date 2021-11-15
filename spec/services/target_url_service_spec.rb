require "rails_helper"

describe TargetUrlService do
  describe ".shorten" do
    let(:url) { "https://coingecko.com" }

    before do
      allow(TargetUrlService).to receive(:get_url_title).and_return "Title"
    end

    it "creates new TargetUrl with a ShortUrl" do
      target_url = nil
      new_short_url = nil
      allow(TargetUrlService).to receive(:get_url_title).and_call_original
      mechanize = double("mechanize")
      page = double("page", title: "Cryptocurrency | CoinGecko")
      expect(Mechanize).to receive(:new).and_return(mechanize)
      expect(mechanize).to receive(:get).with(url).and_return(page)
      expect do
        target_url, new_short_url = described_class.shorten(url)
      end.to change(TargetUrl, :count).by(1)
      expect(target_url.url).to eq url
      expect(target_url.title).to include "CoinGecko"
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

    it "populates error message if URL failed to load" do
      url = "https://congecko.com"
      allow(TargetUrlService).to receive(:get_url_title).and_call_original
      mechanize = double("mechanize")
      expect(Mechanize).to receive(:new).and_return(mechanize)
      expect(mechanize).to receive(:get).with(url)
        .and_raise(SocketError.new("getaddrinfo: Name or service not known"))
      target_url, _ = described_class.shorten(url)
      expect(target_url.errors.messages[:url].join(" "))
        .to include "could not be loaded"
    end
  end
end
