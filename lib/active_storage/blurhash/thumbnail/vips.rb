module ActiveStorage
  module Blurhash
    module Thumbnail
      class Vips
        delegate_missing_to :@thumbnail

        def initialize(image)
          @thumbnail = ::Vips::Image.new_from_file(
            ::ImageProcessing::Vips.source(image.filename).resize_to_limit(200, 200).call.path
          )
        end

        def pixels
          @thumbnail.write_to_memory.unpack("C*")
        end
      end
    end
  end
end
