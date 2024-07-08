# frozen_string_literal: true

module BlurhashImageHelper
  def blurhash_image_tag(source, options = {})
    case source
    when String
      # if a URL is passed, we have to manually re-hydrate the blob from it
      path_parameters = Rails.application.routes.recognize_path(source)
      blob = ActiveStorage::Blob.find_signed!(path_parameters[:signed_blob_id] || path_parameters[:signed_id])
    when ActiveStorage::Blob
      blob = source
    when ActiveStorage::Attached::One
      blob = source.blob
    when ActiveStorage::VariantWithRecord
      blob = source.blob
      # dimensions of the transformation need not represent the actual aspect ratio, like in `resize_to_fit`
      # size = source.variation.transformations[:resize]
    end

    blurhash = blob.metadata["blurhash"]
    size ||= "#{blob.metadata["width"]}x#{blob.metadata["height"]}"

    if !!blurhash
      options[:loading] = "lazy"
      options[:size] = size

      wrapper_class = options.delete(:wrapper_class)
      canvas_class = options.delete(:canvas_class)
      tag.div class: wrapper_class, data: {blurhash: blurhash}, style: "position: relative" do
        image_tag(source, options) + tag.canvas(style: "position: absolute; inset: 0; transition-property: opacity; transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1); transition-duration: 150ms;", class: canvas_class)
      end
    else
      image_tag(source, options)
    end
  rescue ActionController::RoutingError
    image_tag(source, options)
  end
end
