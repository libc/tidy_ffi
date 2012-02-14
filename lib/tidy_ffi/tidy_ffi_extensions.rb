module TidyFFI::TidyFFIExtensions #:nodoc:
  # Sets and gets path to libtidy.{dylib,so}
  attr_accessor :library_path
end
TidyFFI.extend TidyFFI::TidyFFIExtensions
