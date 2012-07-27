#!/bin/sh


# === activeadmin-mongoid-blog ===
# https://github.com/alexkravets/activeadmin-mongoid-blog
#
# Description:
#   Blog app on the top of activeadmin and mongoid, using redactor and
#   select2 plugins. Could be useful for almost every activeadmin based project.
# 
# Installation:
#   curl https://raw.github.com/alexkravets/activeadmin-mongoid-blog/master/install.sh | sh


set -e

echo "Type the new project name, followed by [ENTER]:"
read project_name


rails new $project_name -T -O
cd $project_name


# Gems
echo '
    gem "bson_ext"
    gem "mongoid"
    gem "devise"
    gem "activeadmin-mongoid"
    gem "activeadmin-mongoid-blog"' >> Gemfile


bundle


rails g mongoid:config
rails g devise:install
rails g active_admin:install
rails g active_admin:blog:install blog


bundle


rails g redactor:install


# Tweak active_admin.js
cat app/assets/javascripts/active_admin.js > temp_file.tmp
echo '//= require activeadmin_mongoid_blog' > app/assets/javascripts/active_admin.js
cat temp_file.tmp >> app/assets/javascripts/active_admin.js

# Tweak active_admin.css.scss
cat app/assets/stylesheets/active_admin.css.scss > temp_file.tmp
echo '//= require activeadmin_mongoid_blog' > app/assets/stylesheets/active_admin.css.scss
cat temp_file.tmp >> app/assets/stylesheets/active_admin.css.scss


rm temp_file.tmp


echo "\n\n\n"
echo "New rails project '" + project_name + "' created. Now create new admin user:"
echo "  $ rails c\n  >> AdminUser.create :email => 'admin@example.com', :password => 'password', :password_confirmation => 'password'"

