require "base64"

module MailIso2022Jp
  module FieldWithIso2022JpEncoding
    def initialize(value = nil, charset = "utf-8")
      if charset.to_s.downcase == "iso-2022-jp"
        value = if value.is_a?(Array)
          value.map { |e| encode_with_iso_2022_jp(e, charset) }
        else
          encode_with_iso_2022_jp(value, charset)
        end
      end
      super
    end

    private

    def encode_with_iso_2022_jp(value, charset)
      value = MailIso2022Jp::Preprocessor.process(value)
      value = MailIso2022Jp.encoding_to_charset(value, charset)
      value.force_encoding("ascii-8bit")
      value = b_value_encode(value)
      value.force_encoding("ascii-8bit")
    end

    def encode_crlf(value)
      if charset.to_s.downcase == "iso-2022-jp"
        value.force_encoding("ascii-8bit")
      end
      super
    end

    def do_decode
      if charset.to_s.downcase == "iso-2022-jp"
        value
      else
        super
      end
    end

    def b_value_encode(string)
      string.split(" ").map do |s|
        if s =~ /\e/ || s == "\"" || start_with_specials?(s) || end_with_specials?(s)
          encode64(s)
        else
          s
        end
      end.join(" ")
    end

    def encode(value)
      if charset.to_s.downcase == "iso-2022-jp"
        value
      else
        super
      end
    end

    def encode64(string)
      if string.length > 0
        "=?ISO-2022-JP?B?#{Base64.encode64(string).delete("\n")}?="
      else
        string
      end
    end

    def preprocess(value)
      value = value.to_s.gsub(/#{WAVE_DASH}/o, FULLWIDTH_TILDE)
      value = value.to_s.gsub(/#{MINUS_SIGN}/o, FULLWIDTH_HYPHEN_MINUS)
      value = value.to_s.gsub(/#{EM_DASH}/o, HORIZONTAL_BAR)
      value.to_s.gsub(/#{DOUBLE_VERTICAL_LINE}/o, PARALLEL_TO)
    end

    def start_with_specials?(string)
      string =~ /\A[()<>\[\]:;@\\,."]+[a-zA-Z]+\Z/
    end

    def end_with_specials?(string)
      string =~ /\A[a-zA-Z]+[()<>\[\]:;@\\,."]+\Z/
    end
  end
end
