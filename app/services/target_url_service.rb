class TargetUrlService
  class << self
    # creates a new TargetUrl with a new ShortUrl
    # @param url [String] Target URL
    # @return [TargetUrl, ShortUrl] created TargetUrl and ShortUrl.
    #                               ShortUrl may be nil if TargetUrl is invalid
    def shorten(url)
      target_url = TargetUrl.find_or_initialize_by(url: url)
      if target_url.persisted? || target_url.save
        short_url = target_url.short_urls.create
      end
      [target_url, short_url]
    end
  end
end
