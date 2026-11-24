Trestle.configure do |config|
  config.tinymce.default.configure do |c|
    major_version = Trestle::TinyMCE.tinymce_major_version
    c.skin = major_version < 7 ? "trestle/tinymce-#{major_version}" : "oxide"
    c.branding = false
    c.promotion = false
    c.elementpath = false
    c.menubar = false
    c.statusbar = false
    c.plugins = [
      :lists,
      :link,
      :image,
      :charmap,
      :table,
      :code
    ]
    styles = major_version == 5 ? "styleselect" : "styles"
    c.toolbar = "#{styles} | bold italic underline strikethrough | subscript superscript hr | alignleft aligncenter alignright alignjustify | bullist numlist | indent outdent | undo redo | link unlink | image charmap table | code"
    c.plugins.concat([:hr, :paste]) if major_version == 5
    c.link_context_toolbar = true
    c.convert_urls = false
  end

  config.hook(:javascripts) do
    safe_join([
      tinymce_assets,
      javascript_include_tag("trestle/tinymce"),
      javascript_tag(config.tinymce.to_javascript)
    ], "\n")
  end

  config.form_field :tinymce, Trestle::TinyMCE::Field
  config.form_field :editor, Trestle::TinyMCE::Field
end
