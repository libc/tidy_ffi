class TidyFFI::Tidy
  # Initialized object. str is a string to tidy, options is ignored for now :)
  def initialize(str, options = {})
    @string = str
    parse_options(options)
  end

  # Returns cleaned string
  def clean
    @clean ||= TidyFFI::Interface.with_doc do |doc|
      doc.string = @string
      doc.clean
      doc.output
    end
  end

  def parse_options(options)
  end
  private :parse_options
end