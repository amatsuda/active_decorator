# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)
require "active_decorator/version"

Gem::Specification.new do |s|
  s.name        = "active_decorator"
  s.version     = ActiveDecorator::VERSION
  s.authors     = ["Akira Matsuda"]
  s.email       = ["ronnie@dio.jp"]
  s.homepage    = 'https://github.com/amatsuda/active_decorator'
  s.license     = 'MIT'
  s.summary     = %q{A simple and Rubyish view helper for Rails}
  s.description = %q{A simple and Rubyish view helper for Rails}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'test-unit-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'jbuilder'
  s.add_development_dependency 'byebug'
end
