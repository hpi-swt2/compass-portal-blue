require_relative "boot"

require "rails/all"
require "./app/assets/constants/locations"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Compass
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    config.i18n.available_locales = [:de, :en]

    config.i18n.default_locale = :en
    config.middleware.use I18n::JS::Middleware
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = Time.now.zone
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
