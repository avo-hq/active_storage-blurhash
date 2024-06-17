require "active_storage/blurhash/analyzing"
require "active_storage/blurhash/thumbnail/image_magick"

module ActiveStorage
  module Blurhash
    module Analyzer
      class ImageMagick < ActiveStorage::Analyzer::ImageAnalyzer::ImageMagick
        include ActiveStorage::Blurhash::Analyzing

        protected 

        def processor = "ImageMagick"
      end
    end
  end
end
