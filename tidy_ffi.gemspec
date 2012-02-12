# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tidy_ffi/version"

Gem::Specification.new do |s|
  s.name        = %q{tidy_ffi}
  s.version     = TidyFFI::VERSION
  s.authors     = ["Eugene Pimenov"]
  s.description = %q{Tidy library interface via FFI}
  s.summary     = %q{Tidy library interface via FFI}
  s.email       = %q{libc@libc.st}
  s.homepage    = %q{http://github.com/libc/tidy_ffi}

  s.rubyforge_project = %q{tidy-ffi}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'ffi', ">= 0.3.5"
end
