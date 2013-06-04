module Padrino
  ##
  # Add public api docs here
  module Assets
    class << self
      def registered(app)
        require 'sprockets'
        require 'uglifier'
        require 'padrino-assets/ext/sprockets/environment'

        app.set :serve_assets, true
        app.set :assets, Sprockets::Environment.new
        app.settings.assets.append_path File.join(app.settings.root, 'assets', 'javascripts')
        app.settings.assets.append_path File.join(app.settings.root, 'assets', 'stylesheets')
        app.settings.assets.js_compressor  = Uglifier.new(mangle: true)
        app.settings.assets.js_prefix      = '/assets/javascripts'
        app.settings.assets.css_prefix     = '/assets/stylesheets'

        app.send(:mount_js_assets,  app.settings.assets.js_prefix)
        app.send(:mount_css_assets, app.settings.assets.css_prefix)
      end

      alias :included :registered

    end #class << self

    def configure_assets(&block)
      original_js_prefix  = assets.js_prefix
      original_css_prefix = assets.css_prefix

      yield assets if block_given?
      mount_js_assets(assets.js_prefix)   unless original_js_prefix  == assets.js_prefix
      mount_css_assets(assets.css_prefix) unless original_css_prefix == assets.css_prefix
    end

    private 
    def mount_js_assets(prefix)
      get "#{prefix}/:file.js" do
        content_type "application/javascript"
        settings.assets["#{params[:file]}.js"] || not_found
      end
    end

    def mount_css_assets(prefix)
      get "#{prefix}/:file.css" do
        content_type "text/css"
        settings.assets["#{params[:file]}.css"] || not_found
      end
    end

  end
end
