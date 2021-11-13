require "rails_helper"

RSpec.describe ShortUrl, type: :model do
  it "url_key should be unique" do
    FactoryBot.create(:short_url, url_key: "abc")
    expect { FactoryBot.create(:short_url, url_key: "abc") }
      .to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "populates url_key" do
    short_url = FactoryBot.build(:short_url, url_key: nil)
    short_url.validate
    expect(short_url.url_key).to_not be_blank
  end

  describe "#update_url_key!" do
    let(:target_url) { FactoryBot.create(:target_url) }

    it "should retry on collision" do
      short_url = FactoryBot.build(:short_url, target_url: target_url)

      expect(SecureRandom).to receive(:alphanumeric).and_return("abc", "def")
      expect(short_url)
        .to receive(:save!).and_raise(ActiveRecord::RecordNotUnique).once
      expect(short_url)
        .to receive(:save!).and_call_original

      short_url.update_url_key!

      expect(short_url.persisted?).to be_truthy
      expect(short_url.url_key).to eq "def"
    end

    it "should raise error after exceeding 10 retries" do
      short_url = FactoryBot.build(:short_url, target_url: target_url)
      expect(short_url)
        .to receive(:save!)
        .and_raise(ActiveRecord::RecordNotUnique).exactly(11).times

      expect do
        short_url.update_url_key!
      end.to raise_error(ActiveRecord::RecordNotUnique)

      # starts with 7 characters, then adds 1 for every 5 retries
      expect(short_url.url_key.size).to eq 9
    end
  end

  it "#url" do
    short_url = FactoryBot.build(:short_url, url_key: "abc")
    expect(short_url.url).to eq "http://lvh.me:3000/s/abc"
  end
end
