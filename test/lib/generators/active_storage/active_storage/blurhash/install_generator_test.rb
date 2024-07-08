require "test_helper"
require "generators/active_storage/blurhash/install/install_generator"

module ActiveStorage
  class ActiveStorage::Blurhash::InstallGeneratorTest < Rails::Generators::TestCase
    tests ActiveStorage::Blurhash::InstallGenerator
    destination Rails.root.join("tmp/generators")
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
