module ActiveStorage
  module Blurhash
    module Thumbnail
      class ImageMagick
        delegate_missing_to :@thumbnail

        def initialize(image)
          @thumbnail = MiniMagick::Image.open(
            ::ImageProcessing::MiniMagick.source(image.path).resize_to_limit(200, 200).call.path
          )
        end

        def pixels
          @thumbnail.get_pixels.flatten
        end
      end
    end
  end
end
