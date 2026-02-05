# coding: utf-8

module MailIso2022Jp
  module Header
    def encoded
      buffer = String.new
      fields.each do |field|
        buffer << field.encoded rescue Encoding::CompatibilityError
      end
      buffer
    end
  end
end
::Mail::Header.prepend(::MailIso2022Jp::Header)
