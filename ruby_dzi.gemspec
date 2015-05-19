# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_dzi/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-dzi"
  spec.version       = RubyDzi::VERSION
  spec.authors       = ["Michael Webb"]
  spec.email         = ["michael.webb@trikeapps.com"]
  spec.summary       = %q{Slices images into tiles & creates a dzi descriptor file.}
  spec.description   = %q{A forked project of Deep Zoom Slicer. Sliced images are compatible for use with OpenZoom, Deep Zoom and Seadragon.}
  spec.homepage      = "http://github.com/tricycle/ruby-dzi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rmagick", "~> 2.13"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "aws-sdk", "~> 2.0.0"
end
