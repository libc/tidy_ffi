class TidyFFI::OptionsContainer #:nodoc:
  
  def initialize(ops = nil)
    if ops
      @options = ops.to_hash!
    else
      @options = {}
    end
  end

  def to_hash!
    @options.dup
  end

  def merge_with_options(options)
    options.each do |key, val|
      key = key.intern unless Symbol === key
      validate_option(key, val)
      @options[key] = val
    end
  end

  def ==(obj)
    if obj.is_a?(Hash)
      @options == obj
    elsif obj.is_a?(OptionsContainer)
      obj == @options
    else
      false
    end
  end

  def clear!
    @options = {}
    self
  end

  def method_missing(method, *args)
    if method.to_s =~ /=$/
      key, val = method.to_s.sub(/=$/, '').intern, args.first
      validate_option(key, val)
      @options[key] = val
    else
      @options[method]
    end
  end

  # It's a kinda bad method: it uses TidyFFI::Interface.option_valid and TidyFFI::Tidy.validate_options?
  # Also it do second lookup into default options
  def validate_option(key, value)
    if TidyFFI::Tidy.validate_options? && !TidyFFI::Interface.option_valid?(key, value)
      if TidyFFI::Interface.default_options[key]
        raise TidyFFI::Tidy::InvalidOptionValue, "#{value} is not valid for #{key}"
      else
        raise TidyFFI::Tidy::InvalidOptionName, "#{key} is invalid option name"
      end
    end
  end

  class Proxy #:nodoc:
    attr_reader :options

    define_method :new do |*args|
      @obj.new(args.first, options.to_hash!.merge(args[1] || {}))
    end

    def clean(str, opts = {})
      @obj.clean(str, options.to_hash!.merge(opts))
    end

    def initialize(obj, options1, options2)
      @obj = obj
      @options = TidyFFI::OptionsContainer.new(options1)
      @options.merge_with_options(options2)
    end

    def with_options(options)
      Proxy.new(@obj, @options, options)
    end

    def clear!
      @options.clear!
      self
    end

    def method_missing(meth, *args)
      @obj.send(meth, *args)
    end
  end
end