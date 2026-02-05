module MailIso2022Jp
  module SubjectField
    def b_value_encode(string)
      encode64(string)
    end
  end
end
::Mail::SubjectField.prepend(::MailIso2022Jp::FieldWithIso2022JpEncoding)
::Mail::SubjectField.prepend(::MailIso2022Jp::SubjectField)
