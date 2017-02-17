$:.push File.expand_path("../lib", __FILE__)
require "nostalgic/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "nostalgic"
  s.version     = Nostalgic::VERSION
  s.authors     = ["ichy"]
  s.email       = ["ichylinux@gmail.com"]
  s.homepage    = "https://github.com/ichylinux/nostalgic"
  s.summary     = %q{column versioning utility}
  s.description = %q{column versioning utility}
  s.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.required_ruby_version = '>= 2.1.0'

  s.add_dependency "rails", '>= 4.2', '< 5.1'

  s.add_development_dependency 'bundler', '~> 1.12'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'rake', '~> 11.0'
  s.add_development_dependency 'sqlite3', '~> 1.3'
end
