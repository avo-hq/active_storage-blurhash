require "active_storage/blurhash/analyzing"
require "active_storage/blurhash/thumbnail/vips"

module ActiveStorage
  module Blurhash
    module Analyzer
      class Vips < ActiveStorage::Analyzer::ImageAnalyzer::Vips
        include ActiveStorage::Blurhash::Analyzing

        protected
        
        def processor = "Vips"
      end
    end
  end
end
