class PagesController < ApplicationController
  def home
    @target_url = TargetUrl.new
  end

  def short_redirect
    short_url = ShortUrl.find_by_url_key!(params[:url_key])

    track_click_event(short_url)

    redirect_to short_url.target_url.url
  end

  private

  def track_click_event(short_url)
    TrackClickEventJob.perform_later(
      short_url_id: short_url.id, ip_address: request.remote_ip,
      created_at_in_seconds: Time.now.to_i
    )
  end
end
