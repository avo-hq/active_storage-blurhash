require_relative "lib/active_storage/blurhash/version"

Gem::Specification.new do |spec|
  spec.name        = "active_storage-blurhash"
  spec.version     = ActiveStorage::Blurhash::VERSION
  spec.authors     = ["Julian Rubisch"]
  spec.email       = ["julian@julianrubisch.at"]
  spec.homepage    = "https://github.com/avo-hq/active_storage-blurhash"
  spec.summary     = "Use blurhashes to lazy load ActiveStorage images"
  spec.description = "Use blurhashes to lazy load ActiveStorage images"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "activestorage", ">= 7.1.3.4"
  spec.add_dependency "activesupport", ">= 7.1.3.4"
  spec.add_dependency "blurhash", "~> 0.1.0"
  spec.add_dependency "image_processing", ">= 1.0.0"

  spec.add_development_dependency "rails", ">= 7.1.3.4"
  spec.add_development_dependency "mini_magick"
  spec.add_development_dependency "ruby-vips"
  spec.add_development_dependency "standard"
end
