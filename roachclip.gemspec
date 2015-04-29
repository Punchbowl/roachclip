# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roachclip/version'

Gem::Specification.new do |spec|
  spec.name          = "roachclip"
  spec.version       = Roachclip::VERSION
  spec.authors       = ["Blake Carlson", "Ryan Angilly"]
  spec.email         = ["blc@punchbowl.com", "ryan@angilly.com"]

  spec.summary       = %q{Adds Paperclip-style image uploads to MongoMapper}
  spec.description   = %q{Adds Paperclip-style image uploads to MongoMapper}
  spec.homepage      = "https://github.com/skinandbones/roachclip"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
