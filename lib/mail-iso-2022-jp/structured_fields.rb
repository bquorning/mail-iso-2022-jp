# coding: utf-8

[
  ::Mail::FromField,
  ::Mail::SenderField,
  ::Mail::ToField,
  ::Mail::CcField,
  ::Mail::ReplyToField,
  ::Mail::ResentFromField,
  ::Mail::ResentSenderField,
  ::Mail::ResentToField,
  ::Mail::ResentCcField
].each do |field_class|
  field_class.prepend(::MailIso2022Jp::FieldWithIso2022JpEncoding)
end
