## activeadmin-blog

Blog app on the top of activeadmin and mongoid.


## Quick install

**IMPORTANT**: Make sure local mongodb instance is running.

Replace `new_blog` name with the real one and run:

    export project_name=new_blog ; curl https://raw.github.com/alexkravets/activeadmin-blog/master/install.sh | sh

This command creates new rails project fully configured and ready for Heroku deploy.


## Manual Installation

### Start a new rails project

    $ rails new appname -T -O

### Setup and configure ActiveAdmin

Add these gems to Gemfile and run `bundle` command:

    # Activeadmin
    gem "bson_ext"
    gem "mongoid"
    gem "devise"
    gem "activeadmin-mongoid"

    # Activeadmin Mongoid Blog
    gem "activeadmin-settings"
    gem "activeadmin-blog"

    # Bootstrap styles
    gem "therubyracer"
    gem "twitter-bootstrap-rails"

    # Assets
    gem "asset_sync"

Run following generators:

    $ rails g mongoid:config
    $ rails g devise:install
    $ rails g active_admin:install
    $ rails g activeadmin_settings:install
    $ rails g activeadmin_blog:install blog

Create default admin user for activeadmin:

    rake activeadmin:settings:create_admin

Run `rails s` blog should be accesible at `http://localhost:3000/blog`

### Customizing blog views

Install default views templates to `/app/views/blog`:

    $ rails g activeadmin_blog:views blog

### Default style

By default blog is comming with a Twitter Bootstrap typography, to enable it add to `Gemfile`:

    gem "twitter-bootstrap-rails", :git => "git://github.com/seyhunak/twitter-bootstrap-rails.git"

Install required bootstrap assets:

    rails g bootstrap:install

Remove `reuire_self` line from `application.js` and `application.css` these are added by bootstrap intall and will break the layout with activeadmin styles.

In `application.js` include:

    //= require bootstrap

In `application.css` include:

    /*
        *= require bootstrap_and_overrides
        *= require_self
    */

    // Tuning styles for kaminari pagination
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
    .pagination span:first-child, .pagination .first a { border-left-width:1px; }


## Heroku

#### Mongoid

Configure local and production `config/mongoid.yml` settings to look like this:

    development:
      host: localhost
      database: supercaliblog

    test:
      host: localhost
      database: supercaliblog_test

    production:
      uri: <%= ENV["MONGO_URL"] %>

#### Carrierwave

Create an S3 bucket for redactor image uploading feature and configure `config/initializers/carrierwave.rb`:

    CarrierWave.configure do |config|
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
    end

Make sure you've set Heroku environtment variables:

    FOG_MEDIA_DIRECTORY
    AWS_ACCESS_KEY_ID
    AWS_SECRET_ACCESS_KEY
    MONGO_URL

#### Production assets

Add the following line to `config/environments/production.rb`:

    config.assets.precompile += ["active_admin.js", "active_admin.css", "redactor/css/style.css"]


## TODO

- Admin blog post search;

### The End
