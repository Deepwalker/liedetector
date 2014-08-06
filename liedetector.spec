# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liedetector/version'

Gem::Specification.new do |spec|
  spec.name          = "liedetector"
  spec.version       = LieDetector::VERSION
  spec.authors       = ["Mikhail Krivushin"]
  spec.email         = ["krivushinme@gmail.com"]
  spec.summary       = %q{Markdown API description checker}
  spec.description   = %q{Small lib and script to check API description
                          in special format against test server}
  spec.homepage      = "https://github.com/Deepwalker/liedetector.rb"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"
  spec.add_dependency "trafaret"
  spec.add_dependency "httpclient"
  spec.add_dependency "oj"
  spec.add_dependency "redcarpet"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end