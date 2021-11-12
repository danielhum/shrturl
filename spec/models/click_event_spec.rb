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
end
