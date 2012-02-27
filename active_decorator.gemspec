# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "active_decorator/version"

Gem::Specification.new do |s|
  s.name        = "active_decorator"
  s.version     = ActiveDecorator::VERSION
  s.authors     = ["Akira Matsuda"]
  s.email       = ["ronnie@dio.jp"]
  s.homepage    = 'https://github.com/amatsuda/active_decorator'
  s.summary     = %q{A simple and Rubyish view helper for Rails 3}
  s.description = %q{A simple and Rubyish view helper for Rails 3}

  s.rubyforge_project = "active_decorator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
