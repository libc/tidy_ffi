module TidyFFI::TidyFFIExtensions #:nodoc:
  # Sets path to libtidy.{dylib,so}
  def library_path=(path)
    @libtidy_path = path
  end

  # Returns path to libtidy.{dylib,so}
  def library_path
    @libtidy_path ||= 'tidy'
  end
end
TidyFFI.extend TidyFFI::TidyFFIExtensions
