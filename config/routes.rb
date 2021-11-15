require "sidekiq/web"

Rails.application.routes.draw do
  resources :target_urls, only: %i[create show]
  scope :target_urls do
    post "search", to: "target_urls#search", as: :target_urls_search
  end
  resources :short_urls, only: %i[index show]
  get "s/:url_key", to: "pages#short_redirect", as: :short_redirect

  root to: "pages#home"

  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
      ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(username),
        ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USERNAME"])
      ) & ActiveSupport::SecurityUtils.secure_compare(
        ::Digest::SHA256.hexdigest(password),
        ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"])
      )
    end
  end
  mount Sidekiq::Web => "/sidekiq"
end
