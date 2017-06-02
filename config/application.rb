require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JSON
  def self.is_json?(foo)
    begin
      return false unless foo.is_a?(String)
      JSON.parse(foo).all?
    rescue JSON::ParserError
      false
    end 
  end
end

module Ahecmodules
  class Application < Rails::Application
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

    config.action_mailer.default_url_options = { :host => "courses.arealahec.org" }
    config.action_mailer.delivery_method = :smtp

    config.action_mailer.smtp_settings = {
      :address        => 'smtp.sendgrid.net',
      :port           => '587',
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => 'courses.arealahec.org',
      :enable_starttls_auto => true 
    }

    Paperclip.options[:command_path] = "/usr/local/bin/" 
    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
        :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
        :bucket => ENV['S3_BUCKET_NAME'],
        :s3_region => ENV['AWS_REGION'],
        :s3_host_name => ENV['AWS_ENDPOINT']
      }
    }

    # Don't highlight text fields red on fail
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      html_tag
    }
  end
end
