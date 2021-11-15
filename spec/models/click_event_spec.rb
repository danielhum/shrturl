require "rails_helper"

RSpec.describe ClickEvent, type: :model do
  describe "after_commit callback" do
    let(:click_event) { FactoryBot.build(:click_event) }
    it "enqueues geocode job if needed" do
      allow(GeocodeClickEventJob).to receive(:perform_later)

      click_event.save

      expect(GeocodeClickEventJob)
        .to have_received(:perform_later).with(click_event.id)
    end
  end

  it "#geocode" do
    click_event = FactoryBot.build(:click_event,
      ip_address: GEOCODER_TEST_IPS.keys[0], latitude: 0, longitude: 0,
      city: nil, state: nil, country: nil)

    click_event.geocode

    # lookup stubbed in config/initializers/geocoder.rb
    expect(click_event.latitude).to eq 40.7143528
    expect(click_event.longitude).to eq(-74.0059731)
    expect(click_event.city).to eq "Los Angeles"
    expect(click_event.state).to eq "California"
    expect(click_event.country).to eq "United States"
  end
end
