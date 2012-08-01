# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |gem|
  gem.name    = 'activeadmin-mongoid-blog'
  gem.version = '0.3.7'
  gem.summary = 'Blog app on the top of activeadmin and mongoid, using redactor and select2 plugins.'
  gem.description = ''
  gem.license = 'MIT'

  gem.authors  = ['Alex Kravets']
  gem.email    = 'santyor@gmail.com'
  gem.homepage = 'https://github.com/alexkravets/activeadmin-mongoid-blog'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  # Supress the warning about no rubyforge project
  gem.rubyforge_project = 'nowarning'
end
