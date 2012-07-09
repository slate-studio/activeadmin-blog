# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'activeadmin-mongoid-blog'
  gem.version = '0.1.0'
  gem.summary = 'Generic blog on the top of activeadmin and mongoid'
  gem.description = ''
  gem.license = 'MIT'

  gem.authors  = ['Alex Kravets']
  gem.email    = 'santyor@gmail.com'
  gem.homepage = 'https://github.com/alexkravets/activeadmin-mongoid-blog'

  gem.files         = Dir[ "lib/**/*", "app/**/*" ]
  gem.require_paths = ['lib']

  # Supress the warning about no rubyforge project
  gem.rubyforge_project = 'nowarning'
end
