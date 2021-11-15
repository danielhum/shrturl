class ShortUrlsController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @short_urls = pagy(
      ShortUrl.order_by_clicks, items: 10, link_extra: 'data-remote="true"'
    )
  end

  def show
    @short_url = ShortUrl.find(params[:id])
    @pagy, @clicks = pagy(@short_url.click_events.order("created_at DESC"))
  end
end
