require "rails_helper"

RSpec.describe "TargetUrls", type: :request do
  describe "POST /create" do
    it "creates target_url with a short_url" do
      expect do
        post "/target_urls",
          params: {target_url: {url: "https://coingecko.com"}}
      end.to change(TargetUrl, :count).by(1)
      target_url = TargetUrl.last

      expect(response)
        .to redirect_to(
          target_url_path(
            target_url.id, new_short_url_id: target_url.short_urls.pick(:id)
          )
        )
      expect(target_url.short_urls.last.url_key).to_not be_empty
    end
  end

  describe "POST /target_urls/search" do
    it "redirects to matching target URL" do
      target_url = FactoryBot.create(:target_url)
      post "/target_urls/search",
        params: {target_url: {url: target_url.url}}
      expect(response).to redirect_to(target_url_path(target_url))
    end

    it "redirects to home with error" do
      post "/target_urls/search",
        params: {target_url: {url: "blah"}}
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to match(["Url is invalid"])
    end
  end

  describe "GET /target_urls/:id" do
    it "returns http success" do
      target_url = FactoryBot.create(:target_url)
      target_url.short_urls = FactoryBot.create_pair(:short_url)
      get "/target_urls/#{target_url.id}"
      expect(response).to have_http_status(:success)
      target_url.short_urls.each do |short_url|
        expect(response.body).to include(short_url.url)
      end
    end
  end
end
