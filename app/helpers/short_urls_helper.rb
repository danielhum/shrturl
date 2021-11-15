module ShortUrlsHelper
  def sanitize_report_content(str)
    str.present? ? str : content_tag(:em, "[unknown]", class: "text-muted")
  end
end
