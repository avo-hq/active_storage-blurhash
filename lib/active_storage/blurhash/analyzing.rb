require "active_storage/blurhash/encoder"

module ActiveStorage
  module Blurhash
    module Analyzing
      attr_accessor :thumbnail

      def metadata
        # we could also re-implement #metadata, so that the image is only read once, but it's much less DRY
        read_image do |image|
          build_thumbnail(image)
          super.merge blurhash
        end
      end

      def blurhash
        pixels = thumbnail.pixels
        {
          blurhash: ::ActiveStorage::Blurhash::Encoder.blurHashForPixels(
            4, 3,
            thumbnail.width,
            thumbnail.height,
            pixels,
            thumbnail.width * 3
          )
        }
      end

      def build_thumbnail(image)
        # we scale down the image for faster blurhash processing
        @thumbnail ||= "ActiveStorage::Blurhash::Thumbnail::#{processor}".constantize.new(image)
      end
    end
  end
end
