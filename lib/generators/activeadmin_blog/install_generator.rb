module ActiveadminBlog
  module Generators
    class InstallGenerator < Rails::Generators::NamedBase
      desc << "Description:\n    Copies blog source files to your application's app directory, adds routes and missing gems."

      source_root File.expand_path('../templates', __FILE__)

      def copy_files
        # admin
        puts "Installing admin:"
        copy_file "admin/blog_categories.rb", "app/admin/blog_categories.rb"
        copy_file "admin/blog_posts.rb",      "app/admin/blog_posts.rb"
      end

      def add_assets
        if File.exist?('app/assets/javascripts/active_admin.js')
          insert_into_file  "app/assets/javascripts/active_admin.js",
                            "//= require activeadmin_blog\n", :after => "base\n"
        else
          puts "It doesn't look like you've installed activeadmin: active_admin.js is missing.\nPlease install it and try again."
        end

        if File.exist?('app/assets/stylesheets/active_admin.css.scss')
          insert_into_file  "app/assets/stylesheets/active_admin.css.scss",
                            "//= require activeadmin_blog\n", :before => "// Active Admin CSS Styles\n"
        else
          puts "It doesn't look like you've installed activeadmin: active_admin.scss is missing.\nPlease install it and try again."
        end
      end

      def mount_engine
        route "mount ActiveadminBlog::Engine => '/#{file_name}'"
      end

      def show_congrats
        readme("README")
      end
    end
  end
end
