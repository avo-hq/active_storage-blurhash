require "test_helper"

require "active_storage/blurhash/analyzer/vips"

class ActiveStorage::Blurhash::Analyzer::VipsTest < ActiveSupport::TestCase
  setup do
    ActiveStorage.variant_processor = :vips
  end

  test "analyzing with Vips" do
    blob = create_file_blob(filename: "tulips.jpg", content_type: "image/jpg")
    blob.analyze

    assert_equal 640, blob.metadata[:width]
    assert_equal 480, blob.metadata[:height]
    assert_equal "LDC$_jE#0hv%}?OVI:wJA@#m,sxt", blob.metadata[:blurhash]
  end
end
