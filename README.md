# Trestle TinyMCE Integration (trestle-tinymce)

[![RubyGem](https://img.shields.io/gem/v/trestle-tinymce?include_prereleases&color=%234d6bb2)](https://rubygems.org/gems/trestle-tinymce)
[![Build Status](https://img.shields.io/github/actions/workflow/status/TrestleAdmin/trestle-tinymce/rspec.yml?style=flat)](https://github.com/TrestleAdmin/trestle-tinymce/actions)

> TinyMCE integration plugin for the Trestle admin framework

- Supports TinyMCE 5 through 8 via [tinymce-rails](https://github.com/spohlenz/tinymce-rails/)
- Includes Trestle skins for TinyMCE 5 and 6 and uses the built-in Oxide skin for 7 and 8

<img width="960" alt="Trestle TinyMCE Integration Screenshot" src="https://github.com/user-attachments/assets/d55eb5f2-5317-434d-9f01-ea13761e3bbf">


## Getting Started

These instructions assume you have a working Trestle application. To integrate trestle-tinymce, first add it to your application's Gemfile:

```ruby
gem 'trestle-tinymce'
```

Run `bundle install`, and then restart your Rails server.

To add a TinyMCE editor to your form, use the `editor` (or `tinymce`) field type:

```ruby
Trestle.resource(:articles) do
  form do |article|
    editor :content
  end
end
```

Configure the editor in `config/initializers/trestle.rb`. For example:

```ruby
Trestle.configure do |config|
  config.tinymce.default.configure do |c|
    c.branding = false
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
    c.toolbar = "styles | bold italic underline strikethrough | subscript superscript hr | alignleft aligncenter alignright alignjustify | bullist numlist | indent outdent | undo redo | link unlink | image charmap table | code"
    c.link_context_toolbar = true
    c.convert_urls = false
  end
end
```

TinyMCE 5 uses `styleselect` and needs the `hr` and `paste` plugins. When upgrading to 7 or 8, remove any `trestle/tinymce-5` or `trestle/tinymce-6` skin override to use Oxide.

Alternate configurations can be defined in a similar fashion:

```ruby
Trestle.configure do |config|
  config.tinymce.alternate.configure do |c|
    ...
  end
end
```

and then used by passing the `data-tinymce-configuration-value` option to the editor:

```ruby
editor :content, data: { tinymce_configuration_value: "alternate" }
```

Custom callbacks can be passed as strings and they will be automatically converted to JavaScript functions. The following example allows images to be uploaded and embedded as blob URLs.

```ruby
Trestle.configure do |config|
  config.tinymce.default.configure do |c|
    c.file_picker_types = "image"
    c.file_picker_callback = "function (cb, value, meta) {
      var input = document.createElement('input');
      input.setAttribute('type', 'file');
      input.setAttribute('accept', 'image/*');

      input.onchange = function () {
        var file = this.files[0];

        var reader = new FileReader();
        reader.onload = function () {
          var id = 'blobid' + (new Date()).getTime();
          var blobCache =  tinymce.activeEditor.editorUpload.blobCache;
          var base64 = reader.result.split(',')[1];
          var blobInfo = blobCache.create(id, file, base64);
          blobCache.add(blobInfo);

          cb(blobInfo.blobUri(), { title: file.name });
        };
        reader.readAsDataURL(file);
      };

      input.click();
    }"
  end
end
```

### License configuration for self-hosted TinyMCE 7 and 8

Set `license_key` on each editor configuration. Choose `"gpl"` only if you intend to use TinyMCE under GPLv2+. For a commercial TinyMCE 8 installation, supply a valid `T8LK:` key and load the commercial License Key Manager before initializing the editor. See [TinyMCE's licensing documentation](https://www.tiny.cloud/docs/tinymce/latest/license-key/) for the applicable options.

```ruby
Trestle.configure do |config|
  config.tinymce.default.configure do |c|
    c.license_key = ENV.fetch("TINYMCE_LICENSE_KEY")
  end
end
```

Run `bin/rails assets:precompile` when deploying self-hosted TinyMCE. The `tinymce_assets` helper and `tinymce-rails` precompile task set up the base URL and files needed by dynamically loaded plugins and skins.

For further information, please see [tinymce-rails](https://github.com/spohlenz/tinymce-rails) and the [TinyMCE documentation](https://www.tiny.cloud/docs/configure/).


## License

The gem is available as open source under the terms of the [LGPLv3 License](https://opensource.org/licenses/LGPL-3.0).
