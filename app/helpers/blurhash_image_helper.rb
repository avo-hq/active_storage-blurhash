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
    when ActiveStorage::Attachment
      blob = source.blob
    when ActiveStorage::Attached::One
      blob = source.blob
    when ActiveStorage::VariantWithRecord
      blob = source.blob

      if source.variation.transformations[:resize_to_limit] && source.blob.analyzed?
        original_width = blob.metadata["width"]
        original_height = blob.metadata["height"]
        limit_width, limit_height = source.variation.transformations[:resize_to_limit]

        scale = [limit_width.to_f / original_width, limit_height.to_f / original_height].min
        actual_width = (original_width * scale).round
        actual_height = (original_height * scale).round

        size = "#{actual_width}x#{actual_height}"
      else
        size = source.variation.transformations[:resize]
      end
    end

    blurhash = blob&.metadata&.fetch("blurhash", nil)

    if !!blurhash
      size ||= "#{blob.metadata["width"]}x#{blob.metadata["height"]}"

      options[:loading] = "lazy"
      options[:size] = size

      wrapper_class = options.delete(:wrapper_class)
      canvas_class = options.delete(:canvas_class)
      wrapper_style = options.delete(:wrapper_style)
      width, height = size.split("x")
      tag.div class: wrapper_class, data: {blurhash: blurhash}, style: "position: relative;#{wrapper_style}" do
        image_tag(source, options) +
          tag.canvas(
            height:, width:,
            style: "position: absolute; inset: 0; transition-property: opacity; transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1); transition-duration: 150ms;",
            class: canvas_class
          )
      end
    else
      image_tag(source, options)
    end
  rescue ActionController::RoutingError
    image_tag(source, options)
  end
end
