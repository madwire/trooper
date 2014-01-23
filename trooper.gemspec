$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "trooper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "trooper"
  s.version     = Trooper::Version::STRING
  s.authors     = ["Richard Adams"]
  s.email       = ["richard@madwire.co.uk"]
  s.homepage    = "http://madwire.github.com/trooper"
  s.summary     = "Deploy like a 'Trooper'"
  s.description = "Simple but powerful deployment"
  s.licenses    = ["MIT"]
  s.executables = ["trooper"]

  s.files = Dir["{bin,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency "net-ssh", "~> 2.6.8"

  s.add_development_dependency "rspec", "~> 2.14"
  s.add_development_dependency "guard-rspec", "~> 4.2.4"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "yard", "~> 0.8"
  s.add_development_dependency "pry", "~> 0.9"
  s.add_development_dependency "sdoc", '~> 0.4'
  s.add_development_dependency "simplecov", "~> 0.8.2"
  s.add_development_dependency 'rake', "~> 10.1.1"
end
