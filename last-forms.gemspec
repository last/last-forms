# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "last/forms/version"

Gem::Specification.new do |spec|
  spec.name          = "last-forms"
  spec.version       = Last::Forms::VERSION
  spec.authors       = ["Adam Michela"]
  spec.email         = ["adam@miche.la"]
  spec.summary       = "Last Forms"
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake",    "~> 10.0"

  spec.add_runtime_dependency "activemodel", "~> 4.1"
  spec.add_runtime_dependency "virtus",      "~> 1.0"
end
