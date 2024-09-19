# coding: utf-8

require 'mail'

::Mail::FromField.prepend(Mail::FieldWithIso2022JpEncoding)
::Mail::SenderField.prepend(Mail::FieldWithIso2022JpEncoding)
::Mail::ToField.prepend(Mail::FieldWithIso2022JpEncoding)
::Mail::CcField.prepend(Mail::FieldWithIso2022JpEncoding)
::Mail::ReplyToField.prepend(Mail::FieldWithIso2022JpEncoding)
::Mail::ResentFromField.prepend(Mail::FieldWithIso2022JpEncoding)
::Mail::ResentSenderField.prepend(Mail::FieldWithIso2022JpEncoding)
::Mail::ResentToField.prepend(Mail::FieldWithIso2022JpEncoding)
::Mail::ResentCcField.prepend(Mail::FieldWithIso2022JpEncoding)
