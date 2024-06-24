# frozen_string_literal: true

namespace :active_storage_blurhash do
  desc "Backfill blurhash metadata for existing ActiveStorage image attachments"
  task backfill: :environment do
    batch_size = ENV["BATCH_SIZE"]&.to_i || 1000

    ActiveStorage::Attachment
      .joins(:blob)
      .where("content_type LIKE ?", "image/%")
      .find_each(batch_size: batch_size) do |attachment|
      attachment.analyze_later
    end
  end
end
