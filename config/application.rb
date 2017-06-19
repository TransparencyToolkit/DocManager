require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"
load "app/dataspec/load_dataspec.rb"
load "app/index/index_manager.rb"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DocManager
  class Application < Rails::Application
    include LoadDataspec
    include IndexManager
    config.autoload_paths += %W(#{config.root}/app)
    Mongoid.load!("config/mongoid.yml")
    config.after_initialize do
      sleep(1)
#      clear_all("free_press_legal")
      load_all_dataspecs
      sleep(1)
      create_all_indexes
    end
  end
end
