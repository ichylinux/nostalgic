lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nostalgic/version'

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

  s.add_dependency 'rails', '>= 5.2'

  s.add_development_dependency 'bundler', '~> 2.0'
  s.add_development_dependency 'minitest', '~> 5.25'
  s.add_development_dependency 'rake', '~> 12.0'
end
