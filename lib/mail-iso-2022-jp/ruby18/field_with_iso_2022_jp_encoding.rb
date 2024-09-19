require 'mail'
require 'base64'
require 'nkf'

module Mail
  module FieldWithIso2022JpEncoding
    def self.prepended(base)
      base.include(Mail::CommonMethodsForField)
    end

    def initialize(value = nil, charset = 'utf-8')
      if charset.to_s.downcase == 'iso-2022-jp'
        if value.kind_of?(Array)
          value = value.map { |e| encode_with_iso_2022_jp(e) }
        else
          value = encode_with_iso_2022_jp(value)
        end
      end
      super(value, charset)
    end

    private

    def do_decode_with_iso_2022_jp_encoding
      if charset.to_s.downcase == 'iso-2022-jp'
        value
      else
        super
      end
    end

    def encode_with_iso_2022_jp(value)
      value = Mail::Preprocessor.process(value)
      value = NKF.nkf(NKF_OPTIONS, value)
      b_value_encode(value)
    end
  end
end
