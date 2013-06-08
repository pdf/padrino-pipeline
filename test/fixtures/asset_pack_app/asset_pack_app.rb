require 'padrino-core'
require 'padrino-assets'

class BaseApp < Sinatra::Base
  register Padrino::Assets

  configure do
    set :logging, false
    set :padrino_logging, false
    set :root, File.dirname(__FILE__)
  end

end

class AssetsAppAssetPack < BaseApp
  configure_assets do |config|
    config.pipeline   = Padrino::Assets::AssetPack
  end
  assets.js :application, '/assets/javascripts/application.js', ['/assets/javascripts/*.js']
end

class AssetsAppAssetPackCustom < BaseApp
  configure_assets do |config|
    config.pipeline   = Padrino::Assets::AssetPack
    config.js_prefix  = '/meow/javascripts'
    config.js_assets  = '/assets/js' 
  end

  assets do
    js :pack, ['assets/javascripts/*.js'] 
  end

end

Padrino.load!
