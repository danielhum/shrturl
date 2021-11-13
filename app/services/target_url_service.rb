class TargetUrlService
  class << self
    # creates a new TargetUrl with a ShortUrl, or returns existing TargetUrl
    # @param url [String] Target URL
    # @raise [ActiveRecord::RecordInvalid] if provided URL is invalid
    def shorten!(url)
      target_url = TargetUrl.find_or_initialize_by(url: url)
      return target_url if target_url.persisted?

      target_url.save
      target_url.short_urls.create if target_url.persisted?
      target_url
    end
  end
end
