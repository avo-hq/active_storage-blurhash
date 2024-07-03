# frozen_string_literal: true

require "test_helper"

BLOB_URL = "http://test.host/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--ac8251860f17b296fab2d818b444ca954a0fea8b/tulips.jpg".freeze

class BlurhashImageHelperTest < ActionView::TestCase
  test "falls back to a regular image_tag when passed an arbitrary asset" do
    html = blurhash_image_tag("image.png")

    assert_equal '<img src="/images/image.png" />', html
  end

  test "falls back to a regular image_tag when blurhash isn't present in the blob's metadata" do
    blob = create_file_blob(filename: "tulips.jpg", content_type: "image/jpg")

    html = blurhash_image_tag(blob)

    assert_equal "<img src=\"#{BLOB_URL}\" />", html
  end

  test "resolves an analyzed blob" do
    blob = prepare_analyzed_blob

    element = Nokogiri::HTML.fragment(blurhash_image_tag(blob))

    assert_output(element, blob)
  end

  test "resolves an analyzed attachment" do
    blob = prepare_analyzed_blob
    post = Post.create
    post.feature_image.attach(blob)

    element = Nokogiri::HTML.fragment(blurhash_image_tag(post.feature_image))

    assert_output(element, blob)
  end

  test "resolves an analyzed attachment variant" do
    blob = prepare_analyzed_blob
    post = Post.create
    post.feature_image.attach(blob)

    element = Nokogiri::HTML.fragment(blurhash_image_tag(post.feature_image.variant(resize: "400x300")))

    # we have to make sure the resized dimensions are applied
    assert_output(element, blob, "http://test.host/rails/active_storage/representations/redirect/eyJfcmFpbHMiOnsiZGF0YSI6MSwicHVyIjoiYmxvYl9pZCJ9fQ==--ac8251860f17b296fab2d818b444ca954a0fea8b/eyJfcmFpbHMiOnsiZGF0YSI6eyJmb3JtYXQiOiJqcGciLCJyZXNpemUiOiI0MDB4MzAwIn0sInB1ciI6InZhcmlhdGlvbiJ9fQ==--f8ff65afca51460106c567410f3a29d540c0413e/tulips.jpg", 400, 300)
  end

  test "resolves a blob from a URL" do
    blob = prepare_analyzed_blob

    element = Nokogiri::HTML.fragment(blurhash_image_tag(BLOB_URL))

    assert_output(element, blob)
  end

  test "passes wrapper css classes" do
    blob = prepare_analyzed_blob

    element = Nokogiri::HTML.fragment(blurhash_image_tag(blob, wrapper_class: "thumbnail"))

    wrapper = element.css("div").first

    assert_equal "thumbnail", wrapper["class"]
  end

  test "passes canvas css classes" do
    blob = prepare_analyzed_blob

    element = Nokogiri::HTML.fragment(blurhash_image_tag(blob, canvas_class: "overflow-auto"))

    canvas = element.css("canvas").first

    assert_equal "overflow-auto", canvas["class"]
  end

  test "passes options to image_tag" do
    blob = prepare_analyzed_blob

    element = Nokogiri::HTML.fragment(blurhash_image_tag(blob, class: "object-contain", data: {controller: "hover"}, alt: "Tulips", fetchpriority: "low"))

    image = element.css("img").first

    assert_equal "object-contain", image["class"]
    assert_equal "hover", image["data-controller"]
    assert_equal "Tulips", image["alt"]
    assert_equal "low", image["fetchpriority"]
  end

  private

  def assert_output(element, blob, url = BLOB_URL, width = blob.metadata["width"], height = blob.metadata["height"])
    wrapper = element.css("div").first
    image = wrapper.css("img").first

    assert_equal blob.metadata["blurhash"], wrapper["data-blurhash"]
    assert_equal width, image["width"].to_i
    assert_equal height, image["height"].to_i
    assert_equal "lazy", image["loading"]
    assert_equal url, image["src"]
  end

  def prepare_analyzed_blob
    blob = create_file_blob(filename: "tulips.jpg", content_type: "image/jpg")
    blob.analyze

    blob
  end
end
