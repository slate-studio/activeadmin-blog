# -*- encoding: utf-8 -*-
require File.expand_path('../lib/activeadmin-blog/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'activeadmin-blog'
  gem.summary     = 'Blog app on the top of activeadmin and mongoid.'
  gem.description = ''
  gem.license     = 'MIT'

  gem.authors  = ['Alex Kravets']
  gem.email    = 'santyor@gmail.com'
  gem.homepage = 'https://github.com/alexkravets/activeadmin-blog'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  gem.version       = ActiveadminBlog::VERSION

  # Supress the warning about no rubyforge project
  gem.rubyforge_project = 'nowarning'

  # Dependencies
  gem.add_runtime_dependency "nokogiri"
  gem.add_runtime_dependency "mongoid_slug"
  gem.add_runtime_dependency "mongoid_search", "~> 0.2.8" # "mongoid_search" this uses mongoid 3.x
  gem.add_runtime_dependency "activeadmin-mongoid-reorder"
  gem.add_runtime_dependency "activeadmin-mongoid"
  gem.add_runtime_dependency "activeadmin-settings"
end
