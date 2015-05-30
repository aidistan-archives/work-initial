require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Initial
  class Application < Rails::Application
    # Parse XML automatically
    config.middleware.insert_after ActionDispatch::ParamsParser, ActionDispatch::XmlParamsParser

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Weixin-related constants
    config.weixin = Struct.new(
      :appid, :appsecret, :token,
      :access_token, :access_token_expires_in,
      :jsapi_ticket, :jsapi_ticket_expires_in
    ).new(
      'wxd1a185128b918ca2',
      'c5cb5505799a68988565a71e8c04c5fa',
      'TiZV27gJjde7W78gX7FoP4nvNwBdaPTi',
      nil, 0, nil, 0
    )

    # Dynamic fields
    config.weixin.access_token = "IXiuqnZLbqBBuy8dh0MNG7CiG-VAen5GAmuu5DGAhjifLsQx9pcNLFYPqXJvZ_v1wSw1zyak_Gn70yuy6k1WmEO4nEu6BYHaGFv-GoTXTUs"
    config.weixin.access_token_expires_in = 1432974990 # 2015-05-30 16:36:30 +0800
  end
end
