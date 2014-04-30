# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'alcatraz/client/version'

Gem::Specification.new do |spec|
  spec.name          = 'alcatraz-client'
  spec.version       = Alcatraz::Client::VERSION
  spec.authors       = ['Brian McManus']
  spec.email         = ['brian@checkmate.io']
  spec.summary       = %q{A client library for the Alcatraz PCI-compliant data store.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'webmock', '~> 1.15'
  spec.add_development_dependency 'vcr', '~> 2.8.0'

  spec.add_runtime_dependency 'hashie', '~> 2.1.1'
  spec.add_runtime_dependency 'faraday', '~> 0.9.0'
  spec.add_runtime_dependency 'faraday_middleware'
  spec.add_runtime_dependency 'warden-hmac-authentication', '~> 0.6.4'
end
