module ActiveAdmin
  module Blog
    module Generators
      class InstallGenerator < Rails::Generators::NamedBase
        desc << "Description:\n    Copies blog source files to your application's app directory, adds routes and missing gems."

        source_root File.expand_path('../templates', __FILE__)

        def copy_files
          # models
          puts "Installing models:"
          copy_file "models/blog_category.rb",  "app/models/blog_category.rb"
          copy_file "models/blog_post.rb",      "app/models/blog_post.rb"

          # controllers
          puts "Installing controllers:"
          copy_file "controllers/blog_controller.rb", "app/controllers/blog_controller.rb"

          # admin
          puts "Installing admin:"
          copy_file "admin/blog_categories.rb", "app/admin/blog_categories.rb"
          copy_file "admin/blog_posts.rb",      "app/admin/blog_posts.rb"
        end

        def setup_routes
          route "get '/#{file_name}'             => 'blog#index', :as => :blog"
          route "get '/#{file_name}/feed'        => 'blog#feed',  :as => :blog_rss_feed"
          route "get '/#{file_name}/posts/:slug' => 'blog#post',  :as => :blog_post"
        end

        def add_gems
          gem "mongoid_slug"
          gem "mongoid_search"
          gem "nokogiri"
          gem "activeadmin-mongoid-reorder"
          gem "redactor-rails", :git => "git://github.com/alexkravets/redactor-rails.git"
          gem "carrierwave-mongoid", :require => 'carrierwave/mongoid'
          gem "mini_magick"
          gem "select2-rails"
        end

        def show_congrats
          readme("README")
        end
      end
    end
  end
end
