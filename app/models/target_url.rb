class TargetUrl < ApplicationRecord
  has_many :short_urls

  validates_presence_of :url
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
end
