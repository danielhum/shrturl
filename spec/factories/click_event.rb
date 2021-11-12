FactoryBot.define do
  factory :click_event do
    ip_address { GEOCODER_TEST_IPS.keys[0] }
    short_url

    trait :with_latlng do
      latitude { GEOCODER_TEST_IPS.values[0][0] }
      longitude { GEOCODER_TEST_IPS.values[0][1] }
    end
  end
end
