# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bread/basket/version'

Gem::Specification.new do |spec|
  spec.name          = "bread-basket"
  spec.version       = Bread::Basket::VERSION
  spec.authors       = ["KC Erb"]
  spec.email         = ["iamkcerb@gmail.com"]
  spec.summary       = "The publication tool for bread"
  spec.description   =
    'Basket is a tool for publishing scientific findings. It\'s the last piece of ' +
    'the :bread: framework for scientific computing.\n\nFor now it just makes' +
    'scientific posters. In the future thought it should help make figures,' +
    ' presentations, and maybe even full journal articles.'
  spec.homepage      = "https://github.com/bread/bread-basket"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "rspec-nc", "~> 0"
  spec.add_development_dependency "guard", "~> 2.12"
  spec.add_development_dependency "guard-rspec", "~> 4.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-remote", "~> 0.1"
  spec.add_development_dependency "pry-nav", "~> 0.2"
  spec.add_development_dependency "coveralls", "~> 0.7"
end
