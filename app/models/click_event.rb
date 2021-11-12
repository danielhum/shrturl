class ClickEvent < ApplicationRecord
  belongs_to :short_url

  geocoded_by :ip_address
  after_commit :enqueue_geocode,
    if: ->(obj) do
      obj.ip_address.present? && obj.ip_address_previously_changed?
    end

  validates :short_url, presence: true

  def enqueue_geocode
    GeocodeClickEventJob.perform_later id
  end
end
