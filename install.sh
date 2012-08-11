#!/bin/sh


# === activeadmin-mongoid-blog ===
# https://github.com/alexkravets/activeadmin-mongoid-blog
#
# Description:
#   Blog app on the top of activeadmin and mongoid, using redactor and
#   select2 plugins. Could be useful for almost every activeadmin based project.
# 
# Installation:
#   export project_name=new_blog ; curl https://raw.github.com/alexkravets/activeadmin-mongoid-blog/master/install.sh | sh


set -e

rails new $project_name -T -O --skip-bundle
cd $project_name


# Gems
echo '
# Activeadmin
gem "bson_ext"
gem "mongoid"
gem "devise"
gem "activeadmin-mongoid"

# Blog
gem "activeadmin-settings"
gem "activeadmin-mongoid-blog"

# Bootstrap styles
gem "therubyracer"
gem "twitter-bootstrap-rails"

# Assets
gem "asset_sync"
' >> Gemfile


bundle


rails g mongoid:config
rails g devise:install
rails g active_admin:install
rails g activeadmin_settings:install
rails g active_admin:blog:install blog
rails g bootstrap:install


# Add blog settings
echo '\nGeneral:
  Blog Title:
    description:    You can change blog title with this setting
    default_value:  <%= Rails.application.class.parent_name %>

  Delivered By:
    description:    Link in the footer of the website
    default_value:  (Slate Studio) http://slatestudio.com
    type:           link' >> config/activeadmin_settings.yml


# Tweak application.css.scss
echo '/*
 *= require bootstrap_and_overrides
 *= require_self
 */

.pagination .page.current {
  float:left;
  padding:0 14px;
  line-height:34px;
  text-decoration:none;
  border:1px solid #DDD;
  border-left-width:0;
  color:#999;
  cursor:default;
  background-color:whiteSmoke;
}
.pagination span:first-child, .pagination .first a { border-left-width:1px; }' > app/assets/stylesheets/application.css


# Tweak application.js
echo '//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require bootstrap
'  > app/assets/javascripts/application.js


# Fix default mongoid.yml
echo 'development:
  host: localhost
  database: '$project_name'

test:
  host: localhost
  database: '$project_name'_test

production:
  uri: <%= ENV["MONGO_URL"] %>' > config/mongoid.yml


# Remove migrations, we don't need them with mongoid
rm -Rfd db/migrate


# Fix seeds.rb file to generate first admin user
echo 'puts "EMPTY THE MONGODB DATABASE"
Mongoid.master.collections.reject { |c| c.name =~ /^system/}.each(&:drop)

puts "SETTING UP DEFAULT ADMIN USER"
Rake::Task["activeadmin:create_admin"].invoke
' > db/seeds.rb


# Create default admin user
rake db:seed


# Create carrierwave default configuration
echo 'CarrierWave.configure do |config|
  config.cache_dir = File.join(Rails.root, "tmp", "uploads")
  config.storage = :fog

  config.fog_credentials = {
    :provider               => "AWS",
    :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
    :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"]
  }

  case Rails.env.to_sym
    when :development
      config.storage = :file
    when :production
      config.fog_directory  = ENV["FOG_MEDIA_DIRECTORY"]
      config.fog_host       = "//#{ ENV["FOG_MEDIA_DIRECTORY"] }.s3.amazonaws.com"
      config.fog_attributes = {"Cache-Control"=>"max-age=315576000"}  # optional, defaults to {}
  end
end' > config/initializers/carrierwave.rb


# Fix production assets to include all required files
mv config/environments/production.rb config/environments/production-old.rb
sed '/# config.assets.precompile += %w( search.js )/ a\
  config.assets.precompile += ["active_admin.js", "active_admin.css", "redactor/css/style.css"]' config/environments/production-old.rb 1> config/environments/production.rb
rm config/environments/production-old.rb


echo ""
echo "Please make sure you've set Heroku environment settings:"
echo "  FOG_MEDIA_DIRECTORY"
echo "  AWS_ACCESS_KEY_ID"
echo "  AWS_SECRET_ACCESS_KEY"
echo "  MONGO_URL"
echo ""




