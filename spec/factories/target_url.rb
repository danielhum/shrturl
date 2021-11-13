FactoryBot.define do
  factory :target_url do
    url { "https://#{Faker::Alphanumeric.alphanumeric}.com" }
  end
end
