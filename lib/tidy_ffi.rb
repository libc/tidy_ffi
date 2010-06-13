require 'ffi'

module TidyFFI
  self.autoload :LibTidy, 'tidy_ffi/lib_tidy'
  self.autoload :Interface, 'tidy_ffi/interface'
end

require 'tidy_ffi/options_container'
require 'tidy_ffi/tidy'
require 'tidy_ffi/tidy_ffi_extensions'