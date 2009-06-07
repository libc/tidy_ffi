require 'rubygems'
begin
  require 'echoe'  
  Echoe.new('tidy_ffi') do |p|
    p.author = 'Eugene Pimenov'
    p.summary = 'Tidy library interface via FFI'
    p.url = 'http://github.com/libc/tidy_ffi'
    p.runtime_dependencies = ['ffi >=0.3.5']
    # p.development_dependencies = ['rr', 'matchy', 'context']
    p.project = 'tidy-ffi'
    p.email = 'libc@libc.st'
    p.rdoc_pattern = /^(lib|bin|tasks|ext)|^README\.rdoc|^CHANGELOG|^TODO|^LICENSE|^COPYING$/
    p.retain_gemspec = true
  end

  # My common error 
  task :rdoc => :doc do; end
rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."

  desc 'No effect.'
  task :default do; end
end