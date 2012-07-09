module ActiveAdmin
  module Blog
    module Generators
      class ViewsGenerator < Rails::Generators::NamedBase
        desc << "Description:\n    Copies blog templates to your application."

        source_root File.expand_path('../../../../../app/views/blog', __FILE__)

        def copy_default_views
          filename_pattern = File.join self.class.source_root, "*.html.erb"
          Dir.glob(filename_pattern).map {|f| File.basename f}.each do |f|
            copy_file f, "app/views/blog/#{f}"
          end
        end
      end
    end
  end
end
