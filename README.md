## activeadmin-mongoid-blog

Blog app on the top of activeadmin and mongoid, using redactor and select2 plugins. Could be useful for almost every activeadmin based project.


## Quick install

Replace `new_blog` name with the real one and run:

    export project_name=new_blog ; curl https://raw.github.com/alexkravets/activeadmin-mongoid-blog/master/install.sh | sh

This command creates new rails project fully configured and ready for Heroku deploy.


## Manual Installation

### Start a new rails project

    $ rails new appname -T -O

### Setup and configure ActiveAdmin

Add these gems to Gemfile and run `bundle` command:

    gem "bson_ext"
    gem "mongoid"
    gem "devise"
    gem "activeadmin-mongoid"
    gem "redactor-rails", :git => "git://github.com/alexkravets/redactor-rails.git"
    gem "activeadmin-mongoid-blog"
    gem "therubyracer"
    gem "twitter-bootstrap-rails"
    gem "aws-s3"
    gem "fog"
    gem "asset_sync"

Run generators to and check settings in `/config/mongoid.yml`, `/config/initializers/active_admin.rb`:

    $ rails g mongoid:config
    $ rails g devise:install
    $ rails g active_admin:install

Check that the generated `/config/initializers/devise.rb` file requires mongoid orm. You should see a line like this:

    require 'devise/orm/mongoid'

Create the activeadmin user:

    $ rails c
    >> AdminUser.create :email => 'admin@example.com', :password => 'password', :password_confirmation => 'password'

At this point **activeadmin** should be ready to work. Run `rails s` and check out `http://localhost:3000/admin`.

### Setup activeadmin-mongoid-blog

As blog post editor `redactor.js` is used. It comes with a image uploading featured supported by **carrierwave**, install `Picture` model with command:

    $ rails g redactor:install

Install blog models, admin files, routes and blog controller, replace `blog` value with a prefix you want the blog be accessible at (e.g. `http://localhost:3000/blog`):

    $ rails g active_admin:blog:install blog

Run `bundle` to install new gems.

Add to your `active_admin.js.coffee`:

    #= require activeadmin_mongoid_blog

Add to your `active_admin.css.scss`:

    //= require activeadmin_mongoid_blog

### Customizing blog views

Install default views templates to `/app/views/blog`:

    $ rails g active_admin:blog:views blog

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

    config.assets.precompile += ["active_admin.js", "active_admin.css", "redactor-rails/css/style.css"]


### The End


