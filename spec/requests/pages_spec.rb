require "rails_helper"

RSpec.describe "Pages", type: :request do
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
      expect(response.body)
        .to match(%r{
          <label\sfor="target_url_url">Your\sURL:</label>
          \s*
          <input\splaceholder="include\shttps://"\stype="text"\s
            name="target_url\[url\]"\sid="target_url_url"\s/>
        }x)
    end
  end

  describe "GET /s/:url_key" do
    let(:short_url) { FactoryBot.create(:short_url, url_key: "abc") }
    before { Timecop.freeze }
    after { Timecop.return }

    it "redirects to target URL and tracks click" do
      short_url

      expect { get "/s/abc" }.to have_enqueued_job(TrackClickEventJob)
        .with(
          short_url_id: short_url.id, ip_address: "127.0.0.1",
          created_at_in_seconds: Time.now.to_i
        )

      expect(response).to redirect_to short_url.target_url.url
    end

    it "raises ActiveRecord::RecordNotFound" do
      expect { get "/s/def" }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
