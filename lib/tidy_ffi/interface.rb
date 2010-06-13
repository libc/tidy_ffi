require 'date'

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

  def errors
    @error_buffer[:bp]
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
    LibTidy.tidyBufInit(buf)
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

  class <<self
    # Returns enumeration for opt.
    #
    # Some tidy options might try to trespass as integer, and in order to caught
    # perpertraitors we need to call tidyOptGetPickList
    def pick_list_for(opt)
      iterator = LibTidy.tidyOptGetPickList(opt)

      return nil if iterator.null?

      pick_list = []

      FFI::MemoryPointer.new(:pointer, 1) do |pointer|
        pointer.put_pointer(0, iterator)
        until iterator.null?
          pick_list << LibTidy.tidyOptGetNextPick(opt, pointer)
          iterator = pointer.get_pointer(0)
        end
      end

      pick_list
    end
    private :pick_list_for
    
    # Loads default options.
    def load_default_options
      return if @default_options

      doc = LibTidy.tidyCreate
      iterator = LibTidy.tidyGetOptionList(doc)

      @default_options = {}

      FFI::MemoryPointer.new(:pointer, 1) do |pointer|
        pointer.put_pointer(0, iterator)

        until iterator.null?
          opt = LibTidy.tidyGetNextOption(doc, pointer)

          option = {}

          option[:name] = LibTidy.tidyOptGetName(opt).gsub('-', '_').intern
          option[:readonly?] = LibTidy.tidyOptIsReadOnly(opt) != 0
          option[:type] = LibTidy::TIDY_OPTION_TYPE[LibTidy.tidyOptGetType(opt)]
          option[:default] = case option[:type]
          when :string
            (LibTidy.tidyOptGetDefault(opt) rescue "")
          when :integer
            if pick_list = pick_list_for(opt)
              option[:type] = :enum
              option[:values] = pick_list
              pick_list[LibTidy.tidyOptGetDefaultInt(opt)]
            else
              LibTidy.tidyOptGetDefaultInt(opt)
            end
          when :boolean
            LibTidy.tidyOptGetDefaultBool(opt) != 0
          end

          @default_options[option[:name]] = option

          iterator = pointer.get_pointer(0)
        end

      end
      @default_options.freeze
    ensure
      LibTidy.tidyRelease(doc)
    end
    private :load_default_options
  end

  # Returns a hash that represents default options for tidy. 
  # Key for hash is the option name, value is also a hash...
  # Possible values are:
  # * :type - either :string, :integer, :boolean or :enum
  # * :readonly?
  # * :default - default value of an option
  # * :values - possible values for :enum
  # * :name
  def self.default_options
    @default_options ||= load_default_options
  end
  
  # Returns true if value is valid for +option+ and false otherwise.
  def self.option_valid?(option, value)
    return false unless spec = default_options[option]
    
    case spec[:type]
    when :boolean
      true == value || false == value || value == 0 || value == 1 || %w(on off true false 0 1 yes no).include?(value.downcase)
    when :integer
      Integer === value || !!(value =~ /^\d+$/)
    when :enum
      if Integer === value
        !!spec[:values][value]
      else
        spec[:values].include?(value)
      end
    when :string
      String === value || Symbol === value
    end
  end
end