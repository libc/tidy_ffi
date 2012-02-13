module TidyFFI::TidyFFIExtensions #:nodoc:
  # Sets path to libtidy.{dylib,so}
  def library_path=(path)
    @libtidy_path = path
  end

  # Returns path to libtidy.{dylib,so}
  def library_path
    @libtidy_path ||= find_tidy
  end

  def find_tidy
    fnames = ['libtidy.dylib', 'libtidy.so']
    paths = []
    paths += ENV['LD_LIBRARY_PATH'].split(':') if ENV['LD_LIBRARY_PATH']
    paths += ENV['DYLD_LIBRARY_PATH'].split(':') if ENV['DYLD_LIBRARY_PATH']
    paths += ENV['PATH'].split(':').reject { |a| a['sbin'] }.map { |a| a.sub('/bin', '/lib') } if ENV['PATH']
    paths = ['/usr/lib', '/usr/local/lib'] if paths.size == 0
    paths.uniq.each do |path|
      fnames.each do |fname|
        library_path = File.join(path, fname)
        return library_path if File.exists? library_path
      end
    end
    raise TidyFFI::LibTidyNotInstalled, "Could not find libtidy"
    nil
  end
  private :find_tidy
end
TidyFFI.extend TidyFFI::TidyFFIExtensions
