require 'rubygems'
begin
  require 'echoe'  
  Echoe.new('tidy_ffi') do |p|
    p.author = 'Eugene Pimenov'
    p.summary = 'Tidy library interface via FFI'
    p.url = 'http://github.com/libc/tidy_ffi'
    p.runtime_dependencies = ['ffi >= 0.2.0']
    # p.development_dependencies = ['rr', 'matchy', 'context']
  end
rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."

  desc 'No effect.'
  task :default do; end
end
