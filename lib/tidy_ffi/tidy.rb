# Clean and simple interface to Tidy
class TidyFFI::Tidy
  OptionsContainer = TidyFFI::OptionsContainer
  class InvalidOptionName < ArgumentError; end
  class InvalidOptionValue < ArgumentError; end

  #Initializing object.
  #
  #* str is a string to tidy
  #* options are options for tidy
  def initialize(str, options = {})
    @string = str
    @options = OptionsContainer.new(self.class.default_options)
    self.options = options
  end

  # Returns cleaned string
  def clean
    @clean ||= TidyFFI::Interface.with_doc do |doc|
      doc.apply_options(@options.to_hash!)
      doc.string = @string
      doc.clean
      @errors = doc.errors
      doc.output
    end
  end

  # Returns cleaned string
  def self.clean(str, options = {})
    new(str, options).clean
  end

  # Returns errors for string
  def errors
    @errors ||= begin
      clean
      @errors
    end
  end

  # Assigns options for tidy.
  # It merges options, not deletes old ones.
  #   tidy.options= {:wrap_asp => true}
  #   tidy.options= {:show_body_only => true}
  # Will send to tidy both options.
  def options=(options)
    @options.merge_with_options(options)
  end

  # Proxy for options. Supports set and get
  #
  #   tidy.options.show_body_only #=> nil
  #   tidy.options.show_body_only = true
  #   tidy.options.show_body_only #=> true
  def options
    @options
  end

  class <<self
    # Default options for tidy. Works just like options method
    def default_options
      @default_options ||= OptionsContainer.new
    end

    # Default options for tidy. Works just like options= method
    def default_options=(options)
      @default_options.merge_with_options(options)
    end

    # Returns a proxy class with options.
    # Example:
    #   TidyFFI::Tidy.with_options(:show_body_only => true).with_options(:wrap_asp => true).new('test)
    def with_options(options)
      OptionsContainer::Proxy.new(self, @default_options, options)
    end

    # When true it validates name and option type (default is true).
    def validate_options?
      @validate_options != false
    end
    attr_writer :validate_options
  end
end