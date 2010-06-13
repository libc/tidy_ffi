require 'test/unit'

require 'rubygems'
require 'tidy_ffi'

require 'rr'
require 'matchy'
require 'context'

class Test::Unit::TestCase
  alias method_name name unless instance_methods.include?('method_name')
  include RR::Adapters::TestUnit unless instance_methods.include?('stub') || instance_methods.include?(:stub)
end