class ShortUrl < ApplicationRecord
  belongs_to :target_url
  has_many :click_events

  UPDATE_URL_KEY_RETRY_COUNT = 10

  before_validation :update_url_key!

  validates_presence_of :url_key
  validates_length_of :url_key, maximum: 15
  # note: unique validation of url_key handled by DB unique index

  scope :order_by_clicks, -> do
    select("short_urls.*, COUNT(click_events.id) as clicks_count")
      .left_joins(:click_events).group(:id).order("COUNT(click_events.id) DESC")
  end

  def update_url_key!
    return false if url_key.present?

    retry_count = 0
    begin
      max_len = 7 + retry_count / 5
      self.url_key = SecureRandom.alphanumeric(max_len)
      save!
    rescue ActiveRecord::RecordNotUnique
      retry_count += 1
      retry unless retry_count > UPDATE_URL_KEY_RETRY_COUNT
      raise
    end
  end

  def url
    Rails.application.routes.url_helpers.short_redirect_url(url_key: url_key)
  end
end
