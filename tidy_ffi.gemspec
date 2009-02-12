# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{tidy_ffi}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eugene Pimenov"]
  s.date = %q{2009-02-12}
  s.description = %q{Tidy library interface via FFI}
  s.email = %q{libc@me.com}
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README", "lib/tidy_ffi/interface.rb", "lib/tidy_ffi/lib_tidy.rb", "lib/tidy_ffi/options_container.rb", "lib/tidy_ffi/tidy.rb", "lib/tidy_ffi/tidy_ffi_extensions.rb", "lib/tidy_ffi.rb"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README", "Rakefile", "lib/tidy_ffi/interface.rb", "lib/tidy_ffi/lib_tidy.rb", "lib/tidy_ffi/options_container.rb", "lib/tidy_ffi/tidy.rb", "lib/tidy_ffi/tidy_ffi_extensions.rb", "lib/tidy_ffi.rb", "test/test_helper.rb", "test/test_options.rb", "test/test_simple.rb", "tidy_ffi.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/libc/tidy_ffi}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Tidy_ffi", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{tidy_ffi}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Tidy library interface via FFI}
  s.test_files = ["test/test_helper.rb", "test/test_options.rb", "test/test_simple.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>, [">= 0", "= 0.2.0"])
      s.add_development_dependency(%q<rr>, [">= 0"])
      s.add_development_dependency(%q<matchy>, [">= 0"])
      s.add_development_dependency(%q<context>, [">= 0"])
    else
      s.add_dependency(%q<ffi>, [">= 0", "= 0.2.0"])
      s.add_dependency(%q<rr>, [">= 0"])
      s.add_dependency(%q<matchy>, [">= 0"])
      s.add_dependency(%q<context>, [">= 0"])
    end
  else
    s.add_dependency(%q<ffi>, [">= 0", "= 0.2.0"])
    s.add_dependency(%q<rr>, [">= 0"])
    s.add_dependency(%q<matchy>, [">= 0"])
    s.add_dependency(%q<context>, [">= 0"])
  end
end
