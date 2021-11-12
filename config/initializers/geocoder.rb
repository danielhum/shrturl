if Rails.env.test?
  Geocoder.configure(lookup: :test, ip_lookup: :test)
  GEOCODER_TEST_IPS = {
    "123.456.7.1" => [40.7143528, -74.0059731]
  }
  GEOCODER_TEST_IPS.each do |ip, coordinates|
    Geocoder::Lookup::Test.add_stub(
      ip, [
        {
          "coordinates" => coordinates
          # "address" => "New York, NY, USA",
          # "state" => "New York",
          # "state_code" => "NY",
          # "country" => "United States",
          # "country_code" => "US"
        }
      ]
    )
  end
end
