activeadmin-mongoid-blog
========================

Generic blog app on the top of activeadmin and mongoid.

Active admin configuration:

Gemfile:

```
gem 'bson_ext'
gem 'mongoid'
gem 'activeadmin-mongoid'
gem 'activeadmin-mongoid-blog'
gem 'devise'
```

Configurators:

```rails g mongoid:config```
```rails g devise:install```
```rails g active_admin:install```

Check that the generated initializers/devise.rb file requires mongoid orm. You may find a line like this :

```require 'devise/orm/mongoid'```

Then create the admin user:

```
$ rails console
>> AdminUser.create :email => 'admin@example.com', :password => 'password', :password_confirmation => 'password'
```

```rails g active_admin:blog:install blog``` - this makes a copy of all required models, controllers, admin files and routes. ```blog``` is a prefix which is used for blog, so in this case blog is located at ```/blog```.

To override controllers run: ```rails g active_admin:blog:views``` - this will copy templates into ```/app/views/blog``` folder.


CarrierWave configuration;
S3 assets configuration;


TODO:
- fix carrierwave;
- assets for active admin and redactor with images functionality;
- make sure views generator works correct;

