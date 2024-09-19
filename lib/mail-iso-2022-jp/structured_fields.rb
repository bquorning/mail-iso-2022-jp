# coding: utf-8

require 'mail'


module Mail
  superklass = Gem::Version.new(Mail::VERSION.version) >= Gem::Version.new("2.8.0") ? CommonAddressField : StructuredField

  class FromField < superklass
    include FieldWithIso2022JpEncoding
  end

  class SenderField < superklass
    include FieldWithIso2022JpEncoding
  end

  class ToField < superklass
    include FieldWithIso2022JpEncoding
  end

  class CcField < superklass
    include FieldWithIso2022JpEncoding
  end

  class ReplyToField < superklass
    include FieldWithIso2022JpEncoding
  end

  class ResentFromField < superklass
    include FieldWithIso2022JpEncoding
  end

  class ResentSenderField < superklass
    include FieldWithIso2022JpEncoding
  end

  class ResentToField < superklass
    include FieldWithIso2022JpEncoding
  end

  class ResentCcField < superklass
    include FieldWithIso2022JpEncoding
  end
end
