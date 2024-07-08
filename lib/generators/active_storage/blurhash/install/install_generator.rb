class ActiveStorage::Blurhash::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)

  def install_javascript_deps
    if File.exist? Rails.root.join("config", "importmap.rb")
      say "Pinning blurhash"
      run "bin/importmap pin blurhash"
    else
      say "Installing blurhash"
      run "yarn add blurhash"
    end
  end

  def copy_application_javascript
    directory "javascript", "app/javascript/blurhash"
  end

  def append_to_main_javascript_entrypoint
    append_to_file "app/javascript/application.js", "import \"./blurhash\";\n"
  end
end
