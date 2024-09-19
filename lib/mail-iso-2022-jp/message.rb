# coding: utf-8

require 'mail'

# Patches for Mail::Message on Ruby 1.9.x or above
::Mail::Message.prepend(Module.new do
  def body=(value)
    if @charset.to_s.downcase == 'iso-2022-jp'
      if value.respond_to?(:encoding) && value.encoding.to_s != 'UTF-8'
        raise ::Mail::InvalidEncodingError.new(
          "The mail body is not encoded in UTF-8 but in #{value.encoding}")
      end
      value = Mail::Preprocessor.process(value)
    end
    super(value)
  end

  def process_body_raw
    if @charset.to_s.downcase == 'iso-2022-jp'
      @body_raw = Mail.encoding_to_charset(@body_raw, @charset)
    end
    super
  end

  def text_part=(msg = nil)
    if @charset.to_s.downcase == 'iso-2022-jp' && msg && msg.charset.nil?
      msg.charset = @charset
    end
    super(msg)
  end
end)
