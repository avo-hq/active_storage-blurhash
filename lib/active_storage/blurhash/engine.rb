require "active_storage/blurhash/analyzer/image_magick"
require "active_storage/blurhash/analyzer/vips"

module ActiveStorage
  module Blurhash
    class Engine < ::Rails::Engine
      initializer "active_storage-blurhash.analyze" do
        Rails.application.config.active_storage.analyzers.prepend ActiveStorage::Blurhash::Analyzer::ImageMagick
        Rails.application.config.active_storage.analyzers.prepend ActiveStorage::Blurhash::Analyzer::Vips
      end
    end
  end
end
