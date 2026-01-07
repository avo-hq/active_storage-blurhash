# ActiveStorage::Blurhash

A [blurhash](https://blurha.sh/) integration for images stored in ActiveStorage.

![](./logo.png)

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

## Styling Options

The `blurhash_image_tag` helper accepts additional options for styling:

- `wrapper_class`: CSS classes applied to the wrapper `<div>` element
- `canvas_class`: CSS classes applied to the `<canvas>` element

### Preventing Canvas from Blocking Pointer Events

If you have interactive elements (links, buttons, etc.) positioned over or near blurhash images, the canvas element may block pointer events even when hidden. To fix this, add `pointer-events-none` to the `canvas_class` option:

```erb
<%= blurhash_image_tag person.avatar, 
    class: "rounded-full", 
    canvas_class: "pointer-events-none" %>
```

This ensures clicks pass through to underlying interactive elements. If you're using Tailwind CSS, the `pointer-events-none` utility class works perfectly for this use case.

## Installation

Add the library to your application's Gemfile:

```ruby
gem "active_storage-blurhash"
```

You will also need to add the "image_processing" gem to your Gemfile:

```ruby
gem "image_processing"
```

And then execute:

```bash
$ bundle
```

Install the JavaScript packages and blurhash snippet:

```bash
$ bin/rails g active_storage:blurhash:install
```

> [!IMPORTANT]  
> Consider that, to make everything work, you need [libvips](https://github.com/janko/image_processing/blob/master/doc/vips.md) or [MiniMagick](https://github.com/janko/image_processing/blob/master/doc/minimagick.md) installed on your system.

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

## Tutorial

We wrote a [tutorial](https://avohq.io/blog/blurhash-active-storage) on how to add it to a Rails app.

## Other gems & packages

- [`avo`](https://github.com/avo-hq/avo) - Build Content management systems with Ruby on Rails
- [`class_variants`](https://github.com/avo-hq/class_variants) - Easily configure styles and apply them as classes. Very useful when you're implementing Tailwind CSS components and call them with different states.
- [`prop_initializer`](https://github.com/avo-hq/prop_initializer) - A flexible tool for defining properties on Ruby classes.
- [`stimulus-confetti`](https://github.com/avo-hq/stimulus-confetti) - The easiest way to add confetti to your StimulusJS app

## Try Avo ⭐️

If you enjoyed this gem try out [Avo](https://github.com/avo-hq/avo). It helps developers build Internal Tools, Admin Panels, CMSes, CRMs, and any other type of Business Apps 10x faster on top of Ruby on Rails.

[![](https://github.com/avo-hq/avo/raw/main/public/avo-assets/logo-on-white.png)](https://github.com/avo-hq/avo)
