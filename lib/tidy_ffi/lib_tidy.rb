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

  attach_function :tidyBufFree, [:pointer], :void
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

