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

  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport'

  s.add_development_dependency 'test-unit-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'byebug'
end
