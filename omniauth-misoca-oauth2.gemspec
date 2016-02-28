lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "misoca-oauth2/version"

Gem::Specification.new do |gem|
  gem.add_dependency "oauth2",     "~> 1.0"
  gem.add_dependency "omniauth",   "~> 1.2"

  gem.add_development_dependency "bundler", "~> 1.0"

  gem.authors       = "Takafumi Yamamoto"
  gem.email         = "bino98@gmail.com"
  gem.description   = "Misoca API for Oauth2 client helper."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/bino98/omniauth-misoca-oauth2"
  gem.licenses      = %w(MIT)

  gem.executables   = `git ls-files -- bin/*`.split("\n").collect { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-misoca-oauth2"
  gem.require_paths = %w(lib)
  gem.version       = Misoca::OAuth2::VERSION
end
