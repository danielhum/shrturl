class TargetUrl < ApplicationRecord
  has_many :short_urls

  validates_presence_of :url
  validates :url, http_url: true
end
