module MailIso2022Jp
  module Body
    def initialize(string = "")
      if string.respond_to?(:encoding) && string.encoding.to_s == "ISO-2022-JP"
        string.force_encoding("US-ASCII")
      end
      super
    end
  end
end
::Mail::Body.prepend(::MailIso2022Jp::Body)
