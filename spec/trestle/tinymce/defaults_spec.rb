require "spec_helper"

describe "TinyMCE defaults" do
  let(:config) { Trestle::Configuration.new }

  before do
    allow(Trestle).to receive(:configure).and_yield(config)
    stub_const("TinyMCE::Rails::VERSION", version)
    load File.expand_path("../../../config/initializers/trestle.rb", __dir__)
  end

  context "with TinyMCE 5" do
    let(:version) { "5.10.9" }

    it "uses the Trestle 5 skin and legacy toolbar and plugins" do
      options = config.tinymce.default

      expect(options.skin).to eq("trestle/tinymce-5")
      expect(options.toolbar).to start_with("styleselect |")
      expect(options.plugins).to include(:hr, :paste)
    end
  end

  context "with TinyMCE 6" do
    let(:version) { "6.8.6.1" }

    it "uses the Trestle 6 skin and modern toolbar" do
      options = config.tinymce.default

      expect(options.skin).to eq("trestle/tinymce-6")
      expect(options.toolbar).to start_with("styles |")
      expect(options.plugins).not_to include(:hr, :paste)
    end
  end

  context "with TinyMCE 8" do
    let(:version) { "8.10.2" }

    it "uses Oxide and leaves the license choice to the host" do
      options = config.tinymce.default

      expect(options.skin).to eq("oxide")
      expect(options.toolbar).to start_with("styles |")
      expect(options.plugins).to include(:lists, :link)
      expect(options.plugins).not_to include(:hr, :paste)
      expect(options.options).not_to have_key(:license_key)
    end
  end
end
