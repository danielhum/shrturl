require "rails_helper"

RSpec.describe TrackClickEventJob, type: :job do
  it "#perform" do
    t = Time.now
    short_url = FactoryBot.create(:short_url)
    click_attrs =
      {short_url_id: short_url.id, ip_address: "192.168.1.1",
       created_at_in_seconds: t.to_i}

    Timecop.travel(t + 1.hour) # simulate delay
    expect { described_class.new.perform(click_attrs) }
      .to change(ClickEvent, :count).by(1)

    click_event = ClickEvent.last
    expect(click_event.short_url).to eq short_url
    expect(click_event.ip_address).to eq "192.168.1.1"
    expect(click_event.created_at).to be_within(1.second).of(t)
    expect(click_event.updated_at).to be_within(1.second).of(t)
  end
end
