require "tinymce/rails"

module Trestle
  module TinyMCE
    class Engine < Rails::Engine
      initializer "trestle.tinymce.sprockets" do
        config.assets.precompile << "trestle/tinymce.manifest.js" # Sprockets 4 manifest
        config.assets.precompile << "trestle/tinymce.js"          # Sprockets 3
      end if defined?(Sprockets)
    end
  end
end
