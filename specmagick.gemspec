# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'specmagick/version'

Gem::Specification.new do |spec|
  spec.name          = "specmagick"
  spec.version       = Specmagick::VERSION
  spec.authors       = ["Luciano Di Lucrezia"]
  spec.email         = ["luciano.dilucrezia@gmail.com"]

  spec.summary       = %q{A set of utilities to make life with your specs easier.}
  spec.description   = %q{A set of utilities to make life with your specs easier.}
  spec.homepage      = "http://localhost"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'sequel', '~> 4.31'
  spec.add_dependency 'sqlite3', '~> 1.3'
  spec.add_dependency 'escort', '~> 0.4'
  spec.add_dependency 'tty-table', '~> 0.5'
  spec.add_dependency 'tty-screen', '~> 0.5'
  spec.add_dependency 'rspec', '>= 3.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.10'
end
