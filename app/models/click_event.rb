class ClickEvent < ApplicationRecord
  belongs_to :short_url

  geocoded_by :ip_address
  after_validation :geocode,
    if: ->(obj) { obj.ip_address.present? && obj.ip_address_changed? } # TODO: in background

  validates :short_url, presence: true
end
