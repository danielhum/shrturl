class ShortUrl < ApplicationRecord
  belongs_to :target_url
  has_many :click_events
end
