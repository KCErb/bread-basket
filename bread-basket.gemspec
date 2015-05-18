# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bread/basket/version'

Gem::Specification.new do |spec|
  spec.name          = 'bread-basket'
  spec.version       = Bread::Basket::VERSION
  spec.authors       = ['KC Erb']
  spec.email         = ['iamkcerb@gmail.com']
  spec.summary       = 'The go-to publication tool for bread'
  spec.description   = 'bread-basket is still under development. This release ' \
                       'contains only bare-bones functionality'
  spec.homepage      = 'https://github.com/bread/bread-basket'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'guard', '~> 2.12'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'guard-rubocop', '~> 1.2'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.add_development_dependency 'pry-nav', '~> 0.2'
  spec.add_development_dependency 'pry-remote', '~> 0.1'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'rspec-its', '~> 1.2'
  spec.add_development_dependency 'rspec-nc', '~> 0'

  spec.add_dependency 'css_parser', '~> 1.3'
  spec.add_dependency 'fastimage', '~> 1.6'
  spec.add_dependency 'prawn', '~> 2.0'
  spec.add_dependency 'redcarpet', '~> 3.2'
  spec.add_dependency 'thor', '~> 0.19'
end
