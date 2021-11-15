require "rails_helper"

RSpec.describe GeocodeClickEventJob, type: :job do
  let(:click_event) { FactoryBot.create(:click_event) }
  it "#perform" do
    click_event.update_columns(latitude: nil, longitude: nil)

    described_class.new.perform(click_event.id)

    click_event.reload
    expect(click_event.latitude).to eq 40.7143528
    expect(click_event.longitude).to eq(-74.0059731)
  end
end
