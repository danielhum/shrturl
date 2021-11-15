class ClickEvent < ApplicationRecord
  belongs_to :short_url

  geocoded_by :ip_address do |click, results|
    geo = results.first
    if geo
      %i[latitude longitude city state country].each do |attr_name|
        click.send("#{attr_name}=", geo.send(attr_name))
      end
    end
    click
  end
  after_commit :enqueue_geocode,
    if: ->(obj) do
      obj.ip_address.present? && obj.ip_address_previously_changed?
    end

  validates :short_url, presence: true

  # TODO: https://github.com/alexreisner/geocoder/blob/master/README_API_GUIDE.md#ip-apicom-ipapi_com

  def enqueue_geocode
    GeocodeClickEventJob.perform_later id
  end

  def coordinates
    [latitude, longitude].compact.join(", ")
  end

  def locality
    [city, state, country].compact.join(", ")
  end
end
