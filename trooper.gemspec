$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "trooper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "trooper"
  s.version     = Trooper::Version::STRING
  s.authors     = ["Richard Adams"]
  s.email       = ["richard@madwire.co.uk"]
  s.homepage    = "http://www.madwire.co.uk"
  s.summary     = "Deploy like a 'Trooper'"
  s.description = "Simple but powerful deployment"

  s.files = Dir["{bin,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_runtime_dependency "net-ssh", "~> 2.3.0"

  s.add_development_dependency "rspec", "~> 2.8"
  s.add_development_dependency "guard-rspec", "~> 0.6"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "yard", "~> 0.7"
  s.add_development_dependency "pry", "~> 0.9"
  s.add_development_dependency "sdoc", '~> 0.3.16'
  s.add_development_dependency "simplecov", "~> 0.5.4"
  s.add_development_dependency 'rake', "~> 0.9.2"
end
