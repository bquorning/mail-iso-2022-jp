module MailIso2022Jp
  module Message
    def body=(value)
      if @charset.to_s.downcase == "iso-2022-jp"
        if value.respond_to?(:encoding) && value.encoding.to_s != "UTF-8"
          raise ::MailIso2022Jp::InvalidEncodingError.new(
            "The mail body is not encoded in UTF-8 but in #{value.encoding}"
          )
        end
        value = MailIso2022Jp::Preprocessor.process(value)
      end
      super
    end

    def process_body_raw
      if @charset.to_s.downcase == "iso-2022-jp"
        @body_raw = MailIso2022Jp.encoding_to_charset(@body_raw, @charset)
      end
      super
    end

    def text_part=(msg = nil)
      if @charset.to_s.downcase == "iso-2022-jp" && msg && msg.charset.nil?
        msg.charset = @charset
      end
      super
    end
  end
end
::Mail::Message.prepend(::MailIso2022Jp::Message)
