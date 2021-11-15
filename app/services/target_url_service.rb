class TargetUrlService
  class << self
    # creates a new TargetUrl with a new ShortUrl
    # @param url [String] Target URL
    # @return [Array<TargetUrl, ShortUrl>] created TargetUrl and ShortUrl.
    #    ShortUrl may be nil if TargetUrl is invalid
    def shorten(url)
      short_url = nil
      target_url = TargetUrl.find_or_initialize_by(url: url)
      return [target_url, nil] unless target_url.valid?

      target_url.title ||= get_url_title(target_url)
      target_url.save if target_url.errors.empty?
      short_url = target_url.short_urls.create if target_url.persisted?
      [target_url, short_url]
    end

    private

    def get_url_title(target_url)
      Mechanize.new.get(target_url.url).title
    rescue => e
      if e.message.match?(/Name or service not known/)
        target_url.errors.add(
          :url, :invalid, message: "could not be loaded (#{target_url.url})"
        )
      else
        target_url.errors.add(
          :base, :invalid, message: "URL error: #{e.message}"
        )
      end
      nil
    end
  end
end
