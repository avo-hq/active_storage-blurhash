require "test_helper"

require "active_storage/blurhash/analyzer/image_magick"

class ActiveStorage::Blurhash::Analyzer::ImageMagickTest < ActiveSupport::TestCase
  setup do
    ActiveStorage.variant_processor = :mini_magick
  end

  test "analyzing with ImageMagick" do
    blob = create_file_blob(filename: "tulips.jpg", content_type: "image/jpg")
    blob.analyze

    assert_equal 640, blob.metadata[:width]
    assert_equal 480, blob.metadata[:height]
    assert_equal "LDC$_jE#0hv%}?OBI:wJA@#m,sxt", blob.metadata[:blurhash]
  end
end
