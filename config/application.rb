require_relative 'boot'

require "rails"
require "rails/all"
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
    config.autoload_paths += %W(#{config.root}/app)
    
    config.after_initialize do
      Dir.glob('./app/*/*/*.rb').each { |file| require file }
      
      include LoadDataspec
      include IndexManager
      
      sleep(1)
      Project.delete_all
      clear_all("nsadocs")
      load_all_dataspecs
      sleep(1)
      create_all_indexes
    end
  end
end
