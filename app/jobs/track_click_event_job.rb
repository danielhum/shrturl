class TrackClickEventJob < ApplicationJob
  queue_as :default

  def perform(*args)
    attrs = args[0].symbolize_keys
    short_url = ShortUrl.find(attrs[:short_url_id])
    t = Time.at attrs[:created_at_in_seconds]
    short_url.click_events.create(
      ip_address: attrs[:ip_address], created_at: t, updated_at: t
    )
  end
end
