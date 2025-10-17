require_relative "lib/nostalgic/version"

Gem::Specification.new do |spec|
  spec.name        = "nostalgic"
  spec.version     = Nostalgic::VERSION
  spec.authors     = [ "ichy" ]
  spec.email       = [ "ichylinux@gmail.com" ]
  spec.homepage    = "https://github.com/ichylinux/nostalgic"
  spec.summary     = "column versioning utility"
  spec.description = "column versioning utility"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/ichylinux/nostalgic/blob/master/HISTORY.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.0"
end
