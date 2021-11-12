require "rails_helper"

RSpec.describe GeocodeClickEventJob, type: :job do
  let(:click_event) { FactoryBot.create(:click_event) }
  it "#perform" do
    click_event.update_columns(latitude: nil, longitude: nil)

    described_class.new.perform(click_event.id)

    click_event.reload
    coords = Geocoder.search(click_event.ip_address).first.coordinates
    expect(click_event.latitude).to eq coords[0]
    expect(click_event.longitude).to eq coords[1]
  end
end
