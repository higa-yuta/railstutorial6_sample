require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Railstutorial6Sample
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # add_routing_pathはconfig/routes.rbファイルを読み込みルーティングをセットアップする
    initializer(:remove_action_mailbox_and_activestorage_and_turbo_routes, after: :add_routeing_paths) {|app|
      app.routes_reloader.paths.delete_if {|path| path =~ /activestorage/ }
      app.routes_reloader.paths.delete_if {|path| path =~ /actionmailbox/}
    }

    # NOTE:
    # app.routes_reloader
    # @paths=
    # ["/home/vagrant/workspace/railstutorial_app/config/routes.rb",
    # "/home/vagrant/.rbenv/versions/2.7.5/lib/ruby/gems/2.7.0/gems/turbo-rails-1.0.1/config/routes.rb",
    # "/home/vagrant/.rbenv/versions/2.7.5/lib/ruby/gems/2.7.0/gems/actionmailbox-7.0.2/config/routes.rb",
    # "/home/vagrant/.rbenv/versions/2.7.5/lib/ruby/gems/2.7.0/gems/activestorage-7.0.2/config/routes.rb"],


    # def routes_reloader
    #   @routes_reloader ||= RoutesReloader.new
    # end

    # RoutesReloader.new
    # def initialize
    #   @paths = []
    #   @routes_sets = []
    #   @eager_load = []
    # end


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
