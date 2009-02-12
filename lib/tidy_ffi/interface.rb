# Low level interface to libtidy.
class TidyFFI::Interface
  LibTidy = TidyFFI::LibTidy

  # Returns a TidyFFI::Interface with initialized interface.
  def self.with_doc
    doc = LibTidy.tidyCreate
    nd = new(doc)
    nd.with_redirected_error_buffer { yield nd }
  ensure
    LibTidy.tidyRelease(doc)
  end

  def initialize(doc) #:nodoc:
    @doc = doc
  end

  # Apply options
  def apply_options(options)
    options.each do |key, value|
      k = key.to_s.gsub('_', '-')

      option = LibTidy.tidyGetOptionByName(@doc, k)
      raise ArgumentError, "don't know about option #{key}" if option.null?
      id = LibTidy.tidyOptGetId(option)
      raise ArgumentError, "can't setup option #{key} to #{value}" if LibTidy.tidyOptSetValue(@doc, id, value.to_s) == 0
    end
  end

  # Sets string to tidy
  def string=(str)
    LibTidy.tidyParseString(@doc, str)
  end

  # Cleans string
  def clean
    @output = nil
    LibTidy.tidyCleanAndRepair(@doc)
  end  
  alias :clean_and_repair :clean
  alias :repair :clean

  # Returns output from tidy library
  def output
    @output ||= begin
      with_buffer_pointer do |buf|
        LibTidy.tidySaveBuffer(@doc, buf)
        buf[:bp]
      end
    end
  end

  # Redirects error buffer
  def with_redirected_error_buffer
    with_buffer_pointer do |buf|
      @error_buffer = buf
      LibTidy.tidySetErrorBuffer(@doc, buf)
      yield
    end
  ensure
    @error_buffer = nil
  end

  # Yields block with new buffer
  def with_buffer_pointer
    buf = tidy_buf_object.new
    yield buf
  ensure
    LibTidy.tidyBufFree(buf)
  end

  def tidy_buf_object
    @tidy_buf_object ||= begin
      release_date = Date.parse(LibTidy.tidyReleaseDate) rescue nil
      if release_date && (release_date > Date.parse("Dec 29 2006"))
        TidyFFI::LibTidy::TidyBufWithAllocator
      else
        TidyFFI::LibTidy::TidyBuf
      end
    end
  end
  private :tidy_buf_object
end