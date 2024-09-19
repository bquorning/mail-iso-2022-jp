# coding: utf-8

require 'mail'

::Mail::Field.prepend(Module.new do
  def initialize(name, value = nil, charset = 'utf-8')
    if charset.to_s.downcase == 'iso-2022-jp' && value.kind_of?(String)
      unless [ 'UTF-8', 'US-ASCII' ].include?(value.encoding.to_s)
        raise ::Mail::InvalidEncodingError.new(
          "The '#{name}' field is not encoded in UTF-8 nor in US-ASCII but in #{value.encoding}")
      end
      charset = 'utf-8' if value.ascii_only?
    end
    super(name, value, charset)
  end
end)
