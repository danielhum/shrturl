class ClickEvent < ApplicationRecord
  belongs_to :short_url

  geocoded_by :ip_address
  after_validation :geocode
end
