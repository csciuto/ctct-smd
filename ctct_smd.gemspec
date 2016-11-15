# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ctct_smd/version'

Gem::Specification.new do |spec|
  spec.name          = "ctct_smd"
  spec.version       = CTCT_SMD::VERSION
  spec.authors       = ["Corey Sciuto"]
  spec.email         = ["corey.sciuto@gmail.com"]

  spec.summary       = %q{Generates a Constant Contact email from a Facebook Page feed}
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  #spec.homepage      = "TODO: Put your gem's website or public repo URL here."
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'pry-byebug', '~> 3.4'
  spec.add_development_dependency 'webmock', '~>2.1'
  spec.add_development_dependency 'timecop', '~>0.8'
  spec.add_development_dependency 'rspec-expectations', '~>3.5'
  spec.add_development_dependency 'rspec-mocks', '~>3.5'
  spec.add_development_dependency 'rspec-core', '~>3.5'  
end
