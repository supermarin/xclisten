# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'xclisten/version'

Gem::Specification.new do |spec|
  spec.name          = "xclisten"
  spec.version       = XCListen::VERSION
  spec.authors       = ["Marin Usalj"]
  spec.email         = ["mneorr@gmail.com"]
  spec.summary       = %q{Run ObjectiveC tests each time you hit save}
  spec.description   = %q{Zero configuration file watcher for Objective-C that runs tests, installs Pods each time you save a file}
  spec.homepage      = "https://github.com/supermarin/xclisten"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features|fixtures)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "listen", "~> 2.4"
  spec.add_runtime_dependency "xcpretty", "~> 0.1"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
end
