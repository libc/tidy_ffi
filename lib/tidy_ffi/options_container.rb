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
      @options[method.to_s.sub(/=$/, '').intern] = args.first
    else
      @options[method]
    end
  end
  
  class Proxy #:nodoc:
    attr_reader :options

    define_method :new do |*args|
      @obj.new(args.first, options.to_hash!.merge(args[1] || {}))
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