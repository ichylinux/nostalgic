$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
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

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.required_ruby_version = '>= 2.7.0'

  s.add_dependency 'rails', '>= 5.2', '< 7'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rake'
  s.add_development_dependency "sqlite3"
end
