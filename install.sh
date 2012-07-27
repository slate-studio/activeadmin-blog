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
echo '//= require activeadmin_mongoid_blog' >> app/assets/javascripts/active_admin.js

# Tweak active_admin.css.scss
cat app/assets/stylesheets/active_admin.css.scss > temp_file.tmp
echo '//= require activeadmin_mongoid_blog' > app/assets/stylesheets/active_admin.css.scss
cat temp_file.tmp >> app/assets/stylesheets/active_admin.css.scss
rm temp_file.tmp


echo "\n\n\n"
echo "$ rails c"
echo ">> AdminUser.create :email => 'admin@example.com', :password => 'password', :password_confirmation => 'password'"
echo "\n\n\n"
