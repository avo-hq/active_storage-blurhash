# ActiveStorage::Blurhash

A [blurhash](https://blurha.sh/) integration for images stored in ActiveStorage. 

## Motivation
Elimination of layout shift and speeding up First/Largest Contentful Paint are among the primary goals for improving Core Web Vitals. For both scenarios, lazy loading images while displaying a temporary Blurhash before swapping it out for the actual image is a great way to enhance the loading experience and perceived performance.

## Usage

Suppose we have a simple `Person` model containing an `avatar` attachment:

```rb
class Person < ApplicationRecord
  has_one_attached :avatar
end
```

Simply swap out `image_tag` for `blurhash_image_tag` when displaying it:

```erb
<%= blurhash_image_tag person.avatar %>
```

This will create a wrapper `<div>` containing a `<canvas>` that is going to be painted with the respective blurhash.

Make sure to run the install generator and backfill any existing attachments (see below). New attachments should be automatically analyzed to include the blurhash metadata.


## Installation
Add this line to your application's Gemfile:

```ruby
gem "active_storage-blurhash"
```

And then execute:
```bash
$ bundle
```


Install the JavaScript packages and blurhash snippet:

```bash
$ bin/rails g active_storage:blurhash:install
```

## Backfilling

Chances are you already have a large assortment of ActiveStorage attachments. In this case, we can help you out with a backfill rake task that re-analyzes all existing image blobs:

```bash
$ bin/rails active_storage_blurhash:backfill
```

If you want to throttle it, you can change the batch size using the `BATCH_SIZE` environment variable (default is 1000):

```bash
$ BATCH_SIZE=50 bin/rails active_storage_blurhash:backfill
```

Note that for each blob an `AnalyzeJob` will be appended to your job processor queue.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
