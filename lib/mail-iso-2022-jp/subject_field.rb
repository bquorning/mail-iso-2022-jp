# coding: utf-8

require 'mail'

::Mail::SubjectField.prepend(Mail::FieldWithIso2022JpEncoding)

module Mail
  superklass = Gem::Version.new(Mail::VERSION.version) >= Gem::Version.new("2.8.0") ? NamedUnstructuredField : UnstructuredField

  class SubjectField < superklass
    def b_value_encode(string)
      encode64(string)
    end
  end
end
