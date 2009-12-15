# Very low level interface to tidy

# This file must be lazy loaded!
class TidyFFI::LibTidy #:nodoc:
  extend FFI::Library
  ffi_lib TidyFFI.library_path

  attach_function :tidyReleaseDate, [], :string

  attach_function :tidyCreate, [], :pointer
  attach_function :tidyRelease, [:pointer], :void

  attach_function :tidyCleanAndRepair, [:pointer], :int
  attach_function :tidyRunDiagnostics, [:pointer], :int

  attach_function :tidyParseString, [:pointer, :string], :int

  attach_function :tidySaveBuffer, [:pointer, :pointer], :int

  attach_function :tidySetErrorBuffer, [:pointer, :pointer], :int

  attach_function :tidyBufInit, [:pointer], :void
  attach_function :tidyBufFree, [:pointer], :void

  attach_function :tidyGetOptionByName, [:pointer, :string], :pointer
  attach_function :tidyOptGetId, [:pointer], :int
  attach_function :tidyOptSetValue, [:pointer, :int, :string], :int

  # iterators
  attach_function :tidyGetOptionList, [:pointer], :pointer
  attach_function :tidyGetNextOption, [:pointer, :pointer], :pointer
  attach_function :tidyOptGetName, [:pointer], :string
  attach_function :tidyOptGetType, [:pointer], :int
  attach_function :tidyOptGetDefault, [:pointer], :string
  attach_function :tidyOptGetDefaultInt, [:pointer], :ulong
  attach_function :tidyOptGetDefaultBool, [:pointer], :int
  attach_function :tidyOptIsReadOnly, [:pointer], :int
  attach_function :tidyOptGetPickList, [:pointer], :pointer
  attach_function :tidyOptGetNextPick, [:pointer, :pointer], :string
  
  #types
  # /** Option data types
  # */
  # typedef enum
  # {
  #   TidyString,          /**< String */
  #   TidyInteger,         /**< Integer or enumeration */
  #   TidyBoolean          /**< Boolean flag */
  # } TidyOptionType;
  TIDY_OPTION_TYPE = [:string, :integer, :boolean].freeze
  
end

class TidyFFI::LibTidy::TidyBuf < FFI::Struct #:nodoc:
  layout :bp, :string,
         :size, :uint,
         :allocated, :uint,
         :next, :uint
end

class TidyFFI::LibTidy::TidyBufWithAllocator < FFI::Struct #:nodoc:
  layout :allocator, :pointer,
         :bp, :string,
         :size, :uint,
         :allocated, :uint,
         :next, :uint
end

